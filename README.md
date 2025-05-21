# Zomato-Gold-Membership-SQL-Analysis-Understanding-User-Behavior-Spending-Patterns

A data analysis project using SQL to understand customer behavior, product preferences, and the impact of Zomato Gold membership based on simulated transactional data.

## Project Overview

This project dives into customer transactions, sign-up data, and gold membership information to answer key business questions using SQL. The aim is to analyze how users interact with the platform and how Gold membership affects user behavior and spending.

---

## Dataset Structure

The analysis is based on four tables:

- **users** – Basic customer information with sign-up dates.
- **goldusers_signup** – Users who opted for Zomato Gold with signup dates.
- **sales** – Transaction records of product purchases by users.
- **products** – Product catalog with pricing details.

---

##  Business Questions Solved

1. **What is the total amount each customer spent on Zomato?**

2. **How many days has each customer visited Zomato?**

3. **What was the first product purchased by each customer?**

4. **What is the most purchased item on the menu and how many times was it purchased by all customers?**

5. **Which item was most popular for each customer?**

6. **Which item was purchased first by the customer after they became a Gold member?**

7. **Which item was purchased just before the customer became a Gold member?**

8. **What is the total number of orders and amount spent by each member before they became a Gold member?**

9. **In the first year after a customer joins the Gold program (including the join date), customers earn 5 Zomato points for every ₹10 spent. Who earned more – User 1 or User 3? (1 ZP = ₹2)**

10. **Rank all transactions of the customers based on the purchase date.**

11. **For each Gold member, whenever they are a Zomato Gold member, label transactions accordingly; otherwise, mark as 'NA'.**

12. **Identify whether each sale occurred before or after the user’s Gold signup (if applicable).**
    - Label each sale as:
      - `"Before Gold"`
      - `"After Gold"`
      - `"Non-Gold User"`

---

## 🛠️ Skills Demonstrated

- SQL Joins and Filtering
- Aggregations (`SUM`, `COUNT`, `MAX`)
- Date & Time Filtering
- Window Functions (`RANK`, `ROW_NUMBER`, `PARTITION BY`)
- CASE Statements for Categorization
- Data Cleaning and Transformation

---

## 📌 How to Use

1. Clone this repo.
2. Import the SQL scripts to your SQL engine (MySQL/PostgreSQL).
3. Run the `CREATE TABLE` and `INSERT INTO` queries to set up the database.
4. Open the query files to explore the solutions to each business question.

---

##  Author

**Korrapati Jaswanth**  
Data Science Enthusiast | 23K Followers @Linkedln | Top Machine Learning & Data Analysis Voice on LinkedIn  
Bangalore, India  
Reach out via LinkedIn: [https://www.linkedin.com/in/jaswanth49b057228/]

---

## Don't forget to star this repository if you found it helpful!

