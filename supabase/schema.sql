-- Brief Intelligence System - Supabase Schema
-- Requiere extensión pgvector para embeddings

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Crear tipos de datos personalizados
CREATE TYPE brief_status AS ENUM (
    'pendiente_procesamiento',
    'pendiente_aprobacion',
    'aprobado',
    'rechazado',
    'modificado',
    'archivado'
);

CREATE TYPE decision_type AS ENUM (
    'aprobar',
    'modificar', 
    'rechazar'
);

CREATE TYPE input_source AS ENUM (
    'telegram',
    'gmail',
    'manual'
);

-- Tabla principal de briefs
CREATE TABLE briefs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Metadatos básicos
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status brief_status DEFAULT 'pendiente_procesamiento',
    source input_source NOT NULL,
    source_message_id VARCHAR(255),
    
    -- Contenido original
    original_text TEXT NOT NULL,
    original_files JSONB DEFAULT '[]'::jsonb, -- URLs de archivos originales
    
    -- Información extraída por LLM
    extracted_data JSONB, -- Datos estructurados extraídos
    
    -- Cliente y proyecto
    cliente VARCHAR(255),
    nombre_proyecto VARCHAR(255),
    responsable_cliente VARCHAR(255),
    email_responsable VARCHAR(255),
    telefono_responsable VARCHAR(20),
    
    -- Objetivos y contexto
    objetivo TEXT,
    desafio TEXT,
    audiencia_target TEXT,
    contexto_marca TEXT,
    
    -- Entregables y servicios
    servicios_requeridos JSONB DEFAULT '[]'::jsonb,
    entregables JSONB DEFAULT '[]'::jsonb,
    
    -- Tiempos y presupuesto
    fecha_inicio DATE,
    fecha_entrega DATE,
    presupuesto_estimado NUMERIC(12,2),
    moneda VARCHAR(3) DEFAULT 'EUR',
    
    -- Validación QA
    validation_passed BOOLEAN,
    validation_score NUMERIC(3,2), -- 0.00 - 1.00
    validation_details JSONB,
    missing_fields TEXT[],
    qa_warnings TEXT[],
    qa_recommendations TEXT[],
    
    -- Presentación generada
    presentation_url VARCHAR(500),
    presentation_id VARCHAR(255),
    
    -- Proyecto COR
    cor_project_id VARCHAR(255),
    cor_project_url VARCHAR(500),
    
    -- Equipos asignados
    equipos_asignados JSONB DEFAULT '[]'::jsonb,
    
    -- Vector embedding para búsqueda semántica
    embedding vector(1536), -- Dimensión típica de OpenAI/Gemini embeddings
    
    -- Metadatos adicionales
    processing_duration_ms INTEGER,
    llm_provider VARCHAR(50),
    tokens_used INTEGER,
    
    -- Índices para optimización
    CONSTRAINT valid_validation_score CHECK (validation_score IS NULL OR (validation_score >= 0 AND validation_score <= 1))
);

-- Tabla de historial de cambios
CREATE TABLE brief_cambios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brief_id UUID NOT NULL REFERENCES briefs(id) ON DELETE CASCADE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    changed_by VARCHAR(255), -- Email del usuario que hizo el cambio
    change_reason TEXT,
    
    -- Datos antes y después del cambio
    data_before JSONB,
    data_after JSONB,
    changes_summary TEXT,
    
    -- Regeneración de documentos
    presentation_regenerated BOOLEAN DEFAULT FALSE,
    new_presentation_url VARCHAR(500)
);

-- Tabla de aprobaciones/decisiones
CREATE TABLE brief_aprobaciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brief_id UUID NOT NULL REFERENCES briefs(id) ON DELETE CASCADE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    decision decision_type NOT NULL,
    approved_by VARCHAR(255) NOT NULL, -- Email del director/decisor
    
    -- Comentarios y justificación
    comentarios TEXT,
    motivo_rechazo TEXT,
    cambios_solicitados TEXT,
    
    -- Token de seguridad para webhooks
    security_token VARCHAR(255) NOT NULL UNIQUE,
    
    -- Metadatos de la decisión
    decision_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    webhook_source VARCHAR(100), -- 'email', 'slack', 'manual'
    ip_address INET,
    user_agent TEXT
);

-- Tabla de logs del sistema
CREATE TABLE system_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brief_id UUID REFERENCES briefs(id) ON DELETE SET NULL,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    level VARCHAR(20) NOT NULL, -- 'INFO', 'WARNING', 'ERROR', 'DEBUG'
    operation VARCHAR(100) NOT NULL, -- 'llm_extraction', 'validation', 'email_sent', etc.
    
    message TEXT NOT NULL,
    details JSONB DEFAULT '{}'::jsonb,
    
    -- Contexto técnico
    execution_time_ms INTEGER,
    error_code VARCHAR(50),
    stack_trace TEXT
);

-- Tabla de configuración del sistema
CREATE TABLE system_config (
    key VARCHAR(100) PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by VARCHAR(255)
);

-- Índices para optimización de queries
CREATE INDEX idx_briefs_status ON briefs(status);
CREATE INDEX idx_briefs_created_at ON briefs(created_at DESC);
CREATE INDEX idx_briefs_cliente ON briefs(cliente);
CREATE INDEX idx_briefs_source ON briefs(source);
CREATE INDEX idx_briefs_fecha_entrega ON briefs(fecha_entrega);

