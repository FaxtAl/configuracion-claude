#!/usr/bin/env bash
# Instala esta configuración de Claude Code en Linux (o macOS).
# Uso:  ./instalar.sh
# Opciones: --sin-terceros (no instala skills de terceros ni Playwright)
#           --sin-mcp      (no configura los servidores MCP)
#           --sin-vscode   (no instala extensiones ni ajustes de VS Code)
#           --sin-extras   (solo el starter pack del curso, sin las skills extra de frontend/backend)
set -euo pipefail

SIN_TERCEROS=0; SIN_MCP=0; SIN_VSCODE=0; SIN_EXTRAS=0
for opcion in "$@"; do
    case "$opcion" in
        --sin-terceros) SIN_TERCEROS=1 ;;
        --sin-mcp)      SIN_MCP=1 ;;
        --sin-vscode)   SIN_VSCODE=1 ;;
        --sin-extras)   SIN_EXTRAS=1 ;;
        *) echo "Opción desconocida: $opcion" >&2; exit 1 ;;
    esac
done

repo="$(cd "$(dirname "$0")" && pwd)"
destino="$HOME/.claude"

paso()  { printf '\033[36m==> %s\033[0m\n' "$1"; }
aviso() { printf '\033[33m    %s\033[0m\n' "$1"; }
existe() { command -v "$1" >/dev/null 2>&1; }

# --- Requisitos ---
paso "Comprobando requisitos"
for programa in node npx git; do
    if ! existe "$programa"; then
        echo "Falta '$programa'. Instala Node.js (https://nodejs.org) y Git antes de continuar." >&2
        exit 1
    fi
done
hay_claude=0
if existe claude; then hay_claude=1; else aviso "No se encontró el CLI 'claude': se copiarán los archivos, pero no se configurarán los MCP."; fi

# --- Respaldo de lo que se va a sobrescribir ---
mkdir -p "$destino"
respaldo="$HOME/.claude-respaldo-$(date +%Y%m%d-%H%M%S)"
a_respaldar=()
for elemento in CLAUDE.md settings.json agents commands hooks skills; do
    [ -e "$destino/$elemento" ] && a_respaldar+=("$elemento")
