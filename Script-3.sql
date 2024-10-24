
--Ejercicio 1. Queries Generales

--1.1. Calcula el promedio más bajo y más alto de temperatura.

SELECT 
    MIN(temp_media) AS min_avg_temperature,
    MAX(temp_media) AS max_avg_temperature
FROM (
    SELECT 
        AVG(temperatura) AS temp_media
    FROM precipitaciones
    GROUP BY localizacion_id
) AS media_temperaturas;



--1.2. Obtén los municipios en los cuales coincidan las medias de la sensación térmica y de la temperatura.

SELECT m.nombre
FROM municipios m
JOIN precipitaciones p ON m.id = p.localizacion_id
GROUP BY m.id, m.nombre
HAVING AVG(p.temperatura) = AVG(p.temperatura_sentida);


--1.3. Obtén el local más cercano de cada municipio
-- esta esta con chat pero es que tengo que seguir

SELECT l.distance, m.nombre AS nombre_municipio, l.name AS nombre_lugar
FROM lugares l
INNER JOIN municipios m ON l.municipio = m.id
WHERE l.distance = (
    SELECT MIN(l2.distance)
    FROM lugares l2
    WHERE l2.municipio = l.municipio
);


--1.4. Localiza los municipios que posean algún localizador a una distancia mayor de 2000 y que posean al menos 25 locales.
SELECT m.nombre AS nombre_municipio
FROM municipios m
INNER JOIN lugares l ON m.id = l.municipio
WHERE l.distance > 2000
GROUP BY m.id, m.nombre
HAVING COUNT(l.fsq_id) >= 25;



--1.5. Teniendo en cuenta que el viento se considera leve con una velocidad media de entre 6 y 20 km/h, moderado con una media de entre 21 y 40 km/h, fuerte con media de entre 41 y 70 km/h y muy fuerte entre 71 y 120 km/h. Calcula cuántas rachas de cada tipo tenemos en cada uno de los días. Este ejercicio debes solucionarlo con la sentencia CASE de SQL (no la hemos visto en clase, por lo que tendrás que buscar la documentación).
SELECT 
    fecha,
    SUM(CASE 
        WHEN velocidad_viento BETWEEN 6 AND 20 THEN 1 
        ELSE 0 
    END) AS rachas_leve,
    SUM(CASE 
        WHEN velocidad_viento BETWEEN 21 AND 40 THEN 1 
        ELSE 0 
    END) AS rachas_moderado,
    SUM(CASE 
        WHEN velocidad_viento BETWEEN 41 AND 70 THEN 1 
        ELSE 0 
    END) AS rachas_fuerte,
    SUM(CASE 
        WHEN velocidad_viento BETWEEN 71 AND 120 THEN 1 
        ELSE 0 
    END) AS rachas_muy_fuerte
FROM precipitaciones
GROUP BY fecha;


--Ejercicio 2. Vistas

--2.1. Crea una vista que muestre la información de los locales que tengan incluido el código postal en su dirección.
CREATE VIEW locales_con_codigo_postal AS
SELECT *
FROM lugares
WHERE address LIKE '%[0-9]%';


SELECT *
FROM lugares
WHERE address LIKE '%[0-9]%';

--2.2. Crea una vista con los locales que tienen más de una categoría asociada.
CREATE VIEW locales_con_multiples_categorias AS
SELECT l.fsq_id, l.name, COUNT(l.category) AS total_categorias
FROM lugares l
GROUP BY l.fsq_id, l.name
HAVING COUNT(l.category) > 1;


--2.3. Crea una vista que muestre el municipio con la temperatura más alta de cada día
CREATE VIEW municipios_con_temperatura_maxima AS
SELECT p.fecha, m.nombre AS nombre_municipio, p.temperatura
FROM precipitaciones p
INNER JOIN municipios m ON p.localizacion_id = m.id
WHERE p.temperatura = (
    SELECT MAX(p2.temperatura)
    FROM precipitaciones p2
    WHERE p2.fecha = p.fecha
)
GROUP BY p.fecha, m.nombre, p.temperatura;


