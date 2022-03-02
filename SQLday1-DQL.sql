-- Hello SQL World! A comment is written with two dashes
-- Today we're looking at DQL aka select statements!

-- The hello world of SQL queries: select all from a table
select *
from actor;

-- select <columns>
-- from <table>;

-- what if I only want first and last name
select first_name, last_name
from actor;

-- WHERE clause
-- the where clause lets us filter our results by a condition 
select first_name, last_name
from actor
where first_name = 'Nick';

-- LIKE with a WHERE
select first_name, last_name
from actor
where first_name like 'Nick';

-- wildcards for use with like 
-- _ and %
-- % represents any number of any letter
-- _ represents a single instance of any letter
select first_name, last_name
from actor
where first_name like 'J___';

select first_name, last_name
from actor 
where first_name like 'J%';

select first_name, last_name
from actor
where first_name like 'J____%';

-- Comparison operators:
-- = and like shown above
-- Greater than >
-- Less than <
-- Greater or equal >=
-- Less than or equal <=
-- Not equal <>

-- Explore data with SELECT ALL query
select *
from payment;

-- query for the customers who paid an amount greater than $2
select customer_id, amount
from payment
where amount > 2;

select customer_id, amount
from payment
where amount < 7;

-- using AND to combine conditionals just like python
select customer_id, amount
from payment
where amount > 2  and amount < 7;

-- or use between 
select customer_id, amount
from payment
where amount between 2 and 7;

-- OR operator 
select customer_id, amount
from payment
where amount < 2  or amount > 7;

-- Order By lets us sort the results of our query
-- what are our most expensive payments?
select customer_id, amount
from payment
order by amount desc; -- desc for descending, default is ascending

-- order of our clauses matters
-- select <columns>
-- from <table>
-- where <conditional>
-- order by <column>;
-- cheapest payment that wasnt free
select customer_id, amount 
from payment
where amount <> 0
order by amount;

-- SQL Aggregations -> SUM(), AVG(), COUNT(), MIN(), MAX()

-- how many 0.99 cent payments do I have?
-- slow way: select all and count rows 
select *
from payment
where amount = 0.99;
-- 2690 $0.99 payments - note that my query result did not contain this info, i counted the rows

-- let's use aggregates
-- COUNT(<column>) the number of results in the column matching the query
select count(payment_id)
from payment
where amount = 0.99;
-- 2690 is the actual result of the query

-- How much did this company make from 0.99 payments?
select sum(amount)
from payment
where amount = 0.99;
-- we made $2663.10 from 0.99 payments

-- What payment amount made the most money?
-- I want the sum of the amount for each amount separately
-- but I want it in one query
-- Enter the GROUP BY clause
-- the GROUP BY clause is used in conjunction with aggregates in order to modify the behavior of the way the aggregate groups rows
select amount, count(amount), sum(amount)
from payment
group by amount
order by sum(amount) desc;
-- we made the most money off of $4.99 payments - total $16,970.99

-- which payment amount did we have the most transactions of?
select amount, count(amount), sum(amount)
from payment
group by amount
order by count(amount) desc;
-- also $4.99 payments - all 3,401 of them

-- how many free transactions did we have?
select count(payment_id)
from payment
where amount = 0;
-- 24 free transactions

-- display sums of amounts that different customers are spending
-- when selecting both a non-aggregate column and an aggregate function
-- the non-aggregate column must appear in a groupby
select customer_id, sum(amount)
from payment
group by customer_id
order by sum(amount) desc;
-- which customer spent the most?
-- customer_id 1 spent $16,794.4

-- MAX() and MIN() aggregates are very straightforward
-- what's the most expensive single payment?
select max(amount)
from payment;
-- $565.98

-- I can use a where clause with MAX() or MIN()
-- or with any other aggregate
-- Whats the most expensive payment under $500?
select max(amount)
from payment
where amount < 500;
-- $305.93

-- group by multiple columns
-- I can further separate out my grouped data
-- by specifying two group by columns
-- separate out the sum of the amounts of different payment values for each customer_id

select customer_id, amount, sum(amount)
from payment
where customer_id = 8
group by customer_id, amount
order by customer_id;

-- clauses we've talked about so far (in the order they must appear):
-- select <columns> <aggregates>
-- from <table>
-- where <conditional>
-- group by <columns>
-- order by <column>

-- where allows us to modify/filter the results of the select 
-- specifically with our normal columns 

-- we have another clause that allows us to similarly filter the results of an aggregates 
-- HAVING lets us apply a conditional filtering an aggregate
-- WHERE is to SELECTING a normal column like HAVING is to an AGGREGATE
-- a having clause would appear directly after a group by 
-- ORDER OF CLAUSES IF USING EVERYTHING:
-- select <columns> <aggregates>
-- from <table>
-- where <conditional>
-- group by <columns>
-- having <conditional>
-- order by <column>

-- Which customers paid more than $5000?
select customer_id, sum(amount)
from payment
group by customer_id
having sum(amount) >= 5000
order by sum(amount);
-- only two customers paid more than $5000 -> customer_id 6 and customer_id 1

-- Who are those customers?
-- I can take those customer_ids and go find the associated information from the customer table!
select *
from customer
where customer_id = 1 or customer_id = 6;
-- Mary Smith and Jennifer Davis are our two best customers

-- This afternoon we'll start looking at how we could combine those two queries into a single query