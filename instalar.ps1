# Instala esta configuración de Claude Code en la PC actual.
# Uso:  powershell -ExecutionPolicy Bypass -File .\instalar.ps1
# Opciones: -SinTerceros (no instala skills de terceros ni Playwright)
#           -SinMcp      (no configura los servidores MCP)
#           -SinVSCode   (no instala extensiones ni ajustes de VS Code)
#           -SinExtras   (solo el starter pack del curso, sin las skills extra de frontend/backend)
param(
    [switch]$SinTerceros,
    [switch]$SinMcp,
    [switch]$SinVSCode,
    [switch]$SinExtras
)

$ErrorActionPreference = "Stop"
$repo = $PSScriptRoot
$destino = Join-Path $HOME ".claude"
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)

function Paso($mensaje) { Write-Host "==> $mensaje" -ForegroundColor Cyan }
function Aviso($mensaje) { Write-Host "    $mensaje" -ForegroundColor Yellow }

# --- Requisitos ---
Paso "Comprobando requisitos"
foreach ($programa in @("node", "npx", "git")) {
    if (-not (Get-Command $programa -ErrorAction SilentlyContinue)) {
        throw "Falta '$programa'. Instala Node.js (https://nodejs.org) y Git antes de continuar."
    }
}
$hayClaude = [bool](Get-Command claude -ErrorAction SilentlyContinue)
if (-not $hayClaude) { Aviso "No se encontró el CLI 'claude': se copiarán los archivos, pero no se configurarán los MCP." }

