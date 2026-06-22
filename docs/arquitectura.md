# Arquitectura del sistema

## Vista general

```mermaid
flowchart TB
    Client[Cliente de WhatsApp]
    Meta[WhatsApp Cloud API]
    Chatwoot[Chatwoot]
    Caddy[Caddy HTTPS]
    N8N[n8n]
    OpenAI[OpenAI]
    Postgres[(PostgreSQL)]
    Redis[(Redis)]
    Drive[Google Drive]
    Agent[Agente humano]

    Client <--> Meta
    Meta <--> Chatwoot
    Agent <--> Chatwoot
    Chatwoot -->|Webhook| Caddy
    Caddy --> N8N
    N8N <--> OpenAI
    N8N <--> Postgres
    N8N <--> Redis
    Drive --> N8N
    N8N --> Meta
```

## Flujo de un mensaje

```mermaid
sequenceDiagram
    participant C as Cliente
    participant W as WhatsApp
    participant CW as Chatwoot
    participant N as n8n
    participant R as Redis
    participant P as PostgreSQL
    participant AI as OpenAI

    C->>W: Envía texto o audio
    W->>CW: Entrega el mensaje
    CW->>N: Webhook
    N->>R: Consulta Human Handoff
    alt Atención humana activa
        N-->>N: Detiene automatización
    else Automatización disponible
        N->>R: Agrega mensaje al buffer
        N->>N: Agrupa y valida horario
        opt Mensaje de audio
            N->>AI: Solicita transcripción
            AI-->>N: Texto transcrito
        end
        N->>AI: Envía mensaje y contexto
        AI->>P: Consulta por herramienta si necesita datos
        P-->>AI: Devuelve registros
        AI-->>N: Respuesta o clave de contenido
        N->>W: Envía texto o imagen
        W-->>C: Entrega la respuesta
    end
```

## Capas

| Capa | Componentes | Responsabilidad |
|---|---|---|
| Canal | WhatsApp Cloud API | Entrada y salida de mensajes |
| Atención | Chatwoot | Bandeja, contactos y agentes humanos |
| Orquestación | n8n | Reglas, integraciones y agente de IA |
| Inteligencia | OpenAI | Transcripción y generación de respuestas |
| Persistencia | PostgreSQL | Datos empresariales y memoria |
| Estado temporal | Redis | Buffer, bloqueo humano y coordinación |
| Fuente de datos | Google Drive | Archivo que alimenta `bd_clientes` |
| Exposición | Caddy | HTTPS y reverse proxy |

## Red y exposición

Todos los contenedores pertenecen a `platform_net`. Solo Caddy publica puertos:

- `80/tcp` para redirección y validación de certificados;
- `443/tcp` para HTTPS;
- `443/udp` para HTTP/3 cuando esté disponible.

PostgreSQL, Redis, n8n y Chatwoot no deben publicar puertos directamente en producción.

## Decisiones y límites

- PostgreSQL aloja tres bases: `n8n`, `chatwoot` y `agent`.
- La plantilla usa un usuario de PostgreSQL para simplificar el despliegue. En un entorno de mayor riesgo deben crearse usuarios separados y privilegios mínimos.
- Redis usa contraseña y persistencia AOF, pero no sustituye a un sistema de colas duradero.
- El workflow depende de la estructura del webhook de Chatwoot. Una actualización del proveedor debe probarse antes de producción.
- Las imágenes Docker se parametrizan para facilitar actualizaciones controladas.
