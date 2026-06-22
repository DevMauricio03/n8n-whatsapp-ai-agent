# Credenciales y variables

## Regla principal

Nunca guardes tokens, contraseñas, claves privadas ni exports de credenciales dentro del repositorio. `.env.example` contiene únicamente nombres y valores ficticios; `.env` está ignorado por Git.

## Variables de infraestructura

| Variable | Uso |
|---|---|
| `N8N_DOMAIN` | Dominio público de n8n |
| `CHATWOOT_DOMAIN` | Dominio público de Chatwoot |
| `LETSENCRYPT_EMAIL` | Contacto para certificados |
| `POSTGRES_USER` | Usuario de PostgreSQL |
| `POSTGRES_PASSWORD` | Contraseña de PostgreSQL |
| `REDIS_PASSWORD` | Contraseña de Redis |
| `N8N_ENCRYPTION_KEY` | Cifra credenciales almacenadas por n8n |
| `CHATWOOT_SECRET_KEY_BASE` | Firma sesiones y datos de Chatwoot |

`N8N_ENCRYPTION_KEY` y `CHATWOOT_SECRET_KEY_BASE` deben respaldarse de forma segura. Perderlas puede impedir recuperar información cifrada o sesiones.

## Credenciales dentro de n8n

| Credencial | Configuración |
|---|---|
| OpenAI | API key y proyecto autorizado |
| PostgreSQL | Host `postgres`, puerto `5432`, base `agent` |
| Redis | Host `redis`, puerto `6379`, contraseña configurada |
| WhatsApp Business Cloud | Token y Phone Number ID |
| Google Drive OAuth2 | Cliente OAuth y permisos mínimos |

Después de importar el workflow, cada nodo debe asociarse manualmente a la credencial correspondiente.

## Variables del workflow

| Variable | Uso |
|---|---|
| `WHATSAPP_GRAPH_API_VERSION` | Versión de Graph API |
| `WHATSAPP_PHONE_NUMBER_ID` | Envío de mensajes |
| `GOOGLE_DRIVE_SOURCE_FILE_ID` | Archivo XLSX observado |
| `PRICE_IMAGE_PACKAGE_1_URL` | Imagen de paquete 1 |
| `PRICE_IMAGE_PACKAGE_2_URL` | Imagen de paquete 2 |
| `PRICE_IMAGE_ANALYSIS_URL` | Imagen de análisis |

Los nodos HTTP de descarga de medios deben usar una credencial `HTTP Header Auth` con:

```text
Authorization: Bearer <TOKEN_DE_WHATSAPP>
```

No guardes ese encabezado directamente en el workflow. Cuando sea posible, prefiere el almacén de credenciales de n8n sobre variables visibles para todos los nodos.

## Generación de secretos

Ejemplo:

```bash
openssl rand -hex 32
```

Genera valores distintos para cada secreto.

## Rotación

1. Genera la nueva credencial.
2. Actualízala en el proveedor y en n8n o `.env`.
3. Reinicia únicamente los servicios necesarios.
4. Ejecuta pruebas de recepción y envío.
5. Revoca la credencial anterior.
6. Registra fecha, responsable y resultado.

## Secreto detectado en historial

El workflow original contenía un token de WhatsApp. Debe considerarse comprometido aunque el repositorio sea privado.

Acciones:

- revocarlo desde Meta;
- revisar accesos y uso;
- generar otro;
- almacenarlo correctamente;
- decidir, con respaldo previo, si se reescribirá el historial de Git.

Reescribir historial cambia identificadores de commits y requiere coordinación con cualquier clon existente.
