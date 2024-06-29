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
