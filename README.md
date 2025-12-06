# Database-Course-Project---Library-Management-System
This is the final report for the Database Project, create by group 3 from EP16A (National Economics University). Please contact me via address: tuannh2209@gmail.com if you want to know more information about this project.

# 📚 Library Management System - Database Project

> **Course:** Database Management Systems  
> **Institution:** National Economics University (NEU)  
> **Project Type:** Final Course Project  

---

## 📖 1. Project Overview
The **Library Information Manager** is a comprehensive relational database system designed to modernize library operations. It replaces manual tracking methods with an automated, consistent, and secure digital solution.

The system manages the entire lifecycle of library resources, from book inventory and member registration to loan transactions and automated fine calculations.

### Key Objectives:
- **Data Consistency:** Normalized database (3NF) to prevent redundancy.
- **Automation:** Database Triggers automatically handle inventory updates and fine calculations ($2.00/day for overdue items).
- **Analytics:** Python-based visualizations and a **Streamlit Dashboard** for real-time decision-making.

---

## 🛠️ 2. Tech Stack
The project is built using the following technologies:

* **Database:** MySQL 8.0 (MySQL Workbench)
* **Backend Logic:** SQL (Stored Procedures, Triggers, Views)
* **Application Layer:** Python 3.x
* **Libraries:**
    * `pymysql`: Database connector.
    * `pandas`: Data manipulation and reporting.
    * `matplotlib` & `seaborn`: Data visualization.
    * `streamlit`: Interactive Web Dashboard.

---

## 📂 3. Project Structure
The repository is organized as follows:

```text
├── database/
│   ├── schema.sql          # DDL: Creates Tables, Views, Procedures, Triggers
│   └── seed.sql            # DML: Populates sample data (2025 scenarios)
├── src/
│   ├── lib_app.py          # Main Streamlit Web Application
│   ├── library_outputs.py  # Python Script for Console Reports
│   └── library_viz.py      # Python Script for Charts & Graphs
└── README.md               # Project Documentation
