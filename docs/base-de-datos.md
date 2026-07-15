# Base de datos

![Arquitectura de Base de Datos](./diagramas/base-datos.png)

## Estructura

PostgreSQL aloja tres bases lógicamente separadas:

| Base | Propósito |
|---|---|
| `n8n` | Configuración, credenciales cifradas y ejecuciones |
| `chatwoot` | Conversaciones, contactos y configuración |
| `agent` | Datos empresariales y memoria conversacional |

### Modelo de Datos de `agent` (Diagrama ER)

A continuación, la estructura relacional de la base de datos operativa y conversacional del agente:

```mermaid
erDiagram
    bd_clientes {
        varchar(50) folio PK
        varchar(255) razon_social
        varchar(50) telefono UK "Usado como session_id"
        varchar(255) correo
        varchar(255) materia_prima
        varchar(50) estatus_pago
        varchar(50) aplica_convenio
    }

    catalogo_operativo {
        varchar(50) codigo PK
        varchar(100) categoria FK
        varchar(100) subcategoria
        varchar(255) titulo
        text contenido
        text palabras_clave
        int prioridad
        boolean activo
    }

    configuracion {
        varchar(100) clave PK
        text valor
        text descripcion
        boolean activo
    }

    intenciones {
        varchar(100) intencion PK
        text descripcion
        boolean requiere_cliente
        boolean requiere_transferencia
        boolean consultar_catalogo
        varchar(100) categoria FK
        boolean activo
    }

    n8n_chat_histories {
        int id PK
        varchar(255) session_id FK
        jsonb message
    }

    respuestas_fijas {
        varchar(100) codigo PK
        text mensaje
        boolean activo
    }

    %% Relaciones Lógicas (Llaves Foráneas Conceptuales)
    bd_clientes ||--o{ n8n_chat_histories : "tiene historial (telefono = session_id)"
    intenciones }|--|{ catalogo_operativo : "filtra búsqueda por (categoria)"
```

### Relaciones Lógicas vs Tablas Globales

En arquitecturas ágiles controladas por n8n e IA, es común utilizar conexiones lógicas (gestionadas por la lógica del flujo) en lugar de restricciones físicas (*Foreign Keys*) a nivel de motor de base de datos. 

* **Conexiones Lógicas Fuertes:**
  * **`bd_clientes` ↔ `n8n_chat_histories`:** Se enlazan conceptualmente mediante el número de teléfono. El campo `telefono` del cliente actúa como el `session_id` del historial de chat, permitiendo a la IA recuperar la memoria de esa conversación en específico.
  * **`intenciones` ↔ `catalogo_operativo`:** Se enlazan a través del campo `categoria`. Cuando la IA clasifica la intención del usuario, utiliza su categoría para buscar información únicamente dentro de los registros del catálogo que comparten esa misma categoría, garantizando precisión en la respuesta.

* **Tablas Globales (Sin relaciones explícitas):**
  Existen tablas "sueltas" que funcionan como diccionarios de consulta general. No se enlazan con un usuario porque aplican para todo el sistema por igual:
  * **`configuracion`:** Almacena parámetros globales del negocio (ej. horarios de atención).
  * **`respuestas_fijas`:** Almacena plantillas estáticas de texto (ej. saludos o mensajes de error predefinidos). 
  El sistema acude a estas tablas bajo demanda de manera aislada.

## Tabla `bd_clientes`

Se crea mediante [02-agent-schema.sql](../docker/initdb/02-agent-schema.sql).

| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| `folio` | `text` | Clave primaria | Identificador del servicio |
| `razon_social` | `text` | Opcional | Cliente o empresa |
| `telefono` | `text` | Opcional, indexado | Teléfono asociado |
| `correo` | `text` | Opcional | Correo registrado |
| `materia_prima` | `text` | Opcional | Muestra o producto |
| `estatus_pago` | `text` | Opcional | Estado del pago |
| `aplica_convenio` | `text` | Opcional | Convenio comercial |
| `updated_at` | `timestamptz` | Predeterminado `now()` | Última actualización |

Ejemplo ficticio:

```sql
INSERT INTO bd_clientes (
  folio, razon_social, telefono, correo, materia_prima,
  estatus_pago, aplica_convenio
) VALUES (
  'DEMO-2026-0001', 'Cliente de prueba', '520000000000',
  'demo@example.com', 'Muestra de prueba', 'PENDIENTE', 'NO'
)
ON CONFLICT (folio) DO UPDATE SET
  estatus_pago = EXCLUDED.estatus_pago,
  updated_at = now();
```

## Memoria conversacional

El nodo `Postgres Chat Memory` crea o utiliza una tabla compatible con la versión instalada de n8n. En el workflow revisado la sesión se identifica mediante el teléfono.

Recomendaciones:

- usar un identificador no reutilizable cuando sea posible;
- definir una política de retención;
- evitar guardar información innecesaria;
- comprobar que un agente no pueda consultar conversaciones ajenas;
- no crear manualmente la tabla sin verificar el esquema esperado por la versión del nodo.

## Acceso

Desde el contenedor:

```bash
docker compose --env-file .env -f docker/docker-compose.yml \
  exec postgres sh -lc 'psql -U "$POSTGRES_USER" -d agent'
```

Comprobaciones:

```sql
\dt
SELECT count(*) FROM bd_clientes;
SELECT folio, estatus_pago, updated_at
FROM bd_clientes
ORDER BY updated_at DESC
LIMIT 10;
```

## Migraciones

Los scripts de `docker/initdb/` solo se ejecutan cuando el volumen de PostgreSQL se crea por primera vez. Para entornos existentes:

1. crea un respaldo;
2. aplica el cambio manualmente o mediante una herramienta de migración;
3. registra la fecha y versión;
4. prueba lectura y escritura;
5. conserva un procedimiento de reversión.

## Retención sugerida

La organización debe definirla según su base legal. Como punto de partida:

- ejecuciones exitosas de n8n: retención corta;
- ejecuciones con error: suficiente para diagnóstico;
- memoria conversacional: solo el periodo necesario para atención;
- respaldos: cifrados y con caducidad;
- datos de clientes: según contrato y regulación aplicable.
