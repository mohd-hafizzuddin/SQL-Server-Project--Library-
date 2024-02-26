**FUNCTION AND TRIGGER**

**1. Find the average book by author**

```sql
CREATE OR ALTER FUNCTION avgbookbyauthor (@Book_Author nvarchar (300))
RETURNS TABLE
AS
RETURN
(
SELECT b.Book_Author,
       b.Book_Title,
       ROUND(AVG(CAST (r.Book_Rating AS NUMERIC)),2) AS 'Avg_Rating'
FROM books b
INNER JOIN ratings r
ON b.ISBN = r.ISBN
WHERE Book_Author LIKE @Book_Author + '%'
GROUP BY b.Book_Author,b.Book_Title
HAVING ROUND(AVG(CAST (r.Book_Rating AS NUMERIC)),2) > 6
);
```

| Book_Author         | Book_Title                                               | Avg_Rating |
|---------------------|----------------------------------------------------------|------------|
| Virginia Henley     | Wild Hearts                                              | 8.000000   |
| Virginia Kroll      | She Is Born A Celebration of Daughters                  | 10.000000  |
| Virginia Reynolds   | The Little Black Book of Cocktails...                   | 10.000000  |
| Virginia Woolf      | Language Arts Resources from Recycables...               | 8.000000   |
| Virginia Mae Axline | Dibs.                                                    | 7.000000   |
| Virginia Rounding   | Grandes Horizontales                                     | 8.000000   |
| Virginia Andrews    | Fallen Hearts (Isis Series)                              | 8.000000   |
| Virginia Smith      | The Ropemaker's Daughter                                 | 8.000000   |
| Virginia Wolf       | Las Olas (Fabula)                                        | 10.000000  |
| Virginia Woolf      | Les Vagues                                               | 8.000000   |
| Virginia Woolf      | Olas, Las                                                | 8.000000   |

**2. Find the favourite book by user ID**


```sql
CREATE OR ALTER FUNCTION favbook (@ID INT)
RETURNS TABLE
AS
RETURN
(
          WITH rank AS ( -- Inside this cte we use RANK() to rank all the book by each user
		  SELECT ISBN,        
                 User_ID,
                 Book_Rating,
	             RANK() OVER (PARTITION BY User_ID ORDER BY Book_Rating DESC) AS 'row_num'
          FROM ratings)

          SELECT b.Book_Title AS 'Favourite_Book',r.User_ID,r.Book_Rating -- We then select book title by each user ID with book rating more than 7
          FROM rank r                                                     -- If the user do not have book rating more than 7, we assume the user do not have any favourite book
          INNER JOIN books b
          ON r.ISBN = b.ISBN
          WHERE row_num = 1 
                AND Book_Rating > 7 
	            AND User_ID = @ID
);
```
There are user_ID in users table that not exists in ratings table.
So it create a weakness in above function if you put any user_ID that does not exist in ratings table.


| Favourite_Book | User_ID | Book_Rating |
|----------------|---------|-------------|
| If I'd Known Then What I Know Now Why Not Learn from the Mistakes of Others? You Can't Afford to Make Them All Yourself | 12 | 10 |
