--Get customers sales amount for their first 7 days,  14 days and their LTV.

with bt as 
(
	select * from(
		select
		customer_id
		,payment_date
		,row_number() over (partition by customer_id order by payment_date)
		from payment)sub1
	where sub1.row_number = 1
)

select 
bt.*
,(select sum(p2.amount) 
  from payment p2 
  where p2.customer_id = bt.customer_id
 and p2.payment_date between bt.payment_date and bt.payment_date + interval '7 day') first7_sales
,(select sum(p2.amount) 
  from payment p2 
  where p2.customer_id = bt.customer_id
 and p2.payment_date between bt.payment_date and bt.payment_date + interval '14 day') first14_sales
,(select sum(p2.amount)
 from payment p2
 where p2.customer_id=bt.customer_id) LTV
from bt
