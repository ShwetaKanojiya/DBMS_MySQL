-- -------------------------------------------------Stored Procdeure and function Assign-----------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------
use hrr;
-- 1.	Write a stored procedure to retrieve all employees from the Employees table for a given department ID.
delimiter $$
create function get_emp_by_dept_id(emp_id int)
returns varchar(100)
deterministic
begin 
	   declare f_name varchar(100);
	   select concat(first_name,' ',last_name)into f_name from employees where employee_id=emp_id;
	   return f_name;
end;;
$$
delimiter ;
select get_emp_by_dept_id(100);

-- 2.	Create a function that calculates the total salary expenditure for a given department ID.
delimiter $$
create function get_sal_expend(dept_id int)
returns int
deterministic
begin
	declare sal int;
	select salary into sal from employees;
	return sal;
end;;
$$
delimiter ;
select get_sal_expend(100);

-- 3.	Develop a stored procedure that accepts an employee ID as an input parameter and increases the salary of that employee by a specified percentage.
delimiter $$
create procedure inc_sal(inout emp_id float,inout percent float)
deterministic
begin 
	select salary+salary*percent from employees;
end;;
$$
delimiter ;
set @emp_id=100,@percent=0.20;
call inc_sal(@emp_id,@percent);
select @emp_id as employee_id from employees;

-- 4.	Write a function to determine the average salary for employees in a specific job title category.
delimiter $$
create procedure avg_sal_emp_by_job_title(emp_title varchar(20))
deterministic
begin 
select avg(salary) as avg_sal from employees e join jobs j on e.job_id=j.job_id;
end;;
$$
delimiter ;
set @emp_title='';
call avg_sal_emp_by_job_title(@emp_title);
select @emp_title,avg_sal from employees e join jobs j on e.job_id=j.job_id;

-- 5.	Create a stored procedure that takes an employee's first name and last name as input parameters and returns the full name in uppercase letters.
delimiter $$
create procedure emp_fullName_ucase(inout f_name varchar(20),inout l_name varchar(20),out full_name varchar(40))
deterministic
begin
select first_name as f_name,last_name as l_name,upper(concat(first_name,' ',last_name))as full_name from employees;
end;;
$$
delimiter ;
set @f_name='',@l_name='';
call emp_fullName_ucase(@f_name,@l_name,@full_name);
select @f_name,@l_name,@full_name from employees;

-- 6.	Write a stored procedure to insert a new employee into the Employees table with the provided first name, last name, and department ID.
delimiter $$
create procedure insert_employee(
    in first_name varchar(50),
    in last_name varchar(50),
    in dept_id int
)
begin
    insert into employees (first_name,last_name,department_id)
    values (first_name,last_name,dept_id);
end$$
delimiter ;
call insert_employee('john','doe',10);

-- 7.	Create a function to calculate the total number of employees in a specific department.
delimiter $$
create function dept_emp_cnt(dept_id int)
returns int
deterministic
begin
    declare emp_cnt int;
    select count(*) into emp_cnt from employees where department_id = dept_id;
    return emp_cnt;
end$$
delimiter ;
select dept_emp_cnt(101);


-- 8.	Develop a stored procedure that accepts an employee ID as input and deletes that employee's record from the Employees table.
delimiter $$
create procedure delete_employee(in emp_id int)
begin
    delete from employees where employee_id = emp_id;
end$$
delimiter ;
call delete_employee(1001);

-- 9.	Write a function to determine the highest salary in the Employees table.
delimiter $$
create function max_sal_emp(emp_id int)
returns int
deterministic
begin 
select max(salary)as max_sal from employees where emp_id=employee_id;
end;
$$
delimiter ;
select max_sal_emp(111);

-- 10.	Create a stored procedure that takes a department ID as an input parameter and returns the list of employees sorted
-- by their salary in descending order within that department.
delimiter $$
create procedure dept_emp(inout dept_id int)
deterministic
begin 
end;;
$$
delimiter ;
select dept_emp();

desc jobs;
-- 11.	Write a stored procedure to update the job title of an employee based on their employee ID.
delimiter $$
create procedure update_title(in emp_id int)
begin
select j.job_title from  employees e join jobs j on e.job_id=j.job_id  where emp_id=employee_id; 
end;
$$
delimiter ;

-- 12.	Create a function that returns the number of employees hired in a specific year.
delimiter $$
create function num_of_emp(hd int)
returns int
deterministic
begin
declare emp_cnt int;
select count(*) into emp_cnt from employees where hd=year(hire_date);
end;
$$
delimiter ;

-- 13.	Develop a stored procedure that accepts an employee ID as input and retrieves the employee's details, including their name, department, and salary.
delimiter $$
create procedure emp_details(in emp_id int)
begin
select concat(first_name,' ',last_name)as name,d.department_name,e.salary from employees e join departments d on e.department_id=d.department_id where emp_id=employee_id;
end;
$$
delimiter ;

-- 14.	Write a function to calculate the average tenure (in years) of employees in the company.
delimiter $$
create function avg_tenure(emp_id int)
returns float
deterministic
begin
declare avg_sal float;
select avg(salary)into avg_sal from employees e where emp_id=employee_id;
end;;
$$
delimiter ;

-- 15.	Create a stored procedure that takes a department ID as an input parameter and returns the department name along with the count of employees in that department.
delimiter $$
create procedure dept_name(in dept_id int,out dept_name varchar(40))
begin
select department_name,department_id from departments where dept_id=department_id;
end;;
$$
delimiter ;

-- 16.	Write a stored procedure to retrieve the top N highest-paid employees in the company, where N is an input parameter.
delimiter $$
create procedure top_n_paid(in n int)
begin
    select * from employees
    order by salary desc
    limit n;
end$$
delimiter ;
call top_n_paid(5);

-- 17.	Create a function that calculates the total bonus amount for all employees based on their performance ratings.
delimiter $$
create function total_bonus()
returns decimal(10,2)
deterministic
begin
    declare total decimal(10,2);
    select sum(bonus) into total from employees;
    return total;
end$$
delimiter ;
select total_bonus();

-- 18.	Develop a stored procedure that accepts a salary threshold as an input parameter and retrieves all employees with salaries above that threshold.
delimiter $$
create procedure high_earners(in threshold decimal(10,2))
begin
    select * from employees where salary > threshold;
end$$
delimiter ;
call high_earners(75000.00);

-- 19.	Write a function to determine the average age of employees in the company based on their birthdates.
delimiter $$
create function avg_age()
returns float
deterministic
begin
    declare avg_age_val float;
    select avg(year(curdate()) - year(birth_date)) into avg_age_val from employees;
    return avg_age_val;
end$$
delimiter ;
select avg_age();

-- 20.	Create a stored procedure that takes an employee's last name as an input parameter and returns all employees with a similar last name.
delimiter $$
create procedure find_by_lastname(in lname varchar(50))
begin
    select * from employees where last_name like concat('%', lname, '%');
end$$
delimiter ;
call find_by_lastname('smith');
