-- Mock Database Creation using Amazon ERD

-- run create table command for each entity
create table erd_customer(
	-- column name data type constraints
	customer_id serial primary key,
	first_name varchar(50), -- varchar is a string of length 0 to n (in this case 50)
	last_name varchar(50) not null, -- we must have a customer last name 
	address varchar(150),
	billing_info varchar(150) not null
);

select * from erd_customer;

create table erd_brand(
	seller_id serial primary key,
	brand_name varchar(150) not null,
	contact_number varchar(15),
	address varchar(150)
);

select * from erd_brand;

create table erd_inventory(
	upc serial primary key,
	product_amount integer
);

-- now that my zero foreign key tables are complete
-- I can start creating the tables that rely on them
create table erd_product(
	item_id serial primary key,
	amount numeric(5,2), -- price between -999.99 and 999.99 (5 total digits, 2 decimal places)
	prod_name varchar(100) not null,
	upc integer,
	foreign key(upc) references erd_inventory(upc),
	seller_id integer,
	foreign key(seller_id) references erd_brand(seller_id)
);

create table erd_order(
	order_id serial primary key,
	order_date date default current_date,
	sub_total numeric(8,2), -- max value of 999,999.99 (8 total digits, 2 after the decimal)
	total_cost numeric(9,2), -- max value of 9,999,999.99 (9 total digits, 2 after the decimal)
	upc integer not null,
	foreign key(upc) references erd_inventory(upc)
);

-- now that the order and customer tables are created, I can create the cart that references both 
create table erd_cart(
	cart_id serial primary key,
	customer_id integer not null,
	foreign key(customer_id) references erd_customer(customer_id),
	order_id integer,
	foreign key(order_id) references erd_order(order_id) -- order_id is a foreign key that references the erd_order table's order_id column
);

-- now that all of my tables are created I can go ahead and put in some test/mock data
-- using INSERT commands
-- insert into <table>(<specific colums>)
-- values (<values for those columns>)

insert into erd_customer(first_name, last_name, address, billing_info)
values('Dinesh', 'Chugtai', '5230 Newell Road, Palo Alto, CA', 'poor');

select * from erd_customer;

insert into erd_customer(first_name, last_name, address, billing_info)
values('Hummingbird', 'Saltalamacchia', 'Santa Barbara', 'Psych Office');

-- multiple inserts of the same structure
insert into erd_customer(first_name, last_name, address, billing_info)
values
('Metheuselah', 'Honeysuckle', 'Santa Barbara', 'AMEX'),
(null, 'Gilfoyle', '5230 Newell Road, Palo Alto, CA', 'also poor'),
('Joao', 'Cancelo', 'Manchester, England', 'MCFC');


-- inserts where foreign keys are concerned
-- not null constraint means a value must be provided
-- if a value for a foreign key column is provided, the primary key it references must exist
	-- same concept as the ordering of our create table commands, just more specific
insert into erd_cart(customer_id)
values (4);

select * from erd_cart;

-- what names are tied to these carts?
select cart_id, erd_cart.customer_id, first_name, last_name
from erd_cart
join erd_customer
on erd_cart.customer_id = erd_customer.customer_id;

-- which customers have no cart?
select erd_customer.customer_id, first_name, last_name, address, billing_info
from erd_customer
left join erd_cart
on erd_cart.customer_id = erd_customer.customer_id
where erd_cart.cart_id is null;

-- which customers have no cart but make it a subquery
select *
from erd_customer
where customer_id not in (
	select customer_id
	from erd_cart
);

-- which customer have a cart: subquery edition
select *
from erd_customer
where customer_id in (
	select customer_id
	from erd_cart
);

