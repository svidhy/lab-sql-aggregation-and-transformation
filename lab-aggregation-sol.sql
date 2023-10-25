Use sakila;

-- 1. You need to use SQL built-in functions to gain insights relating to the duration of movies:
-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT MAX(length) AS max_duration, MIN(length) AS min_duration
FROM film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: Look for floor and round functions.
-- SELECT date_format(CONVERT(left(issued,6),date), '%d-%m-%Y') AS 'issued_date'
SELECT SEC_TO_TIME(ROUND(AVG(length)*60)) AS "AVG Movie Duration" -- Function returns seconds also
FROM film;

select CONCAT(FLOOR(AVG(length)/60),'h ',ROUND(MOD(AVG(length),60)),'m') -- This returns only hours and minutes.
FROM film;

-- 2. You need to gain insights related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT * FROM rental;
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS "Operating Days"
FROM rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT *, date_format(CONVERT(left(rental_date,10),date), '%M') AS 'Month', 
CASE
WHEN WEEKDAY(CONVERT(left(rental_date,10),date)) = 1 then 'Monday' 
WHEN WEEKDAY(CONVERT(left(rental_date,10),date)) = 2 then 'Tuesday' 
WHEN WEEKDAY(CONVERT(left(rental_date,10),date)) = 3 then 'Wednesday' 
WHEN WEEKDAY(CONVERT(left(rental_date,10),date)) = 4 then 'Thursday' 
WHEN WEEKDAY(CONVERT(left(rental_date,10),date)) = 5 then 'Friday' 
WHEN WEEKDAY(CONVERT(left(rental_date,10),date)) = 6 then 'Saturday' 
ELSE 'Sunday'
END AS 'Weekday'
FROM rental;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression
-- WEEKDAY method returns a number between 1 and 7 for each day of the week. 
SELECT *,
CASE
WHEN (WEEKDAY(CONVERT(left(rental_date,10),date)) BETWEEN 1 AND 5) then 'workday'
ELSE 'weekend'
END AS 'DAY_TYPE'
FROM rental;

-- 3. You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles 
-- and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. 
-- Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to 
-- handle such cases in the future. Hint: Look for the IFNULL() function..
SELECT * FROM film;

SELECT title, coalesce(length,'Not Available') AS rental_duration
FROM film
ORDER BY title ASC;

-- 4. Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
-- To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters 
-- of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. 
-- The results should be ordered by last name in ascending order to make it easier to use the data.
SELECT * from customer;

SELECT concat(first_name, " ", last_name) AS customer_name, substr(email, 1, 3) as email_letter
FROM customer
ORDER BY last_name ASC;

SELECT concat(first_name, " ", last_name, " ", substr(email, 1, 3)) AS customer_name
FROM customer
ORDER BY last_name ASC;

-- Challenge 2
-- 1. Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.
SELECT * FROM film;
SELECT COUNT(DISTINCT title) AS "Total Films"
FROM film;

SELECT COUNT(title) AS "Total Films"
FROM film;

-- 1.2 The number of films for each rating.
SELECT rating, COUNT(title) AS "Total Films"
FROM film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
SELECT rating, COUNT(title) AS "Total Films"
FROM film
GROUP BY rating
ORDER BY COUNT(title) DESC;
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.


-- Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
-- Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
SELECT rating, COUNT(title) AS "Total Films", ROUND(AVG(length),2) as "Mean Duration"
FROM film
GROUP BY rating
ORDER BY AVG(length) DESC;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
SELECT rating, COUNT(title) AS "Total Films", ROUND(AVG(length),2) as "Mean Duration"
FROM film
GROUP BY rating
HAVING AVG(length) > 120;

-- Bonus: determine which last names are not repeated in the table actor.
SELECT * FROM actor;

SELECT last_name as "Last Name"
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) = 1;
