with base_table as 
(
select customer_id
,payment_date
,ROW_NUMBER() OVER (partition by customer_id order by payment_date) first_order_date
,row_number() over (partition by customer_id order by payment_date desc) recent_order_date
from payment),

second_table as (
select * from base_table where first_order_date = 1 or recent_order_date =1
),

ratings as (--Preferred rating, figure out how to get their rating.
select
*
from(
select customer_id
,rating
,count(*) rental_by_rating
,row_number() over (partition by customer_id order by count(*) desc)
from(
	select r.customer_id
	,r.inventory_id
	,i.film_id
	,f.rating
	from rental r
	join inventory i on r.inventory_id = i.inventory_id
	join film f on i.film_id = f.film_id
	)t1
group by 1,2
--order by 1, 3 desc
) t2
where t2.row_number = 1),

agg as(
select customer_id
,count(*) total_rentals
,array_agg(distinct rating) all_ratings
from(
	select r.customer_id
	,r.inventory_id
	,i.film_id
	,f.rating
	from rental r
	join inventory i on r.inventory_id = i.inventory_id
	join film f on i.film_id = f.film_id
	)t1
group by 1
)

select sub1.*
,r.rating
,r.rental_by_rating
,a.total_rentals
,a.all_ratings
from(
select customer_id
,min(payment_date) first_order_date
,max(payment_date) recent_order_date
,(select sum(amount) from payment where payment.customer_id = st.customer_id) ltv_spent
from second_table st
group by 1) sub1
left join ratings r on sub1.customer_id = r.customer_id
left join agg a on sub1.customer_id = a.customer_id

