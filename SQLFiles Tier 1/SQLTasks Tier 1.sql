/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

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

SELECT name AS paid_member_facilities
FROM facilities
WHERE membercost > 0;

/* A1: 
paid_member_facilities  
Tennis Court 1  
Tennis Court 2  
Massage Room 1  
Massage Room 2  
Squash Court
/*    


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(name) AS num_free_member_facilities
FROM facilities
WHERE membercost = 0;
 

/* A2:
num_free_member_facilities  
4
/*


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM facilities
WHERE membercost > 0 
    AND membercost < .2 * monthlymaintenance;

/* A3:
facid   name            membercost  monthlymaintenance  
0       Tennis Court 1  5.0         200 
1       Tennis Court 2  5.0         200 
4       Massage Room 1  9.9         3000    
5       Massage Room 2  9.9         3000    
6       Squash Court    3.5         80  
/*


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM facilities
WHERE facid IN (1,5);

/* A4:
facid   name            membercost  guestcost   initialoutlay   monthlymaintenance  
1       Tennis Court 2  5.0         25.0        8000            200 
5       Massage Room 2  9.9         80.0        4000            3000    
/*

/* Q5: Produce a list of facilities, with each labeled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
    IF(monthlymaintenance > 100, 'expensive', 'cheap') AS relprice
FROM facilities;

/* A5:
name            monthlymaintenance  relprice    
Tennis Court 1  200                 expensive   
Tennis Court 2  200                 expensive   
Badminton Court 50                  cheap   
Table Tennis    10                  cheap   
Massage Room 1  3000                expensive   
Massage Room 2  3000                expensive   
Squash Court    80                  cheap   
Snooker Table   15                  cheap   
Pool Table  15  cheap   
/*

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM members
WHERE firstname != 'GUEST'
    AND surname != 'GUEST';

/* A6:
firstname   surname 
Darren      Smith   
Tracy       Smith   
Tim         Rownam  
Janice      Joplette    
Gerald      Butters 
Burton      Tracy   
Nancy       Dare    
Tim         Boothe  
Ponder      Stibbons    
Charles     Owen    
David       Jones   
Anne        Baker   
Jemima      Farrell 
Jack        Smith   
Florence    Bader   
Timothy     Baker   
David       Pinker  
Matthew     Genting 
Anna        Mackenzie   
Joan        Coplin  
Ramnaresh   Sarwin  
Douglas     Jones   
Henrietta   Rumney  
David       Farrell 
Henry       Worthington-Smyth   
Millicent   Purview 
Hyacinth    Tupperware  
John        Hunt    
Erica       Crumpet 
Darren      Smith   
/*

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT
    CONCAT(m.firstname,' ', m.surname)) AS member, 
    f.name AS facility
FROM members as m
    INNER JOIN bookings as b
    USING(memid)
    INNER JOIN facilities as f
    USING(facid)
WHERE f.name LIKE 'Tennis%'
    AND m.memid != 0
ORDER BY CONCAT(m.firstname,' ', m.surname);

/* A7:
member              facility    
Anne Baker          Tennis Court 2  
Anne Baker          Tennis Court 1  
Burton Tracy        Tennis Court 2  
Burton Tracy        Tennis Court 1  
Charles Owen        Tennis Court 2  
Charles Owen        Tennis Court 1  
Darren Smith        Tennis Court 2  
David Farrell       Tennis Court 2  
David Farrell       Tennis Court 1  
David Jones         Tennis Court 1  
David Jones         Tennis Court 2  
David Pinker        Tennis Court 1  
Douglas Jones       Tennis Court 1  
Erica Crumpet       Tennis Court 1  
Florence Bader      Tennis Court 1  
Florence Bader      Tennis Court 2  
Gerald Butters      Tennis Court 1  
Gerald Butters      Tennis Court 2  
Henrietta Rumney    Tennis Court 2  
Jack Smith          Tennis Court 1  
Jack Smith          Tennis Court 2  
Janice Joplette     Tennis Court 1  
Janice Joplette     Tennis Court 2  
Jemima Farrell      Tennis Court 2  
Jemima Farrell      Tennis Court 1  
Joan Coplin         Tennis Court 1  
John Hunt           Tennis Court 1  
John Hunt           Tennis Court 2  
Matthew Genting     Tennis Court 1  
Millicent Purview   Tennis Court 2  
Nancy Dare          Tennis Court 2  
Nancy Dare          Tennis Court 1  
Ponder Stibbons     Tennis Court 2  
Ponder Stibbons     Tennis Court 1  
Ramnaresh Sarwin    Tennis Court 1  
Ramnaresh Sarwin    Tennis Court 2  
Tim Boothe          Tennis Court 1  
Tim Boothe          Tennis Court 2  
Tim Rownam          Tennis Court 2  
Tim Rownam          Tennis Court 1  
Timothy Baker       Tennis Court 2  
Timothy Baker       Tennis Court 1  
Tracy Smith         Tennis Court 1  
Tracy Smith         Tennis Court 2  
/*

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT DISTINCT
    f.name AS facility,
    CONCAT(m.firstname,' ', m.surname) AS member, 
    IF(memid = 0, guestcost, membercost) * slots AS cost            
FROM members as m
    INNER JOIN bookings as b
    USING(memid)
    INNER JOIN facilities as f
    USING(facid)
WHERE b.starttime LIKE '2012-09-14%'
    AND IF(memid = 0, guestcost, membercost) * slots > 30
ORDER BY cost DESC;

/* A8:
facility        member          cost    
Massage Room 2  GUEST GUEST     320.0   
Massage Room 1  GUEST GUEST     160.0   
Tennis Court 2  GUEST GUEST     150.0   
Tennis Court 1  GUEST GUEST     75.0    
Tennis Court 2  GUEST GUEST     75.0    
Squash Court    GUEST GUEST     70.0    
Massage Room 1  Jemima Farrell  39.6    
Squash Court    GUEST GUEST     35.0    
/*

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT
    bookid,
    fsub.facility,
    msub.member, 
    IF(bookings.memid = 0, fsub.guestcost, fsub.membercost) * slots AS cost
FROM bookings,
    (SELECT
        memid,
        CONCAT(firstname,' ', surname) AS member        
     FROM members) AS msub,
    (SELECT
        facid,
        name AS facility,
        guestcost,
        membercost
     FROM facilities) AS fsub
WHERE
    bookings.memid = msub.memid
    AND bookings.facid = fsub.facid
    AND IF(bookings.memid = 0, fsub.guestcost, fsub.membercost) * slots > 30
    AND starttime LIKE '2012-09-14%'
ORDER BY cost DESC;

/* A9:
bookid  facility        member          cost    
2946    Massage Room 2  GUEST GUEST     320.0   
2942    Massage Room 1  GUEST GUEST     160.0   
2940    Massage Room 1  GUEST GUEST     160.0   
2937    Massage Room 1  GUEST GUEST     160.0   
2926    Tennis Court 2  GUEST GUEST     150.0   
2920    Tennis Court 1  GUEST GUEST     75.0    
2925    Tennis Court 2  GUEST GUEST     75.0    
2922    Tennis Court 1  GUEST GUEST     75.0    
2948    Squash Court    GUEST GUEST     70.0    
2941    Massage Room 1  Jemima Farrell  39.6    
2951    Squash Court    GUEST GUEST     35.0    
2949    Squash Court    GUEST GUEST     35.0       
/*


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

