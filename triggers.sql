CREATE OR REPLACE FUNCTION function_check_matricula_year() RETURNS TRIGGER AS
$$
BEGIN
    IF new.year <= (SELECT EXTRACT(YEAR FROM construccion_fecha) FROM sede WHERE id = new.sede_id) THEN
        RAISE EXCEPTION 'El año de matrícula debe ser mayor que el año de construcción de la sede.';
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_matricula_year
    BEFORE INSERT OR UPDATE
    ON matricula
    FOR EACH ROW
EXECUTE FUNCTION function_check_matricula_year();

----

CREATE OR REPLACE FUNCTION function_check_colaborador_sueldo_mensual()
    RETURNS TRIGGER AS
$$
DECLARE
    sueldo_mensual INT;
BEGIN
    sueldo_mensual = new.sueldo_hora * new.horas_semanales_trabajo * 4;

    IF sueldo_mensual < 1025 THEN
        RAISE EXCEPTION 'El sueldo mensual debe ser % mayor al sueldo mínimo de 1025.', sueldo_mensual;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_colaborador_sueldo_mensual
    BEFORE INSERT OR UPDATE
    ON colaborador
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_sueldo_mensual();

----

CREATE OR REPLACE FUNCTION function_check_colaborador_overlapping()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (EXISTS (SELECT 1 FROM profesor WHERE dni = new.dni)) OR
       (EXISTS (SELECT 1 FROM consejero WHERE dni = new.dni)) OR
       (EXISTS (SELECT 1 FROM secretario WHERE dni = new.dni)) OR
       (EXISTS (SELECT 1 FROM director WHERE dni = new.dni)) OR
       (EXISTS (SELECT 1 FROM tutor WHERE dni = new.dni)) THEN
        RAISE EXCEPTION 'El colaborador con DNI % ya existe en otra tabla hija.', new.dni;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_profesor_overlapping
    BEFORE INSERT
    ON profesor
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_overlapping();

CREATE TRIGGER trigger_check_profesor_overlapping
    BEFORE INSERT
    ON consejero
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_overlapping();

CREATE TRIGGER trigger_check_secretario_overlapping
    BEFORE INSERT
    ON secretario
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_overlapping();

CREATE TRIGGER trigger_check_director_overlapping
    BEFORE INSERT
    ON director
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_overlapping();

CREATE TRIGGER trigger_check_tutor_overlapping
    BEFORE INSERT
    ON tutor
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_overlapping();

----

CREATE OR REPLACE FUNCTION function_check_colaborador_apoderado_overlapping_alumno()
    RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM alumno WHERE dni = new.dni) THEN
        RAISE EXCEPTION 'La persona con DNI % ya existe en la tabla Alumno.', new.dni;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_colaborador_overlapping
    BEFORE INSERT
    ON colaborador
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_apoderado_overlapping_alumno();

CREATE TRIGGER trigger_check_apoderado_overlapping
    BEFORE INSERT
    ON apoderado
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_apoderado_overlapping_alumno();

----

CREATE OR REPLACE FUNCTION function_check_alumno_overlapping_colaborador_apoderado()
    RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM colaborador WHERE dni = new.dni) OR
       EXISTS (SELECT 1 FROM apoderado WHERE dni = new.dni) THEN
        RAISE EXCEPTION 'La persona con DNI % ya existe en las tablas Colaborador o Apoderado.', new.dni;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_alumno_overlapping
    BEFORE INSERT
    ON alumno
    FOR EACH ROW
EXECUTE FUNCTION function_check_alumno_overlapping_colaborador_apoderado();

----

CREATE OR REPLACE FUNCTION function_check_profesor_asignacion()
    RETURNS TRIGGER AS
$$
DECLARE
    is_asignado BOOLEAN;
BEGIN
    SELECT TRUE
    INTO is_asignado
    FROM profesor_curso_grado
    WHERE curso_id = new.curso_id
      AND grado_id = new.grado_id
      AND periodo_academico = new.periodo_academico
      AND profesor_dni = new.profesor_dni;

    IF is_asignado THEN
        RAISE EXCEPTION 'El profesor ya está asignado a este curso para este grado y periodo académico.';
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_profesor_asignacion
    BEFORE INSERT
    ON profesor_curso_grado
    FOR EACH ROW
EXECUTE FUNCTION function_check_profesor_asignacion();

----

CREATE OR REPLACE FUNCTION function_check_institucion_construccion_fecha()
    RETURNS TRIGGER AS
$$
BEGIN
    IF new.construccion_fecha < (SELECT fundacion_fecha FROM institucion WHERE ruc = new.institucion_ruc) THEN
        RAISE EXCEPTION 'La fecha de construcción no puede ser anterior a la fecha de fundación de la institución.';
    END IF;

    IF new.construccion_fecha > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de construcción no puede ser mayor que la fecha actual.';
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_institucion_construccion_fecha
    BEFORE INSERT OR UPDATE
    ON sede
    FOR EACH ROW
EXECUTE FUNCTION function_check_institucion_construccion_fecha();

----

