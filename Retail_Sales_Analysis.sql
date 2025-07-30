-- Level 1 – Basic (Foundational)
-- Problem 1: List all unique customer segments.
SELECT DISTINCT SEGMENT
FROM CUSTOMERS;

-- Problem 2: Count total orders placed by each customer.
select c.customer_name , count(order_id) as Total_orders
from orders join customers c on orders.customer_id=c.customer_id
group by c.customer_name;

--  Problem 3: Find the total sales per region.
select r.region_name,sum(ot.sales) as Total_sales
from orders join order_items ot on orders.order_id=ot.order_id
join regions r on r.region_id=orders.region_id
group by r.region_name
order by Total_sales desc;

-- Problem 4: Get the list of products with zero profit.
select product_id,product_name,profit
from products
where profit =0;

-- Problem 5: Find all orders placed in January 2024.
select order_id,date_format(order_date,"%M-%Y") as Month_Year
from orders
where date_format(order_date,"%M-%Y") = 'January-2024';

-- Level 2 – Intermediate (Joins + Aggregation)
-- Problem 6: Find top 5 products by total sales.
select p.product_name,sum(sales) as Total_sales
from order_items join products p on p.product_id=order_items.product_id
group by p.product_name
order by Total_sales desc
limit 5;

-- Problem 7: Show total quantity and sales per category
select p.category,sum(ot.quantity) as Total_quantity,sum(ot.sales) as Total_sales
from order_items ot join products p on p.product_id = ot.product_id
group by p.category
order by total_sales desc;

--  Problem 8: Calculate average discount per sub-category
select p.sub_category,avg(ot.discount) as Average_Discount
from order_items ot join products p on p.product_id=ot.product_id
group by p.sub_category;

-- Problem 9: Find customers who purchased more than 5 unique products.
select c.customer_name,count(distinct ot.product_id) as Unique_products
from orders join order_items ot on ot.order_id=orders.order_id
join customers c on c.customer_id=orders.customer_id
group by c.customer_name
HAVING Unique_products > 5
order by unique_products desc;

--  Problem 10: Identify the region with the highest total profit
select r.region_name,sum(p.profit) as Total_profit
from orders join order_items ot on ot.order_id=orders.order_id
join products p on p.product_id=ot.product_id
join regions r on r.region_id=orders.region_id
group by r.region_name
order by total_profit desc
limit 1;

-- Level 3 – Advanced SQL
-- Problem 11: Use window functions to rank products by sales within each category.
select 	p.category,
		p.product_name,
		sum(ot.sales) as Total_sales,
        row_number() over(partition by p.category order by sum(ot.sales) desc) as sales_rank
from order_items ot join orders on orders.order_id=ot.order_id
join products p on p.product_id=ot.product_id
group by p.product_name,p.category;

-- Problem 12: Running total of sales by month.
with cte as(select 	date_format(order_date,'%m-%Y') as monthYear,
			sum(ot.sales) as Total_sales
			from orders join order_items ot on ot.order_id=orders.order_id
			group by monthYear)
select *,
		sum(total_sales) over(order by monthYear) as running_total_sales
from cte;

-- Problem 13: Get the top customer per region by total sales.
with cte as(
select 	r.region_name,
		c.customer_name,
		sum(ot.sales) as Total_sales,
        row_number() over(partition by r.region_name order by sum(ot.sales) desc) as sales_rank
from order_items ot join orders on orders.order_id=ot.order_id
join customers c on c.customer_id=orders.customer_id
join regions r on r.region_id=orders.region_id
group by r.region_name,c.customer_name)
select *
from cte
where sales_rank=1;

-- Problem 14: Create a monthly sales trend per product category
select 	p.category,
		date_format(order_date,'%Y-%m') as  Monthly,
		sum(ot.sales) Total_sales
from orders join order_items ot on ot.order_id=orders.order_id
join products p on p.product_id=ot.product_id
group by p.category,Monthly
order by monthly;

-- Problem (15): Use CASE to classify products by profit margin
with cte as(
	select 	p.product_name,
			round((p.profit/sum(ot.sales))*100,2) as profit_margin
	from orders join order_items ot on ot.order_id=orders.order_id
	join products p on p.product_id=ot.product_id
	GROUP BY p.product_name, p.profit)
    select 	product_name,
			profit_margin,
			case
				when profit_margin < 10 then 'Low'
                when profit_margin between 10 and 30 then 'Medium'
                else 'High'
			end as 	margin_category
    from cte
    order by profit_margin;
    
