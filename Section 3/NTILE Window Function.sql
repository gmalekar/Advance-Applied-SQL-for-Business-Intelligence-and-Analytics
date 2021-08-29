-- I want top 10 % of movies by rental amount
select f.film_id
,f.title
,sum(p.amount) rental_amount
,ntile(100) over (order by sum(p.amount) desc) p_rank
,sum(sum(p.amount)) over()
from payment p join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
group by 1,2
order by 3 desc
