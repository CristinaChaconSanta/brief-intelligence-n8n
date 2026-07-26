# Brief Intelligence System - n8n Workflow

## 📋 Descripción del Proyecto

El **Brief Intelligence System** es un workflow completo de automatización para agencias de marketing que procesa briefs de clientes automáticamente utilizando IA, los valida, genera presentaciones y gestiona el flujo de aprobación hasta la creación de proyectos en sistemas de gestión.

### 🎯 Características Principales

- **Recepción Multi-Canal**: Telegram y Gmail
- **Procesamiento IA**: Extracción inteligente con LLM (Gemini/OpenAI)
- **Validación QA**: Agente de calidad automático
- **Base de Datos**: Supabase con búsqueda vectorial
- **Presentaciones**: Google Slides automáticas
- **Workflow de Aprobación**: Email/Slack con botones
- **Gestión de Proyectos**: Integración con COR
- **Notificaciones**: Emails personalizados por equipo

## 🏗️ Arquitectura del Sistema

```
📥 Input (Telegram/Gmail)
    ↓
🔄 Procesamiento (Audio→Texto, PDF→Texto)
    ↓
🤖 Extracción LLM (Gemini/OpenAI)
    ↓
✅ Validación QA (Agente IA)
    ↓
💾 Supabase (Base de datos + Vector DB)
    ↓
📊 Google Slides (Presentación automática)
    ↓
⏸️ Aprobación Humana (Email/Slack)
    ↓
🔀 Decisión (Aprobar/Modificar/Rechazar)
    ↓
🚀 COR (Creación proyecto) + 📧 Notificar Equipos
```

## 📁 Estructura del Proyecto

```
brief-intelligence-n8n/
├── workflows/
│   └── brief-intelligence-main.json     # Workflow principal de n8n
├── config/
│   ├── llm-config.json                  # Configuración LLM modular
│   ├── supabase-config.json             # Configuración Supabase
│   ├── apis-config.json                 # Configuración APIs
│   └── .env.example                     # Variables de entorno
├── prompts/
│   ├── extractor-prompt.txt             # Prompt extracción IA
│   ├── validator-prompt.txt             # Prompt validación QA
│   └── change-processor-prompt.txt      # Prompt procesar cambios
├── schemas/
│   ├── brief-schema.json                # Schema JSON briefs
│   └── validation-schema.json           # Schema validación
├── supabase/
│   └── schema.sql                       # Schema base de datos
├── templates/
│   ├── email-approval.html              # Email aprobación director
│   ├── email-team-notification.html     # Email equipos asignados
│   ├── slack-approval.json              # Slack aprobación director
│   └── slack-team-notification.json     # Slack equipos asignados
└── README.md                            # Este archivo
```

## 🚀 Instalación y Setup

### 1. Prerequisitos

- **n8n** instalado y funcionando
- **Supabase** proyecto creado
- **Google Cloud** proyecto con APIs habilitadas
- **Telegram Bot** creado
- **Slack App** configurada
- **COR** o sistema de gestión de proyectos

### 2. Configurar Supabase

```bash
# 1. Crear proyecto en Supabase
# 2. Habilitar extensión pgvector
# 3. Ejecutar schema.sql
```

```sql
-- En el SQL Editor de Supabase:
-- Copiar y ejecutar todo el contenido de supabase/schema.sql
```

### 3. Configurar Variables de Entorno

```bash
# Copiar archivo de ejemplo
cp config/.env.example .env

# Editar .env con tus credenciales
nano .env
```

**Variables críticas a configurar:**

```bash
# LLM APIs
GEMINI_API_KEY=tu-api-key-gemini
OPENAI_API_KEY=tu-api-key-openai

# Supabase
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key
SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key

# Gmail OAuth2
GMAIL_CLIENT_ID=tu-gmail-client-id
GMAIL_CLIENT_SECRET=tu-gmail-client-secret
GMAIL_REFRESH_TOKEN=tu-refresh-token

# Y todas las demás según .env.example
```

### 4. Configurar Google Cloud

1. **Crear proyecto en Google Cloud Console**
2. **Habilitar APIs necesarias:**
   - Gmail API
   - Google Slides API
   - Google Drive API

3. **Crear credenciales OAuth2**
4. **Obtener tokens de refresh**

### 5. Configurar Telegram Bot

```bash
# 1. Crear bot con @BotFather
# 2. Obtener token del bot
# 3. Configurar webhook en n8n
# 4. Añadir bot a chats autorizados
```

### 6. Configurar Slack

