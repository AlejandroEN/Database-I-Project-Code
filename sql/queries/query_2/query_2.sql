SELECT CONCAT(Persona.nombres, ' ', Persona.primerApellido, ' ', Persona.segundoApellido) AS nombreCompleto,
       Colaborador.cci,
       Persona.email,
       CASE
           WHEN Profesor.dni IS NOT NULL THEN
               Colaborador.sueldoHora * Colaborador.horasSemanalesTrabajo * 4 * 0.05 *
               (SELECT COUNT(*)
                FROM Sede
                         JOIN ProfesorSede ON Sede.id = ProfesorSede.sedeId
                WHERE ProfesorSede.profesorDni = Profesor.dni
                  AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Sede.construccionFecha)) % 10 = 0
                  AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Sede.construccionFecha)) > 0)
           ELSE
               Colaborador.sueldoHora * Colaborador.horasSemanalesTrabajo * 4 * 0.05 *
               (CASE
                    WHEN (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM (SELECT MIN(Sede.construccionFecha)
                                                                               FROM Sede
                                                                                        JOIN Colaborador AS C ON C.dni = Colaborador.dni
                                                                               WHERE C.dni = Colaborador.dni
                                                                                     AND (EXTRACT(YEAR FROM CURRENT_DATE) -
                                                                                          EXTRACT(YEAR FROM Sede.construccionFecha)) %
                                                                                         10 = 0
                                                                                     AND (EXTRACT(YEAR FROM CURRENT_DATE) -
                                                                                          EXTRACT(YEAR FROM Sede.construccionFecha)) >
                                                                                         0))) >= 10 THEN 1
                                                                                     ELSE 0 END)
                                                                               END  AS bonificacion
FROM Colaborador
         JOIN Persona ON Colaborador.dni = Persona.dni
         LEFT JOIN Profesor ON Colaborador.dni = Profesor.dni
WHERE Colaborador.estaActivo = TRUE
  AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Persona.nacimientoFecha)) > 40
  AND EXISTS (SELECT 1
              FROM Sede
                       JOIN Colaborador AS C ON C.dni = Colaborador.dni
              WHERE C.dni = Colaborador.dni
                AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Sede.construccionFecha)) % 10 = 0
                AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Sede.construccionFecha)) > 0);
