USE library;
GO

/*SELECT * FROM books: --271360 rows

SELECT * FROM ratings;

SELECT * FROM users;

--Data cleaning for books table
--Set ISBN to become uppercase for data consistency


UPDATE books
SET ISBN = UPPER(ISBN);

--handle duplicate

WITH find_dup AS (
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY ISBN ORDER BY ISBN) AS row_num
FROM books)

--SELECT * FROM find_dup WHERE row_num > 1; -- 314 duplicate

DELETE FROM find_dup WHERE row_num > 1; -- delete the duplicate

(314 rows affected)

Completion time: 2024-02-20T15:08:57.8631086+08:00

SELECT Year_Of_Publication
FROM books
WHERE Year_Of_Publication > 0
ORDER BY Year_Of_Publication DESC; 
--There some rows in Year_Of_Publication column that illogical
--For example there are book publish in year 2050
-- We will delete row where Year_Of_Publication >= 2024
--However the data deleted will be store into new table called books_record

 CREATE TABLE books_record (
 ISBN nvarchar(20),
 Book_Title nvarchar(300),
 Book_Author nvarchar(300),
 Year_Of_Publication smallint,
 Publisher nvarchar(300));

 CREATE TRIGGER store_books_deleted
 ON books
 AFTER DELETE
 AS 
    INSERT INTO books_record( ISBN,Book_Title,Book_Author,Year_Of_Publication,Publisher)
	SELECT * FROM deleted;

--delete rows in books where year publish >= 2024

DELETE FROM books WHERE Year_Of_Publication >= 2024;

SELECT * FROM books_record; -- check the new table;

SELECT * FROM users; -- 278858 rows

SELECT DISTINCT User_ID FROM users; --278858 (no duplicate)

SELECT MIN(age),MAX(age) FROM users; --age range from  0 - 244

-- we will remove row where age (0-5) and age > 116

DELETE FROM users 
WHERE age BETWEEN 0 AND 5
OR
      age > 116;

SELECT MAX(age),MIN(age) FROM users; -- range (6-116)

SELECT --TOP 4599
       *,
	   SUBSTRING(location,LEN(location)-CHARINDEX(',',REVERSE(location))+3,LEN(location)) AS 'country'
FROM users
ORDER BY 'country' ASC; 

-- There are 4599 rows of country table with unknown country.
-- We will add new column in users table name country
-- we will then populate the rows in country column based on location
--  we extract only country

ALTER TABLE users
ADD country nvarchar(20);

ALTER TABLE users
ALTER COLUMN country nvarchar(50);

UPDATE users
SET country = SUBSTRING(location,LEN(location)-CHARINDEX(',',REVERSE(location))+3,LEN(location)); 

--set the NULL value in country into 'unknown'

UPDATE users
SET country = 'unknown'
WHERE country = ' ';

UPDATE users
SET country = 'unknown'
WHERE country IN (
                   SELECT TOP 23 country 
				   FROM users 
				   ORDER BY country);

WITH c AS (
SELECT 
       REPLACE(
               REPLACE (
                       REPLACE(
	                           REPLACE(
	                                   REPLACE(country,'"',''),'/',''),'!',''),'=',''),'\','') AS country FROM users) --679 > 602

SELECT DISTINCT country FROM c ORDER BY country;

UPDATE users
SET country = REPLACE(
                      REPLACE (
                              REPLACE(
	                                  REPLACE(
	                                          REPLACE(country,'"',''),'/',''),'!',''),'=',''),'\','');

UPDATE users
SET country = UPPER(country);

SELECT * INTO new_ratings
FROM ratings
WHERE ISBN IN ( 
      SELECT ISBN FROM books)
	  AND
	  User_ID IN (SELECT User_ID FROM users);

SELECT * FROM new_ratings;

ALTER TABLE books
ADD CONSTRAINT pk_books PRIMARY KEY (isbn);

ALTER TABLE users
ADD CONSTRAINT pk_users PRIMARY KEY (User_ID);

EXEC sp_rename 'new_ratings', 'ratings';

ALTER TABLE ratings
ADD CONSTRAINT fk_isbn FOREIGN KEY (ISBN) REFERENCES books(ISBN);

ALTER TABLE ratings
ADD CONSTRAINT fk_ID FOREIGN KEY (User_ID) REFERENCES users(User_ID);

SELECT * FROM books b INNER JOIN ratings r ON b.ISBN = r.ISBN INNER JOIN users u ON r.User_ID = u.User_ID; 

-Number of book by each author
SELECT Book_Author, 
       COUNT(*) AS 'Count_Book'
FROM books
GROUP BY Book_Author
ORDER BY 'Count_Book' DESC;

-Number of book publish by each publisher
SELECT Publisher, 
       COUNT(*) AS 'Count_Book_Publish'
FROM books
GROUP BY Publisher
ORDER BY 'Count_Book_Publish' DESC;

-Number of book publish by each year
SELECT Year_Of_Publication, 
       COUNT(*) AS 'Count_Book_Publish_Per_Year'
FROM books
GROUP BY Year_Of_Publication
ORDER BY 'Count_Book_Publish_Per_Year' DESC;

--Average of book rating
SELECT b.Book_Title,
	   b.ISBN,
	   ROUND(AVG(CAST (r.Book_Rating AS NUMERIC)),2) AS 'Average_Rating'
FROM books b
INNER JOIN ratings r
ON b.ISBN = r.ISBN
WHERE Book_Rating > 0
GROUP BY b.Book_Title,b.ISBN
ORDER BY 'Average_Rating' DESC;

-Average of book rating by each publisher

SELECT b.Publisher, 
       AVG(CAST (r.Book_Rating AS NUMERIC)) AS 'Avg_Rating'
FROM books b
INNER JOIN ratings r
ON b.ISBN = r.ISBN
GROUP BY Publisher
HAVING AVG(r.Book_Rating) > 7
ORDER BY 'Avg_Rating' DESC;

The count of user by age group
SELECT
       COUNT(CASE WHEN age >= 6 AND age < 29 THEN 1 END) AS '6-28', 
       COUNT(CASE WHEN age >= 29 AND age < 52 THEN 1 END) AS '29-51',
	   COUNT(CASE WHEN age >= 52 AND age < 75 THEN 1 END) AS '52-74',
	   COUNT(CASE WHEN age >= 75 AND age < 98 THEN 1 END) AS '75-97',
	   COUNT(CASE WHEN age >= 98 THEN 1 END) AS '98-116'
FROM users
WHERE age IS NOT NULL;

-The average of book rating by each age group
SELECT 
    CASE 
        WHEN u.age >= 6 AND u.age < 29 THEN '6-28' 
        WHEN u.age >= 29 AND u.age < 52 THEN '29-51'
        WHEN u.age >= 52 AND u.age < 75 THEN '52-74'
        WHEN u.age >= 75 AND u.age < 98 THEN '75-97'
        WHEN u.age >= 98 THEN '98-116'
    END AS 'Age_Range',
    AVG(CAST(r.Book_Rating AS NUMERIC)) AS 'Avg_Rating'
FROM 
    users u
INNER JOIN 
    ratings r ON r.User_ID = u.User_ID
WHERE 
    u.age IS NOT NULL
    AND r.Book_Rating > 0
GROUP BY 
    CASE 
        WHEN u.age >= 6 AND u.age < 29 THEN '6-28' 
        WHEN u.age >= 29 AND u.age < 52 THEN '29-51'
        WHEN u.age >= 52 AND u.age < 75 THEN '52-74'
        WHEN u.age >= 75 AND u.age < 98 THEN '75-97'
        WHEN u.age >= 98 THEN '98-116'
    END;

- The number of user by each country
SELECT country, 
       COUNT(*) AS 'Count_User'
FROM users
GROUP BY country
ORDER BY 'Count_User' DESC;


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

SELECT * FROM avgbookbyauthor('Virginia');

--Calculate avg rating of book that were read more than 10 times
--excluding 0 rating

CREATE OR ALTER FUNCTION avgbook()
RETURNS TABLE
AS
RETURN
(
WITH count AS (
                SELECT ISBN, 
                COUNT(*) AS 'Book_Count'
                FROM ratings
				WHERE Book_Rating > 0
                GROUP BY ISBN
                HAVING COUNT(*) > 10)


SELECT b.Book_Title, 
       r.ISBN, 
	   ROUND(AVG(CAST(r.Book_Rating AS NUMERIC)),2) AS 'Avg_Rating'
FROM books b
INNER JOIN ratings r
ON b.ISBN = r.ISBN
WHERE r.ISBN IN 
               (SELECT ISBN FROM count)
GROUP BY b.Book_Title,r.ISBN
);

SELECT * FROM avgbook() ORDER BY Avg_Rating DESC;


CREATE TRIGGER refreshavgbookbyauthortriggerR
ON ratings
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
	EXEC sp_refreshsqlmodule 'avgbookbyauthor'; 
END;

CREATE TRIGGER refreshavgbookbyauthortriggerB
ON books
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
	EXEC sp_refreshsqlmodule 'avgbookbyauthor'; 
END;

CREATE OR ALTER PROCEDURE favbook (@ID INT)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM ratings WHERE User_ID = @ID) AND EXISTS (SELECT 1 FROM users WHERE User_ID = @ID)
	BEGIN
	     IF EXISTS (
		    SELECT TOP 1 1
			FROM books b
				INNER JOIN ratings r
				ON b.ISBN = r.ISBN
				INNER JOIN users u
				ON u.User_ID = r.User_ID
				WHERE r.Book_Rating > 7
				AND
				r.User_ID = @ID
                )
		BEGIN
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
		ELSE
		        BEGIN
					PRINT 'No favourite book found for User ID' + CAST(@ID AS nvarchar);
				END
	END
	ELSE
	BEGIN
				DECLARE @ErrorMessage nvarchar(200) = 'User_ID' + CAST(@ID AS nvarchar) + ' does not exist on both users and ratings table.';
				RAISERROR(@ErrorMessage,16,1)
	END
END;

EXEC favbook @ID = 183;*/








