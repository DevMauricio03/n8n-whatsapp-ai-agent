SELECT 'CREATE DATABASE n8n'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n') \gexec

SELECT 'CREATE DATABASE chatwoot'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'chatwoot') \gexec

SELECT 'CREATE DATABASE agent'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'agent') \gexec
