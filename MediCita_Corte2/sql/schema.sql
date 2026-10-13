CREATE DATABASE IF NOT EXISTS medicita CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medicita;
CREATE TABLE usuarios (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(120) NOT NULL,
 correo VARCHAR(190) NOT NULL UNIQUE,
 contrasena VARCHAR(255) NOT NULL COMMENT 'SOLO CORTE ACADEMICO: TEXTO PLANO; NUNCA USAR EN PRODUCCION',
 rol ENUM('paciente','medico','admin') NOT NULL DEFAULT 'paciente',
 activo BOOLEAN NOT NULL DEFAULT TRUE,
 creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE pacientes (
 id INT AUTO_INCREMENT PRIMARY KEY,
 usuario_id INT NOT NULL UNIQUE,
 telefono VARCHAR(30) NULL,
 documento VARCHAR(40) NULL UNIQUE,
 FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);
CREATE TABLE especialidades (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(120) NOT NULL UNIQUE
);
CREATE TABLE sedes (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(150) NOT NULL,
 direccion VARCHAR(255) NOT NULL,
 comuna VARCHAR(120) NULL
);
CREATE TABLE medicos (
 id INT AUTO_INCREMENT PRIMARY KEY,
 usuario_id INT NULL UNIQUE,
 nombre VARCHAR(120) NOT NULL,
 especialidad_id INT NOT NULL,
 perfil TEXT NOT NULL,
 precio_consulta DECIMAL(12,2) NOT NULL,
 activo BOOLEAN NOT NULL DEFAULT TRUE,
 FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
 FOREIGN KEY (especialidad_id) REFERENCES especialidades(id),
 CONSTRAINT chk_precio CHECK (precio_consulta>=0)
);
CREATE TABLE horarios (
 id INT AUTO_INCREMENT PRIMARY KEY,
 medico_id INT NOT NULL,
 sede_id INT NULL,
 dia_semana TINYINT NOT NULL COMMENT '0 domingo ... 6 sabado',
 hora_inicio TIME NOT NULL,
 hora_fin TIME NOT NULL,
 activo BOOLEAN NOT NULL DEFAULT TRUE,
 FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE RESTRICT,
 FOREIGN KEY (sede_id) REFERENCES sedes(id) ON DELETE SET NULL,
 CONSTRAINT chk_dia CHECK(dia_semana BETWEEN 0 AND 6),
 CONSTRAINT chk_horas CHECK(hora_inicio<hora_fin)
);
CREATE TABLE citas (
 id INT AUTO_INCREMENT PRIMARY KEY,
 paciente_id INT NOT NULL,
 medico_id INT NOT NULL,
 horario_id INT NOT NULL,
 fecha_hora DATETIME NOT NULL,
 precio_acordado DECIMAL(12,2) NOT NULL,
 estado ENUM('agendada','atendida','cancelada') NOT NULL DEFAULT 'agendada',
 creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(paciente_id) REFERENCES pacientes(id) ON DELETE RESTRICT,
 FOREIGN KEY(medico_id) REFERENCES medicos(id) ON DELETE RESTRICT,
 FOREIGN KEY(horario_id) REFERENCES horarios(id) ON DELETE RESTRICT,
 CONSTRAINT chk_cita_precio CHECK(precio_acordado>=0),
 UNIQUE KEY uq_medico_cita(medico_id,fecha_hora),
 INDEX idx_cita_paciente(paciente_id,fecha_hora),
 INDEX idx_cita_fecha(fecha_hora)
);
CREATE TABLE resenas (
 id INT AUTO_INCREMENT PRIMARY KEY,
 cita_id INT NOT NULL UNIQUE,
 calificacion TINYINT NOT NULL,
 comentario TEXT NULL,
 espera_minutos SMALLINT UNSIGNED NULL,
 creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(cita_id) REFERENCES citas(id) ON DELETE RESTRICT,
 CONSTRAINT chk_calificacion CHECK(calificacion BETWEEN 1 AND 5)
);
CREATE TABLE etiquetas (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(70) NOT NULL UNIQUE
);
CREATE TABLE resena_etiquetas (
 resena_id INT NOT NULL,
 etiqueta_id INT NOT NULL,
 PRIMARY KEY(resena_id,etiqueta_id),
 FOREIGN KEY(resena_id) REFERENCES resenas(id) ON DELETE CASCADE,
 FOREIGN KEY(etiqueta_id) REFERENCES etiquetas(id) ON DELETE RESTRICT
);
CREATE TABLE examenes (
 id INT AUTO_INCREMENT PRIMARY KEY,
 paciente_id INT NOT NULL,
 cita_id INT NULL,
 nombre VARCHAR(180) NOT NULL,
 tipo ENUM('numerico','cualitativo','imagen') NOT NULL,
 fecha DATETIME NOT NULL,
 publicado BOOLEAN NOT NULL DEFAULT TRUE,
 FOREIGN KEY(paciente_id) REFERENCES pacientes(id) ON DELETE RESTRICT,
 FOREIGN KEY(cita_id) REFERENCES citas(id) ON DELETE SET NULL,
 INDEX idx_examen_paciente(paciente_id,tipo,fecha)
);
CREATE TABLE resultados_numericos (
 examen_id INT PRIMARY KEY,
 valor DECIMAL(16,4) NOT NULL,
 unidad VARCHAR(50) NOT NULL,
 referencia_min DECIMAL(16,4) NOT NULL,
 referencia_max DECIMAL(16,4) NOT NULL,
 FOREIGN KEY(examen_id) REFERENCES examenes(id) ON DELETE CASCADE,
 CONSTRAINT chk_referencia CHECK(referencia_min<=referencia_max)
);
CREATE TABLE resultados_cualitativos (
 examen_id INT PRIMARY KEY,
 resultado VARCHAR(120) NOT NULL,
 observaciones TEXT NULL,
 FOREIGN KEY(examen_id) REFERENCES examenes(id) ON DELETE CASCADE
);
CREATE TABLE resultados_imagenes (
 examen_id INT PRIMARY KEY,
 informe TEXT NOT NULL,
 archivo_url VARCHAR(1024) NOT NULL COMMENT 'Referencia privada; no publicar una URL sin autorizacion',
 FOREIGN KEY(examen_id) REFERENCES examenes(id) ON DELETE CASCADE
);
