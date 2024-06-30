SET search_path TO millon_datos;

SET enable_mergejoin TO ON;
SET enable_hashjoin TO ON;
SET enable_bitmapscan TO ON;
SET enable_sort TO ON;
SET enable_nestloop TO ON;
SET enable_indexscan TO ON;
SET enable_indexonlyscan TO ON;

--CREATE INDEX idx_colaborador_esta_activo ON colaborador(esta_activo);
--CREATE INDEX idx_colaborador_horas_semanales_trabajo ON colaborador(horas_semanales_trabajo);
--CREATE INDEX idx_persona_nacimiento_fecha ON persona(nacimiento_fecha);
--CREATE INDEX idx_colaborador_sueldo_hora ON colaborador(sueldo_hora);
--CREATE INDEX idx_construccion_fecha ON sede(construccion_fecha);

VACUUM FULL persona;
VACUUM FULL colaborador;
VACUUM FULL director;
VACUUM FULL sede;
VACUUM FULL profesor_sede;

EXPLAIN ANALYZE
SELECT
    p_colaborador.nombres || ' ' || p_colaborador.primer_apellido || ' ' || p_colaborador.segundo_apellido AS nombre_colaborador,
    c.numero_celular,
    p_director.nombres || ' ' || p_director.primer_apellido || ' ' || p_director.segundo_apellido AS nombre_director,
    s.direccion,
    s.coordenada_longitud,
    s.coordenada_latitud
FROM
    colaborador c
        JOIN persona p_colaborador ON c.dni = p_colaborador.dni
        JOIN profesor_sede ps ON c.dni = ps.profesor_dni
        JOIN sede s ON ps.sede_id = s.id
        JOIN director d ON s.id = d.sede_id
        JOIN persona p_director ON d.dni = p_director.dni
WHERE
    c.esta_activo = true
  AND c.horas_semanales_trabajo BETWEEN 1 AND 168
  AND c.sueldo_hora BETWEEN 1 AND 100
  AND p_colaborador.nacimiento_fecha BETWEEN '1960-01-01' AND '2000-12-31'
  AND s.construccion_fecha BETWEEN '1950-01-01' AND '1980-12-31'
ORDER BY
    p_colaborador.nombres;

DROP INDEX IF EXISTS idx_colaborador_horas_semanales_trabajo;
DROP INDEX IF EXISTS idx_persona_nacimiento_fecha;
DROP INDEX IF EXISTS idx_colaborador_esta_activo;
DROP INDEX IF EXISTS idx_colaborador_sueldo_hora;
DROP INDEX IF EXISTS idx_construccion_fecha;
