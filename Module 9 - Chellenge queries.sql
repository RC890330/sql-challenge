DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS department_employees;
DROP TABLE IF EXISTS department_manager;

-- Create table for title csv file 
CREATE TABLE titles(
	title_ID VARCHAR PRIMARY KEY,
	title VARCHAR
);

-- Show everything from table title
SELECT * FROM titles;

-- Create table for import of employees csv file 
CREATE TABLE employees(
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_ID VARCHAR NOT NULL,
	birth_date VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date VARCHAR NOT NULL,
	FOREIGN KEY (emp_title_ID) REFERENCES titles(title_ID)
);

-- Show everything from employees table 
SELECT * FROM employees;

-- Create table for import of salaries csv file 
CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no) 
);

-- Show everything from the salaries table 
SELECT * FROM salaries;

-- Create table for import of departments table 
CREATE TABLE departments(
	dept_no VARCHAR PRIMARY KEY NOT NULL,
	dept_name VARCHAR NOT NULL
);

-- Show everything from the departments table 
SELECT * FROM departments;

-- Create table for department_employees table 
CREATE TABLE department_employees(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

-- Show everything from department_employees table 
SELECT * FROM department_employees;

-- Create table for department_manager table 
CREATE TABLE department_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Show everything from department_manager table 
SELECT * FROM department_manager;

-- Data Analysis 
-- Create joint table of employees and salaries with employee number, 
-- last name, first name, sex, and salary of each employee
DROP TABLE IF EXISTS employee_info;
CREATE TABLE employee_info(
	e INT PRIMARY KEY NOT NULL,
	birth_date VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	emp_salary INT NOT NULL
);

-- Show everything from the employee_info table 
SELECT * FROM employee_info;

SELECT e.emp_no, e.birth_date, e.first_name, e.last_name, e.sex, s.salary
FROM salaries as s
INNER JOIN employees AS e ON
e.emp_no=s.emp_no;

-- Create table which includes first name, last name, and hire date for the employees who were hired in 1986
DROP TABLE IF EXISTS employee_1986;
CREATE TABLE employee_1986(
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	hire_date VARCHAR NOT NULL
);

SELECT * FROM employee_1986;

SELECT e.first_name, e.last_name, e.hire_date
FROM employees AS e
WHERE e.hire_date LIKE '%/1986';

-- Join departments, department_manager, and employee together 
-- Include manager of each department along with their department number, 
-- department name, employee number, last name, and first name
DROP TABLE IF EXISTS manager_of_department;
CREATE TABLE manager_of_department(
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL,
	emp_no VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL
);

-- Show everything from 
SELECT * FROM manager_of_department;

SELECT departments.dept_no, departments.dept_name, department_manager.emp_no, employees.last_name, employees.first_name
FROM departments
INNER JOIN department_manager ON
departments.dept_no=department_manager.dept_no
INNER JOIN employees ON
department_manager.emp_no=employees.emp_no;

-- Create join table of employees and dept_employee
-- Include department number for each employee along with that employee’s 
-- employee number, last name, first name, and department name
DROP TABLE IF EXISTS employee_of_departments;
CREATE TABLE employee_of_departments(
	dept_no INT NOT NULL,
	emp_no INT NOT NULL,
	last_name VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL, 
	dept_name VARCHAR NOT NULL
);

SELECT * FROM employee_of_departments;

SELECT department_employees.dept_no, e.emp_no, e.last_name, e.first_name, departments.dept_name
FROM department_employees
INNER JOIN employees AS e ON
e.emp_no=department_employees.emp_no
INNER JOIN departments ON
department_employees.dept_no=departments.dept_no;

-- List first name, last name, and sex of each employee whose first name is Hercules 
-- and whose last name begins with the letter B 
DROP TABLE IF EXISTS name;
CREATE TABLE name (
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL, 
	sex VARCHAR NOT NULL 
);

SELECT * FROM name;

SELECT e.first_name, e.last_name, e.sex
FROM employees AS e
WHERE e.first_name LIKE 'Hercules'
AND e.last_name LIKE 'B%'

-- List each employee in the Sales department, including 
-- their employee number, last name, and first name 
DROP TABLE IF EXISTS sales_employees;
CREATE TABLE sales_employees(
	emp_no INT NOT NULL,
	last_name VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL
);

SELECT * FROM sales_employees;

SELECT e.emp_no, e.last_name, e.first_name
FROM employees AS e
INNER JOIN department_employees AS de ON 
e.emp_no=de.emp_no
INNER JOIN departments AS d ON
de.dept_no=d.dept_no
WHERE d.dept_name = 'Sales';

-- List each employee in the Sales and Development departments, 
-- including their employee number, last name, first name,
-- and department name 
DROP TABLE IF EXISTS sales_dev_employees;
CREATE TABLE sales_dev_employees(
	emp_no INT NOT NULL,
	last_name VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL
);

SELECT * FROM sales_dev_employees;

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN department_employees AS de ON 
e.emp_no=de.emp_no
INNER JOIN departments AS d ON
de.dept_no=d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

-- List the frequency counts, in descending order, of all the employees last name
-- (this is, how many employees share each last name)
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;