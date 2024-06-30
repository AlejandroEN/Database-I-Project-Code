SET search_path TO millon_datos;
SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;
SET enable_nestloop TO OFF;
SET enable_indexscan TO OFF;
SET enable_indexonlyscan TO OFF;

VACUUM FULL persona;
VACUUM FULL colaborador;
VACUUM FULL director;
VACUUM FULL sede;
VACUUM FULL matricula;

EXPLAIN ANALYSE
SELECT
    persona.nombres || ' ' || persona.primer_apellido || ' ' || persona.segundo_apellido AS nombre_director,
    persona.email,
    colaborador.numero_celular,
    sede.direccion,
    sede.coordenada_longitud,
    sede.coordenada_latitud
FROM
    director
        JOIN colaborador ON director.dni = colaborador.dni
        JOIN persona ON colaborador.dni = persona.dni
        JOIN sede ON director.sede_id = sede.id
WHERE
    sede.id IN (
        SELECT
            sede.id
        FROM (
                 SELECT
                     sede.id,
                     COUNT(salon.nombre_seccion) AS numero_salones,
                     (SELECT COUNT(matricula.alumno_dni)
                      FROM matricula
                      WHERE matricula.sede_id = sede.id AND matricula.year = EXTRACT(YEAR FROM CURRENT_DATE)) AS numero_alumnos
                 FROM
                     sede
                         LEFT JOIN salon ON sede.id = salon.sede_id
                 GROUP BY
                     sede.id,
                     sede.construccion_fecha
                 ORDER BY
                     numero_salones DESC,
                     sede.construccion_fecha
                 LIMIT 20
             ) AS sedes_filtradas
        WHERE sedes_filtradas.numero_alumnos <= 5000
    )
ORDER BY
    sede.id;
