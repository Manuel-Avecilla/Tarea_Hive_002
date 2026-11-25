USE nyc_mobility;

-- 1. Crear la tabla con tipos complejos ARRAY y STRUCT
CREATE TABLE IF NOT EXISTS taxis_expediente_viaje (
    viaje_id BIGINT,
    paradas ARRAY<BIGINT>,
    desglose_coste STRUCT<base: DOUBLE, propina: DOUBLE, peajes: DOUBLE>
)
STORED AS ORC;

-- 2. Insertar un registro demostrativo desde taxis_procesados (Actividad E.1)
INSERT INTO TABLE taxis_expediente_viaje
SELECT 
    1001 AS viaje_id,
    array(pulocationid, dolocationid) AS paradas,
    named_struct(
        'base', fare_amount,
        'propina', tip_amount,
        'peajes', tolls_amount
    ) AS desglose_coste
FROM taxis_procesados
LIMIT 1;

-- 3. Consultar el expediente completo y extraer campos concretos por indice y punto
SELECT 
    viaje_id,
    paradas,
    paradas[0] AS zona_origen,
    desglose_coste,
    desglose_coste.propina AS propina_abonada
FROM taxis_expediente_viaje;