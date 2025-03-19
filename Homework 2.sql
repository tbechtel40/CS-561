/* Todd Bechtel */
/* CWID: 20005967 */
/* CS 561 */
/* 12/15/23 */
/* I pledge my honor that I have abided by the Stevens Honor System. */

/* Query #1 (done) */

WITH q1 as
	(select s.cust, s.prod, s.month, round(avg(quant), 2) avg
	from sales s
	group by s.cust, s.prod, s.month),
q2 as
	(select s.cust, s.prod, s.month + 1 prev_month, round(avg(quant), 2) prev_month_avg
	from sales s
	left join q1
	on s.prod = q1.prod and s.month - 1 = q1.month and s.quant = q1.avg
	group by s.cust, s.prod, s.month),
q3 as
	(select s.cust, s.prod, s.month - 1 next_month, round(avg(quant), 2) next_month_avg
	from sales s
	left join q1
	on s.prod = q1.prod and s.month + 1 = q1.month and s.quant = q1.avg
	group by s.cust, s.prod, s.month),
q4 as
	(select q1.cust, q1.prod, q1.month, q2.prev_month - 1 prev_month, q1.avg, q2.prev_month_avg
	from q1 left join q2
	on q1.month = q2.prev_month and q1.cust = q2.cust and q1.prod = q2.prod
	group by q1.cust, q1.prod, q1.month, q2.prev_month, q1.avg, q2.prev_month_avg),
q5 as
	(select q4.cust, q4.prod, q4.prev_month, q4.month, q3.next_month + 1 next_month, q4.prev_month_avg, q4.avg, q3.next_month_avg
	from q4 left join q3
	on q4.month = q3.next_month and q4.cust = q3.cust and q4.prod = q3.prod
	group by q4.cust, q4.prod, q4.prev_month, q4.month, q3.next_month, q4.prev_month_avg, q4.avg, q3.next_month_avg),
q6 as
	(select q5.cust, q5.prod, (case when q5.prev_month is null then 0 else q5.prev_month end), q5.month,
	(case when q5.next_month is null then 0 else q5.next_month end), (case when q5.prev_month_avg is null then 0 else q5.prev_month_avg end), 
	q5.avg, (case when q5.next_month_avg is null then 0 else q5.next_month_avg end)
	from q5),
q7 as
	(select q6.cust customer, q6.prod product, q6.month, count(s.quant) sales_count_between_avgs
	from q6 left join sales s
	on s.month = q6.month
	and (s.quant between q6.prev_month_avg and q6.next_month_avg)
	or (s.quant between q6.next_month_avg and q6.prev_month_avg)
	group by q6.cust, q6.prod, q6.month)
SELECT *
FROM q7
ORDER BY customer, product, month

/* Query #2 (done) */

WITH q1 as
	(select s.cust, s.prod, s.month, round(avg(quant), 2) avg
	from sales s
	group by s.cust, s.prod, s.month),
q2 as
	(select s.cust, s.prod, s.month + 1 prev_month, round(avg(quant), 2) prev_month_avg
	from sales s
	left join q1
	on s.prod = q1.prod and s.month - 1 = q1.month and s.quant = q1.avg
	group by s.cust, s.prod, s.month),
q3 as
	(select s.cust, s.prod, s.month - 1 next_month, round(avg(quant), 2) next_month_avg
	from sales s
	left join q1
	on s.prod = q1.prod and s.month + 1 = q1.month and s.quant = q1.avg
	group by s.cust, s.prod, s.month),
q4 as
	(select q1.cust, q1.prod, q1.month, q2.prev_month - 1 prev_month, q1.avg, q2.prev_month_avg
	from q1 left join q2
	on q1.month = q2.prev_month and q1.cust = q2.cust and q1.prod = q2.prod
	group by q1.cust, q1.prod, q1.month, q2.prev_month, q1.avg, q2.prev_month_avg),
q5 as
	(select q4.cust customer, q4.prod product, q4.month, q4.prev_month_avg before_avg, q4.avg during_avg, q3.next_month_avg after_avg
	from q4 left join q3
	on q4.month = q3.next_month and q4.cust = q3.cust and q4.prod = q3.prod
	group by q4.cust, q4.prod, q4.month, q4.prev_month_avg, q4.avg, q3.next_month_avg)
SELECT *
FROM q5
ORDER BY customer, product, month

/* Query 3 (done) */

WITH q1 as
	(select s.cust, s.prod, s.state, round(avg(quant), 2) avg
	from sales s
	group by s.cust, s.prod, s.state),
q2 as
	(select q1.cust, q1.prod, q1.state, round(avg(quant), 2) other_cust_avg
	from q1, sales s
	where q1.prod = s.prod AND q1.state = s.state AND q1.cust != s.cust
	group by q1.cust, q1.prod, q1.state),
q3 as
	(select q1.cust, q1.prod, q1.state, round(avg(quant), 2) other_prod_avg
	from q1, sales s
	where q1.prod != s.prod AND q1.state = s.state AND q1.cust = s.cust
	group by q1.cust, q1.prod, q1.state),
q4 as
	(select q1.cust, q1.prod, q1.state, round(avg(quant), 2) other_state_avg
	from q1, sales s
	where q1.prod = s.prod AND q1.state != s.state AND q1.cust = s.cust
	group by q1.cust, q1.prod, q1.state)
SELECT *
FROM q1 natural join q2 natural join q3 natural join q4
ORDER BY cust, prod, state

/* Query 4 (done) */

WITH q1 as
	(select s.cust, max(quant)
	from sales s
	where s.state = 'NJ'
	group by s.cust),
q4 as
	(SELECT s.cust, MAX(s.quant) AS second_max
	 FROM sales s, q1
	 WHERE q1.cust = s.cust AND s.quant < q1.max AND state = 'NJ'
	 GROUP BY s.cust),
q5 as
	(SELECT s.cust, MAX(s.quant) AS third_max
	 FROM sales s, q4
	 WHERE q4.cust = s.cust AND s.quant < q4.second_max AND state = 'NJ'
	 GROUP BY s.cust),
q6 as
	(SELECT * from q1
	 UNION
	 SELECT * from q4
	 UNION
	 SELECT * from q5),
q7 as
	(SELECT q6.cust customer, q6.max quantity, s.prod product, s.date
	FROM sales s, q6
	WHERE s.cust = q6.cust and s.quant = q6.max)
SELECT *
FROM q7
ORDER BY customer, quantity DESC

/* Query 5 (done) */

with base as
	(select distinct prod, quant
	from sales
	order by 1, 2),
q1 as
	(select b.prod, b.quant, count(s.quant) pos
	from sales s, base b
	where b.prod = s.prod and s.quant <= b.quant
	group by b.prod, b.quant),
q2 as
	(select q1.prod, ceil(max(q1.pos)/2.0) median_pos
	from q1
	group by q1.prod),
q3 as
	(select q1.prod, q1.quant, q1.pos
	from q1, q2
	where q1.prod = q2.prod and q1.pos >= q2.median_pos
	),
q4 as
	(select q3.prod product, min(q3.quant) median_quant
	from q3
	group by q3.prod
	)
select *
from q4
order by product