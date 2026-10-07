# Copia tu configuración actual de ~/.claude a este repositorio para guardar los cambios.
# Uso:  powershell -ExecutionPolicy Bypass -File .\exportar.ps1
# Después revisa con "git diff" y haz commit.
$ErrorActionPreference = "Stop"
$repo = $PSScriptRoot
$origen = Join-Path $HOME ".claude"
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)

# Skills propias (las de terceros las instala instalar.ps1 desde su fuente oficial).
$skillsPropias = @("sdd", "mi-commit", "mi-stack", "plantilla-proyecto")

Write-Host "==> Exportando desde $origen" -ForegroundColor Cyan
Copy-Item -Force (Join-Path $origen "CLAUDE.md") (Join-Path $repo "claude")
foreach ($carpeta in @("agents", "commands")) {
    $destinoCarpeta = Join-Path $repo "claude\$carpeta"
    Remove-Item -Recurse -Force $destinoCarpeta -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force $destinoCarpeta | Out-Null
    Copy-Item -Force (Join-Path $origen "$carpeta\*.md") $destinoCarpeta
}
Copy-Item -Force (Join-Path $origen "hooks\solo-specs.js") (Join-Path $repo "claude\hooks")
foreach ($skill in $skillsPropias) {
    $rutaSkill = Join-Path $origen "skills\$skill"
    if (Test-Path $rutaSkill) {
        Remove-Item -Recurse -Force (Join-Path $repo "claude\skills\$skill") -ErrorAction SilentlyContinue
        Copy-Item -Recurse -Force $rutaSkill (Join-Path $repo "claude\skills")
    }
}

# Vuelve a poner el marcador en lugar de la ruta de esta PC.
$rutaClaude = $origen -replace "\\", "/"
foreach ($archivo in @("claude\agents\planner.md", "claude\commands\coordinador.md")) {
    $ruta = Join-Path $repo $archivo
    $texto = [IO.File]::ReadAllText($ruta, $utf8SinBom).Replace($rutaClaude, "{{CLAUDE_DIR}}")
    [IO.File]::WriteAllText($ruta, $texto, $utf8SinBom)
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    code --list-extensions | Sort-Object | Set-Content -Encoding ascii (Join-Path $repo "vscode\extensiones.txt")
}
$settingsVSCode = Join-Path $env:APPDATA "Code\User\settings.json"
if (Test-Path $settingsVSCode) {
    Copy-Item -Force $settingsVSCode (Join-Path $repo "vscode\settings.json")
}

Write-Host "==> Listo. Revisa los cambios con 'git diff' antes de hacer commit." -ForegroundColor Cyan
Write-Host "    Si creaste una skill propia nueva, agrégala a `$skillsPropias en este script."
Write-Host "    Los permisos no se exportan solos: edita claude\settings-base.json si los cambiaste."
