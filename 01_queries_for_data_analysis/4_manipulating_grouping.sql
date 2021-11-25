SELECT id, first_name, last_name
FROM employees 
WHERE department = 'Accounting';

SELECT CONCAT('Hello', ' ', 'there!') AS greeting;

SELECT 'Hello' || ' ' || 'there!' AS greeting;

SELECT id, first_name, last_name, CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

SELECT id, first_name, last_name, CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE first_name IS NOT NULL AND last_name IS NOT NULL;

SELECT 
	DISTINCT(department)
FROM employees;

SELECT 
	COUNT(*)
FROM employees
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';

SELECT 
	COUNT(*) AS total_employ_2001
FROM employees
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';

SELECT 
	MIN(salary) AS min_salary,
	MAX(salary) AS max_salary
FROM employees;

SELECT 
	AVG(salary) AS avg_HR_salary
FROM employees
WHERE department = 'Human Resources';

SELECT 
	SUM(salary) AS total_expense_2018
FROM employees
WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';

SELECT *
FROM employees
WHERE salary IS NOT NULL 
ORDER BY salary ASC 
LIMIT 1;

SELECT *
FROM employees
ORDER BY salary ASC NULLS LAST
LIMIT 1;

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 1;

SELECT *
FROM employees 
ORDER BY
	fte_hours DESC NULLS LAST,
	last_name ASC NULLS LAST;
	
SELECT *
FROM employees 
ORDER BY start_date ASC NULLS LAST;

SELECT *
FROM employees 
WHERE country = 'Libya'
ORDER BY salary DESC NULLS LAST
LIMIT 1;

-- num of employ within each department of the corp; display in desc order

SELECT 
	department,
	COUNT(id) AS num_employees
FROM employees 
GROUP BY department
ORDER BY num_employees DESC;

-- num of employ in each country

SELECT 
	country,
	COUNT(id) AS num_country
FROM employees 
GROUP BY country;

-- num of employ per department work either 0.25 or 0.5 hours

SELECT 
	department,
	COUNT(id) AS num_par_time
FROM employees 
WHERE fte_hours IN (0.25, 0.5)
GROUP BY department;

SELECT 
	COUNT(first_name) AS count_first_name,
	COUNT(id) AS count_id,
	COUNT(*) AS count_star
FROM employees;

-- longest time served by any one employee in each depoartment

SELECT 
	department,
	NOW()-MIN(start_date) AS longest_time
FROM employees
GROUP BY department;

SELECT 
	department,
	EXTRACT(DAY FROM NOW()-MIN(start_date)) AS longest_time,
	ROUND(EXTRACT(DAY FROM NOW()-MIN(start_date))/365) AS longest_time
FROM employees
GROUP BY department;

-- num of employ per department enrolled in pension scheme

SELECT 
	department,
	COUNT(id) AS num_pension
FROM employees
WHERE pension_enrol = TRUE
GROUP BY department;

-- num of employ per country that do not have stored first name

SELECT 
	country,
	COUNT(id) AS num_no_fisrt_name
FROM employees 
WHERE first_name IS NULL 
GROUP BY country;

-- show depertments in which at least 40 employees work either 0.25 or 0.5 h 

SELECT 
	department,
	COUNT(id) AS num_employ
FROM employees 
WHERE fte_hours IN (0.25, 0.5)
GROUP BY department 
HAVING COUNT(id) >= 40;

-- show any country in which the min salary amongst pension enrolled employ is less than 21000$

SELECT 
	country,
	MIN(salary) AS min_salary
FROM employees 
WHERE pension_enrol = TRUE
GROUP BY country 
HAVING MIN(salary) < 21000;

-- any department in which the earliest start date amongst grade 1 employees is prior to 1991

SELECT 
	department,
	MIN(start_date) AS earliest_start
FROM employees
WHERE grade = 1
GROUP BY department 
HAVING MIN(start_date) < '1991-01-01';

-- find all employees in Japane who earn over the company-wide average salary

SELECT *
FROM employees 
WHERE country = 'Japan' AND salary > (SELECT AVG(salary) FROM employees);

-- avg salary

SELECT AVG(salary)
FROM employees;

-- find all employees in legal who earn less than the mean salary in that same department

SELECT *
FROM employees
WHERE department = 'Legal' AND salary < (SELECT AVG(salary) FROM employees WHERE department = 'Legal');

-- find all the employees in the USA who work the most common full time equivalent hours across the corporation

SELECT
 fte_hours
FROM employees 
GROUP BY fte_hours
HAVING COUNT(id) = (
	SELECT MAX(c) AS max_count
	FROM(
		SELECT COUNT(id) AS c
		FROM employees 
		GROUP BY fte_hours 
		) AS t
	)
	
SELECT *
FROM employees 
WHERE country = 'United States' AND fte_hours = (
	SELECT
 	fte_hours
	FROM employees 
	GROUP BY fte_hours
	HAVING COUNT(id) = (
		SELECT MAX(c) AS max_count
		FROM(
			SELECT COUNT(id) AS c
			FROM employees 
			GROUP BY fte_hours 
		) AS t
	)
)






