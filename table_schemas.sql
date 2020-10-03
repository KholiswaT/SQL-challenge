-- Database: PH Employees

-- DROP DATABASE "PH Employees";

CREATE DATABASE "PH Employees"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

--Insert postgres code exported from Quick Database Diagrams
-- Run code for creating table then import corresponding csv file for each newly created table

CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Depart_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "Dept_manager" (
    "dept_no" VARCHAR  NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "Employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

CREATE TABLE "Titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "title_id"
     )
);

--After tables and csv files are created, run code for adding foreign key, linking the separate tables together

ALTER TABLE "Depart_emp" ADD CONSTRAINT "fk_Depart_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Depart_emp" ADD CONSTRAINT "fk_Depart_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("title_id");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

--Join Employees and Salary tables together to extract specific data from each

select *
from "Salaries"; 

select * 
from "Employees";

select "Employees"."emp_no","Employees"."first_name","Employees"."last_name", "Employees"."sex", "Salaries"."salary"
from "Salaries"
inner join "Employees"
on "Salaries"."emp_no" = "Employees"."emp_no";


-- Extract Employees who were hired in 1986
select "Employees"."first_name", "Employees"."last_name", "Employees"."hire_date"
from "Employees"
where 
	"hire_date" >=  '1986-01-01'
	and "hire_date" <= '1986-12-31';

--Select managers for every department

select * from "Dept_manager";
select * from "Departments";

select "Departments"."dept_no", "Departments"."dept_name", "Dept_manager"."emp_no", "Employees"."first_name", "Employees"."last_name"
from "Departments"
left join "Dept_manager"
on "Departments"."dept_no"= "Dept_manager"."dept_no"
left join "Employees"
on "Dept_manager"."emp_no" = "Employees"."emp_no";

--List department name for all employees

select * from "Depart_emp";
select "Depart_emp"."emp_no", "Employees"."first_name", "Employees"."last_name", "Departments"."dept_name"
from "Employees"
left join "Depart_emp"
on "Employees"."emp_no" = "Depart_emp"."emp_no"
left join "Departments"
on "Depart_emp"."dept_no" = "Departments"."dept_no";


--Select Employees whose first name is Hercules and last name begins with the letter B

select "Employees"."first_name", "Employees"."last_name", "Employees"."sex"
from "Employees"
where "first_name" = 'Hercules'
	   and "last_name" like 'B%'; 


--Select employees who work in the Sales Department

select "Depart_emp"."emp_no", "Employees"."first_name", "Employees"."last_name", "Departments"."dept_name"
from "Employees"
left join "Depart_emp"
on "Employees"."emp_no" = "Depart_emp"."emp_no"
left join "Departments"
on "Depart_emp"."dept_no" = "Departments"."dept_no"
where "Departments"."dept_name" = 'Sales';


--Select employees who either work in the Sales or Development department
select "Depart_emp"."emp_no", "Employees"."first_name", "Employees"."last_name", "Departments"."dept_name"
from "Employees"
left join "Depart_emp"
on "Employees"."emp_no" = "Depart_emp"."emp_no"
left join "Departments"
on "Depart_emp"."dept_no" = "Departments"."dept_no"
where "Departments"."dept_name" = 'Sales' or 
      "Departments"."dept_name" ='Development';

-- List the frequency count of the employees' last names
select "Employees"."last_name",
count("Employees"."last_name") as last_name_frequency
from "Employees"
group by "Employees"."last_name"
order by last_name_frequency DESC
;


