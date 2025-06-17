USE sakila;

# 1 the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id IN (
    SELECT film_id FROM film WHERE title = 'Hunchback Impossible'
);
# 2 we list all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

# 3  all actors who appear in the film "Alone Trip".
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);
# 4 all movies categorized as family films.
SELECT f.title, c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name IN ( 'Family')
ORDER BY f.title;

# 5 the name and email of customers from Canada
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id FROM address
    WHERE city_id IN (
        SELECT city_id FROM city
        WHERE country_id = (
            SELECT country_id FROM country WHERE country = 'Canada'
        )
    )
);

# 6 films were starred by the most prolific actor
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = 107;

# OR
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT a.actor_id
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id
    ORDER BY COUNT(fa.film_id) DESC
    LIMIT 1
);

# 7 the films rented by the most profitable customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

# 8 we retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_spent) FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS avg_table)
ORDER BY total_amount_spent DESC;