done
if [ ${#a_respaldar[@]} -gt 0 ]; then
    paso "Respaldando la configuración actual en $respaldo"
    mkdir -p "$respaldo"
    for elemento in "${a_respaldar[@]}"; do
        cp -R "$destino/$elemento" "$respaldo/"
    done
fi

# --- Archivos propios ---
paso "Copiando CLAUDE.md, agentes, comandos, hooks y skills"
cp "$repo/claude/CLAUDE.md" "$destino/"
for carpeta in agents commands hooks skills; do
    mkdir -p "$destino/$carpeta"
    cp -R "$repo/claude/$carpeta/." "$destino/$carpeta/"
done

# Reemplaza {{CLAUDE_DIR}} por la ruta real de esta máquina.
for archivo in agents/planner.md commands/coordinador.md; do
    node -e 'const fs = require("fs"); const [ruta, dir] = process.argv.slice(1);
             fs.writeFileSync(ruta, fs.readFileSync(ruta, "utf8").split("{{CLAUDE_DIR}}").join(dir));' \
        "$destino/$archivo" "$destino"
done

# --- Permisos (se fusionan, no se pisan) ---
paso "Fusionando settings.json"
node "$repo/scripts/fusionar-settings.js" "$repo/claude/settings-base.json" "$destino/settings.json"

# --- Skills de terceros y Playwright ---
if [ $SIN_TERCEROS -eq 0 ]; then
    paso "Instalando skills de terceros (starter pack del curso)"
    skills=(
        "vercel-labs/skills find-skills"
        "mattpocock/skills grill-me"
        "anthropics/skills frontend-design"
        "vercel-labs/agent-skills web-design-guidelines"
        "obra/superpowers systematic-debugging"
    )
    for s in "${skills[@]}"; do
        repo_skill="${s%% *}"; nombre="${s#* }"
        echo "    $nombre"
        npx -y skills add "$repo_skill" -s "$nombre" -g -a claude-code -y --copy >/dev/null
    done

    if [ $SIN_EXTRAS -eq 0 ]; then
        paso "Instalando skills extra (frontend, backend y buenas prácticas)"
        extras=(
            "vercel-labs/agent-skills *"
            "anthropics/skills webapp-testing"
            "anthropics/skills mcp-builder"
            "obra/superpowers test-driven-development"
            "obra/superpowers verification-before-completion"
            "obra/superpowers requesting-code-review"
            "obra/superpowers receiving-code-review"
            "mattpocock/skills codebase-design"
            "mattpocock/skills improve-codebase-architecture"
            "supabase/agent-skills supabase"
            "supabase/agent-skills supabase-postgres-best-practices"
            "mcollina/skills node"
            "mcollina/skills typescript-magician"
            "mcollina/skills fastify-best-practices"
        )
        for s in "${extras[@]}"; do
            repo_skill="${s%% *}"; nombre="${s#* }"
            echo "    $repo_skill -> $nombre"
            npx -y skills add "$repo_skill" -s "$nombre" -g -a claude-code -y --copy >/dev/null
        done
    fi

    paso "Instalando Playwright CLI y su skill"
    if npm install -g @playwright/cli@latest >/dev/null; then
        playwright-cli install --skills -g >/dev/null
    else
        aviso "No se pudo instalar Playwright CLI con npm -g (¿falta permiso?). Configura un prefijo de npm en tu HOME o usa nvm."
    fi
fi

# --- Servidores MCP ---
if [ $SIN_MCP -eq 0 ] && [ $hay_claude -eq 1 ]; then
    paso "Configurando MCP (chrome-devtools, context7, figma y supabase)"
    mcp_actuales="$(claude mcp list 2>/dev/null || true)"
    if ! grep -q chrome-devtools <<<"$mcp_actuales"; then
        claude mcp add chrome-devtools -s user -- npx -y chrome-devtools-mcp@latest --no-usage-statistics >/dev/null
    else aviso "chrome-devtools ya estaba configurado."; fi
    if ! grep -q context7 <<<"$mcp_actuales"; then
        claude mcp add --transport http context7 -s user https://mcp.context7.com/mcp >/dev/null
        aviso "context7 quedó sin API key. Para agregarla: ver README."
    else aviso "context7 ya estaba configurado."; fi
    # Figma y Supabase usan inicio de sesión en el navegador (/mcp): no guardan claves aquí.
    if ! grep -q figma <<<"$mcp_actuales"; then
        claude mcp add --transport http figma -s user https://mcp.figma.com/mcp >/dev/null
    else aviso "figma ya estaba configurado."; fi
    if ! grep -q supabase <<<"$mcp_actuales"; then
        claude mcp add --transport http supabase -s user https://mcp.supabase.com/mcp >/dev/null
    else aviso "supabase ya estaba configurado."; fi
    aviso "Figma y Supabase: inicia sesión con /mcp dentro de Claude Code."
fi

# --- Extensiones de VS Code ---
if [ $SIN_VSCODE -eq 0 ]; then
    if existe code; then
        paso "Instalando extensiones de VS Code"
        while IFS= read -r extension; do
            extension="$(echo "$extension" | tr -d '\r' | xargs)"
            [ -z "$extension" ] && continue
            echo "    $extension"
            code --install-extension "$extension" --force >/dev/null
        done < "$repo/vscode/extensiones.txt"

        paso "Ajustes de VS Code (se fusionan, no se pisan) e idioma español"
        if [ "$(uname)" = "Darwin" ]; then
            settings_vscode="$HOME/Library/Application Support/Code/User/settings.json"
        else
            settings_vscode="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/settings.json"
        fi
        node "$repo/scripts/fusionar-vscode.js" "$repo/vscode/settings.json" "$settings_vscode"
        node "$repo/scripts/idioma-vscode.js"
        aviso "Cierra VS Code por completo y vuelve a abrirlo para ver el idioma."
    else
        aviso "No se encontró VS Code ('code'): se omiten las extensiones."
    fi
fi

paso "Listo. Reinicia Claude Code y VS Code para que carguen la configuración."
if [ ${#a_respaldar[@]} -gt 0 ]; then echo "    Tu configuración anterior quedó en: $respaldo"; fi
