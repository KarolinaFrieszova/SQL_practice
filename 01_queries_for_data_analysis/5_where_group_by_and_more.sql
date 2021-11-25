-- find employees who work in HR department

SELECT *
FROM employees 
WHERE department = 'Human Resources';

-- get first and last name, country of the employees who work in the Legal department

SELECT 
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal';

-- count the number of employees based in Portugal

SELECT 
	COUNT(id) AS num_portugal
FROM employees 
WHERE country = 'Portugal';

-- count the num of omploy based in either Spain or Portugal

SELECT 
	COUNT(id) AS num_spain_portugal
FROM employees 
WHERE country IN ('Spain', 'Portugal');

-- count number of pay_details lacking a local_account_no

SELECT 
	COUNT(id) AS no_pay_details
FROM employees 
WHERE pay_detail_id IS NULL;

-- get a table with employees first name, last name ordered alphabeticaly by last name

SELECT 
	first_name,
	last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST;

-- How many employees have a first_name beggining with 'F'?

SELECT 
	COUNT(id)
FROM employees 
WHERE first_name ILIKE 'f%';

-- Count the number of pension enrolled employees who started work with the corporation in 2003

SELECT 
	COUNT(id)
FROM employees 
WHERE pension_enrol = TRUE AND start_date BETWEEN '2003-01-01' AND '2003-12-31';

-- Count the number of pension enrolled employees not based in either France or Germany

SELECT 
	COUNT(id)
FROM employees 
WHERE pension_enrol IS TRUE AND country NOT IN ('France', 'Germany');

-- Obtain a count by department of the employees who started work with the corporation in 2013

SELECT 
	department,
	COUNT(id)
FROM employees 
WHERE start_date BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY department;

/* obtain a table showing department, fte_hours, and number of employees in each department 
who work each fte_hours patten. Order alphabeticaly by department, and then ascending order of hte-hours */

SELECT 
	department,
	fte_hours,
	COUNT(id)
FROM employees 
GROUP BY department, fte_hours
ORDER BY department ASC, fte_hours ASC;

/* Obtain a table showing any departments in which there are two or more employees lacking a stored first name.
Order the table in descending order of the number of employees lacking a first name, and then in alphabetical
order by department */

SELECT
	department,
	COUNT(id) AS no_first_name
FROM employees 
WHERE first_name IS NULL 
GROUP BY department 
HAVING COUNT(id) >= 2
ORDER BY no_first_name DESC, department ASC;

-- Find proportion of employees in each department who are grade 1

SELECT
	department,
	SUM(CAST(grade = 1 AS INT)) / CAST(COUNT(id) AS REAL) AS proportion_g_1
FROM employees
GROUP BY department;

SELECT
	department,
	SUM((grade = 1)::INT) / COUNT(id)::REAL AS proportion_g_1
FROM employees
GROUP BY department;

-- do a count by year of all employees, ordered most recent year last

SELECT
	COUNT(id) AS num_employ,
	EXTRACT(YEAR FROM start_date) AS start_year
FROM employees
GROUP BY start_year -- EXTRACT(YEAR FROM start_date)
ORDER BY start_year ASC NULLS LAST

/* Return first name, last name and salary of all employees together with a new column called salary_class
 * with a value 'low' where salary is less than 40,000 and value 'high' where salary is greater than or
 * equal to 40,000.*/

SELECT 
	first_name, 
	last_name, 
	salary,
	CASE
		WHEN salary < 40000 THEN 'low'
		WHEN salary IS NULL THEN NULL
		ELSE 'high'
	END AS salary_class
FROM employees;

/* The first two digits of the local_sort_code (e.g. digits 97 in code 97-09-24) in the pay_details table are
 * indicative of the region of an account. Obtain counts of the number of pay_details records bearing each 
 * set of first two digits? Make sure that the count of NULL local_sort_codes comes at the top of the table, 
 * and then order all subsequent rows first by counts in descending order, and then by the first two digits 
 * in ascending order */

SELECT 
	SUBSTRING(local_sort_code, 1, 2) AS region,
	COUNT(id) AS count_records
FROM pay_details
GROUP BY region
ORDER BY
	CASE 
		WHEN SUBSTRING(local_sort_code, 1, 2) IS NULL THEN 1
		ELSE 0
	END DESC,
	count_records DESC,
	region ASC
	
-- return only numeric part of the local_tax_code in pay_details table, preserving NULLs where they exist
	
SELECT 
	local_tax_code,
	REGEXP_REPLACE(local_tax_code, '\D', '', 'g') AS numeric_tax_code
FROM pay_details