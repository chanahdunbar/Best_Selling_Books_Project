DROP TABLE best_selling_books

CREATE TABLE best_selling_books (
	book VARCHAR(100),
	author VARCHAR(60),
	original_language VARCHAR(30),
	first_published VARCHAR(15),
	approximate_sales_in_millions NUMERIC,
	genre VARCHAR(300))
	
SELECT *
FROM best_selling_books