SET search_path TO mil_datos;

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

---- la consulta no funciona xd
SELECT persona.nombres,
       persona.email,
       colaborador.numero_celular,
       sede.direccion,
       sede.coordenada_longitud,
       sede.coordenada_latitud
FROM director
         JOIN colaborador ON director.dni = colaborador.dni
         JOIN persona ON colaborador.dni = persona.dni
         JOIN sede ON director.sede_id = sede.id
WHERE sede.id IN (
    SELECT sede.id
    FROM sede
             LEFT JOIN (
        SELECT matricula.sede_id,
               COUNT(*) AS cantidad_alumnos
        FROM matricula
        WHERE EXTRACT(YEAR FROM CURRENT_DATE) = year
        GROUP BY matricula.sede_id
    ) AS alumno_count ON sede.id = alumno_count.sede_id
);
