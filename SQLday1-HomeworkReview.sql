-- SQL Day 1 Homework
-- DQL practice

-- 1. How many actors are there with the last name ‘Wahlberg’?
select *
from actor
where last_name like 'Wahlberg';
-- Two actors with last name 'Wahlberg'
select count(actor_id)
from actor
where last_name like 'Wahlberg';
-- aggregate version agrees - 2 wahlbergs

-- 2. How many payments were made between $3.99 and $5.99?
select count(amount)
from payment
where amount between 3.99 and 5.99;
-- 5,563 payments between 3.99 and 5.99 inclusive of 3.99 and 5.99 (if using BETWEEN or >= and <=)
-- 3,408 payments between 3.99 and 5.99 not inclusive of 3.99 and 5.99 (using > and <)

select * from inventory;
-- 3. What film does the store have the most of? (search in inventory)
select film_id, count(film_id)
from inventory
group by film_id
order by count(film_id) desc;
-- Film_id 200: 9 in inventory
select * from film where film_id = 200;
-- Film_id 200 is Curtain Videotape - A Boring Reflection of a Dentist And a Mad Cow who must Chase a Secret Agent in A Shark Tank - rental cost $0.99

-- 4. How many customers have the last name ‘William’?
select count(last_name)
from customer
where last_name like 'Williams';
-- Zero. But there is one 'Williams'.

-- 5. What store employee (get the id) sold the most rentals?
-- options - count of staff_ids within payment table
		-- count of staff_ids within rental table
select staff_id, count(staff_id)
from payment
group by staff_id
order by count(staff_id) desc;
-- according to the payment table, staff_id #2 sold 7304 rentals
select staff_id, count(staff_id)
from rental
group by staff_id
order by count(staff_id) desc;
-- according to the rental table however, staff_id #1 sold 8040 rentals
-- according to one table staff_id #2 sold most, according to the other, staff id #1 sold most

-- 6. How many different district names are there?
select district, count(district)
from address
group by district;
-- based on the above query giving me 378 rows - we have 378 different district names
-- however, there is a better way
-- use the distinct constraint to only select unique district names
select count(distinct district)
from address;

-- 7. What film has the most actors in it? (use film_actor table and get film_id)
-- aka what film_id has the highest count in the film_actor table
select film_id, count(*)
from film_actor
group by film_id
order by count(*) desc;
-- film_id#508 has the most actors - 16

-- what about the other side - what actor has appeared in the most films?
select actor_id, count(*)
from film_actor
group by actor_id
order by count(*) desc;
-- actor#107 appeared in 42 films

-- 8. From store_id 1, how many customers have a last name ending with ‘es’? (use customer table)
select count(customer_id) 
from customer
where store_id = 1 and last_name like '%es';
-- 13 customers shop at store_id#1 with a last name ending in 'es'

-- 9. How many payment amounts (4.99, 5.99, etc.) had a number of rentals above 250 for customers  with ids between 380 and 430? (use group by and having > 250) 
select amount, count(rental_id)
from payment
where customer_id between 380 and 430
group by amount
having count(rental_id) > 250;
-- we have 3 amounts with more than 250 rentals for customers with ids between 380 and 430

-- 10. Within the film table, how many rating categories are there? And what rating has the most movies total?
select count(distinct rating)
from film;
-- 5 different rating categories
select rating, count(*)
from film
group by rating
order by count(*) desc;
-- PG-13 has the most movies total at 223