CREATE OR REPLACE FUNCTION function_check_max_salones_per_grado()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM salon WHERE grado_id = new.grado_id) >= 15 THEN
        RAISE EXCEPTION 'El grado ya tiene el máximo de 15 salones.';
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_max_salones_per_grado
    BEFORE INSERT
    ON salon
    FOR EACH ROW
EXECUTE FUNCTION function_check_max_salones_per_grado();

----

CREATE OR REPLACE FUNCTION function_check_alumno_aforo()
    RETURNS TRIGGER AS
$$
DECLARE
    aforo_maximo   INT;
    numero_alumnos INT;
BEGIN
    SELECT aforo
    INTO aforo_maximo
    FROM salon
    WHERE nombre_seccion = new.nombre_seccion
      AND sede_id = new.sede_id;

    SELECT COUNT(*) + 1
    INTO numero_alumnos
    FROM alumno
    WHERE salon_nombre_seccion = new.salon_nombre_seccion
      AND salon_sede_id = new.salon_sede_id;

    IF numero_alumnos > aforo_maximo THEN
        RAISE EXCEPTION 'El aforo del salón ha sido excedido. Aforo máximo: %, Número de alumnos: %', aforo_maximo, numero_alumnos;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_alumno_aforo
    BEFORE INSERT
    ON alumno
    FOR EACH ROW
EXECUTE FUNCTION function_check_alumno_aforo();

CREATE OR REPLACE FUNCTION function_check_matricula_aforo()
    RETURNS TRIGGER AS
$$
DECLARE
    aforo_maximo   INT;
    numero_alumnos INT;
    nombre_seccion VARCHAR(50);
    sede_id        INT;
BEGIN
    SELECT nombre_seccion, sede_id
    INTO nombre_seccion, sede_id
    FROM alumno
    WHERE dni = new.alumno_dni;

    SELECT aforo
    INTO aforo_maximo
    FROM salon
    WHERE nombre_seccion = new.nombre_seccion
      AND sede_id = new.sede_id;

    SELECT COUNT(*)
    INTO numero_alumnos
    FROM alumno
    WHERE nombre_seccion = new.nombre_seccion
      AND sede_id = new.sede_id;

    IF numero_alumnos > aforo_maximo THEN
        RAISE EXCEPTION 'El aforo del salón ha sido excedido. Aforo máximo: %, Número de alumnos: %', aforo_maximo, numero_alumnos + 1;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_matricula_aforo
    BEFORE INSERT
    ON matricula
    FOR EACH ROW
EXECUTE FUNCTION function_check_matricula_aforo();

----

CREATE OR REPLACE FUNCTION function_check_secretario_activo()
    RETURNS TRIGGER AS
$$
DECLARE
    esta_activo     BOOLEAN;
    sede_secretario INT;
BEGIN
    SELECT esta_activo, sede_id
    INTO esta_activo, sede_secretario
    FROM secretario
             JOIN colaborador ON secretario.dni = colaborador.dni
    WHERE secretario.dni = new.secretariodni;

    IF NOT esta_activo OR sede_secretario != new.sedeid THEN
        RAISE EXCEPTION 'El secretario con DNI % no está activo en la sede %', new.secretariodni, new.sedeid;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_secretario_activo
    BEFORE INSERT
    ON matricula
    FOR EACH ROW
EXECUTE FUNCTION function_check_secretario_activo();

----

-- Todo: Rename
CREATE OR REPLACE FUNCTION gestionar_director_reasignacion()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM director WHERE sede_id = old.sede_id AND dni != old.dni) = 0 THEN
        RAISE EXCEPTION 'No se puede reasignar el director sin reemplazo en la sede %', old.sedeid;
    END IF;

    DELETE FROM director WHERE dni = old.dni;

    UPDATE colaborador SET esta_activo = FALSE WHERE dni = old.dni;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gestionar_director_reasignacion
    AFTER UPDATE
    ON director
    FOR EACH ROW
    WHEN (old.dni IS DISTINCT FROM new.dni)
EXECUTE FUNCTION gestionar_director_reasignacion();

----

CREATE OR REPLACE FUNCTION gestionar_tutor_reasignacion()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT COUNT(*)
        FROM tutor
        WHERE salon_nombre_seccion = old.salon_nombre_seccion
          AND sede_id = old.sede_id
          AND dni != old.dni) = 0 THEN
        RAISE EXCEPTION 'No se puede reasignar el tutor sin reemplazo en el salón % de la sede %', old.salon_nombre_seccion, old.sede_id;
    END IF;

    DELETE FROM tutor WHERE dni = old.dni AND salon_nombre_seccion = old.salon_nombre_seccion AND sede_id = old.sede_id;

    UPDATE colaborador SET esta_activo = FALSE WHERE dni = old.dni;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gestionar_tutor_reasignacion
    AFTER UPDATE
    ON tutor
    FOR EACH ROW
    WHEN (old.dni IS DISTINCT FROM new.dni OR old.salon_nombre_seccion IS DISTINCT FROM new.salon_nombre_seccion OR
          old.sede_id IS DISTINCT FROM new.sede_id)
EXECUTE FUNCTION gestionar_tutor_reasignacion();

----
