--JOIN and UEFA EURO 2012
--This tutorial introduces JOIN which allows you to use data from two or more tables. 
--The tables contain all matches and goals from UEFA EURO 2012 Football Championship in Poland and Ukraine.

--The data is available (mysql format) at http://sqlzoo.net/euro2012.sql


--1.
--The first example shows the goal scored by a player with the last name 'Bender'. 
--The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime

--Modify it to show the matchid and player name for all goals scored by Germany. 
--To identify German players, check for: teamid = 'GER'

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

--2.
--From the previous query you can see that Lars Bender's scored a goal in game 1012. 
--Now we want to know what teams were playing in that match.

--Notice in the that the column matchid in the goal table corresponds to the id column in the game table. 
--We can look up information about game 1012 by finding that row in the game table.

--Show id, stadium, team1, team2 for just game 1012

SELECT distinct(id),stadium,team1,team2
  FROM game g, goal go
where go.matchid = g.id
and matchid =1012


--3.
--You can combine the two steps into a single query with a JOIN.

SELECT *
FROM game JOIN goal ON (id=matchid)
--The FROM clause says to merge data from the goal table with that from the game table. 
--The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. 
--(If we wanted to be more clear/specific we could say
--ON (game.id=goal.matchid)

--The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.

--Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player,teamid, stadium,mdate
  FROM game JOIN goal ON (id=matchid)
where teamid = 'GER'

--4.
--Use the same JOIN as in the previous question.

--Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

select team1,team2,player
FROM game JOIN goal ON (id=matchid)
where player LIKE 'Mario%'

--5.
--The table eteam gives details of every national team including the coach. 
--You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id

--Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
  FROM goal join eteam on (teamid=id)
 WHERE gtime<=10

--6.
--To JOIN game with eteam you could use either
--game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)

--Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id

--List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

select mdate, teamname
from game join eteam on (team1=eteam.id)
where eteam.coach = 'Fernando Santos'

--7.
--List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

select player
from goal join game on (matchid=id)
where stadium = 'National Stadium, Warsaw'


--More difficult questions
--8.
--The example query shows all goals scored in the Germany-Greece quarterfinal.
--Instead show the name of all players who scored a goal against Germany.


SELECT distinct(player)
  FROM game JOIN goal ON matchid = id 
    WHERE teamid!='GER'
and (team1='GER' OR TEAM2='GER')

--9.
--Show teamname and the total number of goals scored.
--COUNT and GROUP BY

SELECT teamname, count(teamid)
  FROM eteam JOIN goal ON id=teamid
group by teamname
 ORDER BY teamname


--10.
--Show the stadium and the number of goals scored in each stadium.

select stadium, count(teamid)
 FROM game JOIN goal ON id=matchid
group by stadium

--11.
--For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT matchid,mdate, count(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
group by matchid

--12.
--For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT matchid,mdate, count(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE teamid='GER'
group by matchid

--13.
--List every match with the goals scored by each team as shown. 
--This will use "CASE WHEN" which has not been explained in any previous exercises.
--mdate	team1	score1	team2	score2
--1 July 2012	ESP	4	ITA	0
--10 June 2012	ESP	1	ITA	1
--10 June 2012	IRL	1	CRO	3
--...
--Notice in the query given every goal is listed. 
--If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. 
--You could SUM this column to get a count of the goals scored by team1. 
--Sort your result by mdate, matchid, team1 and team2.

SELECT 
mdate, 
team1, 
sum(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1, 
team2, 
sum(CASE WHEN teamid=team2 THEN 1 ELSE 0 END ) score2
FROM game left JOIN goal ON matchid = id
group by mdate, team1,team2
order by  mdate, matchid, team1,team2
  
