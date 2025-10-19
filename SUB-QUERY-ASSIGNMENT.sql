-- --------------------------------------------------------SUB-QUERY-ASSIGNMENT---------------------------------------------------
use hr;
-- 1. Write a query to find the name (first_name, last_name) and the salary of the employees who have a higher salary than the employee whose last_name='Bull'. 
select first_name, last_name,salary from employees where salary>(select salary from employees where  last_name='Bull');

-- 2. Write a query to find the name (first_name, last_name) of all employees who works in the IT department.
select first_name,last_name from employees where department_id=(select department_id from departments where department_name = 'IT');

-- 3. Write a query to find the name (first_name, last_name) of the employees who have a manager and worked in a USA based department. 
-- Hint : Write single-row and multiple-row subqueries
select first_name,last_name from employees where manager_id is not null and department_id 
in(select department_id from departments where location_id in(
select location_id from locations where country_id=(select country_id from countries where country_name='United States of America')));

-- 4. Write a query to find the name (first_name, last_name) of the employees who are managers. 
select first_name, last_name,salary from employees where employee_id in (select manager_id from employees where manager_id is not null);

-- 5. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary.
select first_name, last_name,salary from employees where salary>(select avg(salary) from employees);

-- 6. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is equal to the minimum salary for their job grade. 
select e.first_name,e.last_name,e.salary from employees e where e.salary=(select min(salary) from employees where job_id=e.job_id);

-- 7. Write a query to find the name (first_name, last_name), and salary of the employees who earns more than the average salary and works in any of the IT departments. 
select e.first_name,e.last_name,e.salary from employees e join departments d on e.department_id = d.department_id 
where e.salary>(select avg(salary) from employees where d.department_name like 'it%');

-- 8. Write a query to find the name (first_name, last_name), and salary of the employees who earns more than the earning of Mr. Bell.
select e.first_name,e.last_name,e.salary from employees e where e.salary>(select salary from employees where last_name='bell');

-- 9. Write a query to find the name (first_name, last_name), and salary of the employees who earn the
--  same salary as the minimum salary for all departments. 
select e.first_name,e.last_name,e.salary from employees e join departments d on e.department_id = d.department_id 
where e.salary=(select min(salary) from employees where e.department_id=d.department_id);
select e.first_name,e.last_name,e.salary from employees e where e.salary=(select min(salary) from employees);

-- 10. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary of all departments.
select e.first_name,e.last_name,e.salary from employees e where e.salary>(select avg(salary) from employees);

-- 11. Write a query to find the name (first_name, last_name) and salary of the employees who earn a salary that is
--  higher than the salary of all the Shipping Clerk (JOB_ID = 'SH_CLERK'). Sort the results of the salary of the lowest to highest. 
select e.first_name,e.last_name,e.salary from employees e where e.salary>(select max(salary) from employees where JOB_ID='SH_CLERK') order by e.salary;

-- 12. Write a query to find the name (first_name, last_name) of the employees who are not supervisors. 
select first_name,last_name from employees where employee_id not in(select distinct manager_id from employees where manager_id is not null);

-- 13. Write a query to display the employee ID, first name, last name, and department names of all employees. 
select employee_id,first_name,last_name from employees where department_id in(select department_name from departments);
select e.employee_id,e.first_name,e.last_name,d.department_name from employees e join departments d on e.department_id=d.department_id;

-- 14. Write a query to display the employee ID, first name, last name, salary of all employees whose salary is above average for their departments.
select e.employee_id,e.first_name,e.last_name,e.salary from employees e where e.salary>(select avg(salary) from employees where department_id = e.department_id);

-- 15. Write a query to fetch even numbered records from the employees table. 
select * from employees where employee_id%2=0;
select * from employees where mod(employee_id,2)=0;

-- 16. Write a query to find the 5th maximum salary in the employees table. 
use hr;
select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees))));

select distinct salary from employees order by salary desc limit 1 offset 4;

-- 17. Write a query to find the 4th minimum salary in the employees table. 
select min(salary) from employees where salary>
(select min(salary) from employees where salary>
(select min(salary) from employees where salary>
(select min(salary) from employees)));
select distinct salary from employees order by salary limit 1 offset 3;

-- 18. Write a query to select the last 10 records from a table. 
select * from employees where employee_id in(select employee_id from employees order by employee_id)limit 10;

