# Decisiones de modelado para anexar al informe del corte 1

## Normalización

- 1FN: atributos atómicos; especialidad en catálogo independiente; etiquetas en relación N:M.
- 2FN: la única PK compuesta `resena_etiquetas(resena_id, etiqueta_id)` no tiene atributos no-clave dependientes parcialmente de la clave.
- 3FN: los datos de médicos, pacientes, usuarios, sedes y exámenes se mantienen en relaciones específicas; el subtipo de examen se elige mediante discriminador `tipo` y almacenamiento 1:1 en una única tabla de detalle por examen.
- Desnormalización justificada: `citas.precio_acordado` replica el valor vigente de `medicos.precio_consulta` solo al registrar la cita, para no alterar los informes históricos cuando la tarifa cambie.
- Constraint: `UNIQUE(medico_id, fecha_hora)` evita duplicación exacta de inicio de consulta. **Limitación:** no modela duración de las citas ni intervalos parcialmente solapados. No permite reservar de nuevo un bloque cancelado hasta que exista una estrategia explícita de reutilización. Debe explicarse en el informe.
- Cada examen tiene un subtipo obligatorio a nivel lógico, impuesto por servicio transaccional; MySQL con estas claves FK no garantiza por sí solo exclusividad o existencia del subtipo si se modifican tablas directamente.

## REST y arquitectura

- El recurso `/api/medicos` expone catálogo filtrable; `/api/horarios?medico_id=` resuelve la relación sin duplicar recursos.
- `/api/mis-citas` es una vista compuesta y `/api/admin/ingresos` una agregación de solo lectura.
- `/api/examenes` contiene el campo discriminador `tipo`; el cuerpo `resultado` adapta su estructura a cada tipo.
- Carpeta `routes` enruta, `controllers` adapta solicitudes/respuestas, `services` aplica reglas, `repositories` ejecuta SQL parametrizado, `config` crea el pool MySQL.
- Se requiere JWT para información privada; los administradores y personal médico pueden crear exámenes, los pacientes solo consultan los propios.
- El campo de contraseña no se incluye en las respuestas de `/usuarios` y el login devuelve JWT. Almacenamiento en texto plano es **inseguro** y está implementado únicamente por la exigencia de este corte.
