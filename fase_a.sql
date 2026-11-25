CREATE DATABASE IF NOT EXISTS nyc_mobility;
USE nyc_mobility;

CREATE EXTERNAL TABLE IF NOT EXISTS raw_taxis_parquet (
    vendorid BIGINT,
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
STORED AS PARQUET
LOCATION '/data/raw/taxis/';

SELECT COUNT(*) FROM raw_taxis_parquet;