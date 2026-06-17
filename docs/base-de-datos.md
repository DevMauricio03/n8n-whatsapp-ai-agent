# Base de Datos

## Descripción General

La plataforma utiliza PostgreSQL como base de datos principal para el almacenamiento de información estructurada y memoria conversacional.

## Responsabilidades

- Almacenamiento de memoria conversacional.
- Consulta de información de clientes.
- Consulta de folios.
- Consulta de estados de pago.
- Consulta de resultados.
- Persistencia de información utilizada por el agente de Inteligencia Artificial.

## Tablas Principales

### bd_clientes

Tabla utilizada para almacenar la información consultada por el agente de Inteligencia Artificial.

Campos principales:

| Campo             | Descripción                                               |
|-------------------|-----------------------------------------------------------|
| folio             | Identificador del análisis o servicio.                    |
| razon_social      | Nombre o razón social del cliente.                        |
| telefono          | Número telefónico asociado al cliente.                    |
| correo            | Correo electrónico registrado.                            |
| materia_prima     | Información relacionada con la muestra o materia prima    |
|analizada.                                                                     |
| estatus_pago      | Estado actual del pago asociado al servicio.              |
| aplica_convenio   | Indicador de aplicación de convenio comercial.            |

### n8n_chat_histories

Tabla utilizada para almacenar la memoria conversacional del agente.

Campos principales:

| Campo      | Descripción                         |
|------------|-------------------------------------|
| id         | Identificador único del registro.   |
| session_id | Identificador de la conversación.   |
| message    | Mensaje almacenado en formato JSON. |

Esta tabla permite conservar contexto entre mensajes y mantener continuidad durante las conversaciones.

## Relacion con el Agente de Inteligencia Artificial

La base de datos PostgreSQL es utilizada por el agente de Inteligencia Artificial mediante herramientas conectadas al workflow de n8n.

### Funciones principales

- Consulta de información de clientes.
- Consulta de folios registrados.
- Consulta de estados de pago.
- Recuperación de información asociada a servicios.
- Persistencia de memoria conversacional.

### Flujo de consulta

1. El cliente envía un mensaje mediante WhatsApp.
2. El mensaje es procesado por el agente.
3. El agente determina si requiere información almacenada.
4. Se ejecuta una consulta sobre PostgreSQL.
5. La información obtenida es utilizada para construir la respuesta.
6. La respuesta es enviada nuevamente al cliente.

### Memoria Conversacional

La tabla `n8n_chat_histories` permite conservar el contexto de conversaciones previas.

Esto permite:

- Mantener continuidad entre mensajes.
- Recordar información previamente proporcionada por el cliente.
- Reducir solicitudes repetidas de información.
- Generar respuestas más coherentes y contextualizadas.