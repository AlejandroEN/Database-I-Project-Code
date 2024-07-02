SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;
SET enable_nestloop TO OFF;
SET enable_indexscan TO OFF;
SET enable_indexonlyscan TO OFF;

DROP INDEX IF EXISTS idx_sede_construccion_fecha;

VACUUM FULL persona;
VACUUM FULL colaborador;
VACUUM FULL director;
VACUUM FULL sede;
VACUUM FULL profesor_sede;
VACUUM FULL alumno;

EXPLAIN ANALYZE
SELECT
    d_persona.nombres || ' ' || d_persona.primer_apellido || ' ' || d_persona.segundo_apellido AS nombre_director,
    d_persona.email AS email_director,
    d_colaborador.numero_celular AS celular_director,
    sede.direccion,
    sede.coordenada_longitud,
    sede.coordenada_latitud,
    sede.construccion_fecha
FROM
    director
        JOIN colaborador AS d_colaborador ON director.dni = d_colaborador.dni
        JOIN persona AS d_persona ON d_colaborador.dni = d_persona.dni
        JOIN sede ON director.sede_id = sede.id
WHERE
    sede.construccion_fecha BETWEEN '1920-01-01' AND '2010-12-31'
  AND (
          SELECT COUNT(*)
          FROM profesor_sede
          WHERE profesor_sede.sede_id = sede.id
      ) + (
          SELECT COUNT(*)
          FROM alumno
          WHERE alumno.salon_sede_id = sede.id
      ) <= 400
ORDER BY
    sede.construccion_fecha
LIMIT 20;

