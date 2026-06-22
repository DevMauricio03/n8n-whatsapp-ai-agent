# Seguridad y privacidad

## Acciones inmediatas

El historial anterior incluyó un token de WhatsApp. Debe revocarse y reemplazarse. La copia actual del workflow ya no contiene ese token.

## Controles mínimos

- HTTPS obligatorio.
- Solo Caddy expuesto a Internet.
- SSH mediante llaves y acceso limitado.
- Firewall con los puertos estrictamente necesarios.
- MFA para proveedores y paneles.
- Credenciales distintas por entorno.
- Principio de mínimo privilegio.
- Backups cifrados y pruebas de restauración.
- Actualizaciones controladas.
- Revisión periódica de usuarios.

## Datos personales

La plataforma puede procesar:

- números telefónicos;
- nombres y correos;
- mensajes y audios;
- folios, pagos y resultados;
- metadatos de conversaciones.

La organización debe definir:

- finalidad y base legal;
- aviso de privacidad;
- consentimiento cuando corresponda;
- periodo de retención;
- procedimiento de acceso, corrección y eliminación;
- proveedores que reciben datos;
- responsables de incidentes.

## Uso de IA

- Envía solo el contexto necesario.
- No incluyas resultados o datos sensibles si no son indispensables.
- No permitas que el modelo invente información empresarial.
- Valida permisos antes de revelar un folio.
- Revisa políticas de retención y tratamiento del proveedor.
- Documenta cuándo una respuesta es automatizada.

## Webhooks

- Usa rutas difíciles de adivinar como defensa secundaria, nunca como control único.
- Verifica firmas o tokens si el proveedor los ofrece.
- Rechaza payloads inesperados.
- Limita tamaño y frecuencia.
- No registres encabezados de autorización.

## Gestión de secretos

- `.env` nunca se versiona.
- Los exports de n8n deben revisarse antes de commit.
- No pegues tokens en nodos HTTP.
- Rota secretos ante cualquier exposición.
- Conserva `N8N_ENCRYPTION_KEY` fuera del repositorio.

## Revisión antes de publicar

```bash
rg -n -i \
  'bearer |api[_ -]?key|secret|password|token|phoneNumberId|BEGIN .*PRIVATE KEY' \
  . \
  -g '!*.png' \
  -g '!.git/**'
```

La búsqueda genera falsos positivos en documentación, pero cualquier valor real debe investigarse.

## Historial Git

Eliminar un archivo no elimina versiones previas. Si el repositorio va a hacerse público:

1. crea un respaldo;
2. revoca primero los secretos;
3. identifica commits afectados;
4. coordina con colaboradores;
5. reescribe historial con una herramienta especializada;
6. fuerza la actualización remota;
7. elimina clones y cachés antiguos cuando sea posible.

La reescritura no sustituye la revocación.