-- 19. Write a query to list the department ID and name of all the departments where no employee is working. 
select d.department_id,d.department_name from departments d where d.department_id not in(select distinct e.department_id from employees e
 where e.department_id is not null);
 
-- 20. Write a query to get 3 maximum salaries. 
select distinct salary from employees e where 3>(select count(distinct salary)
from employees where salary>e.salary)order by salary desc;
select distinct salary from employees order by salary desc limit 3;
select distinct salary from employees e1 where 3>(select count(distinct salary) 
from employees e2 where e2.salary>e1.salary)order by salary desc;

-- 21. Write a query to get 3 minimum salaries.
select distinct salary from employees e where 3>(select count(distinct salary)from employees where salary<e.salary)order by salary;
select distinct salary from employees order by salary limit 3;

-- 22. Write a query to get nth max salaries of employees. 
select distinct salary from employees e where 22=(select count(distinct salary) from employees where salary>e.salary);-- (n-1)=22
select distinct salary from employees order by salary desc limit 1 offset 22;-- n-1

-- Write a query that returns all employees who have a salary greater than the average salary of their department.
select * from employees e where e.salary>(select avg(salary) from employees where department_id=e.department_id);

-- Write a query that returns the names of all departments that have more than 10 employees.
select department_name from departments d where department_id in(select department_id from employees 
group by department_id having count(employee_id)>10);

-- Write a query that returns the names of all employees who work in departments that have a total salary greater than $1,000,000.
select concat(first_name,' ',last_name) as fname from employees where department_id in
(select department_id from employees group by department_id having sum(salary)>10000000);

-- Write a query that returns the average salary of all employees who have been with the company for less than 3 years.
select avg(salary) from employees where employee_id in(select employee_id from employees 
where timestampdiff(year,hire_date,current_date)<3);

-- Write a query that returns the names of all employees who have the same manager as the employee with ID 123.
select employee_id,concat(first_name,' ',last_name) as fname from employees where employee_id
 in(select manager_id from employees group by manager_id);

-- Write a query that returns the department name and average salary of the department with the highest average salary.
-- Write a query that returns the names of all employees who have a salary greater than the highest salary in the sales department.
select concat(first_name,' ',last_name) as fname from employees where salary>(select max(salary) from employees 
where department_id=(select department_id from departments where department_name='Sales'));

-- Write a query that returns the names of all employees who have a manager with a salary greater than $100,000.
-- Write a query that returns the names of all departments that have at least one employee who has been with the company for more than 5 years
select department_name from departments where department_id in(select department_id from employees 
where hire_date<=adddate(curdate(),interval-5 year));

-- Write a query that returns the name and salary of the employee with the second-highest salary in the company.
select concat(first_name,' ',last_name) as employee_name,salary from employees where salary=(select max(salary) from employees where salary
 <(select max(salary) from employees));
 
-- ---------------------------------------------------------------------------------------------------------------
select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary)));
select distinct salary from employees order by salary desc limit 10;
select distinct salary from employees order by salary desc limit 1 offset 3;
(select salary from employees e1 where 4=(select count(salary) from employees e2 where e2.salary>e1.salary));


select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees where salary<
(select max(salary) from employees))))));
select distinct salary from employees order by salary desc limit 1 offset 6;
select distinct salary from employees e1 where 6=(select count(distinct salary) 
from employees e2 where e2.salary>e1.salary);


select distinct salary from employees e1 where 3=(select count(distinct salary) from employees e2 
where e2.salary>e1.salary);
select max(distinct salary) from employees where salary<
(select max(distinct salary) from employees where salary<
(select max(distinct salary) from employees));
select distinct salary from employees order by salary desc limit 1 offset 2;
select distinct salary from employees order by salary desc limit 4;

-- 20. Write a query to get 3 maximum salaries. 
select distinct salary from employees e1 where 3>(select count(distinct salary)
from employees e2 where e2.salary>e1.salary)order by salary desc;
select distinct salary from employees order by salary desc limit 3;

-- 21. Write a query to get 3 minimum salaries.
select distinct salary from employees e1 where 3>(select count(distinct salary)from employees e2 where e2.salary<e1.salary)
order by salary;
select distinct salary from employees order by salary limit 3;
