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
