/*
1. Registro de Cita Médica: Permite programar, modificar y cancelar
citas.
2. Actualización de Expediente Médico: Gestiona las actualizaciones
en los expedientes médicos de los pacientes.
3. Gestión de Tratamientos: Registra y sigue los tratamientos
prescritos a los pacientes.
*/

-- 1. Registro de Cita Médica: Permite programar, modificar y cancelar citas.

DELIMITER //
DROP PROCEDURE IF EXISTS Programar_CitaMedica //

CREATE PROCEDURE Programar_CitaMedica(        
    IN p_id_paciente INT,    
    IN p_id_medico INT,        
    IN p_fecha_cita DATE,      
    IN p_hora_cita TIME,       
    IN p_motivo_cita VARCHAR(100) 
)
BEGIN
    -- Comprobar si ya existe una cita con los mismos datos
    IF EXISTS (SELECT * FROM citas 
               WHERE id_paciente = p_id_paciente 
                 AND id_medico = p_id_medico 
                 AND fecha_cita = p_fecha_cita 
                 AND hora_cita = p_hora_cita 
                 AND motivo_cita = p_motivo_cita) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una cita con los mismos datos.';
    ELSE
        -- Insertar una nueva cita si no existe ninguna con los mismos datos
        INSERT INTO citas (id_paciente, id_medico, fecha_cita, hora_cita, motivo_cita, estado) 
        VALUES (p_id_paciente, p_id_medico, p_fecha_cita, p_hora_cita, p_motivo_cita, 'Normal');
    END IF;
END //
DELIMITER ;


CALL Programar_CitaMedica(
    10, 2, '2024-06-01', '10:00:00', 'Consulta general' 
);

select * from citas;

drop procedure if exists Modificar_CitaMedica;
DELIMITER //
CREATE PROCEDURE Modificar_CitaMedica (
    IN p_accion VARCHAR(10),  
    IN p_id_cita INT,        
    IN p_id_paciente INT,    
    IN p_id_medico INT,        
    IN p_fecha_cita DATE,      
    IN p_hora_cita TIME,       
    IN p_motivo_cita VARCHAR(100) 
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Manejo de errores
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la operación, no se registro la cita médica';
    END;
    
    IF p_accion = 'modificar' THEN
        UPDATE Citas
        SET id_paciente = p_id_paciente, id_medico = p_id_medico, fecha_cita = p_fecha_cita, hora_cita = p_hora_cita, motivo_cita = p_motivo_cita, estado = 'Modificada'
        WHERE id_cita = p_id_cita;
    
    ELSEIF p_accion = 'cancelar' THEN
        UPDATE Citas
        SET estado = 'Cancelada'
        WHERE id_cita = p_id_cita;
    
    END IF;
END
//
DELIMITER ;

select * from citas;

CALL Modificar_CitaMedica(
    'modificar',
    501,               -- id_cita
    10,               -- id_paciente
    2,               -- id_medico
    '2024-06-02',    -- fecha_cita
    '15:00:00',      -- hora_cita
    'Revisión de resultados' -- motivo_cita
);

CALL Modificar_CitaMedica(
    'cancelar',
    501, NULL, NULL, NULL, NULL, NULL
);


-- ----------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Actualización de Expediente Médico: Gestiona las actualizaciones en los expedientes médicos de los pacientes.

DROP PROCEDURE IF EXISTS Actualizar_InsertarExpedienteMedico;
DELIMITER //
CREATE PROCEDURE Actualizar_InsertarExpedienteMedico (
	IN p_accion VARCHAR(10),  
    IN p_id_expediente INT,
    IN p_id_paciente INT,
    IN p_fecha DATE,
    IN p_descripcion TEXT,
    IN p_observaciones TEXT,
    IN p_id_tratamiento INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Manejo de errores
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la operación de actualización de expediente médico';
    END;

    IF p_accion = 'insertar' THEN
        INSERT INTO Expedientes_Medicos (id_paciente, fecha, descripcion, observaciones, id_tratamiento) 
        VALUES (p_id_paciente, p_fecha, p_descripcion, p_observaciones, p_id_tratamiento);
        
    ELSEIF p_accion = 'modificar' THEN
        UPDATE Expedientes_Medicos
        SET id_paciente = p_id_paciente, fecha = p_fecha, descripcion = p_descripcion, observaciones = p_observaciones, id_tratamiento = p_id_tratamiento
        WHERE id_expediente = p_id_expediente;
    END IF;
END
//
DELIMITER ;

select * from expedientes_medicos;

CALL Actualizar_InsertarExpedienteMedico(
    'insertar',     
    NULL, 1, 
    '2024-06-01',
    'Descripción del expediente',
    'Observaciones adicionales, este paciente es la mamada xd',
    1
);

CALL Actualizar_InsertarExpedienteMedico(
	'modificar',
    501, 1, 
    '2024-06-02', 
    'Descripción actualizada del expediente',
    'Observaciones actualizadas, este paciente ya no es la mamada y esta apunto de recuperarse :D',
    1
);

-- -------------------------------------------------------------------------------------------------------------------

-- 3. Gestión de Tratamientos: Registra y sigue los tratamientos prescritos a los pacientes.
DROP PROCEDURE IF EXISTS GestionTratamientos;
DELIMITER //
CREATE PROCEDURE GestionTratamientos (
    IN p_accion VARCHAR(10),  
    IN p_id_tratamiento INT,  
    IN p_id_paciente INT,    
    IN p_id_medico INT,       
    IN p_nombre_tratamiento VARCHAR(50), 
    IN p_descripcion TEXT,    
    IN p_fecha_inicio DATE,    
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Manejo de errores
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la operación de gestión de tratamientos';
    END;

    IF p_accion = 'insertar' THEN
        INSERT INTO tratamientos (id_paciente, id_medico, nombre_tratamiento, descripcion, fecha_inicio, fecha_fin, estado) 
        VALUES (p_id_paciente, p_id_medico, p_nombre_tratamiento, p_descripcion, p_fecha_inicio, p_fecha_fin, 'En curso');
    
    ELSEIF p_accion = 'modificar' THEN
        UPDATE tratamientos
        SET id_paciente = p_id_paciente, id_medico = p_id_medico, nombre_tratamiento = p_nombre_tratamiento, descripcion = p_descripcion,
			fecha_inicio = p_fecha_inicio, fecha_fin = p_fecha_fin, estado = 'En curso y modificado'
        WHERE id_tratamiento = p_id_tratamiento;
        
	ELSEIF p_accion = 'terminar' THEN
        UPDATE tratamientos
        SET estado = 'Terminado'
        WHERE id_tratamiento = p_id_tratamiento;
    
    END IF;
END
//
DELIMITER ;

select * from tratamientos;

CALL GestionTratamientos(
    'insertar', 
    NULL, 1, 2, 
    'Fisioterapia',  
    'Sesiones de fisioterapia para recuperación de lesión en la pierna.',
    '2024-06-01',    -- fecha_inicio
    '2024-06-30'   -- fecha_fin       
);

CALL GestionTratamientos(
    'modificar', 
    501, 1, 2, 
    'Fisioterapia avanzada', 
    'Sesiones avanzadas de fisioterapia.', 
    '2024-06-01',    -- fecha_inicio
    '2024-07-01'   -- fecha_fin    
);

CALL GestionTratamientos(
    'terminar', 
    501, null, null, null, null, null, null  
);






