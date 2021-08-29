-- using lag to get the interval between two orders
select
t1.*
,payment_date - lag_date some_interval
,extract(epoch from payment_date - lag_date)/3600 as hours_between_orders
from(
select *
,lag(payment_date) over(partition by customer_id order by payment_date) lag_date
from payment ) t1

-- using window function alias to calculate moving averages
select *
,avg(amount) over w as "7_day_SMA"
,avg(amount) over w2 as "9_day_SMA"
from payment
window w as (order by payment_date rows between 7 preceding and 0 following),
w2 as (order by payment_date rows between 14 preceding and 0 following)
