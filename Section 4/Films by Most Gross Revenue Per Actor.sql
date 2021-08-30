-- Films by Most Gross Revenue Per Actor
with base_table as (
select amount, r.inventory_id, f.film_id,aa.first_name||' '||aa.last_name actor_name,aa.actor_id
from payment p 
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_actor fa on f.film_id = fa.film_id
join actor aa on fa.actor_id = aa.actor_id
),
total_actor as (
select
film_id
,count(distinct actor_id) num_actors
from(
select bt.film_id
,actor_id
from base_table bt
group by 1,2)sub1
group by 1
--order by 1
),
gross_amount as (
	select
	f.film_id
	,sum(p.amount) total_amount
	from
	payment p
	join rental r on p.rental_id = r.rental_id
	join inventory i on r.inventory_id=i.inventory_id
	join film f on f.film_id = i.film_id
group by 1
--order by 2 desc
)

select a.film_id
,total_amount
,num_actors
,total_amount / num_actors gross_revenue_per_actor
from gross_amount a
join total_actor b on a.film_id= b.film_id
order by 4 desc
