-- ------------------------------------------CTE AASIGN ON HR---------------------------------------
/*1) Hello, Employees (staging CTE)
Task: Build a CTE that returns EMPLOYEE_ID, full_name, JOB_ID, DEPARTMENT_ID, SALARY.
 Output: employee_id, full_name, job_id, department_id, salary.
 Hint: CONCAT(COALESCE(FIRST_NAME,''),' ',LAST_NAME).*/
use hr;
with Hello as(select employee_id,concat(first_name,' ',last_name)as full_name, job_id, department_id, salary from employees)
select  employee_id,full_name,job_id,department_id,salary from Hello;

/*2) Department Headcount (include 0)
Task: CTE with employees grouped by DEPARTMENT_ID. Left-join to departments to show all departments.
 Output: department_id, department_name, headcount.
 Hint: COALESCE(headcount,0).*/
 with Department_Headcount as(select d.department_id,d.department_name,COALESCE(count(e.employee_id),0) as headcount 
 from departments d left join employees e on e.department_id=d.department_id group by d.department_id,d.department_name)
 select department_id,department_name,headcount from Department_Headcount;

/*3) Avg Salary by Job
Task: CTE aggregates average salary per JOB_ID; join to jobs for titles.
 Output: job_id, job_title, emp_count, avg_salary.
 Hint: ROUND(AVG(SALARY),2).
*/
with Avg_Salary_by_Job as(select j.job_id,j.job_title,count(e.employee_id)as emp_count,ROUND(AVG(e.SALARY),2) as avg_salary 
from employees e join jobs j on e.job_id=j.job_id group by j.job_id,j.job_title)
select job_id,job_title, emp_count, avg_salary from Avg_Salary_by_Job;

/*4) Employee → Manager (1 hop)
Task: Stage employees in a CTE; self-join to get direct manager name.
 Output: employee_id, employee_name, manager_id, manager_name.
 Hint: Left join; top boss may have MANAGER_ID = 0 or NULL.*/
 with Employee_Manager as(select e.employee_id,concat(e.first_name,' ',e.last_name)as employee_name,m.manager_id,concat(m.first_name,' ',m.last_name)as manager_name 
 from employees e join employees m on e.employee_id=m.employee_id)
 select employee_id, employee_name, manager_id, manager_name from Employee_Manager;
 
 
/*5) Employees Without a Department
Task: Use a CTE to list employees where DEPARTMENT_ID IS NULL OR DEPARTMENT_ID=0.
 Output: employee_id, full_name, job_id, department_id.*/
 with Employees_Without_Department as(select employee_id,concat(first_name,' ',last_name)as full_name,job_id,department_id from employees where
 department_id is null or department_id=0)
 select employee_id, full_name, job_id, department_id from Employees_Without_Department;

/*6) Departments Without Employees
Task: Distinct DEPARTMENT_ID from employees in a CTE; anti-join to departments.
 Output: department_id, department_name.
*/
with Departments_Without_Employees as(select distinct e.department_id from employees e where department_id is null or e.department_id<>0)
select d.department_id, d.department_name from departments d left join
 Departments_Without_Employees dwe on d.department_id=dwe.department_id where dwe.department_id is null;

/*7) Map Employees to Region (clean text)
Task: CTE joins employees → departments → locations → countries → regions and trims REGION_NAME.
 Output: employee_id, full_name, department_name, city, country_name, region_name.
 Hint: TRIM(REPLACE(REGION_NAME,'\r','')).
*/
desc locations;
desc regions;
desc departments;
desc jobs;
with Map_Employees_to_Region as(Select e.employee_id,concat(first_name,' ',last_name)as full_name,
d.department_name,l.city,c.country_name,TRIM(REPLACE(r.region_name, '\r', '')) as region_name
from employees e join departments d on e.department_id=d.department_id 
join locations l on d.location_id=l.location_id 
join countries c on l.country_id=c.country_id
join regions r on c.region_id=r.region_id)
select employee_id, full_name, department_name, city, country_name, region_name from Map_Employees_to_Region;

/*8) Simple Pay-Band Check
Task: CTE joins employees to jobs; return rows where salary < min_salary OR salary > max_salary.
 Output: employee_id, full_name, job_title, salary, min_salary, max_salary.*/
 with Pay_Band_Check as(select e.employee_id,concat(first_name,' ',last_name)as full_name,j.job_title,e.salary,j.min_salary,j.max_salary from 
 employees e join jobs j on e.job_id=j.job_id where e.salary<j.min_salary OR e.salary>j.max_salary)
 select employee_id, full_name, job_title, salary, min_salary, max_salary from Pay_Band_Check;
 
