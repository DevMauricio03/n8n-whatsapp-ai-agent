# Human Handoff

## Descripción General

El sistema incorpora un mecanismo de Human Handoff que permite suspender temporalmente la atención automatizada cuando una conversación requiere intervención humana.

Cuando un agente humano toma control de una conversación, el sistema evita que los mensajes sean procesados por el agente de Inteligencia Artificial.

Esta funcionalidad permite combinar atención automatizada y atención humana dentro del mismo canal de comunicación.

## Objetivos

- Evitar respuestas automáticas durante la atención humana.
- Permitir la intervención de personal de soporte.
- Mantener continuidad en la conversación.
- Mejorar la experiencia del cliente.

## Funcionamiento

El mecanismo de Human Handoff utiliza Redis para almacenar un indicador temporal asociado a una conversación.

Cuando una conversación es transferida a un agente humano, se registra un estado temporal que bloquea el procesamiento automático de mensajes.

Cada nuevo mensaje recibido verifica primero si existe un estado activo de atención humana.

Si el estado existe:

- El mensaje no es enviado al agente de Inteligencia Artificial.
- El flujo automatizado se detiene.
- La conversación permanece bajo control humano.

Si el estado no existe:

- El mensaje continúa normalmente hacia el flujo automatizado.
- El agente de Inteligencia Artificial puede procesar la conversación.

Este mecanismo permite evitar conflictos entre respuestas automáticas y respuestas generadas por agentes humanos.

## Persistencia del Estado

El estado de atención humana se almacena temporalmente en Redis utilizando una clave asociada al identificador de la conversación.

Este estado posee un tiempo de expiración configurable (TTL), permitiendo que el sistema regrese automáticamente al modo de atención automatizada una vez finalizado el periodo definido.

Beneficios:
$
- No requiere intervención manual para restaurar el modo automático.
- Reduce el riesgo de conversaciones bloqueadas permanentemente.
- Permite una administración eficiente de recursos.
- Facilita la coexistencia entre automatización y atención humana.