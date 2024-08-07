SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;
SET enable_nestloop TO OFF;
SET enable_indexscan TO OFF;
SET enable_indexonlyscan TO OFF;

DROP INDEX IF EXISTS idx_horas_semanales_trabajo;

VACUUM FULL colaborador;
VACUUM FULL apoderado;
VACUUM FULL alumno;
VACUUM FULL matricula;
VACUUM FULL persona;

EXPLAIN ANALYSE
SELECT persona.nombres,
       persona.primer_apellido,
       persona.segundo_apellido,
       persona.sexo,
       persona.email
FROM persona
WHERE persona.dni IN (SELECT alumno.dni
                      FROM alumno
                      WHERE alumno.dni IN (SELECT matricula.alumno_dni
                                           FROM matricula
                                           WHERE matricula.year <= EXTRACT(YEAR FROM CURRENT_DATE) - 2)
                        AND alumno.apoderado_dni IN (SELECT apoderado.dni
                                                     FROM apoderado
                                                     WHERE apoderado.dni IN (SELECT colaborador.dni
                                                                             FROM colaborador
                                                                             WHERE colaborador.esta_activo = TRUE
                                                                               AND colaborador.horas_semanales_trabajo > 48
                                                                               AND colaborador.sueldo_hora * colaborador.horas_semanales_trabajo * 4 < 2000)))
  AND persona.nacimiento_fecha > CURRENT_DATE - INTERVAL '18 years';
