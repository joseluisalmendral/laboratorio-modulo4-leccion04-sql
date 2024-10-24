# Contexto

**Nombre de la Empresa:** 

SetMagic Productions

**Descripción:**

SetMagic Productions es una empresa especializada en la provisión de servicios integrales para la realización de rodajes cinematográficos y audiovisuales. Nos dedicamos a facilitar tanto el atrezzo necesario para las producciones como los lugares idóneos para llevar a cabo los rodajes, ya sea en entornos al aire libre o en interiores.

**Servicios Ofrecidos:**

- **Atrezzo Creativo:** Contamos con un extenso catálogo de atrezzo que abarca desde accesorios hasta muebles y objetos temáticos para ambientar cualquier tipo de  escena.

- **Locaciones Únicas:** Nuestra empresa ofrece una amplia selección de locaciones, que incluyen desde escenarios naturales como playas, bosques y montañas, hasta espacios interiores como estudios, casas históricas y edificios emblemáticos.
- **Servicios de Producción:** Además de proporcionar atrezzo y locaciones, también ofrecemos servicios de producción audiovisual, incluyendo equipos de filmación, personal técnico y servicios de postproducción.

**Herramientas y Tecnologías:**

Para recopilar información sobre nuevas locaciones y tendencias en atrezzo, utilizamos herramientas de web scraping como Beautiful Soup y Selenium para extraer datos de sitios web relevantes y redes sociales especializadas en cine y producción audiovisual. También integramos APIs de plataformas de alquiler de locaciones y bases de datos de atrezzo para acceder a información actualizada y detallada.

**Almacenamiento de Datos:** (A trabajar la próima semana)

La información recopilada mediante web scraping y APIs se almacenará tanto en una base de datos relacional SQL como en una base de datos no relacional MongoDB . Estas base de datos nos permite organizar eficientemente la información sobre locaciones, atrezzo, clientes y proyectos en curso, facilitando su acceso y gestión.

**Objetivo:**

Nuestro objetivo principal es proporcionar a nuestros clientes una experiencia fluida y personalizada en la búsqueda y selección de locaciones y atrezzo para sus proyectos audiovisuales. Utilizando tecnologías avanzadas y una amplia red de contactos en la industria, nos esforzamos por ofrecer soluciones creativas y de alta calidad que satisfagan las necesidades específicas de cada producción.




# Lab SQL III (CTE's, Tablas Temporales y Vistas)

## Ejercicio 1. Queries Generales

1.1. Calcula el promedio más bajo y más alto de temperatura.

1.2. Obtén los municipios en los cuales coincidan las medias de la sensación térmica y de la temperatura. 

1.3. Obtén el local más cercano de cada municipio

1.4. Localiza los municipios que posean algún localizador a una distancia mayor de 2000 y que posean al menos 25 locales.

1.5. Teniendo en cuenta que el viento se considera leve con una velocidad media de entre 6 y 20 km/h, moderado con una media de entre 21 y 40 km/h, fuerte con media de entre 41 y 70 km/h y muy fuerte entre 71 y 120 km/h. Calcula cuántas rachas de cada tipo tenemos en cada uno de los días. Este ejercicio debes solucionarlo con la sentencia CASE de SQL (no la hemos visto en clase, por lo que tendrás que buscar la documentación). 

## Ejercicio 2. Vistas

2.1. Crea una vista que muestre la información de los locales que tengan incluido el código postal en su dirección. 

2.2. Crea una vista con los locales que tienen más de una categoría asociada.

2.3. Crea una vista que muestre el municipio con la temperatura más alta de cada día

2.4. Crea una vista con los municipios en los que haya una probabilidad de precipitación mayor del 100% durante mínimo 7 horas.

2.5. Obtén una lista con los parques de los municipios que tengan algún castillo.

## Ejercicio 3. Tablas Temporales

3.1. Crea una tabla temporal que muestre cuántos días han pasado desde que se obtuvo la información de la tabla AEMET.

3.2. Crea una tabla temporal que muestre los locales que tienen más de una categoría asociada e indica el conteo de las mismas

3.3. Crea una tabla temporal que muestre los tipos de cielo para los cuales la probabilidad de precipitación mínima de los promedios de cada día es 5.

3.4. Crea una tabla temporal que muestre el tipo de cielo más y menos repetido por municipio.


## Ejercicio 4. SUBQUERIES

4.1. Necesitamos comprobar si hay algún municipio en el cual no tenga ningún local registrado.

4.2. Averigua si hay alguna fecha en la que el cielo se encuente "Muy nuboso con tormenta".

4.3. Encuentra los días en los que los avisos sean diferentes a "Sin riesgo".

4.4. Selecciona el municipio con mayor número de locales.

4.5. Obtén los municipios muya media de sensación térmica sea mayor que la media total.

4.6. Selecciona los municipios con más de dos fuentes.

4.7. Localiza la dirección de todos los estudios de cine que estén abiertod en el municipio de "Madrid".

4.8. Encuentra la máxima temperatura para cada tipo de cielo.

4.9. Muestra el número de locales por categoría que muy probablemente se encuentren abiertos.

BONUS. 4.10. Encuentra los municipios que tengan más de 3 parques, los cuales se encuentren a una distancia menor de las coordenadas de su municipio correspondiente que la del Parque Pavia. Además, el cielo debe estar despejado a las 12.