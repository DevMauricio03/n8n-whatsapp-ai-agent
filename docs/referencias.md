# Referencias oficiales

Consulta siempre la documentación de la versión que vas a desplegar.

- [n8n con Docker Compose](https://docs.n8n.io/hosting/installation/server-setups/docker-compose/)
- [Variables de entorno de n8n](https://docs.n8n.io/hosting/configuration/environment-variables/)
- [Despliegue Docker de Chatwoot](https://developers.chatwoot.com/self-hosted/deployment/docker)
- [Variables de entorno de Chatwoot](https://developers.chatwoot.com/self-hosted/configuration/environment-variables)
- [HTTPS automático de Caddy](https://caddyserver.com/docs/automatic-https)
- [Docker Engine en Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [WhatsApp Cloud API](https://developers.facebook.com/docs/whatsapp/cloud-api/)
- [Buenas prácticas de seguridad de OpenAI](https://platform.openai.com/docs/guides/safety-best-practices)

## Política de versiones

Las etiquetas incluidas en `.env.example` son una línea base legible, no una promesa de compatibilidad futura.

Para producción:

1. selecciona versiones compatibles;
2. registra la fecha de validación;
3. fija la etiqueta exacta o digest;
4. prueba en staging;
5. actualiza deliberadamente, nunca de forma automática.
