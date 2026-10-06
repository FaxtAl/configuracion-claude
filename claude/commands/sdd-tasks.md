---
description: SDD · Divide el plan en tareas pequeñas y verificables
argument-hint: <NNN-nombre>
arguments: [spec]
disable-model-invocation: true
---
A partir de specs/$spec/spec.md y specs/$spec/plan.md, genera specs/$spec/tasks.md
siguiendo el formato de la skill sdd:
- Tareas pequeñas (máx. 20-30 min cada una), en orden de dependencia.
- Cada una con los RF que cubre y una línea "Hecho cuando:" verificable.
- Checkboxes.
- Intenta que no sean más de 10: si salen más, propón dividir la spec.
