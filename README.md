 # Plataforma de Atención Automatizada con WhatsApp, IA y n8n

## Descripción

Este repositorio contiene la documentación técnica de una plataforma de atención automatizada desarrollada durante el proyecto de estadía profesional.

La solución integra WhatsApp Cloud API, Chatwoot, n8n, OpenAI, PostgreSQL y Redis para gestionar conversaciones, consultar información empresarial y proporcionar respuestas inteligentes mediante Inteligencia Artificial.

La plataforma fue diseñada para automatizar procesos de atención al cliente, reducir tiempos de respuesta y centralizar la comunicación mediante canales digitales.

## Tecnologías Utilizadas

- WhatsApp Cloud API
- Chatwoot
- n8n
- OpenAI
- PostgreSQL
- Redis
- Docker
- Docker Compose
- Caddy
- Ubuntu Server 24.04 LTS

## Arquitectura General

```text
Cliente
│
▼
WhatsApp
│
▼
WhatsApp Cloud API
│
▼
Chatwoot
│
▼
n8n
│
├── OpenAI
├── PostgreSQL
└── Redis
│
▼
Respuesta al Cliente
```

## Documentación

La documentación del proyecto se encuentra organizada en la carpeta:

```text
docs/
```

Documentos disponibles:

- overview.md
- arquitectura.md
- componentes.md
- workflows.md
- base-de-datos.md
- despliegue.md
- instalacion.md
- credenciales.md

## Objetivo

Documentar la arquitectura, instalación, despliegue y funcionamiento de la plataforma para facilitar su mantenimiento, transferencia de conocimiento y futuras implementaciones.