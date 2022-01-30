
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