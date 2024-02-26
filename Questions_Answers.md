**QUESTIONS AND ANSWERS.**

**1. Number of book produce by each author**

```sql
SELECT TOP 5
       Book_Author, 
       COUNT(*) AS 'Count_Book'
FROM books
GROUP BY Book_Author
ORDER BY 'Count_Book' DESC;
```
| Author_Name         | Count_Book |
|---------------------|------------|
| Agatha Christie     | 635        |
| William Shakespeare | 569        |
| STEPHEN KING        | 532        |
| Ann M. Martin       | 423        |
| FRANCINE PASCAL     | 418        |

**2. Number of book publish by each publisher**

```sql
SELECT TOP 5
       Publisher, 
       COUNT(*) AS 'Count_Book_Publish'
FROM books
GROUP BY Publisher
ORDER BY 'Count_Book_Publish' DESC;
```

| Publisher         | Count_Book_Publish |
|-------------------|--------------------|
| Harlequin         | 7533               |
| Silhouette        | 4218               |
| Pocket            | 3896               |
| Ballantine Books  | 3772               |
| Bantam Books      | 3642               |

**3. Number of book publish by each year**

```sql
SELECT TOP 5 
       Year_Of_Publication, 
       COUNT(*) AS 'Count_Book_Publish_Per_Year'
FROM books
GROUP BY Year_Of_Publication
ORDER BY 'Count_Book_Publish_Per_Year' DESC;
```

| Year_Of_Publication | Count_Book_Publish_Per_Year |
|---------------------|-----------------------------|
| 2002                | 17615                       |
| 1999                | 17410                       |
| 2001                | 17337                       |
| 2000                | 17214                       |
| 1998                | 15752                       |

**4. Average of book rating by each book**

```sql
SELECT TOP 5
       b.Book_Title,
	     b.ISBN,
	     ROUND(AVG(CAST (r.Book_Rating AS NUMERIC)),2) AS 'Average_Rating'
FROM books b
INNER JOIN ratings r
ON b.ISBN = r.ISBN
WHERE Book_Rating > 0
GROUP BY b.Book_Title,b.ISBN
ORDER BY 'Average_Rating' DESC;
```

| Book_Title                                           | ISBN       | Average_Rating |
|------------------------------------------------------|------------|----------------|
| Farmer Boy (Little House)                           | 006026425X | 10.000000      |
| The Bartender's Bible 1001 Mixed Drinks             | 006016722X | 10.000000      |
| Betsy-Tacy and Tib                                  | 006024416X | 10.000000      |
| Tarot                                               | 000710331X | 10.000000      |
| The Emerald Cavern (Graham, Mitchell. Fifth Ring, Bk. 2.) | 006050675X | 10.000000      |


**5. Average of book rating by each publisher**

```sql
SELECT b.Publisher, 
       AVG(CAST (r.Book_Rating AS NUMERIC)) AS 'Avg_Rating'
FROM books b
INNER JOIN ratings r
ON b.ISBN = r.ISBN
GROUP BY Publisher
HAVING AVG(r.Book_Rating) > 7
ORDER BY 'Avg_Rating' DESC;
```

| Publisher                       | Avg_Rating |
|---------------------------------|------------|
| Sportverlag                     | 10.000000  |
| Open University Worldwide       | 10.000000  |
| Kepustakaan Populer Gramedia    | 10.000000  |
| Real Kids Real Adventures       | 10.000000  |
| English Heritage                | 10.000000  |


**6. The count of user by age group**

```sql
SELECT
       COUNT(CASE WHEN age >= 6 AND age < 29 THEN 1 END) AS '6-28', 
       COUNT(CASE WHEN age >= 29 AND age < 52 THEN 1 END) AS '29-51',
	     COUNT(CASE WHEN age >= 52 AND age < 75 THEN 1 END) AS '52-74',
	     COUNT(CASE WHEN age >= 75 AND age < 98 THEN 1 END) AS '75-97',
	     COUNT(CASE WHEN age >= 98 THEN 1 END) AS '98-116'
FROM users
WHERE age IS NOT NULL;
```

| Range   | Count |
|---------|-------|
| 6-28    | 65301 |
| 29-51   | 78425 |
| 52-74   | 22378 |
| 75-97   | 705   |
| 98-116  | 299   |

**7. The average of book rating by age group**

```sql
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
```

| Age_Range | Avg_Rating |
|-----------|------------|
| 29-51     | 7.608805   |
| 52-74     | 7.997579   |
| 6-28      | 7.690591   |
| 75-97     | 7.492063   |
| 98-116    | 7.190000   |

**8. Number of user by each country**

```sql
SELECT TOP 5
       country, 
       COUNT(*) AS 'Count_User'
FROM users
GROUP BY country
ORDER BY 'Count_User' DESC;
```

| Country         | Count_User |
|-----------------|------------|
| USA             | 139319     |
| CANADA          | 21609      |
| UNITED KINGDOM  | 18483      |
| GERMANY         | 17024      |
| SPAIN           | 13197      |








