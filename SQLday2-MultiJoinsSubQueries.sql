-- SQL Day 2 - More joins, multijoins, and subqueries

-- Inner join on the actor and film_actor tables
select actor.actor_id, first_name, last_name, film_id
from actor
join film_actor
on actor.actor_id = film_actor.actor_id;

-- inner join film table and film_actor table
select actor_id, film.film_id, title, description, rating
from film_actor
join film
on film.film_id = film_actor.film_id;

-- We now have two separate joins involving the film_actor table
-- the result of those joins share columns - actor_id and film_id
-- because all three of these tables are related (involved in the many to many relationship between films and actors)
			-- one actor can be in many films
			-- one film can have many actors
-- we can perform a multijoin to have information from both the film table and the actor table in our resulting joined table
-- in other words, I can combine the two joins above into a single multijoin
select actor.actor_id, first_name, last_name, film.film_id, title, description, rating
from actor
join film_actor
on actor.actor_id = film_actor.actor_id
join film
on film.film_id = film_actor.film_id;

-- The above example is of using a multijoin in the scenario of a many to many relationship
-- Sometimes the information we want is spread across many tables to avoid copies of data (aka the database is normalized)
-- in that scenario we may need to perform a multijoin to actually get all the data in one place

-- Produce a query showing the first name, last name, and email of customers living in Angola
-- first figure out where the info is held
	-- write down your foreign key chain
select * from customer; -- customer has address_id fkey
select * from address; -- address has city_id fkey
select * from city; -- city has country_id fkey
select * from country; -- has country name

-- I want to filter the results of a select in the customer table
-- by country name
-- in order to do that, I need to get customer and country joined
-- they have no direct fkey
-- so i need to multijoin until they are joinable
select customer.customer_id, customer.first_name, customer.last_name, customer.email, address.address, address.district, city.city, country.country
from customer
join address
on customer.address_id = address.address_id
join city
on city.city_id = address.city_id
join country
on country.country_id = city.country_id
where country.country = 'Angola';
-- customers Claude Herzog and Martin Bales live in Angola


-- SubQuery Examples
-- What is a subquery?
-- We can actually make the condition of a where clause an entire separate query
-- This enables us to filter a table by another table or by the results of an aggregate while still selecting just normal columns

-- I want to write a query providing me with the customer information (first name, last name, etc.)
-- for customers who spent more than $175
-- we're asking for info from the customer table
-- but only if it meets certain criteria from the payment table
-- this could be done with a join
	-- payment table sum(amount) group by customer_id then join customer table on that customer_id
-- it could be somewhat done with 2 seperate queries
select * from customer;

select customer_id
from payment
group by customer_id
having sum(amount) > 175;

-- or it could be done using one query as a subquery
select *
from customer
where customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) > 175
);

-- key difference between a join and a subquery:
	-- the join's result will have data from both tables
	-- the subquery result will only have data from the outer query's table
-- random specific:
	-- a subquery can only select a single column- which must be the column specified right before the subquery

-- another basic subquery example
-- select all english language films
-- this specific example of a subquery is a pretty useless one
	-- same thing could be accomplished with the clause 'where language_id = 1'
select *
from film
where language_id in (
	select language_id 
	from language
	where name = 'English'
);

-- I want to know the name, email, address, city, and country of any customers who spent more than 175
-- multijoin and filtering it by a subquery
-- just combine our multijoin and the where clause from above examples
select customer.customer_id, customer.first_name, customer.last_name, customer.email, address.address, address.district, city.city, country.country
from customer
join address
on customer.address_id = address.address_id
join city
on city.city_id = address.city_id
join country
on country.country_id = city.country_id
where customer.customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) > 175
)
order by customer.customer_id;

-- a brief intro to DML - changing a value
-- I want to change the country 'Reunion' to 'Réunion' in the country table
select * from country where country = 'Réunion';
-- update command
update country
set country = 'Réunion'
where country = 'Reunion';
