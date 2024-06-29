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
