# Brief Intelligence System - Ejemplos de Uso

## 📋 Ejemplos Prácticos del Sistema

Esta documentación incluye ejemplos reales de cómo usar el Brief Intelligence System en diferentes escenarios.

## 🎯 Ejemplo 1: Brief Simple por Telegram

### Input (Usuario envía por Telegram):

```
Hola equipo! Soy Ana López de TechStartup. 

Necesitamos lanzar nuestra nueva app de fintech antes del Black Friday. 
Queremos hacer campañas en Facebook e Instagram dirigidas a millennials 
de 25-35 años en Madrid y Barcelona.

El presupuesto total es 45k€, con 20k para medios pagados.
Necesitamos que esté todo listo para el 20 de noviembre.

La app se llama "FinanceGo" y ayuda a jóvenes profesionales 
a gestionar sus finanzas personales de forma inteligente.

Mi email es ana.lopez@techstartup.com
Teléfono: +34 666 123 456

¡Gracias!
```

### Processing:

1. **🤖 Extracción LLM** detecta automáticamente:

```json
{
  "cliente": {
    "nombre_empresa": "TechStartup",
    "sector_industria": "Fintech",
    "responsable": {
      "nombre": "Ana López",
      "email": "ana.lopez@techstartup.com",
      "telefono": "+34 666 123 456"
    }
  },
  "proyecto": {
    "nombre": "Lanzamiento FinanceGo",
    "objetivo_principal": "Lanzar app de fintech antes del Black Friday",
    "tipo_proyecto": "Lanzamiento de producto"
  },
  "audiencia": {
    "target_primario": "Millennials de 25-35 años",
    "ubicacion_geografica": ["Madrid", "Barcelona"]
  },
  "servicios_requeridos": {
    "estrategia_digital": true,
    "publicidad_pagada": true,
    "social_media": true,
    "branding_diseno": true,
    "contenido_copywriting": true,
    "analitica_reporting": true
  },
  "timeline": {
    "fecha_entrega_final": "2024-11-20"
  },
  "presupuesto": {
    "rango_total": {
      "maximo": 45000,
      "moneda": "EUR"
    },
    "presupuesto_medios": {
      "total_campana": 20000
    }
  }
}
```

2. **✅ Validación QA** devuelve:

```json
{
  "validation_passed": true,
  "confidence_score": 0.85,
  "missing_fields": ["contexto_marca", "competencia"],
  "recommendations": [
    "Solicitar más información sobre la personalidad de marca",
    "Definir diferenciadores vs competencia fintech"
  ],
  "estimated_complexity": "media",
  "estimated_resources": {
    "team_size": 4,
    "duration_weeks": 6
  }
}
```

### Output:

3. **📊 Presentación Google Slides** generada automáticamente
4. **📧 Email al Director** para aprobación:

```html
🎯 Nuevo Brief: TechStartup - Lanzamiento FinanceGo

📋 RESUMEN
Cliente: TechStartup (Fintech)
Proyecto: Lanzamiento FinanceGo  
Deadline: 20 Nov 2024
Presupuesto: 45.000€ (20k medios)

🎯 OBJETIVO
Lanzar app de fintech antes del Black Friday

👥 AUDIENCIA  
Millennials 25-35 años en Madrid y Barcelona

✅ SCORE QA: 85%

[BOTONES: Aprobar | Modificar | Rechazar]
```

---

## 🎯 Ejemplo 2: Brief Complejo por Gmail

### Input (Email recibido):

