-- Top Five Highest Grossing Actors and get all the movies that they have appeared in.
-- Compare total customers and customers renting those movies.

with base_table as (
select amount, r.inventory_id, f.film_id,aa.first_name||' '||aa.last_name actor_name,aa.actor_id
from payment p 
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_actor fa on f.film_id = fa.film_id
join actor aa on fa.actor_id = aa.actor_id
),

top_5_actors as (
select
actor_name
,actor_id
,sum(amount)
from base_table
group by 1,2
order by 3 DESC
limit 5),

top_movies as (
select distinct f.film_id
from
film f
join film_actor fa on f.film_id = fa.film_id
where actor_id in (select actor_id from top_5_actors))
-- The top 5 gross actors have feature in 183 movies.

-- there are total 599 customers. and 591 customers have rented movies which star top 5 grossing actor.
select
distinct p.customer_id
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
where film_id in (select * from top_movies)
