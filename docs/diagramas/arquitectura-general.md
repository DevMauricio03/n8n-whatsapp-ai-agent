# Arquitectura general

```mermaid
flowchart LR
    Client[Cliente] <--> Meta[WhatsApp Cloud API]
    Meta <--> Chatwoot[Chatwoot]
    Human[Agente humano] <--> Chatwoot
    Chatwoot -->|Webhook| N8N[n8n]
    N8N <--> OpenAI[OpenAI]
    N8N <--> Postgres[(PostgreSQL)]
    N8N <--> Redis[(Redis)]
    Drive[Google Drive] --> N8N
    N8N --> Meta
```

## Lectura

- WhatsApp es el canal del cliente.
- Chatwoot centraliza conversaciones e intervención humana.
- n8n aplica las reglas y coordina integraciones.
- Redis mantiene estado temporal.
- PostgreSQL conserva datos y memoria.
- OpenAI procesa audio y lenguaje.
- Google Drive alimenta la tabla empresarial.

La explicación completa está en [Arquitectura](../arquitectura.md).
