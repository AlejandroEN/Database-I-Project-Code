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

CREATE OR REPLACE FUNCTION check_aforo_salon()
    RETURNS TRIGGER AS $$
DECLARE
    aforo INT;
    cantidad_alumnos INT;
BEGIN
    SELECT aforo INTO aforo FROM Salon WHERE nombreSeccion = NEW.nombreSeccion AND sedeId = NEW.sedeId;
    SELECT COUNT(*) INTO cantidad_alumnos FROM Alumno WHERE nombreSeccion = NEW.nombreSeccion AND sedeId = NEW.sedeId;

    IF (cantidad_alumnos >= aforo) THEN
        RAISE EXCEPTION 'El aforo del salón ha sido superado.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_aforo_trigger
    BEFORE INSERT ON Alumno
    FOR EACH ROW
EXECUTE FUNCTION check_aforo_salon();

----

CREATE OR REPLACE FUNCTION check_sueldo_mensual()
    RETURNS TRIGGER AS $$
DECLARE
    sueldo_mensual FLOAT;
BEGIN
    sueldo_mensual = NEW.sueldoHora * NEW.horasSemanalesTrabajo * 4;

    IF sueldo_mensual < 1025 THEN
        RAISE EXCEPTION 'El sueldo mensual debe ser mayor al sueldo mínimo de 1025.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_sueldo_mensual_trigger
    BEFORE INSERT OR UPDATE ON Colaborador
    FOR EACH ROW
EXECUTE FUNCTION check_sueldo_mensual();

----

CREATE OR REPLACE FUNCTION check_colaborador_roles()
    RETURNS TRIGGER AS $$
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
    BEFORE INSERT ON Consejero
    FOR EACH ROW
EXECUTE FUNCTION check_colaborador_roles();

CREATE TRIGGER check_secretario_roles_trigger
    BEFORE INSERT ON Secretario
    FOR EACH ROW
EXECUTE FUNCTION check_colaborador_roles();

CREATE TRIGGER check_tutor_roles_trigger
    BEFORE INSERT ON Tutor
    FOR EACH ROW
EXECUTE FUNCTION check_colaborador_roles();

----

CREATE OR REPLACE FUNCTION check_profesor_asignacion()
    RETURNS TRIGGER AS $$
DECLARE
    asignado BOOLEAN;
BEGIN
    SELECT TRUE INTO asignado
    FROM ProfesorCursoGrado
    WHERE cursoId = NEW.cursoId AND gradoId = NEW.gradoId AND periodoAcademico = NEW.periodoAcademico AND profesorDni = NEW.profesorDni;

    IF asignado THEN
        RAISE EXCEPTION 'El profesor ya está asignado a este curso para este grado y periodo académico.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_profesor_asignacion_trigger
    BEFORE INSERT ON ProfesorCursoGrado
    FOR EACH ROW
EXECUTE FUNCTION check_profesor_asignacion();

----

CREATE OR REPLACE FUNCTION check_max_secciones()
    RETURNS TRIGGER AS $$
DECLARE
    num_secciones INT;
BEGIN
    SELECT COUNT(*) INTO num_secciones
    FROM Salon
    WHERE sedeId = NEW.sedeId AND gradoId = NEW.gradoId;

    IF num_secciones >= 5 THEN
        RAISE EXCEPTION 'El número de secciones para este grado en esta sede ha alcanzado el límite permitido.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_max_secciones_trigger
    BEFORE INSERT ON Salon
    FOR EACH ROW
EXECUTE FUNCTION check_max_secciones();

----
