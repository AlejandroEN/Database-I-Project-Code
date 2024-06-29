CREATE OR REPLACE FUNCTION function_check_colaborador_sueldo_mensual() RETURNS TRIGGER AS
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

CREATE OR REPLACE FUNCTION function_check_colaborador_overlapping() RETURNS TRIGGER AS
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

CREATE TRIGGER trigger_check_consejero_overlapping
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

CREATE OR REPLACE FUNCTION function_check_colaborador_apoderado_overlapping_alumno() RETURNS TRIGGER AS
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
CREATE OR REPLACE FUNCTION function_check_colaborador_esta_activo() RETURNS TRIGGER AS
$$
DECLARE
    esta_activo BOOLEAN;
BEGIN
    SELECT esta_activo
    INTO esta_activo
    FROM colaborador
    WHERE new.dni = dni;

    IF NOT esta_activo THEN
        RAISE EXCEPTION 'El colaborador que se intenta insertar no está activo.';
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_profesor_esta_activo
    BEFORE INSERT OR UPDATE
    ON persona
    FOR EACH ROW
EXECUTE FUNCTION function_check_colaborador_esta_activo();
