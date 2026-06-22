# Plan de pruebas

Usa datos ficticios y un número de prueba. Registra fecha, versión, resultado y evidencia.

## Casos de aceptación

| ID | Escenario | Resultado esperado |
|---|---|---|
| MSG-01 | Enviar saludo | Una respuesta breve y en español |
| MSG-02 | Enviar tres mensajes rápidos | Una sola respuesta con el contenido agrupado |
| MSG-03 | Enviar audio válido | Transcripción y respuesta correctas |
| MSG-04 | Enviar audio inválido | Error controlado, sin respuesta inventada |
| MSG-05 | Enviar imagen o sticker | Se ignora o responde según política definida |
| AI-01 | Preguntar por un servicio | Orientación sin inventar información |
| AI-02 | Preguntar por precio general | Se envía el recurso correcto |
| AI-03 | Proporcionar folio existente | Se devuelve únicamente información autorizada |
| AI-04 | Proporcionar folio inexistente | Se informa que no fue encontrado |
| AI-05 | Pregunta fuera de alcance | El agente limita su respuesta |
| HH-01 | Agente humano responde | Se crea la clave Redis |
| HH-02 | Cliente escribe durante handoff | La IA no responde |
| HH-03 | Expira el TTL | Regresa el modo automático |
| HH-04 | Redis no disponible | La automatización falla de forma segura |
| TIME-01 | Mensaje dentro del horario | Se ejecuta la IA |
| TIME-02 | Mensaje fuera del horario | Se envía aviso y no se ejecuta la IA |
| TIME-03 | Fin de semana | Se aplica política fuera de horario |
| DATA-01 | Cambia el XLSX | Se actualiza `bd_clientes` |
| DATA-02 | Fila duplicada por folio | Se actualiza, no se duplica |
| SEC-01 | Webhook con payload incompleto | No filtra secretos ni rompe el flujo completo |
| OPS-01 | Reinicio de servicios | Datos y configuración persisten |
| BAK-01 | Restauración en entorno aislado | Servicios y datos recuperados |

## Prueba mínima antes de cada release

Ejecuta como mínimo:

- MSG-01;
- MSG-02;
- AI-03;
- HH-01 y HH-02;
- TIME-01 y TIME-02;
- DATA-01;
- OPS-01.

## Evidencia

Para cada caso conserva:

```text
ID:
Fecha:
Entorno:
Versión:
Datos usados:
Resultado esperado:
Resultado obtenido:
Evidencia:
Responsable:
```

Oculta teléfonos, nombres, correos, tokens y contenido sensible en capturas.
