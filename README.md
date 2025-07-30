# 🧠 RetailDB SQL Analytics Project

This project demonstrates end-to-end SQL analytics using a retail dataset (`RetailDB`). It includes real-world, interview-level SQL problems categorized by difficulty—from basic aggregations to advanced KPIs and window functions.

---

## 📦 Dataset Overview

The project uses a fictional yet realistic retail database with the following tables:

| Table Name     | Description                              |
|----------------|------------------------------------------|
| `customers`    | Customer details with segment info       |
| `orders`       | Order headers (order_id, customer, date) |
| `order_items`  | Order-level sales, quantity, discount    |
| `products`     | Product details, category, profit        |
| `regions`      | Mapping between orders and regions       |

All tables are available in the [`/dataset/`](./dataset) folder.

---

## 🎯 Objective

To build a portfolio-ready SQL project covering:

- Joins, Aggregations, Window Functions
- KPIs like CLV, AOV, Profit Margin
- Time-based Analysis (MoM, YoY, Weekly)
- Business Insight Generation (churn, funnel, profit flags)
- Resume-boosting advanced SQL scenarios

---

## 🧠 Problem Levels Breakdown

### 🔹 Level 1 – Basic (Foundational)
- Unique customer segments
- Orders per customer
- Total sales per region
- Zero-profit products
- Orders in January 2024

### 🔹 Level 2 – Intermediate (Joins + Aggregation)
- Top 5 products by sales
- Sales & quantity per category
- Average discount per sub-category
- Customers who bought >5 unique products
- Region with highest profit

### 🔹 Level 3 – Advanced SQL
- Rank products by sales per category
- Running total sales by month
- Top customer by sales per region
- Monthly trend by category
- Profit margin classification using `CASE`

### 🔹 Level 4 – Resume Boosters (Complex Queries)
- Identify churned customers (inactive for 3 months)
- Year-over-year (YoY) sales growth
- Top 3 most discounted products per category
- Sales funnel: Segment-wise performance
- Orders with negative profit

### 🔹 Level 5 – Business KPIs & Analysis
- Customer Lifetime Value (CLV)
- Pareto analysis (top 20% products)
- Seasonal product detection
- Sales vs. Profit trend
- Categories with rising profit but falling sales

### 🔹 Level 6 – Expert-Level (CTEs, Views, Subqueries)
- CTE: Customers with multiple weekly orders
- View: Monthly category-wise sales report
- Average time between two purchases
- Segment-wise discount comparison
- Cohort analysis by first purchase month

---

## 🚀 Skills Demonstrated

- 📌 Advanced SQL: Joins, CTEs, Subqueries, Views
- 📈 Data Aggregation and Time Analysis
- 🧩 KPIs: CLV, AOV, Profitability
- 🧠 Interview-Ready SQL Thinking
- 🗃️ Relational Data Modeling

---

## 💡 How to Use

1. Clone the repo or download as ZIP.
2. Import CSV files from `/dataset/` into MySQL/PostgreSQL.
3. Run SQL queries in the `/queries/` folder by level.
4. Reuse or extend queries for your own analysis.

---

## 📫 Connect With Me

- 💼 [LinkedIn](https://linkedin.com/in/your-profile)
- 📊 [GitHub](https://github.com/your-username)
- 📧 Email: your.email@example.com

---

## ⭐ Star This Repo

If you found this project useful, please consider giving it a ⭐ on GitHub—it really helps!

