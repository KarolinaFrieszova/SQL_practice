/* Common Table Expressions */

-- Add a column for each employee showing the ratio of their salary to the average salary of their team

SELECT
	t.id,
	t.name AS team_name,
	ROUND(AVG(e.salary)) AS team_avg
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
GROUP BY t.id;

SELECT 
	*,
	round(e.salary / team_averages.team_avg, 2) AS salary_over_team_avg
FROM employees e
INNER JOIN (SELECT
				t.id,
				t.name AS team_name,
				ROUND(AVG(e.salary)) AS team_avg
			FROM employees e
			INNER JOIN teams t
			ON e.team_id = t.id
			GROUP BY t.id) AS team_averages
ON e.team_id = team_averages.id
ORDER BY e.team_id;

-- rewrite with CTE

WITH team_averages(id, team_name, team_avg) AS (
	SELECT
		t.id,
		t.name,
		ROUND(AVG(e.salary))
	FROM employees e
	RIGHT JOIN teams t
	ON e.team_id = t.id
	GROUP BY t.id
	)
SELECT 
	*,
	ROUND(e.salary / team_averages.team_avg, 2) AS salary_over_team_avg
FROM employees e 
INNER JOIN team_averages
ON e.team_id = team_averages.id
ORDER BY e.team_id;

-- country averages

WITH country_averages(country, country_avg) AS (
	SELECT 
		country,
		AVG(salary)
	FROM employees
	GROUP BY country
	)
SELECT 
	e.first_name,
	e.last_name,
	country_averages.country AS country,
	e.salary,
	ROUND(e.salary / country_averages.country_avg, 3) AS salary_over_country_avg
FROM employees e
INNER JOIN country_averages
ON e.country = country_averages.country
ORDER BY e.country;

-- two CTE

WITH team_averages(id, team_name, team_avg) AS (
	SELECT
		t.id,
		t.name,
		ROUND(AVG(e.salary))
	FROM employees e
	RIGHT JOIN teams t
	ON e.team_id = t.id
	GROUP BY t.id
	),
	country_averages(country, country_avg) AS (
	SELECT 
		country,
		AVG(salary)
	FROM employees
	GROUP BY country
	)
SELECT 
	e.first_name,
	e.last_name,
	country_averages.country AS country,
	team_averages.team_name,
	e.salary,
	ROUND(e.salary / country_averages.country_avg, 2) AS salary_over_country_avg,
	ROUND(e.salary / team_averages.team_avg, 2) AS salary_over_team_avg
FROM employees e 
INNER JOIN team_averages
ON e.team_id = team_averages.id
INNER JOIN country_averages
ON e.country = country_averages.country
ORDER BY e.team_id;

/* Window Functions */

SELECT 
	SUM(salary)
FROM employees; 

SELECT 
	first_name,
	last_name,
	salary,
	SUM(salary) OVER () AS sum_salary
FROM employees;

SELECT 
	first_name,
	last_name,
	salary,
	(SELECT 
		SUM(salary)
	FROM employees) AS sum_salary
FROM employees;

/* Get a table of employees' names, salaries and start dates ordered by start date, together with a running
 * total of salaries by start date */

SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
	salary,
	start_date,
	SUM(salary) OVER (ORDER BY start_date ASC) AS running_total_salary
FROM employees;

-- Rank empoyees in order by their start date with the corporation

SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
	start_date,
	RANK() OVER (ORDER BY  start_date) AS start_rank,
	DENSE_RANK() OVER (ORDER BY  start_date) AS start_dense_rank,
	ROW_NUMBER() OVER (ORDER BY  start_date) AS start_row_num
FROM employees;

/* Split the salaries of employees into four groups corresponding to the 'quartiles' of salary (so, 
 * for example, group 1 will contain the lowest 25%, group two next lowest 25%, and so on) */

SELECT 
	salary,
	NTILE(4) OVER (ORDER BY salary) AS salary_group
FROM employees;

SELECT *	
FROM (SELECT 
		department,
		salary,
		NTILE(4) OVER (ORDER BY salary) AS salary_group 
	FROM employees) AS s
WHERE salary_group = 3;

-- Does each group contain 250 rows?

WITH grouped_salaries(salary_group) AS (
	SELECT 
		NTILE(4) OVER (ORDER BY salary)
	FROM employees 
	)
SELECT 
	*,
	COUNT(*) AS num_in_group
FROM grouped_salaries 
GROUP BY salary_group;

-- Show for each employee the number of other employees who are members of the same department as them

SELECT 
	last_name,
	department,
	COUNT(id) OVER (PARTITION BY department) - 1 AS num_of_other_employ
FROM employees
ORDER BY last_name;

-- Show for each employee the number of employees who started in the same month as them

SELECT 
	last_name,
	EXTRACT(MONTH FROM start_date) AS start_month,
	EXTRACT(YEAR FROM start_date) AS start_year,
	COUNT(id) OVER (PARTITION BY EXTRACT(YEAR FROM start_date), EXTRACT(MONTH FROM start_date))
FROM employees;

SELECT 
	last_name,
	start_date,
	TO_CHAR(start_date, 'Month') || ' ' || TO_CHAR(start_date, 'yyyy') AS start_month,
	COUNT(*) OVER (
		PARTITION BY EXTRACT(YEAR FROM start_date), EXTRACT(MONTH FROM start_date)
		) AS num_that_month
FROM employees;

SELECT 
	last_name,
	start_date,
	CONCAT(TO_CHAR(start_date, 'Month'), ' ', TO_CHAR(start_date, 'yyyy')) AS start_month,
	COUNT(*) OVER (
		PARTITION BY EXTRACT(YEAR FROM start_date), EXTRACT(MONTH FROM start_date)
		) AS num_that_month
FROM employees;

/* Get a table of employee id, first and last name, grade and salary, together with two new columns 
 * showing the maximum salary and minimum salary for employees of their grade. */

SELECT 
	id,
	first_name,
	last_name,
	grade,
	salary,
	MAX(salary) OVER (PARTITION BY grade) AS max_salary,
	MIN(salary) OVER (PARTITION BY grade) AS min_salary
FROM employees
ORDER BY id;

-- Add a column for each employee showing the ratio of their salary to the average of their team

SELECT 
	first_name || ' ' || last_name AS full_name,
	salary,
	t.name AS team_name,
	ROUND(e.salary / AVG(e.salary) OVER (PARTITION BY e.team_id),2) AS team_ratio,
	ROUND(e.salary / AVG(e.salary) OVER (PARTITION BY e.country), 2) AS country_ratio
FROM employees e 
INNER JOIN teams t 
ON e.team_id = t.id
ORDER BY team_ratio DESC NULLS LAST;

/* Get a table of employees showing the order in which they started work with the corporation 
 * split by depart by department. */

SELECT 
	first_name || ' ' || last_name AS employ_name,
	start_date,
	department,
	RANK() OVER (PARTITION BY department ORDER BY start_date)
FROM employees
ORDER BY start_date;

-- Find name of the employee that started to work first, per each department

SELECT *
FROM (SELECT 
		first_name || ' ' || last_name AS employ_name,
		start_date,
		department,
		RANK() OVER (PARTITION BY department ORDER BY start_date) AS ranking
	FROM employees) AS t
WHERE ranking = 1;



