USE nyc_mobility;

-- 1. Habilitar particionado dinámico no estricto en la sesión
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- 2. Crear la tabla interna particionada en formato ORC con compresión Snappy
CREATE TABLE IF NOT EXISTS taxis_procesados (
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
    airport_fee DOUBLE
)
PARTITIONED BY (fecha_viaje DATE, proveedor_id BIGINT)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

-- 3. Poblar la tabla filtrando enero de 2024 (las columnas de partición van al final)
INSERT OVERWRITE TABLE taxis_procesados PARTITION (fecha_viaje, proveedor_id)
SELECT 
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    ratecodeid,
    store_and_fwd_flag,
    pulocationid,
    dolocationid,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,
    to_date(tpep_pickup_datetime) AS fecha_viaje,
    vendorid AS proveedor_id
FROM raw_taxis_parquet
WHERE to_date(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-01-31';

-- 4. Comprobar particiones creadas y conteo de registros limpios
SHOW PARTITIONS taxis_procesados;
SELECT COUNT(*) FROM taxis_procesados;