```
Asunto: BRIEF - Campaña de Rebranding Luxury Hotels

De: maria.garcia@luxuryhotels.com
Para: briefs@zelva.com

Estimado equipo de Zelva,

Somos Luxury Hotels Group, una cadena de hoteles de lujo con 15 propiedades 
en España, Francia e Italia. Tras 25 años en el mercado, necesitamos un 
rebranding completo para modernizar nuestra imagen y atraer a una audiencia 
más joven sin perder nuestro prestigio.

CONTEXTO:
- Empresa familiar fundada en 1998
- 15 hoteles 5 estrellas en destinos premium
- Facturación anual: 150M€
- Competencia directa: Four Seasons, Mandarin Oriental
- Problema: Imagen percibida como "clásica/antigua"

OBJETIVOS:
1. Renovar identidad visual completa
2. Desarrollar nueva estrategia digital
3. Atraer millennials y Gen Z de alto poder adquisitivo
4. Mantener prestigio con clientes actuales (45+ años)
5. Incrementar reservas directas en 25%

SCOPE DEL PROYECTO:
- Nuevo logo y brand identity
- Website completamente nuevo
- Estrategia de contenido premium
- Campañas en Google, Meta, LinkedIn
- Influencer marketing con luxury travel bloggers
- Email marketing automation
- Packaging y amenities redesign

AUDIENCIA PRIMARIA:
- Millennials (28-40) con ingresos >100k€/año
- Profesionales ejecutivos
- Ubicación: Madrid, Barcelona, París, Milán
- Intereses: lujo sostenible, experiencias únicas

AUDIENCIA SECUNDARIA:
- Gen X actual (clientes leales)
- Empresarios 45-60 años
- Turismo de lujo internacional

PRESUPUESTO:
- Total proyecto: 350.000€
- Medios pagados: 120.000€ (6 meses)
- Desarrollo web: 80.000€
- Branding: 60.000€
- Contenido: 40.000€
- Resto: gestión y extras

TIMELINE:
- Inicio: 15 enero 2024
- Brand identity: 15 marzo 2024
- Website: 30 abril 2024  
- Lanzamiento campaña: 15 mayo 2024
- Fin primera fase: 31 octubre 2024

ENTREGABLES ESPERADOS:
- Manual de marca completo
- Logotipo en todas las variantes
- Website responsive optimizado para móvil
- Estrategia de contenido 12 meses
- 50+ piezas creativas para campaña
- Setup completo Google Ads + Meta
- Dashboard de métricas en tiempo real

REQUISITOS ESPECIALES:
- Cumplimiento GDPR estricto
- Integración con PMS (Property Management System)
- Multilingual: ES, FR, IT, EN
- Fotografía profesional de propiedades
- Coordinación con 15 hoteles

CONTACTOS:
María García - CMO
Email: maria.garcia@luxuryhotels.com
Teléfono: +34 91 123 456
Skype: maria.garcia.lhg

Carlos Mendoza - CEO  
Email: carlos.mendoza@luxuryhotels.com
Móvil: +34 600 789 012

CONTEXTO ADICIONAL:
- Trabajamos actualmente con agencia pequeña local
- Budget aprobado por board of directors
- Decisión de cambio motivada por caída 15% bookings jóvenes
- Timing crítico: temporada alta empieza en mayo
- Muy importantes las métricas de ROI y tracking

Quedamos atentos a su propuesta.

Saludos cordiales,
María García
```

### Processing:

1. **🤖 Extracción LLM** detecta:

```json
{
  "cliente": {
    "nombre_empresa": "Luxury Hotels Group",
    "sector_industria": "Hospitalidad/Hoteles de Lujo",
    "responsable": {
      "nombre": "María García",
      "cargo": "CMO",
      "email": "maria.garcia@luxuryhotels.com",
      "telefono": "+34 91 123 456"
    },
    "contexto_empresa": "Cadena familiar de 15 hoteles 5 estrellas en España, Francia e Italia. 25 años en el mercado, facturación 150M€ anuales."
  },
  "proyecto": {
    "nombre": "Rebranding Luxury Hotels Group",
    "tipo_proyecto": "Rebranding completo",
    "objetivo_principal": "Modernizar imagen para atraer audiencia joven sin perder prestigio",
    "objetivos_secundarios": [
      "Renovar identidad visual completa",
      "Desarrollar nueva estrategia digital", 
      "Incrementar reservas directas en 25%"
    ],
    "desafio_principal": "Balancear modernización con mantenimiento de prestigio"
  },
  "audiencia": {
    "target_primario": "Millennials (28-40) con ingresos >100k€/año",
    "target_secundario": "Gen X clientes actuales (45-60 años)",
    "ubicacion_geografica": ["Madrid", "Barcelona", "París", "Milán"],
    "comportamientos": ["Buscan lujo sostenible", "Valoran experiencias únicas"],
    "pain_points": ["Percepción de marca anticuada"]
  },
  "marca": {
    "personalidad_marca": "Lujo moderno y sofisticado",
    "valores_clave": ["Lujo sostenible", "Experiencias únicas", "Excelencia"],
    "competencia_directa": ["Four Seasons", "Mandarin Oriental"],
    "diferenciadores": ["Hoteles familiares con historia", "Ubicaciones premium"]
  },
  "servicios_requeridos": {
    "estrategia_digital": true,
    "branding_diseno": true,
    "publicidad_pagada": true,
    "contenido_copywriting": true,
    "desarrollo_web": true,
    "social_media": true,
    "seo_sem": true,
    "analitica_reporting": true
  },
  "presupuesto": {
    "rango_total": {
      "maximo": 350000,
      "moneda": "EUR"
    },
    "distribucion_sugerida": {
      "branding": 60000,
      "desarrollo_web": 80000,
      "medios_pagados": 120000,
      "contenido": 40000,
      "otros": 50000
    },
    "presupuesto_medios": {
      "total_campana": 120000
    }
  },
  "timeline": {
    "fecha_inicio_preferida": "2024-01-15",
    "fecha_entrega_final": "2024-10-31",
    "hitos_importantes": [
      {
        "descripcion": "Brand identity completa",
        "fecha_estimada": "2024-03-15",
        "criticidad": "alta"
      },
      {
        "descripcion": "Website lanzado",
        "fecha_estimada": "2024-04-30", 
        "criticidad": "alta"
      },
      {
        "descripcion": "Campaña activa",
        "fecha_estimada": "2024-05-15",
        "criticidad": "alta"
      }
    ]
  },
  "requisitos_especiales": {
    "compliance_legal": ["GDPR estricto"],
    "integraciones_tecnicas": ["PMS (Property Management System)"],
    "restricciones_creativas": ["Multilingual: ES, FR, IT, EN"]
  },
  "metadata": {
    "urgencia": "alta",
    "complejidad_estimada": "alta",
    "recursos_internos_requeridos": [
      "Estratega senior", "Director creativo", "Desarrollador senior", 
      "Especialista paid media", "Account manager senior"
    ]
  }
}
```

