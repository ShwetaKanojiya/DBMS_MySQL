create database Student;
use Student;
CREATE TABLE student_score (
  student_id SERIAL PRIMARY KEY,
  student_name VARCHAR(30),
  dep_name VARCHAR(40),
  score INT
);

INSERT INTO student_score VALUES (11, 'Ibrahim', 'Computer Science', 80);
INSERT INTO student_score VALUES (7, 'Taiwo', 'Microbiology', 76);
INSERT INTO student_score VALUES (9, 'Nurain', 'Biochemistry', 80);
INSERT INTO student_score VALUES (8, 'Joel', 'Computer Science', 90);
INSERT INTO student_score VALUES (10, 'Mustapha', 'Industrial Chemistry', 78);
INSERT INTO student_score VALUES (5, 'Muritadoh', 'Biochemistry', 85);
INSERT INTO student_score VALUES (2, 'Yusuf', 'Biochemistry', 70);
INSERT INTO student_score VALUES (3, 'Habeebah', 'Microbiology', 80);
INSERT INTO student_score VALUES (1, 'Tomiwa', 'Microbiology', 65);
INSERT INTO student_score VALUES (4, 'Gbadebo', 'Computer Science', 80);
INSERT INTO student_score VALUES (12, 'Tolu', 'Computer Science', 67);

select * from student_score;

SELECT *,MAX(score)AS maximum_score from student_score group by student_id;-- normal
SELECT *,MAX(score) OVER() AS maximum_score FROM student_score;-- using window function

SELECT *,min(score)AS minimum_score from student_score group by student_id;-- normal
SELECT *,min(score)AS minimum_score from student_score group by student_id;-- using window function

/*It adds two new columns (maximum_score and minimum_score) to the original table. The same overall max and min scores are repeated on every single row.*/
SELECT *,MAX(score) OVER() AS maximum_score,MIN(score) OVER() AS minimum_score FROM student_score;

/*It adds two new columns showing the highest score and the average score for the student's own department.
 This allows you to directly compare each student's score to their department's performance metrics on the same row.*/
SELECT *,MAX(score)OVER(PARTITION BY dep_name) AS dep_maximum_score,ROUND(AVG(score)OVER(PARTITION BY dep_name), 2) AS dep_average_score
FROM student_score;

/*get a simple, continuous serial number for every student when they are sorted by name. 
No two rows will ever have the same number, even if two students had the exact same name.*/
SELECT *,ROW_NUMBER() OVER(ORDER BY student_name) AS name_serial_number FROM student_score;

/*Ties get the same rank: If two students have the same top score in a department, they both get Rank 1.
Gaps are created: The rank following the tie is skipped. For instance, if two students tie for Rank 2, the next student will be Rank 4 (skipping Rank 3).*/
SELECT *,RANK()OVER(PARTITION BY dep_name ORDER BY score DESC) FROM student_score;

/*It ranks students by score (highest is Rank 1) only compared to others in their own department, without skipping any rank numbers.*/
SELECT *,DENSE_RANK()OVER(PARTITION BY dep_name ORDER BY score DESC)FROM student_score;

/*For every student, a new column is added showing the score of the student who had the immediately lower score in the same department.
The student with the absolute lowest score in a department will have a NULL value here, as no row precedes them.*/
SELECT *,LAG(score) OVER(PARTITION BY dep_name ORDER BY score)FROM student_score;

/*A new column (cummulative_sum) is created where the value in each row is the sum of all scores up to and including the current row, 
based on the student_id order. This is a classic running total.*/
SELECT *,SUM(score)OVER(ORDER BY student_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cummulative_sum
FROM student_score;




-- ------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------
use hr;
select first_name,department_id,salary,avg(salary) over(partition by department_id)as dept_avg from employees;

use northwind;
select product_name,category_id,unit_price,row_number() over(order by unit_price desc)as rank_price from products;

-- no of products within same category
with rank_high as(select category_id,product_name,unit_price,row_number() 
over(partition by category_id order by unit_price desc )as cat_in from products)
select cat_in as product_name,unit_price,cat_in as high_price_product from rank_high where cat_in=1;

select category_id,product_name,unit_price,row_number() 
over(partition by category_id order by unit_price desc)as cat_in_row_num,
rank()
over(partition by category_id  order by unit_price desc)as cat_by_rank,
dense_rank()
over(partition by category_id  order by unit_price desc)as cat_by_dense_rank
from products;


select e.employee_id,e.first_name,count(o.order_id) as total_order,rank() over(order by count(o.order_id)desc)as performance_rank
from employees e left join orders o on e.employee_id=o.employee_id group by e.employee_id,e.first_name order by performance_rank;


