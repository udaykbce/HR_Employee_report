-- create database projects;
use projects;
select * from hr;
-- alter table hr
-- change column ï»¿id emp_id varchar(20) null;
describe hr;
select birthdate from hr;
set sql_safe_updates = 0;

update hr
set birthdate = case 
	when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else null
    end;
    
alter table hr
modify column birthdate date;

update hr
set hire_date= case 
	when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    else null
    end;
select termdate from hr;

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate <> ' ';

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d'))
where termdate is null and termdate <> ' ';

select birthdate,age from hr;

alter table hr
modify column hire_date date;

alter table hr
add column age int;

update hr
set age = timestampdiff(year, birthdate, curdate());

select gender, count(*) as count
from hr
where age >= 18 and termdate = ''
group by gender;

-- 2. what is the race/ethnicity breakdown of employees in the company?
select race, count(*) as count
from hr
where age >= 18 and termdate = ''
group by race
order by count(*) desc;
-- 3. what is the age distribution of the employrees in the company?
select min(age) as youngest, max(age) as oldest
from hr
where age >= 18 and termdate = '';

select case 
	when age > 18 and age<= 24 then '18-24'
    when age > 25 and age<= 34 then '25-34'
    when age > 35 and age<= 44 then '35-44'
    when age > 45 and age<= 54 then '45-54'
    when age > 55 and age<= 64 then '55-64'
    else '64+'
end as age_group,
count(*) as count
from hr
where age >= 18 and termdate = ''
group by age_group
order by age_group;

select case 
	when age > 18 and age<= 24 then '18-24'
    when age > 25 and age<= 34 then '25-34'
    when age > 35 and age<= 44 then '35-44'
    when age > 45 and age<= 54 then '45-54'
    when age > 55 and age<= 64 then '55-64'
    else '64+'
end as age_group, gender,
count(*) as count
from hr
where age >= 18 and termdate = ''
group by age_group, gender
order by age_group, gender;


-- 4. How many employees work in headquarters versus remote location? 
select location, count(*) as count
from hr
where age > 18 and termdate = ''
group by location;


-- 5. What is the average length of employment for employees who have been terminated?

select round(avg(datediff(termdate, hire_date))/365,0) as avg_length
from hr
where termdate < curdate() and termdate <> '' and age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count
from hr
where age >= 18 and termdate = ''
group by department, gender
order by department;

-- 7. what is the distribution of job title across the company?

 select jobtitle, count(*) as count
 from hr
 where age >= 18 and termdate = ''
 group by jobtitle
 order by jobtitle desc;
 
 -- 8. which dipartment has the highest turnover rate?
 select department, total_count, termination_count, termination_count/total_count as termination_rate
 from (
	select department, count(*) as total_count,
    sum(case when termdate <> '' and termdate < curdate() then 1 else 0 end) as termination_count
    from hr
    where age > 18
    group by department
    ) as details_table
order by termination_rate desc;

select department, count(*) as total_count,
    sum(case when termdate <> '' and termdate < curdate() then 1 else 0 end) as termination_count
from hr
where age > 18
group by department;
    
-- 9. what is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from hr
where age > 18 and termdate = ''
group by location_state
order by count(*) desc;

-- 10. how has the company's employee count has changed over time based on hire date and term date?

select year,
		hires, 
		terminations, 
        (hires-terminations) as net_change, 
        round((hires-terminations)/ hires *100, 2) as net_change_percentage
from (
	select year(hire_date) as year,
    count(*) as hires,
    sum(case when termdate <> '' and termdate <= curdate() then 1 else 0 end) as terminations
    from hr
    where age > 18
    group by year(hire_date)
    ) as subquery
order by year;

-- 11. What is the tenure distribution for each department?
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where age >= 18 and termdate <> '' and termdate <= curdate()
group by department;


































