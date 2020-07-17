--1.The example uses a WHERE clause to show the cases in 'Italy' in March.

--Modify the query to show data from Spain

SELECT name, DAY(whn),
 confirmed, deaths, recovered
 FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3
ORDER BY whn

--2.
