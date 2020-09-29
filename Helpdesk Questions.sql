--Helpdesk Easy Questions    8,9

--1.There are three issues that include the words "index" and "Oracle". Find the call_date for each of them

SELECT call_date, call_ref FROM Issue
WHERE Detail LIKE '%index%'
AND Detail LIKE '%Oracle%'


--2.Samantha Hall made three calls on 2017-08-14. Show the date and time for each

SELECT call_date, first_name, last_name
FROM Caller c JOIN Issue i ON c.Caller_id = i.Caller_id
WHERE First_name = 'Samantha' AND last_name = 'Hall'
AND Call_date LIKE '%2017-08-14%'


--3.There are 500 calls in the system (roughly). Write a query that shows the number that have each status.

SELECT status, count(*) Volume
FROM Issue
GROUP BY status


--4.Calls are not normally assigned to a manager but it does happen. How many calls have been assigned to staff who are at Manager Level?

SELECT count(*)
FROM Issue 
JOIN Staff s ON Assigned_to = Staff_code
JOIN Level l ON s.Level_code = l.Level_code
WHERE l.Manager IS NOT NULL


--5.Show the manager for each shift. Your output should include the shift date and type; also the first and last name of the manager.

SELECT Shift_date, Shift_type, First_name, Last_name
FROM Shift sh
JOIN Staff s ON sh.Manager = s.Staff_code
ORDER BY 1


--Helpdesk Medium Questions

--6.List the Company name and the number of calls for those companies with more than 18 calls.

SELECT Company_name, COUNT(*)
FROM Customer cu
JOIN Caller c ON cu.Company_ref = c.Company_ref
JOIN Issue i ON c.Caller_id = i.Caller_id
GROUP BY 1
HAVING COUNT(*) > 18

--7.Find the callers who have never made a call. Show first name and last name

SELECT First_name, Last_name
FROM Caller
WHERE Caller_id NOT IN
(SELECT Caller_id
FROM  Issue 
)

--**8.For each customer show: Company name, contact name, number of calls where the number of calls is fewer than 5
SELECT Company_name, First_name, Last_name, nc
FROM
(SELECT Company_name, Contact_id, Count(*) nc
FROM Issue i
JOIN Caller c ON c.Caller_id = i.Caller_id
JOIN Customer cu ON cu.Company_ref = c.Company_ref
GROUP BY 1,2
HAVING nc < 5 ) e
JOIN
(SELECT Caller_id, First_name, Last_name
FROM Caller
) f
ON 
e.Contact_id = f.Caller_id


--**9.For each shift show the number of staff assigned. Beware that some roles may be NULL and that the same person might have been assigned to multiple roles 
--(The roles are 'Manager', 'Operator', 'Engineer1', 'Engineer2').

SELECT e.Shift_date, e.Shift_type, COUNT(Manager)
FROM
(SELECT Shift_date, Shift_type, Manager
FROM Shift
UNION
SELECT Shift_date, Shift_type, Operator
FROM Shift
UNION
SELECT Shift_date, Shift_type, Engineer1
FROM Shift
UNION
SELECT Shift_date, Shift_type, Engineer2
FROM Shift) e
GROUP BY 1,2

--10.Caller 'Harry' claims that the operator who took his most recent call was abusive and insulting. Find out who took the call (full name) and when.
SELECT First_name, Last_name, Call_date
FROM Staff 
JOIN Issue ON Staff_code = Taken_by
WHERE Caller_id = 
(SELECT Caller_id
FROM Caller
WHERE First_name LIKE 'Harry')
ORDER BY 3 DESC
LIMIT 1








