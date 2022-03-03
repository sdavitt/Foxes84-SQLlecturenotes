-- Day 2 - working with joins (and a brief intro to DDL)
create table join_customer(
	customer_id serial primary key,
	first_name varchar(100),
	last_name varchar(100),
	email varchar(200),
	address varchar(150),
	city varchar(150),
	customer_state varchar(100),
	zipcode varchar(10)
);
select * from join_customer;
create table join_order(
	order_id serial primary key,
	order_date date default current_date,
	amount numeric(5,2), -- decimals between -999.99 and 999.99
	customer_id integer,
	foreign key(customer_id) references join_customer(customer_id)
);
select * from join_order;

insert into join_customer(first_name, last_name, email, address, city, customer_state, zipcode)
values('George', 'Washington', 'gwash@usa.gov', '3200 Mt Vernon Hwy', 'Mt Vernon', 'VA', '22121');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('John','Adams','jadams@usa.gov','1200 Hancock', 'Quincy', 'MA','02169');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('Thomas','Jefferson', 'tjeff@usa.gov', '931 Thomas Jefferson Pkway', 'Charlottesville','VA','02169');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('James','Madison', 'jmad@usa.gov', '11350 Conway','Orange','VA','02169');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('James','Monroe','jmonroe@usa.gov','2050 James Monroe Parkway','Charlottesville','VA','02169');

INSERT INTO join_order(amount,customer_id)
VALUES(234.56,4);

INSERT INTO join_order(amount,customer_id)
VALUES(78.50,6);

INSERT INTO join_order(amount,customer_id)
values(124.00,5);

INSERT INTO join_order(amount,customer_id)
VALUES(65.50,6);

INSERT INTO join_order(amount,customer_id)
VALUES(55.50,NULL); -- null is postgres' version of python's None

-- Let's talk about joins
select * from join_customer;
select * from join_order;

-- join_customer will be considered table A for the below examples
-- and join_order will be table B

-- Inner join - only takes data with matching data in both tables
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
join join_order
on join_customer.customer_id = join_order.customer_id;
-- notice that not all orders have a row in the result
-- and not all customers have a row in the result

-- full join - takes all of our data
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
full join join_order
on join_customer.customer_id = join_order.customer_id;
-- every possible row including those with nulls

-- outer join - all non-matching data
-- aka data from table_a that has no corresponding table_b
-- and table_b data that has no corresponding table_a data 
-- the way we do this is actually the same type of join - a full join
-- we just filter the results with a where clause
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
full join join_order
on join_customer.customer_id = join_order.customer_id
where order_id is null or join_customer.customer_id is null;


-- left join
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
left join join_order
on join_customer.customer_id = join_order.customer_id;

-- left outer join
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
left join join_order
on join_customer.customer_id = join_order.customer_id
where order_id is null;

-- right join
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
right join join_order
on join_customer.customer_id = join_order.customer_id;

-- right outer join
select order_id, join_customer.customer_id, first_name, last_name, email, amount
from join_customer
right join join_order
on join_customer.customer_id = join_order.customer_id
where email is null;