--2.4. Crea una vista con los municipios en los que haya una probabilidad de precipitación mayor del 100% durante mínimo 7 horas.
CREATE VIEW municipios_con_alta_probabilidad_precipitacion AS
SELECT m.nombre AS nombre_municipio, p.fecha, COUNT(p.prob_precipitacion) AS horas_con_probabilidad_alta
FROM municipios m
INNER JOIN precipitaciones p ON m.id = p.localizacion_id
WHERE p.prob_precipitacion > 100
GROUP BY m.nombre, p.fecha
HAVING COUNT(p.prob_precipitacion) >= 7;


--2.5. Obtén una lista con los parques de los municipios que tengan algún castillo.
SELECT p.name AS nombre_parque, m.nombre AS nombre_municipio
FROM lugares p
INNER JOIN municipios m ON p.municipio = m.id
INNER JOIN categorias_lugares c1 ON p.category = c1.id
WHERE c1.categoria = 'Park'
AND EXISTS (
    SELECT 1
    FROM lugares l
    INNER JOIN categorias_lugares c2 ON l.category = c2.id
    WHERE l.municipio = m.id
    AND c2.categoria = 'Castle'
);


--Ejercicio 3. Tablas Temporales

--3.1. Crea una tabla temporal que muestre cuántos días han pasado desde que se obtuvo la información de la tabla AEMET.
CREATE TEMPORARY TABLE dias_desde_aemet AS
SELECT 
    fecha,
    CURRENT_DATE - fecha AS dias_desde_obtencion
FROM precipitaciones;

--3.2. Crea una tabla temporal que muestre los locales que tienen más de una categoría asociada e indica el conteo de las mismas
CREATE TEMPORARY TABLE locales_con_multiples_categorias AS
SELECT 
    l.fsq_id, 
    l.name AS nombre_local, 
    COUNT(l.category) AS total_categorias
FROM lugares l
GROUP BY l.fsq_id, l.name
HAVING COUNT(l.category) > 1;



--3.3. Crea una tabla temporal que muestre los tipos de cielo para los cuales la probabilidad de precipitación mínima de los promedios de cada día es 5.
CREATE TEMPORARY TABLE tipos_cielo_probabilidad_5 AS
SELECT 
    e.estado AS tipo_cielo,
    AVG(p.prob_precipitacion) AS promedio_prob_precipitacion
FROM precipitaciones p
INNER JOIN estados_cielo e ON p.cielo = e.id
GROUP BY e.estado, p.fecha
HAVING AVG(p.prob_precipitacion) = 5;



--3.4. Crea una tabla temporal que muestre el tipo de cielo más y menos repetido por municipio.
CREATE TEMPORARY TABLE cielo_mas_y_menos_repetido AS
WITH cielo_frecuencia AS (
    SELECT 
        m.nombre AS nombre_municipio,
        e.estado AS tipo_cielo,
        COUNT(p.cielo) AS frecuencia
    FROM precipitaciones p
    INNER JOIN municipios m ON p.localizacion_id = m.id
    INNER JOIN estados_cielo e ON p.cielo = e.id
    GROUP BY m.nombre, e.estado
)
SELECT 
    nombre_municipio,
    tipo_cielo AS tipo_cielo_mas_repetido,
    frecuencia AS frecuencia_mas_repetida
FROM cielo_frecuencia cf1
WHERE frecuencia = (
    SELECT MAX(frecuencia)
    FROM cielo_frecuencia cf2
    WHERE cf1.nombre_municipio = cf2.nombre_municipio
)
UNION ALL
SELECT 
    nombre_municipio,
    tipo_cielo AS tipo_cielo_menos_repetido,
    frecuencia AS frecuencia_menos_repetida
FROM cielo_frecuencia cf1
WHERE frecuencia = (
    SELECT MIN(frecuencia)
    FROM cielo_frecuencia cf2
    WHERE cf1.nombre_municipio = cf2.nombre_municipio
);


--Ejercicio 4. SUBQUERIES

--4.1. Necesitamos comprobar si hay algún municipio en el cual no tenga ningún local registrado.
SELECT m.nombre AS nombre_municipio
FROM municipios m
LEFT JOIN lugares l ON m.id = l.municipio
WHERE l.fsq_id IS NULL;



--4.2. Averigua si hay alguna fecha en la que el cielo se encuente "Muy nuboso con tormenta".
SELECT p.fecha
FROM precipitaciones p
INNER JOIN estados_cielo e ON p.cielo = e.id
WHERE e.estado = 'Muy nuboso con tormenta';



