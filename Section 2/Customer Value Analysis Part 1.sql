-- -- buyerid, email, first order, recent order, total spend
with base_table as 
(
select customer_id
,payment_date
,ROW_NUMBER() OVER (partition by customer_id order by payment_date) first_order_date
,row_number() over (partition by customer_id order by payment_date desc) recent_order_date
from payment),

second_table as (
select * from base_table where first_order_date = 1 or recent_order_date =1
)

select customer_id
,min(payment_date) first_order_date
,max(payment_date) recent_order_date
,(select sum(amount) from payment where payment.customer_id = st.customer_id) ltv_spent
from second_table st
group by 1

-- How I had done it, not optimum, was just focusing on getting it done.
/*** Case study one Need spreadsheet with 
Buyer, email/id, first_order, recent_order, total spend
***/

with first_orders -- all details for the first order
as
(select
* from
(select *
,ROW_NUMBER() OVER (partition by customer_id order by payment_date)
,sum(amount) over (partition by customer_id) total_spend
 ,max(payment_date) over (partition by customer_id order by payment_date desc) recent_order_date
from payment
order by 2) t1
where t1.row_number = 1)

select c.customer_id
,fo.payment_date first_order_date
,fo.recent_order_date
,fo.total_spend
from customer c
left join first_orders fo on c.customer_id = fo.customer_id
