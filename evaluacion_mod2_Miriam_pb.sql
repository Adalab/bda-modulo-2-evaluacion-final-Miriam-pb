USE sakila; -- me aseguro de utilizar el schema en el que tengo que trabajar

-- Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS peliculas
FROM film;

-- Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
-- abro la tabla y compruebo que ahy una columna de rating

SELECT title AS peliculas_PG13
FROM film
WHERE rating = 'PG-13';

-- Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS peliculas_increibles, description AS descripción 
FROM film
WHERE description LIKE "%amazing%";

-- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- suponiendo que la duracion en minutos es length de la tabla film

SELECT title AS peliculas_largas
FROM film
WHERE length > 120;

-- Recupera los nombres de todos los actores.

SELECT first_name AS nombre, last_name AS apellido
FROM actor;

-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS nombre, last_name AS apellido
FROM actor
WHERE last_name = 'Gibson';

-- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
-- suponiendo que estan incluidos el 10 y el 20:

SELECT first_name AS nombre, last_name AS apellido -- para comprobar sacamos el id
FROM actor
WHERE actor_id <= 20 AND actor_id >= 10;

-- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title AS peliculas_no_R_PG13 -- para comprobar sacamos un rating
FROM film
WHERE rating <> "R" AND rating <> "PG-13";

-- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
-- para comprobar hago un select distinct rating from film y veo que el output devuelve las mismas rows

SELECT COUNT(film_id) AS num_peliculas, rating AS clasificación
FROM film
GROUP BY rating;

-- Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT COUNT(rental_id) AS total_peliculas_alquiladas, customer_id, first_name AS nombre, last_name AS apellido
FROM rental 
INNER JOIN customer -- inner join porque me interesan las coincidencias, si algun cliente no ha alquilado no me interesa 
USING (customer_id) -- atajo en lugar del ON
GROUP BY customer_id;

-- Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres
-- veo como se relacionan las tablas en el diagrama y necesito unir category, film_category, inventory y rental para acceder a toda la informacion.
-- para comprobar saco el total de categorias y el total de alquileres de la primera categoria como muestra

SELECT COUNT(rental_id) AS num_alquiler, category.name AS categorias
FROM rental
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY category.name;

-- Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- como es clasificación y no categoria, la información esta en la tabla film

SELECT AVG(length) AS media_duración, rating AS clasificaciones
FROM film
GROUP BY rating;

-- Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- hay que unir por una tabla intermedia y para comprobar el resultado saco el titulo de la pelicula tambien.

SELECT first_name AS nombre, last_name AS apellido
FROM actor
INNER JOIN film_actor USING (actor_id)
INNER JOIN film USING (film_id)
WHERE title = "Indian Love";

-- Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- entiendo que como pide que contengan la PALABRA dog o cat, el output de "%dog%" o "%cat%" no seria correcto
-- porque aparecen titulos con esas silabas y no palabras como tal, por lo que no hay peliculas que tengan esas palabras.

SELECT title AS peliculas_con_dog_o_cat
FROM film
WHERE title LIKE "% dog %" OR title LIKE "% cat %";

/*SELECT title AS peliculas_con_dog_o_cat
FROM film
WHERE title LIKE "% dog %"
UNION
SELECT title AS peliculas_con_dog_o_cat
FROM film
WHERE title LIKE "% cat %";*/ -- otra forma de resolver este ejercicio es con UNION, que juntaría las que tiene dog y las que tienen cat sin repetirlas, personalmente prefiero la solución de arriba

-- Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
-- NO

SELECT actor_id
FROM film_actor
WHERE film_id IS NULL;

-- Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- suponiendo que no se incluyen las fechas del enunciado y para comprobar el resultado saco release_year tambien

SELECT title AS peliculas_entre_2005_2010
FROM film
WHERE release_year > 2005 AND release_year < 2010;

-- Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- para comprobar saco el name de category tambien

SELECT title AS peliculas_family
FROM film
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name = "Family";

-- Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- relaciono film_actor con actor para contar film_id por cada nombre de actor, para comprobar el resultado saco tambien COUNT(film_id) y lo ordeno ASC

SELECT first_name AS nombre, last_name AS apellido
FROM film_actor
INNER JOIN actor USING (actor_id)
GROUP BY actor_id
HAVING COUNT(film_id) > 10;

-- Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
-- para que se cumplan las dos condiciones las ponemos juntas con un AND y para comprobar resultado saco length, rating tambien

SELECT title AS peliculas_largas_R
FROM film
WHERE length > 120 AND rating = "R";

-- Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- relaciono category, film_category y film para llegar a la media de duración de las categorias, agrupo por categoria y con la condición de que la media sea superior a 120 min

SELECT name AS categorias, AVG(length) AS promedio_duración
FROM category
INNER JOIN film_category USING (category_id)
INNER JOIN film USING (film_id)
GROUP BY name
HAVING AVG(length)>120;

-- Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
-- contamos los film_id por actor_id y como no pide el titulo no hace falta relacionar mas tablas

SELECT first_name AS nombre_actor, last_name AS apellido, COUNT(film_id) AS total_peliculas
FROM actor
INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id
HAVING COUNT(film_id) >= 5;

-- Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
-- este codigo que pruebo primero no sirve : SELECT return_date - rental_date AS duracion FROM rental; por lo que me apoyo en recursos externos para llegar a la conclusión correcta
-- en este caso pruebo con DATEDIFF() y devuelve los dias de alquiler
-- para comprobar saco DATEDIFF(return_date, rental_date) tambien

SELECT DISTINCT title AS peliculas_alquiladas_mas5dias -- distinct porque si no se reppiten las mismas peliculas si fueron alquiladas varias veces mas de 5 dias 
FROM film
INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
WHERE rental_id IN (SELECT rental_id
			FROM rental
			WHERE DATEDIFF(return_date, rental_date) > 5);
                            
/*SELECT DATEDIFF(return_date, rental_date) AS dias, rental_id
FROM rental
WHERE DATEDIFF(return_date, rental_date) > 5;*/ -- subconsulta

-- Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT first_name AS nombre, last_name AS apellido
FROM actor
WHERE actor_id NOT IN (SELECT actor_id -- solo una columna para que funcione el NOT IN
					FROM actor
					INNER JOIN film_actor USING (actor_id)
					INNER JOIN film USING (film_id)
					INNER JOIN film_category USING (film_id)
					INNER JOIN category USING (category_id)
					WHERE name = "Horror");

/*SELECT first_name, last_name, name       -- este es solo para comprobar la subconsulta
FROM actor
INNER JOIN film_actor USING (actor_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name = "Horror";*/

-- Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT title AS peliculas_comedia_más180min
FROM film
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name = "Comedy" AND length > 180; -- dan igual las mayúsculas pero yo las pongo


-- BONUS
