create database hrdata;
use hrdata;
select * from employees;
-- Total Employees
select count(*) as total_employees from employees;
-- Total Old Employees
select count(*) as total_old_employees from employees where DateOfTermination !='';
-- Total Current Employees
select count(*) as total_old_employees from employees where DateOfTermination ='';
-- Average Salary
select avg(salary) as Avg_Salary from employees;
-- Average age
select avg(TIMESTAMPDIFF(year, str_to_date(DOB,'%d-%m-%Y'), CURDATE())) as avg_age from employees;
-- Average years in company
select avg(TIMESTAMPDIFF(year, str_to_date(DateOfHire,'%d-%m-%Y'), CURDATE())) as avg_years_in_company from employees;
-- adding new column for employee current status
alter table employees 
add employeeCurrentStatus INT;
-- UPDATE VALUES for new column
set sql_safe_updates=0;
update employees
set employeeCurrentStatus = CASE
   when DateofTermination ='' then 1
   else 0
end;
-- calculate attrition rate 
select 
   (CAST(COUNT(CASE WHEN employeeCurrentStatus= 0 then 1 end) as float)/count(*))*100 as Attrition_Rate
   from employees;
   -- get column name and data types
   DESCRIBE employees;
-- print 1st 5 rows
select * from employees limit 5;
-- print last 5 rows
select * from employees order by empid desc limit 5;
-- changing datatypes of salary
alter table employees
MODIFY column salary decimal(10,2);
-- convert all data columns in proper dates
update employees
set DOB = str_to_date(DOB, '%d-%m-%Y');
update employees
set DateofHire = str_to_date(DateofHire, '%d-%m-%Y');
update employees
set LastPerformanceReview_Date = str_to_date(LastPerformanceReview_Date, '%d-%m-%Y');
alter table employees
modify column DOB date,
modify column DateofHire date,
modify column LastPerformanceReview_Date  date;
DESCRIBE employees;
update employees 
set DateofTermination = 'CurrentlyWorking'
where DateofTermination is null or DateofTermination = '';
-- count of each unique value in maritalDesc
select MaritalDesc, count(*) as count
from employees
group by MaritalDesc
order by count DESC;
-- count of each unique value in department
select Department, count(*) as count
from employees
group by Department
order by count DESC;
-- count of each unique value in positions
select Position, count(*) as count
from employees
group by Position
order by count DESC;
-- salary ditribution by employees
select
CASE
when salary<30000 then '<30K'
when salary between 30000 and 49999 then '30K-49K'
when salary between 50000 and 69999 then '50K-69K'
when salary between 70000 and 89999 then '70K-89K'
when salary >=90000 then '90K and above'
end as Salary_Range,
count(*) as Frequency
from employees group by Salary_Range order by Salary_Range;
-- average salary by department
select 
   department,
   avg(Salary) as AverageSalary
from employees
group by department
order by department;
-- COUNT TERMINATION BY CAUSE
select 
   TermReason,
   count(*) as count
from employees
where TermReason is not null
group by TermReason
order  by count DESC;
-- employee count by state
select 
   State,
   count(*) as count
from employees
group by State
order  by count DESC;
-- gender dostribution
select 
   Sex,
   count(*) as count
from employees
group by Sex
order  by count DESC;
--  getting age distribution
-- add a new column
alter table employees
add column age int;
-- update te age column
set sql_safe_updates=0;
update employees
set age=TIMESTAMPDIFF(YEAR,DOB,CURDATE());
-- age distribution
select
CASE
WHEN age<20 then '<20'
when age between 20 and 29 then '20-29'
when age between 30 and 39 then '30-39'
when age between 40 and 49 then '40-49'
when age between 50 and 59 then '50-59'
when age >=60 then '60 and above'
end as Age_Range,
count(*) as count
from employees
group by Age_Range;
-- absence by deaprtment
select
     Department,
     Sum(Absences) as TotalAbsences
from employees
group by Department
order by TotalAbsences Desc;
-- salary by gender
select
 Sex,
 sum(salary) as TotalSalary from employees group by Sex order by TotalSalary DESC;
 -- count of employees terminated a per marital status
 select
     MaritalDesc,
     count(*) as Terminatedcount
from employees
where Termd=1
group by MaritalDesc
order by Terminatedcount Desc;
-- average absence
 select
  PerformanceScore,
     avg(absences) as averageabsence
from employees
group by PerformanceScore
order by PerformanceScore;
-- by recritemnt source
 select
  RecruitmentSource,
     count(*) as EmployeeCount
from employees
group by RecruitmentSource
order by EmployeeCount desc;
