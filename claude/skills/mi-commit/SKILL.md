---
name: mi-commit
description: Crea un commit ordenado y seguro con mis convenciones (mensaje en español, sin Co-Authored-By, revisando que no se suban secretos). Úsala solo cuando yo la invoque con /mi-commit.
argument-hint: [descripción opcional del cambio]
disable-model-invocation: true
allowed-tools: Bash(git status*) Bash(git diff*) Bash(git log*) Bash(git add *) Bash(git commit *) Bash(git branch*)
---

# Commit con mis convenciones

Contexto opcional del cambio: $ARGUMENTS

## Pasos
1. Ejecuta `git status` y `git branch --show-current`.
   - Si estás en la rama principal (`main` o `principal`), PARA y pregúntame: el trabajo diario va en `dev` o en un worktree.
   - Todo en español: mensaje del commit y, si propones una rama nueva, su nombre (ej.: `arreglo-carrito`).
2. Revisa seguridad antes de añadir nada:
   - No deben aparecer `.env`, `.env.*`, `.dev.vars`, claves, tokens ni credenciales. Si aparecen, PARA y avísame (y propón añadirlos a `.gitignore`).
   - Busca en el diff cadenas que parezcan secretos (tokens largos, `sk-`, `ghp_`, `Bearer`, contraseñas).
3. Revisa `git diff` y `git log --oneline -5` para seguir el estilo de mensajes del repo.
4. Añade solo los archivos relacionados con el cambio, por nombre. Nunca `git add -A` ni `git add .` a ciegas.
   - Si hay cambios mezclados de temas distintos, propón separarlos en varios commits.
5. Haz el commit:
   - Mensaje en español, en imperativo y corto (máximo ~72 caracteres en la primera línea). Ej.: `Añade validación de minutos en el formulario`.
   - Si hace falta, un cuerpo breve con el porqué.
   - Sin la línea `Co-Authored-By` ni firmas de IA.
   - Si el proyecto tiene versión en `package.json` y el cambio lo amerita, pregúntame antes de subirla.
6. Muestra el resultado (`git log --oneline -1`).

## Nunca
- Hacer push sin que yo lo pida.
- Usar `--amend`, `--no-verify` ni reescribir historial sin que yo lo pida.