/*9) Top Earners (overall)
Task: CTE selecting employee_id, full_name, salary, then order and limit to top 5.
 Output: employee_id, full_name, salary.
 Hint: Use the CTE just to keep the final SELECT clean.*/
 with Top_Earners as(select employee_id,concat(first_name,' ',last_name)as full_name, salary from employees order by salary desc limit 5)
 select employee_id, full_name, salary from Top_Earners;

/*10) Jobs Present in Each Department
Task: CTE groups employees by DEPARTMENT_ID, JOB_ID and counts. Join jobs for title.
 Output: department_name, job_title, employees_in_role.
*/
 with Jobs_Present_in_Each_Department as(select d.department_name,j.job_title,count(e.employee_id)as employees_in_role 
 from employees e join departments d on e.department_id=d.department_id join jobs j on e.job_id=j.job_id group by d.department_name, j.job_title)
 select department_name, job_title, employees_in_role from Jobs_Present_in_Each_Department;
 
 /*11) Headcount by Region
Task: Reuse the “map to region” idea in a CTE; then group by region.
 Output: region_name, headcount.
 Hint: Handle NULL region as “Unknown”.*/
 with Headcount_by_Region as(select r.region_name,count(e.employee_id)as headcount from employees e 
 join departments d on e.department_id=d.department_id join locations l on d.location_id=l.location_id 
 join countries c on l.country_id=c.country_id join regions r on c.region_id=r.region_id group by r.region_name)
 select region_name, headcount from Headcount_by_Region;

/*12) Commission Snapshot
Task: In a CTE, compute a flag has_commission = commission_pct > 0. Then count by flag.
 Output: has_commission, headcount.
 Optional: Break down by department as well.
*/
with Commission_Snapshot as(select case
when commission_pct>0 then 'Yes'
else 'No'
end has_commission,department_id,count(employee_id)as headcount from employees group by department_id,commission_pct)
select department_id,has_commission, headcount from Commission_Snapshot order by headcount desc; 

desc job_history;
/*13) Employees with Any Job History
Task: CTE with distinct EMPLOYEE_ID from job_history (exclude dummy row). Join to employees.
 Output: employee_id, full_name, history_row_count.
 Hint: COUNT(*) OVER (PARTITION BY EMPLOYEE_ID) or aggregate before join.*/
 with  Employees_with_Any_Job_History as(select e.employee_id,concat(first_name,' ',last_name)as full_name,count(jh.employee_id) as history_row_count 
 from employees e left join job_history jh on e.employee_id=jh.employee_id group by e.employee_id order by e.employee_id)
 select employee_id, full_name, history_row_count from Employees_with_Any_Job_History;

 -- by over partition
  with  Employees_with_Any_Job_History as(select e.employee_id,concat(first_name,' ',last_name)as full_name,
  count(*) over(partition by employee_id)as history_row_count from employees e left join job_history jh 
  on e.employee_id=jh.employee_id group by e.employee_id order by e.employee_id)
 select employee_id, full_name, history_row_count from Employees_with_Any_Job_History;

desc employees;
desc job_history;
/*14) Latest History Row (gentle)
Task: Clean job_history in a CTE (exclude zero/invalid dates) and pick the latest row per employee using ROW_NUMBER.
 Output: employee_id, last_hist_job_id, last_hist_department_id, last_hist_end_date.
 Hint: Order by END_DATE DESC, START_DATE DESC.*/
with Latest_History_Row as(select employee_id,
j.job_id as last_hist_job_id,
j.department_id as last_hist_department_id,
j.end_date as last_hist_end_date
from job_history j where j.end_date=(select max(jh.end_date) from job_history jh where jh.employee_id=j.employee_id))
select employee_id, last_hist_job_id, last_hist_department_id, last_hist_end_date from Latest_History_Row order by last_hist_end_date desc;

desc locations;
desc countries;
/*15) Locations per Country
Task: CTE groups locations by COUNTRY_ID; join to countries.
 Output: country_id, country_name, location_count.
 Hint: COALESCE(country_name,'Unknown').
*/
with Locations_per_Country as(select c.country_id,COALESCE(c.country_name,'Unknown')as country_name,count(l.location_id)as location_count
from locations l join countries c on l.country_id=c.country_id group by country_id,country_name)
select country_id, country_name, location_count from Locations_per_Country;


