# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix_logo](https://github.com/IshaDataWorks/netflix_sql_project/blob/main/logo.png)

## Objective
# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1.Count the number of movies vs tv shows

SELECT type , COUNT(*)  as total_content
FROM netflix 
GROUP BY type;

**Objective:** Determine the distribution of content types on Netflix.

### 2.Find the most comman rating for movies and tv shows 
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

**Objective:** Identify the most frequently occurring rating for each type of content.


### 3. list all movies released in a specific year(e.g ,2020)
-- filter 2020
-- movies

SELECT * FROM netflix 
WHERE 
     type = 'Movie'
	 AND 
	 release_year = 2020;
   
**Objective:** Retrieve all movies released in a specific year.

### 4.find the top 5 countries with the most content on netflix

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

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. IDENTIFY THE LOGEST MOVIE ?

SELECT * FROM netflix
WHERE 
     type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration ) FROM netflix );
   
**Objective:** Find the movie with the longest duration.

### 6.find the content added in last 5 years ?
SELECT * FROM netflix
WHERE 
     TO_DATE(date_added, 'Month DD ,YYYY') >= CURRENT_DATE - INTERVAL '5 years' ;

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. find all the tv shows/ movies by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8 . LIST ALL THE TV SHOWS WITH MORE THAN 5 SEASONS 

SELECT * FROM netflix 
WHERE  
      type = 'TV Show' 
	  AND
      SPLIT_PART(duration, ' ', 1 ):: numeric  > 5 ;

**Objective:** Identify TV shows with more than 5 seasons.

### 9. count the number of content items in each genre 
SELECT 
       UNNEST(STRING_TO_ARRAY(listed_in , ','))AS genre,
	   COUNT(show_id) as total_content
FROM netflix 
GROUP BY  UNNEST(STRING_TO_ARRAY(listed_in , ','))

**Objective:** Count the number of content items in each genre.


### 10. find each year and the average number of content release by India on netflix.
--return top 5 year with highest avg content release .

SELECT  
      EXTRACT(YEAR FROM TO_DATE(date_added , 'Month DD , YYYY')) AS year ,
	  COUNT(*) AS yearly_content,
	  ROUND(COUNT(*)::numeric/ (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2 ) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;

**Objective:** Calculate and rank years by the average number of content releases by India.


### 11. list all the movies that are documentries

SELECT 
	 *
FROM netflix
WHERE  
     listed_in LIKE '%Documentaries%';
     
**Objective:** Retrieve all movies classified as documentaries.

### 12. find all the content without a director 

SELECT *
FROM netflix
WHERE director IS NULL;

**Objective:** List content that does not have a director.


### 13. find how many movies actor 'Salman Khan' apperared in last 10 years ?
SELECT * FROM netflix
WHERE 
     casts LIKE '%Salman Khan%'
	 AND 
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE ) - 10;

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. find the top 10 actors who have appered in the highest number of movies produced in India.
SELECT 
      UNNEST(STRING_TO_ARRAY(casts , ',')) AS actors,
      COUNT(show_iD) as number_of_movies
FROM netflix
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Catgeorize the content based on the presence of the keyboards 'Kill' and 'voilence' in
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

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Isha Choudhari

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/isha-choudhari-01a882293/)
- **Email**: choudhariisha79@gmail.com
Thank you for your support, and I look forward to connecting with you!