2. **✅ Validación QA**:

```json
{
  "validation_passed": true,
  "confidence_score": 0.95,
  "quality_assessment": {
    "campos_criticos": {
      "presentes": ["cliente", "objetivo", "timeline", "presupuesto"],
      "score": 1.0
    },
    "campos_importantes": {
      "presentes": ["audiencia", "entregables", "contexto_marca"],
      "score": 0.95
    }
  },
  "estimated_complexity": "alta",
  "estimated_resources": {
    "team_size": 8,
    "duration_weeks": 38,
    "skill_requirements": ["estrategia", "branding", "desarrollo_web", "paid_media", "project_management"]
  },
  "risk_assessment": {
    "timeline_risk": "media",
    "budget_risk": "baja",
    "scope_clarity_risk": "baja"
  },
  "recommendations": [
    "Asignar project manager dedicado por complejidad",
    "Planificar calls semanales con stakeholders",
    "Setup staging environment para desarrollo web"
  ]
}
```

### Output Workflow:

3. **📧 Email Director** con información detallada
4. **Director aprueba** → Proyecto se crea en COR automáticamente
5. **Notificaciones personalizadas** a cada equipo:

**Email Equipo Creativo:**
```
🚀 Nuevo Proyecto: Luxury Hotels Group - Rebranding

TU ROL: Equipo Creativo - Estrategia y Branding

📋 RESUMEN
Cliente: Luxury Hotels Group (Hospitalidad) 
Proyecto: Rebranding completo de cadena de lujo
Timeline: 38 semanas (Enero - Octubre 2024)

🎯 TUS RESPONSABILIDADES:
• Desarrollar nueva identidad de marca completa
• Crear estrategia de rebranding que balance modernidad y prestigio  
• Diseñar manual de marca para 15 hoteles
• Supervisar consistencia visual en todos los touchpoints

📦 ENTREGABLES ESPERADOS:
• Manual de marca completo con guidelines
• Nuevo logotipo y variantes
• Estrategia de rebranding documentada
• Paleta de colores y tipografías
• Templates para aplicaciones

⏰ HITOS CLAVE:
• 15 Mar: Brand identity aprobada
• Presupuesto asignado: 60.000€

[Ver en COR] [Programar Kick-off] [Canal Slack]
```

**Email Equipo Medios:**
```
🚀 Nuevo Proyecto: Luxury Hotels Group - Campañas

TU ROL: Equipo Medios - Performance y Paid Media

📋 RESUMEN  
Cliente: Luxury Hotels Group
Objetivo: Incrementar reservas directas 25%
Presupuesto medios: 120.000€ (6 meses)

🎯 TUS RESPONSABILIDADES:
• Planificar estrategia paid media Google, Meta, LinkedIn
• Configurar tracking avanzado y métricas ROI
• Gestionar presupuesto 120k€ optimizando performance
• Reportar resultados semanalmente con dashboard

📦 ENTREGABLES ESPERADOS:
• Plan de medios detallado por canal
• Setup completo Google Ads + Meta Business
• Dashboard métricas en tiempo real
• Reportes performance semanales

⏰ TIMELINE:
• 15 May: Lanzamiento campaña
• Target: +25% reservas directas

[Ver en COR] [Acceder a Assets] [Dashboard]
```

