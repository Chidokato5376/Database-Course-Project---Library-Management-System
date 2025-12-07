import pymysql
import pandas as pd
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

# ==========================================
# 1. CONNECTION CONFIGURATION
# ==========================================
db_config = {
    "host": "127.0.0.1",    # Use your ID address
    "user": "root",
    "password": "********", # Your password
    "database": "LibraryManagementDB",
    "cursorclass": pymysql.cursors.Cursor
}

def get_connection():
    return pymysql.connect(**db_config)

# ==========================================
# 2. CALL VIEW (Display as table)
# ==========================================
def task_call_view():
    print("\n" + "="*50)
    print("TASK 1: CALL VIEW (v_books_status)")
    print("="*50)
    
    conn = get_connection()
    try:
        query = "SELECT * FROM v_books_status ORDER BY book_id;"
        df = pd.read_sql(query, conn)
        
        if not df.empty:
            print("Results from View v_books_status:")
            print("-" * 30)
            print(df.to_string(index=False))
        else:
            print("View has no data.")
    finally:
        conn.close()

# ==========================================
# 3. CALL STORED PROCEDURE (Monthly Report)
# ==========================================
def task_call_procedure():
    print("\n" + "="*50)
    print("TASK 2: CALL STORED PROCEDURE (sp_monthly_activity_report)")
    print("="*50)
    
    conn = get_connection()
    try:
        cursor = conn.cursor()
        
        # Call report for June 2025 (Based on new seed data)
        report_year = 2025
        report_month = 6
        
        print(f"Running report for: {report_month}/{report_year}...")
        cursor.callproc('sp_monthly_activity_report', (report_year, report_month))
        rows = cursor.fetchall()
        
        if cursor.description:
            columns = [col[0] for col in cursor.description]
            df = pd.DataFrame(rows, columns=columns)
            if 'total_fines_collected' in df.columns:
                df['total_fines_collected'] = df['total_fines_collected'].astype(float)
            
            print("Activity Report Results:")
            print("-" * 30)
            print(df.to_string(index=False))
        else:
            print("No data returned.")
            
    finally:
        conn.close()

# ==========================================
# 4. EXECUTE SQL QUERY (Most Borrowed Books)
# ==========================================
def task_execute_query():
    print("\n" + "="*50)
    print("TASK 3: COMPLEX QUERY (Most Borrowed Books)")
    print("="*50)
    
    conn = get_connection()
    try:
        query = """
        SELECT 
            b.book_id,
            b.title,
            c.category_name,
            COUNT(l.loan_id) AS times_borrowed
        FROM Book b
        JOIN Loan l ON b.book_id = l.book_id
        JOIN Category c ON b.category_id = c.category_id
        GROUP BY b.book_id, b.title, c.category_name
        ORDER BY times_borrowed DESC
        LIMIT 5;
        """
        
        df = pd.read_sql(query, conn)
        
        print("Top 5 Most Borrowed Books:")
        print("-" * 30)
        print(df.to_string(index=False))
        
    finally:
        conn.close()

# ==========================================
# MAIN EXECUTION
# ==========================================
if __name__ == "__main__":
    try:
        task_call_view()
        task_call_procedure()
        task_execute_query()
        print("\n All tasks completed successfully.")
    except Exception as e:
        print(f"\n Error occurred: {e}")