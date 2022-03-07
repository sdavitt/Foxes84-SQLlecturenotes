-- Join and Subquery homework

-- 1. List all customers who live in Texas (use JOINs)
select customer_id, first_name, last_name, address, district
from customer
join address
on customer.address_id = address.address_id
where district = 'Texas';

-- 2. Get all payments above $6.99 with the Customer's Full Name
select payment_id, amount, first_name || ' ' || last_name as full_name
from payment
join customer
on payment.customer_id = customer.customer_id
where amount > 6.99;
-- little bit of an optional twist on this answer -> concatenating first_name and last_name columns and aliasing the result


-- 3. Show all customers names who have made payments over $175(use subqueries)
-- Brandt's answer interpreting question as sum of payments per customer
select first_name, last_name  
from customer
where customer_id in (
	select customer_id 
	from payment 
	group by customer_id 
	having sum(amount) > 175
);

-- 4. List all customers that live in Nepal (use the city table)
select customer.customer_id, customer.first_name, customer.last_name, country.country
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where country.country = 'Nepal';
-- Kevin Schuler is the only Nepalese customer

-- 5. Which staff member had the most transactions?
-- transactions defined as payments?
-- we'll use a subquery
	-- we want our subquery to select only staff_id and only return one staff_id
select *
from staff
where staff_id in (
	select staff_id
	from payment
	group by staff_id
	order by count(staff_id) desc
	limit 1 -- limit <number> lets us show a specific number of results
);
-- transactions defined as rentals and using a join this time
select rental.staff_id, count(rental.staff_id), first_name, last_name, email
from rental
join staff
on rental.staff_id = staff.staff_id
group by rental.staff_id, first_name, last_name, email
order by count(rental.staff_id) desc
limit 1;

-- 6. How many movies of each rating are there?
-- doesn't need a join, no join that makes sense here
-- we want count of films grouped by rating
select rating, count(title) 
from film
group by rating;

-- question 6 part 2/a different question 6 - how many movies of each category are there?
-- looking at count of film_ids grouped by category_id from the film_category table 
-- and joining the category table on the category_id to bring in category names
select film_category.category_id, category.name, count(film_category.film_id)
from film_category
join category
on film_category.category_id = category.category_id
group by film_category.category_id, category.name
order by count(film_category.film_id) desc;

-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)
select *
from customer
where customer_id in (
	select customer_id
	from payment
	where amount > 6.99
);
-- 538 customers

-- 8. How many free rentals did our stores give away?
-- simple answer
select count(payment_id) from payment where amount = 0;
-- 23

-- follow up - which staff member is giving away more free rentals and at which store?
-- let's use a subquery - design a query returning a staff_id based on count of free rentals
select staff.staff_id, first_name, last_name, email, staff.store_id, address, district, city, country
from staff
join store
on staff.store_id = store.store_id
join address
on store.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where staff_id in (
	select staff_id
	from payment
	where amount = 0
	group by staff_id
	order by count(rental_id) desc
	limit 1
);
-- Mike Hillyer is giving away more free rentals at the store#1 in Alberta, La Romana, Dominican Republic

-- follow up - which films are given away as free rentals?
select payment.rental_id, rental.inventory_id, inventory.film_id, film.title, film.description 
from payment
join rental
on payment.rental_id = rental.rental_id
join inventory
on rental.inventory_id = inventory.inventory_id
join film
on inventory.film_id = film.film_id
where amount = 0;
