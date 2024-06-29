CREATE OR REPLACE FUNCTION gestionar_director_reasignacion() RETURNS TRIGGER AS
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
