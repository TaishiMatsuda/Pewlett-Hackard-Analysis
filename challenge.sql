--	Part 1. Step 1. Create a list of current employees with details
-- 	including their name, department, job title and salary
SELECT 	e.emp_no, first_name, last_name, birth_date, hire_date,
		dept_name, title, t.from_date title_from, salary
INTO current_employees_full
FROM employees e
INNER JOIN titles t ON e.emp_no = t.emp_no
LEFT JOIN salaries s ON e.emp_no = s.emp_no
LEFT JOIN dept_emp de ON e.emp_no = de.emp_no
LEFT JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01';		-- Include only current employees

-- Step 2. Create a list of current employees with current job title
SELECT 	emp_no, first_name, last_name, birth_date, hire_date,
		dept_name, title, title_from, salary
INTO current_employees_current_job
FROM (SELECT *, 
	 ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY title_from DESC) AS JobCount
	 FROM current_employees_full
	) withjobcount
WHERE JobCount = 1;

-- Step 3. Create a list of candidates for a supervisory role
-- Candidates:	Employees born in 1965
SELECT * 
INTO candidates_supervisor
FROM current_employees_current_job
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';	


-- Retiring Employees / Candidates for part-time mentoring role
-- Candidates: 	Employees born between 1952 and 1955 &
--				Employees hired between 1985 and 1988
SELECT COUNT(*)
FROM current_employees_current_job
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
	AND hire_date BETWEEN '1985-01-01' AND '1988-12-31';

-- Retirement per Department by birth year
SELECT	dept_name AS "Department",
		COUNT(*) FILTER (WHERE EXTRACT(YEAR from birth_date) = 1952) AS "1952",
		COUNT(*) FILTER (WHERE EXTRACT(YEAR from birth_date) = 1953) AS "1953",
		COUNT(*) FILTER (WHERE EXTRACT(YEAR from birth_date) = 1954) AS "1954",
		COUNT(*) FILTER (WHERE EXTRACT(YEAR from birth_date) = 1955) AS "1955",
		COUNT(*) AS "TOTAL"
FROM current_employees_current_job
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
	AND hire_date BETWEEN '1985-01-01' AND '1988-12-31'
GROUP BY dept_name;

-- Retirement by Job Title
SELECT	title AS "JOB TITLE", COUNT(*)
FROM current_employees_current_job
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
	AND hire_date BETWEEN '1985-01-01' AND '1988-12-31'
GROUP BY title
ORDER BY COUNT(*) DESC;


-- Total New Hire (Employees hired within 4 years)
SELECT COUNT(*), MAX(hire_date)
FROM current_employees_current_job
WHERE hire_date >= '1996-01-01';

-- New Hire by Department & Title
SELECT dept_name AS "Department", title AS "JOB TITLE", COUNT(*)
FROM current_employees_current_job
WHERE hire_date >= '1996-01-01'
GROUP BY dept_name, title
ORDER BY COUNT(*) DESC;

-- Total Number of Candidates for Supervisor
SELECT COUNT(*)
FROM candidates_supervisor;

-- Candidates for Supervisor per Department and Job Title
SELECT dept_name AS "Department", title AS "JOB TITLE", COUNT(*)
FROM candidates_supervisor
GROUP BY dept_name, title
ORDER BY COUNT(*) DESC;