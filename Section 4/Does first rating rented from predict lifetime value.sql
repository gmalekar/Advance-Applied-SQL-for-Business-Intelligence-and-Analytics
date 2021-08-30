--Does first rating rented from predict lifetime value.

with first_order as (
select *
	from (
select
payment_id,customer_id, rental_id ,payment_date,amount
,row_number() over (partition  by customer_id order by payment_date)
from payment) sub1
where row_number = 1),

film_num as (
select rating
,count(distinct film_id) num_films
from film
group by 1),

second_table as(
select
sub1.rating
,customer_id
,sum(amount) as total_amount
,count(*)
,(select sum(p.amount) from payment p where p.customer_id=sub1.customer_id ) lifetime_spent
from(
select fo.rental_id
,fo.customer_id
,fo.amount
,i.film_id
,f.rating
from first_order fo
join rental r on fo.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
) sub1
group by 1,2)

select rating
,avg(lifetime_spent)
from second_table
group by 1