-- Índices para búsqueda vectorial
CREATE INDEX idx_briefs_embedding ON briefs USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- Índices para tablas relacionadas
CREATE INDEX idx_cambios_brief_id ON brief_cambios(brief_id);
CREATE INDEX idx_cambios_created_at ON brief_cambios(created_at DESC);

CREATE INDEX idx_aprobaciones_brief_id ON brief_aprobaciones(brief_id);
CREATE INDEX idx_aprobaciones_security_token ON brief_aprobaciones(security_token);
CREATE INDEX idx_aprobaciones_decision ON brief_aprobaciones(decision);

CREATE INDEX idx_logs_brief_id ON system_logs(brief_id);
CREATE INDEX idx_logs_level ON system_logs(level);
CREATE INDEX idx_logs_created_at ON system_logs(created_at DESC);

-- Triggers para updated_at automático
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_briefs_updated_at 
    BEFORE UPDATE ON briefs 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_config_updated_at 
    BEFORE UPDATE ON system_config 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Función para búsqueda semántica
CREATE OR REPLACE FUNCTION search_briefs_by_similarity(
    query_embedding vector(1536),
    match_threshold float DEFAULT 0.8,
    match_count int DEFAULT 10
)
RETURNS TABLE (
    brief_id UUID,
    cliente VARCHAR(255),
    nombre_proyecto VARCHAR(255),
    similarity float
) LANGUAGE sql STABLE AS $$
    SELECT 
        id as brief_id,
        cliente,
        nombre_proyecto,
        1 - (embedding <=> query_embedding) as similarity
    FROM briefs
    WHERE 1 - (embedding <=> query_embedding) > match_threshold
    ORDER BY embedding <=> query_embedding
    LIMIT match_count;
$$;

-- Función para generar tokens de seguridad
CREATE OR REPLACE FUNCTION generate_security_token()
RETURNS VARCHAR(255) AS $$
BEGIN
    RETURN encode(gen_random_bytes(32), 'hex');
END;
$$ LANGUAGE plpgsql;

-- Row Level Security (RLS) - Opcional para multi-tenancy
ALTER TABLE briefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE brief_cambios ENABLE ROW LEVEL SECURITY;
ALTER TABLE brief_aprobaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_logs ENABLE ROW LEVEL SECURITY;

-- Política básica (ajustar según necesidades)
CREATE POLICY "Permitir todo para usuarios autenticados" ON briefs
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir todo para usuarios autenticados" ON brief_cambios
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir todo para usuarios autenticados" ON brief_aprobaciones
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir todo para usuarios autenticados" ON system_logs
    FOR ALL USING (auth.role() = 'authenticated');

-- Datos de configuración inicial
INSERT INTO system_config (key, value, description) VALUES 
    ('llm_provider', '"gemini"', 'Proveedor de LLM activo'),
    ('webhook_base_url', '"https://your-n8n-instance.com/webhook"', 'URL base para webhooks'),
    ('cor_api_url', '"https://your-cor-instance.com/api"', 'URL de la API de COR'),
    ('email_from', '"briefs@zelva.com"', 'Email remitente para notificaciones'),
    ('slack_channel_proyectos', '"#proyectos"', 'Canal de Slack para notificaciones'),
    ('equipos_emails', '{"creativo": ["creativo@zelva.com"], "medios": ["medios@zelva.com"], "diseno": ["diseno@zelva.com"]}', 'Emails de equipos para asignación'),
    ('director_email', '"director@zelva.com"', 'Email del director para aprobaciones'),
    ('max_brief_age_days', '30', 'Días máximos antes de archivar briefs automáticamente');

-- Crear vista para reportes
CREATE VIEW briefs_summary AS
SELECT 
    b.id,
    b.cliente,
    b.nombre_proyecto,
    b.status,
    b.source,
    b.created_at,
    b.fecha_entrega,
    b.presupuesto_estimado,
    b.validation_score,
    CASE 
        WHEN a.decision IS NOT NULL THEN a.decision::TEXT
        ELSE 'pendiente'
    END as ultima_decision,
    a.approved_by,
    a.created_at as fecha_decision,
    array_length(b.servicios_requeridos::jsonb, 1) as num_servicios,
    b.cor_project_id IS NOT NULL as proyecto_creado_cor
FROM briefs b
LEFT JOIN brief_aprobaciones a ON b.id = a.brief_id 
    AND a.created_at = (
        SELECT MAX(created_at) 
        FROM brief_aprobaciones 
        WHERE brief_id = b.id
    );

-- Comentarios para documentación
COMMENT ON TABLE briefs IS 'Tabla principal que almacena todos los briefs recibidos y procesados';
COMMENT ON TABLE brief_cambios IS 'Historial de cambios realizados a los briefs';
COMMENT ON TABLE brief_aprobaciones IS 'Decisiones de aprobación, modificación o rechazo de briefs';
COMMENT ON TABLE system_logs IS 'Logs del sistema para debugging y auditoría';
COMMENT ON TABLE system_config IS 'Configuración del sistema';

COMMENT ON COLUMN briefs.embedding IS 'Vector embedding para búsqueda semántica usando pgvector';
COMMENT ON COLUMN brief_aprobaciones.security_token IS 'Token único para validar webhooks de aprobación';
COMMENT ON FUNCTION search_briefs_by_similarity IS 'Función para buscar briefs similares usando embeddings vectoriales';