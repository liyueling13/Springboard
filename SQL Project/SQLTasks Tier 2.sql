/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: you might need to do some digging, and revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name 
FROM `Facilities` 
WHERE membercost = 0;

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(name) 
FROM `Facilities` 
WHERE membercost = 0;
4 facilities total

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance 
FROM `Facilities` 
WHERE membercost < monthlymaintenance*0.2;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT *
FROM `Facilities` 
WHERE facid IN (1, 5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
ELSE 'cheap' END
AS maintenancecost
FROM `Facilities`;

 name 	monthlymaintenance 	maintenancecost 	
Tennis Court 1 	200 	expensive
Tennis Court 2 	200 	expensive
Badminton Court 	50 	cheap
Table Tennis 	10 	cheap
Massage Room 1 	3000 	expensive
Massage Room 2 	3000 	expensive
Squash Court 	80 	cheap
Snooker Table 	15 	cheap
Pool Table 	15 	cheap

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM `Members`
WHERE joindate = 
	(SELECT MAX(joindate)
    FROM `Members`);
Darren 	Smith

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT_WS(m.firstname, '', m.surname) AS fullname, f.name
FROM `Members` AS m
LEFT JOIN `Bookings` AS b 
ON m.memid = b.memid
LEFT JOIN `Facilities` AS f
ON b.facid = f.facid
WHERE f.facid IN (0, 1)
ORDER BY fullname;

 fullname Ascending 	name 	
AnneBaker 	Tennis Court 2
AnneBaker 	Tennis Court 1
BurtonTracy 	Tennis Court 1
BurtonTracy 	Tennis Court 2
CharlesOwen 	Tennis Court 2
CharlesOwen 	Tennis Court 1
DarrenSmith 	Tennis Court 2
DavidFarrell 	Tennis Court 1
DavidFarrell 	Tennis Court 2
DavidJones 	Tennis Court 2
DavidJones 	Tennis Court 1
DavidPinker 	Tennis Court 1
DouglasJones 	Tennis Court 1
EricaCrumpet 	Tennis Court 1
FlorenceBader 	Tennis Court 2
FlorenceBader 	Tennis Court 1
GeraldButters 	Tennis Court 1
GeraldButters 	Tennis Court 2
GUESTGUEST 	Tennis Court 2
GUESTGUEST 	Tennis Court 1
HenriettaRumney 	Tennis Court 2
JackSmith 	Tennis Court 2
JackSmith 	Tennis Court 1
JaniceJoplette 	Tennis Court 1
JaniceJoplette 	Tennis Court 2
JemimaFarrell 	Tennis Court 2
JemimaFarrell 	Tennis Court 1
JoanCoplin 	Tennis Court 1
JohnHunt 	Tennis Court 1
JohnHunt 	Tennis Court 2
MatthewGenting 	Tennis Court 1
MillicentPurview 	Tennis Court 2
NancyDare 	Tennis Court 1
NancyDare 	Tennis Court 2
PonderStibbons 	Tennis Court 2
PonderStibbons 	Tennis Court 1
RamnareshSarwin 	Tennis Court 2
RamnareshSarwin 	Tennis Court 1
TimBoothe 	Tennis Court 2
TimBoothe 	Tennis Court 1
TimothyBaker 	Tennis Court 2
TimothyBaker 	Tennis Court 1
TimRownam 	Tennis Court 2
TimRownam 	Tennis Court 1
TracySmith 	Tennis Court 2
TracySmith 	Tennis Court 1

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT 
	DISTINCT CONCAT_WS(m.firstname, '', m.surname) AS fullname, 
	f.name AS facility, 
	CASE WHEN b.memid = 0 THEN b.slots * f.guestcost
	ELSE b.slots * f.membercost END AS cost
FROM `Bookings` AS b 
	JOIN `Facilities` AS f
		ON b.facid = f.facid
	JOIN `Members` AS m
		ON m.memid = b.memid
WHERE b.starttime LIKE '2012-09-14%'
HAVING cost > 30
ORDER BY cost DESC;

 fullname 	facility 	cost Descending 	
GUESTGUEST 	Massage Room 2 	320.0
GUESTGUEST 	Massage Room 1 	160.0
GUESTGUEST 	Tennis Court 2 	150.0
GUESTGUEST 	Tennis Court 2 	75.0
GUESTGUEST 	Tennis Court 1 	75.0
GUESTGUEST 	Squash Court 	70.0
JemimaFarrell 	Massage Room 1 	39.6
GUESTGUEST 	Squash Court 	35.0

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT 
	DISTINCT CONCAT_WS(m.firstname, '', m.surname) AS fullname, 
	subquery.name AS facility, 
	subquery.cost
FROM `Members` AS m,
	(SELECT f.name, b.memid, b.starttime,
	CASE WHEN b.memid = 0 THEN b.slots * f.guestcost
	ELSE b.slots * f.membercost END AS cost
	FROM `Bookings` AS b 
	JOIN `Facilities` AS f
		ON b.facid = f.facid) AS subquery
WHERE m.memid = subquery.memid
AND subquery.starttime LIKE '2012-09-14%'
HAVING cost > 30
ORDER BY cost DESC;

 fullname 	facility 	cost Descending 	
GUESTGUEST 	Massage Room 2 	320.0
GUESTGUEST 	Massage Room 1 	160.0
GUESTGUEST 	Tennis Court 2 	150.0
GUESTGUEST 	Tennis Court 2 	75.0
GUESTGUEST 	Tennis Court 1 	75.0
GUESTGUEST 	Squash Court 	70.0
JemimaFarrell 	Massage Room 1 	39.6
GUESTGUEST 	Squash Court 	35.0


/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook for the following questions.

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
import sqlite3
import pandas as pd
con = sqlite3.connect("sqlite_db_pythonsqlite.db")

member_query = con.execute('SELECT f.name, SUM(b.slots * f.membercost) FROM Bookings AS b JOIN Facilities AS f ON b.facid = f.facid WHERE b.memid != 0 GROUP BY f.name')
member_df = pd.DataFrame(member_query.fetchall())
member_df.columns = ['Facility', 'Total Cost']
member_df = member_df.set_index('Facility')
member_df

nonm_query = con.execute('SELECT f.name, SUM(b.slots * f.guestcost) FROM Bookings AS b JOIN Facilities AS f ON b.facid = f.facid WHERE b.memid = 0  GROUP BY f.name')
nonm_df = pd.DataFrame(nonm_query.fetchall())
nonm_df.columns = ['Facility', 'Total Cost']
nonm_df = nonm_df.set_index('Facility')
nonm_df

revenues_df = member_df.merge(nonm_df, on = 'Facility', suffixes = ('_mem', '_nonm'))
revenues_df['Total Revenue'] = revenues_df['Total Cost_mem'] + revenues_df['Total Cost_nonm']
revenues_df[revenues_df['Total Revenue'] < 1000]

Pool Table 	270.0
Snooker Table 	240.0
Table Tennis 	180.0

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
 member 	recommender 	
BaderFlorence 	SarwinRamnaresh
BakerTimothy 	CoplinJoan
ButtersGerald 	GentingMatthew
FarrellJemima 	BakerTimothy
GentingMatthew 	RumneyHenrietta
JonesDavid 	JonesDouglas
JopletteJanice 	DareNancy
PurviewMillicent 	HuntJohn
RownamTim 	BootheTim
SmithDarren 	JopletteJanice
SmithTracy 	Worthington-SmythHenry
StibbonsPonder 	BakerAnne
TracyBurton 	StibbonsPonder

SELECT CONCAT_WS(M1.surname, '', M1.firstname) AS member, CONCAT_WS(M2.surname, '', M2.firstname) AS recommender 
FROM Members as M1
INNER JOIN Members as M2
    ON M1.memid = M2.recommendedby
WHERE M1.memid != 0
GROUP BY member;

/* Q12: Find the facilities with their usage by member, but not guests */
SELECT f.name, SUM(b.slots)
FROM Bookings AS b
LEFT JOIN Facilities AS f
ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name;

 name 	SUM(b.slots) 	
Badminton Court 	1086
Massage Room 1 	884
Massage Room 2 	54
Pool Table 	856
Snooker Table 	860
Squash Court 	418
Table Tennis 	794
Tennis Court 1 	957
Tennis Court 2 	882

/* Q13: Find the facilities usage by month, but not guests */
SELECT f.name AS facility, MONTH(b.starttime) AS month, SUM(b.slots) AS num_bookings
FROM Bookings AS b
LEFT JOIN Facilities AS f
ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name, MONTH(b.starttime);

 facility 	month 	num_bookings 	
Badminton Court 	7 	165
Badminton Court 	8 	414
Badminton Court 	9 	507
Massage Room 1 	7 	166
Massage Room 1 	8 	316
Massage Room 1 	9 	402
Massage Room 2 	7 	8
Massage Room 2 	8 	18
Massage Room 2 	9 	28
Pool Table 	7 	110
Pool Table 	8 	303
Pool Table 	9 	443
Snooker Table 	7 	140
Snooker Table 	8 	316
Snooker Table 	9 	404
Squash Court 	7 	50
Squash Court 	8 	184
Squash Court 	9 	184
Table Tennis 	7 	98
Table Tennis 	8 	296
Table Tennis 	9 	400
Tennis Court 1 	7 	201
Tennis Court 1 	8 	339
Tennis Court 1 	9 	417
Tennis Court 2 	7 	123
Tennis Court 2 	8 	345
Tennis Court 2 	9 	414



















