---
description: SDD · Nuevo requisito - primero la spec, luego el código
argument-hint: <NNN-nombre> <requisito>
arguments: [spec]
disable-model-invocation: true
---
Nuevo requisito para la spec specs/$spec/ (el texto que va después del nombre de
la carpeta): $ARGUMENTS
NO toques código. Usa la skill sdd.
1. Actualiza specs/$spec/spec.md: nuevo RF (o cambio de uno existente) en EARS,
   sus casos límite y lo que queda fuera de alcance.
2. Indica qué partes de plan.md y tasks.md habría que cambiar después.
3. Muéstrame el diff de la spec y espera mi aprobación.