---

## 🎯 Ejemplo 3: Brief con Audio por Telegram

### Input (Usuario envía audio):

**🎤 Mensaje de voz de 2 minutos:**

"Hola, soy Jorge de Ecomerce Plus. Escucha, necesitamos ayuda urgente con nuestro Black Friday. Somos un marketplace de productos sostenibles y este año queremos hacer algo grande. Tenemos un presupuesto de unos 80 mil euros para todo, y necesitamos que esté todo listo para finales de octubre. 

Vendemos productos eco-friendly, desde ropa sostenible hasta productos de hogar zero waste. Nuestro público son principalmente mujeres entre 25 y 45 años que se preocupan por el medio ambiente, sobre todo en Barcelona, Madrid y Valencia.

Necesitamos nuevas creatividades, campañas en redes sociales, Google Ads, y también queremos probar con influencers. Ah, y necesitamos landing pages nuevas porque las que tenemos son un desastre.

Mi email es jorge@ecommerceplus.com y mi móvil es el 666 555 777. La empresa factura como unos 2 millones al año, llevamos 3 años en el mercado. 

¿Podéis ayudarnos? Es súper urgente porque la competencia ya está empezando sus campañas."

### Processing:

1. **🎤 Whisper transcribe** el audio automáticamente
2. **🤖 Extracción LLM** procesa la transcripción:

```json
{
  "cliente": {
    "nombre_empresa": "Ecommerce Plus", 
    "sector_industria": "E-commerce sostenible",
    "responsable": {
      "nombre": "Jorge",
      "email": "jorge@ecommerceplus.com",
      "telefono": "666 555 777"
    },
    "contexto_empresa": "Marketplace de productos sostenibles. 3 años en mercado, facturación 2M€/año"
  },
  "proyecto": {
    "nombre": "Campaña Black Friday 2024",
    "objetivo_principal": "Lanzar campaña Black Friday para marketplace sostenible", 
    "desafio_principal": "Timeline ajustado y competencia ya activa"
  },
  "audiencia": {
    "target_primario": "Mujeres 25-45 años interesadas en sostenibilidad",
    "ubicacion_geografica": ["Barcelona", "Madrid", "Valencia"],
    "intereses": ["Productos eco-friendly", "Sostenibilidad", "Zero waste"]
  },
  "servicios_requeridos": {
    "estrategia_digital": true,
    "branding_diseno": true, 
    "publicidad_pagada": true,
    "contenido_copywriting": true,
    "desarrollo_web": true,
    "social_media": true
  },
  "presupuesto": {
    "rango_total": {
      "maximo": 80000,
      "moneda": "EUR"
    }
  },
  "timeline": {
    "fecha_entrega_final": "2024-10-31"
  },
  "metadata": {
    "urgencia": "alta"
  }
}
```

3. **✅ Validación QA**:

```json
{
  "validation_passed": true,
  "confidence_score": 0.75,
  "missing_fields": ["presupuesto_detallado", "entregables_específicos"],
  "warnings": ["Timeline muy ajustado para Black Friday"],
  "recommendations": [
    "Confirmar presupuesto detallado por servicios",
    "Definir entregables específicos en kick-off", 
    "Priorizar landing pages para lanzar primero"
  ]
}
```

### Workflow continúa normalmente hacia aprobación y asignación de equipos.

---

## 🎯 Ejemplo 4: Caso de Modificación

### Escenario: 
El director recibe el email de aprobación del ejemplo 1 (TechStartup) y decide solicitar cambios.

### Input (Director hace clic en "Modificar"):

**Formulario web aparece:**
```
Comentarios de modificación:

"El presupuesto está bien, pero necesitamos ampliar el alcance. 
El cliente me comentó por teléfono que también quieren:

1. Incluir campañas en LinkedIn para captar profesionales
2. Desarrollar una landing page específica para la app
3. Cambiar el público objetivo solo a Barcelona (no Madrid)
4. Añadir email marketing automation 

El deadline puede moverse una semana más tarde si es necesario."
```

### Processing:

1. **🤖 Change Processor LLM** analiza los cambios:

