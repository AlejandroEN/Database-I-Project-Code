SELECT Persona.nombres,
       Persona.email,
       Colaborador.numeroCelular,
       Sede.direccion,
       Sede.coordenadaLongitud,
       Sede.coordenadaLatitud
FROM Director
         JOIN Colaborador ON Director.dni = Colaborador.dni
         JOIN Persona ON Colaborador.dni = Persona.dni
         JOIN Sede ON Director.sedeId = Sede.id
WHERE Sede.id IN (SELECT Sede.id
                  FROM Sede
                           LEFT JOIN (SELECT Matricula.sedeId,
                                             COUNT(*) AS cantidadAlumnos
                                      FROM Matricula
                                      WHERE year = EXTRACT(YEAR FROM CURRENT_DATE)
                                      GROUP BY Matricula.sedeId) SedeAlumnos ON Sede.id = SedeAlumnos.sedeId
                           LEFT JOIN (SELECT Salon.sedeId,
                                             COUNT(*) AS cantidadSalones
                                      FROM Salon
                                      GROUP BY Salon.sedeId) SedeSalones ON Sede.id = SedeSalones.sedeId
                  WHERE (SedeAlumnos.cantidadAlumnos IS NULL OR SedeAlumnos.cantidadAlumnos <= 5000)
                  ORDER BY SedeSalones.cantidadSalones DESC
                  LIMIT 20);
