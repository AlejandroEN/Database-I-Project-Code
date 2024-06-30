SET search_path TO millon_datos;
SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;
SET enable_nestloop TO OFF;
SET enable_indexscan TO OFF;
SET enable_indexonlyscan TO OFF;

VACUUM FULL colaborador;
VACUUM FULL persona;
VACUUM FULL profesor_sede;
VACUUM FULL sede;

EXPLAIN ANALYSE
SELECT persona.nombres || ' ' || persona.primer_apellido || ' ' || persona.segundo_apellido AS nombre_completo,
       persona.nacimiento_fecha,
       (colaborador.sueldo_hora * colaborador.horas_semanales_trabajo * 4 * 0.05 *
        CASE
            WHEN numero_sedes_aniversario.numero_sedes IS NOT NULL THEN numero_sedes_aniversario.numero_sedes
            ELSE 1
            END)                                                                            AS bonificacion,
       colaborador.cci,
       persona.email
FROM colaborador
         JOIN persona ON colaborador.dni = persona.dni
         LEFT JOIN (SELECT profesor_sede.profesor_dni,
                           COUNT(sede.id) AS numero_sedes
                    FROM profesor_sede
                             JOIN sede ON profesor_sede.sede_id = sede.id
                    WHERE EXTRACT(YEAR FROM AGE(sede.construccion_fecha)) % 10 = 0
                      AND EXTRACT(YEAR FROM AGE(sede.construccion_fecha)) != 0
                    GROUP BY profesor_sede.profesor_dni) numero_sedes_aniversario
                   ON colaborador.dni = numero_sedes_aniversario.profesor_dni
WHERE colaborador.esta_activo = TRUE
  AND persona.nacimiento_fecha BETWEEN '1960-01-01' AND '1980-12-31'
ORDER BY nombre_completo;
