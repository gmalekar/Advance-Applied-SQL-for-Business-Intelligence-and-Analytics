--Free Form Analysis 
-- First Order Analysis
/*** Based on all initial orders, do customers prefer a specfic type of rating?
Outline - get all the first initial orders - map them to their rating - then getting the count of ratings
***/

with first_order as (
select *
	from (
select
payment_id,customer_id, rental_id ,payment_date,amount
,row_number() over (partition  by customer_id order by payment_date)
from payment) sub1
where row_number = 1)

select
rating
,sum(amount) as total_amount
,count(*) total_order
from(
select fo.rental_id
,fo.amount
,i.film_id
,f.rating
from first_order fo
join rental r on fo.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
) sub1
group by 1
order by 2 desc

