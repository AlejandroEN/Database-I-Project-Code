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



----

CREATE OR REPLACE FUNCTION check_colaborador_roles()
    RETURNS TRIGGER AS
$$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT TRUE INTO existe FROM Consejero WHERE dni = NEW.dni AND sedeId = NEW.sedeId;
    IF existe THEN
        RAISE EXCEPTION 'El colaborador ya es consejero en esta sede.';
    END IF;

    SELECT TRUE INTO existe FROM Secretario WHERE dni = NEW.dni AND sedeId = NEW.sedeId;
    IF existe THEN
        RAISE EXCEPTION 'El colaborador ya es secretario en esta sede.';
    END IF;

    SELECT TRUE INTO existe FROM Tutor WHERE dni = NEW.dni AND sedeId = NEW.sedeId;
    IF existe THEN
        RAISE EXCEPTION 'El colaborador ya es tutor en esta sede.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_consejero_roles_trigger
    BEFORE INSERT
    ON Consejero
    FOR EACH ROW
EXECUTE FUNCTION check_colaborador_roles();

CREATE TRIGGER check_secretario_roles_trigger
    BEFORE INSERT
    ON Secretario
    FOR EACH ROW
EXECUTE FUNCTION check_colaborador_roles();

CREATE TRIGGER check_tutor_roles_trigger
    BEFORE INSERT
    ON Tutor
    FOR EACH ROW
EXECUTE FUNCTION check_colaborador_roles();

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

CREATE OR REPLACE FUNCTION enforce_single_active_director()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT COUNT(*)
        FROM Director d
                 JOIN Colaborador c ON d.dni = c.dni
        WHERE d.sedeId = NEW.sedeId
          AND c.estaActivo) > 0 THEN
        RAISE EXCEPTION 'Ya existe un director activo para esta sede.';
    END IF;

    IF (SELECT COUNT(*)
        FROM Director d
        WHERE d.dni = NEW.dni
          AND d.sedeId <> NEW.sedeId) > 0 THEN
        UPDATE Colaborador
        SET estaActivo = FALSE
        WHERE dni = NEW.dni
          AND estaActivo = TRUE;
    END IF;

    UPDATE Colaborador
    SET estaActivo = TRUE
    WHERE dni = NEW.dni;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_single_active_director_trigger
    BEFORE INSERT OR UPDATE
    ON Director
    FOR EACH ROW
EXECUTE FUNCTION enforce_single_active_director();

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

--- rehacer
CREATE OR REPLACE FUNCTION check_aforo_salon()
    RETURNS TRIGGER AS
$$
DECLARE
    aforo INT;
BEGIN
    SELECT aforo FROM Salon WHERE nombreSeccion = NEW.nombreSeccion AND sedeId = NEW.sedeId;

    IF (50 >= aforo) THEN
        RAISE EXCEPTION 'El aforo del salón ha sido superado.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_aforo_trigger
    BEFORE INSERT
    ON Alumno
    FOR EACH ROW
EXECUTE FUNCTION check_aforo_salon();

----

CREATE OR REPLACE FUNCTION enforce_single_active_tutor()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT COUNT(*)
        FROM Tutor t
                 JOIN Colaborador c ON t.dni = c.dni
        WHERE t.salonNombreSeccion = NEW.salonNombreSeccion
          AND t.sedeId = NEW.sedeId
          AND c.estaActivo) > 0 THEN
        RAISE EXCEPTION 'Ya existe un tutor activo para este salón en esta sede.';
    END IF;

    IF (SELECT COUNT(*)
        FROM Tutor t
        WHERE t.dni = NEW.dni
          AND (t.salonNombreSeccion <> NEW.salonNombreSeccion OR t.sedeId <> NEW.sedeId)) > 0 THEN
        UPDATE Colaborador
        SET estaActivo = FALSE
        WHERE dni = NEW.dni
          AND estaActivo = TRUE;
    END IF;

    UPDATE Colaborador
    SET estaActivo = TRUE
    WHERE dni = NEW.dni;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_single_active_tutor_trigger
    BEFORE INSERT OR UPDATE
    ON Tutor
    FOR EACH ROW
EXECUTE FUNCTION enforce_single_active_tutor();
