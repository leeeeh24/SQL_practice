CREATE TABLE Users
(
	user_id int primary key,
	user_name varchar(30) not null,
	email varchar(50)
	);
    
insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users;

##Write a SQL Query to fetch all the duplicate records in a table.
##solution1
## we can see robin have 2 user_id, it is duplicate 
SELECT user_name, count(user_id)
FROM users
group by user_name

## a unique name has a unique id, so min(user_id) equals to 1, if there is any duplicate
## it will greater than 1. so here we use a subquery
SELECT *
FROM USERS
WHERE USERS.user_id not in 
(
select	min(user_id)
from users
group by user_name);

##solution2 
## use window function, row_number to find out duplicate, then locate it
select user_id, user_name, email
from (
select *,
row_number() over (partition by user_name order by user_id) as rn
from users u
order by user_id) x
where x.rn <> 1;

-- Query 2:
-- Write a SQL query to fetch the second last record from a employee table.

drop table employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

## use window function, this time don't need to partition by, simply row the number
## because we look at the whole table, put it into a subquery and use select query to locate it
SELECT *
FROM 
(
	SELECT *, row_number() over (order by emp_ID desc) as x
	FROM employee
    ) AS D
WHERE x = 2;

-- Write a SQL query to display only the details of employees who either earn the highest salary
-- or the lowest salary in each department from the employee table.
## solution 1 my way
SELECT *
FROM 
(
	SELECT *, min(salary) over (partition by DEPT_NAME) as minwages,
		max(salary) over (partition by DEPT_NAME) as maxwages
	FROM employee
	ORDER BY salary ) a
WHERE salary = minwages
or salary = maxwages
ORDER BY DEPT_NAME

-- Solution2:
select x.*
from employee e
join (select *,
max(salary) over (partition by dept_name) as max_salary,
min(salary) over (partition by dept_name) as min_salary
from employee) x
on e.emp_id = x.emp_id
and (e.salary = x.max_salary or e.salary = x.min_salary)
order by x.dept_name, x.salary;



-- Query 4:
-- From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.

drop table doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

## solution1
SELECT d1.name, d1.speciality, d1.hospital
FROM doctors D1
JOIN doctors d2
	ON D1.hospital = D2.hospital
WHERE 
	D1.speciality <> D2.speciality

-- Solution2:

select d1.name, d1.speciality,d1.hospital
from doctors d1
join doctors d2
on d1.hospital = d2.hospital and d1.speciality <> d2.speciality  ##this is new
and d1.id <> d2.id; ##this is new

select d1.name, d1.speciality,d1.hospital
from doctors d1
join doctors d2
on d1.hospital = d2.hospital 
and d1.id <> d2.id;  ## where clause also works



create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

-- Query 5:
-- From the login_details table, fetch the users who logged in consecutively 3 or more times.
select * from login_details;

SELECT user_name, row_number() over (partition by user_name)
FROM login_details
WHERE 

select distinct repeated_names
from (
	select *,
	case when user_name = lead(user_name) over(order by login_id) ##user_name from next row (second row
	and  user_name = lead(user_name,2) over(order by login_id) ## user_name next next (third row
	then user_name else null end as repeated_names
	from login_details) x ##sub query fetch row include null
where x.repeated_names is not null;



drop table students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');
-- Query 6:
-- From the students table, write a SQL query to interchange the adjacent student names.
select * from students;

SELECT *,
	CASE WHEN id%2 <> 0 then lead(student_name,1,student_name) over (order by id)
    ## %2 equal to divide by 2 if reminder = 0 then number is even
    ## %2 lead(student_name,1,student_name) 1(off set) means retrieve student_name from next row, 
    ##	student_name(default) after 1 means if off set beyond the scope default is returned
    ## if you dont specify it would be null
    WHEN id%2 = 0 then lag(student_name) over (order by id)
    END AS new_student_name
FROM students



create table weather
(
id int,
city varchar(50),
temperature int,
day date
);

insert into weather values
(1, 'London', -1, str_to_date('1,1,2021','%d,%m,%Y')),  ## in sql server the clause is to_date and the format is slightly different
(2, 'London', -2, str_to_date('2,1,2021','%d,%m,%Y')),
(3, 'London', 4, str_to_date('3,1,2021','%d,%m,%Y')),
(4, 'London', 1, str_to_date('4,1,2021','%d,%m,%Y')),
(5, 'London', -2, str_to_date('5,1,2021','%d,%m,%Y')),
(6, 'London', -5, str_to_date('6,1,2021','%d,%m,%Y')),
(7, 'London', -7, str_to_date('7,1,2021','%d,%m,%Y')),
(8, 'London', 5, str_to_date('8,1,2021','%d,%m,%Y'));

