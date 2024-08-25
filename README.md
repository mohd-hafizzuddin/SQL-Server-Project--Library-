# SQL-Server-Project--Library-

**Author:** Mohamad Hafizzudin Bin Yahya

**Project Name:** Library Insights: Analyzing Books, Authors, and Readers

**Email:** hafizz.yahya777@gmail.com

**LinkedIn:** http://www.linkedin.com/in/mohamad-hafizzuddin

INTRODUCTION

The SQL Server (Library) Project is to showcase my skill in SQL server that i acquired from enrolling in Datacamp online courses. By using SQL Server Management Studio (SSMS),  the aim of these project is to show my proficiency in data analysis and data management.

ABOUT THE DATASET

**books Table**
- **isbn**: The unique identifier for each book (no duplicate).
  - Primary Key.
- **book_title**: The title of the book.
- **book_author**: The name of book author (may have duplicate).
- **year_publish**: Year of book publish.
  - (Range from 1376 - 2021).
  - Excluding year = 0  and year >= 2024.
- **publisher**: Name of the book publisher (contain duplicate).

**ratings Table**
- **user_id** : The ID of each user.
  - foreign key references to user_id in users table.
- **isbn** : The unique identifier of each book read by each user (contain duplicate).
  - foreign key references to isbn in books table.
- **book_ratings** : The rating give by each user to book read.
  - (Range from 1376 - 2021).
  - 0 rating indicate implicit rating. 
  
 **users Table**
 - **user_id** : The unique identifier for each user.
   - Primary Key.
 - **location** : The address/location of user .
 - **age** : Age of user.
   - Contain null value.
   - Range from 6 years old - 116 years old.
- **country** : The country which the user came from.
  
**Dataset:** https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset

**Entity Relationship Diagram**

![ERD](https://github.com/hfzzddn/SQL-Server-Project--Library-/assets/157438704/10fa60b9-58e7-4994-81d2-df67b159cb30)

 









