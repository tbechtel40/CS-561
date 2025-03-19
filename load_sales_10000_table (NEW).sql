/* Query #1 (done) */

WITH t1 AS
	(SELECT cust, min(quant) min_q, max(quant) max_q, round(avg(quant), 0) avg_q
	FROM sales
	GROUP BY cust),
t2 AS
	(SELECT t1.cust, t1.min_q, sales.prod min_prod, sales.date min_date, sales.state min_state, t1.max_q, t1.avg_q
	FROM t1, sales
	WHERE t1.cust = sales.cust and t1.min_q = sales.quant),
t3 AS
	(SELECT t2.cust, t2.min_q, t2.min_prod, t2.min_date, t2.min_state, t2.max_q,
	 sales.prod max_prod, sales.date max_date, sales.state max_state, t2.avg_q
	FROM t2, sales
	WHERE t2.cust = sales.cust and t2.max_q = sales.quant)
SELECT *
FROM t3
ORDER BY 1


/* Query #2 (done) */

/* WITH t1 AS
	(SELECT year, month, day, sum(quant) total_sales
	FROM sales
	GROUP BY year, month, day),
t2 AS
	(SELECT t1.year, t1.month, max(total_sales) busiest_total_q
	FROM t1
	GROUP BY year, month),
t3 AS
	(SELECT t1.year, t1.month, min(total_sales) slowest_total_q
	FROM t1
	GROUP BY year, month),
t4 AS
	(SELECT t1.year, t1.month, t1.day busiest_day, t2.busiest_total_q
	FROM t1
	JOIN t2 ON t1.year = t2.year AND t1.month = t2.month AND t1.total_sales = t2.busiest_total_q
	ORDER BY t1.year, t1.month),
t5 AS
	(SELECT t1.year, t1.month, t1.day slowest_day, t3.slowest_total_q
	FROM t1
	JOIN t3 ON t1.year = t3.year AND t1.month = t3.month AND t1.total_sales = t3.slowest_total_q
	ORDER BY t1.year, t1.month)
SELECT t4.year, t4.month, t4.busiest_day, t4.busiest_total_q, t5.slowest_day, t5.slowest_total_q
FROM t4
JOIN t5 ON t4.year = t5.year AND t4.month = t5.month */


/* Query #3 (done) */

/* WITH t1 AS
	(SELECT cust, prod, count(prod) prod_count
	FROM sales
	GROUP BY cust, prod),
t2 AS
	(SELECT t1.cust, max(t1.prod_count)
	FROM t1, sales
	WHERE t1.cust = sales.cust and t1.prod = sales.prod
	GROUP BY t1.cust),
t3 AS
	(SELECT t1.cust, min(t1.prod_count)
	FROM t1, t2, sales
	WHERE t1.cust = sales.cust and t1.prod = sales.prod
	GROUP BY t1.cust),
t4 AS
	(SELECT t2.cust, t1.prod most_fav_prod
	FROM t1, t2
	WHERE t1.prod_count = t2.max and t1.cust = t2.cust),
t5 AS
	(SELECT t3.cust, t1.prod least_fav_prod
	FROM t1, t3
	WHERE t1.prod_count = t3.min and t1.cust = t3.cust)
SELECT *
FROM t4
NATURAL JOIN t5
ORDER BY 1 */

/* Query #4 (done) */

