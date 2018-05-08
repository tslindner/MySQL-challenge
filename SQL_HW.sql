USE sakila;

-- 1)
-- 		a)
SELECT first_name, last_name
FROM actor;

--		b)
SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS 'Actor Name'
FROM actor a;

-- 2)
--		a)
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 		b)
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

-- 		c)
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

-- 		d)
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3)
-- 		a)
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;

-- 		b)
ALTER TABLE actor
MODIFY middle_name BLOB;

-- 		c)
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4)
-- 		a)
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- 		b)
SELECT *
FROM 
(
	SELECT last_name, COUNT(*) AS 'counted'
	FROM actor
	GROUP BY last_name
) AS count_table
WHERE count_table.counted > 1;

-- 		c)
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO';

-- 		d)
SELECT 
	CASE 
	WHEN actor.first_name = 'HARPO' THEN 'GROUCHO'
	WHEN actor.first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
    ELSE actor.first_name
END
FROM actor;

-- 	5)
-- 		a)
SHOW CREATE TABLE address;

-- 	6)
-- 		a)
SELECT first_name, last_name, address
FROM staff
JOIN address ON staff.address_id = address.address_id;

-- 		b)
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
LEFT JOIN 
(
	SELECT *
	FROM payment
	WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
) AS payment
ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

-- 		c)
SELECT film.title, COUNT(film_actor.actor_id) AS 'Number of actors'
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;
-- 		d)
SELECT film.title, COUNT(inventory.film_id) AS 'Total Copies'
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';

-- 		e)
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.last_name;

-- 	7)
-- 		a)
SELECT title
FROM film f
WHERE title LIKE 'K%' 
OR title LIKE 'Q%' 
AND f.language_id IN (
					SELECT language_id
					FROM language
					WHERE name = 'english'
					);

-- 		b)
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
		)
	);

-- 		c)
SELECT first_name, last_name, email
FROM customer
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country = 'Canada';

-- 		d)
SELECT title
FROM film 
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN (
		SELECT category_id
		FROM category
		WHERE name = 'Family'
		)
	);

-- 		e)
SELECT title, COUNT(payment_id) AS 'count'
FROM payment
JOIN customer ON customer.customer_id = payment.customer_id
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id
GROUP BY title
ORDER BY count DESC;

-- 		f)
-- Only two employees/stores soooo
SELECT staff_id, SUM(amount)
FROM payment
GROUP BY staff_id;

-- 		g)
SELECT store_id, city, country
FROM customer
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id;

-- 		h)
SELECT c.name, SUM(p.amount) AS total
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY total DESC
LIMIT 5;

-- 	8)
-- 		a)
CREATE VIEW a AS 
	SELECT c.name, SUM(p.amount) AS total
	FROM category c
	JOIN film_category fc ON c.category_id = fc.category_id
	JOIN inventory i ON i.film_id = fc.film_id
	JOIN rental r ON r.inventory_id = i.inventory_id
	JOIN payment p ON p.rental_id = r.rental_id
	GROUP BY c.name
	ORDER BY total DESC
	LIMIT 5;

-- 		b)
SELECT *
from a;

-- 		c)
DROP VIEW a;
