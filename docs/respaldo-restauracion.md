# Respaldo y restauración

Un respaldo no se considera válido hasta que se restaura correctamente en un entorno aislado.

## Qué respaldar

- Bases `n8n`, `chatwoot` y `agent`.
- Volumen `n8n_data`.
- Volumen `chatwoot_storage`.
- Datos persistentes de Redis si son necesarios.
- `.env` y claves, en un almacén cifrado separado.
- Caddy y archivos de infraestructura.
- Versiones exactas de las imágenes desplegadas.

## PostgreSQL

Crear directorio local:

```bash
mkdir -p backups
```

Respaldar todas las bases:

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec -T postgres sh -lc 'pg_dumpall -U "$POSTGRES_USER"' \
  > backups/postgres-all.sql
```

Si cambiaste el usuario, reemplaza `platform`.

Restaurar en una instancia vacía:

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec -T postgres sh -lc 'psql -U "$POSTGRES_USER"' \
  < backups/postgres-all.sql
```

## Volúmenes

Detén escrituras o programa una ventana de mantenimiento antes de copiar volúmenes. Para producción, usa snapshots del proveedor o una herramienta de backup con consistencia y cifrado.

No documentes ni almacenes backups productivos dentro del repositorio.

## Redis

Redis se configura con AOF. Fuerza persistencia:

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec redis sh -lc 'redis-cli -a "$REDIS_PASSWORD" BGREWRITEAOF'
```

Redis contiene estado temporal; define si realmente necesitas restaurarlo o si es más seguro iniciar limpio.

## Frecuencia sugerida

| Elemento | Frecuencia inicial |
|---|---|
| PostgreSQL | Diario y antes de cada release |
| Volúmenes | Diario o según cambio |
| Configuración | En cada cambio |
| Prueba de restauración | Mensual y antes de cambios mayores |

La frecuencia final depende del RPO y RTO del negocio.

## Prueba de recuperación

1. Crea un servidor o proyecto aislado.
2. Usa dominios y credenciales de prueba.
3. Restaura PostgreSQL y volúmenes.
4. Confirma acceso a n8n y Chatwoot.
5. Comprueba credenciales cifradas.
6. Ejecuta BAK-01 y las pruebas mínimas.
7. Registra duración, errores y pasos faltantes.