/* WITH t1 AS
	(SELECT cust, prod product, round(avg(quant), 0) average, sum(quant) total, count(quant)
	FROM sales
	GROUP BY cust, prod),
t2 AS
	(SELECT t1.cust, t1.product, round(avg(quant), 0) spring_avg
	FROM t1, sales
	WHERE month >= 3 and month <= 5 and t1.cust = sales.cust and t1.product = sales.prod
	GROUP BY t1.cust, t1.product),
t3 AS
	(SELECT t1.cust, t1.product, round(avg(quant), 0) summer_avg
	FROM t1, sales
	WHERE month >= 6 and month <= 8 and t1.cust = sales.cust and t1.product = sales.prod
	GROUP BY t1.cust, t1.product),
t4 AS
	(SELECT t1.cust, t1.product, round(avg(quant), 0) fall_avg
	FROM t1, sales
	WHERE month >= 9 and month <= 11 and t1.cust = sales.cust and t1.product = sales.prod
	GROUP BY t1.cust, t1.product),
t5 AS
	(SELECT t1.cust, t1.product, round(avg(quant), 0) winter_avg
	FROM t1, sales
	WHERE (month = 12 or month <= 2) and t1.cust = sales.cust and t1.product = sales.prod
	GROUP BY t1.cust, t1.product)
SELECT t1.cust customer, t1.product, t2.spring_avg, t3.summer_avg, t4.fall_avg, t5.winter_avg, t1.average, t1.total, t1.count
FROM t1
JOIN t2 ON t1.cust = t2.cust and t1.product = t2.product
JOIN t3 ON t1.cust = t3.cust and t3.product = t2.product
JOIN t4 ON t1.cust = t4.cust and t1.product = t4.product
JOIN t5 ON t1.cust = t5.cust and t1.product = t5.product
ORDER BY 1 */

/* Query #5 (done) */

/* WITH t1 AS
	(SELECT prod, day, month, max(quant) max_q
	FROM sales
	GROUP BY prod, day, month),
t2 AS
	(SELECT t1.prod, max(t1.max_q) q1_max
	FROM sales, t1
	WHERE t1.month >= 1 and t1.month <= 3 and t1.prod = sales.prod and t1.day = sales.day and t1.month = sales.month
	GROUP BY t1.prod),
t2sub AS
	(SELECT t2.prod, t2.q1_max, sales.date
	FROM t2, sales
	WHERE t2.prod = sales.prod and t2.q1_max = sales.quant and sales.month >= 1 and sales.month <= 3),
t3 AS
	(SELECT t1.prod, max(t1.max_q) q2_max
	FROM sales, t1
	WHERE t1.month >= 4 and t1.month <= 6 and t1.prod = sales.prod and t1.day = sales.day and t1.month = sales.month
	GROUP BY t1.prod),
t3sub AS
	(SELECT t3.prod, t3.q2_max, sales.date
	FROM t3, sales
	WHERE t3.prod = sales.prod and t3.q2_max = sales.quant and sales.month >= 4 and sales.month <= 6),
t4 AS
	(SELECT t1.prod, max(t1.max_q) q3_max
	FROM sales, t1
	WHERE t1.month >= 7 and t1.month <= 9 and t1.prod = sales.prod and t1.day = sales.day and t1.month = sales.month
	GROUP BY t1.prod),
t4sub AS
	(SELECT t4.prod, t4.q3_max, sales.date
	FROM t4, sales
	WHERE t4.prod = sales.prod and t4.q3_max = sales.quant and sales.month >= 7 and sales.month <= 9),
t5 AS
	(SELECT t1.prod, max(t1.max_q) q4_max
	FROM sales, t1
	WHERE t1.month >= 10 and t1.month <= 12 and t1.prod = sales.prod and t1.day = sales.day and t1.month = sales.month
	GROUP BY t1.prod),
t5sub AS
	(SELECT t5.prod, t5.q4_max, sales.date
	FROM t5, sales
	WHERE t5.prod = sales.prod and t5.q4_max = sales.quant and sales.month >= 10 and sales.month <= 12)
SELECT t2sub.prod product, t2sub.q1_max, t2sub.date, t3sub.q2_max,
t3sub.date, t4sub.q3_max, t4sub.date, t5sub.q4_max, t5sub.date
FROM t2sub
JOIN t3sub ON t2sub.prod = t3sub.prod
JOIN t4sub ON t2sub.prod = t4sub.prod
JOIN t5sub ON t2sub.prod = t5sub.prod
ORDER BY 1 */