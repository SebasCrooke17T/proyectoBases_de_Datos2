-- Vista para obtener información completa de una cita con el nombre del paciente y su doctor al que agendo
DROP VIEW IF exists Vista_Citas_Completas;
CREATE VIEW Vista_Citas_Completas AS
SELECT 
    C.id_cita,
    P.nombre AS nombre_paciente,
    P.apellido_p AS apellido_paciente,
    M.nombre AS nombre_medico,
    M.apellido_p AS apellido_medico,
    C.fecha_cita,
    C.hora_cita,
    C.motivo_cita,
    C.estado
FROM 
    citas C
JOIN 
    pacientes P ON C.id_paciente = P.id_paciente
JOIN 
    medicos M ON C.id_medico = M.id_medico;
    
select * from Vista_Citas_Completas;


-- Vista para ver los tratamientos que estan en curso de los pacientes
DROP VIEW IF exists Vista_Tratamientos_enCurso;
CREATE VIEW Vista_Tratamientos_enCurso AS
SELECT 
    T.id_tratamiento,
    P.nombre AS nombre_paciente,
    P.apellido_p AS apellido_paciente,
    M.nombre AS nombre_medico,
    M.apellido_p AS apellido_medico,
    T.nombre_tratamiento,
    T.descripcion,
    T.fecha_inicio,
    T.fecha_fin,
    T.estado
FROM 
    tratamientos T
JOIN 
    Pacientes P ON T.id_paciente = P.id_paciente
JOIN 
    Medicos M ON T.id_medico = M.id_medico
WHERE 
    T.estado = 'En curso' or T.estado = 'En curso y modificado';

select * from Vista_Tratamientos_enCurso;

-- Vista para ver los tratamientos que estan terminados finiquitados de los pacientes
DROP VIEW IF exists Vista_Tratamientos_terminados;
CREATE VIEW Vista_Tratamientos_terminados AS
SELECT 
    T.id_tratamiento,
    P.nombre AS nombre_paciente,
    P.apellido_p AS apellido_paciente,
    M.nombre AS nombre_medico,
    M.apellido_p AS apellido_medico,
    T.nombre_tratamiento,
    T.descripcion,
    T.fecha_inicio,
    T.fecha_fin,
    T.estado
FROM 
    tratamientos T
JOIN 
    Pacientes P ON T.id_paciente = P.id_paciente
JOIN 
    Medicos M ON T.id_medico = M.id_medico
WHERE 
    T.estado = 'Terminado';

select * from Vista_Tratamientos_terminados;


-- si se desea pasar a otra tabla los tratamientos terminados
Drop table if exists tratamientosTerminados;
CREATE TABLE IF NOT EXISTS tratamientosTerminados (
    id_tratamiento_terminado INT NOT NULL AUTO_INCREMENT,
    id_tratamiento INT NOT NULL,
    id_paciente int not null,
    nombre_tratamiento VARCHAR(255) not null,
    descripcion VARCHAR(255) not null,
    fecha_inicio DATE,
    fecha_fin DATE,

	PRIMARY KEY (id_tratamiento_terminado)
);

select * from tratamientos;
select * from tratamientos where estado = 'Terminado';

drop trigger if exists tratamientoTerminado;
DELIMITER //
CREATE TRIGGER tratamientoTerminado
BEFORE delete ON tratamientos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM tratamientos WHERE 
		old.estado = 'Terminado') THEN
        insert into tratamientosTerminados (id_tratamiento, id_paciente, nombre_tratamiento, descripcion, fecha_inicio, fecha_fin) 
			VALUES (OLD.id_tratamiento, OLD.id_paciente, OLD.nombre_tratamiento, OLD.descripcion, OLD.fecha_inicio, old.fecha_fin);
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'todavia no ha terminado su tratamiento';
    END IF;
END;
//
DELIMITER ;

DELETE FROM tratamientos WHERE id_tratamiento = 501;
select * from tratamientosTerminados;

DELETE FROM tratamientos WHERE id_tratamiento = 2;


select * from pacientes;
select * from medicos;
select * from citas;
select * from tratamientos;
select * from expedientes_medicos;

DELIMITER //
CREATE TRIGGER antesInsertarPaciente
BEFORE INSERT ON pacientes
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM pacientes WHERE 
		nombre = NEW.nombre and 
        apellido_p = new.apellido_p and 
        apellido_m = new.apellido_m and 
        fecha_nacimiento = new.fecha_nacimiento) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un paciente con estos datos ya existe.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER antesInsertarMedico
BEFORE INSERT ON medicos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM medicos WHERE 
		nombre = NEW.nombre and 
        apellido_p = new.apellido_p and 
        apellido_m = new.apellido_m and 
        especialidad = new.especialidad) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un medico con estos datos ya existe.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER antesInsertarCita
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM citas WHERE 
		id_paciente = NEW.id_paciente and 
        id_medico = new.id_medico and 
        fecha_cita = new.fecha_cita and 
        hora_cita = new.hora_cita) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una cita con estos datos ya existe.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER antesInsertarTratamiento
BEFORE INSERT ON tratamientos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM tratamientos WHERE 
		id_paciente = NEW.id_paciente and 
        id_medico = new.id_medico and 
        nombre_tratamiento = new.nombre_tratamiento and 
        fecha_inicio = new.fecha_inicio and
        fecha_fin = new.fecha_fin) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un tratamiento con estos datos ya existe.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER antesInsertarExpediente
BEFORE INSERT ON expedientes_medicos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM expedientes_medicos WHERE 
		id_paciente = NEW.id_paciente and 
        fecha = new.fecha and 
        descripcion = new.descripcion and 
        id_tratamiento = new.id_tratamiento) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un expediente con estos datos ya existe.';
    END IF;
END;
//
DELIMITER ;
