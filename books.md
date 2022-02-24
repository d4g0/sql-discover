# books 
- [grup by explanation](!https://learnsql.com/blog/group-by-in-sql-explained/)


```sql

create Table books(
	id serial PRIMARY KEY,
	title text not null DEFAULT 'book_title',
	author text not null DEFAULT 'book_author',
	genre text not null DEFAULT 'book_genre',
	qty integer not null DEFAULT 0
);

insert into books (title, author, genre, qty) values ('Les Trois Mousquetaires', 'Alexandre Dumas', 'adventure', 4),
	('A Game of Thrones', 'George R.R. Martin', 'fantasy', 5),
	('Pride and Prejudice', 'Jane Austen', 'romance', 2),
	('Vampire Academy', 'Richelle Mead', 'fantasy', 3),
	('Ivanhoe', 'Walter Scott', 'adventure', 3),
	('Armance', 'Stendhal', 'romance', 1);

```

