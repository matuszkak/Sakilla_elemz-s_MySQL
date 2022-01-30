
use employees;

select * from titles;


-- 1. Average salaries by dept / gender
select dept_no, gender, avg(salary)
from employees
inner join dept_emp using(emp_no)
inner join departments using(dept_no)
inner join salaries using(emp_no)
where salaries.to_date > curdate()
group by dept_no, gender
order by dept_no;

-- 2. Department with lowest and highest id
select min(dept_no)
from dept_emp;

select max(dept_no)
from dept_emp;

-- 3. Query data for employees with emp_no < 10040

select emp_no, min(dept_no),
-- manager: 110022 ha az employee number alacsonyabb vagy egyenlő 10020-al, és 110039 abban az esetben ha az employee number 10021 és 10040 közé esik
case
	when emp_no <= 10020 then '110022'
    else '110039'
    end as manager
from employees   
inner join dept_emp using(emp_no)
where emp_no <= '10040'
group by emp_no;

-- 4. Employees hired in 2000
select emp_no, last_name, first_name, hire_date
from employees
inner join titles using(emp_no)
where to_date between '2000-01-01' and '2000-12-31';

-- 5. List of engineers and senior engineers
select emp_no, last_name, first_name, title, from_date, to_date
from employees
inner join titles using (emp_no)
where to_date in ('9999-01-01') and title in ('Engineer')
order by last_name, first_name
limit 10;

select emp_no, last_name, first_name, title, from_date, to_date
from employees
inner join titles using (emp_no)
where to_date in ('9999-01-01') and title in ('Senior engineer')
order by last_name, first_name
limit 10;

-- 6. Procedure: query dept based on employee no.
use employees;
drop procedure if exists last_dept;

delimiter $$
use employees $$
create procedure last_dept(in p_emp_no integer)
begin
  select employees.last_name, employees.first_name, dept_no, dept_name, from_date, to_date
  from employees
  inner join dept_emp using(emp_no)
  inner join departments using(dept_no)
  where to_date in ('9999-01-01') and employees.emp_no = p_emp_no;
end$$
delimiter ;

call employees.last_dept(10010);

-- 7. No. of contracts in slaries table longer than a year

-- create view contract lengths calculated
create or replace view contract_lengths as
select emp_no, from_date, to_date, salary,
-- if contract have not expired check length equals current date minus from_date
case
	when to_date in ('9999-01-01') then datediff(curdate(), from_date)
    else datediff(to_date, from_date)
    end as length
from salaries
where salary > 100000
having length > 365
order by length;

-- run / refresh view first and then below select! 
select count(emp_no) from contract_lengths;

-- 8. Trigger: to check if hiring date < current date

use employees;
delimiter $$
create trigger employees.before_employee_insert
before insert on employees
for each row
begin 
    if new.hire_date < curdate() then 
        set new.hire_date = sysdate(); 
    end if; 
end $$
delimiter ;

-- test case positive:
use employees;
insert employees values('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');
select * from employees order by emp_no desc limit 10;

-- test case negative:
use employees;
insert employees values('999906', '1976-06-14', 'Kristof', 'Mastuszka', 'M', '2002-01-01');
select * from employees order by emp_no desc limit 10;

-- update typo in name
update employees 
set last_name = 'Matuszka'
where emp_no = 999906;

-- 9. Function: find top / min salary for an employee

use employees;
drop function if exists f_emp_top_salary;
delimiter $$
create function f_emp_top_salary(p_emp_no integer) returns decimal(10,2)
deterministic
begin
  declare v_top_salary decimal(10, 2);
	  select max(salaries.salary)
	  into v_top_salary
	  from employees
	  inner join salaries using(emp_no)
	  where emp_no = p_emp_no;
  return v_top_salary;
end;

use employees;
drop function if exists f_emp_min_salary;
create function f_emp_min_salary(p_emp_no integer) returns decimal(10,2)
deterministic
begin
  declare v_min_salary decimal(10, 2);
	  select min(salaries.salary)
	  into v_min_salary
	  from employees
	  inner join salaries using(emp_no)
	  where emp_no = p_emp_no;
  return v_min_salary;
end $$
delimiter ;

-- call functions
select employees.f_emp_top_salary(11356);
select employees.f_emp_min_salary(11356);

-- salaries for emp_no 11356
select * from employees.salaries
where emp_no = 11356;

-- 10. Function: find top / min salary with a function with two attributes

use employees;
drop function if exists f_emp_minvsmax_salary;
delimiter $$
create function f_emp_minvsmax_salary(p_emp_no integer, minvsmax text) returns decimal(10,2)
deterministic
begin
  declare v_output_salary decimal(10, 2);
	if minvsmax = 'min' then set v_output_salary = f_emp_min_salary(p_emp_no);
    elseif minvsmax = 'max' then set v_output_salary = f_emp_top_salary(p_emp_no);
	else set v_output_salary = f_emp_top_salary(p_emp_no) - f_emp_min_salary(p_emp_no);
    end if;
  return v_output_salary;
end $$
delimiter ;

-- call and test function
select employees.f_emp_minvsmax_salary(11356, 'min');
select employees.f_emp_minvsmax_salary(11356, 'max');
select employees.f_emp_minvsmax_salary(11356, 'fcuk');

-- salaries for emp_no 11356
select * from employees.salaries
where emp_no = 11356;

