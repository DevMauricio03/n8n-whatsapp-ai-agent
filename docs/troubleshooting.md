# Solución de problemas

## Los dominios no abren

Comprueba:

```bash
getent hosts "$N8N_DOMAIN"
docker compose --env-file .env -f docker/docker-compose.yml ps
docker compose --env-file .env -f docker/docker-compose.yml logs --tail=100 caddy
```

Causas comunes:

- DNS todavía no propagado;
- puertos 80/443 bloqueados;
- dominio incorrecto en `.env`;
- Caddy sin acceso a Internet;
- otro servicio ocupa el puerto.

## Chatwoot no inicia

```bash
docker compose --env-file .env -f docker/docker-compose.yml logs --tail=200 chatwoot-prepare
docker compose --env-file .env -f docker/docker-compose.yml logs --tail=200 chatwoot-rails
docker compose --env-file .env -f docker/docker-compose.yml logs --tail=200 chatwoot-sidekiq
```

Revisa PostgreSQL, Redis, `SECRET_KEY_BASE`, versión de imagen y migraciones.

## n8n no puede conectar a PostgreSQL

- Host: `postgres`.
- Puerto: `5432`.
- Base interna de n8n: `n8n`.
- Base del workflow: `agent`.
- Usuario y contraseña deben coincidir con `.env`.

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec postgres sh -lc 'pg_isready -U "$POSTGRES_USER" -d n8n'
```

## Redis devuelve error de autenticación

Configura la misma `REDIS_PASSWORD` en servidor, Chatwoot y credencial de n8n.

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec redis sh -lc 'redis-cli -a "$REDIS_PASSWORD" PING'
```

## El webhook no ejecuta el workflow

- El workflow debe estar activo.
- Usa `/webhook/`, no `/webhook-test/`.
- Revisa método POST y ruta.
- Confirma que Chatwoot envía el evento.
- Revisa Caddy y ejecuciones de n8n.

## La IA responde dos veces

- Confirma que solo `incoming` entra al flujo automático.
- Revisa si hay dos webhooks configurados.
- Comprueba la lógica del buffer.
- Busca ejecuciones duplicadas con el mismo evento.

## La IA responde durante atención humana

- Confirma que el evento saliente crea la clave.
- Compara formato de teléfono o conversación.
- Consulta TTL.
- Comprueba que ambos nodos usan exactamente la misma clave.

## El audio falla

- Verifica permisos del token de Meta.
- Confirma versión de Graph API.
- Revisa URL de descarga y archivo binario.
- Confirma formato aceptado por transcripción.
- Asegura un mensaje de error seguro para el cliente.

## Google Drive no actualiza datos

- Reautoriza OAuth.
- Confirma ID del archivo.
- Revisa el encabezado del XLSX.
- Ejecuta manualmente desde `Google Drive Trigger`.
- Comprueba restricciones y clave primaria `folio`.

## Los scripts SQL no se ejecutaron

Solo se ejecutan al crear el volumen de PostgreSQL. No elimines el volumen productivo para repetirlos. Aplica la migración manualmente después de un respaldo.
