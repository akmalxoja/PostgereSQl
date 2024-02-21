create table customers(
    customer_id int ,
    card_number char(16),
    discount smallint
)

create table persons(
    person_id int,
    person_first_name varchar(255),
    person_last_name varchar(255),
    person_birth_date date
)

create table person_contacts(
    person_contact_id int,
    person_id int,
    contact_type_id int,
    contact_value varchar(255)
)

create table contact_types(
    contact_type_id int,
    contact_type_name varchar(255),

)


create table product_manufacturers(
    manufacturer_id int,
    manufacturer_name varchar(255)
)

create table product_suppliers(
    supplier_id int,
    supplier_name varchar(256)
)

create table product_titles(
    product_title_id int,
    product_title varchar(255),
    product_category_id int
)
create table product_categories(
    category_id int,
    category_name varchar(255)
)
create table shop_products(
    product_id int,
    product_title_id int,
    product_manufacturer_id int,
    product_supplier_id int,
    unit_price money ,
    comment text
)
create table customer_orders(
    customer_order_id int,
    operation_time timestamp,
    supermarket_location_id int,
    customer_id int
)

create table customer_order_details(
    customer_order_detail_id int,
    customer_order_id int,
    product_id int,
    price decimal,
    price_with_discount decimal,
    product_amount int
)





create table supermarket_locations(
    supermarket_location_id int,
    supermarket_id int,
    location_id int
) 

create table locations(
    location_id int,
    location_address varchar(255),
    location_city_id int
)

create table location_city(
    city_id int,
    city varchar(255),

)

create table supermarkets(
    supermarket_id int,
    supermarket_name varchar(255)
)









ALTER TABLE shop_products
ADD CONSTRAINT PK_shop_products
PRIMARY KEY(product_id);

ALTER TABLE product_manufacturers
ADD CONSTRAINT PK_product_manufacturers
PRIMARY KEY(manufacturer_id);


ALTER TABLE product_suppliers
ADD CONSTRAINT PK_product_suppliers
PRIMARY KEY(supplier_id);


ALTER TABLE product_titles
ADD CONSTRAINT PK_product_titles
PRIMARY KEY(product_title_id);


ALTER TABLE product_categories
ADD CONSTRAINT PK_product_categories
PRIMARY KEY(category_id);


ALTER TABLE customer_orders
ADD CONSTRAINT PK_customer_orders
PRIMARY KEY(customer_order_id);


ALTER TABLE persons
ADD CONSTRAINT PK_persons
PRIMARY KEY(persons_id);

ALTER TABLE contact_types
ADD CONSTRAINT PK_contact_types
PRIMARY KEY(contact_type_id);



ALTER TABLE supermarket_locations
ADD CONSTRAINT PK_supermarket_locations
PRIMARY KEY(supermarket_location_id);

ALTER TABLE locations
ADD CONSTRAINT PK_locations
PRIMARY KEY(location_id);




ALTER TABLE location_city
ADD CONSTRAINT PK_location_city
PRIMARY KEY(city_id);

ALTER TABLE supermarkets
ADD CONSTRAINT PK_supermarkets
PRIMARY KEY(supermarket_id);

ALTER TABLE customers
ADD CONSTRAINT PK_customers
PRIMARY KEY(customer_id);







ALTER TABLE shop_products
ADD CONSTRAINT shop_products_product_title FOREIGN KEY(product_title_id)
    REFERENCES product_titles(product_title_id)

ALTER TABLE shop_products
ADD CONSTRAINT shop_products_product_suppliers FOREIGN KEY(product_supplier_id)
    REFERENCES product_suppliers(supplier_id)

ALTER TABLE shop_products
ADD CONSTRAINT shop_products_product_manufacturers FOREIGN KEY(product_manufacturer_id)
    REFERENCES product_manufacturers(manufacturer_id)    


ALTER TABLE product_titles
ADD CONSTRAINT product_titles_product_categories FOREIGN KEY(product_category_id)
    REFERENCES product_categories(category_id)


    ALTER TABLE customer_orders
ADD CONSTRAINT customer_orders_supermarket_locations FOREIGN KEY(supermarket_location_id)
    REFERENCES supermarket_locations(supermarket_location_id)

ALTER TABLE customer_orders
ADD CONSTRAINT customer_orders_customers FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)




ALTER TABLE customer_order_details
ADD CONSTRAINT customer_order_details_customer_orders FOREIGN KEY(customer_order_id)
    REFERENCES customer_orders(customer_order_id)

ALTER TABLE customer_order_details
ADD CONSTRAINT customer_order_details_shop_products FOREIGN KEY(product_id)
    REFERENCES shop_products(product_id)



ALTER TABLE customers
ADD CONSTRAINT customers_persons FOREIGN KEY(customer_id)
    REFERENCES persons(person_id)






    ALTER TABLE person_contacts
ADD CONSTRAINT person_contacts_persons FOREIGN KEY(person_id)
    REFERENCES persons(person_id)




    ALTER TABLE person_contacts