# --- Respaldo de lo que se va a sobrescribir ---
New-Item -ItemType Directory -Force $destino | Out-Null
$respaldo = Join-Path $HOME (".claude-respaldo-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
$aRespaldar = @("CLAUDE.md", "settings.json", "agents", "commands", "hooks", "skills") |
    Where-Object { Test-Path (Join-Path $destino $_) }
if ($aRespaldar) {
    Paso "Respaldando la configuración actual en $respaldo"
    New-Item -ItemType Directory -Force $respaldo | Out-Null
    foreach ($elemento in $aRespaldar) {
        Copy-Item -Recurse -Force (Join-Path $destino $elemento) $respaldo
    }
}

# --- Archivos propios ---
Paso "Copiando CLAUDE.md, agentes, comandos, hooks y skills"
Copy-Item -Force (Join-Path $repo "claude\CLAUDE.md") $destino
foreach ($carpeta in @("agents", "commands", "hooks", "skills")) {
    New-Item -ItemType Directory -Force (Join-Path $destino $carpeta) | Out-Null
    Copy-Item -Recurse -Force (Join-Path $repo "claude\$carpeta\*") (Join-Path $destino $carpeta)
}

# Reemplaza {{CLAUDE_DIR}} por la ruta real de esta PC.
$rutaClaude = $destino -replace "\\", "/"
foreach ($archivo in @("agents\planner.md", "commands\coordinador.md")) {
    $ruta = Join-Path $destino $archivo
    $texto = [IO.File]::ReadAllText($ruta, $utf8SinBom).Replace("{{CLAUDE_DIR}}", $rutaClaude)
    [IO.File]::WriteAllText($ruta, $texto, $utf8SinBom)
}

# --- Permisos (se fusionan, no se pisan) ---
Paso "Fusionando settings.json"
node (Join-Path $repo "scripts\fusionar-settings.js") (Join-Path $repo "claude\settings-base.json") (Join-Path $destino "settings.json")

# --- Skills de terceros y Playwright ---
if (-not $SinTerceros) {
    Paso "Instalando skills de terceros (starter pack del curso)"
    $skills = @(
        @("vercel-labs/skills", "find-skills"),
        @("mattpocock/skills", "grill-me"),
        @("anthropics/skills", "frontend-design"),
        @("vercel-labs/agent-skills", "web-design-guidelines"),
        @("obra/superpowers", "systematic-debugging")
    )
    foreach ($s in $skills) {
        Write-Host "    $($s[1])"
        npx -y skills add $s[0] -s $s[1] -g -a claude-code -y --copy | Out-Null
    }

    if (-not $SinExtras) {
        Paso "Instalando skills extra (frontend, backend y buenas prácticas)"
        $extras = @(
            @("vercel-labs/agent-skills", "*"),
            @("anthropics/skills", "webapp-testing"),
            @("anthropics/skills", "mcp-builder"),
            @("obra/superpowers", "test-driven-development"),
            @("obra/superpowers", "verification-before-completion"),
            @("obra/superpowers", "requesting-code-review"),
            @("obra/superpowers", "receiving-code-review"),
            @("mattpocock/skills", "codebase-design"),
            @("mattpocock/skills", "improve-codebase-architecture"),
            @("supabase/agent-skills", "supabase"),
            @("supabase/agent-skills", "supabase-postgres-best-practices"),
            @("mcollina/skills", "node"),
            @("mcollina/skills", "typescript-magician"),
            @("mcollina/skills", "fastify-best-practices")
        )
        foreach ($s in $extras) {
            Write-Host "    $($s[0]) -> $($s[1])"
            npx -y skills add $s[0] -s $s[1] -g -a claude-code -y --copy | Out-Null
        }
    }

    Paso "Instalando Playwright CLI y su skill"
    npm install -g @playwright/cli@latest | Out-Null
    playwright-cli install --skills -g | Out-Null
}

# --- Servidores MCP ---
if (-not $SinMcp -and $hayClaude) {
    Paso "Configurando MCP (chrome-devtools y context7)"
    $mcpActuales = (claude mcp list 2>$null) -join "`n"
    if ($mcpActuales -notmatch "chrome-devtools") {
        claude mcp add chrome-devtools -s user -- cmd /c npx -y chrome-devtools-mcp@latest --no-usage-statistics | Out-Null
    } else { Aviso "chrome-devtools ya estaba configurado." }
    if ($mcpActuales -notmatch "context7") {
        claude mcp add --transport http context7 -s user https://mcp.context7.com/mcp | Out-Null
        Aviso "context7 quedó sin API key. Para agregarla: ver README."
    } else { Aviso "context7 ya estaba configurado." }
    # Figma y Supabase usan inicio de sesión en el navegador (/mcp): no guardan claves aquí.
    if ($mcpActuales -notmatch "figma") {
        claude mcp add --transport http figma -s user https://mcp.figma.com/mcp | Out-Null
    } else { Aviso "figma ya estaba configurado." }
    if ($mcpActuales -notmatch "supabase") {
        claude mcp add --transport http supabase -s user https://mcp.supabase.com/mcp | Out-Null
    } else { Aviso "supabase ya estaba configurado." }
    Aviso "Figma y Supabase: inicia sesión con /mcp dentro de Claude Code."
}

# --- Extensiones de VS Code ---
if (-not $SinVSCode) {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Paso "Instalando extensiones de VS Code"
        Get-Content (Join-Path $repo "vscode\extensiones.txt") | Where-Object { $_.Trim() } | ForEach-Object {
            Write-Host "    $_"
            code --install-extension $_ --force | Out-Null
        }

        Paso "Ajustes de VS Code (se fusionan, no se pisan) e idioma español"
        $settingsVSCode = Join-Path $env:APPDATA "Code\User\settings.json"
        node (Join-Path $repo "scripts\fusionar-vscode.js") (Join-Path $repo "vscode\settings.json") $settingsVSCode
        node (Join-Path $repo "scripts\idioma-vscode.js")
        Aviso "Cierra VS Code por completo y vuelve a abrirlo para ver el idioma."
    } else { Aviso "No se encontró VS Code ('code'): se omiten las extensiones." }
}

Paso "Listo. Reinicia Claude Code y VS Code para que carguen la configuración."
if ($aRespaldar) { Write-Host "    Tu configuración anterior quedó en: $respaldo" }
