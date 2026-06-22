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
%%{init: { "flowchart": { "defaultRenderer": "elk", "curve": "basis" }, "themeVariables": { "fontSize": "13px", "primaryColor": "#111827", "primaryTextColor": "#ffffff", "primaryBorderColor": "#374151", "lineColor": "#4b5563", "secondBkgColor": "#111827", "tertiaryColor": "#111827", "tertiaryTextColor": "#ffffff", "tertiaryBorderColor": "#374151", "background": "#111827", "mainBkg": "#111827", "secondBkg": "#111827", "clusterBkg": "#111827", "clusterBorder": "#374151", "edgeLabelBackground":"#111827" }, "theme": "dark" }}}%%
flowchart LR

%% SECCIONES HORIZONTALES
subgraph Cliente["Cliente"]
    A1["fa:fa-whatsapp Cliente WhatsApp"]:::green
end

subgraph Entrada["Entrada y Mensajería"]
    A2["fa:fa-cloud WhatsApp Cloud API"]:::blue
    A3["fa:fa-comments Chatwoot recibe mensaje"]:::blue
    A4["fa:fa-link Webhook a n8n"]:::blue
end

subgraph Lógica["Lógica y Decisión"]
    B1["fa:fa-database Consulta Redis (estado atención)"]:::gray
    B2{"¿Atención humana activa?"}:::gray
    B3["fa:fa-user Espera atención humana (mensajes en pausa)\nTTL 30 min o desactivación manual"]:::gray
    B4["fa:fa-robot Continuar automatización"]:::gray
end

%% RAMA PARA TEXTO (SUPERIOR)
subgraph Texto["Canal Texto"]
    T1["fa:fa-database Buffer Redis"]:::blue
    T2["fa:fa-clock Validar horario y agrupar mensajes"]:::blue
    T3["fa:fa-brain OpenAI procesa texto"]:::orange
    T4["fa:fa-database Consultar PostgreSQL (contexto)"]:::blue
    T5["fa:fa-comments Generar respuesta (texto o imagen)"]:::orange
end

%% RAMA PARA AUDIO (INFERIOR)
subgraph Audio["Canal Audio"]
    A5["fa:fa-microphone Transcribir con OpenAI Whisper"]:::orange
    A6["fa:fa-database Guarda transcripción Redis"]:::blue
    A7["fa:fa-clock Validar horario y agrupar mensajes"]:::blue
    A8["fa:fa-brain OpenAI procesa texto derivado de audio"]:::orange
    A9["fa:fa-database Consultar PostgreSQL (contexto)"]:::blue
    A10["fa:fa-comments Generar respuesta (texto o imagen)"]:::orange
end

subgraph Salida["Entrega de Respuesta"]
    E1["fa:fa-paper-plane n8n → WhatsApp API"]:::blue
    E2["fa:fa-message Chatwoot → Cliente"]:::blue
    E3["fa:fa-whatsapp Cliente recibe respuesta"]:::green
end

%% FLUJO PRINCIPAL HORIZONTAL
A1 --> A2 --> A3 --> A4 --> B1 --> B2
B2 -->|Sí| B3
B2 -->|No| B4

%% BIFURCACIÓN A CANALES PARALELOS
B4 -->|Texto| T1
B4 -->|Audio| A5

%% CANAL TEXTO
T1 --> T2 --> T3 --> T4 --> T5 --> E1

%% CANAL AUDIO
A5 --> A6 --> A7 --> A8 --> A9 --> A10 --> E1

E1 --> E2 --> E3

%% VUELTA DESDE HUMAN MODE
B3 -. "Expira TTL (30 min)\n o se desactiva manualmente" .-> B4

%% ESTILOS
classDef green stroke:#4ade80,fill:#064e3b,color:#ffffff;
classDef blue stroke:#38bdf8,fill:#0c2d48,color:#ffffff;
classDef orange stroke:#fb923c,fill:#5a2e0f,color:#ffffff;
classDef gray stroke:#6b7280,fill:#1f2937,color:#ffffff;
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