-- Level 4 problems
-- Problem 16: Identify churned customers (no orders in the last 3 months)
WITH last_order_per_customer AS (
  SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
  FROM orders o
  JOIN customers c ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.customer_name
),
latest_date AS (
  SELECT MAX(order_date) AS max_order_date FROM orders
)
SELECT
  l.customer_id,
  l.customer_name,
  l.last_order_date,
  'Churned' AS status
FROM last_order_per_customer l
JOIN latest_date d ON 1=1
WHERE l.last_order_date < d.max_order_date - INTERVAL 3 MONTH;

-- Problem 16: Identify Churned Customers
WITH last_order_per_customer AS (
  SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  GROUP BY c.customer_id, c.customer_name
)
SELECT
  customer_id,
  customer_name,
  last_order_date,
  'Churned' AS status
FROM last_order_per_customer
WHERE last_order_date < CURDATE() - INTERVAL 3 MONTH;

-- Problem 17: Calculate Year-over-Year (YoY) Growth in Sales.
WITH yearly_sales AS (
    SELECT 
        YEAR(order_date) AS year,
        SUM(ot.sales) AS total_sales
    FROM orders o
    JOIN order_items ot ON o.order_id = ot.order_id
    GROUP BY YEAR(order_date)
),
yoy_calc AS (
    SELECT 
        year,
        total_sales AS current_year_sales,
        LAG(total_sales) OVER (ORDER BY year) AS prev_year_sales
    FROM yearly_sales
)
SELECT 
    year,
    current_year_sales,
    prev_year_sales,
    ROUND(((current_year_sales - prev_year_sales) / prev_year_sales) * 100, 2) AS yoy_growth_percent
FROM yoy_calc
WHERE prev_year_sales IS NOT NULL;

-- Problem 18: Top 3 Most Discounted Products per Category.
with cte as (
select 	p.category,
		p.product_name,
        max(ot.discount) as Most_discount
from orders join order_items ot on ot.order_id=orders.order_id
join products p on p.product_id=ot.product_id
group by p.category,p.product_name
order by most_discount desc),
rk as(
select 	*,
		row_number() over(partition by category order by most_discount desc) as ranks
from cte)
select * from rk 
WHERE ranks <= 3
ORDER BY category, ranks;

-- Problem 19: Build a Sales Funnel by Customer Segment
select 	c.segment,
		count(distinct o.order_id) as Total_orders,
		sum(ot.quantity) as Total_quantity_sold,
        sum(ot.sales) as Total_sales,
        sum(p.profit) as Total_profit
from orders o join customers c on o.customer_id=c.customer_id
join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by c.segment;

-- Problem 20: Flag Orders That Had Negative Profit
select 	o.order_id,
		sum(p.profit) as Total_profit,
        case
			when sum(p.profit) < 0 then 'Negative profit'
            else 'Positive Profit'
		end as Flag
from orders o join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by o.order_id;

-- Level 5 – Business KPIs & Analysis (Real-World Focus)
-- Problem 21: Calculate Customer Lifetime Value (CLV)
select 	c.customer_name,
		count(distinct o.order_id) as Total_orders,
        sum(ot.sales) as Total_sales,
        sum(p.profit) as Total_profit,
        round((sum(p.profit)/count(distinct o.order_id)),2) as AOV,
        sum(p.profit) as CLV
from orders o join customers c on o.customer_id=c.customer_id
join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by c.customer_name;

-- Problem 22: Analyze Sales Contribution of Top 20% Products (Pareto Rule)
with all_Total_sales as(
select sum(sales) as all_total_sales
from order_items),
prod_sales as(
select 	p.product_name,
        sum(ot.sales) as Total_sales,
        row_number() over(order by sum(ot.sales) desc ) as sales_rank,
        COUNT(*) OVER () AS total_products
from orders o join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by p.product_name),
sales_contribution as(
select 	*,
		ROUND((ps.total_sales / ats.all_total_sales) * 100, 2) AS sales_contribution_pct
from prod_sales ps, all_total_sales ats),
top_20_products AS (
    SELECT *
    FROM sales_contribution
    WHERE sales_rank <= CEIL(total_products * 0.2)
)
SELECT *
FROM top_20_products -- means Top 2 sales
ORDER BY sales_rank;

