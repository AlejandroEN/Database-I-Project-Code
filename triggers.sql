CREATE OR REPLACE FUNCTION validar_year_matricula() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.year <= (SELECT EXTRACT(YEAR FROM construccionFecha) FROM Sede WHERE id = NEW.sedeId) THEN
        RAISE EXCEPTION 'El año de matrícula debe ser mayor que el año de construcción de la sede.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_year_matricula
    BEFORE INSERT OR UPDATE
    ON Matricula
    FOR EACH ROW
EXECUTE FUNCTION validar_year_matricula();

----

CREATE OR REPLACE FUNCTION check_sueldo_mensual()
    RETURNS TRIGGER AS
$$
DECLARE
    sueldo_mensual INT;
BEGIN
    sueldo_mensual = NEW.sueldoHora * NEW.horasSemanalesTrabajo * 4;

    IF sueldo_mensual < 1025 THEN
        RAISE EXCEPTION 'El sueldo mensual debe ser % mayor al sueldo mínimo de 1025.', sueldo_mensual;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_sueldo_mensual_trigger
    BEFORE INSERT OR UPDATE
    ON Colaborador
    FOR EACH ROW
EXECUTE FUNCTION check_sueldo_mensual();

----

CREATE OR REPLACE FUNCTION evitar_solapamiento_colaboradores()
    RETURNS TRIGGER AS $$
BEGIN
    IF (EXISTS (SELECT 1 FROM Profesor WHERE dni = NEW.dni)) OR
       (EXISTS (SELECT 1 FROM Consejero WHERE dni = NEW.dni)) OR
       (EXISTS (SELECT 1 FROM Secretario WHERE dni = NEW.dni)) OR
       (EXISTS (SELECT 1 FROM Director WHERE dni = NEW.dni)) OR
       (EXISTS (SELECT 1 FROM Tutor WHERE dni = NEW.dni)) THEN
        RAISE EXCEPTION 'El colaborador con DNI % ya existe en otra tabla hija', NEW.dni;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER evitar_solapamiento_profesor
    BEFORE INSERT ON Profesor
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_colaboradores();

CREATE TRIGGER evitar_solapamiento_consejero
    BEFORE INSERT ON Consejero
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_colaboradores();

CREATE TRIGGER evitar_solapamiento_secretario
    BEFORE INSERT ON Secretario
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_colaboradores();

CREATE TRIGGER evitar_solapamiento_director
    BEFORE INSERT ON Director
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_colaboradores();

CREATE TRIGGER evitar_solapamiento_tutor
    BEFORE INSERT ON Tutor
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_colaboradores();

----

CREATE OR REPLACE FUNCTION evitar_solapamiento_con_alumno()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Alumno WHERE dni = NEW.dni) THEN
        RAISE EXCEPTION 'La persona con DNI % ya existe en la tabla Alumno', NEW.dni;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER evitar_solapamiento_colaborador
    BEFORE INSERT ON Colaborador
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_con_alumno();

CREATE TRIGGER evitar_solapamiento_apoderado
    BEFORE INSERT ON Apoderado
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_con_alumno();

CREATE OR REPLACE FUNCTION evitar_solapamiento_con_colaborador_apoderado()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Colaborador WHERE dni = NEW.dni) OR
       EXISTS (SELECT 1 FROM Apoderado WHERE dni = NEW.dni) THEN
        RAISE EXCEPTION 'La persona con DNI % ya existe en las tablas Colaborador o Apoderado', NEW.dni;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER evitar_solapamiento_alumno
    BEFORE INSERT ON Alumno
    FOR EACH ROW
EXECUTE FUNCTION evitar_solapamiento_con_colaborador_apoderado();

----

CREATE OR REPLACE FUNCTION check_profesor_asignacion()
    RETURNS TRIGGER AS
$$
DECLARE
    asignado BOOLEAN;
BEGIN
    SELECT TRUE
    INTO asignado
    FROM ProfesorCursoGrado
    WHERE cursoId = NEW.cursoId
      AND gradoId = NEW.gradoId
      AND periodoAcademico = NEW.periodoAcademico
      AND profesorDni = NEW.profesorDni;

    IF asignado THEN
        RAISE EXCEPTION 'El profesor ya está asignado a este curso para este grado y periodo académico.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_profesor_asignacion_trigger
    BEFORE INSERT
    ON ProfesorCursoGrado
    FOR EACH ROW
EXECUTE FUNCTION check_profesor_asignacion();

----

CREATE OR REPLACE FUNCTION check_construction_date()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.construccionFecha < (SELECT fundacionFecha FROM Institucion WHERE ruc = NEW.institucionRuc) THEN
        RAISE EXCEPTION 'La fecha de construcción no puede ser anterior a la fecha de fundación de la institución.';
    END IF;

    IF NEW.construccionFecha > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de construcción no puede ser mayor que la fecha actual.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_construction_date_trigger
    BEFORE INSERT OR UPDATE
    ON Sede
    FOR EACH ROW
EXECUTE FUNCTION check_construction_date();

----

