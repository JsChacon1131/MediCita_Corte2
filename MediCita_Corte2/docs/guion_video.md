# Guion demostración API - máximo 5 minutos

**Antes de grabar:** iniciar MySQL y API, importar Postman, crear datos de prueba, autenticar administrador y paciente; confirmar que IDs, horario y fecha elegidos funcionan. NO grabar ni mostrar las contraseñas en texto visible más tiempo del necesario. No usar datos médicos reales.

- 0:00–0:25: `POST /api/auth/login` -> 200 + token.
- 0:25–0:50: `POST /api/especialidades` -> 201; `GET /api/especialidades` -> 200.
- 0:50–1:15: `POST /api/medicos` -> 201; `GET /api/medicos` -> 200.
- 1:15–1:40: `POST /api/horarios` -> 201; `GET /api/horarios?medico_id=1` -> 200.
- 1:40–2:05: `POST /api/auth/registro` -> 201; verificar `GET /api/pacientes` con admin -> 200.
- 2:05–2:35: `POST /api/citas` con paciente -> 201; `GET /api/mis-citas` -> 200.
- 2:35–2:55: `PATCH /api/citas/1` con admin `estado=atendida` -> 200.
- 2:55–3:20: `POST /api/resenas` con paciente -> 201; `GET /api/resenas` -> 200.
- 3:20–3:55: `POST /api/examenes` con admin -> 201; `GET /api/examenes?tipo=numerico` con paciente -> 200.
- 3:55–4:15: `GET /api/admin/ingresos?desde=...&hasta=...` -> 200.
- 4:15–4:35: `PUT /api/medicos/1` actualizar perfil -> 200.
- 4:35–4:50: `POST /api/citas` con JSON vacío -> 400 (demostrar validación).
- 4:50–5:00: `DELETE /api/etiquetas/:id` solo si se creó una de prueba no referenciada -> 200.

Mostrar siempre solicitud + respuesta real. El video y su enlace deben grabarse/publicarse después de ejecutar la API; este archivo NO constituye evidencia de funcionamiento.
