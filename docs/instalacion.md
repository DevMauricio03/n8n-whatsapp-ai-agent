# Instalación

## Descripción General

Esta guía describe el proceso de instalación y despliegue de la plataforma de atención automatizada utilizada durante el desarrollo del proyecto.

La arquitectura se encuentra compuesta por los siguientes componentes:

- Ubuntu 24.04 LTS.
- Docker.
- Docker Compose.
- Caddy Reverse Proxy.
- n8n.
- Chatwoot.
- PostgreSQL.
- Redis.
- WhatsApp Cloud API.
- OpenAI.

## Orden de Instalación

Para desplegar correctamente la plataforma se recomienda seguir el siguiente orden:

1. Configuración del servidor Ubuntu.
2. Instalación de Docker.
3. Instalación de Docker Compose.
4. Creación de la red Docker compartida.
5. Despliegue de PostgreSQL.
6. Despliegue de Redis.
7. Despliegue de Chatwoot.
8. Despliegue de n8n.
9. Configuración de Caddy.
10. Configuración de dominios.
11. Configuración de WhatsApp Cloud API.
12. Configuración de OpenAI.
13. Importación de workflows.
14. Pruebas de funcionamiento.

## 1. Configuración del Servidor Ubuntu

La plataforma fue desplegada sobre un servidor Ubuntu 24.04 LTS.

Antes de instalar cualquier componente se recomienda actualizar completamente el sistema operativo.

### Actualización del sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### Verificación de la versión instalada

```bash
lsb_release -a
```

Resultado esperado:

```text
Ubuntu 24.04 LTS
```

## 2. Instalación de Docker

Docker es utilizado para ejecutar todos los servicios de la plataforma mediante contenedores.

### Instalación

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### Verificación

```bash
docker --version
```

Resultado esperado:

```text
Docker version XX.XX.X
```

### Habilitar inicio automático

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

## 3. Instalación de Docker Compose

Docker Compose permite administrar múltiples contenedores como una sola aplicación.

### Verificación de instalación

```bash
docker compose version
```

Resultado esperado:

```text
Docker Compose version v2.x.x
```

### Prueba de funcionamiento

```bash
docker compose ls
```

Este comando permite verificar que Docker Compose se encuentra disponible y funcionando correctamente.

## 4. Creación de la Red Docker Compartida

Todos los servicios de la plataforma se comunican mediante una red Docker compartida.

### Creación de la red

```bash
docker network create n8n_evo_net
```

### Verificación

```bash
docker network ls
```

Resultado esperado:

```text
n8n_evo_net
```

Esta red permite la comunicación entre:

- n8n.
- Chatwoot.
- PostgreSQL.
- Redis.
- Caddy.

Los contenedores pueden comunicarse utilizando sus nombres o alias definidos dentro de la red.

## 5. Despliegue de PostgreSQL

La plataforma utiliza PostgreSQL como base de datos principal para el almacenamiento de información persistente.

### Imagen utilizada

```text
pgvector/pgvector:pg15
```

### Verificar contenedores PostgreSQL

```bash
docker ps | grep postgres
```

Resultado esperado:

```text
postgres-evo
```

### Verificar conectividad

```bash
docker exec -it postgres-evo psql -U evo
```

### Verificar bases de datos disponibles

```sql
\l
```

La base de datos utilizada por n8n debe encontrarse disponible antes de iniciar la plataforma.

## 6. Despliegue de Redis

Redis es utilizado para almacenamiento temporal de información y mecanismos de control conversacional.

Entre sus principales funciones se encuentran:

- Human Handoff.
- Buffer Conversacional.
- Almacenamiento temporal de estados.
- Gestión de bloqueos temporales.

### Imagen utilizada

```text
redis:7-alpine
```

### Verificar contenedor Redis

```bash
docker ps | grep redis
```

Resultado esperado:

```text
redis-evo
```

### Verificar conectividad

```bash
docker exec -it redis-evo redis-cli
```

### Prueba de funcionamiento

```redis
PING
```

Resultado esperado:

```text
PONG
```

## 7. Despliegue de Chatwoot

Chatwoot es utilizado como plataforma de gestión de conversaciones y atención al cliente.

### Estructura del proyecto

```text
chatwoot/
├── docker-compose.production.yaml
└── .env
```

### Iniciar servicios

```bash
docker compose -f docker-compose.production.yaml up -d
```

### Verificar contenedores

```bash
docker ps | grep chatwoot
```

Resultado esperado:

```text
chatwoot-rails-1
chatwoot-sidekiq-1
```

### Verificar acceso

La plataforma debe encontrarse disponible mediante el dominio configurado para Chatwoot.

```text
https://chat.estadian8n.ninja
```

## 8. Despliegue de n8n

n8n es el motor principal de automatización utilizado por la plataforma.

### Estructura del proyecto

```text
n8n-docker/
├── docker-compose.yml
└── Caddyfile
```

### Iniciar servicios

```bash
docker compose up -d
```

### Verificar contenedores

```bash
docker ps | grep n8n
```

Resultado esperado:

```text
n8n
```

### Verificar acceso local

```bash
docker logs n8n
```

### Verificar acceso web

La plataforma debe encontrarse disponible mediante el dominio configurado.

```text
https://estadian8n.ninja
```

## 9. Configuración de Caddy

