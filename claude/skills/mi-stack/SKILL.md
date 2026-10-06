---
name: mi-stack
description: Mis preferencias técnicas y convenciones para proyectos web (frontend, backend con Cloudflare Workers/D1 o PHP/Supabase, secretos, tests y despliegue). Úsala al crear un proyecto nuevo, al planificar una funcionalidad o al elegir librerías, stack o despliegue.
---

# Mi stack y convenciones

Guía base. Si el proyecto tiene `AGENTS.md` o `CLAUDE.md` con otras reglas, mandan esas.

## Principios
- Lo más simple que funcione: HTML, CSS y JavaScript puros antes que frameworks. Si hace falta un framework o una dependencia, pregúntame antes y justifica por qué.
- Interfaz, documentación, comentarios y commits en español.
- Diseño responsive: todo se revisa también en móvil (375 px).

## Backend
- **Cloudflare Workers + D1** (ej.: catBot):
  - JavaScript puro con módulos ES, `wrangler` como única dependencia de desarrollo.
  - Migraciones SQL numeradas en una carpeta (`0001_init.sql`, ...) y aplicadas con `npx wrangler d1 migrations apply <db>`.
  - Variables no secretas en `wrangler.toml` (`[vars]`); secretos con `wrangler secret put` o `wrangler secret bulk .dev.vars`.
  - Desarrollo: `npx wrangler dev`. Deploy: `npx wrangler deploy`. Logs: `npx wrangler tail <worker>`.
  - Si wrangler da error de certificado (`UNABLE_TO_VERIFY_LEAF_SIGNATURE`): `$env:NODE_OPTIONS = '--use-system-ca'` antes del comando.
- **PHP + Supabase** (ej.: DimensionTres): endpoints PHP en `api/`, cliente de Supabase en el frontend; los archivos de configuración reales nunca van a git, solo su `*.example.php`.

## Secretos (innegociable)
- Nunca en el código, en logs, en commits ni en el chat. Los carga el usuario.
- `.env`, `.dev.vars` y configs reales siempre en `.gitignore`, con un archivo `*.ejemplo` / `*.example` sin valores.

## Tests y verificación
- Lógica pura: `node --test`, sin instalar paquetes.
- Navegador: `playwright-cli` (skill playwright-cli) para pruebas automáticas, sobre todo si hay varios proyectos a la vez; MCP de Chrome DevTools para revisar consola y vista móvil.
- Si el proyecto ya tiene scripts de test en `package.json`, usa esos primero.

## Despliegue
- Sitios estáticos y APIs pequeñas: Cloudflare (Pages / Workers).
- Antes de proponer un servicio pago, avísame.

## Antes de levantar un servidor local
- Comprueba que el puerto esté libre; si está ocupado, usa otro y dime cuál.
