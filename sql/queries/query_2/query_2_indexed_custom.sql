SET search_path TO millon_datos;
SET enable_mergejoin TO ON;
SET enable_hashjoin TO ON;
SET enable_bitmapscan TO ON;
SET enable_sort TO ON;
SET enable_nestloop TO ON;
SET enable_indexscan TO ON;
SET enable_indexonlyscan TO ON;

VACUUM colaborador;
VACUUM persona;
VACUUM profesor_sede;

CREATE INDEX idx_persona_nacimiento_fecha ON persona (nacimiento_fecha);

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

DROP INDEX IF EXISTS idx_persona_nacimiento_fecha;