```json
{
  "changes_detected": {
    "scope_changes": [
      {
        "field": "servicios_requeridos.otros_servicios",
        "action": "add",
        "new_value": ["LinkedIn Ads", "Email marketing automation"],
        "reason": "Cliente solicita nuevos canales"
      },
      {
        "field": "entregables.tecnicos", 
        "action": "add",
        "new_value": ["Landing page específica para app"],
        "reason": "Desarrollo web adicional requerido"
      }
    ],
    "strategic_changes": [
      {
        "field": "audiencia.ubicacion_geografica",
        "current_value": ["Madrid", "Barcelona"],
        "new_value": ["Barcelona"],
        "significance": "media",
        "reason": "Enfoque geográfico más específico"
      }
    ],
    "timeline_changes": [
      {
        "field": "timeline.fecha_entrega_final",
        "current_value": "2024-11-20",
        "new_value": "2024-11-27", 
        "impact": "baja",
        "reason": "Extensión para nuevos servicios"
      }
    ]
  },
  "change_summary": {
    "total_changes": 4,
    "complexity_impact": "aumenta",
    "budget_impact": "aumenta", 
    "team_impact": ["Requiere especialista LinkedIn", "Desarrollador web adicional"]
  },
  "validation_needed": true,
  "next_actions": [
    "Validar presupuesto adicional con cliente",
    "Confirmar nueva fecha de entrega",
    "Asignar desarrollador al proyecto"
  ]
}
```

2. **Sistema actualiza automáticamente**:
   - Brief en Supabase
   - Presenta modified Google Slides 
   - Registra cambios en historial

3. **📧 Email notifica cambios** a todos los stakeholders:

```html
✏️ Brief Modificado: TechStartup - FinanceGo

🔄 CAMBIOS APLICADOS:
• ✅ Añadido: LinkedIn Ads
• ✅ Añadido: Email marketing automation  
• ✅ Añadido: Landing page dedicada
• 📍 Audiencia: Solo Barcelona (excluido Madrid)
• 📅 Nueva fecha: 27 Nov (extensión 1 semana)

💰 IMPACTO PRESUPUESTO: Aumenta ~15% 
👥 EQUIPOS AFECTADOS: Medios, Desarrollo

[Ver presentación actualizada] [Proyecto en COR]
```

4. **Workflow continúa** creando proyecto con las modificaciones.

---

## 🎯 Ejemplo 5: Caso de Rechazo

### Escenario:
Brief demasiado vago recibe validación negativa.

### Input:
```
"Hola, somos una startup y necesitamos marketing. 
Tenemos algo de dinero. ¿Pueden ayudarnos?"
```

### Processing:

1. **🤖 Extracción LLM** extrae muy poca información:

```json
{
  "cliente": {
    "nombre_empresa": null,
    "responsable": {
      "nombre": null,
      "email": null
    }
  },
  "proyecto": {
    "objetivo_principal": "Servicios de marketing para startup"
  },
  "metadata": {
    "urgencia": "baja",
    "complejidad_estimada": "indeterminada"
  }
}
```

2. **✅ Validación QA** falla:

```json
{
  "validation_passed": false,
  "confidence_score": 0.2,
  "missing_fields": [
    "Información de contacto del responsable",
    "Nombre de la empresa",
    "Presupuesto estimado", 
    "Servicios específicos requeridos",
    "Timeline del proyecto"
  ],
  "blockers": [
    "Sin información de contacto para follow-up",
    "Brief demasiado vago para procesar",
    "Sin presupuesto definido"
  ],
  "next_actions": [
    "Solicitar información adicional",
    "Enviar cuestionario de brief estructurado",
    "No proceder hasta tener datos básicos"
  ]
}
```

3. **🛑 Sistema se detiene** y envía respuesta automática:

**Por Telegram:**
```
❌ Brief incompleto detectado

Hola! Gracias por contactarnos. 

Para poder ayudarte necesitamos más información:

📋 INFORMACIÓN REQUERIDA:
• Nombre de tu empresa
• Tu nombre y email de contacto  
• Qué servicios específicos necesitas
• Presupuesto aproximado
• Timeline del proyecto

📝 Te recomiendo usar esta plantilla:

"Hola, soy [NOMBRE] de [EMPRESA].
Necesitamos [SERVICIOS] para [OBJETIVO].
Presupuesto: [CANTIDAD]€
Timeline: [FECHAS]
Contacto: [EMAIL] [TELÉFONO]"

¡Envíanos un nuevo brief con esta info! 🚀
```

---

