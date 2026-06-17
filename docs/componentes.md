# Componentes del Sistema

## WhatsApp Cloud API

Canal principal de comunicación con los clientes.

Responsabilidades:

- Recepción de mensajes.
- Envío de respuestas.
- Envío de imágenes informativas.
- Gestión de conversaciones mediante WhatsApp Business.

## Chatwoot

Plataforma utilizada para centralizar las conversaciones provenientes de WhatsApp.

Responsabilidades:

- Recepción de mensajes.
- Gestión de conversaciones.
- Interacción con agentes humanos.
- Integración con n8n mediante Webhooks.

## n8n

Motor principal de automatización de la plataforma.

Responsabilidades:

- Recepción de eventos mediante Webhooks.
- Procesamiento de mensajes entrantes.
- Gestión del flujo conversacional.
- Procesamiento de mensajes de texto.
- Procesamiento de mensajes de audio.
- Coordinación de integraciones externas.
- Ejecución del agente de Inteligencia Artificial.
- Envío de respuestas hacia WhatsApp.

El sistema utiliza workflows para orquestar todas las operaciones de negocio y comunicación.

## OpenAI

Servicio de Inteligencia Artificial utilizado para interpretar consultas y generar respuestas conversacionales.

Responsabilidades:

- Comprensión del lenguaje natural.
- Generación de respuestas contextuales.
- Interpretación de preguntas de los clientes.
- Procesamiento de mensajes transcritos desde audio.
- Uso de memoria conversacional para mantener contexto.

El agente utiliza instrucciones de sistema y contexto conversacional para proporcionar respuestas coherentes y orientadas a la atención al cliente.

## PostgreSQL

Base de datos principal utilizada por la plataforma.

Responsabilidades:

- Almacenamiento de memoria conversacional.
- Almacenamiento de información de clientes.
- Consulta de folios.
- Consulta de estados de pago.
- Consulta de resultados de análisis.
- Persistencia de información utilizada por el agente.

La base de datos permite que el agente consulte información estructurada y mantenga contexto histórico de las conversaciones.

## Redis

Sistema de almacenamiento en memoria utilizado para operaciones de alta velocidad.

Responsabilidades:

- Buffer conversacional.
- Control de handoff humano.
- Gestión temporal de mensajes.
- Almacenamiento de estados transitorios.
- Control de sesiones activas.

Redis permite consolidar múltiples mensajes enviados en pocos segundos antes de procesarlos mediante Inteligencia Artificial.

## Caddy

Servidor Reverse Proxy utilizado para exponer los servicios de la plataforma mediante HTTPS.

Responsabilidades:

- Terminación SSL/TLS.
- Generación automática de certificados SSL.
- Enrutamiento de tráfico hacia los servicios internos.
- Exposición segura de n8n.
- Exposición segura de Chatwoot.

Caddy permite simplificar la administración de certificados y garantizar comunicaciones seguras entre los usuarios y la plataforma.