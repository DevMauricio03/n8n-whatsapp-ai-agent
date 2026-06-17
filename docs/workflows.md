# Workflows

## Workflow Principal de Atención Automatizada

El workflow principal es responsable de recibir mensajes desde WhatsApp, procesarlos mediante n8n y generar respuestas automáticas utilizando Inteligencia Artificial.

Este workflow integra mecanismos de control conversacional, procesamiento de audio, memoria conversacional, consultas de información y atención automatizada para clientes de Extracta.

### 1. Recepción del Mensaje

El workflow inicia mediante un Webhook conectado a Chatwoot.

Cada mensaje recibido contiene información relacionada con:

- Conversación.
- Cliente.
- Contenido del mensaje.
- Archivos adjuntos.
- Tipo de mensaje.

### 2. Validación de Human Handoff

Antes de iniciar cualquier procesamiento, el sistema consulta Redis para verificar si la conversación se encuentra bajo atención humana.

Si existe un estado activo de Human Handoff:

- El workflow se detiene.
- No se ejecuta el agente de Inteligencia Artificial.
- La conversación permanece bajo control humano.

Si no existe un estado activo:

- El mensaje continúa hacia el procesamiento automatizado.

### 3. Clasificación del Mensaje

El sistema identifica automáticamente el tipo de mensaje recibido.

Tipos soportados:

- Texto.
- Audio.

### 4. Procesamiento de Audio

Cuando el mensaje recibido corresponde a una nota de voz:

1. Se obtiene el archivo desde WhatsApp Cloud API.
2. Se descarga el contenido multimedia.
3. El audio es enviado al servicio de transcripción.
4. La transcripción obtenida se convierte en texto para continuar el flujo.

Una vez transcrito, el mensaje sigue exactamente el mismo proceso que un mensaje de texto convencional.

### 5. Buffer Conversacional

Antes de enviar información al agente de Inteligencia Artificial, los mensajes son almacenados temporalmente en Redis.

El objetivo es evitar que múltiples mensajes consecutivos generen respuestas independientes.

El sistema:

1. Almacena temporalmente cada mensaje recibido.
2. Espera un periodo de tiempo configurable.
3. Verifica si llegaron mensajes adicionales.
4. Agrupa todos los mensajes pendientes.
5. Genera una única consulta para el agente.

Beneficios:

- Reduce respuestas fragmentadas.
- Mejora la comprensión del contexto.
- Disminuye el consumo de recursos.
- Genera conversaciones más naturales.

### 6. Validación de Horario de Atención

Antes de procesar una consulta mediante Inteligencia Artificial, el sistema verifica si la solicitud fue recibida dentro del horario de atención establecido.

Si la consulta se recibe fuera del horario laboral:

- Se envía un mensaje informativo al cliente.
- No se ejecuta el agente de Inteligencia Artificial.
- La conversación queda registrada para atención posterior.

Si la consulta se recibe dentro del horario laboral:

- El flujo continúa normalmente.
- La solicitud es enviada al agente de Inteligencia Artificial.

### 7. Procesamiento mediante Inteligencia Artificial

Una vez validado el horario de atención, la consulta es enviada al agente de Inteligencia Artificial.

El agente utiliza:

- Instrucciones de comportamiento.
- Contexto conversacional.
- Memoria histórica de la conversación.
- Herramientas de consulta de información.

Entre sus funciones principales se encuentran:

- Responder preguntas sobre servicios.
- Orientar a los clientes sobre análisis disponibles.
- Solicitar información necesaria para consultas.
- Consultar información asociada a folios.
- Generar respuestas contextuales basadas en conversaciones previas.

### 8. Memoria Conversacional y Consulta de Información

El agente utiliza memoria conversacional almacenada en PostgreSQL para mantener contexto entre mensajes de una misma conversación.

Esto permite:

- Recordar información previamente proporcionada por el cliente.
- Mantener continuidad en conversaciones largas.
- Comprender referencias a mensajes anteriores.
- Reducir solicitudes repetidas de información.

Adicionalmente, el agente puede utilizar herramientas de consulta para obtener información almacenada en la base de datos cuando el cliente proporciona datos válidos para realizar búsquedas.

### 9. Generación y Envío de Respuestas

Después de procesar la solicitud, el sistema clasifica la respuesta generada.

Dependiendo del tipo de información solicitada, el workflow puede:

- Enviar una respuesta de texto.
- Enviar información complementaria mediante imágenes.
- Enviar información relacionada con paquetes o análisis específicos.

Todas las respuestas son enviadas mediante WhatsApp Cloud API hacia el cliente.

El objetivo es proporcionar información clara, consistente y fácil de consultar desde dispositivos móviles.

## Workflow de Sincronización de Datos

Además del workflow principal de atención automatizada, el sistema cuenta con un workflow dedicado a la actualización de información utilizada por el agente.

### Flujo General

1. Se detectan cambios en una fuente de datos.
2. Se obtiene el archivo actualizado.
3. Se extrae la información necesaria.
4. Los registros son insertados o actualizados en PostgreSQL.
5. La información queda disponible para futuras consultas realizadas por el agente.

### Objetivo

Mantener actualizada la información utilizada por el sistema sin necesidad de modificaciones manuales en la base de datos.