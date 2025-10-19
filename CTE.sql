-- ------------------------------------CTE-----------------------------------------------------------
create database CTE_prac;
use CTE_prac;
create table print(msg varchar(700));
with print as(select "hello wlc to PG_DBDA"as wlc_note)
select wlc_note from print;

use hr;
-- emps earning more than avg(salary) of their dept, display department_name,avg(salary),dept_id
with avg_count as(
select department_id,avg(salary)as dept_avg from employees group by department_id
)
select first_name,salary,dept_avg,c.department_id from employees e join avg_count c on e.department_id=c.department_id
where e.salary>=dept_avg;


-- find dept where number of emps are zero
with emp_dept as(
select distinct department_id from employees where department_id is not null)
select d.department_id,d.department_name from departments d left join emp_dept e on e.department_id=d.department_id where e.department_id is null;


select distinct department_id,count(*)as e_c from employees where department_id is not null group by department_id;

-- num of dept working in each dept,count in each dept including 0 emp in dept
with emp_count as(
select distinct department_id,count(*)as e_c from employees e where department_id is not null group by department_id)
select d.department_id,department_name,coalesce(e.e_c,0) as num_emp from departments d left join emp_count ee on e.department_id=d.department_id
order by num_emp;

select * from departments;
-- find the dept where there is no manager assign
select first_name,last_name from employees where manager_id and department_id in(select department_id from departments where manager_id);
with dept_m as(
select distinct manager_id,count(*)as e_c from employees e where manager_id is not null group by manager_id)
select d.manager_id,coalesce(e.e_c,0) as num_emp from departments d left join dept_m on e.department_id=d.department_id;


with emp_dept as(
select employee_id,department_id,salary from employees),r_map as(
select d.department_id,d.department_name,l.city,c.country_name,trim(replace(r.region_name,'\r','')) as region_name from departments d join locations l on
d.location_id=l.location_id join country_new c on c.country_id=l.country_id join regions r on r.region_id=c.region_id),dept_co as
(select department_id,count(*)as no_of_emp from emp_dept group by department_id)
select employee_id,d.deparment_id,r.city,region_name,d.no_of_emp from emp_dept join r_map r on r.department_id=e.department_id;


desc jobs;
desc regions;
desc country_new;
-- jobid,job title,count(jobid),regionname
with emp_depttt as(
select job_id,job_title,count(job_id) from jobs),r_name as(
select j.job_id,j.job_title,c.region_id from jobs j join country_new c on j.region_id=c.region_id),reg as
(select region_name from regions r join country_new c on r.region_id=c.country_id)
select job_id,job_title,count(job_id) from emp_depttt join reg re on r.region_id=re.region_id;


with emp_details as(select e.employee_ide.salary,e.job_id,trim(replace(r.r_name,'/r',''))as region_name from employees join departments d
on d.department_id,l.location_id left join country_new c on c.country_id=l.country_id right join regions r on r.region_id=c.region_id),
job_detail as(select j.job_id,j.job_title,count(*) as num_of from employees e right join jobs j on e.job_id=j.job_id group by job_id)
select j.job_id,j.job_title,j.num_of,e.region_name from emp_detail e right join job_detail j on e.job_id=j.job_id;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
with print as (select "hello wlc to PG_DBDA" as wlc_note)
select wlc_note from print;


-- Employees earning more than avg(salary) of their dept
with avg_count as (
    select department_id, avg(salary) as dept_avg
    from employees
    group by department_id
)
select e.first_name, e.salary, c.dept_avg, e.department_id
from employees e
join avg_count c on e.department_id = c.department_id
where e.salary >= c.dept_avg;

-- Departments with zero employees
with emp_dept as (
    select distinct department_id
    from employees
    where department_id is not null
)
select d.department_id, d.department_name
from departments d
left join emp_dept e on d.department_id = e.department_id
where e.department_id is null;

-- Employee count in each dept including 0
with emp_count as (
    select department_id, count(*) as e_c
    from employees
    where department_id is not null
    group by department_id
)
select d.department_id, d.department_name, coalesce(e.e_c,0) as num_emp
from departments d
left join emp_count e on d.department_id = e.department_id
order by num_emp;

-- Departments with no manager assigned
select department_id, department_name
from departments
where manager_id = 0 or manager_id is null;

-- Manager-wise employee count (including depts without employees)
with dept_m as (
    select manager_id, count(*) as e_c
    from employees
    where manager_id is not null
    group by manager_id
)
select d.manager_id, coalesce(dm.e_c,0) as num_emp
from departments d
left join dept_m dm on d.manager_id = dm.manager_id;

-- Employee + Dept + City + Region mapping
with emp_dept as (
    select employee_id, department_id, salary
    from employees
),
r_map as (
    select d.department_id, d.department_name, l.city, c.country_name, 
           trim(replace(r.region_name,'\r','')) as region_name
    from departments d
    join locations l on d.location_id = l.location_id
    join countries c on c.country_id = l.country_id
    join regions r on r.region_id = c.region_id
),
dept_co as (
    select department_id, count(*) as no_of_emp
    from employees
    group by department_id
)
select e.employee_id, e.department_id, r.city, r.region_name, dc.no_of_emp
from emp_dept e
join r_map r on e.department_id = r.department_id
join dept_co dc on e.department_id = dc.department_id;

-- Employee details with region + job count
with emp_detail as (
    select e.employee_id, e.salary, e.job_id, trim(replace(r.region_name,'\r','')) as region_name
    from employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
    join regions r on c.region_id = r.region_id
),
job_detail as (
    select j.job_id, j.job_title, count(e.employee_id) as num_of
    from jobs j
    left join employees e on e.job_id = j.job_id
    group by j.job_id, j.job_title
)
select j.job_id, j.job_title, j.num_of, e.region_name
from job_detail j
left join emp_detail e on j.job_id = e.job_id;