--4.3. Encuentra los días en los que los avisos sean diferentes a "Sin riesgo".
SELECT fecha, avisos
FROM precipitaciones
WHERE avisos <> 'Sin riesgo';



--4.4. Selecciona el municipio con mayor número de locales.
SELECT m.nombre AS nombre_municipio, COUNT(l.fsq_id) AS total_locales
FROM municipios m
INNER JOIN lugares l ON m.id = l.municipio
GROUP BY m.id, m.nombre
ORDER BY total_locales DESC
LIMIT 1;



--4.5. Obtén los municipios muya media de sensación térmica sea mayor que la media total.
WITH media_total AS (
    SELECT AVG(temperatura_sentida) AS media_global
    FROM precipitaciones
),
media_municipios AS (
    SELECT m.nombre AS nombre_municipio, AVG(p.temperatura_sentida) AS media_sensacion_municipio
    FROM precipitaciones p
    INNER JOIN municipios m ON p.localizacion_id = m.id
    GROUP BY m.id, m.nombre
)
SELECT nombre_municipio, media_sensacion_municipio
FROM media_municipios
WHERE media_sensacion_municipio > (SELECT media_global FROM media_total);



--4.6. Selecciona los municipios con más de dos fuentes.
SELECT m.nombre AS nombre_municipio, COUNT(l.fsq_id) AS total_fuentes
FROM municipios m
INNER JOIN lugares l ON m.id = l.municipio
INNER JOIN categorias_lugares c ON l.category = c.id
WHERE c.categoria = 'Fuente'
GROUP BY m.id, m.nombre
HAVING COUNT(l.fsq_id) > 2;



--4.7. Localiza la dirección de todos los estudios de cine que estén abiertod en el municipio de "Madrid".
SELECT l.address AS direccion, l.name AS nombre_estudio
FROM lugares l
INNER JOIN municipios m ON l.municipio = m.id
INNER JOIN categorias_lugares c ON l.category = c.id
WHERE m.nombre = 'Madrid'
  AND c.categoria = 'Estudio de cine'
  AND l.closed_bucket = 'abierto';



--4.8. Encuentra la máxima temperatura para cada tipo de cielo.
SELECT e.estado AS tipo_cielo, MAX(p.temperatura) AS temperatura_maxima
FROM precipitaciones p
INNER JOIN estados_cielo e ON p.cielo = e.id
GROUP BY e.estado;



--4.9. Muestra el número de locales por categoría que muy probablemente se encuentren abiertos.
SELECT c.categoria AS categoria_lugar, COUNT(l.fsq_id) AS total_locales_abiertos
FROM lugares l
INNER JOIN categorias_lugares c ON l.category = c.id
WHERE l.closed_bucket = 'abierto' OR l.closed_bucket = 'probablemente abierto'
GROUP BY c.categoria;



--BONUS. 4.10. Encuentra los municipios que tengan más de 3 parques, los cuales se encuentren a una distancia menor de las coordenadas de su municipio correspondiente que la del Parque Pavia. Además, el cielo debe estar despejado a las 12.
WITH parque_pavia_distancia AS (
    SELECT l.municipio, l.distance
    FROM lugares l
    INNER JOIN categorias_lugares c ON l.category = c.id
    WHERE l.name = 'Parque Pavia' AND c.categoria = 'Park'
),
municipios_con_parques AS (
    SELECT m.id AS municipio_id, m.nombre AS nombre_municipio, COUNT(l.fsq_id) AS total_parques, MIN(l.distance) AS menor_distancia_parque
    FROM lugares l
    INNER JOIN municipios m ON l.municipio = m.id
    INNER JOIN categorias_lugares c ON l.category = c.id
    WHERE c.categoria = 'Park'
    GROUP BY m.id, m.nombre
    HAVING COUNT(l.fsq_id) > 3
)
SELECT mp.nombre_municipio
FROM municipios_con_parques mp
INNER JOIN parque_pavia_distancia ppd ON mp.municipio_id = ppd.municipio
INNER JOIN precipitaciones p ON mp.municipio_id = p.localizacion_id
INNER JOIN estados_cielo e ON p.cielo = e.id
WHERE mp.menor_distancia_parque < ppd.distance
  AND e.estado = 'Despejado'
  AND EXTRACT(HOUR FROM p.fecha) = 12;





























