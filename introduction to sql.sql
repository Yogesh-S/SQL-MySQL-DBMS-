#to print statements in the console
SELECT 'SQL is cool' AS result;

# Arithmetic symbols (+, -, *, /)
SELECT (4 * 3);
SELECT (4 / 3);            #returns result in int (according to the course)
SELECT (4.0 / 3.0);        #returns result in float

# SELECTing single columns
SELECT title from films;
SELECT name from people;

# SELECTing multiple columns
SELECT title,release_year
FROM films;
SELECT *
FROM films;

# SELECT DISTINCT
SELECT DISTINCT release_year, country        #returns unique combinations of the two columns
FROM films;

# Learning to COUNT
SELECT COUNT(*)
FROM people;
SELECT COUNT(birthdate)           #number of (non-missing) birth dates
FROM people;
SELECT COUNT(DISTINCT birthdate)  #number of unique birth dates
FROM people;

# Simple filtering of numeric values (WHERE clause)
SELECT *
FROM films
where release_year = 2016;        #<, >, <=, >=

SELECT *
FROM films
WHERE language = 'French';

SELECT name, birthdate
FROM people
WHERE birthdate = '11/11/1974';

#WHERE with AND/OR for multiple conditions
SELECT *
FROM films
WHERE language = 'Spanish'       #Can use OR instead of AND
AND release_year > 2000
AND release_year < 2010;        

# AND with OR
SELECT title, release_year
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')
AND (gross > 2000000);

# BETWEEN
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
AND budget > 100000000
AND (language = 'Spanish' OR language = 'French');

# WHERE IN
select title, release_year
from films
where release_year IN (1990,2000)
AND duration > 120;

select title, language
from films
where language in ('English','Spanish','French');    #Text in single quotes

# NULL
select count(*)
from people
where deathdate is null;

select count(*)
from people
where deathdate is not null;

# LIKE and NOT LIKE
select name
from people
where name like 'B%';       #begin with 'B'

select name
from people
where name like '_r%';      #'r' as the second letter

select name
from people
where name not like 'A%';   #don't start with A

# Aggregate functions
select sum(duration)        #avg, min, max
from films;
select max(gross)
from films
where release_year between 2000 and 2012;

# AS aliasing
SELECT title, (duration/60.) as duration_hours
from films;
select avg(duration)/60.0 as avg_duration_hours                 #average duration in hours for all films, aliased as avg_duration_hours
from films;
select count(deathdate) * 100.0 / count(*) as percentage_dead   #percentage of people who are no longer alive. Alias the result as percentage_dead
from people;
select max(release_year) - min(release_year) as difference      #number of years between the newest film and oldest film. Alias the result as difference
from films;
select (max(release_year) - min(release_year))/10. as number_of_decades  #number of decades the films table covers. Alias the result as number_of_decades
from films;

# Sorting
select *
from films
where release_year not in (2015)
order by duration;
select title, duration
from films
order by duration desc;
select certification, release_year, title            #order by multiple columns
from films
order by certification, release_year;

# Group by
select release_year, avg(duration)
from films
group by release_year;
select release_year, country, max(budget)
from films
group by release_year, country
order by release_year, country;                    #always put the ORDER BY clause at the end of query

# HAVING (aggregate functions can't be used in WHERE clauses)
SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10;

/* Write a query that returns the average budget as avg_budget and average gross earnings as avg_gross for films in each year after 1990,
if the average budget is greater than $60 million. Modify your query to order the results from highest average 
gross earnings to lowest.
Note: If both order by and group by are used in single query, order by goes after group by*/
SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
order by avg(gross) desc;

/*Get the country, average budget, and average gross take of countries that have made more than 10 films. Order the result by country name,
and limit the number of results displayed to 5. You should alias the averages as avg_budget and avg_gross respectively.
Note :  You can use the LIMIT keyword to limit the number of rows returned*/
select country, avg(budget) as avg_, avg(gross)
from films
group by country
having count(country) > 10
order by country
limit 5;

# Duplicate the table
CREATE TABLE films2 AS SELECT * FROM films;

# INSERT INTO
INSERT INTO films2 (id, title, release_year)
VALUES (10000, 'Test Movie', 2020);

/*If you are adding values for all the columns of the table, you do not need to specify the column names in the SQL query.
However, make sure the order of the values is in the same order as the columns in the table.*/
INSERT INTO films2
VALUES (10001, 'Movie 2', 2020, 'IN',180,'XYZ','XYZ',1000000,5000000);

# UPDATE (to modify the existing records in a table)
/* *** In MySQL update & delete query does not work because the safe mode is enabled by default. Disable it using
Edit > Preferences > Sql Editor > uncheck the "Safe Updates"
Note - try reconnecting the server (Query > Reconnect to Server) and than run your query again. */
update films2
set country = 'IN', duration = 145
where id = 10000;

# DELETE
delete from films2
where id = 10001;

# JOINS (clause is used to combine rows from two or more tables, based on a related column between them)

# INNER JOIN (selects records that have matching values in both tables)
select reviews.film_id, films2.title, films2.release_year, reviews.imdb_score  #Use * to display all columns from both tables
from films2                                                  #any table name
inner join reviews on films2.id = reviews.film_id            #remaining table name
order by film_id;

# LEFT JOIN (returns all records from the left table (table1), and the matching records from the right table (table2))
select reviews.film_id, films2.title, films2.release_year, reviews.imdb_score  #Use * to display all columns from both tables
from films2                                                  #left table name
left join reviews on films2.id = reviews.film_id             #right table name
order by film_id;

# RIGHT JOIN (returns all records from the right table (table2), and the matching records from the left table (table1))
select reviews.film_id, films2.title, films2.release_year, reviews.imdb_score #Use * to display all columns from both tables
from films2                                                  #left table name
right join reviews on films2.id = reviews.film_id            #right table name
order by film_id;

# FULL OUTER JOIN (returns all records when there is a match in left (table1) or right (table2) table records)
select *
from films2                                                  #left table name
left join reviews on films2.id = reviews.film_id             #right table name
union
select *
from films2                                                  #left table name
right join reviews on films2.id = reviews.film_id            #right table name
order by film_id;

# SELF JOIN (It is a regular join, but the table is joined with itself. Self join matches countries that are from same continent)
# Below tabel is from 'world' database
SELECT A.Name AS Name1, B.Name AS Name2, A.Continent
FROM country A, country B
WHERE A.Code <> B.Code
AND A.Continent = B.Continent	
ORDER BY A.Continent;

# UNION Operator
/*The UNION operator is used to combine the result-set of two or more SELECT statements.

Every SELECT statement within UNION must have the same number of columns
The columns must also have similar data types
The columns in every SELECT statement must also be in the same order*/

SELECT CountryCode FROM city
UNION
SELECT Name FROM country;

# The UNION operator selects only distinct values by default. To allow duplicate values, use UNION ALL
SELECT CountryCode FROM city
UNION ALL
SELECT Name FROM country;

/* # Create Database
CREATE DATABASE databasename;

# Drop Database
DROP DATABASE databasename;

# Create Table
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype,
   ....
);

# Drop Table
DROP TABLE table_name;