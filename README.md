# Tarea_Hive_002

Guía rápida de despliegue y ejecución de scripts SQL para la práctica de Data Warehousing con Apache Hive y el dataset NYC TLC.

---

## Preparar el entorno

### 1. Levantar el Docker
```bash
docker compose up -d
```

### 2. Copiar el archivo Parquet al contenedor
```bash
docker cp taxis_hive_listo.parquet hive-server:/tmp/taxis_hive_listo.parquet
```

### 3. Esperar a que HDFS esté escuchando y fuera de SafeMode, crear el directorio Raw y subir el Parquet
```bash
docker exec -it hive-server bash -c "while ! (echo > /dev/tcp/localhost/9000) >/dev/null 2>&1; do sleep 1; done && hdfs dfsadmin -safemode wait && hdfs dfs -mkdir -p /data/raw/taxis/ && hdfs dfs -put -f /tmp/taxis_hive_listo.parquet /data/raw/taxis/ && rm -f /tmp/taxis_hive_listo.parquet"
```

---

## Fase A: Capa Bronce (Tabla Externa Parquet)

### 1. Copiar SQL
```bash
docker cp fase_a.sql hive-server:/tmp/fase_a.sql
```

### 2. Ejecutar SQL
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /tmp/fase_a.sql
```

---

## Fase B: Capa Plata (Particionado Dinámico ORC)

### 1. Copiar SQL
```bash
docker cp fase_b.sql hive-server:/tmp/fase_b.sql
```

### 2. Ejecutar SQL
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /tmp/fase_b.sql
```

---

## Fase C: Auditoría de Poda de Particiones (EXPLAIN)

### 1. Copiar SQL
```bash
docker cp fase_c.sql hive-server:/tmp/fase_c.sql
```

### 2. Ejecutar SQL
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /tmp/fase_c.sql
```

---

## Fase D: Capa Oro (Bucketing y TABLESAMPLE)

### 1. Copiar SQL
```bash
docker cp fase_d.sql hive-server:/tmp/fase_d.sql
```

### 2. Ejecutar SQL
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /tmp/fase_d.sql
```

---

## Fase E: Tipos Complejos (ARRAY y STRUCT)

### 1. Copiar SQL
```bash
docker cp fase_e.sql hive-server:/tmp/fase_e.sql
```

### 2. Ejecutar SQL
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /tmp/fase_e.sql
```

---

## Fase F: Consultas Analíticas Avanzadas (Window Functions)

### 1. Copiar SQL
```bash
docker cp fase_f.sql hive-server:/tmp/fase_f.sql
```

### 2. Ejecutar SQL
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /tmp/fase_f.sql
```

---

## Parar el Docker y limpiar volúmenes
```bash
docker compose down -v
```