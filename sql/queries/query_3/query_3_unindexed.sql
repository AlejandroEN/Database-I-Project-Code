SET search_path TO millon_datos;
SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;
SET enable_nestloop TO OFF;
SET enable_indexscan TO OFF;
SET enable_indexonlyscan TO OFF;


SELECT
    p.nombres,
    p.primer_apellido,
    p.segundo_apellido,
    p.sexo,
    p.email
FROM
    alumno a
JOIN
    persona p ON a.dni = p.dni
JOIN
    apoderado apo ON a.apoderado_dni = apo.dni
JOIN
    colaborador c ON apo.dni = c.dni
JOIN
    matricula m ON a.dni = m.alumno_dni
WHERE
    p.nacimiento_fecha > CURRENT_DATE - INTERVAL '18 years'
    AND c.esta_activo = TRUE
    AND c.horas_semanales_trabajo > 48
    AND c.sueldo_hora * c.horas_semanales_trabajo * 4 < 2000
    AND m.year <= EXTRACT(YEAR FROM CURRENT_DATE) - 2;

--Opcion 2 desoptimizada

SELECT
    persona.nombres,
    persona.primer_apellido,
    persona.segundo_apellido,
    persona.sexo,
    persona.email
FROM
    persona
WHERE
    persona.dni IN (
        SELECT
            alumno.dni
        FROM
            alumno
        WHERE
            alumno.dni IN (
                SELECT
                    matricula.alumno_dni
                FROM
                    matricula
                WHERE
                    matricula.year <= EXTRACT(YEAR FROM CURRENT_DATE) - 2
            )
            AND alumno.apoderado_dni IN (
                SELECT
                    apoderado.dni
                FROM
                    apoderado
                WHERE
                    apoderado.dni IN (
                        SELECT
                            colaborador.dni
                        FROM
                            colaborador
                        WHERE
                            colaborador.esta_activo = TRUE
                            AND colaborador.horas_semanales_trabajo > 48
                            AND colaborador.sueldo_hora * colaborador.horas_semanales_trabajo * 4 < 2000
                    )
            )
    )
    AND persona.nacimiento_fecha > CURRENT_DATE - INTERVAL '18 years';

