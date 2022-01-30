
-- 1. First and last names for all actors
select first_name, last_name from sakila.actor;

-- 2.a Full names for all actors
select UCASE(concat(first_name, ' ',last_name)) as Actor_name
from sakila.actor;

-- 2.b Actor_id, first and last names for all actors with first name Joe
select actor_id, first_name, last_name
from sakila.actor
where first_name in ('Joe');

-- 2.c Actor_id, first and last names for all actors name containg 'gen'
select UCASE(concat(first_name, ' ',last_name)) as Actor_name
from sakila.actor
where UCASE(concat(first_name, ' ',last_name)) like '%gen%';

-- 2.d Actor_id, first and last names for all actors name containg 'li' ordered
select UCASE(concat(last_name, ' ',first_name)) as Actor_name2
from sakila.actor
where UCASE(concat(last_name, ' ',first_name)) like '%li%'
order by UCASE(concat(last_name, ' ',first_name));

-- 3. No of actors with distinct last names
select count(DISTINCT last_name) from sakila.actor;

-- 4. Last names more than once in actors' list
select last_name as 'Last name more than once', count(last_name) as 'No. of times'
from sakila.actor
group by last_name
having count(last_name) > 1;

-- 5. Country id and name for China, Afganistan and Israel
select country_id, country
from sakila.country
where country in ('China', 'Afghanistan', 'Israel');

-- 6. Average length of a film
select avg(length) as 'Average length of a film'
from sakila.film;

select * from sakila.staff;

-- 7. Name and address for whole staff
select last_name, first_name, address, address2, district, city, country, postal_code
from sakila.staff
inner join sakila.address using(address_id)
inner join sakila.city using(city_id)
inner join sakila.country using(country_id);

-- 8. Customers and amounts paid (for first 10 only)
select customer_id, last_name, first_name, amount
from sakila.payment
inner join sakila.customer using(customer_id)
group by customer_id
limit 10;

-- 9. Film names with actors (for first 20 only)
select title, actor_id, last_name, first_name
from sakila.film
inner join sakila.film_actor using(film_id)
inner join sakila.actor using(actor_id)
order by title
limit 20;


