# Human Handoff

Human Handoff evita que la IA responda mientras un agente humano atiende la conversación desde Chatwoot.

## Estado

El workflow actual usa una clave Redis similar a:

```text
human_mode:human_mode:<telefono>
```

Valor:

```text
true
```

TTL actual:

```text
1800 segundos (30 minutos)
```

Para una implementación nueva se recomienda:

```text
human_mode:<account_id>:<conversation_id>
```

Esto evita colisiones si un teléfono aparece en más de una bandeja o cuenta.

## Activación

1. Un agente envía un mensaje desde Chatwoot.
2. Chatwoot emite un evento saliente.
3. n8n identifica que no es un mensaje `incoming`.
4. n8n establece la clave con TTL.
5. Los mensajes siguientes del cliente no pasan al agente de IA.

## Desactivación

En la implementación actual el estado expira automáticamente. La operación recomendada añade una acción explícita al cerrar o resolver la conversación:

```redis
DEL human_mode:<account_id>:<conversation_id>
```

No debe eliminarse el bloqueo mientras un agente siga escribiendo.

## Renovación

Cada nueva respuesta humana debe renovar el TTL. Si la atención suele durar más de 30 minutos, ajusta el valor según métricas reales, no de forma arbitraria.

## Verificación

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec redis sh -lc 'redis-cli -a "$REDIS_PASSWORD" GET "human_mode:human_mode:<telefono>"'
```

Consultar TTL:

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec redis sh -lc 'redis-cli -a "$REDIS_PASSWORD" TTL "human_mode:human_mode:<telefono>"'
```

## Casos límite

- Si Redis no está disponible, la opción segura es no responder automáticamente.
- Si el agente humano contesta cerca de la expiración, el TTL debe renovarse.
- Si un evento saliente automático se confunde con uno humano, puede bloquear la conversación sin necesidad.
- Si el teléfono cambia de formato, la clave puede dejar de coincidir.

Consulta los escenarios HH-01 a HH-04 en [Pruebas](pruebas.md).
