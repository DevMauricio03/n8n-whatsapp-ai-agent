# Despliegue

## Infraestructura Base

La plataforma se despliega sobre un servidor VPS con Ubuntu Server 24.04 LTS.

Los servicios principales se ejecutan mediante contenedores Docker administrados con Docker Compose.

Componentes desplegados:

- Caddy
- n8n
- Chatwoot
- PostgreSQL
- Redis
- Integración con WhatsApp Cloud API
- Integración con OpenAI

La comunicación entre los servicios se realiza mediante una red Docker compartida denominada `n8n_evo_net`.

El acceso externo se expone mediante Caddy, que actúa como Reverse Proxy y administra automáticamente los certificados SSL utilizados por la plataforma.

Los servicios principales son accesibles mediante dominios públicos configurados sobre HTTPS.

## Arquitectura de Despliegue

```text
Internet
│
├── estadian8n.ninja
└── chat.estadian8n.ninja
        │
        ▼
      Caddy
        │
 ┌──────┴──────┐
 │             │
 ▼             ▼
n8n       Chatwoot
 │
 ├── PostgreSQL
 │
 └── Redis
 │
 ├── WhatsApp Cloud API
 │
 └── OpenAI
```

## Red Interna

Todos los servicios se comunican mediante la red Docker compartida:

```text
n8n_evo_net
```

Esta red permite la comunicación entre los diferentes componentes sin exponer servicios internos directamente a Internet.