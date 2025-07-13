SELECT first_name, last_name FROM customer;

SELECT film.title
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL;

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

SELECT c.name AS category, COUNT(*) AS film_count
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

SELECT rental_date, return_date FROM rental;

SELECT s.first_name, s.last_name, s.store_id
FROM staff s;

SELECT c.first_name, c.last_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE a.district = 'California';

SELECT ci.city, COUNT(*) AS customer_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city;

SELECT title, length
FROM film
WHERE length = (SELECT MAX(length) FROM film);

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Alien Center';

SELECT DATE_TRUNC('month', rental_date) AS month, COUNT(*) AS rental_count
FROM rental
GROUP BY month
ORDER BY month;

SELECT p.*
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
WHERE c.first_name = 'Mary' AND c.last_name = 'Smith';

SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

SELECT c.name, AVG(f.rental_duration) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
HAVING COUNT(*) > 50;

SELECT staff_id, COUNT(*) AS rentals_processed
FROM rental
GROUP BY staff_id;

SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;

SELECT title, length
FROM film
WHERE length > 120;

SELECT *
FROM rental
WHERE return_date > rental_date + INTERVAL '3 days';

SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT c.name AS category, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 3;

CREATE VIEW customer_payments AS
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

UPDATE customer
SET email = 'new_email@example.com'
WHERE customer_id = 1; -- change to actual ID

INSERT INTO actor (first_name, last_name, last_update)
VALUES ('John', 'Doe', CURRENT_TIMESTAMP);

ALTER TABLE customer
ADD COLUMN age INTEGER;

CREATE INDEX idx_film_title ON film(title);

SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

SELECT ci.city, COUNT(*) AS rental_count
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY rental_count DESC
LIMIT 1;

SELECT COUNT(*) AS multi_category_films
FROM (
    SELECT film_id
    FROM film_category
    GROUP BY film_id
    HAVING COUNT(*) > 1
) AS sub;

SELECT a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 10;

SELECT DISTINCT c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Matrix Revolutions';

CREATE OR REPLACE FUNCTION get_customer_total_payment(cid INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(amount) INTO total
    FROM payment
    WHERE customer_id = cid;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

BEGIN;

UPDATE inventory
SET last_update = CURRENT_TIMESTAMP
WHERE inventory_id = 1; -- example

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_TIMESTAMP, 1, 1, NULL, 1, CURRENT_TIMESTAMP);

COMMIT;

SELECT DISTINCT c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN (
    SELECT customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Action')
)
AND c.customer_id IN (
    SELECT customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Comedy')
);

SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

SELECT * FROM staff;
SELECT *
FROM staff
WHERE last_update> '2005-12-31';

BEGIN;

UPDATE inventory
SET last_update = CURRENT_TIMESTAMP
WHERE inventory_id = 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_TIMESTAMP, 1, 1, NULL, 1, CURRENT_TIMESTAMP);

COMMIT;

