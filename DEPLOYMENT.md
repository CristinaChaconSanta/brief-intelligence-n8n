# Brief Intelligence System - Guía de Deployment

## 🚀 Deployment en Producción

Esta guía te llevará paso a paso para deployar el Brief Intelligence System en un entorno de producción.

## ✅ Pre-requisitos

### Servicios y Cuentas Necesarias

- [ ] **n8n Cloud** o instancia self-hosted
- [ ] **Supabase** proyecto creado
- [ ] **Google Cloud Platform** con APIs habilitadas
- [ ] **Telegram Bot** configurado
- [ ] **Slack Workspace** con app instalada
- [ ] **COR** o sistema de gestión accesible
- [ ] **Dominio propio** (recomendado)

### Conocimientos Técnicos

- [ ] Configuración básica de n8n
- [ ] Manejo de variables de entorno
- [ ] SQL básico para Supabase
- [ ] OAuth2 flows (Google, Slack)

## 🔧 Paso 1: Configurar Supabase

### 1.1 Crear Proyecto

```bash
# 1. Ir a https://supabase.com
# 2. Crear nuevo proyecto
# 3. Anotar URL y API Keys
```

### 1.2 Habilitar Extensiones

```sql
-- En SQL Editor de Supabase
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";
```

### 1.3 Ejecutar Schema

```sql
-- Copiar y ejecutar supabase/schema.sql completo
-- Verificar que todas las tablas se crearon correctamente
```

### 1.4 Configurar Storage

```sql
-- Crear bucket para attachments
INSERT INTO storage.buckets (id, name, public) VALUES ('brief-attachments', 'brief-attachments', false);

-- Configurar políticas RLS
CREATE POLICY "Authenticated users can upload" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'brief-attachments');
```

## 🔧 Paso 2: Google Cloud Platform

### 2.1 Crear Proyecto

```bash
# 1. Ir a Google Cloud Console
# 2. Crear nuevo proyecto: "brief-intelligence-prod"
# 3. Anotar Project ID
```

### 2.2 Habilitar APIs

```bash
# En Google Cloud Console > APIs & Services
- Gmail API ✅
- Google Slides API ✅  
- Google Drive API ✅
```

### 2.3 Crear Credenciales OAuth2

```bash
# 1. APIs & Services > Credentials
# 2. Create Credentials > OAuth 2.0 Client IDs
# 3. Application type: Web application
# 4. Authorized redirect URIs:
#    - https://your-n8n-instance.com/rest/oauth2-credential/callback
# 5. Download JSON credentials
```

### 2.4 Obtener Refresh Tokens

Usar herramienta como OAuth 2.0 Playground:

```bash
# 1. Ir a https://developers.google.com/oauthplayground
# 2. Configurar con tus credenciales
# 3. Obtener refresh tokens para:
#    - Gmail API
#    - Google Slides API
```

## 🔧 Paso 3: Telegram Bot

### 3.1 Crear Bot

```bash
# 1. Hablar con @BotFather en Telegram
# 2. /newbot
# 3. Seguir instrucciones
# 4. Anotar token del bot
```

### 3.2 Configurar Comandos

```bash
# En chat con @BotFather
/setcommands

# Añadir:
brief - Enviar nuevo brief
status - Consultar estado de briefs  
help - Ayuda del sistema
```

### 3.3 Obtener Chat IDs

```bash
# Añadir bot a grupos autorizados
# Usar bot como @userinfobot para obtener Chat IDs
```

## 🔧 Paso 4: Slack App

### 4.1 Crear Slack App

```bash
# 1. Ir a https://api.slack.com/apps
# 2. Create New App > From scratch
# 3. Name: "Brief Intelligence Bot"
# 4. Workspace: Tu workspace
```

### 4.2 Configurar Permisos

```bash
# OAuth & Permissions > Scopes > Bot Token Scopes:
- channels:read
- chat:write
- chat:write.public
- users:read
- files:write
```

### 4.3 Instalar App

```bash
# 1. Install App to Workspace
# 2. Anotar Bot User OAuth Token
# 3. Invitar bot a canales necesarios:
#    - #brief-approvals  
#    - #proyectos
#    - #equipo-creativo
#    - #equipo-medios
#    - #equipo-diseno
```

## 🔧 Paso 5: Configurar n8n

### 5.1 Setup Instancia

```bash
# Opción A: n8n Cloud
# 1. Crear cuenta en https://n8n.cloud
# 2. Crear nueva instancia

# Opción B: Self-hosted
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e WEBHOOK_URL="https://your-domain.com/" \
  -v n8n_data:/home/node/.n8n \
  n8nio/n8n
```

### 5.2 Configurar Variables de Entorno

En n8n Settings > Environment variables:

```bash
GEMINI_API_KEY=your-key-here
OPENAI_API_KEY=your-key-here  
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
# ... (ver .env.example para lista completa)
```

### 5.3 Crear Credenciales

En n8n Credentials, crear:

```bash
# 1. Telegram Bot API
Name: telegram-bot-credentials
Token: tu-bot-token

# 2. Gmail OAuth2  
Name: gmail-oauth-credentials
Client ID: tu-gmail-client-id
Client Secret: tu-gmail-client-secret
Refresh Token: tu-refresh-token

# 3. Google Slides OAuth2
Name: google-slides-oauth
Client ID: tu-google-client-id
Client Secret: tu-google-client-secret  
Refresh Token: tu-refresh-token

# 4. Slack OAuth2
Name: slack-oauth-credentials
Bot Token: tu-slack-bot-token

# 5. OpenAI API
Name: openai-credentials  
API Key: tu-openai-key
```

