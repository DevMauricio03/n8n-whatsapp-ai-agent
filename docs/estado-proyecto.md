# Estado del proyecto

## Madurez

Estado actual: **base funcional documentada, pendiente de validación integral en un entorno limpio**.

## Disponible

- Arquitectura documentada.
- Workflow principal exportado y saneado.
- Plantilla completa de Docker Compose.
- PostgreSQL, Redis, n8n, Chatwoot y Caddy.
- Esquema inicial de `bd_clientes`.
- Guías de instalación, operación, pruebas y respaldo.

## Pendiente antes de producción

- Revocar el token histórico de WhatsApp.
- Verificar y, si se publica, limpiar el historial Git.
- Probar instalación desde cero.
- Confirmar versiones compatibles de todas las imágenes.
- Validar la configuración del canal de WhatsApp en Chatwoot.
- Implementar verificación robusta de webhooks.
- Separar usuarios y privilegios de PostgreSQL.
- Añadir manejo global de errores en n8n.
- Configurar retención de ejecuciones y memoria.
- Añadir monitoreo y alertas.
- Validar privacidad y tratamiento de datos.
- Ejecutar una restauración completa.

## Riesgos técnicos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Cambio en payload de Chatwoot | Workflow interrumpido | Pruebas de contrato |
| Expiración de token | Audio o mensajes fallan | Rotación y alerta |
| Redis no disponible | Handoff y buffer inseguros | Fallo cerrado y monitoreo |
| IA inventa datos | Información incorrecta | Herramientas, reglas y pruebas |
| Disco lleno | Caída de bases | Retención, métricas y alertas |
| Actualización incompatible | Indisponibilidad | Versionado, staging y rollback |

## Próximas mejoras

1. Separar el workflow de atención del workflow de sincronización.
2. Añadir workflow de errores y alertas.
3. Usar `conversation_id` para claves Redis y memoria.
4. Añadir validación de autorización antes de revelar folios.
5. Automatizar lint de Markdown, JSON y Compose.
6. Añadir pruebas de carga y métricas de calidad.
