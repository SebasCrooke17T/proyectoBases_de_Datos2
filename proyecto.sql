/* PROYECTO instrucciones
Sistema de Gestión de Pacientes para una Clínica
	Requerimiento: Crear una base de datos para gestionar la información de los
	pacientes, citas médicas, tratamientos y expedientes médicos en una clínica. El
	sistema debe facilitar la programación de citas, el seguimiento de tratamientos y el
	acceso seguro a los expedientes médicos.
        
Aspectos de Entrega:
• Propuesta Justificación: Explicar cómo el sistema de gestión de pacientes
puede mejorar la eficiencia de las operaciones clínicas y la atención al
paciente.

• Diagrama Entidad-Relación (DER) en 3FN: Representar visualmente la
estructura de la base de datos, asegurando la eliminación de redundancias y
optimización del diseño.

• Script SQL: Incluir la creación de todas las tablas, relaciones, claves

• Implementación de Índices, Vistas y Procedimientos Almacenados:
	Utilizar índices para optimizar las búsquedas de pacientes y tratamientos,
	vistas para consultas comunes y procedimientos almacenados para registrar
	citas y tratamientos.

• Procedimientos Almacenados Específicos:
	1. Registro de Cita Médica: Permite programar, modificar y cancelar
	citas.
	2. Actualización de Expediente Médico: Gestiona las actualizaciones
	en los expedientes médicos de los pacientes.
	3. Gestión de Tratamientos: Registra y sigue los tratamientos
	prescritos a los pacientes.
    
• Manejo de Errores en Procedimientos Almacenados: Asegurar la
integridad de los datos con un manejo de errores efectivo.

• Generación de registros “prueba”, al menos 500 registros en cada una de las tablas.

• Requerimiento de Trigger en el Sistema de Gestión de Pacientes para una Clínica
Con el objetivo de automatizar ciertas acciones y mantener la integridad de los datos
*/
drop database if exists proyecto;
CREATE DATABASE proyecto;
use proyecto;
show tables;
select * from pacientes;
select * from medicos;
select * from citas;
select * from tratamientos;
select * from expedientes_medicos;

CREATE TABLE pacientes (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido_p VARCHAR(50) NOT NULL,
    apellido_m VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    sexo CHAR(1),
    telefono VARCHAR(15),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE medicos (
    id_medico INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido_p VARCHAR(50) NOT NULL,
    apellido_m VARCHAR(50) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(50)
);

CREATE TABLE citas (
    id_cita INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    id_medico INT,
    fecha_cita DATE,
    hora_cita TIME,
    motivo_cita VARCHAR(100),
    estado VARCHAR(20),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE tratamientos (
    id_tratamiento INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    id_medico INT,
    nombre_tratamiento VARCHAR(50),
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(40),
    
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE expedientes_Medicos (
    id_expediente INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    fecha DATE,
    descripcion TEXT,
    observaciones TEXT,
    id_tratamiento INT,
    
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamientos(id_tratamiento)
);


select * from pacientes;
select * from medicos;
select * from citas;
select * from tratamientos;
select * from expedientes_medicos;


ALTER TABLE pacientes
	ADD COLUMN fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ADD COLUMN usuario_BD VARCHAR(100) NOT NULL;
		DELIMITER //
		CREATE TRIGGER antes_insertar_pacientes
		BEFORE INSERT ON pacientes
		FOR EACH ROW
		BEGIN
			SET NEW.usuario_BD = USER();
			SET NEW.fecha_modificacion = NOW();
		END;
		// DELIMITER ;
DELIMITER //
CREATE TRIGGER antes_actualizar_pacientes
    BEFORE UPDATE ON pacientes
    FOR EACH ROW
    BEGIN
        SET NEW.usuario_BD = USER();
        SET NEW.fecha_modificacion = NOW();
    END;
// DELIMITER ;

ALTER TABLE medicos
	ADD COLUMN fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ADD COLUMN usuario_BD VARCHAR(100) NOT NULL;
    DELIMITER //
		CREATE TRIGGER antes_insertar_medicos
		BEFORE INSERT ON medicos
		FOR EACH ROW
		BEGIN
			SET NEW.usuario_BD = USER();
			SET NEW.fecha_modificacion = NOW();
		END;
	// DELIMITER ;
DELIMITER //
CREATE TRIGGER antes_actualizar_medicos
    BEFORE UPDATE ON medicos
    FOR EACH ROW
    BEGIN
        SET NEW.usuario_BD = USER();
        SET NEW.fecha_modificacion = NOW();
    END;
// DELIMITER ;

ALTER TABLE citas
	ADD COLUMN fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ADD COLUMN usuario_BD VARCHAR(100) NOT NULL;
    DELIMITER //
		CREATE TRIGGER antes_insertar_citas
		BEFORE INSERT ON citas
		FOR EACH ROW
		BEGIN
			SET NEW.usuario_BD = USER();
			SET NEW.fecha_modificacion = NOW();
		END;
	// DELIMITER ;
DELIMITER //
CREATE TRIGGER antes_actualizar_citas
    BEFORE UPDATE ON citas
    FOR EACH ROW
    BEGIN
        SET NEW.usuario_BD = USER();
        SET NEW.fecha_modificacion = NOW();
    END;
// DELIMITER ;

ALTER TABLE tratamientos
	ADD COLUMN fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ADD COLUMN usuario_BD VARCHAR(100) NOT NULL;
    DELIMITER //
		CREATE TRIGGER antes_insertar_tratamientos
		BEFORE INSERT ON tratamientos
		FOR EACH ROW
		BEGIN
			SET NEW.usuario_BD = USER();
			SET NEW.fecha_modificacion = NOW();
		END;
	// DELIMITER ;
DELIMITER //
CREATE TRIGGER antes_actualizar_tratamientos
    BEFORE UPDATE ON tratamientos
    FOR EACH ROW
    BEGIN
        SET NEW.usuario_BD = USER();
        SET NEW.fecha_modificacion = NOW();
    END;
// DELIMITER ;

ALTER TABLE expedientes_medicos
	ADD COLUMN fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ADD COLUMN usuario_BD VARCHAR(100) NOT NULL;
    DELIMITER //
		CREATE TRIGGER antes_insertar_expedientes_medicos
		BEFORE INSERT ON expedientes_medicos
		FOR EACH ROW
		BEGIN
			SET NEW.usuario_BD = USER();
			SET NEW.fecha_modificacion = NOW();
		END;
	// DELIMITER ;
DELIMITER //
CREATE TRIGGER antes_actualizar_expedientes_medicos
    BEFORE UPDATE ON expedientes_medicos
    FOR EACH ROW
    BEGIN
        SET NEW.usuario_BD = USER();
        SET NEW.fecha_modificacion = NOW();
    END;
// DELIMITER ;