### 5.4 Importar Workflow

```bash
# 1. En n8n interface
# 2. Workflows > Import from File
# 3. Seleccionar: workflows/brief-intelligence-main.json
# 4. Asignar credenciales a cada nodo
# 5. Activar workflow
```

## 🔧 Paso 6: Configurar COR Integration

### 6.1 API Access

```bash
# 1. Obtener API token de COR
# 2. Documentar endpoints disponibles
# 3. Configurar en variables de entorno:
COR_API_URL=https://your-cor-instance.com/api
COR_API_TOKEN=your-api-token
```

### 6.2 Test Connection

```bash
# Hacer request de prueba:
curl -H "Authorization: Bearer $COR_API_TOKEN" \
     -H "Content-Type: application/json" \
     "$COR_API_URL/projects"
```

## 🧪 Paso 7: Testing

### 7.1 Ejecutar Validador

```bash
cd scripts/
npm install
npm run validate
```

### 7.2 Test Manual

```bash
# 1. Enviar brief de prueba por Telegram
# 2. Verificar procesamiento en n8n
# 3. Comprobar datos en Supabase  
# 4. Verificar email de aprobación
# 5. Probar flujo completo
```

### 7.3 Test de Carga

```bash
# Enviar múltiples briefs simultáneamente
# Verificar que el sistema maneja la carga
# Monitorear performance en Supabase
```

## 📊 Paso 8: Monitoreo

### 8.1 Logs en n8n

```bash
# Configurar logs detallados
# Revisar Executions regulares
# Setup alertas para fallos
```

### 8.2 Monitoreo Supabase

```sql
-- Query para monitorear rendimiento
SELECT 
  DATE(created_at) as fecha,
  COUNT(*) as briefs_procesados,
  AVG(processing_duration_ms) as tiempo_promedio,
  AVG(validation_score) as score_promedio
FROM briefs 
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY DATE(created_at)
ORDER BY fecha DESC;
```

### 8.3 Alertas

```bash
# Setup alertas para:
- Errores de API (> 5% rate)  
- Timeouts en processing (> 30s)
- Fallos de validación (> 20%)
- Storage casi lleno (> 80%)
```

## 🚨 Paso 9: Backup y Recovery

### 9.1 Backup Supabase

```bash
# Setup backup diario automático
pg_dump -h db.project.supabase.co \
        -U postgres \
        -d postgres \
        > backup-$(date +%Y%m%d).sql
```

### 9.2 Backup n8n

```bash
# Exportar workflows regularmente
# Backup de credenciales (encriptado)
# Backup de variables de entorno
```

### 9.3 Recovery Plan

```bash
# Documentar pasos para:
1. Restore base de datos
2. Reconfigurar n8n  
3. Restaurar credenciales
4. Verificar integrations
5. Test funcional completo
```

## 🔒 Paso 10: Seguridad

### 10.1 Secrets Management

```bash
# Nunca hardcodear secrets
# Usar variables de entorno
# Rotar tokens regularmente
# Audit access logs
```

### 10.2 Network Security

```bash
# HTTPS obligatorio
# Rate limiting en webhooks
# IP whitelisting si es posible
# VPN para acceso admin
```

### 10.3 Data Protection

```bash
# Encriptar datos sensibles
# GDPR compliance
# Data retention policies
# Access logging
```

## 📋 Checklist de Deployment

### Pre-Deployment

- [ ] Todos los servicios configurados
- [ ] Variables de entorno set
- [ ] Credenciales validadas
- [ ] Schema de DB desplegado
- [ ] Workflow importado y activado
- [ ] Tests manuales exitosos

### Post-Deployment  

- [ ] Monitoreo activo
- [ ] Backups configurados
- [ ] Alertas funcionando
- [ ] Documentación actualizada
- [ ] Equipo capacitado
- [ ] Plan de rollback listo

### Go-Live

- [ ] Comunicar a equipos
- [ ] Período de observación 48h
- [ ] Soporte disponible 24/7
- [ ] Métricas baseline capturadas

## 🆘 Troubleshooting

### Problemas Comunes

1. **Webhook timeouts**
   - Verificar configuración de firewall
   - Comprobar URL accessibility
   - Revisar rate limits

2. **LLM API errors**
   - Verificar API keys válidas
   - Comprobar quotas disponibles
   - Revisar formato de requests

3. **Supabase connection issues**
   - Verificar credenciales
   - Comprobar network connectivity  
   - Revisar RLS policies

4. **Email delivery problems**
   - Verificar OAuth tokens válidos
   - Comprobar límites de Gmail API
   - Revisar formato de templates

## 📞 Soporte

### Contactos de Emergencia

- **Technical Lead**: tech@zelva.com
- **DevOps**: devops@zelva.com  
- **24/7 Support**: +34 600 000 000

### Recursos

- [n8n Documentation](https://docs.n8n.io)
- [Supabase Docs](https://supabase.com/docs)
- [Internal Wiki](https://wiki.zelva.com/brief-intelligence)

---

## 🎉 ¡Deployment Completado!

El Brief Intelligence System está ahora live en producción. 

**Próximos pasos:**
1. Monitorear performance primeras 48h ✅
2. Recopilar feedback de usuarios ✅  
3. Optimizar basado en uso real ✅
4. Planificar mejoras v2 ✅

**¡Disfruta la automatización! 🚀**