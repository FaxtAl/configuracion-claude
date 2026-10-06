---
description: SDD · Implementa UNA tarea, tests primero (uso - /sdd-implement 002-nombre T3)
argument-hint: <NNN-nombre> <Tn>
arguments: [spec, task]
disable-model-invocation: true
---
Implementa SOLO la tarea $task de specs/$spec/tasks.md, siguiendo specs/$spec/plan.md,
docs/constitution.md y la skill sdd.

1. Escribe primero los tests y comprueba que fallan.
2. Escribe el código hasta que pasen.
3. Ejecuta node --test y muéstrame el resultado.
4. Marca $task como hecha en tasks.md e indica qué RF cubre.

Después PÁRATE. No empieces la siguiente tarea.
