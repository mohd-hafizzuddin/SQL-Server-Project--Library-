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
CREATE OR ALTER PROCEDURE favbook (@ID INT)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM ratings WHERE User_ID = @ID) AND EXISTS (SELECT 1 FROM users WHERE User_ID = @ID) -- check if @ID parameter exists in ratings table
        BEGIN                                                                                                      -- check if @ID parameter exists in users table
	     IF EXISTS ( --condition that check the existence of fav book                                          -- AND logical operator combine 2 condition 
		    SELECT TOP 1 1                                                                                 --Ensure both condition must be true
			FROM books b
				INNER JOIN ratings r
				ON b.ISBN = r.ISBN
				INNER JOIN users u
				ON u.User_ID = r.User_ID
				WHERE r.Book_Rating > 7
				AND
				r.User_ID = @ID
                )
		BEGIN                                  -- if exists then we select 
				SELECT b.Book_Title, 
				       r.User_ID, 
					   r.Book_Rating,
					   u.Age,
					   u.country
				FROM books b
				INNER JOIN ratings r
				ON b.ISBN = r.ISBN
				INNER JOIN users u
				ON u.User_ID = r.User_ID
				WHERE r.Book_Rating > 7
				AND
				r.User_ID = @ID;
                END
             ELSE                           -- if not exist then is show no favourite book
		        BEGIN
                             PRINT 'No favourite book found for User ID' + CAST(@ID AS nvarchar);
                        END
	END
	ELSE
	     BEGIN --if you put @ID parameter that does not exist then it raise an error
                   DECLARE @ErrorMessage nvarchar(200) = 'User_ID' + CAST(@ID AS nvarchar) + ' does not exist on both users and ratings table.';
                   RAISERROR(@ErrorMessage,16,1)
	      END
END;
```

```sql
EXEC favbook @ID = 1;
```

Msg 50000, Level 16, State 1, Procedure favbook, Line 372 [Batch Start Line 2]
User_ID1 does not exist on both users and ratings table.

```sql
EXEC favbook @ID = 83;
```

No favourite book found for User ID83

```sql
EXEC favbook @ID = 183;
```

| Book_Title                                    | User_ID | Book_Rating | Age | Country  |
|-----------------------------------------------|---------|-------------|-----|----------|
| Folio Junior L'histoire De Monsieur Sommer   | 183     | 8           | 27  | PORTUGAL |
| Fahrenheit 451                               | 183     | 9           | 27  | PORTUGAL |
| Que Se Mueran Los Feos (Fabula)              | 183     | 9           | 27  | PORTUGAL |
| Estudios sobre el amor                       | 183     | 8           | 27  | PORTUGAL |











