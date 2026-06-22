\connect agent

CREATE TABLE IF NOT EXISTS bd_clientes (
    folio text PRIMARY KEY,
    razon_social text,
    telefono text,
    correo text,
    materia_prima text,
    estatus_pago text,
    aplica_convenio text,
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_bd_clientes_telefono
    ON bd_clientes (telefono);

-- n8n crea la tabla de memoria al configurar Postgres Chat Memory.
-- Se documenta su estructura esperada, pero no se crea aquí para evitar
-- incompatibilidades entre versiones del nodo.
