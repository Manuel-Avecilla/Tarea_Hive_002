USE nyc_mobility;

-- 1. Ranking por Zona: Top 3 viajes mas rentables en las zonas 132 y 161
SELECT 
    pulocationid,
    tpep_pickup_datetime,
    total_amount,
    ranking_zona
FROM (
    SELECT 
        pulocationid,
        tpep_pickup_datetime,
        total_amount,
        DENSE_RANK() OVER (PARTITION BY pulocationid ORDER BY total_amount DESC) AS ranking_zona
    FROM taxis_procesados
    WHERE pulocationid IN (132, 161)
) ranked
WHERE ranking_zona <= 3
ORDER BY pulocationid, ranking_zona;

-- 2. Acumulado Progresivo: Recaudacion acumulada dia a dia por cada proveedor
SELECT 
    proveedor_id,
    fecha_viaje,
    ingresos_dia,
    SUM(ingresos_dia) OVER (
        PARTITION BY proveedor_id 
        ORDER BY fecha_viaje 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS acumulado_progresivo
FROM (
    SELECT 
        proveedor_id,
        fecha_viaje,
        SUM(total_amount) AS ingresos_dia
    FROM taxis_procesados
    GROUP BY proveedor_id, fecha_viaje
) diario
ORDER BY proveedor_id, fecha_viaje;

-- 3. Diferencial Secuencial: Variacion de precio respecto a la carrera anterior del mismo proveedor
SELECT 
    proveedor_id,
    tpep_pickup_datetime,
    total_amount AS importe_actual,
    LAG(total_amount, 1) OVER (PARTITION BY proveedor_id ORDER BY tpep_pickup_datetime) AS importe_anterior,
    ROUND(
        total_amount - LAG(total_amount, 1) OVER (PARTITION BY proveedor_id ORDER BY tpep_pickup_datetime), 
        2
    ) AS diferencia_precio
FROM taxis_procesados
WHERE fecha_viaje = '2024-01-15'
LIMIT 20;