Caddy es utilizado como reverse proxy para exponer los servicios mediante HTTPS y administrar automáticamente los certificados SSL.

### Archivo de configuración

```text
Caddyfile
```

### Configuración utilizada

```caddy
estadian8n.ninja {
    reverse_proxy n8n:5678
}

chat.estadian8n.ninja {
    reverse_proxy chatwoot-rails-1:3000
}
```

### Iniciar servicios

```bash
docker compose up -d
```

### Verificar contenedor

```bash
docker ps | grep caddy
```

Resultado esperado:

```text
caddy
```

### Verificar HTTPS

Acceder desde un navegador a:

```text
https://estadian8n.ninja
https://chat.estadian8n.ninja
```

Los certificados SSL deben generarse automáticamente.

## 10. Configuración de Dominios

La plataforma requiere dominios públicos apuntando al servidor donde se encuentran desplegados los servicios.

### Dominios utilizados

```text
estadian8n.ninja
chat.estadian8n.ninja
```

### Configuración DNS

Se deben crear registros tipo A apuntando a la dirección IP pública del servidor.

Ejemplo:

```text
estadian8n.ninja        -> IP_DEL_SERVIDOR
chat.estadian8n.ninja   -> IP_DEL_SERVIDOR
```

### Verificación

Desde el servidor:

```bash
ping estadian8n.ninja
ping chat.estadian8n.ninja
```

Los dominios deben resolver hacia la IP pública configurada.

### Certificados SSL

Los certificados SSL son administrados automáticamente por Caddy una vez que los dominios resuelven correctamente hacia el servidor.

## 11. Configuración de WhatsApp Cloud API

La plataforma utiliza WhatsApp Cloud API como canal oficial para la recepción y envío de mensajes.

### Requisitos

- Cuenta de Meta Developers.
- Aplicación registrada en Meta.
- Número de WhatsApp configurado.
- Access Token.
- Phone Number ID.
- Webhook configurado.

### Configuración del Webhook

El webhook debe apuntar al endpoint configurado en la plataforma.

```text
https://DOMINIO_CONFIGURADO/webhook
```

### Permisos requeridos

La aplicación debe contar con permisos para:

- Recepción de mensajes.
- Envío de mensajes.
- Gestión de eventos de WhatsApp.

### Verificación

Enviar un mensaje desde un dispositivo de prueba y confirmar que el evento es recibido por el workflow principal de n8n.

## 12. Configuración de OpenAI

La plataforma utiliza OpenAI para el procesamiento de lenguaje natural y generación de respuestas automáticas.

### Requisitos

- Cuenta activa de OpenAI.
- API Key válida.
- Créditos disponibles.

### Configuración

La API Key debe almacenarse de forma segura dentro de las credenciales utilizadas por n8n.

Nunca debe almacenarse directamente dentro del repositorio.

### Uso dentro de la plataforma

OpenAI es utilizado para:

- Comprensión de consultas.
- Generación de respuestas.
- Gestión del contexto conversacional.
- Procesamiento de instrucciones del agente.
- Interacción con herramientas conectadas al workflow.

### Verificación

Realizar una consulta de prueba desde WhatsApp y verificar que el agente genere una respuesta correctamente.

## 13. Importación de Workflows

Una vez desplegada la infraestructura, es necesario importar los workflows utilizados por la plataforma.

### Procedimiento

1. Acceder a la interfaz de n8n.
2. Seleccionar la opción **Import from File**.
3. Seleccionar el archivo JSON correspondiente al workflow.
4. Verificar que todos los nodos hayan sido importados correctamente.
5. Configurar las credenciales requeridas.

### Credenciales requeridas

Dependiendo de la versión del workflow pueden requerirse credenciales para:

- OpenAI.
- PostgreSQL.
- Redis.
- WhatsApp Cloud API.
- Chatwoot.

### Verificación

Después de la importación:

1. Ejecutar una prueba manual.
2. Confirmar que no existan nodos con errores.
3. Verificar que todas las credenciales se encuentren asignadas correctamente.
4. Activar el workflow.

## 14. Pruebas de Funcionamiento

Una vez desplegada toda la plataforma, se recomienda realizar una validación completa de los componentes.

### Verificación de contenedores

```bash
docker ps
```

Verificar que los servicios necesarios se encuentren en estado operativo.

### Verificación de dominios

Acceder desde un navegador a:

```text
https://estadian8n.ninja
https://chat.estadian8n.ninja
```

### Verificación de n8n

1. Confirmar acceso a la interfaz.
2. Verificar que los workflows se encuentren activos.
3. Revisar que las credenciales estén configuradas correctamente.

### Verificación de Chatwoot

1. Confirmar acceso al panel administrativo.
2. Verificar la recepción de conversaciones.
3. Confirmar la conexión con WhatsApp.

### Verificación de PostgreSQL

```bash
docker exec -it postgres-evo psql -U evo
```

Confirmar acceso a la base de datos y disponibilidad de las tablas requeridas.

### Verificación de Redis

```bash
docker exec -it redis-evo redis-cli
```

Ejecutar:

```redis
PING
```

Resultado esperado:

```text
PONG
```

### Verificación de Mensajería

1. Enviar un mensaje desde WhatsApp.
2. Confirmar recepción en Chatwoot.
3. Confirmar ejecución del workflow en n8n.
4. Confirmar respuesta generada por el agente.
5. Confirmar entrega de la respuesta al cliente.