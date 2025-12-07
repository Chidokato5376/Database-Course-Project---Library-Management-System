import pymysql
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (10, 6)

# ==========================================
# DATABASE CONNECTION
# ==========================================
def get_connection():
    return pymysql.connect(
        host="127.0.0.1",       # Use IP instead of localhost
        user="root",
        password="hoangtuan5p", # Your password
        database="LibraryManagementDB"
    )

# ==========================================
# PART 1: VISUALIZE VIEWS
# Objective: Display inventory status and general loan overview
# ==========================================
def visualize_views():
    conn = get_connection()
    print("--- Generating charts for VIEWS ---")

    # 1.1. Fetch data
    query_books = """
        SELECT c.category_name, 
               SUM(b.total_copies) as 'Total Books', 
               SUM(b.available_copies) as 'Available Now'
        FROM Book b
        JOIN Category c ON b.category_id = c.category_id
        GROUP BY c.category_name;
    """
    df_books = pd.read_sql(query_books, conn)
    ax = df_books.set_index('category_name').plot(
        kind='bar', 
        stacked=False,  
        figsize=(12, 6), 
        color=['#95a5a6', '#2ecc71'], 
        width=0.7 
    )

    plt.title('Comparison: Total Inventory vs Available Books', fontsize=16)
    plt.ylabel('Number of Books', fontsize=12)
    plt.xlabel('Category', fontsize=12)
    plt.xticks(rotation=0) 
    plt.legend(title='Status')
    plt.grid(axis='y', linestyle='--', alpha=0.5)

    for p in ax.patches:
        if p.get_height() > 0:
            ax.annotate(str(int(p.get_height())), 
                        (p.get_x() + p.get_width() / 2., p.get_height()), 
                        ha='center', va='center', 
                        xytext=(0, 9), 
                        textcoords='offset points',
                        fontsize=10, fontweight='bold')

    plt.tight_layout()
    plt.show()

    # 1.2. From View v_active_loans: Overdue vs Active ratio
    query_loans = "SELECT status, COUNT(*) as count FROM v_active_loans GROUP BY status;"
    df_loans = pd.read_sql(query_loans, conn)
    
    plt.figure(figsize=(6, 6))
    plt.pie(df_loans['count'], labels=df_loans['status'], autopct='%1.1f%%', 
            colors=['#3498db', '#e74c3c'], startangle=90)
    plt.title('Active Loans Status Distribution', fontsize=14)
    plt.show()
    
    conn.close()

# ==========================================
# PART 2: VISUALIZE STORED PROCEDURE
# Objective: Run monthly report and plot performance
# ==========================================
def visualize_stored_procedure():
    conn = get_connection()
    print("--- Generating chart for STORED PROCEDURE ---")

    try:
        cursor = conn.cursor()
        cursor.callproc('sp_monthly_activity_report', (2025, 6))
        
        rows = cursor.fetchall()
        
        if cursor.description:
            columns = [col[0] for col in cursor.description]
            df = pd.DataFrame(rows, columns=columns)
            
            df = df.fillna(0)
            
            metrics = ['total_borrowed', 'total_returned', 'total_overdue_returns']
            
            if not df.empty:
                values = df[metrics].iloc[0].values
                
                plt.figure(figsize=(8, 6))
                sns.barplot(x=metrics, y=values, palette="viridis")
                plt.title('Monthly Activity Report (June 2025)', fontsize=14)
                plt.ylabel('Count')
                plt.xlabel('Activity Type')
                
                for i, v in enumerate(values):
                    plt.text(i, float(v) + 0.1, str(int(v)), ha='center', fontweight='bold')
                    
                plt.show()
            else:
                print("No data returned from monthly report.")
        else:
            print("Stored Procedure returned no data table.")

    except Exception as e:
        print(f"Error running Stored Procedure: {e}")
    

# ==========================================
# PART 3: VISUALIZE TRIGGER IMPACT
# Objective: Verify automated fine calculation Trigger
# ==========================================
def visualize_trigger_impact():
    conn = get_connection()
    print("--- Generating chart for TRIGGER validation ---")

    query = """
        SELECT 
            p.amount as Fine_Amount,
            p.remarks,  -- Lấy remarks về
            m.member_id,
            m.full_name
        FROM Payment p
        JOIN Loan l ON p.loan_id = l.loan_id
        JOIN Member m ON l.member_id = m.member_id
        WHERE p.remarks LIKE '%Late%' OR p.remarks LIKE 'Auto-fine%';
    """
    df = pd.read_sql(query, conn)

    if df.empty:
        print("No fine data found.")
        return

    df['Days_Late'] = df['remarks'].str.extract(r'(\d+)').astype(int)

    print("\nDetailed Fine List (Processed):")
    print("-" * 50)
    print(df[['member_id', 'full_name', 'Days_Late', 'Fine_Amount']].to_string(index=False))
    print("-" * 50)

    plt.figure(figsize=(8, 6))
    sns.regplot(x='Days_Late', y='Fine_Amount', data=df, color='#e67e22', marker='o')
    
    for i in range(df.shape[0]):
        plt.text(df.Days_Late[i]+0.1, df.Fine_Amount[i], 
                 df.full_name[i].split()[-1], 
                 fontsize=9, color='black')

    plt.title('Trigger Logic Validation: Days Late vs Fine Amount', fontsize=14)
    plt.xlabel('Days Overdue', fontsize=12)
    plt.ylabel('Fine Amount Generated ($)', fontsize=12)
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.text(df['Days_Late'].min(), df['Fine_Amount'].max(), 
             'Linear Relationship proves\nFine = Days * $2.00', 
             bbox=dict(facecolor='white', alpha=0.8))

    plt.show()
    conn.close()

# ==========================================
# MAIN EXECUTION
# ==========================================
if __name__ == "__main__":
    try:
        # 1. Visualize Views
        visualize_views()
        
        # 2. Visualize Stored Procedure
        visualize_stored_procedure()
        
        # 3. Visualize Trigger Logic
        visualize_trigger_impact()
        
        print("\nAll charts generated successfully.")
    except Exception as e:
        print(f"Error occurred: {e}")