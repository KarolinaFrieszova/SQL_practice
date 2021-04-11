-- Get a table of all employees details, with their local account number and local sort code, if they have one

SELECT 
	e.*,
	pd.local_account_no,
	pd.local_sort_code 
FROM employees e 
LEFT JOIN pay_details pd 
ON e.pay_detail_id = pd.id;

-- Add to above name of the team that each each employee belongs to 

SELECT 
	e.*,
	pd.local_account_no,
	pd.local_sort_code,
	t.name AS team_name
FROM employees e 
LEFT JOIN pay_details pd 
ON e.pay_detail_id = pd.id
LEFT JOIN teams t
ON e.team_id = t.id;

/* Find first name, last name and team name of employees who are members of teams for which the charge cost 
 * is greater than 80. Order the employees alphabetically by last name. */

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	t.charge_cost 
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS INT) > 80
ORDER BY e.last_name;

/* Breakdown the number of employees in each of the teams, including any teams without members.
* Order table by increasing size of team. */

SELECT 
	t.name,
	COUNT(*) AS num_employ
FROM employees e
RIGHT JOIN teams t
ON e.team_id = t.id 
GROUP BY t.name
ORDER BY num_employ ASC;

/* The effective_salary of an employee is defined as their fte_hours multiplied by their salary.
* Get a table for each employee showing their id, first name, last name, fte_hours, salary and 
* effective_salary, along with a running total of effective_salary with employees placed in 
* ascending order od effective_salary. */

SELECT 
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_salary,
	SUM(fte_hours * salary) OVER (ORDER BY fte_hours * salary ASC) AS running_total
FROM employees
-- ORDER BY effective_salary ASC - returns same results

/* The total-day_charge of a team is defined as the charge_cost of the team multiplied by the number
* of employees in the team. Calculate the total_day_charge for each team. */

SELECT 
	t.name AS team_name,
	COUNT(e.id) * t.charge_cost::INT AS total_day_charge
FROM employees e 
RIGHT JOIN teams t 
ON e.team_id = t.id
GROUP BY t.id;

/* How would you amend your query from quesion above to show only those teams with
 * a total_day_charge greater than 5000? */

SELECT *
FROM (SELECT 
		t.name AS team_name,
		COUNT(e.id) * t.charge_cost::INT AS total_day_charge
	FROM employees e 
	RIGHT JOIN teams t 
	ON e.team_id = t.id
	GROUP BY t.id
	) AS t
WHERE total_day_charge > 5000;

SELECT 
	t.name AS team_name,
	COUNT(e.id) * t.charge_cost::INT AS total_day_charge
FROM employees e 
RIGHT JOIN teams t 
ON e.team_id = t.id
GROUP BY t.id
HAVING COUNT(e.id) * t.charge_cost::INT > 5000;

-- How many employees serve on one or more committee?

SELECT
	COUNT(DISTINCT(employee_id))
FROM employees_committees;


	