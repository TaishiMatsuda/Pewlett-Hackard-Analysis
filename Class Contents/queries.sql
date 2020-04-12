-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
	AND hire_date BETWEEN '1985-01-01' AND '1988-12-31';
	
-- Creating Table with employee eligible to retire
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
	AND hire_date BETWEEN '1985-01-01' AND '1988-12-31';
-- Checking the Table
SELECT * FROM retirement_info;

-- JOIN departments and dept_manager tables
SELECT d.dept_name, dm.emp_no, dm.from_date, dm.to_date
FROM departments d
INNER JOIN dept_manager dm ON d.dept_no = dm.dept_no;


-- List of employees currently working & eligible to retire
SELECT dept_no, count(ri.emp_no)
FROM retirement_info ri
LEFT JOIN dept_emp de ON ri.emp_no = de.emp_no
--WHERE to_date = '9999-01-01'
GROUP BY dept_no