-- NETFLIX PROJECT 

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
	show_id VARCHAR(6) ,
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT ,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)

);

SELECT * FROM netflix;

SELECT COUNT(*) as total_content 
FROM netflix;

SELECT DISTINCT type 
FROM netflix;

-- 15 Business Problems 

--1.Count the number of movies vs tv shows

SELECT type , COUNT(*)  as total_content
FROM netflix 
GROUP BY type;

-- 2.Find the most comman rating for movies and tv shows 
SELECT 
       type ,
	   rating 
FROM 

(
SELECT type,
      rating,
	  COUNT(*),
	  RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) as ranking 
FROM netflix
GROUP BY 1,2
) as t1
WHERE ranking = 1;
--ORDER BY 1,3 DESC;

-- 3. list all movies released in a specific year(e.g ,2020)
-- filter 2020
-- movies

SELECT * FROM netflix 
WHERE 
     type = 'Movie'
	 AND 
	 release_year = 2020;


-- 4.find the top 5 countries with the most content on netflix

SELECT 
      UNNEST(STRING_TO_ARRAY(country , ',')) as new_country ,
	  COUNT(show_id) as total_content 
FROM netflix 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;

--SELECT 
--     UNNEST(STRING_TO_ARRAY(country , ',')) as new_country 
--FROM netflix 


-- 5. IDENTIFY THE LOGEST MOVIE ?

SELECT * FROM netflix
WHERE 
     type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration ) FROM netflix );

-- 6.find the content added in last 5 years ?
SELECT * FROM netflix
WHERE 
     TO_DATE(date_added, 'Month DD ,YYYY') >= CURRENT_DATE - INTERVAL '5 years' ;


-- 7. find all the tv shows/ movies by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';


-- 8 . LIST ALL THE TV SHOWS WITH MORE THAN 5 SEASONS 

SELECT * FROM netflix 
WHERE  
      type = 'TV Show' 
	  AND
      SPLIT_PART(duration, ' ', 1 ):: numeric  > 5 ;

	  
-- 9. count the number of content items in each genre 
SELECT 
       UNNEST(STRING_TO_ARRAY(listed_in , ','))AS genre,
	   COUNT(show_id) as total_content
FROM netflix 
GROUP BY  UNNEST(STRING_TO_ARRAY(listed_in , ','))

-- 10. find each year and the average number of content release by India on netflix.
--return top 5 year with highest avg content release .

SELECT  
      EXTRACT(YEAR FROM TO_DATE(date_added , 'Month DD , YYYY')) AS year ,
	  COUNT(*) AS yearly_content,
	  ROUND(COUNT(*)::numeric/ (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2 ) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;

--11. list all the movies that are documentries

SELECT 
	 *
FROM netflix
WHERE  
     listed_in LIKE '%Documentaries%';

-- 12. find all the content without a director 

SELECT *
FROM netflix
WHERE director IS NULL;


-- 13. find how many movies actor 'Salman Khan' apperared in last 10 years ?
SELECT * FROM netflix
WHERE 
     casts LIKE '%Salman Khan%'
	 AND 
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE ) - 10;

-- 14. find the top 10 actors who have appered in the highest number of movies produced in India.
SELECT 
      UNNEST(STRING_TO_ARRAY(casts , ',')) AS actors,
      COUNT(show_iD) as number_of_movies
FROM netflix
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Catgeorize the content based on the presence of the keyboards 'Kill' and 'voilence' in
-- the description field . label content containing these keyboards as 'Bad' and all other
-- content as 'Good'. count how many items fall into each category .

WITH new_table 
AS(
SELECT *,
       CASE 
	   WHEN description ILIKE '%Kill%' OR 
	        description ILIKE '%voilence%' THEN 'Bad_Content'
		    ELSE 'Good_content'
	   END category 
FROM netflix
)

SELECT category ,
        COUNT(*) AS total_content 
FROM new_table
GROUP BY 1;











