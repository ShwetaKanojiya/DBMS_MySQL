-- -------------------------------Trigger Assignment-------------------------------------------
-- --------------------------------------------------------------------------------------------
-- 1.	How can MySQL triggers be used to automatically update employee records when a department is changed?
delimiter $$
create trigger after_department_update
after update on departments
for each row
begin
    update employees
    set department_id=new.department_id
    where department_id=old.department_id;
end;
$$
delimiter ;
insert into departments values (40,'human resources',null,0),(80,'sales',null,0);

-- 2.	What MySQL trigger can be used to prevent an employee from being deleted if they are currently assigned to a department?
delimiter $$
create trigger prevent_employee_delete
before delete on employees
for each row
begin
    if old.department_id is not null then
        signal sqlstate '45000'
        set message_text = 'cannot delete employee assigned to a department';
    end if;
end;
$$
delimiter ;
insert into employees (employee_id, first_name, last_name, job_id, salary) values (101, 'john', 'doe', 'it_prog', 5000);

-- 3.	How can a MySQL trigger be used to send an email notification to HR when an employee is hired or terminated?
delimiter $$
create trigger after_employee_hire
after insert on employees
for each row
begin
    insert into hr_notifications(message, created_at)
    values (concat('new hire: ', new.first_name, ' ', new.last_name), now());
end;
$$
delimiter ;

-- 4.	What MySQL trigger can be used to automatically assign a new employee to a department based on their job title?
delimiter $$
create trigger assign_department_based_on_job
before insert on employees
for each row
begin
    if new.job_id = 'it_prog' then
        set new.department_id = 60;
    elseif new.job_id = 'hr_rep' then
        set new.department_id = 40;
    elseif new.job_id = 'sa_rep' then
        set new.department_id = 80;
    end if;
end;
$$
delimiter ;

-- 5.	How can a MySQL trigger be used to calculate and update the total salary budget for a department whenever a new employee is hired or their salary is changed?
delimiter $$
create trigger after_salary_insert
after insert on employees
for each row
begin
    update departments
    set total_salary_budget = (
        select sum(salary)
        from employees
        where department_id = new.department_id
    )
    where department_id = new.department_id;
end;
$$
delimiter ;

-- 6.	What MySQL trigger can be used to enforce a maximum number of employees that can be assigned to a department?
delimiter $$
create trigger limit_department_employees
before insert on employees
for each row
begin
    declare emp_count int;
    select count(*) into emp_count
    from employees
    where department_id = new.department_id;

    if emp_count >= 3 then
        signal sqlstate '45000'
        set message_text = 'department has reached the maximum number of employees';
    end if;
end;
$$
delimiter ;

-- 7.	How can a MySQL trigger be used to update the department manager whenever an employee under their supervision is promoted or leaves the company?
delimiter $$
create trigger update_department_manager
after update on employees
for each row
begin
    if new.job_id = 'manager' then
        update departments
        set manager_id = new.employee_id
        where department_id = new.department_id;
    end if;
end;
$$
delimiter ;

-- 8.	What MySQL trigger can be used to automatically archive the records of an employee who has been terminated or has left the company?
delimiter $$
create trigger archive_employee_before_delete
before delete on employees
for each row
begin
    insert into employee_archive
    (employee_id, first_name, last_name, department_id, job_id, salary, termination_date)
    values (old.employee_id, old.first_name, old.last_name, old.department_id, old.job_id, old.salary, now());
end;
$$
delimiter ;
