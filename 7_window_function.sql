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
	