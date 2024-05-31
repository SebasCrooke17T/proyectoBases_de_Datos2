use proyecto;
show tables;

select * from expedientes_medicos;
select * from expedientes_medicos where id_expediente = 401;

-- para que cada que se actualice un expediente se guarde en el historial
CREATE TABLE IF NOT EXISTS Historial_Expedientes_Medicos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_expediente INT,
    id_paciente INT,
    fecha DATE,
    descripcion TEXT,
    observaciones TEXT,
    ultima_actualizacion TIMESTAMP
);

DELIMITER //

CREATE TRIGGER HistorialExpedienteMedico
AFTER UPDATE ON Expedientes_Medicos
FOR EACH ROW
BEGIN
    INSERT INTO Historial_Expedientes_Medicos (id_expediente, id_paciente, fecha, descripcion, observaciones, ultima_actualizacion)
    VALUES (OLD.id_expediente, OLD.id_paciente, OLD.fecha, OLD.descripcion, OLD.observaciones, NOW());
END;
//
DELIMITER ;

CALL Actualizar_InsertarExpedienteMedico(
	'modificar',
    401, 401, 
    '2024-07-17', 
    'Descripción actualizada del expediente',
    'Observaciones actualizadas, no viene a seguimiento nunca hojala lo den de baja (-_-)',
    401
);

select * from Historial_Expedientes_Medicos;

-- -------------------------------------------------------------------------------------------------------------------------------------

select * from citas;

CREATE TABLE IF NOT EXISTS citasCanceladas (
    id_citasCanceladas INT NOT NULL AUTO_INCREMENT,
    id_cita INT NOT NULL,
    id_paciente int not null,
    id_medico INT,
    fecha_cita DATE,
    hora_cita TIME,
    motivo_cita VARCHAR(100),

	PRIMARY KEY (id_citasCanceladas)
);

DELIMITER //
CREATE TRIGGER citaCancelada
BEFORE delete ON citas
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM citas WHERE 
		old.estado = 'Cancelada') THEN
        insert into citasCanceladas (id_cita, id_paciente, id_medico, fecha_cita, hora_cita, motivo_cita) 
			VALUES (OLD.id_cita, OLD.id_paciente, OLD.id_medico, OLD.fecha_cita, OLD.hora_cita, old.motivo_cita);
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'esta cita no esta cancelada por favor no insistas >:v';
    END IF;
END;
//
DELIMITER ;

CALL Programar_CitaMedica(
    107, 245, '2024-04-11', '15:30:00', 'Consulta general' 
);

select * from citas;

DELETE FROM citas WHERE id_cita = 502;

CALL Modificar_CitaMedica(
    'cancelar',
    501, NULL, NULL, NULL, NULL, NULL
);

DELETE FROM citas WHERE id_cita = 501;

select * from citasCanceladas;


-- -------------------------------------------------------------------------------------------------------------------------------------

-- Índice para búsqueda rápida por nombre de paciente
CREATE INDEX indice_nombre_paciente ON pacientes (nombre);
show index from pacientes;

-- Índice para búsqueda rápida por apellido paterno
CREATE INDEX indice_apellido_paterno_paciente ON pacientes (apellido_p);
show index from pacientes;

-- Índice para búsqueda rápida por fecha de cita
CREATE INDEX indice_fecha_cita ON citas (fecha_cita);
show index from citas;

-- Índice para búsqueda rápida por estado del tratamiento
CREATE INDEX indice_estado_tratamiento ON tratamientos (estado);
show index from tratamientos;
explain SELECT * FROM Tratamientos WHERE estado = 'En curso';

-- -----------------------------------------------------------------------------------------------

-- usuarios de la base que tendran acceso
CREATE USER 'elSuperJefe'@'localhost' IDENTIFIED BY 'h0l41mth3b0s5';
CREATE USER 'admin1'@'localhost' IDENTIFIED BY '1234567';
CREATE USER 'admin2'@'localhost' IDENTIFIED BY '123456789';
CREATE USER 'colado1'@'localhost' IDENTIFIED BY 'h0l4wh4-Th3f4ck';
CREATE USER 'chambeador'@'localhost' IDENTIFIED BY 'odi0m13esta';

-- Asignar privilegios a los nuevos usuarios
GRANT ALL privileges ON proyecto TO 'elSuperJefe'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON proyecto TO 'admin1'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON proyecto TO 'admin2'@'localhost';
GRANT SELECT ON proyecto TO 'colado1'@'localhost';
GRANT SELECT, UPDATE ON proyecto TO 'chambeador'@'localhost';

