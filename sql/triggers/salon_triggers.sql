CREATE OR REPLACE FUNCTION function_check_salon_aforo_on_alumno()
    RETURNS TRIGGER AS
$$
DECLARE
    salon_aforo      INT;
    alumnos_cantidad INT;
BEGIN
    SELECT aforo
    INTO salon_aforo
    FROM salon
    WHERE nombre_seccion = new.nombre_seccion
      AND sede_id = new.sede_id;

    SELECT COUNT(dni) + 1
    INTO alumnos_cantidad
    FROM alumno
    WHERE salon_nombre_seccion = new.salon_nombre_seccion
      AND salon_sede_id = new.salon_sede_id;

    IF alumnos_cantidad > salon_aforo THEN
        RAISE EXCEPTION 'El aforo del salón ha sido excedido. Aforo máximo: %, Número de alumnos: %', salon_aforo, alumnos_cantidad;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_salon_aforo_on_alumno
    BEFORE INSERT
    ON alumno
    FOR EACH ROW
EXECUTE FUNCTION function_check_salon_aforo_on_alumno();

----

CREATE OR REPLACE FUNCTION function_check_salon_aforo_on_matricula()
    RETURNS TRIGGER AS
$$
DECLARE
    salon_aforo          INT;
    alumnos_cantidad     INT;
    salon_nombre_seccion VARCHAR(50);
    salon_sede_id        INT;
BEGIN
    SELECT salon_nombre_seccion, salon_sede_id
    INTO salon_nombre_seccion, salon_sede_id
    FROM alumno
    WHERE dni = new.alumno_dni;

    SELECT aforo
    INTO salon_aforo
    FROM salon
    WHERE salon_nombre_seccion = new.nombre_seccion
      AND salon_sede_id = new.sede_id;

    SELECT COUNT(dni) + 1
    INTO alumnos_cantidad
    FROM alumno
    WHERE salon_nombre_seccion = new.nombre_seccion
      AND salon_sede_id = new.sede_id;

    IF alumnos_cantidad > salon_aforo THEN
        RAISE EXCEPTION 'El aforo del salón ha sido excedido. Aforo máximo: %, Número de alumnos: %', salon_aforo, alumnos_cantidad + 1;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_salon_aforo_on_matricula
    BEFORE INSERT
    ON matricula
    FOR EACH ROW
EXECUTE FUNCTION function_check_salon_aforo_on_matricula();
