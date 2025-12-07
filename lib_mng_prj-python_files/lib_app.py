import streamlit as st
import pymysql
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# 1. CẤU HÌNH TRANG WEB
st.set_page_config(
    page_title="Library Management Dashboard",
    page_icon="📚",
    layout="wide"
)

# 2. HÀM KẾT NỐI DATABASE (Có Cache để chạy nhanh hơn)
#@st.cache_resource
def get_connection():
    return pymysql.connect(
        host="127.0.0.1",
        user="root",
        password="hoangtuan5p", # Mật khẩu của bạn
        database="LibraryManagementDB"
    )

# 3. GIAO DIỆN CHÍNH
def main():
    # Tiêu đề và Sidebar
    st.title("📚 Library Management System")
    st.markdown("---")
    
    # Menu bên trái
    menu = st.sidebar.radio("Navigate", ["📊 Dashboard Overview", "📖 Book Inventory", "⚠️ Overdue Analytics"])

    # --- TAB 1: DASHBOARD TỔNG QUAN (NÂNG CẤP) ---
    if menu == "📊 Dashboard Overview":
        st.header("📈 Library Performance Analytics")
        
        # 1. Bộ lọc thời gian (Sidebar Filter)
        st.sidebar.markdown("### 🗓️ Report Settings")
        selected_year = st.sidebar.selectbox("Select Year", [2025, 2024, 2023], index=0)
        
        # Chọn khoảng tháng (Ví dụ: Từ tháng 1 đến tháng 6)
        month_range = st.sidebar.slider("Select Month Range", 1, 12, (1, 12))
        start_month, end_month = month_range

        st.info(f"Showing data for **{selected_year}** from **Month {start_month}** to **Month {end_month}**")

        # 2. Thu thập dữ liệu cho nhiều tháng
        conn = get_connection()
        report_data = []
        
        try:
            with conn.cursor() as cursor:
                # Vòng lặp chạy qua từng tháng trong khoảng đã chọn
                for m in range(start_month, end_month + 1):
                    cursor.callproc('sp_monthly_activity_report', (selected_year, m))
                    rows = cursor.fetchall()
                    
                    if rows:
                        # Lấy dòng đầu tiên (vì SP chỉ trả về 1 dòng tổng hợp mỗi tháng)
                        row = rows[0] 
                        # Thêm vào danh sách data
                        # Thêm vào danh sách data (Đã sửa lỗi NoneType)
                        # Logic: Nếu giá trị là None thì lấy số 0, ngược lại thì lấy giá trị đó
                        report_data.append({
                            "Month": f"Month {m}",
                            "Month_Num": m,
                            "Borrowed": int(row[0]) if row[0] else 0,       # <--- Sửa dòng này
                            "Returned": int(row[1]) if row[1] else 0,       # <--- Sửa dòng này
                            "Overdue Returns": int(row[2]) if row[2] else 0,# <--- Sửa dòng này
                            "Fines ($)": float(row[3]) if row[3] else 0.0   # Dòng này đã đúng sẵn
                        
                        })
            
            # Chuyển danh sách thành DataFrame
            df_trend = pd.DataFrame(report_data)

            if not df_trend.empty:
                # 3. Hiển thị KPI Tổng hợp (Cộng dồn các tháng)
                st.subheader("📌 Period Summary")
                col1, col2, col3, col4 = st.columns(4)
                
                total_borrow = df_trend['Borrowed'].sum()
                total_return = df_trend['Returned'].sum()
                total_overdue = df_trend['Overdue Returns'].sum()
                total_fines = df_trend['Fines ($)'].sum()

                col1.metric("Total Borrowed", f"{total_borrow}", delta="Period Total")
                col2.metric("Total Returned", f"{total_return}")
                col3.metric("Overdue Returns", f"{total_overdue}", delta_color="inverse")
                col4.metric("Total Revenue", f"${total_fines:,.2f}")

                st.markdown("---")

                # 4. Biểu đồ xu hướng (Trend Chart)
                st.subheader("📊 Monthly Trends Comparison")
                
                # Biểu đồ kết hợp (Combo Chart) dùng Seaborn/Matplotlib
                fig, ax1 = plt.subplots(figsize=(10, 5))

                # Trục trái: Số lượng sách (Cột)
                sns.barplot(data=df_trend, x='Month', y='Borrowed', color='#a8dadc', ax=ax1, label='Borrowed', alpha=0.6)
                sns.barplot(data=df_trend, x='Month', y='Overdue Returns', color='#e63946', ax=ax1, label='Overdue', alpha=0.8)
                ax1.set_ylabel("Number of Books")
                ax1.legend(loc='upper left')

                # Trục phải: Tiền phạt (Đường dây)
                ax2 = ax1.twinx()
                sns.lineplot(data=df_trend, x='Month', y='Fines ($)', color='#457b9d', marker='o', ax=ax2, linewidth=2, label='Revenue ($)')
                ax2.set_ylabel("Fines Collected ($)")
                ax2.legend(loc='upper right')

                plt.title(f"Activity & Revenue Trends ({selected_year})")
                st.pyplot(fig)

                # 5. Bảng dữ liệu chi tiết
                with st.expander("View Detailed Monthly Data"):
                    st.dataframe(df_trend.set_index("Month"), use_container_width=True)

            else:
                st.warning("No data found for the selected period.")

        except Exception as e:
            st.error(f"Error fetching reports: {e}")
        finally:
            conn.close()

    # --- TAB 2: KHO SÁCH (INVENTORY) ---
    elif menu == "📖 Book Inventory":
        st.header("📦 Inventory Status")
        
        # Tạo kết nối mới (Không dùng cache)
        conn = get_connection()
        try:
            with conn.cursor() as cursor:
                # Dùng cursor.execute thay vì pd.read_sql
                cursor.execute("SELECT * FROM v_books_status ORDER BY book_id ASC")
                rows = cursor.fetchall()
                
                # Nếu có dữ liệu
                if rows:
                    # Lấy tên cột tự động
                    col_names = [i[0] for i in cursor.description]
                    df_books = pd.DataFrame(rows, columns=col_names)
                    
                    # 1. Hiển thị bảng
                    with st.expander("View Detailed Book List", expanded=True):
                        st.dataframe(df_books, use_container_width=True)
                        
                    # 2. Chuẩn bị dữ liệu vẽ biểu đồ (Inventory Chart)
                    st.subheader("Inventory Distribution by Category")
                    
                    # Query lấy dữ liệu
                    cursor.execute("""
                        SELECT c.category_name, 
                               SUM(b.total_copies) as Total, 
                               SUM(b.available_copies) as Available
                        FROM Book b JOIN Category c ON b.category_id = c.category_id
                        GROUP BY c.category_name;
                    """)
                    chart_rows = cursor.fetchall()
                    
                    if chart_rows:
                        # Tạo DataFrame
                        chart_cols = [i[0] for i in cursor.description]
                        df_chart = pd.DataFrame(chart_rows, columns=chart_cols)
                        
                        # --- CÁCH SỬA QUAN TRỌNG ---
                        # Ép kiểu dữ liệu sang số thực (float) để vẽ được biểu đồ
                        df_chart['Total'] = df_chart['Total'].astype(float)
                        df_chart['Available'] = df_chart['Available'].astype(float)
                        
                        # Vẽ biểu đồ
                        fig, ax = plt.subplots(figsize=(10, 5))
                        df_chart.set_index('category_name').plot(
                            kind='bar', 
                            stacked=False, 
                            ax=ax, 
                            color=['#95a5a6', '#2ecc71']
                        )
                        plt.xticks(rotation=0)
                        plt.title("Total vs Available Books")
                        st.pyplot(fig)
                    else:
                        st.info("No data for inventory chart.")
                    
        except Exception as e:
            st.error(f"Error: {e}")
        finally:
            # Luôn đóng kết nối
            conn.close()

        

    # --- TAB 3: PHÂN TÍCH QUÁ HẠN (TRIGGER) ---
    elif menu == "⚠️ Overdue Analytics":
        st.header("🚨 Overdue & Fines Analysis")
        
        conn = get_connection()
        
        # 1. Biểu đồ tròn Active vs Overdue
        col_left, col_right = st.columns(2)
        
        with col_left:
            st.subheader("Current Loan Status")
            df_loans = pd.read_sql("SELECT status, COUNT(*) as count FROM v_active_loans GROUP BY status", conn)
            
            if not df_loans.empty:
                fig1, ax1 = plt.subplots()
                ax1.pie(df_loans['count'], labels=df_loans['status'], autopct='%1.1f%%', colors=['#3498db', '#e74c3c'], startangle=90)
                st.pyplot(fig1)

        # 2. Biểu đồ đường kiểm chứng Trigger
        with col_right:
            st.subheader("Fine Logic Validation ($2.00/day)")
            query_trigger = """
                SELECT amount as Fine, 
                CAST(REGEXP_SUBSTR(remarks, '[0-9]+') AS UNSIGNED) as Days
                FROM Payment WHERE remarks LIKE '%Late%' OR remarks LIKE 'Auto-fine%'
            """
            df_trigger = pd.read_sql(query_trigger, conn)
            
            if not df_trigger.empty:
                fig2, ax2 = plt.subplots()
                sns.regplot(x='Days', y='Fine', data=df_trigger, ax=ax2, color='#e67e22')
                st.pyplot(fig2)
            else:
                st.info("No fine data available yet.")
        
        conn.close()

if __name__ == "__main__":
    main()