USE nyc_mobility;

-- 1. Forzar el bucketing y la ordenacion fisica en la sesion
SET hive.enforce.bucketing = true;
SET hive.enforce.sorting = true;

-- 2. Crear la tabla bucketizada en formato ORC (Actividad D.1)
CREATE TABLE IF NOT EXISTS taxis_bucketed_zonas (
    tpep_pickup_datetime TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count BIGINT,
    trip_distance DOUBLE,
    ratecodeid BIGINT,
    store_and_fwd_flag STRING,
    pulocationid BIGINT,
    dolocationid BIGINT,
    payment_type BIGINT,
    fare_amount DOUBLE,
    extra DOUBLE,
    mta_tax DOUBLE,
    tip_amount DOUBLE,
    tolls_amount DOUBLE,
    improvement_surcharge DOUBLE,
    total_amount DOUBLE,
    congestion_surcharge DOUBLE,
    airport_fee DOUBLE,
    fecha_viaje DATE,
    proveedor_id BIGINT
)
CLUSTERED BY (pulocationid) SORTED BY (total_amount DESC) INTO 8 BUCKETS
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

-- 3. Poblar la tabla desde taxis_procesados
INSERT OVERWRITE TABLE taxis_bucketed_zonas
SELECT * FROM taxis_procesados;

-- 4. Extraer muestra representativa de 1 de los 8 buckets (Actividad D.2)
SELECT 
    COUNT(*) AS viajes_muestra, 
    AVG(total_amount) AS importe_medio_muestra
FROM taxis_bucketed_zonas 
TABLESAMPLE (BUCKET 1 OUT OF 8 ON pulocationid);