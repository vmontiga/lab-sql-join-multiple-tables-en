-- 1 Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a USING(address_id)
JOIN city ci USING (city_id)
JOIN country co USING(country_id)
GROUP BY store_id;

-- 2 Write a query to display how much business, in dollars, each store brought in.
SELECT i.store_id, SUM(p.amount) AS Total_business_$
FROM inventory i
JOIN rental r USING(inventory_id)
JOIN payment p USING(rental_id)
GROUP BY i.store_id;

-- Another option is to go through CUSTOMER to access PAYMENT, it will reduce the number of table joined
-- Solution with CUSTOMER:
SELECT c.store_id , SUM(p.amount) AS Total_business_$
FROM customer c
JOIN payment p USING(customer_id)
GROUP BY c.store_id;
-- The total amount for both store is the same but each total (store 1 vs store 2) are different than previously !!

-- A third option is to go through STAFF
-- Solution with STAFF:
SELECT s.store_id , SUM(p.amount) AS Total_business_$
FROM staff s
JOIN payment p USING(staff_id)
GROUP BY s.store_id;
-- The total amount for both store is the same but each total (store 1 vs store 2) is different than the other 2 solutions !!

-- 3 What is the average running time of films by category?
SELECT cat.name as 'Category', ROUND(AVG(f.length)) as Average_Running_Time_min
FROM film f
JOIN film_category fc USING(film_id)
JOIN category cat USING(category_id)
GROUP BY cat.name;

-- 4 Which film categories are longest?
SELECT cat.name as 'Category', max(f.length) as Running_Time_min
FROM film f
JOIN film_category fc USING(film_id)
JOIN category cat USING(category_id)
GROUP BY cat.name
HAVING max(f.length) = 185;
-- Dirty way because we hard code the max value that should be found

-- Another way to solve it:
SELECT cat.name as 'Category', max(S1.max_length)
FROM (SELECT f.film_id, max(f.length) as max_length
FROM film f
) AS S1
JOIN film_category fc USING(film_id)
JOIN category cat USING(category_id)
GROUP BY cat.name;
-- Messy way to solve it because it only returns 1 value and ignore the other categories that also have the max length

-- 5 Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS Renting_frequency
FROM film f
JOIN inventory i USING(film_id)
JOIN rental r USING(inventory_id)
GROUP BY f.film_id, f.title
ORDER BY Renting_frequency DESC
LIMIT 10;	-- Arbitrary Limit

-- 6 List the top five genres in gross revenue in descending order.
SELECT cat.name as Genre, SUM(p.amount) as Gross_Revenue_$
FROM category cat
JOIN film_category fc USING(category_id)
JOIN inventory i USING(film_id)
JOIN rental r USING(inventory_id)
JOIN payment p USING(rental_id)
GROUP BY cat.name
ORDER BY Gross_Revenue_$ DESC
LIMIT 5;

-- 7 Is "Academy Dinosaur" available for rent from Store 1?
SELECT f.title, i.store_id
FROM film f
JOIN inventory i USING(film_id)
WHERE i.store_id = 1
GROUP BY f.title
HAVING f.title = "ACADEMY DINOSAUR";
