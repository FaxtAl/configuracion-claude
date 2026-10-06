# Forma de trabajar (global)

Metodología del curso "El Nuevo Programador": la IA ejecuta, el responsable del proyecto soy yo.

## Contexto del proyecto
- Al empezar en un proyecto, lee `AGENTS.md` y `MEMORY.md` si existen. `AGENTS.md` manda sobre estas reglas generales.
- Si el proyecto usa SDD (`docs/constitution.md` o `specs/`), lee la constitución y la spec activa antes de tocar código y sigue la skill `sdd`.

## Memoria
- Al terminar una tarea, actualiza `MEMORY.md` (si existe): estado actual, decisiones importantes (con su porqué) y errores a evitar.
- Mantenlo breve (máximo ~50 líneas): resume o elimina lo que ya no aporte.
- Si algo se convierte en una regla permanente, propón moverlo a `AGENTS.md`.
- Nunca guardes datos sensibles (claves, tokens, datos personales).

## Git y trabajo en paralelo
- Ramas: la principal (`main` o `principal`) es producción y solo recibe código revisado; el trabajo diario va en `dev`. Si el proyecto no tiene `dev`, propón crearla.
- Si dos tareas pueden tocar los mismos archivos a la vez, cada una va en su propio worktree (`.claude/worktrees/`), nunca dos agentes en la misma carpeta.
- Al terminar una función en worktree: se combina en `dev` (no en la principal) y se elimina el worktree y su rama. No dejes worktrees acumulados.
- Antes de combinar, muéstrame qué archivos cambian en cada rama y avisa si hay conflictos.
- Nunca hagas push ni combines en la rama principal sin que yo lo pida.

## Reglas
- Haz solo lo que se pide: no añadas funcionalidades por tu cuenta.
- Cambios pequeños y enfocados; no reescribas lo que ya funciona.
- Tareas grandes o refactors: propón un plan antes de escribir código (modo plan).
- Pregunta antes de: añadir dependencias, crear archivos nuevos, cambiar el formato de datos guardados.
- Al terminar, resume qué has cambiado y cualquier decisión que deba revisar.
- Verifica los cambios antes de darlos por terminados (tests y, si hay interfaz, el MCP de Chrome DevTools incluida la vista móvil de 375 px).

## Idioma: todo en español
- Commits: mensaje siempre en español (título y cuerpo), sin `Co-Authored-By` ni firmas de IA.
- Repositorio en español: nombre y descripción del repo, README, documentación, comentarios, `.gitignore` comentado, issues, pull requests (título y descripción), etiquetas y notas de versión.
- Ramas y worktrees nuevos con nombres en español (ej.: `login-google`, `arreglo-carrito`). Las ramas base se quedan como estén (`main`/`principal`, `dev`).
- Interfaz, mensajes de error, logs y textos para el usuario en español.
- Nombres de variables y funciones: los que diga el `AGENTS.md` o `CLAUDE.md` del proyecto; si no dice nada, en español. Lo que imponen terceros (APIs, librerías, `package.json`, etc.) se queda en su idioma original.
