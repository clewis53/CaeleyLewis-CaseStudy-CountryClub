import sqlite3
from sqlite3 import Error

 
def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by the db_file
    :param db_file: database file
    :return: Connection object or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        print(sqlite3.version)
    except Error as e:
        print(e)
 
    return conn

 
def select_all_tasks(conn, query):
    """
    Query all rows in the tasks table
    :param conn: the Connection object
    :return:
    """
    cur = conn.cursor()
    
    cur.execute(query)
    
    print([description[0] for description in cur.description])
    
    rows = cur.fetchall()
 
    for row in rows:
        print(row)
        

def define_queries():
    """
    Creates the queries to answer the necessary questions for the Country
    Club Case Study.
    
    Returns
    -------
    queries : dict
        keys are the question number
        values are the queries

    """
    queries = {}
    
    # Q10: Produce a list of facilities with a total revenue less than 1000.
    # The output of facility name and total revenue, sorted by revenue. Remember
    # that there's a different cost for guests and members!
    queries['Q10'] = '''
        SELECT 
            f.name AS facility,
            ROUND(SUM(CASE WHEN memid = 0 THEN guestcost ELSE membercost END * slots), 2) AS revenue            
        FROM members as m
            INNER JOIN bookings as b
                USING(memid)
            INNER JOIN facilities as f
                USING(facid)       
        GROUP BY facid
        ORDER BY revenue;
        '''
    
    # Q11: Produce a report of members and who recommended them in alphabetic 
    # surname,firstname order
    queries['Q11'] = '''
        SELECT
            m1.surname, m1.firstname,
            m2.firstname || ' ' || m2.surname AS recommendedby
        FROM members as m1
        LEFT JOIN members as m2
        ON m1.recommendedby = m2.memid
        ORDER BY m1.surname, m1.firstname;
        '''
    
    # Q12: Find the facilities with their usage by member, but not guests
    queries['Q12'] = '''
        SELECT
            f.name AS facility,
            m.firstname || ' ' || m.surname AS member,
            COUNT(*) AS usage
        FROM members as m
            INNER JOIN bookings as b
                USING(memid)
            INNER JOIN facilities as f
                USING(facid)       
        GROUP BY facid, memid
        HAVING memid != 0
        ORDER BY facility, member
        '''
    
    # Q13: Find the facilities usage by month, but not guests
    queries['Q13'] = '''
        SELECT
            f.name AS facility,
            substr(b.starttime, 1, 7) AS month,
            COUNT(*) AS usage
        FROM bookings as b
            INNER JOIN facilities as f
            USING(facid)
        GROUP BY facid, month
        ORDER BY facility, month
        '''   
    return queries


def main():
    database = "sqlite_db_pythonsqlite.db"
    
    queries = define_queries()
    # create a database connection
    conn = create_connection(database)
    with conn:
        for question_num, query in queries.items():
            print(question_num)
            select_all_tasks(conn, query)
            print('\n----------------------------')
 
 
if __name__ == '__main__':
    main()
    
    
    
    