-- Problem 23: Identify Seasonal Products
with monthly_sales as(
select 	p.product_id,
		p.product_name,
		date_format(order_date,'%Y-%m') as sales_month,
        sum(ot.sales) as monthly_sales
from orders o 
join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by sales_month,p.product_name,p.product_id),
avg_sales_per_product AS (
    SELECT  
        product_id,
        AVG(monthly_sales) AS avg_monthly_sales
    FROM monthly_sales
    GROUP BY product_id
    ),
    seasonal_spikes AS (
    SELECT  
        ms.product_name,
        ms.sales_month,
        ms.monthly_sales,
        asp.avg_monthly_sales,
        ROUND((ms.monthly_sales / asp.avg_monthly_sales), 2) AS sales_ratio
    FROM monthly_sales ms
    JOIN avg_sales_per_product asp ON ms.product_id = asp.product_id
    WHERE ms.monthly_sales > 1.5 * asp.avg_monthly_sales
    )
    SELECT *
FROM seasonal_spikes
ORDER BY product_name, sales_month;


--  Task 24 – Compare Sales vs. Profit Trends
select 	date_format(order_date,'%Y-%m') as sales_month,
		sum(ot.sales) as Total_sales,
        sum(p.profit) as Total_profit
from orders o 
join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by sales_month;


-- Task 25 – Find Product Categories with Increasing Profit but Decreasing Sales
with cte as(
select	 p.category,
		date_format(order_date,'%Y-%m') as sales_month,
        sum(ot.sales) as Total_sales,
        sum(p.profit) as Total_profit
from orders o 
join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by sales_month,p.category),
mom as(
select *,
		LAG(total_sales) OVER (PARTITION BY category ORDER BY sales_month) AS prev_month_sales,
        LAG(total_profit) OVER (PARTITION BY category ORDER BY sales_month) AS prev_month_profit
    FROM cte)
select *
from mom
where total_sales < prev_month_sales and total_profit > prev_month_profit;


-- Task 26 – Write a CTE to Filter Customers with Multiple Orders in the Same Week
select 	c.customer_id,
		week(order_date) as weekly,
		year(order_date) as yearly,
        count(order_id) Total_orders
from orders join customers c on c.customer_id=orders.customer_id
group by c.customer_id,weekly,yearly
having Total_orders > 1;

-- Task 27 – Create a View for Monthly Category-wise Sales Report
create view Sales_Report as
select	 p.category,
		date_format(order_date,'%Y-%m') as sales_month,
        sum(ot.quantity) as total_quantity_sold,
        sum(ot.sales) as Total_sales,
        sum(p.profit) as Total_profit
from orders o 
join order_items ot on ot.order_id=o.order_id
join products p on p.product_id=ot.product_id
group by sales_month,p.category;

--  Task 28: Average time between two purchases per customer?
WITH purchase_dates AS(
select c.customer_name,
		order_date,
        LAG(order_date) OVER(PARTITION BY c.customer_id ORDER BY order_date) AS previous_order_date
from orders join customers c on c.customer_id=orders.customer_id
),
diffs AS (
    SELECT 
        customer_name,order_date,previous_order_date,
        DATEDIFF(order_date, previous_order_date) AS days_between_orders
    FROM purchase_dates
    WHERE previous_order_date IS NOT NULL
)
SELECT 
    customer_name,order_date,previous_order_date,days_between_orders,
    ROUND(AVG(days_between_orders), 2) AS avg_days_between_orders
FROM diffs
GROUP BY customer_name,order_date,previous_order_date,days_between_orders
ORDER BY avg_days_between_orders DESC;


-- Task 29: Compare average discount between customer segments
SELECT 
    c.segment,
    ROUND(AVG(ot.discount), 2) AS avg_discount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items ot ON o.order_id = ot.order_id
GROUP BY c.segment
ORDER BY avg_discount DESC;

-- Task 30: Cohort Analysis Table by First Purchase Month
WITH first_order_month AS (
    SELECT 
        c.customer_id,
        MIN(DATE_FORMAT(order_date, '%Y-%m')) AS cohort_month
    FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items ot ON o.order_id = ot.order_id
GROUP BY c.customer_id
),
customer_orders AS (
    SELECT 
        c.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        f.cohort_month
    FROM orders o join customers c on c.customer_id=o.customer_id
    JOIN first_order_month f ON o.customer_id = f.customer_id
),
cohort_summary AS (
    SELECT 
        cohort_month,
        order_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM customer_orders
    GROUP BY cohort_month, order_month
    ORDER BY cohort_month, order_month
)
SELECT *
FROM cohort_summary;
