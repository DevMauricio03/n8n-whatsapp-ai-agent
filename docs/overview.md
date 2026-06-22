# Descripción general

## Problema

La atención por WhatsApp suele combinar preguntas repetitivas, consultas de información empresarial y casos que requieren intervención humana. Sin coordinación central, los tiempos de respuesta aumentan y pueden producirse respuestas duplicadas.

## Solución

La plataforma centraliza las conversaciones en Chatwoot y utiliza n8n para decidir si un mensaje debe:

- detenerse porque un agente humano tiene el control;
- agruparse con mensajes enviados en pocos segundos;
- transcribirse si contiene audio;
- responderse mediante IA;
- consultar información empresarial;
- enviar una imagen informativa;
- o quedar pendiente fuera del horario de atención.

## Alcance

Incluye:

- infraestructura Docker;
- integración con WhatsApp Cloud API;
- bandeja de atención en Chatwoot;
- workflow principal de n8n;
- sincronización desde Google Drive hacia PostgreSQL;
- memoria conversacional;
- Human Handoff y buffer en Redis;
- HTTPS mediante Caddy;
- guías de operación, pruebas, seguridad y respaldo.

No incluye:

- una cuenta de Meta aprobada;
- dominios, servidor o certificados preexistentes;
- credenciales reales;
- políticas legales específicas de la organización;
- monitoreo externo, alta disponibilidad o escalamiento horizontal;
- datos de clientes para pruebas.

## Usuarios

- Clientes que escriben por WhatsApp.
- Agentes humanos que atienden desde Chatwoot.
- Administradores que mantienen n8n e infraestructura.
- Responsables de negocio que actualizan la fuente de datos.

## Criterios de éxito

- El cliente recibe una respuesta única y coherente.
- La automatización no responde durante la atención humana.
- Los datos consultados provienen de PostgreSQL y no son inventados.
- Los mensajes de audio se procesan o fallan de forma controlada.
- Los servicios internos no quedan expuestos directamente a Internet.
- Una persona nueva puede desplegar, probar y recuperar la plataforma siguiendo la documentación.
