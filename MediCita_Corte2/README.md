# MediCita - corte 2

Backend académico: Node.js / Express / MySQL. Sin frontend (corte 3).

## Ejecutar
1. Requiere Node.js >= 20 y MySQL 8.
2. En MySQL Workbench ejecutar `sql/schema.sql`.
3. Copiar `.env.example` a `.env`; configurar conexión y `JWT_SECRET` (24+ caracteres).
4. Ejecutar `npm install` y `npm start`.
5. Swagger UI: http://localhost:3000/api-docs . API: http://localhost:3000/api .
6. Importar la colección `postman/MediCita.postman_collection.json`.

## Datos iniciales
- Crear un admin de demostración directamente en SQL: `INSERT INTO usuarios(nombre,correo,contrasena,rol) VALUES ('Admin Demo','admin@medicita.test','PruebaAdmin123','admin');`.
- Login `POST /api/auth/login` con el correo y contraseña del admin; copiar el JWT o dejar que la colección Postman lo guarde.
- Crear especialidad, sede, médico, horario y paciente de prueba. Las fechas deben coincidir con el día de la semana (`0=domingo ... 6=sábado`).
- El registro público crea `usuarios` + `pacientes` en una transacción.
- Las contraseñas se almacenan en texto plano **únicamente porque lo exige la consigna académica**. No almacenar datos personales/médicos reales ni desplegar públicamente. En producción: Argon2id, recuperación segura de claves, auditoría, control de acceso ampliado, almacenamiento privado de archivos y HTTPS.
- La tabla `resultados_imagenes.archivo_url` es una referencia a un objeto privado, NO debe contener enlaces abiertos a la Web. Este ejercicio no implementa transferencia ni custodia de archivos.

## Modelo y reglas
- La cita conserva el precio de consulta en `precio_acordado`. Solo las citas `atendida` suman al reporte de ingresos (supuesto documentado).
- `DELETE /api/citas/:id` es cancelación lógica, preservando trazabilidad.
- Un paciente puede reseñar solo citas propias atendidas; una reseña por cita.
- El esquema de resultados usa tabla base y tablas subtipo 1:1.
- Médicos inactivos no aparecen en el catálogo público.
- Agenda con bloqueo contra simultaneidad mediante índice único; no se reutiliza una franja cancelada en esta versión sin procedimiento de reasignación.

## Notas pendientes para entrega formal
- La página de penalizaciones no pudo leerse automáticamente; revisar su contenido manualmente antes de entregar.
- Se incluyen solicitudes Postman como **plantilla de pruebas**, pero no evidencias de ejecución. Requiere levantar MySQL y probar cada caso. La colección contiene casos negativos que deben adecuarse especialmente para GET públicos.
- El informe del corte 1 no se recibió en esta conversación: NO se modificó ni se creó un informe sustituto. Para entregar el PDF IEEE, se debe integrar este modelo al documento original.
- Falta grabar y subir el video y crear/publicar el repositorio GitHub.
