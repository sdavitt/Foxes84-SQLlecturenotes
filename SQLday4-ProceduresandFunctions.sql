-- Stored Function or Procedure in Postgres
-- the concept of a stored function in SQL/postgres is the same as the concept of a function in python
-- we can assign a name to a certain query or set of queries
-- have that name be able to accept input
-- run its process
-- and potentially return a value (although SQL functions do not particularly play well with return values)

-- One thing you will notice about stored functions and procedures in Postgres is the syntax is rather complicated
-- SQL was invented in the 1970s, it is an older language
-- and even more so than any other syntax in SQL, stored functions and procedures seem old 
-- outside of database management or a job where you are working very much day to day purely with sql
-- stored functions and procedures are not commonly used anymore

-- STORED PROCEDURE vs. a FUNCTION in SQL 
-- What's the difference?
-- The answer is very little. Before Postgres 11, there was no difference. 
-- Only functions existed and functions with no return values were just called procedures
-- Now, after postgres 11, there is a formal difference. The main formal difference (there are other smaller ones we wont really get into)
-- is that a Procedure has NO RETURN VALUE and a function does have a return value (although that return value can be nothing)

-- Let's look at creating a procedure to assign a late fee to a customer
-- This will be using DML (the UPDATE command) to increase the amount for a payment based on a rental_id

-- first let's see what columns we're dealing with
select * from payment where rental_id = 14741 or rental_id = 14107;

-- I want to set up a procedure that accepts a rental_id and an fee and increases the amount on that payment by the fee

-- procedure definition is equivalent to
-- def funcName(inputA, inputB):
-- a python function definition 
create or replace procedure lateFee (
	rental INTEGER, 
	feeAmount DECIMAL
)
language plpgsql
as $$
begin 
	-- here is where we write the actual query/process run by the procedure 
	-- UPDATE command
		-- update <table>
		-- set <column> = <value>
		-- where <condition>
	update payment
	set amount = amount + feeAmount
	where rental_id = rental;

	-- now, within a procedure running a query doesn't actually alter the database
	-- we need to tell the database to "save" the results from the query in the procedure
	commit;
end;
$$

-- call the procedure with input values to run it
-- equivalent to a function call in python
call lateFee(14741, 170.99);
call lateFee(14107, 9.99);

-- delete a procedure from my database using drop procedure 
drop procedure latefee;

-- Stored Functions
-- simple stored function: insert a new actor in our actor table

select * from actor;

-- syntax is very similar to our procedure 
create or replace function addactor(actorid INTEGER, firstname VARCHAR, lastname VARCHAR, lastupdate TIMESTAMP without TIME zone)
returns table(fname VARCHAR, lname VARCHAR)
as $func$ 
begin 
	insert into actor(actor_id, first_name, last_name, last_update)
	values (actorid, firstname, lastname, lastupdate);

	-- return query allows us to see the newly added actor in our database
	return query select first_name, last_name from actor where actor_id = actorid;
end;
$func$
language plpgsql;

-- let's call our function 
-- how not to call a function in postgres:
-- call addactor()
-- it would make a lot of sense to use the call keyword
-- but addactor is a function not a procedure therefore we don't call it
-- we select it

-- addactor function in the version we made that had no return value
select addactor(566, 'Kevin', 'Beier', NOW()::timestamp);
select addactor(567, 'Christopher', 'Thrutchley', NOW()::timestamp);
select addactor(584, 'Devon', 'W', NOW()::timestamp);
-- what is happening with NOW()::timestamp?
	-- NOW() let's postgres access our system's clock to get current time
	-- and :: is postgres' typecasting (aka data type conversion) syntax
	-- so we're grabbing our system's current time and converting it to a postgres timestamp


-- working with a return value
select * from addactor(666, 'The', 'Devil', NOW()::timestamp);
-- the returned value from a SQL function is not a permanent table in our database
-- retuning a value from a sql function is mostly done to see the results of our query (not dissimilar to how we might use a print() in python)
-- the same effect can be achieved by just running a select statement after your query is done 
select * from actor where actor_id > 500;

-- delete the function addactor
drop function addactor;

-- a potential benefit of using a return value in a function
-- although not commonly used 
-- is that a function with a return value can be used a subquery
-- not really necessary, but cool that it works


-- what is the declare clause? essentially a different way to alias our inputs (give names to parameters)
-- same function as above just with declare
-- Easier to just use the pythonic syntax of declaring parameter names right after function name as is done above
create or replace function addactordecl(INTEGER, VARCHAR, VARCHAR, TIMESTAMP without TIME zone)
returns table(fname VARCHAR, lname VARCHAR)
as $func$
declare
	actorid alias for $1;
	fname alias for $2;
	lname alias for $3;
	lastupdate alias for $4;
begin 
	insert into actor(actor_id, first_name, last_name, last_update)
	values (actorid, firstname, lastname, lastupdate);

	-- return query allows us to see the newly added actor in our database
	return query select first_name, last_name from actor where actor_id = actorid;
end;
$func$
language plpgsql;