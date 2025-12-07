# Database-Course-Project---Library-Management-System
This is the final report for the Database Project, create by group 3 from EP16A (National Economics University). Please contact me via address: tuannh2209@gmail.com if you have questions or to know more information about this project.

In this document, we will instruct you how to operate the system, from running the database server to visualizing the data by Python code. We also establish a small web, executed by Streamlit library. Make sure that you have downloaded the SQL, Python code and set up all requirements needed for operating system.

## 1. Setup server on MySQL Workbench
In this project, we use the version 8.0.44 of MySQL Workbench. After you have downloaded the raw SQL files from this project, set up the system as follows:

- **Check your username and localhost:**
   When creating a connection, please note your user-name and the IP Address (the localhost) at the main background of MySQL. Normally, the default name can be set as "root" and the localhost could be "127.0.0.1" as follow:
  <img width="660" height="222" alt="image" src="https://github.com/user-attachments/assets/10fd1dbb-147a-40a9-9a81-3396a9e812af" />
  
- **Check Users and Privileges:**
   We use the Standard Type of Authentication, so if you have set the Caching_Sha2 authentication type, please run file caching_sha2_password.sql and remember to modify the localhost with your IP Address in your database server and your own password. The result of Users and Privileges of the database should be as compatible as follow:
   <img width="1211" height="536" alt="image" src="https://github.com/user-attachments/assets/094a6e92-e450-4369-97c0-7bee23b93e2f" />
   
- **Check the queries:**
   The queries in MySQL are the evidence that prove the system worked normally in both MySQL and Python. To check these, execute the file queries_check.sql and ensure that you have executed all the fundamental files before, include caching_sha2_password.sql (recommended), schema.sql, seed.sql, views.sql, stored_procedured.sql and triggers.sql in order.

## 2. Operating Web and other tasks
We just create a demo web for visualizing the data by Python. However, the warrant of SQL connection in operating Web is also necessary for other tasks, such as tablizing data and visualizations. These are some essential actions to execute the raw Python files successfully:

- **Modify the connection configuration:**
  In part 1, you have already had your username and your database's ID address. With the private password you have create in MySQL Workbench, modify the "CONNECTION CONFIGURATION" in each Python file to ensure that the connection between Python and MySQL is compatible.
  <img width="677" height="306" alt="image" src="https://github.com/user-attachments/assets/cd11454f-dae1-4449-b61f-86e5eb7a1d7b" />

- **Execute the Web-demo Python file:**
  In the Terminal of Python Environment (VSCode, etc), change the primitive direction to the folder that you have downloaded the Web-demo Python file (lib_abb.py). After changing your server information, run `streamlit run lib_app.py` in Terminal. The Web will run automatically if you execute successfully the Web Python file, just experience all the features in the Web.
  
  <img width="714" height="223" alt="image" src="https://github.com/user-attachments/assets/81fa7c43-6528-43f6-9c32-efa1df96d27c" />

## Conclusion
This is a small project served for the final grade of the Database Subject in National Economics University. We admit there will be some mistakes may occur in experiment and execution process. Just let us know your feeling about the project and we will try our best to gain more experience and improve our experiment skills. We would like to give many thanks for your interest and help. These would be the motivations for us to make more complicated projects in the future.
 

