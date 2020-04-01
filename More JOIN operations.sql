--1962 movies
--1.
--List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962

--When was Citizen Kane released?
--2.
--Give year of 'Citizen Kane'.

select yr
from movie
where title = 'Citizen Kane'

--Star Trek movies
--3.
--List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). 
--Order results by year.

select id, title, yr
from movie
where title like 'Star Trek%'
order by yr


--id for actor Glenn Close
--4.
--What id number does the actor 'Glenn Close' have?

select id 
from actor
where name = 'Glenn Close'


--id for Casablanca
--5.
--What is the id of the film 'Casablanca'

select id 
from movie
where title = 'Casablanca'

--Get to the point

--Cast list for Casablanca
--6.
--Obtain the cast list for 'Casablanca'.

--what is a cast list?
--Use movieid=11768, (or whatever value you got from the previous question)

select name
from casting join actor on actorid = id
where movieid=11768

--Alien cast list
--7.
--Obtain the cast list for the film 'Alien'

select name
from actor join casting on actor.id = actorid
join movie on movie.id = movieid
where  title = 'Alien'

--Harrison Ford movies
--8.
--List the films in which 'Harrison Ford' has appeared

select title
from actor join casting on actor.id = actorid
join movie on movie.id = movieid
where  name = 'Harrison Ford'

--Harrison Ford as a supporting actor
--9.
--List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select title
from actor join casting on actor.id = actorid
join movie on movie.id = movieid
where  name = 'Harrison Ford' and ord != 1

--Lead actors in 1962 movies
--10.
--List the films together with the leading star for all 1962 films.

select title, name
from actor join casting on actor.id = actorid
join movie on movie.id = movieid
where  yr = 1962 and ord = 1

--Harder Questions

--Busy years for Rock Hudson
--11.
--Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

--Lead actor in Julie Andrews movies
--12.
--List the film title and the leading actor for all of the films 'Julie Andrews' played in.

--Did you get "Little Miss Marker twice"?

select title, name from movie join casting on movie.id=movieid and ord = 1 
join actor on actorid = actor.id
where movie.id IN (
select movieid from casting join actor on actorid = actor.id
where actorid IN (
select actor.id from actor
  WHERE name='Julie Andrews'))


--Actors with 15 leading roles
--13.
--Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

select name from actor join casting on actor.id = actorid 
where ord = 1
group by name
having count(name)>=15

--14.
--List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

select title,count(actorid)
from movie join casting on movie.id = movieid
where yr = 1978 
group by title 
order by count(actorid) desc,title

--15.
--List all the people who have worked with 'Art Garfunkel'.

select name 
from actor join casting on actor.id = actorid
where name != 'Art Garfunkel' and movieid in (
select movieid 
from casting join actor on actorid = actor.id
where name = 'Art Garfunkel')
