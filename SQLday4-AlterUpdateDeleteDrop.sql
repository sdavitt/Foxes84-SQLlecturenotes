-- Changing database structure (When needed)
-- Is done using the following commands/clauses, which are part of the DDL and DML command families
-- The statements we use to change the database tables are:
-- ALTER, UPDATE/SET, DELETE/WHERE, ADD(used with an ALTER statment), DROP

select * from erd_customer;

-- modify a constraint (remove the not null from customer last name)
-- alter table <table name>
-- alter column <column name>
-- drop <constraint>
alter table erd_customer
alter column last_name
drop not null;

-- add the not null back
-- set is the inverse of drop for constraints
alter table erd_customer
alter column last_name
set not null;

-- set a default on a column
alter table erd_customer 
alter column billing_info
set default 'not provided';

-- add a column to a table
alter table erd_customer
add ispoor bool;

-- change datatype of a column
-- may need to provide a method of transformation if there is existing data in the column
-- optional USING clause at the end to provide some typecast for the transformation
alter table erd_customer
alter column ispoor
type varchar(10);

-- change the value in a column BAD PRACTICE NO WHERE CLAUSE
-- note: without a WHERE clause this will change EVERY VALUE IN THE COLUMN
update erd_customer
set ispoor = 'not poor';

select * from erd_customer;

-- change the value in a column - good practice
-- use a where clause to specify rows 
update erd_customer
set ispoor = 'poor'
where first_name = 'Dinesh';

-- delete a row from a table 
-- remember your where clause so that you don't delete everything
delete from erd_customer
where first_name is null;

select * from erd_customer;

-- add a row to a table
insert into erd_customer(customer_id, first_name, last_name, address, billing_info, ispoor)
values (4, 'Bertram', 'Gilfoyle', '5230 Newell Road, Palo Alto, CA', 'just bill jared', 'not poor');

-- deleting a column from a table 
alter table erd_customer
drop ispoor;

-- deleting a whole table 
drop table erd_brand;
-- a drop table won't run if there are other tables that depend on the table to be dropped
	-- aka have foreign keys referencing the table to be dropped 
-- we can drop a table and all of the tables that reference it at the same time
-- using drop table with cascade:
drop table erd_brand cascade;