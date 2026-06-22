# Componentes

| Componente | Función | Datos que maneja | Dependencias |
|---|---|---|---|
| WhatsApp Cloud API | Recibe y envía mensajes | Teléfono, texto, audio y estado de entrega | Meta, Internet |
| Chatwoot | Centraliza conversaciones | Contactos, conversaciones y agentes | PostgreSQL, Redis |
| n8n | Ejecuta automatizaciones | Payloads, contexto y resultados | Todos los servicios |
| OpenAI | Transcribe y genera respuestas | Texto, audio y contexto enviado | API externa |
| PostgreSQL | Persistencia | Clientes, folios y memoria | Volumen Docker |
| Redis | Estado temporal | Buffers y bloqueo humano | Volumen Docker |
| Google Drive | Fuente de sincronización | Archivo XLSX empresarial | OAuth de Google |
| Caddy | Reverse proxy | Tráfico HTTPS | DNS, puertos 80/443 |

## Responsabilidades operativas

### WhatsApp Cloud API

- Mantener activo el número empresarial.
- Entregar eventos a Chatwoot.
- Permitir el envío de texto, audio e imágenes.
- Rotar tokens y revisar permisos.

### Chatwoot

- Presentar la bandeja a los agentes.
- Emitir webhooks hacia n8n.
- Diferenciar mensajes entrantes y salientes.
- Conservar la conversación visible para operación humana.

### n8n

- Validar la estructura de entrada.
- Evitar que mensajes salientes vuelvan a activar la IA.
- Aplicar Human Handoff.
- Consolidar mensajes.
- Ejecutar horario, IA, consultas y envíos.
- Registrar ejecuciones y errores.

### PostgreSQL

- Base `n8n`: configuración y ejecuciones de n8n.
- Base `chatwoot`: datos internos de Chatwoot.
- Base `agent`: `bd_clientes` y memoria del agente.

### Redis

- Claves de Human Handoff con TTL.
- Listas temporales del buffer.
- Datos temporales de Chatwoot.

### Caddy

- Solicitar y renovar certificados.
- Enrutar `N8N_DOMAIN` hacia n8n.
- Enrutar `CHATWOOT_DOMAIN` hacia Chatwoot.

## Matriz de salud

| Servicio | Verificación |
|---|---|
| Caddy | Los dominios responden por HTTPS |
| n8n | Interfaz accesible y workflow ejecutable |
| Chatwoot | Panel accesible y Sidekiq procesando |
| PostgreSQL | `pg_isready` y consultas correctas |
| Redis | `PING` devuelve `PONG` con autenticación |
| OpenAI | Prueba controlada de texto y audio |
| WhatsApp | Mensaje real enviado y recibido |
