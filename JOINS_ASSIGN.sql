
-- ----------------------------------JOINS ASSIGN----------------------------------------------
use hrr;
show tables;
select * from locations;
select * from country_new;
select * from departments;
select * from employees;
select * from regions;
select * from jobs;
select * from job_history;

-- 1. Write a query to find the addresses (location_id, street_address, city, state_province, country_name) of all the departments.
select l.location_id,l.street_address,l.city,l.state_province,c.country_name from departments d join locations l on d.location_id=l.location_id
join countries c on l.country_id=c.country_id;

-- 2. Write a query to find the name (first_name, last name), department ID and name of all the employees
select concat(first_name,' ', last_name) as name,e.department_id,d.department_name from employees e join departments d on e.department_id=d.department_id;

-- 3. Write a query to find the name (first_name, last_name), job, department ID and name of the employees who works in London.
select concat(e.first_name, ' ', e.last_name) as name,e.job_id,d.department_id,d.department_name from employees e
join departments d on e.department_id=d.department_id join locations l on d.location_id=l.location_id where l.city='London';

-- 4. Write a query to find the employee id, name (last_name) along with their manager_id and name (last_name).
select e.employee_id,e.last_name as empl_name,m.employee_id as manager_id,m.last_name as manager_name from employees e
left join employees m on e.manager_id=m.employee_id;

-- 5. Write a query to find the name (first_name, last_name) and hire date of the employees who was hired after 'Jones'.
select concat(first_name,' ', last_name) as name, hire_date from employees 
where hire_date>(select hire_date from employees where last_name = 'Jones');

-- 6. Write a query to get the department name and number of employees in the department.
select d.department_name,count(e.employee_id) from employees e join departments d on e.department_id=d.department_id group by department_name;

-- 7. Write a query to find the employee ID, job title, number of days between ending date and starting date for all jobs in department 90.
select e.employee_id,j.job_title, datediff(jh.end_date, jh.start_date) as dwork from job_history jh join employees e on jh.employee_id = e.employee_id
join jobs j on jh.job_id=j.job_id where e.department_id = 90;


-- 8. Write a query to display the department ID and name and first name of manager.
select e.department_id,d.department_name,e.first_name as manager_first_name from employees e join departments d on e.employee_id=d.manager_id;

-- 9. Write a query to display the department name, manager name, and city.
select d.department_name,concat(e.first_name,' ',e.last_name) as manager_name, l.city from departments d join employees e on d.manager_id=e.employee_id
join locations l on d.location_id=l.location_id;

-- 10. Write a query to display the job title and average salary of employees.
select j.job_title,avg(e.salary) from employees e join jobs j on e.job_id=j.job_id group by j.job_title;

-- 11. Write a query to display job title, employee name, and the difference between salary of the employee and minimum salary for the job.
select j.job_title,concat(first_name,' ',last_name) as f_name,e.salary-j.min_salary as sal_diff from employees e join
 jobs j on e.job_id=j.job_id;

-- 12. Write a query to display the job history that were done by any employee who is currently drawing more than 10000 of salary.
select j.* from job_history j join employees e on j.employee_id=e.employee_id where e.salary > 10000;

-- 13. Write a query to display department name, name (first_name, last_name), hire date, salary of the manager for all managers whose experience is more than 15 years.
select d.department_name,concat(e.first_name,' ',e.last_name) as manager_name,e.hire_date,e.salary from employees e
join departments d on e.employee_id=d.manager_id where timestampdiff(year,e.hire_date,curdate())>15;
