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
