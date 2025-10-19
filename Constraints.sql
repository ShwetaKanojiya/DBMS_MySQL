-- --------------------------CONSTRAINTS---------------------
create database constraints;
use constraints;
-- -----------------------------------------------------------------
-- ------------------UNIQUE constraint-------------------------------
create table constraint_ex1(s_name varchar(20),age int,email varchar(20) unique);
insert into constraint_ex1 values('Aaa',9,'aaa@gmail.com'),('Bbb',19,'bb@gmail.com');
insert into constraint_ex1 value('Ccc',null,'abs@gmIL.COM');
select * from constraint_ex1;
-- ---------------------------------------------------------------------------------------
create table constraint_ex2(s_name varchar(20),age int,email varchar(20),mob_no int(10),unique (email,mob_no));
insert into constraint_ex2 values('Aaa',9,'aaa@gmail.com',99999999),('Bbb',19,'bb@gmail.com',88888888);
insert into constraint_ex2 value('Ccc',29,'bb@gmail.com',7777888);-- unique works like or operation either should be uniqueemail or mob
select * from constraint_ex2;
-- -------------------------------------------------------------------------
create table constraint_ex3(s_name varchar(10),username varchar(10) unique,email varchar(20),mob_no int(10),unique (email,mob_no));
insert into constraint_ex3 values('Aaa','user1','aaa@gmail.com',99999999),('Bbb','user2','bb@gmail.com',88888888);
insert into constraint_ex3 value('Aaa',null,'a@gmail.com',99999999);-- ------can be null but not duplicate 
select * from constraint_ex3;
-- -------------------------------------------------------------------------------
-- ------------------DEFAULT constraint-------------------------------
create table constraint_ex4(emp_name varchar(10),username varchar(10) unique, age int default 18,dept_id int);
insert into constraint_ex4 values('Aaa','user1',21,99999999),('Bbb','user2',22,88888888);
insert into constraint_ex4 value ('Ccc',null,default,2322);
select * from constraint_ex4;
-- --------ex2--------
create table constraint_ex4_0(emp_id int ,emp_name varchar(10),dept_id int,dept_name varchar(20) default 'IT');
insert into constraint_ex4_0 value(1,'AAA',11,default);
insert into constraint_ex4_0 (emp_id,emp_name,dept_id)value(2,'BB',11);
select * from constraint_ex4_0;
-- -------------------------------------------------------------------
-- ------------------NOT NULL constraint-------------------------------
create table constraint_ex5(s_name varchar(20),age int not null,email varchar(20),mob_no int(10));
insert into constraint_ex5 values('Aaa',0 ,'aaa@gmail.com',99999999),
-- ('baa',null,'aaa@gmail.com',9999),
('caa',9,'aaa@gmail.com',999989);
insert into constraint_ex5 value('Ccc',29,'bb@gmail.com',7777888);
select * from constraint_ex5;
-- ---------------------------------------------------------------------
-- ----------------------CHECK constraint-------------------------------
create table constraint_ex6(s_name varchar(20),age int not null check (age>=18),s_address varchar(20));
insert into constraint_ex6 values('AA',20,'sector1'),('Bb',27,'sector2');
-- insert into constraint_ex6 values('CA',2,'sector2'); --error (age>=18)
select * from constraint_ex6;
desc constraint_ex6;
-- --------ex2--------
create table constraint_ex6_0(uname varchar(20),pswrd varchar(10) not null check (char_length(pswrd)>=8 and char_length(pswrd)<10));
insert into constraint_ex6_0 value ('Abc','abc@12hhj');
insert into constraint_ex6_0 value ('pqr','siuuxssss');
select * from constraint_ex6_0;
-- --------ex3--------
/*
create table constraint_example(usname varchar(20),pss_w_d varchar(10) not null check (char_length(pss_w_d)>=8 and char_length(pss_w_d)<10 and usname regexp '^[A-Za-z]+$'));
insert into constraint_example value ('Abvc','abdc@12hhj');
insert into constraint_example value ('pqcr','siduuxssss');
select * from constraint_example;
*/
create table departt(dept_id int,dept_name varchar(20),location varchar(20),constraint pk_dept_id primary key(dept_id));
desc departt;
insert into departt values(1,'CSE','Sector 1'),(2,'It','Sector 2');
select * from departt;

create table empp(e_id int primary key,e_name varchar(20),dept_id int, constraint fk_epm_dept foreign key(dept_id) references departt(dept_id));
desc empp;
select table_name,constraint_name from information_schema.Table_constraints where table_schema=database() and table_name='empp';
select table_name,constraint_name,constraint_type from information_schema.Table_constraints where table_schema=database() and table_name in('employee','department','emp_default','emp_uk');
-- create table empp_UK(emp_name varchar(20),username varchar(20) unique not null,age int,