-- get a list of all animals that have diet plans together with diet plans that they are on

SELECT *
FROM animals a
INNER JOIN diets d
ON a.diet_id = d.id;

-- find any known dietary requirements for animals over four years old

SELECT *
FROM animals AS a 
INNER JOIN diets AS d
ON a.diet_id = d.id
WHERE a.age > 4;

-- breakdown the number of animals in the zoo by their diet type 

SELECT
	d.diet_type,
	COUNT(a.id) AS diet_count
FROM animals a 
INNER JOIN diets AS d
ON a.diet_id = d.id
GROUP BY d.diet_type;

-- get details of all herbivores in the zoo

SELECT *
FROM animals a 
INNER JOIN diets d 
ON a.diet_id = d.id
WHERE d.diet_type = 'herbivore';

-- return details of all animals in zoo, together with their dietary requirements if they have any

SELECT *
FROM animals a 
LEFT JOIN diets d 
ON a.diet_id = d.id;

-- right join 

SELECT *
FROM animals a 
RIGHT JOIN diets d 
ON a.diet_id = d.id;

-- return how many animals follow each diet type, including any diets which no animals follow 

SELECT
	d.diet_type,
	COUNT(a.id) AS animal_count
FROM animals AS a 
RIGHT JOIN diets AS d
ON a.diet_id = d.id
GROUP BY d.diet_type;

-- got a rota for the keepers and the animals they look after, ordered first by animal name, and then by day 

SELECT 
	a.species,
	cs.day,
	k.name AS keeper_name
FROM (animals a 
	INNER JOIN care_schedule cs 
	ON a.id = cs.animal_id)
INNER JOIN keepers k
ON cs.keeper_id = k.id
ORDER BY a.name, cs.day;

-- weekly scheduly for only Ernest the Snake

SELECT 
	cs.day,
	k.name AS keeper_name
FROM (animals a 
	INNER JOIN care_schedule cs 
	ON a.id = cs.animal_id)
INNER JOIN keepers k
ON cs.keeper_id = k.id
WHERE a.species = 'Snake';

-- self joins

SELECT *
FROM keepers;

-- get a table showing the name of each keeper, together with their manage's name (if they have a manger)

SELECT
	k.name AS keeper,
	k2.name AS manager
FROM keepers k 
LEFT JOIN keepers k2 
ON k.manager_id = k2.id;

-- Union (removes duplicate rows)

SELECT *
FROM animals
UNION 
SELECT *
FROM animals;

-- union all

SELECT *
FROM animals
UNION ALL
SELECT *
FROM animals;

-- Return all the entries in the animals table that do not have a matching entry in diet table

SELECT *
FROM animals a 
LEFT JOIN diets d 
ON a.diet_id = d.id 
WHERE d.id IS NULL;

-- shortcuts for group_by and order_by

SELECT 
	a.name AS animal_name,
	cs.day,
	k.name AS keeper_name
FROM (animals a 
	INNER JOIN care_schedule cs
	ON a.id = cs.animal_id)
INNER JOIN keepers k 
ON cs.keeper_id = k.id 
ORDER BY a.name, cs.day;

SELECT 
	a.name AS animal_name,
	cs.day,
	k.name AS keeper_name
FROM (animals a 
	INNER JOIN care_schedule cs
	ON a.id = cs.animal_id)
INNER JOIN keepers k 
ON cs.keeper_id = k.id 
ORDER BY 1, 2;