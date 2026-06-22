# Operación

## Revisión diaria

- Los dominios responden por HTTPS.
- Los contenedores están en ejecución.
- No hay crecimiento inesperado de errores.
- Hay espacio disponible en disco.
- WhatsApp recibe y envía mensajes.
- Chatwoot procesa tareas en segundo plano.

```bash
docker compose --env-file .env -f docker/docker-compose.yml ps
df -h
```

## Logs

```bash
docker compose --env-file .env -f docker/docker-compose.yml logs --since=1h n8n
docker compose --env-file .env -f docker/docker-compose.yml logs --since=1h chatwoot-rails
docker compose --env-file .env -f docker/docker-compose.yml logs --since=1h chatwoot-sidekiq
docker compose --env-file .env -f docker/docker-compose.yml logs --since=1h caddy
```

No copies logs con teléfonos, mensajes o tokens a canales públicos.

## Alta de un agente

1. Crea la cuenta en Chatwoot.
2. Aplica el rol mínimo necesario.
3. Asigna únicamente las bandejas requeridas.
4. Habilita MFA cuando esté disponible.
5. Prueba Human Handoff.
6. Registra responsable y fecha.

## Baja de un agente

1. Revoca acceso a Chatwoot.
2. Revoca acceso al servidor y n8n si existe.
3. Rota credenciales compartidas.
4. Revisa sesiones activas.
5. Registra la baja.

## Cambio de horario

El horario actual está implementado en el nodo `Code in JavaScript1`. Después de modificarlo:

- prueba límite de apertura;
- prueba límite de cierre;
- prueba fin de semana;
- revisa zona horaria;
- documenta días festivos por separado.

## Cambio de precios o servicios

Los textos del workflow y las imágenes deben actualizarse como una sola versión. Antes de publicar:

- aprobación del responsable de negocio;
- coincidencia entre imagen y texto;
- prueba de cada clave `INFO_PRECIOS_*`;
- fecha de vigencia;
- reversión disponible.

## Limpieza y capacidad

- Define retención de ejecuciones de n8n.
- Vigila tamaño de PostgreSQL y volúmenes.
- Elimina imágenes Docker sin uso con precaución.
- No borres volúmenes como método de liberar espacio.

## Incidentes

Prioridad sugerida:

- P1: envíos incorrectos, exposición de datos o indisponibilidad total.
- P2: audio, consultas o Human Handoff fallan parcialmente.
- P3: problema visual o administrativo sin impacto al cliente.

Para P1, desactiva primero el workflow si continuar operando puede causar daño.
