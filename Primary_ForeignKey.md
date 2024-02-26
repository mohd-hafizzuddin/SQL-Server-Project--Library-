**List of Primary and Foreign Key**

1. Primary key on books table

```sql
ALTER TABLE books
ADD CONSTRAINT pk_books PRIMARY KEY (isbn);
```

2. Primary key on users table

```sql
ALTER TABLE users
ADD CONSTRAINT pk_users PRIMARY KEY (User_ID);
```

3. Foreign key on ratings table

```sql
ALTER TABLE ratings
ADD CONSTRAINT fk_isbn FOREIGN KEY (ISBN) REFERENCES books(ISBN);

ALTER TABLE ratings
ADD CONSTRAINT fk_ID FOREIGN KEY (User_ID) REFERENCES users(User_ID);
```