CREATE OR REPLACE FUNCTION check_max_salones_per_grado()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM Salon WHERE gradoId = NEW.gradoId) >= 15 THEN
        RAISE EXCEPTION 'El grado ya tiene el máximo de 15 salones.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_max_salones_per_grado_trigger
    BEFORE INSERT
    ON Salon
    FOR EACH ROW
EXECUTE FUNCTION check_max_salones_per_grado();

----

CREATE OR REPLACE FUNCTION validar_aforo_alumno()
    RETURNS TRIGGER AS $$
DECLARE
    aforo_maximo INT;
    numero_alumnos INT;
BEGIN
    SELECT aforo INTO aforo_maximo
    FROM Salon
    WHERE nombreSeccion = NEW.nombreSeccion AND sedeId = NEW.sedeId;

    SELECT COUNT(*) + 1 INTO numero_alumnos
    FROM Alumno
    WHERE nombreSeccion = NEW.nombreSeccion AND sedeId = NEW.sedeId;

    IF numero_alumnos > aforo_maximo THEN
        RAISE EXCEPTION 'El aforo del salón ha sido excedido. Aforo máximo: %, Número de alumnos: %', aforo_maximo, numero_alumnos;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_aforo_alumno
    BEFORE INSERT ON Alumno
    FOR EACH ROW
EXECUTE FUNCTION validar_aforo_alumno();

CREATE OR REPLACE FUNCTION validar_aforo_matricula()
    RETURNS TRIGGER AS $$
DECLARE
    aforo_maximo INT;
    numero_alumnos INT;
    nombre_seccion VARCHAR(50);
    sede_id INT;
BEGIN
    SELECT nombreSeccion, sedeId INTO nombre_seccion, sede_id
    FROM Alumno
    WHERE dni = NEW.alumnoDni;

    SELECT aforo INTO aforo_maximo
    FROM Salon
    WHERE nombreSeccion = nombre_seccion AND sedeId = sede_id;

    SELECT COUNT(*) INTO numero_alumnos
    FROM Alumno
    WHERE nombreSeccion = nombre_seccion AND sedeId = sede_id;

    IF numero_alumnos > aforo_maximo THEN
        RAISE EXCEPTION 'El aforo del salón ha sido excedido. Aforo máximo: %, Número de alumnos: %', aforo_maximo, numero_alumnos + 1;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_aforo_matricula
    BEFORE INSERT ON Matricula
    FOR EACH ROW
EXECUTE FUNCTION validar_aforo_matricula();

----

CREATE OR REPLACE FUNCTION validar_secretario_activo()
    RETURNS TRIGGER AS $$
DECLARE
    esta_activo BOOLEAN;
    sede_secretario INT;
BEGIN
    SELECT estaActivo, sedeId INTO esta_activo, sede_secretario
    FROM Secretario
             JOIN Colaborador ON Secretario.dni = Colaborador.dni
    WHERE Secretario.dni = NEW.secretarioDni;

    IF NOT esta_activo OR sede_secretario != NEW.sedeId THEN
        RAISE EXCEPTION 'El secretario con DNI % no está activo en la sede %', NEW.secretarioDni, NEW.sedeId;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_secretario_activo
    BEFORE INSERT ON Matricula
    FOR EACH ROW
EXECUTE FUNCTION validar_secretario_activo();

----

CREATE OR REPLACE FUNCTION gestionar_director_reasignacion()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Director WHERE sedeId = OLD.sedeId AND dni != OLD.dni) = 0 THEN
        RAISE EXCEPTION 'No se puede reasignar el director sin reemplazo en la sede %', OLD.sedeId;
    END IF;

    DELETE FROM Director WHERE dni = OLD.dni;

    UPDATE Colaborador SET estaActivo = FALSE WHERE dni = OLD.dni;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gestionar_director_reasignacion
    AFTER UPDATE ON Director
    FOR EACH ROW
    WHEN (OLD.dni IS DISTINCT FROM NEW.dni)
EXECUTE FUNCTION gestionar_director_reasignacion();

----

CREATE OR REPLACE FUNCTION gestionar_tutor_reasignacion()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Tutor WHERE salonNombreSeccion = OLD.salonNombreSeccion AND sedeId = OLD.sedeId AND dni != OLD.dni) = 0 THEN
        RAISE EXCEPTION 'No se puede reasignar el tutor sin reemplazo en el salón % de la sede %', OLD.salonNombreSeccion, OLD.sedeId;
    END IF;

    DELETE FROM Tutor WHERE dni = OLD.dni AND salonNombreSeccion = OLD.salonNombreSeccion AND sedeId = OLD.sedeId;

    UPDATE Colaborador SET estaActivo = FALSE WHERE dni = OLD.dni;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gestionar_tutor_reasignacion
    AFTER UPDATE ON Tutor
    FOR EACH ROW
    WHEN (OLD.dni IS DISTINCT FROM NEW.dni OR OLD.salonNombreSeccion IS DISTINCT FROM NEW.salonNombreSeccion OR OLD.sedeId IS DISTINCT FROM NEW.sedeId)
EXECUTE FUNCTION gestionar_tutor_reasignacion();

----