-- Query 7:
-- From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.
-- Note: Weather is considered to be extremely cold then its temperature is less than zero.
select * from weather;

## 一是要当天小于0°，以下三种情况有其一满足冷天 1.前一天都小于0°，2.后俩天都小于0°
				##3.前俩天都小于0°
                ##window function lag and lead
SELECT *
FROM (
		SELECT *,
			case when temperature < 0
				and lead(temperature) over(order by day) <0
				and lead(temperature,2) over(order by day) < 0
			then 'Yes its cold'
			when temperature < 0
				and lead(temperature) over(order by day) <0
				and lag(temperature) over(order by day) <0
			then 'Yes its cold'
			when temperature < 0
				and lag(temperature) over(order by day) <0
				and lag(temperature,2) over(order by day) <0
			then 'Yes its cold'
			end as flag
			FROM weather) x
WHERE X.flag = 'Yes its cold'

## 3 tables
drop table event_category;
create table event_category
(
  event_name varchar(50),
  category varchar(100)
);

drop table physician_speciality;
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

drop table patient_treatment;
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);
-- Query 8:
-- From the following 3 tables (event_category, physician_speciality, patient_treatment),
-- write a SQL query to get the histogram of specialities of the unique physicians who have done the procedures but never did prescribe anything.
## event_category
insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');

## physician_speciality
insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');

## patient_treatment
insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);

## my way, only difference is The count which i choose id.
SELECT PS.speciality, count(PS.physician_id) speciality_count
FROM patient_treatment PT
JOIN physician_speciality PS
	ON PT.physician_id = PS.physician_id 
JOIN event_category EC
	ON PT.event_name = EC.event_name
WHERE PS.physician_id NOT in (
	SELECT PT.physician_id
	FROM patient_treatment PT
	JOIN event_category EC
		on PT.event_name = EC.event_name
	WHERE EC.category = 'prescription'
    ) 
AND EC.category = 'Procedure'
GROUP BY PS.speciality


##solution 2

select ps.speciality, count(1) as speciality_count
from patient_treatment pt
join event_category ec on ec.event_name = pt.event_name
join physician_speciality ps on ps.physician_id = pt.physician_id
where ec.category = 'Procedure'
and pt.physician_id not in (select pt2.physician_id
							from patient_treatment pt2
							join event_category ec on ec.event_name = pt2.event_name
							where ec.category in ('Prescription'))
group by ps.speciality;



create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, str_to_date('02,01,2020','%d,%m,%Y'), 100);
insert into patient_logs values (1, str_to_date('21,01,2020','%d,%m,%Y'), 200);
insert into patient_logs values (2, str_to_date('01,01,2020','%d,%m,%Y'), 300);
insert into patient_logs values (2, str_to_date('21,01,2020','%d,%m,%Y'), 400);
insert into patient_logs values (2, str_to_date('21,01,2020','%d,%m,%Y'), 300);
insert into patient_logs values (2, str_to_date('01,01,2020','%d,%m,%Y'), 500);
insert into patient_logs values (3, str_to_date('20,01,2020','%d,%m,%Y'), 400);
insert into patient_logs values (1, str_to_date('04,03,2020','%d,%m,%Y'), 500);
insert into patient_logs values (3, str_to_date('20,01,2020','%d,%m,%Y'), 450);
-- Query 9:
-- Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
-- Note: Prefer the account if with the least value in case of same number of unique patients

SELECT B.months, B.account_id, B.cp
FROM (
	SELECT A.months, A.account_id, A.cp, row_number() over (partition by A.months ORDER BY cp desc) as RN
	FROM (
		SELECT monthname(date) as  Months, account_id, count(distinct(patient_id)) CP
		FROM patient_logs
		GROUP BY monthname(date),account_id
		ORDER BY monthname(date), CP desc
		) A
    ) B
WHERE B.rn < 3;

drop table if exists weather cascade;
create table if not exists weather
	(
		id 					int 				primary key,
		city 				varchar(50) not null,
		temperature int 				not null,
		day 				date				not null
	);
