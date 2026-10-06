---
name: sdd
description: Úsala siempre que trabajes con Spec-Driven Development en este proyecto (docs/constitution.md o cualquier archivo dentro de specs/) - redactar, revisar o cambiar specs, planes y tareas, o implementar y validar tareas de una spec.
---

# Spec-Driven Development (SDD)

## Flujo
Constitución → Spec → Clarificación → Plan → Tareas → Implementación → Validación → Cambio.

- Nunca pases a la siguiente fase sin la aprobación explícita del usuario.
- La spec manda: si algo no está en la spec, no se implementa. Si falta una decisión, para y pregunta.
- Un cambio de requisitos se hace primero en la spec, luego en el plan y las tareas, y por último en el código.
- Cada spec vive en su carpeta: `specs/NNN-nombre/` con `spec.md`, `plan.md` y `tasks.md`.
- Al terminar cada fase, actualiza `MEMORY.md`.

## Estructura
```
project/
├── .claude/ (agents, commands, skills)
├── AGENTS.md, CLAUDE.md, MEMORY.md
├── docs/
│   └── constitution.md
├── specs/
│   ├── 001-nombre-spec/
│   │   ├── spec.md
│   │   ├── plan.md
│   │   └── tasks.md
│   └── 002-nombre-spec/...
├── tests/
└── <CÓDIGO DEL PROYECTO>
```

## Constitución (docs/constitution.md)
Una vez por proyecto. Unos 6 principios innegociables, cortos y verificables (máximo 15 líneas), que cubran: simplicidad del stack, relación entre spec y código, separación entre lógica e interfaz, política de tests, protección de los datos del usuario e idioma del código y los textos. Toda spec, plan y tarea debe cumplirlos.

## Plantilla de spec (spec.md)
```
# Spec NNN -- <Nombre>

Estado: borrador | aprobada | implementada

## Contexto y objetivo
## Usuarios
## Historias de usuario
- HU-1. Como <rol>, quiero <acción> para <beneficio>.
## Definiciones (solo si hay términos que puedan interpretarse de varias formas)
## Requisitos funcionales
## Requisitos no funcionales
## Casos límite
## Fuera de alcance
## Criterios de finalización
## Dudas abiertas
- [NECESITA ACLARACIÓN] <duda>
```
La spec describe el QUÉ y el POR QUÉ. Nada de stack, arquitectura ni nombres de archivos.

## Requisitos en EARS (en español)
- RF-x: CUANDO <evento>, EL SISTEMA <respuesta>.
- RF-x: SI <condición no deseada>, ENTONCES EL SISTEMA <respuesta>.
- RF-x: MIENTRAS <estado>, EL SISTEMA <respuesta>.
- RF-x: EL SISTEMA <comportamiento permanente>.

Cada RF debe ser verificable: nada de "rápido", "intenso" o "bonito" sin un criterio medible. Una frase = un comportamiento. El SI... ENTONCES obliga a pensar en los errores.

## Plan (plan.md)
Archivos y responsabilidades · Funciones puras (con "hoy" como parámetro) · Algoritmo en pseudocódigo · Interfaz · Decisiones justificadas con su alternativa descartada · Estrategia de tests con `node --test`. Indica qué RF cubre cada parte.

## Tareas (tasks.md)
```
- [ ] **Tn. <Descripción>.** RF-x, RF-y
  - Hecho cuando: <comprobación verificable>.
```
Máximo 20-30 min por tarea, en orden de dependencia. Si salen más de 10, propón dividir la spec.

## Implementación
Una sola tarea cada vez: tests primero (en rojo), después el código, `node --test` en verde, marcar la tarea y parar.

## Validación
RF por RF: qué test lo cubre y su resultado. Los RF de interfaz que no se puedan testear con `node --test` se verifican con el MCP de Chrome DevTools (incluida la vista móvil de 375 px). Después, criterios de finalización y veredicto.

## Comandos
| Comando | Uso | Fase |
|---|---|---|
| `/sdd-constitution` | `/sdd-constitution` | Constitución |
| `/sdd-spec` | `/sdd-spec 002-nombre idea...` | Especificación |
| `/sdd-clarify` | `/sdd-clarify 002-nombre` | Clarificación |
| `/sdd-plan` | `/sdd-plan 002-nombre` | Planificación |
| `/sdd-tasks` | `/sdd-tasks 002-nombre` | Tareas |
| `/sdd-implement` | `/sdd-implement 002-nombre T3` | Implementación |
| `/sdd-validate` | `/sdd-validate 002-nombre` | Validación |
| `/sdd-change` | `/sdd-change 002-nombre requisito...` | Mantenimiento |
| `/sdd-status` | `/sdd-status 002-nombre` | Fase actual y siguiente paso |

El paso de Clarificación puede repetirse después del plan o las tareas si algo no está claro.