ADD CONSTRAINT person_contacts_persons FOREIGN KEY(contact_type_id)
    REFERENCES contact_types(contact_type_id)

    ALTER TABLE supermarket_locations
ADD CONSTRAINT supermarket_locations_supermarkets FOREIGN KEY(supermarket_id)
    REFERENCES supermarkets(supermarket_id)

    ALTER TABLE supermarket_locations
ADD CONSTRAINT supermarket_locations_locations FOREIGN KEY(location_id)
    REFERENCES locations(location_id)





--13
update shop_products set unit_price=1.1*unit_price
where product_manufacturer_id=(select manufacturer_id from product_manufacturers where manufacturer_name='Orbit')
and product_title_id in (select product_title_id from product_titles where product_category_id=(select category_id from product_categories where category_name='grocery')
)




--14
select person_first_name || '   ' || person_last_name as fullname,avg((price_with_discount::decimal)*product_amount) as avg_sum from customer_order_details
inner join customer_orders using(customer_order_id)
inner join customers using(customer_id)
inner join persons on customers.customer_id=persons.person_id
group by person_id
having avg((price_with_discount::decimal)*product_amount)>200000
order by avg((price_with_discount::decimal)*product_amount) desc,fullname asc


--15
select persons.person_first_name,persons.person_last_name,product_titles.product_title from customer_order_details
inner join customer_orders  using(customer_order_id) 
inner join product_titles on product_id=product_title_id
inner join customers on customer_orders.customer_order_id=customers.customer_id
inner join persons on customers.customer_id=persons.person_id
where  persons.person_birth_date between '01-01-2000' and '01-01-2005'


--16
begin
delete from shop_products
where product_title_id in (
    select product_title_id
    from product_titles
    where product_category_id IN (
        select category_id
        from product_categories
        where category_name = 'drinks'
    )
);
rollback




 -- 17
insert into product_categories(category_id,category_name) values(21,'nimadur')
insert into product_titles(product_title_id,product_title,product_category_id) values(365,'tezroq ishla',19)
insert into product_suppliers(supplier_id,supplier_name) values(27,'Kimdur')
insert into product_manufacturers(manufacturer_id,manufacturer_name) values(39,'qashqadaryo')
insert into shop_products(product_id,product_title_id,product_manufacturer_id,product_supplier_id,unit_price,comment) 
values(99001,365,39,27,'$200000','ishladiyov')







 --18
select
  product_title_id,
  comment,
  case
    when unit_price::decimal < 300 then 'very cheap'
    when unit_price::decimal > 300 and unit_price::decimal <= 750 then 'affordable'
    else 'expensive'
  end as type
from  shop_products;


--19
select supermarket_id,supermarket_name,count(distinct product_id)
from supermarkets
join supermarket_locations using(supermarket_id)
join customer_orders using(supermarket_location_id)
join customer_order_details using(customer_order_id)
group by(supermarket_id)



--20                       
create or replace function GetProductListByPeratinDate(OPERATIONDATE date) RETURNS TABLE (P VARCHAR(255)) LANGUAGE PlpgSql AS $$
begin
return query select product_titles.product_title from customer_order_details
inner join customer_orders using(customer_order_id)
inner join product_titles on product_titles.product_title_id= customer_order_details.product_id
where DATE(operation_time)=operationDate;
end;$$;

select * from GetProductListByPeratinDate('2016-06-06');



--21
CREATE or replace FUNCTION getCustomerListForManufacturer1(manufacturer_name1 varchar) RETURNS TABLE (P VARCHAR(255)) LANGUAGE PlpgSql AS $$
begin
return query select product_titles.product_title from product_manufacturers
inner join shop_products on product_manufacturer_id=manufacturer_id
inner join product_titles on shop_products.product_title_id=product_titles.product_title_id
where manufacturer_name=manufacturer_name1;
end;$$;

select * from getCustomerListForManufacturer1('OFS Capital Corporation');




--23
CREATE VIEW Checkout  AS 
select product_titles.product_title,customer_order_details.price_with_discount,customer_order_details.product_amount,customer_order_details.price from customer_order_details
inner join shop_products using(product_id)
inner join product_titles on product_titles.product_title_id=shop_products.product_title_id

select * from Checkout





--24
create view product_details  as
select pt.product_title, pc.category_name, sup.supplier_name, pm.manufacturer_name  
from shop_products as sp inner join product_titles as pt
on sp.product_title_id=pt.product_title_id inner join product_categories as pc
on pt.product_category_id = pc.category_id inner join product_suppliers as sup on 
sp.product_supplier_id=sup.supplier_id inner join product_manufacturers as pm on
sp.product_manufacturer_id = pm.manufacturer_id

 
 
--25
create view Customer_details as
select person_first_name|| ' ' || person_last_name as FullName,
person_birth_date, c.card_number
from persons inner join customers as c on person_id=customer_id
select * from Customer_details


--Sharifxo'jayev Akmalxo'ja
