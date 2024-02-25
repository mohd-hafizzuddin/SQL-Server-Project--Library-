# SQL-Server-Project--Library-

**Author:** Mohamad Hafizzuddin Bin Yahya

**Email:** hafizz.yahya777@gmail.com

**LinkedIn:** http://www.linkedin.com/in/mohamad-hafizzuddin

INTRODUCTION

The SQL Server (Library) Project is to showcase my skill in SQL server that i acquired from enrolling in Datacamp online courses. By using tool in Microsoft SQL Server the aim of these project is to show my proficiency in data analysis and data management.

ABOUT THE DATASET

**books Table**

**- ISBN**                    : The unique identifier for each book (no duplicate).
                                Primary Key.
**- Book_Title**              : The title of the book.
**- Book_Author**             : The name of book author (may have duplicate).
**- Year_Of_Publication**     : Year of book publish.
                                (Range from 1376 - 2021).
                                Excluding year = 0  and year >+ 2024.
**- Publisher**               : Name of the book publisher (contain duplicate).

ratings Table

- User_ID                 : The ID of each user.
                            Foreign key.
  
- ISBN                    : The unique identifier of each book read by each user (contain duplicate).
                            Foreign key.
- Book_Rating             : The rating give by each user to book read.
                            Range from 1 - 10 rating (explicit rating).
                            0 rating indicate implicit rating.

users Table

-User_ID                  : The unique identifier for each user
                            Primary Key
                            
-Location                 : The address/location of user 

-Age                      : Age of user
                            Range from 6 years old - 116 years old
                            
-Country                  : The country which the user come from










