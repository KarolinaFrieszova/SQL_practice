-- Find employees not based in Brasil.
SELECT *
FROM employees
WHERE country != 'Brazil';

-- Find all the employees working 0.5 full-time equivalent hours or greater.
SELECT *
FROM employees
WHERE fte_hours >= 0.5;

-- Find all the employees in China who started working for OmniCorp in 2019.
SELECT *
FROM employees
WHERE country = 'China' AND start_date >= '2019-01-01' AND start_date <= '2019-12-31';

/*
 * Of all employees based in China, find those who either started working
 * for OmniCorp from 2019 onwords or who are enrolled in pension scheme.
 */
SELECT *
FROM employees
WHERE country = 'China' AND (start_date >= '2019-01-01' OR pension_enrol = TRUE);

-- Find all employees who work between 0.25 and 0.5 full-time equivalent hours inclusive.
SELECT *
FROM employees
WHERE fte_hours >= 0.25 AND fte_hours <= 0.5;


-- Find all employees who started working for OmniCorp in years other than 2017.
SELECT *
FROM employees
WHERE start_date < '2017-01-01' OR start_date > '2017-01-31';

SELECT *
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5;

SELECT *
FROM employees
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-01-31';

-- Find all employees who started work at OmniCorp in 2016 who work 0.5 full time equivalent hours or greater.
SELECT *
FROM employees
WHERE (start_date BETWEEN '2016-01-01' AND '2016-01-31') AND (fte_hours >= 0.5);

-- Find all employees based in Spain, South Africa, Ireland or Germany.
SELECT *
FROM employees
WHERE country = 'Spain' OR country = 'South Africa' OR country = 'Ireland' OR country = 'Germany';

SELECT *
FROM employees
WHERE country IN ('Spain', 'South Africa', 'Ireland', 'Germany');

-- Find all employees based in countries other than Finland, Argentina or Canada.
SELECT *
FROM employees 
WHERE country NOT IN ('Agrentina', 'Finland', 'Canada');

/*
 * I was talking with a colleague from Greece last month, I can’t remember their 
 * last name exactly, I think it began ‘Mc…’ something-or-other. Can you find them?
 */
SELECT *
FROM employees 
WHERE country = 'Greece' AND last_name LIKE 'Mc%';

-- Find all employees with last names containing the phrase ‘ere’ anywhere.
SELECT *
FROM employees
WHERE last_name LIKE '%ere%';

-- Find all employees in the Legal department with a last name beginning with ‘D’.
SELECT *
FROM employees 
WHERE department = 'Legal' AND last_name LIKE 'D%';

-- Find all employees having ‘a’ as the second letter of their first names.
SELECT *
FROM employees 
WHERE first_name LIKE '_a%';

-- Find all employees whose last name contains the letters ‘ha’ anywhere.
SELECT *
FROM employees 
WHERE last_name LIKE '%ha%';

-- We need to ensure our employee records are up-to-date. Find all the employees who do not have a listed email address.
SELECT *
FROM employees 
WHERE email IS NULL;