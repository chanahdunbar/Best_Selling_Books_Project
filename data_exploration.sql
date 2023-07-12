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

-- Data Exploration --

-- How many languages are represented in the dataset
--There are 16 distinct languages represented in the dataset -- 
SELECT COUNT(DISTINCT original_language) as distinct_languages
FROM best_selling_books

-- What are the top 5 most commonly represented languages in the dataset --
SELECT original_language, COUNT(original_language) as language_count
FROM best_selling_books
GROUP BY original_language
ORDER BY language_count DESC 
LIMIT 5

-- What time span does the dataset encompass -- 
SELECT MAX(first_published) AS latest_year, MIN(first_published) AS earliest_year
FROM best_selling_books

-- How many books were published each century (2010s, 2000s, 1900s, 1800s, 1700, etc.)
-- This one is giving me errors !!
SELECT
  CASE
  	WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 2010 THEN '2010s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 2000 THEN '2000s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1900 THEN '1900s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1800 THEN '1800s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1700 THEN '1700s'
    ELSE 'Before 1700'
  END AS century,
  COUNT(*) AS book_count
FROM
  best_selling_books
GROUP BY
  CASE
  	WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 2010 THEN '2010s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 2000 THEN '2000s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1900 THEN '1900s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1800 THEN '1800s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1700 THEN '1700s'
    ELSE 'Before 1700'
  END
ORDER BY
  century;

-- Which books sold the most?
SELECT book, original_language, approximate_sales_in_millions
FROM best_selling_books
ORDER BY approximate_sales_in_millions DESC
LIMIT 6

-- What genres are represented?
SELECT DISTINCT(genre)
FROM best_selling_books

--  How many books are considered under multiple genres?
CREATE OR REPLACE FUNCTION book_count_per_genre()
  RETURNS TABLE (book_count BIGINT, genre TEXT)
AS $$
BEGIN
  RETURN QUERY
  SELECT COUNT(book), bsb.genre::TEXT
  FROM best_selling_books AS bsb
  WHERE bsb.genre LIKE '%,%'
  GROUP BY bsb.genre;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM book_count_per_genre();