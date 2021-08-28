-- All payment details for the first order of a customer.
select
* from
(select *
,ROW_NUMBER() OVER (partition by customer_id order by payment_date) rw
from payment) t1
where rw = 1

-- list of orders of payments for staff members in reverse?
select *, 
row_number() over (partition by staff_id order by payment_date desc)row_number
from payment

-- All payment details for the most recent order by customer?
select
* from
(select *
,ROW_NUMBER() OVER (partition by customer_id order by payment_date DESC) rw
from payment) t1
where rw = 1
