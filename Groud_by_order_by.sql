-- -----------------------------------------------GROUP BY ORDER BY ASSIGNMNT---------------------------------------
-- -----------------------------------------------------------------------------------------------------------------

select year(hire_date) as hire_year,count(employee_id) as num_emp from employees group by year(hire_date)
order by hire_year;

select department_id, job_id, count(*) as num_emp from employees group by department_id, job_id
order by num_emp desc;

select department_id, sum(salary) as total_sal from employees group by department_id
order by total_sal desc limit 1;

select count(distinct job_id) as ttl_jobs from employees;

select job_id, count(*) as job_count from employees group by job_id order by job_count desc;

select sum(salary) as total_salaries from employees;

select department_id,job_id, count(*) as num_employees,sum(salary) as total_salary from employees group by department_id, job_id;

select min(salary) as minimum_salary from employees;

select max(salary) as max_sal from employees where job_id = 'IT_PROG';

select department_id,avg(salary)as avg_salary, count(*) as num_employees from employees
where department_id=90 group by department_id;

select sum(salary) as total_salary,max(salary) as highest_salary,min(salary) as lowest_salary,avg(salary) as average_salary,
count(employee_id) as total_employees from employees;

select job_id,count(*) as num_emp from employees group by job_id;

select max(salary)-min(salary) as salary_diff from employees;

select manager_id,min(salary) as lowest_paid from employees group by manager_id order by lowest_paid;

select department_id,sum(salary) as total_salary from employees group by department_id;

select job_id,avg(salary) as avg_salary from employees where job_id!='IT_PROG' group by job_id;

select job_id, department_id,count(*) as num_employees,sum(salary) as total_salary,max(salary) as max_salary,min(salary) as min_salary,
avg(salary) as avg_salay from employees where department_id=90 group by job_id, department_id;

select job_id,max(salary) as max_salary from employees group by job_id having max_salary>=4000 order by max_salary desc;

select department_id, avg(salary) as avg_salary, count(*) as num_employees from employees group by department_id having count(*) > 10
order by num_employees;