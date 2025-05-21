CREATE DATABASE Zomato;

USE Zomato;

CREATE TABLE goldusers_signup(
userid INT,
gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
VALUES (1,'09-22-2017'),
(3,'04-21-2017');



CREATE TABLE users(
userid INT,
signup_date date); 

INSERT INTO users(userid,signup_date) 
VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');


CREATE TABLE sales(
userid INT,
created_date date,
product_id INT); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),(2,'07-20-2020',3),
(1,'10-23-2019',2),(1,'03-19-2018',3),
(3,'12-20-2016',2),(1,'11-09-2016',1),
(1,'05-20-2016',3),(2,'09-24-2017',1),
(1,'03-11-2017',2),(1,'03-11-2016',1),
(3,'11-10-2016',1),(3,'12-07-2017',2),
(3,'12-15-2016',2),(2,'11-08-2017',2),
(2,'09-10-2018',3);

CREATE TABLE products(
product_id INT,
product_name VARCHAR(10),
price INT); 

INSERT INTO products(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

SELECT * FROM goldusers_signup;
SELECT * FROM Users;
SELECT * FROM Sales;
SELECT * FROM Products;



-- 1.what is total amount each customer spent on zomato ?

SELECT * FROM Users;
SELECT TOP 2 * FROM Sales;
SELECT * FROM products;

SELECT u.Userid, SUM(price) AS Total_Amount
FROM Users AS u
INNER JOIN Sales AS s
ON u.userid = s.userid
INNER JOIN products AS p
ON s.product_id = p.product_id
GROUP BY u.userid;

----------------------------------------------------------------------

-- 2.How many days has each customer visited zomato?

SELECT * FROM Sales;

SELECT userid, COUNT(DISTINCT Created_date) AS no_of_days 
FROM Sales 
GROUP BY userid;

-----------------------------------------------------------------

-- 3.what was the first product purchased by each customer?

SELECT * FROM Sales;
SELECT * FROM products;

With first_product_purchased AS (
SELECT userid, created_date, p.product_id, product_name,
DENSE_RANK() OVER(PARTITION BY userid ORDER BY created_date) AS rnk
FROM Sales AS s
INNER JOIN products AS p
ON s.product_id = p.product_id)

SELECT userid, created_date, product_id, product_name
FROM first_product_purchased
WHERE rnk = 1;
-------------------------------------------------------------------

-- 4.what is most purchased item on menu & how many times was it
-- purchased by all customers ?
 
 
SELECT * FROM Sales;
 

WITH cte AS (
SELECT TOP 1 product_id AS most_purchased_item , COUNT(1) AS cnt
FROM sales
GROUP BY product_id
ORDER BY cnt DESC)

SELECT userid, most_purchased_item , COUNT(1) AS cnt_of_product
FROM cte AS c
INNER JOIN sales AS s
ON c.most_purchased_item = s.product_id
GROUP BY userid, most_purchased_item;

--------------------------------------------------------------------------

-- 5.which item was most popular for each customer?

SELECT * FROM Sales;

WITH cte AS (
SELECT userid, product_id, COUNT(1) AS cnt 
FROM Sales 
GROUP BY userid, product_id),

cte_2 AS (
SELECT userid, product_id,cnt,
DENSE_RANK() OVER(PARTITION BY userid ORDER BY cnt DESC) AS rnk 
FROM cte )

SELECT userid, product_id, cnt, rnk 
FROM cte_2 
WHERE rnk = 1;

-------------------------------------------------------------------------
 
-- 6.which item was purchased first by customer after they become a member ?

SELECT * FROM goldusers_signup;
SELECT * FROM sales;

WITH cte AS (
SELECT gs.userid, gold_signup_date, created_date, product_id 
FROM goldusers_signup AS gs
INNER JOIN sales AS s 
ON gs.userid = s.userid
WHERE created_date>=gold_signup_date),

cte_2 AS (
SELECT userid, gold_signup_date, created_date, product_id,
DENSE_RANK() OVER(PARTITION BY userid ORDER BY created_date) AS rnk 
FROM cte)

SELECT userid, product_id
FROM cte_2 
WHERE rnk = 1;

-----------------------------------------------------------------------------

-- 7. which item was purchased just before the customer became a member?

SELECT * FROM goldusers_signup;
SELECT * FROM Sales;
  
WITH cte AS (
SELECT gs.userid, gold_signup_date, created_date, product_id 
FROM goldusers_signup AS gs
INNER JOIN Sales AS s
ON gs.userid = s.userid
WHERE gold_signup_date>=created_date),

cte_2 AS (
SELECT userid, gold_signup_date, created_date, product_id,
DENSE_RANK() OVER(PARTITION BY userid ORDER BY created_date DESC) AS rnk 
FROM cte)

SELECT userid, product_id
FROM cte_2 
WHERE rnk = 1;

------------------------------------------------------------

-- 8. what is total orders and amount spent for each member 
-- before they become a member?

SELECT * FROM goldusers_signup;
SELECT TOP 2 * FROM sales;
SELECT * FROM products;

SELECT gs.userid, COUNT(s.product_id) AS Total_orders,
SUM(price) AS Amount_Spent
FROM goldusers_signup AS gs 
INNER JOIN sales AS s
ON gs.userid = s.userid
INNER JOIN products AS p
ON s.product_id = p.product_id
WHERE gold_signup_date>=created_date
GROUP BY gs.userid;

--------------------------------------------------------------------

/*
9. In the first year after a customer joins the gold program
(including the join date ) irrespective of what customer has 
purchased earn 5 zomato points for every 10rs spent who earned
more more 1 or 3 what int earning in first yr ? 1zp = 2rs
*/

SELECT * FROM goldusers_signup;
SELECT Top 2 * FROM sales;
SELECT * FROM products;

WITH cte AS (
SELECT gs.userid, gold_signup_date, created_date, price 
FROM goldusers_signup AS gs
INNER JOIN sales AS s
ON gs.userid = s.userid
INNER JOIN products AS p
ON s.product_id = p.product_id
WHERE created_date BETWEEN gs.gold_signup_date AND DATEADD(DAY, 365, gs.gold_signup_date)
)
--     '2025-01-10'                    '2024-02-20'              '2025-02-20'

SELECT userid, 
CAST(SUM(price / 10.0 * 5) AS DECIMAL(10,2)) AS total_zp
FROM cte 
GROUP BY userid;

-----------------------------------------------------------

-- 10. rnk all transaction of the customers

SELECT * FROM sales;
 
SELECT userid, created_date, product_id,
DENSE_RANK() OVER(PARTITION BY userid ORDER BY created_date) AS transaction_rank
FROM sales;

------------------------------------------------------------------------

/*
11. for each member whenever they are zomato
gold member for every non gold member mark as na
*/

SELECT * FROM goldusers_signup;
SELECT * FROM sales;

WITH cte AS (
SELECT s.userid, gs.gold_signup_date,  created_date
FROM sales AS s
LEFT JOIN goldusers_signup AS gs
ON s.userid = gs.userid)

SELECT DISTINCT userid, 
CASE WHEN gold_signup_date IS NULL THEN 'NA'
ELSE 'Gold Member' END AS status
FROM cte;

----------------------------------------------------------------

/* 12.
Identify whether the sale occurred before or after the user’s gold signup (if applicable).

Output should include all sales, and label each as:

 - "Before Gold" if the sale happened before gold signup.
 - "After Gold" if after.
 - "Non-Gold User" if the user never signed up for gold.
*/

SELECT * FROM goldusers_signup;
SELECT TOP 5 * FROM sales;

SELECT s.userid, created_date, gold_signup_date, product_id,
CASE WHEN created_date>=gold_signup_date THEN 'After Gold'
WHEN gold_signup_date>=created_date THEN 'Before Gold'
ELSE 'Non Gold User' END AS Gold_Status 
FROM goldusers_signup AS gs
RIGHT JOIN Sales AS s
ON gs.userid = s.userid;

-----------------------------------------------------------------------------------------


--                  *** Key Insights from Zomato SQL Analysis **

/*
1) High-Spending Users Identified:-
  - User 1 was the top spender across all transactions, showing strong engagement with the platform.

2) Customer Loyalty Patterns:-
 - User 1 visited Zomato 7 times, while User 3 had 5 visits, indicating repeat usage and brand loyalty.

3) Popular Product Trends:-
 - Product p2 was the most purchased item across all users, suggesting it's a customer favorite.

4) Loyalty Points Earned:-
 - In the first year of Gold membership, User 3 earned more Zomato Points than User 1, 
  indicating higher engagement and value generation post-membership.

5) Transaction Timeline Ranking:-
 - Transactions were successfully ranked to identify behavioral trends over time,
  helping to predict future actions.

6) Sales Categorization Based on Membership:-
 - All sales were clearly categorized as "Before Gold", "After Gold", or "Non-Gold User", 
  enabling targeted marketing and promotions.

*/

