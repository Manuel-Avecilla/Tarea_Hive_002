USE nyc_mobility;

-- 1. Plan de ejecucion para auditar la poda de particiones (Entregable C.1)
EXPLAIN
SELECT 
    COUNT(*) AS total_viajes,
    SUM(total_amount) AS ingresos_totales
FROM taxis_procesados
WHERE fecha_viaje = '2024-01-15';

-- 2. Ejecucion real de la consulta analitica para obtener el resultado
SELECT 
    COUNT(*) AS total_viajes,
    SUM(total_amount) AS ingresos_totales
FROM taxis_procesados
WHERE fecha_viaje = '2024-01-15';