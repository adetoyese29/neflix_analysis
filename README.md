# Netflix Data SQL Analysis
### Project Overview
This project involves exploratory and analytical SQL queries on a dataset containing information about Netflix's global content library. The goal is to uncover trends, patterns, and insights into Netflix’s content offerings using structured query language (SQL).

### Dataset Description
The dataset includes the following key fields:
show_id: Unique identifier
type: Movie or TV show
title: Title of movie or Tv shows
director: Director/directors
cast: Casts
country: Country of production
date_added: Date
release_year: Year released
rating: Rating
duration: Length of movie or TV show
listed_in: Genres listed in	
description: Description

### Analysis Performed
SELECT * FROM netflix;

/*
Task 1:
	Count the number of Movies vs TV Shows
*/

SELECT
	type,
	COUNT(type) as total_number
FROM netflix
GROUP BY
	type;

/*
Task 2:
	Find the most common rating for movies and TV shows
*/

WITH RATINGSCOUNT AS(
	SELECT
		type,
		rating,
		count(*) as rating_count
	FROM netflix
	GROUP BY
		type,
		rating
),
RANKEDRATINGS AS(
	SELECT
		type,
		rating,
		rating_count,
		RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) as rank
	FROM RATINGSCOUNT
)
SELECT
	type,
	rating as most_frequent_rating
FROM RANKEDRATINGS
WHERE rank = 1


/*
Task 3:
	Find the top 5 countries with the most content on Netflix
*/

SELECT * 
FROM 
(
	SELECT
		TRIM(UNNEST(STRING_TO_ARRAY (country, ','))) AS country,
		COUNT(*) AS total_country
	FROM netflix
	GROUP BY 1
) as t1
WHERE country IS NOT NULL
ORDER BY total_country DESC
LIMIT 5;
	
/*
Task 4:
	Identify the longest movie
*/


SELECT 
	title,
	duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

/*
Task 5:
	 List all TV shows with more than 5 seasons
*/


SELECT 
	title,
	duration
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

/*
Task 6:
	Count the number of content items in each genre
*/

SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC;

/*
Task 7:
	Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
*/

SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, release_year
ORDER BY avg_release DESC 
LIMIT 5;

/*
Task 8:
	List all movies that are documentaries
*/

SELECT 
	title,
	listed_in
FROM netflix
WHERE listed_in LIKE '%Documentaries%'

/*
Task 9:
	Find the top 10 actors who have appeared in the highest number of movies produced in India.
*/

SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) as actor,
	COUNT(*) as total
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY total DESC
LIMIT 10;

/*
Task 10:
	Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2;

### Tool Used
PostgreSQL 
