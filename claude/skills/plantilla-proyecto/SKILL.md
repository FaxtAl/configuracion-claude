---
name: plantilla-proyecto
description: Plantillas del curso para arrancar un proyecto - AGENTS.md, CLAUDE.md, MEMORY.md y .gitignore. Úsala siempre que crees o revises AGENTS.md, MEMORY.md o prepares un proyecto nuevo.
---

# Plantillas para un proyecto nuevo

## AGENTS.md (máximo 30-40 líneas, solo lo principal)
```
# AGENTS.md -- [Nombre del proyecto]
[Una o dos frases: qué es, para quién y cuál es su objetivo.]

## Stack y estructura
- Tecnologías y versiones clave.
- Qué hay en cada carpeta o archivo importante (solo lo que no es obvio).

## Comandos
- Cómo ejecutar, probar, hacer lint y compilar (comandos exactos, copiables).
- Tests: `node --test` (o el que use el proyecto).

## Convenciones
- Estilo de código, nombres, idioma de comentarios y textos.
- Patrones que hay que seguir (y cuál es el archivo de referencia).

## Reglas de dominio / trampas conocidas
- Lo que es fácil hacer mal y el agente no puede deducir leyendo el código.

## Reglas
- Lee `docs/constitution.md` y la spec activa (`specs/NNN-*/`) antes de tocar código.

## Forma de trabajar
- Cuándo planificar antes de tocar código, tamaño de los cambios, qué explicar al terminar.

## Memoria
- Al empezar, lee `MEMORY.md` para conocer el estado del proyecto y las decisiones tomadas.
- Al terminar una tarea, actualízalo: estado actual, decisiones importantes (con su porqué) y errores a evitar.
- Mantenlo breve (máximo ~50 líneas): resume o elimina lo que ya no aporte.
- Si algo se convierte en una regla permanente, propón moverlo a `AGENTS.md`.
- No guardes nunca datos sensibles (claves, tokens, datos personales).

## Límites
- Siempre: lo que debe hacer sin preguntar (incluido actualizar `MEMORY.md` al terminar cada tarea).
- Pregunta antes: dependencias nuevas, archivos nuevos, cambios en el formato de datos...
- Nunca: lo que no debe tocar bajo ningún concepto.

## Verificación
- Cómo comprobar que un cambio funciona antes de darlo por terminado (tests + MCP de Chrome DevTools con vista móvil si hay interfaz).
```

## CLAUDE.md
```
# CLAUDE.md

Las instrucciones del proyecto viven en AGENTS.md.

@AGENTS.md
```

## MEMORY.md (máximo ~50 líneas)
```
# MEMORY.md -- [Nombre del proyecto]
Memoria del proyecto entre sesiones. Máximo ~50 líneas: resume o elimina lo que ya no aporte.

## Estado actual
- 

## Decisiones (y por qué)
- 

## Aprendizajes y errores a evitar
- (vacío por ahora)

## Próximos pasos
- 
```

## .gitignore base
```
# Secretos y variables de entorno
.env*
!.env.ejemplo
.dev.vars

# Dependencias y builds
node_modules/
.next/
dist/
build/

# Claude Code (local, no se comparte)
.claude/worktrees/
.claude/settings.local.json

# Sistema
.DS_Store
Thumbs.db
```

## Estructura de carpetas
```
proyecto/
├── AGENTS.md, CLAUDE.md, MEMORY.md, .gitignore
├── docs/constitution.md
├── specs/.gitkeep
└── tests/
```

## Git
- Primer commit en la rama principal con la estructura base; después crear `dev` y trabajar ahí.