## 🎯 Ejemplo 6: Brief Multiidioma

### Input (Cliente italiano envía por Gmail):

```
Oggetto: BRIEF - Campagna digitale per resort di lusso

Ciao team Zelva,

Sono Marco Rossini, Marketing Director di Bellissimo Resort, 
una struttura di lusso a Positano con 45 camere vista mare.

Abbiamo bisogno di una campagna digitale per la stagione estiva 2024.
Vogliamo attirare clienti internazionali high-end, soprattutto 
americani e tedeschi.

Budget totale: 150.000€
Timeline: Aprile-Settembre 2024  

La nostra USP è la vista mozzafiato sulla costiera amalfitana 
e il servizio personalizzato.

Contatti:
Marco Rossini - marco@bellissimo-resort.it
+39 089 123 456

Grazie mille!
Marco
```

### Processing:

**🤖 LLM detecta idioma automáticamente** y procesa en italiano, luego traduce estructura al español:

```json
{
  "cliente": {
    "nombre_empresa": "Bellissimo Resort",
    "sector_industria": "Hospitalidad/Resort de lujo",
    "responsable": {
      "nombre": "Marco Rossini",
      "cargo": "Marketing Director", 
      "email": "marco@bellissimo-resort.it",
      "telefono": "+39 089 123 456"
    },
    "contexto_empresa": "Resort de lujo en Positano con 45 habitaciones vista mar"
  },
  "proyecto": {
    "nombre": "Campaña Digital Temporada Estiva 2024",
    "objetivo_principal": "Atraer clientes internacionales high-end para temporada estival"
  },
  "audiencia": {
    "target_primario": "Turistas de lujo internacionales",
    "ubicacion_geografica": ["Estados Unidos", "Alemania"],
    "comportamientos": ["Buscan experiencias de lujo", "Viajes a Italia"]
  },
  "marca": {
    "diferenciadores": ["Vista costa amalfitana", "Servicio personalizado"],
    "posicionamiento_deseado": "Resort de lujo exclusivo en Positano"
  },
  "timeline": {
    "fecha_inicio_preferida": "2024-04-01",
    "fecha_entrega_final": "2024-09-30"
  },
  "presupuesto": {
    "rango_total": {
      "maximo": 150000,
      "moneda": "EUR"
    }
  }
}
```

**El sistema continúa normalmente**, generando documentación en español para el equipo interno, pero manteniendo comunicación con el cliente en italiano.

---

## 📊 Métricas de Éxito

### Después de 1 mes usando el sistema:

```sql
-- Briefs procesados exitosamente
SELECT COUNT(*) as total_briefs,
       COUNT(CASE WHEN validation_passed = true THEN 1 END) as validated,
       AVG(validation_score) as score_promedio
FROM briefs 
WHERE created_at > NOW() - INTERVAL '30 days';

-- Resultado: 127 briefs, 89% validación exitosa, score 0.82
```

### Tiempo ahorrado:

- **Antes**: 2-4 horas por brief (manual)
- **Después**: 15 minutos promedio (automatizado) 
- **Ahorro**: 85% tiempo de procesamiento

### Satisfacción equipos:

- **Creativos**: "Ya no perdemos tiempo extrayendo info de briefs confusos"
- **Medios**: "Los datos llegan perfectamente estructurados"  
- **Account**: "Los clientes están impresionados con la rapidez"

---

## 🔧 Casos de Debugging

### Problema: LLM devuelve JSON malformado

**Error en logs:**
```
JSON.parse error: Unexpected token in JSON at position 45
```

**Solución:**
```javascript
// En el nodo "Process Extraction Response"
try {
  extractedData = JSON.parse(response);
} catch (error) {
  // Intentar limpiar la respuesta
  const cleanResponse = response
    .replace(/```json/g, '')
    .replace(/```/g, '')
    .replace(/^\s*[\r\n]/gm, '');
  extractedData = JSON.parse(cleanResponse);
}
```

### Problema: Supabase timeout en insert

**Error:**
```
Connection timeout after 30000ms
```

**Solución:**
```javascript
// Dividir inserts grandes en chunks
const chunkSize = 100;
for (let i = 0; i < data.length; i += chunkSize) {
  const chunk = data.slice(i, i + chunkSize);
  await supabase.from('briefs').insert(chunk);
}
```

---

Esta documentación de ejemplos te ayudará a entender exactamente cómo el sistema procesa diferentes tipos de briefs y maneja varios escenarios reales que pueden ocurrir en Zelva. 🚀