SELECT * FROM WEATHER
delete from weather
insert into weather values
	(1, 'London', -1, str_to_date('1,1,2021','%d,%m,%Y')),
	(2, 'London', -2, str_to_date('2,1,2021','%d,%m,%Y')),
	(3, 'London', 4, str_to_date('3,1,2021','%d,%m,%Y')),
	(4, 'London', 1, str_to_date('4,1,2021','%d,%m,%Y')),
	(5, 'London', -2, str_to_date('5,1,2021','%d,%m,%Y')),
	(6, 'London', -5, str_to_date('6,1,2021','%d,%m,%Y')),
	(7, 'London', -7, str_to_date('7,1,2021','%d,%m,%Y')),
	(8, 'London', 5, str_to_date('8,1,2021','%d,%m,%Y')),
	(9, 'London', -20, str_to_date('9,1,2021','%d,%m,%Y')),
	(10, 'London', 20, str_to_date('10,1,2021','%d,%m,%Y')),
	(11, 'London', 22, str_to_date('11,1,2021','%d,%m,%Y')),
	(12, 'London', -1, str_to_date('12,1,2021','%d,%m,%Y')),
	(13, 'London', -2, str_to_date('13,1,2021','%d,%m,%Y')),
	(14, 'London', -2, str_to_date('14,1,2021','%d,%m,%Y')),
	(15, 'London', -4, str_to_date('15,1,2021','%d,%m,%Y')),
	(16, 'London', -9, str_to_date('16,1,2021','%d,%m,%Y')),
	(17, 'London', 0, str_to_date('17,1,2021','%d,%m,%Y')),
	(18, 'London', -10, str_to_date('18,1,2021','%d,%m,%Y')),
	(19, 'London', -11, str_to_date('19,1,2021','%d,%m,%Y')),
	(20, 'London', -12, str_to_date('20,1,2021','%d,%m,%Y')),
	(21, 'London', -11, str_to_date('21,1,2021','%d,%m,%Y'));
COMMIT;

-- Finding n consecutive records where temperature is below zero. And table has a primary key.
with table1 as
	(
select *,
	row_number() over(order by id) as rn,
    id - (row_number() over(order by id)) as difference
from weather
WHERE  temperature < 0
	),
    table2 as
    (SELECT *, count(*) over (partition by difference) as num_of_records
    FROM table1)
SELECT id, city, temperature, day 
FROM TABLE2
WHERE num_of_records =5;

-- Finding n consecutive records where temperature is below zero. And table does not have primary key.
CREATE TABLE vw_weather
	(city varchar(50) not null,
    temperature int not null);
INSERT INTO vw_weather
VALUES ('London', -1),
	('London', -2),
	('London', 4),
	('London', 1),
	('London', -2),
	('London', -5),
	('London', -7),
	('London', 5),
	('London', -20),
	('London', 20),
	('London', 22),
	('London', -1),
	('London', -2),
	('London', -2),
	('London', -4),
	('London', -9),
	('London', 0),
	('London', -10),
	('London', -11),
	('London', -12),
	('London', -11);
    

 ## use a temp table to create a column for id first   
with  idtable as
	(SELECT *, row_number() over() as id
    FROM vw_weather),  ## there is a comma
table1 as
	(
select *,
	row_number() over(order by id) as rn,
    id - (row_number() over(order by id)) as difference
from idtable
WHERE  temperature < 0
	),
    table2 as
    (SELECT *, count(*) over (partition by difference) as num_of_records
    FROM table1)
SELECT id, city, temperature
FROM TABLE2
WHERE num_of_records =5;


-- Finding n consecutive records with consecutive date value.

create table if not exists orders
  (
    order_id    varchar(20) primary key,
    order_date  date        not null
);
insert into orders values
  ('ORD1001', str_to_date('1,1,2021','%d,%m,%Y')),
  ('ORD1002', str_to_date('1,2,2021','%d,%m,%Y')),
  ('ORD1003', str_to_date('2,2,2021','%d,%m,%Y')),
  ('ORD1004', str_to_date('3,2,2021','%d,%m,%Y')),
  ('ORD1005', str_to_date('1,5,2021','%d,%m,%Y')),
  ('ORD1006', str_to_date('1,6,2021','%d,%m,%Y')),
  ('ORD1007', str_to_date('25,12,2021','%d,%m,%Y')),
  ('ORD1008', str_to_date('26,12,2021','%d,%m,%Y'));
COMMIT;

WITH table1 as
(
SELECT *, 
	row_number() over (order by order_id) as rn,		## "unsigned",different from other sql, in postgresql use int
	order_date - CAST(row_number() over (order by order_id) AS UNSIGNED) as difference
FROM orders
),
	table2 as
    (SELECT *, 
    count(*) over(partition by difference) as num_of_records
	FROM table1)
SELECT order_id, order_date
FROM table2
WHERE num_of_records =3;

    
    