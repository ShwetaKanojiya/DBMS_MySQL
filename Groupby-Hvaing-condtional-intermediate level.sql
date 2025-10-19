/*QUESTION 1: Employee Order Count by Year
Business Scenario: Count how many orders each employee handled per year.
Requirements: Show employee order counts for each year (1997-1998). Include only employees
 who processed more than 10 orders per year. 
Categorize employees as 'High Volume' (>30 orders), 'Medium Volume' (15-30 orders), or 'Low Volume' (<15 orders).
Expected Output: employee_id, order_year, total_orders, avg_freight, employee_category
*/
use northwind;
show tables;
select * from employees;
select * from products;
select * from orders;
select * from customers;

select o.employee_id,year(o.order_date) as order_year,count(o.order_id) as total_orders,avg(o.freight) as avg_freight,
case
when count(o.order_id)>30 then 'High Volume'
when count(o.order_id) between 15 and 30 then 'Medium Volume'
else 'Low Volume'
end as employee_category from orders o where year(o.order_date) between 1997 and 1998 group by o.employee_id,year(o.order_date) having count(o.order_id)>10;

/*QUESTION 2: Customer Orders by Month
Business Scenario: Analyze customer ordering patterns by month.
Requirements: Show customer order counts by month for 1997. Include only customers with more than 2 orders per month and average freight above $15. 
Classify months as 'High Season' (Dec-Feb), 'Medium Season' (Mar-May, Sep-Nov), or 'Low Season' (Jun-Aug).
Expected Output: customer_id, order_month, month_name, total_orders, avg_freight, season_type
*/
select * from orders where monthname(order_date) between 'March' and 'may' or monthname(order_date)  between 'september' and 'November';
desc orders;
desc products;

select * from products;
select case 
when monthname(order_date)>='December' and  monthname(order_date)<='february' then 'High Season'
when monthname(order_date)  between 'March' and 'may' or monthname(order_date)  between 'september' and 'November' then'Medium Season'
else 'Low Season'
end as season_type,customer_id, month(order_date) as order_month, monthname(order_date) as month_name,sum(order_id) as total_orders, 
avg(freight)as avg_freight from orders group by season_type,customer_id,order_month,month_name;



/*QUESTION 3: Product Sales by Category and Year
Business Scenario: Count product sales by category each year.
Requirements: Count how many times products from each category were ordered in 1997-1998. 
Include only categories with more than 20 total orders and average unit price above $10. Categorize years as 'Year 1997' or 'Year 1998'.
Expected Output: category_id, order_year, times_ordered, avg_unit_price, total_quantity, year_label
*/
select case
when count(o.order_id)>20 then 'Year 1997'
when avg(p.unit_price)>10 then 'Year 1998'
end as year_label,p.category_id,year(o.order_date)as order_year,count(p.reorder_level)as times_ordered,avg(p.unit_price)as avg_unit_price,
count(p.quantity_per_unit)as total_quantity from orders o join products p on o.order_id=p.category_id group by o.order_date,p.category_id;

/*QUESTION 4: Monthly Freight Cost Analysis
Business Scenario: Analyze monthly shipping costs.
Requirements: Calculate total and average freight costs by month for 1997. Include only months with more than 15 orders 
and total freight above $500. Classify freight levels as 'High Cost' (avg >$25), 'Medium Cost' ($15-25), or 'Low Cost' (<$15).
Expected Output: order_month, month_name, total_orders, total_freight, avg_freight, cost_category
*/
select case
when avg(freight)>25 then 'High Cost'
when avg(freight) between 15 and 25 then 'Medium Cost'
when avg(freight)<15 then 'Low Cost'
end as cost_category,month(order_date)as order_month,monthname(order_date)as month_name,sum(order_id)as total_orders,
sum(freight)as total_freight,avg(freight)as avg_freight from orders group by order_month,month_name;


/*QUESTION 6: Seasonal Product Performance
Business Scenario: Analyze product performance by seasons.
Requirements: Group product sales by seasons (Spring: Mar-May, Summer: Jun-Aug, Fall: Sep-Nov, Winter: Dec-Feb) for 1997. 
Include only products sold more than 5 times per season with average quantity above 10. Categorize seasons as 'Peak Season' or 'Normal Season' based on total sales.
Expected Output: product_id, season, times_sold, total_quantity, avg_quantity, avg_price, season_type
*/
use northwind;
desc customers;
/*QUESTION 5: Weekend vs Weekday Orders
Business Scenario: Compare weekend and weekday ordering patterns.
Requirements: Group orders by day type (Weekend/Weekday) for each employee in 1997.
 Include only employees with more than 20 total orders and who processed at least 3 weekend orders. 
 Show whether each employee is 'Weekend Active' or 'Weekday Focused'.
Expected Output: employee_id, day_type, order_count, avg_freight, weekend_orders, activity_type
*/
select case 
when count(order_id)>1 or dayname(order_date) between 'friday' and 'sunday' then 'Weekend Active'
when dayname(order_date) between 'monday' and 'thrusday' then'Weekday Focused'
end as activity_type,employee_id,dayname(order_date) as day_type,count(order_id)as order_count,avg(freight)as avg_freight 
from orders group by employee_id,day_type,order_date;

/*QUESTION 7: Customer Country Analysis
Business Scenario: Analyze customer distribution by country.
Requirements: Count customers and their orders by country for 1997-1998. Include only countries with more than 3 customers and average freight above $12.
Classify countries as 'Major Market' (>5 customers), 'Growing Market' (3-5 customers), or 'Small Market' (<3 customers).
Expected Output: country, customer_count, total_orders, avg_freight, market_type
*/
desc orders;
select case
when count(c.customer_id)>5 then 'Major Market'
when count(c.customer_id) between 3 and 5 then 'Growing Market'
when count(c.customer_id)<3 then 'Small Market'
end as market_type,country,count(c.customer_id) as customer_count,sum(order_id)as total_orders,avg(freight)as 
avg_freight from customers c join orders o on c.customer_id=o.customer_id group by country;

/*QUESTION 8: Quarterly Sales Summary
Business Scenario: Create quarterly sales reports.
Requirements: Summarize orders by quarters for 1997. Include only quarters with more than 40 orders and average freight between $10-50. 
Label quarters as 'Q1', 'Q2', 'Q3', 'Q4' and classify as 'Strong Quarter' (>60 orders) or 'Average Quarter' (40-60 orders).
Expected Output: quarter_number, quarter_name, total_orders, unique_customers, avg_freight, quarter_performance
*/
select case 
-- when count(order_id)>40 and avg(freight) between 10 and 50 
when count(order_id)>60 then 'Strong Quarter'
when count(order_id) between 40 and 60 then 'Average Quarter'
end as aquarter_performance,quarter_number,quarter_name,sum(order_id)as total_orders,order_id as unique_customers,avg(freight)as avg_freight;