CREATE OR REPLACE FUNCTION function_check_alumno_overlapping_colaborador_apoderado() RETURNS TRIGGER AS
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
