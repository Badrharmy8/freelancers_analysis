CREATE DATABASE Freelancers;
USE Freelancers;


-- What is the gender distribution in the freelance workforce (percentage of males vs. females)?
SELECT gender,
	FORMAT(CAST(COUNT(freelancer_id) AS FLOAT) / 
	(SELECT COUNT(gender) FROM Freelancers) , 'P2') AS 'freelancers'
FROM Freelancers
GROUP BY gender;

-- What is the average hourly rate by gender (male vs. female freelancers)?
SELECT gender,
	ROUND(AVG([hourly_rate (USD)]) , 2) AS 'rate average'
FROM Freelancers
GROUP BY gender;

-- Which top 10 countries has the highest number of freelancers?
SELECT TOP 10 country,
	FORMAT(CAST(COUNT(freelancer_ID) AS FLOAT) / 
	(SELECT COUNT(freelancer_ID) FROM Freelancers), 'P2') AS 'freelancers'
FROM Freelancers
GROUP BY country
ORDER BY freelancers DESC;

-- What is the most common freelance field in each country?
SELECT country , 
	primary_skill,
	FORMAT(freelancers , 'P') AS freelancers
FROM(
SELECT *,
	RANK() OVER(PARTITION BY country ORDER BY freelancers DESC) AS ranked
FROM(
SELECT  country , 
	primary_skill,
	ROUND(CAST(COUNT(freelancer_ID) AS FLOAT) /
	SUM(COUNT(freelancer_ID)) OVER(PARTITION BY country) , 2) AS freelancers
FROM Freelancers
GROUP BY country, primary_skill) AS freelance) AS ranked
WHERE ranked = 1;

-- What is the average client satisfaction rating for freelancers from each country?
SELECT country,
	ROUND(AVG(client_satisfaction) , 2)  AS client_satisfaction
FROM Freelancers
GROUP BY country
ORDER BY client_satisfaction DESC;

-- what percentage of active and inactive
SELECT 
CASE
	WHEN is_active = 0 THEN 'active'
	ELSE 'not active'
END AS  status,
	FORMAT(CAST(COUNT(is_active) AS FLOAT) /
	(SELECT COUNT(is_active)
	FROM Freelancers) , 'P2') AS percentage
FROM Freelancers
GROUP BY is_active;

-- What percentage of freelancers in each country are active?
SELECT country,
CASE
	WHEN is_active = 0 THEN 'active'
	ELSE 'not active'
END AS  status,
	FORMAT(CAST(COUNT(is_active) AS FLOAT) / SUM(COUNT(is_active)) OVER(PARTITION BY country) , 'P2')
	AS status
FROM Freelancers
GROUP BY country , is_active;

-- what average hourly rate for each country?
SELECT country,
	ROUND(AVG([hourly_rate (USD)]) , 2) AS 'average hour rate'
FROM Freelancers
GROUP BY country
ORDER BY [average hour rate] DESC;

-- what average hourly rate for each primary skill over countries?
SELECT country,
	 primary_skill,
	ROUND(AVG([hourly_rate (USD)]) , 2) AS 'average hour rate'
FROM Freelancers
GROUP BY country , primary_skill;

-- top language for freelancers
SELECT language,
	CAST(COUNT(freelancer_ID)AS FLOAT) AS freelancers
FROM Freelancers
GROUP BY language
ORDER BY  freelancers DESC;


-- Average years of experience for each feild
SELECT primary_skill,
	ROUND(AVG(years_of_experience) ,2)AS years_of_experience
FROM Freelancers
GROUP BY primary_skill;