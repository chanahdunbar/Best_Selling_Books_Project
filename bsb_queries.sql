-- Select all the data
SELECT *
FROM best_selling_books

-- How many languages are represented in the dataset?
SELECT COUNT(DISTINCT original_language) as distinct_languages
FROM best_selling_books

-- List all the languages represented in the dataset
SELECT original_language
FROM best_selling_books
GROUP BY original_language

-- Which author has published the most books?
SELECT author, COUNT(*) AS books_published
FROM best_selling_books
GROUP BY author
ORDER BY books_published DESC

-- Which authors published more than one book?
SELECT author, COUNT(*) AS books_published
FROM best_selling_books
GROUP BY author
HAVING COUNT(*) > 1
ORDER BY books_published DESC

-- List all the genres.
SELECT DISTINCT(genre)
FROM best_selling_books

-- What year was the earliest book published? And what was its corresponding sales?
SELECT first_published AS earliest_year, approximate_sales_in_millions
FROM best_selling_books
WHERE first_published = (
  SELECT MIN(first_published)
  FROM best_selling_books
);

-- What year was the latest book published? And what was its corresponding sales?
SELECT first_published AS latest_year, approximate_sales_in_millions
FROM best_selling_books
WHERE first_published = (
  SELECT MAX(first_published)
  FROM best_selling_books
);

-- Which books sold the most?
SELECT book, original_language, approximate_sales_in_millions
FROM best_selling_books
ORDER BY approximate_sales_in_millions DESC

-- What are the top 5 languages most commonly written in?
SELECT original_language, COUNT(original_language) as language_count
FROM best_selling_books
GROUP BY original_language
ORDER BY language_count DESC 
LIMIT 5

-- How many books were published each century (2000s, 1900s, 1800s, 1700, etc.)?
SELECT
  CASE
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
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 2000 THEN '2000s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1900 THEN '1900s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1800 THEN '1800s'
    WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1700 THEN '1700s'
    ELSE 'Before 1700'
  END
ORDER BY
  century;

-- What century published the highest number of books?
CREATE OR REPLACE FUNCTION book_count_per_century()
  RETURNS TABLE (book_count BIGINT, century TEXT)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*) AS book_count,
    CASE
      WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 2000 THEN '2000s'
      WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1900 THEN '1900s'
      WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1800 THEN '1800s'
      WHEN EXTRACT(YEAR FROM TO_DATE(first_published, 'YYYY')) > 1700 THEN '1700s'
      ELSE 'Before 1700'
    END AS century
  FROM best_selling_books
  GROUP BY century
  ORDER BY book_count DESC;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM book_count_per_century()
LIMIT 1;

-- Which books sold the most?
SELECT book, original_language, approximate_sales_in_millions
FROM best_selling_books
ORDER BY approximate_sales_in_millions DESC

--Which books sold the least?
SELECT book, original_language, approximate_sales_in_millions
FROM best_selling_books
ORDER BY approximate_sales_in_millions

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