1. **Crear Slack App**
2. **Configurar Bot Token Scopes:**
   - `chat:write`
   - `channels:read`
   - `users:read`
3. **Instalar app en workspace**
4. **Obtener Bot User OAuth Token**

### 7. Importar Workflow a n8n

```bash
# 1. Ir a n8n interface
# 2. Import > From File
# 3. Seleccionar workflows/brief-intelligence-main.json
# 4. Configurar credenciales para cada nodo
```

### 8. Configurar Credenciales en n8n

Crear las siguientes credenciales en n8n:

- **Telegram Bot API** → `telegram-bot-credentials`
- **Gmail OAuth2** → `gmail-oauth-credentials`  
- **Google Slides OAuth2** → `google-slides-oauth`
- **Slack OAuth2** → `slack-oauth-credentials`
- **OpenAI API** → `openai-credentials`
- **HTTP Header Auth** → Para Supabase y COR

## 🔄 Cómo Cambiar de Gemini a OpenAI

El sistema está diseñado para cambiar fácilmente entre providers de LLM:

### Opción 1: Editar Configuración

```json
// En config/llm-config.json
{
  "active_provider": "openai",  // Cambiar de "gemini" a "openai"
  "providers": {
    // ... resto de la configuración
  }
}
```

### Opción 2: Variable de Entorno

```bash
# En .env
LLM_ACTIVE_PROVIDER=openai
```

### Opción 3: Modificar en Runtime

El workflow leerá automáticamente la configuración sin necesidad de reiniciar.

## 📊 Explicación de las Sticky Notes

El workflow incluye **Sticky Notes** visuales con códigos de colores:

- **🟦 Azul**: Entrada/Recepción (Fases 1-2)
- **🟨 Amarillo**: Procesamiento con IA (Fases 3-4)  
- **🟩 Verde**: Almacenamiento/Base de datos (Fase 5)
- **🟪 Morado**: Generación de documentos (Fase 6)
- **🟧 Naranja**: Aprobación humana - PAUSA (Fase 7)
- **🟥 Rojo**: Decisiones y branches (Fase 8)
- **⬜ Gris**: Salidas/Notificaciones (Fases 9-11)

### Fases del Workflow

1. **📥 RECEPCIÓN**: Telegram + Gmail triggers
2. **🔄 PROCESAMIENTO**: Detección tipo + transcripción
3. **🤖 EXTRACCIÓN IA**: LLM extrae datos estructurados
4. **✅ VALIDACIÓN QA**: Agente valida completitud
5. **💾 SUPABASE**: Almacena en base de datos
6. **📊 PRESENTACIÓN**: Genera Google Slides
7. **⏸️ APROBACIÓN**: Email/Slack - WORKFLOW SE PAUSA
8. **🔀 DECISIÓN**: Switch según respuesta director
9. **🚀 PROYECTO COR**: Crea proyecto automáticamente
10. **📧 NOTIFICAR EQUIPOS**: Emails personalizados por rol

## 📧 Templates de Email y Slack

### Email de Aprobación (Director)

- **HTML responsivo** con diseño profesional
- **Métricas clave** destacadas
- **Botones de acción** (Aprobar/Modificar/Rechazar)
- **Información completa** del brief
- **Evaluación de riesgos** automática

### Email de Asignación (Equipos)

- **Personalizado por rol** del equipo
- **Timeline específico** y responsabilidades
- **Enlaces directos** a COR y recursos
- **Información contextual** del proyecto
- **Contactos del PM y AM**

### Slack Notifications

- **Block Kit** para interacción rica
- **Menciones automáticas** a equipos
- **Botones de acción** directos
- **Información resumida** y organizada

## 🔧 Configuración Avanzada

### Personalizar Prompt de Extracción

```txt
# Editar prompts/extractor-prompt.txt
# Ajustar según necesidades específicas de Zelva
# Mantener formato JSON de salida
```

### Configurar Validación QA

```txt
# Editar prompts/validator-prompt.txt
# Ajustar criterios de calidad
# Modificar scoring system
```

### Mapeo de Equipos

```json
// En el nodo "Identify & Prepare Teams"
const equipoMapping = {
  'equipo_creativo': {
    emails: ['creativo@zelva.com'],
    responsibilities: [...],
    // Personalizar por equipo
  }
}
```

## 🐛 Troubleshooting

### Problemas Comunes

1. **LLM no responde**
   - Verificar API keys en variables de entorno
   - Comprobar quotas y límites de API
   - Revisar formato de prompts

2. **Supabase connection error**
   - Verificar URL y keys de Supabase
   - Comprobar que RLS policies están configuradas
   - Verificar que pgvector está habilitado

