SELECT *
FROM employees
WHERE country != 'Brazil';

SELECT *
FROM employees
WHERE fte_hours >= 0.5;

SELECT *
FROM employees
WHERE country = 'China' AND start_date >= '2019-01-01' AND start_date <= '2019-12-31';

SELECT *
FROM employees
WHERE country = 'China' AND (start_date >= '2019-01-01' OR pension_enrol = TRUE);

SELECT *
FROM employees
WHERE fte_hours >= 0.25 AND fte_hours <= 0.5;

SELECT *
FROM employees
WHERE start_date < '2017-01-01' OR start_date > '2017-01-31';

SELECT *
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5;

SELECT *
FROM employees
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-01-31';

SELECT *
FROM employees
WHERE (start_date BETWEEN '2016-01-01' AND '2016-01-31') AND (fte_hours >= 0.5);

SELECT *
FROM employees
WHERE country = 'Spain' OR country = 'South Africa' OR country = 'Ireland' OR country = 'Germany';

SELECT *
FROM employees
WHERE country IN ('Spain', 'South Africa', 'Ireland', 'Germany');

SELECT *
FROM employees 
WHERE country NOT IN ('Agrentina', 'Finland', 'Canada');

SELECT *
FROM employees 
WHERE country = 'Greece' AND last_name LIKE 'Mc%';

SELECT *
FROM employees
WHERE last_name LIKE '%ere%';

SELECT *
FROM employees 
WHERE department = 'Legal' AND last_name LIKE 'D%';

SELECT *
FROM employees 
WHERE first_name LIKE '_a%';

SELECT *
FROM employees 
WHERE last_name LIKE '%ha%';

SELECT *
FROM employees 
WHERE email IS NULL;







