# Pewlett-Hackard-Analysis
Module 07 of UofT Data Analytics Boot Camp

### Project Objective
To analyze the Human Resource (HR) data of Pewlett Hackard (PH) to better prepare for the rapid retirement of baby boomers.

Project is broken down to 2 key parts.
1. Create SQL Database for HR data from CSV files provided
2. Conduct detailed analysis on the retirement of baby boomers


### 1. Preparing SQL Database
From 6 CSV files provided by HR, SQL Database for HR department was created based on the ERD design shown below.

![EmployeeDB](EmployeeDB.png)


### 2. HR Data Analysis
```sql
SELECT 	e.emp_no, first_name, last_name, birth_date, hire_date,
		dept_name, title, t.from_date title_from, salary
INTO current_employees_full
FROM employees e
INNER JOIN titles t ON e.emp_no = t.emp_no
LEFT JOIN salaries s ON e.emp_no = s.emp_no
LEFT JOIN dept_emp de ON e.emp_no = de.emp_no
LEFT JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01';		-- Include only current employees
```