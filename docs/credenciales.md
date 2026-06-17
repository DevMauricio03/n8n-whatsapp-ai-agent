# Credenciales y Configuración

## Descripción General

La plataforma requiere la configuración de diferentes credenciales y servicios externos para funcionar correctamente.

Por razones de seguridad, ninguna credencial real debe almacenarse dentro del repositorio.

Este documento describe únicamente qué configuraciones son necesarias para desplegar la plataforma en un nuevo entorno.

## Servicios que Requieren Configuración

- WhatsApp Cloud API.
- OpenAI.
- Chatwoot.
- PostgreSQL.
- Redis.
- n8n.

## Recomendaciones de Seguridad

- No almacenar credenciales dentro del repositorio.
- Utilizar variables de entorno cuando sea posible.
- Limitar permisos de acceso a las API utilizadas.
- Rotar credenciales periódicamente.
- Mantener respaldos seguros de la configuración.

## WhatsApp Cloud API

Para la integración con WhatsApp es necesario configurar los siguientes elementos:

| Configuración | Descripción |
|--------------|-------------|
| Access Token | Token de acceso generado desde Meta Developers. |
| Phone Number ID | Identificador del número asociado a WhatsApp Business. |
| Business Account ID | Identificador de la cuenta de negocio. |
| Webhook URL | Endpoint utilizado para recibir eventos de WhatsApp. |
| Verify Token | Token utilizado para validar el Webhook. |

### Verificación

Antes de poner en marcha la plataforma se debe verificar:

- Recepción de eventos.
- Envío de mensajes.
- Correcta validación del Webhook.
- Acceso al número configurado.

## OpenAI

El agente de Inteligencia Artificial requiere una credencial de OpenAI configurada dentro de n8n.

| Configuración | Descripción |
|--------------|-------------|
| API Key | Clave de acceso utilizada para consumir los modelos de OpenAI. |
| Modelo Utilizado | Modelo configurado para el procesamiento de consultas. |

### Verificación

Antes de habilitar el workflow se debe verificar:

- Acceso correcto a la API.
- Disponibilidad de créditos.
- Generación exitosa de respuestas.
- Funcionamiento de las herramientas conectadas al agente.

### Recomendaciones

- No almacenar la API Key dentro de workflows exportados.
- Utilizar las credenciales seguras de n8n.
- Limitar el acceso a usuarios autorizados.

## PostgreSQL

La plataforma utiliza PostgreSQL para almacenamiento de información estructurada y memoria conversacional.

| Configuración | Descripción |
|--------------|-------------|
| Host | Dirección o nombre del servidor PostgreSQL. |
| Puerto | Puerto de conexión a PostgreSQL. |
| Base de Datos | Base de datos utilizada por la plataforma. |
| Usuario | Usuario con permisos de acceso. |
| Contraseña | Contraseña asociada al usuario configurado. |

### Uso dentro de la plataforma

PostgreSQL es utilizado para:

- Almacenamiento de memoria conversacional.
- Consulta de información de clientes.
- Consulta de información asociada a folios.
- Persistencia de información utilizada por el agente.

### Verificación

Antes de habilitar el sistema se debe verificar:

- Conectividad con la base de datos.
- Existencia de las tablas requeridas.
- Permisos de lectura y escritura.
- Correcto funcionamiento de las consultas utilizadas por el agente.

## Redis

Redis es utilizado para almacenamiento temporal de información y control de estados conversacionales.

| Configuración | Descripción |
|--------------|-------------|
| Host | Dirección o nombre del servidor Redis. |
| Puerto | Puerto de conexión a Redis. |
| Contraseña | Contraseña de acceso si se encuentra habilitada. |

### Uso dentro de la plataforma

Redis es utilizado para:

- Human Handoff.
- Buffer Conversacional.
- Control temporal de sesiones.
- Almacenamiento de estados transitorios.
- Coordinación de mensajes pendientes de procesamiento.

### Verificación

Antes de habilitar el sistema se debe verificar:

- Conectividad con Redis.
- Permisos de acceso.
- Lectura y escritura de claves.
- Funcionamiento correcto del Human Handoff.
- Funcionamiento correcto del Buffer Conversacional.

## Chatwoot

Chatwoot requiere configuración para la gestión de conversaciones y la integración con los canales de comunicación.

| Configuración | Descripción |
|--------------|-------------|
| URL Pública | Dirección utilizada para acceder a Chatwoot. |
| Cuenta Administrativa | Usuario con permisos de administración. |
| Base de Datos | Configuración de PostgreSQL utilizada por Chatwoot. |
| Redis | Configuración de Redis utilizada por Chatwoot. |
| Canal de WhatsApp | Integración configurada para la recepción y envío de mensajes. |

### Uso dentro de la plataforma

Chatwoot es utilizado para:

- Centralización de conversaciones.
- Atención por agentes humanos.
- Supervisión de conversaciones.
- Integración con n8n.
- Gestión de contactos.

### Verificación

Antes de habilitar el sistema se debe verificar:

- Acceso a la interfaz administrativa.
- Recepción de conversaciones.
- Envío de mensajes.
- Correcta integración con WhatsApp.
- Correcta integración con n8n.

## n8n

n8n actúa como el motor principal de automatización y orquestación de la plataforma.

| Configuración | Descripción |
|--------------|-------------|
| URL Pública | Dirección utilizada para acceder a la interfaz de n8n. |
| Usuario Administrador | Cuenta con permisos para administrar workflows y credenciales. |
| OpenAI Credential | Credencial utilizada por el agente de Inteligencia Artificial. |
| PostgreSQL Credential | Credencial utilizada para consultas y memoria conversacional. |
| Redis Credential | Credencial utilizada para Human Handoff y Buffer Conversacional. |
| Chatwoot Credential | Configuración utilizada para la integración con Chatwoot. |
| WhatsApp Cloud API Credential | Configuración utilizada para la comunicación con WhatsApp. |

### Uso dentro de la plataforma

n8n es utilizado para:

- Recepción de eventos.
- Orquestación de workflows.
- Ejecución del agente de Inteligencia Artificial.
- Integración con servicios externos.
- Procesamiento de mensajes.
- Automatización de procesos de negocio.

### Verificación

Antes de habilitar la plataforma se debe verificar:

- Acceso a la interfaz de administración.
- Correcta configuración de credenciales.
- Funcionamiento de los workflows.
- Comunicación con servicios externos.
- Activación de los workflows necesarios.