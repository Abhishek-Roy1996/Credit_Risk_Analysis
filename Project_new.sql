create database creditcard_default;

use creditcard_default;

create table defaulter
(person_age int,
person_income int,	
person_home_ownership varchar(100),
person_emp_length int,
loan_intent varchar(50),
loan_grade 	varchar(50),
loan_amnt int,
loan_int_rate double,	
loan_percent_income	double,
cb_person_default_on_file text,
cb_person_cred_hist_length int,
loan_status int);

select * from defaulter;

-- Calculate base default rate.

select sum(loan_status)/count(*) as Default_rate
from defaulter;

-- Age wise default rate.
-- Diving the data into 10 ntiles

create table age_distri
select *,ntile(10) over (order by person_age desc) as age_distribution
from defaulter;

select * from age_distri;

-- Finding the min and max age of the distribution after dividing it into 10 ntiles.

select age_distribution,min(person_age) as MinAge, max(person_age) as MaxAge,sum(loan_status)/count(*) as Default_rate
from age_distri
group by age_distribution
order by age_distribution desc;

-- Spreading the last ntile into further 20 ntiles as the variance is way too large for age (36-144)

create table last10decile_age as select person_age, loan_status from defaulter
where person_age>=36;

select * from last10decile_age;

create table age_distri2
select *,ntile(20) over (order by person_age desc) as age_distribution
from last10decile_age;

select age_distribution,Min(person_age) as MinAge, Max(person_age) as MaxAge,sum(loan_status)/count(*) as Default_rate
from age_distri2
group by age_distribution
order by age_distribution desc;

-- Person income wise default rate

select person_income,sum(loan_status)/count(*) as Default_rate
from defaulter
group by person_income;

-- Diving the data into 10 ntiles

create table income_distri
select *,ntile(10) over (order by person_income desc) as income_distribution
from defaulter;

select person_income, income_distribution from income_distri;

-- Finding the min and max of the income distribution after dividing it into 10 ntiles.

select income_distribution,min(person_income) as MinIncome,max(person_income) as Maxincome,sum(loan_status)/count(*) as Default_rate
from income_distri
group by income_distribution
order by income_distribution desc;

-- Spreading the last ntile into further 10 ntiles as the variance is way too large for income (110004-6000000)

create table last10decile_income as select person_income, loan_status from defaulter
where person_income>=110004;

select * from last10decile_income;

create table income_distri2
select *,ntile(10) over (order by person_income desc) as last10decile_income
from last10decile_income;

select person_income,last10decile_income from income_distri2;

select last10decile_income,min(person_income) as MinIncome,max(person_income) as MaxIncome,sum(loan_status)/count(*) as Default_rate
from income_distri2
group by last10decile_income
order by last10decile_income desc;

-- Home ownership wise default rate

select person_home_ownership,sum(loan_status)/count(*) as Default_rate
from defaulter
group by person_home_ownership;

-- Person employee length wise default rate

select person_emp_length,sum(loan_status)/count(*) as Default_rate
from defaulter
group by person_emp_length;

-- -- Diving the data into 10 ntiles

create table emp_length select *,
ntile(10) over (order by person_emp_length desc) as employee_length
from defaulter;

-- Finding the min and max person employee length of the distribution by dividing it into 10 ntiles.

select employee_length, min(person_emp_length) as MinLength, Max(person_emp_length) as Maxlength,sum(loan_status)/count(*) as Default_rate
from emp_length
group by employee_length;

-- Spreading the last ntile into further 10 ntiles as the variance is way too large for emplength (10-123)

create table last10decile_emplength as select person_emp_length,loan_status from defaulter
where person_emp_length>=10;

create table emp_length2 select *,
ntile(20) over (order by person_emp_length) as last10decile_emplength
from last10decile_emplength;

select last10decile_emplength,Min(person_emp_length) as MinAge, Max(person_emp_length) as MaxAge,sum(loan_status)/count(*) as Default_rate
from emp_length2
group by last10decile_emplength
order by last10decile_emplength desc;

-- Loan intent wise default rate

select loan_intent,sum(loan_status)/count(*) as Default_rate
from defaulter
group by loan_intent;

-- Loan grade wise default rate

select loan_grade,sum(loan_status)/count(*) as Default_rate
from defaulter
group by loan_grade
order by loan_grade asc;

-- Loan amount wise default rate

select loan_amnt,sum(loan_status)/count(*) as Default_rate
from defaulter
group by loan_amnt;

create table loan_amt as select *,
ntile(10) over (order by loan_amnt desc) as loan_amt_distribution
from defaulter;

select * from loan_amt;

-- Finding the min and max loan amount of the distribution after dividing it into 10 ntiles.

select loan_amt_distribution,min(loan_amnt) as MinLoan, max(loan_amnt) as MaxLoan,sum(loan_status)/count(*) as Default_rate
from loan_amt
group by loan_amt_distribution
order by loan_amt_distribution desc;

-- Loan interest rate wise 

select loan_int_rate,sum(loan_status)/count(*) as Default_rate
from defaulter
group by loan_int_rate;

create table interest select *, 
ntile(10) over (order by loan_int_rate desc) as int_rate
from defaulter;

-- Finding the min and max of the interest after dividing it into 10 ntiles.

select int_rate,min(loan_int_rate) as MinRate, max(loan_int_rate) as MaxRate,sum(loan_status)/count(*) as Default_rate
from interest
group by int_rate;

-- Loan percent income

select loan_percent_income,sum(loan_status)/count(*) as Default_rate
from defaulter
group by loan_percent_income;

create table loan_income as select *,
ntile (20) over (order by loan_percent_income desc) as LoanIncDistri
from defaulter;

select * from loan_income;

-- Finding the maximum and minimum value after diving it into 10 ntiles

select LoanIncDistri, Min(loan_percent_income) as MinLoanInc, Max(loan_percent_income) as MaxLoanInc,sum(loan_status)/count(*) as Default_rate
from loan_income
group by LoanIncDistri
order by LoanIncDistri desc;

-- Person default on file

create table default_10
select cb_person_default_on_file,loan_status,
case 
    when cb_person_default_on_file in ("Y") then 1
else 0
end as "default_yes",
case 
    when cb_person_default_on_file in ("N") then 1
else 0 
end as "no_default"
from defaulter;

select * from default_10;

select cb_person_default_on_file,sum(loan_status)/count(*) as Default_rate
from default_10
group by cb_person_default_on_file;

-- Person credit history length

select case 
  when cb_person_cred_hist_length <=6 then 'a.<=6'
  when cb_person_cred_hist_length <=12 then 'b.7-12'
  when cb_person_cred_hist_length <=18 then 'c.13-18'
  when cb_person_cred_hist_length <=24 then 'd.19-24'
  else 'e.>24'
  end as year_length,count(*) as Cnt,sum(loan_status)/count(*) as Default_rate
from defaulter
group by year_length
order by year_length;

Create table binary_values as select loan_status,
case when loan_percent_income > 0.25 then '>0.25' else '<0.25' end as loanincome_bin,
case when loan_intent in ("medical","home-improvement","debt-consolidation") then 'risky' else 'non-risky' end as intent_type,
case when loan_grade in ("D","E","F","G") then 'risky' else 'non-risky' end as loan_grade


