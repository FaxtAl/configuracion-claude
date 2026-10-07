# Configuración de Claude Code

Mi configuración de Claude Code para trabajar con **Spec-Driven Development (SDD)** y **multiagentes**, basada en el curso *"El Nuevo Programador"* de MauroDev, más ideas del flujo multi-agente de Fazt (worktrees, Playwright, Herdr). Todo en español.

## Qué incluye

| Qué | Dónde | Para qué |
|---|---|---|
| Reglas globales | `claude/CLAUDE.md` | Forma de trabajar, memoria, Git (`main`/`dev` + worktrees) y todo en español |
| Agentes | `claude/agents/` | `coordinator`, `planner`, `implementer`, `reviewer` (flujo SDD multiagente) |
| Comandos | `claude/commands/` | `/feature`, `/coordinador` y los 9 `/sdd-*` |
| Skills propias | `claude/skills/` | `sdd`, `plantilla-proyecto`, `mi-commit`, `mi-stack` |
| Hook | `claude/hooks/solo-specs.js` | El `planner` solo puede escribir dentro de `specs/` |
| Permisos | `claude/settings-base.json` | Idioma español, tests y git de solo lectura, escritura en `specs/` |
| Extensiones | `vscode/extensiones.txt` | Extensiones de VS Code para frontend y backend |
| Ajustes de VS Code | `vscode/settings.json` | Formato al guardar, ESLint, iconos, Git Bash, autoguardado… (se fusionan, no se pisan) |

El instalador además descarga desde su fuente oficial:
- **Skills de terceros (starter pack del curso):** `find-skills`, `grill-me`, `frontend-design`, `web-design-guidelines`, `systematic-debugging`.
- **Skills extra** (se omiten con `-SinExtras`):
  - Paquete completo de Vercel (`vercel-labs/agent-skills`): React, Next.js, despliegue...
  - Buenas prácticas: `test-driven-development`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review` (obra), `codebase-design`, `improve-codebase-architecture` (Matt Pocock).
  - Frontend: `webapp-testing` (Anthropic).
  - Backend: `node`, `typescript-magician`, `fastify-best-practices` (Matteo Collina), `supabase`, `supabase-postgres-best-practices` (Supabase), `mcp-builder` (Anthropic).
- **Playwright CLI** y su skill.
- **MCP:** Chrome DevTools, Context7, Figma y Supabase (Figma y Supabase: iniciar sesión con `/mcp`).
- **VS Code en español** (`locale: es`, si no tenías otro idioma configurado).

## Requisitos
- Windows con PowerShell.
- [Node.js](https://nodejs.org) y [Git](https://git-scm.com).
- [Claude Code](https://claude.com/claude-code) (CLI o extensión de VS Code).
- Opcional: [VS Code](https://code.visualstudio.com) y [Herdr](https://herdr.dev).

## Instalación

```powershell
git clone https://github.com/FaxtAl/configuracion-claude.git
cd configuracion-claude
powershell -ExecutionPolicy Bypass -File .\instalar.ps1
```

Opciones: `-SinTerceros`, `-SinExtras`, `-SinMcp`, `-SinVSCode`.

El instalador:
- **respalda** tu configuración actual en `~/.claude-respaldo-<fecha>` antes de tocar nada;
- **fusiona** los permisos con tu `settings.json` (no lo pisa);
- no copia credenciales, historial ni sesiones.

Después reinicia Claude Code y VS Code.

### GitHub MCP (opcional)
Necesita un token personal de GitHub (no admite inicio de sesión automático). Créalo en GitHub → Settings → Developer settings → Personal access tokens y ejecuta:

```powershell
claude mcp add --transport http github -s user https://api.githubcopilot.com/mcp/ --header "Authorization: Bearer TU_TOKEN"
```

### Context7 con API key (opcional)
Saca una key gratis en [context7.com/dashboard](https://context7.com/dashboard) y ejecuta:

```powershell
claude mcp remove context7 -s user
claude mcp add --transport http context7 -s user https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: TU_KEY"
```

## Guardar cambios de tu configuración

```powershell
powershell -ExecutionPolicy Bypass -File .\exportar.ps1
git diff
```

Revisa los cambios y haz commit.

## Cómo se usa

### Proyecto nuevo (una vez)
1. Abre la carpeta del proyecto y, en un chat normal: `/sdd-constitution` + resumen del proyecto.
2. Pide crear `AGENTS.md`, `CLAUDE.md`, `MEMORY.md`, `.gitignore` y `specs/` con la skill `plantilla-proyecto`.
3. Commit inicial en `main` con `/mi-commit` y crea la rama `dev`.

### Cada funcionalidad
| Tamaño | Qué usar |
|---|---|
| Chica | `/feature descripción` |
| Mediana o grande, paso a paso | `/sdd-spec` → `/sdd-clarify` → `/sdd-plan` → `/sdd-tasks` → `/sdd-implement NNN T1` → `/sdd-validate` |
| Mediana o grande, automático | `/coordinador petición` (o `claude --agent coordinator` en la terminal) |

¿En qué fase estoy? → `/sdd-status NNN-nombre`.

### Trabajo en paralelo
- Tareas independientes: "lanza un subagente en segundo plano que…".
- Tareas que tocan los mismos archivos: un **worktree** por tarea (`claude -w nombre` o "crea un worktree para esto") y al terminar se combinan en `dev`.

## Créditos
- Flujo SDD, agentes y comandos: adaptados a Claude Code a partir del curso *"El Nuevo Programador"* de **MauroDev** (originalmente para OpenCode).
- Flujo multi-agente con worktrees y Herdr: inspirado en un video de **Fazt**.
- Skills de terceros: de sus autores (Vercel, Anthropic, Matt Pocock, Jesse Vincent / obra, Supabase, Matteo Collina, Microsoft Playwright), se instalan desde sus repositorios oficiales.
