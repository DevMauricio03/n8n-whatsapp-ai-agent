# Arquitectura del Sistema

## Arquitectura General

```text
Cliente
↓
WhatsApp Cloud API
↓
Chatwoot
↓
Webhook n8n
↓
Validación de mensajes entrantes
↓
Control de Human Handoff (Redis)
↓
Extracción de datos del mensaje
↓
Clasificación de mensaje (Texto / Audio)
↓
Transcripción de audio (OpenAI Whisper)
↓
Buffer conversacional (Redis)
↓
Agrupación de mensajes
↓
Validación de horario de atención
↓
AI Agent
├── OpenAI
├── Memoria Conversacional (PostgreSQL)
└── Herramienta de consulta de datos
↓
Clasificación de respuestas
↓
Envío de imágenes informativas o mensajes
↓
WhatsApp Cloud API
↓
Cliente
```
## Descripción General

La plataforma utiliza una arquitectura basada en eventos donde los mensajes recibidos desde WhatsApp son procesados mediante n8n.

Antes de ser enviados al agente de Inteligencia Artificial, los mensajes pasan por mecanismos de control que permiten gestionar conversaciones humanas, consolidar múltiples mensajes enviados en intervalos cortos de tiempo, procesar mensajes de voz y validar horarios de atención.

El agente utiliza OpenAI para generar respuestas contextuales, PostgreSQL para almacenar memoria conversacional e información estructurada, y Redis para la gestión de estados temporales y buffers conversacionales.

Finalmente, las respuestas son enviadas nuevamente al cliente mediante WhatsApp Cloud API.

## Componentes Principales

### WhatsApp Cloud API

Canal principal de comunicación utilizado para recibir y enviar mensajes a los clientes.

### Chatwoot

Plataforma utilizada para centralizar conversaciones y permitir la intervención de agentes humanos cuando sea necesario.

### n8n

Motor de automatización encargado de coordinar todos los procesos de negocio y comunicación.

### OpenAI

Proveedor de Inteligencia Artificial utilizado para la generación de respuestas y procesamiento de lenguaje natural.

### PostgreSQL

Base de datos utilizada para memoria conversacional y almacenamiento de información estructurada.

### Redis

Sistema de almacenamiento en memoria utilizado para buffers conversacionales, control de estados y handoff humano.