3. **Emails no se envían**
   - Verificar OAuth2 tokens de Gmail
   - Comprobar que templates tienen formato correcto
   - Revisar límites de Gmail API

4. **Telegram no recibe**
   - Verificar bot token
   - Comprobar que webhook está activo
   - Revisar IDs de chats autorizados

5. **Slack no notifica**
   - Verificar bot token y permisos
   - Comprobar que bot está en canales
   - Revisar formato de Block Kit

### Logs y Debugging

```sql
-- Ver logs del sistema en Supabase
SELECT * FROM system_logs 
WHERE level = 'ERROR' 
ORDER BY created_at DESC;

-- Ver briefs con errores
SELECT * FROM briefs 
WHERE validation_passed = false;
```

### Reiniciar Workflow

```bash
# Si el workflow se queda colgado:
# 1. Ir a n8n > Executions
# 2. Cancelar ejecuciones pendientes
# 3. Revisar datos en Wait nodes
# 4. Reiniciar desde el punto apropiado
```

## 📈 Monitoreo y Métricas

### Métricas Clave

```sql
-- Briefs procesados por día
SELECT DATE(created_at) as fecha, 
       COUNT(*) as briefs_procesados,
       AVG(validation_score) as score_promedio
FROM briefs 
GROUP BY DATE(created_at)
ORDER BY fecha DESC;

-- Tiempo de procesamiento
SELECT AVG(processing_duration_ms) as tiempo_promedio_ms
FROM briefs 
WHERE created_at > NOW() - INTERVAL '7 days';

-- Tasa de aprobación
SELECT 
  COUNT(CASE WHEN status = 'aprobado' THEN 1 END) * 100.0 / COUNT(*) as tasa_aprobacion
FROM briefs 
WHERE status IN ('aprobado', 'rechazado');
```

### Dashboard Supabase

Crear dashboard con:
- Total briefs procesados
- Tiempo promedio de procesamiento  
- Score de validación promedio
- Tasa de aprobación/rechazo
- Distribución por fuente (Telegram/Gmail)
- Proyectos creados en COR

## 🔐 Seguridad

### Tokens de Webhook

- Tokens únicos generados por brief
- Validación en base de datos antes de procesar
- Expiración automática después de 48h

### Variables Sensibles

```bash
# NUNCA commits estos valores:
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=AI...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Usar siempre variables de entorno
```

### RLS Policies

```sql
-- Row Level Security habilitado en todas las tablas
-- Solo usuarios autenticados pueden acceder
-- Políticas específicas por rol si es necesario
```

## 🚀 Deployment

### Producción

1. **Configurar dominio y SSL**
2. **Variables de entorno en servidor**
3. **Backup automático de Supabase**
4. **Monitoring con logs**
5. **Rate limiting en APIs**

### Staging Environment

```bash
# Variables específicas para staging
SUPABASE_URL=https://staging-project.supabase.co
N8N_INSTANCE_URL=https://staging-n8n.zelva.com
DIRECTOR_EMAIL=test-director@zelva.com
```

## 📞 Soporte

### Contactos

- **Técnico**: soporte@zelva.com
- **Proyecto**: proyectos@zelva.com
- **Issues**: [GitHub Issues](https://github.com/zelva/brief-intelligence)

### Recursos Adicionales

- [Documentación n8n](https://docs.n8n.io)
- [Supabase Docs](https://supabase.com/docs)
- [Gemini API Reference](https://ai.google.dev/docs)
- [OpenAI API Reference](https://platform.openai.com/docs)

## 🔄 Updates y Mantenimiento

### Actualizaciones Regulares

1. **Actualizar prompts** según feedback de usuarios
2. **Optimizar validation criteria** basado en métricas
3. **Mejorar templates** de emails y Slack
4. **Añadir nuevos servicios** al mapeo de equipos

### Backup y Restore

```sql
-- Backup regular de briefs
pg_dump -h db.project.supabase.co -U postgres -t briefs > backup_briefs.sql

-- Backup de configuración
cp -r config/ backup/config-$(date +%Y%m%d)/
```

---

## 🎉 ¡Listo para usar!

El Brief Intelligence System está ahora completamente configurado y listo para automatizar el procesamiento de briefs en Zelva. 

**Próximos pasos:**
1. Importar workflow a n8n ✅
2. Configurar todas las credenciales ✅  
3. Hacer prueba con brief de ejemplo ✅
4. Ajustar templates según branding ✅
5. Capacitar equipo en el nuevo sistema ✅

**¡Disfruta la automatización inteligente! 🚀**