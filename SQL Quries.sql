USE imdb;
-- Run above line to make imdb as default schema to run the below code
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Code Below

SELECT 
    COUNT(*) AS DIRECTOR_MAPPING_ROWS
FROM
    director_mapping;
SELECT 
    COUNT(*) AS GENRE_ROWS
FROM
    genre;
SELECT 
    COUNT(*) AS MOVIE_ROWS
FROM
    movie;
SELECT 
    COUNT(*) AS NAMES_ROWS
FROM
    names;
SELECT 
    COUNT(*) AS RATINGS_ROWS
FROM
    ratings;
SELECT 
    COUNT(*) AS ROLE_MAPPING_ROWS
FROM
    role_mapping;

-- no of rows in director_mapping = 3867
-- no of rows in  genre = 14662
-- no of rows in movie = 7997
-- no of rows in names = 25735
-- no of rows in rating = 7997
-- no of rows in role_mapping = 15615
-- The above information was noted after running the code


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    COUNT(*)
FROM
    movie
WHERE
    title IS NULL;
SELECT 
    COUNT(*)
FROM
    movie
WHERE
    date_published IS NULL;
SELECT 
    COUNT(*)
FROM
    movie
WHERE
    duration IS NULL;
SELECT 
    COUNT(*)
FROM
    movie
WHERE
    country IS NULL;
SELECT 
    COUNT(*)
FROM
    movie
WHERE
    worlwide_gross_income IS NULL;
SELECT 
    COUNT(*)
FROM
    movie
WHERE
    languages IS NULL;
SELECT 
    COUNT(*)
FROM
    movie
WHERE
    production_company IS NULL;

-- we found column named country, worlwide_gross_income, languages, production_company are having null values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released in each year
SELECT 
    year, COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY year;

-- Movie released in year 2017, 2018, 2019 are 3052, 2944, 2001 respectively

-- Number of movies released in each month 
SELECT 
    MONTH(date_published) AS Month_Number,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY Month_Number
ORDER BY Month_Number; 

-- Movie released in months starting from Jan to Dec are 804, 640, 824, 680, 625, 580, 493, 678, 809, 801, 625 and 438 respectively

-- Insight are mention below.
-- The highest number of movies is produced in the month of March.
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(DISTINCT id) AS Number_of_Movies, year
FROM
    movie
WHERE
    year = 2019
        AND (country LIKE '%USA%'
        OR country LIKE '%INDIA%');

-- Insight
-- In 2019, there were 1059 films made in the USA and India.


-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre; 


-- Insight
-- Their are more than 13 genre altogether.
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(m.id) AS number_of_movies
FROM
    movie AS m
        INNER JOIN
    genre AS g
WHERE
    g.movie_id = m.id
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;





-- Insight 
-- Drama genre has the highest number of movies that is 4285.
/* So, based on the insight that we just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH ct_genre AS
(
	SELECT 
    movie_id, COUNT(genre) AS number_of_movies
	FROM genre
	GROUP BY movie_id
	HAVING number_of_movies=1
)

SELECT COUNT(movie_id) AS number_of_movies
FROM ct_genre;





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie AS m
        INNER JOIN
    genre AS g ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Insight 
-- Action genre is having the max duration with 112.88 .

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:



WITH genre_thiller AS(
	SELECT genre,
	COUNT(*) AS movie_count,
	Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
	FROM movie AS m
	INNER JOIN genre AS g
	ON g.movie_id = m.id
	GROUP BY   genre
	ORDER BY genre_rank
)
SELECT * from genre_thiller where genre = "THRILLER";



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS min_median_rating
FROM
    ratings;
   

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rank_movie AS
(
SELECT 
title, avg_rating, DENSE_Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
from movie as m
INNER JOIN ratings AS r
ON r.movie_id = m.id 
)
SELECT * from rank_movie where movie_rank <= 10;



-- Insight 
-- KIRKEY AND LOVEIN KILNERRY IS HAVING THE BEST AVERAGE RATING AMONG ALL THE REST.
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
production_company, 
count(movie_id) AS movie_count, 
DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
from ratings as r
INNER JOIN movie as m
ON r.movie_id = m.id
WHERE avg_rating > 8
AND production_company IS NOT NULL
GROUP BY production_company; 

-- Insight
-- DREAM WARRIOR PICTURES AND NATIONAL THEATRE LIVE TOP THE LIST.

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    genre, COUNT(r.movie_id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    genre AS g ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    year = 2017
        AND MONTH(date_published) = 3
        AND country LIKE '%USA%'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- Insight
-- Drama genre tops the poll with 24 counts followed by Comedy with 9 and Action with 8.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
     title, avg_rating, genre
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    genre AS g ON g.movie_id = m.id
WHERE
    title LIKE 'The%' AND avg_rating > 8
ORDER BY avg_rating DESC;


-- Insight 
-- The Brighton Miracleis having the highest avg_rating as 9.5 whose title start with 'The'

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    median_rating, COUNT(*) AS movie_count
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;


-- Insight
-- Total 361 movies have been published 1st April 2019 to 1 April 2019 with median rating as 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    country, SUM(total_votes) AS votes_count
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    country = 'germany' OR country = 'italy'
GROUP BY country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre AS
(
 SELECT genre,
 Count(m.id) AS movie_count ,
 Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
 FROM movie AS m
 INNER JOIN genre AS g
 ON g.movie_id = m.id
 INNER JOIN ratings AS r
 ON r.movie_id = m.id
 WHERE avg_rating > 8
 GROUP BY genre limit 3 
 )	
SELECT n.NAME AS director_name ,
Count(d.movie_id) AS movie_count
FROM director_mapping  AS d
INNER JOIN genre G
using (movie_id)
INNER JOIN names AS n
ON n.id = d.name_id
INNER JOIN top_genre
using (genre)
INNER JOIN ratings
using (movie_id)
WHERE avg_rating > 8
GROUP BY NAME
ORDER BY movie_count DESC limit 3;


-- Insight
-- James Mangold, Joe Russo and Anthony Russo are top 3 Ranked director.
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    N.name AS actor_name, COUNT(movie_id) AS movie_count
FROM
    role_mapping AS RM
        INNER JOIN
    movie AS M ON M.id = RM.movie_id
        INNER JOIN
    ratings AS R USING (movie_id)
        INNER JOIN
    names AS N ON N.id = RM.name_id
WHERE
    R.median_rating >= 8
        AND category = 'ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- Insight
-- Mammooty and Mohanlal are the two best actor among others.
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, 
SUM(total_votes) AS vote_count,
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company
LIMIT 3;



-- Insight
-- Marvel Studios, Twentieth Century Fox and Warner Bros are the best 3 Production company

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH top_actor AS 
(
	SELECT 
    b.NAME AS actor_name,
    SUM(c.total_votes) AS total_votes,
    COUNT(DISTINCT a.movie_id) AS movie_count,
    ROUND(SUM(c.avg_rating * c.total_votes) / SUM(c.total_votes),
            2) AS actor_avg_rating
FROM
    role_mapping a
        INNER JOIN
    names b ON a.name_id = b.id
        INNER JOIN
    ratings c ON a.movie_id = c.movie_id
        INNER JOIN
    movie d ON a.movie_id = d.id
WHERE
    a.category = 'actor'
        AND d.country LIKE '%India%'
GROUP BY a.name_id , b.NAME
HAVING COUNT(DISTINCT a.movie_id) >= 5
)
SELECT *,
Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM top_actor
limit 5;  




-- Insight
-- Vijay Sethupathi is among top actor in India with actor average rating of 8.42 and total votes of 23115
-- FOLLOWED BY FAHADH FAASIL AND YOGI BABU WITH 7.99 AND 7.83 AS AVERAGE RATING RESPECTIVELY
-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH top_actoress AS 
(
SELECT b.NAME AS actoress_name,
Sum(c.total_votes) AS total_votes,
Count(DISTINCT a.movie_id) AS movie_count,
Round(Sum(c.avg_rating * c.total_votes) / Sum(c.total_votes), 2) AS actoress_avg_rating
FROM role_mapping a
INNER JOIN names b
ON a.name_id = b.id
INNER JOIN ratings c
ON a.movie_id = c.movie_id
INNER JOIN movie d
ON a.movie_id = d.id
WHERE  a.category = 'actress'
AND d.country LIKE '%India%'
AND languages = 'hindi'
GROUP  BY a.name_id,
b.NAME
HAVING Count(DISTINCT a.movie_id) >= 3
)
SELECT *,
Rank() OVER (ORDER BY actoress_avg_rating DESC) AS actoress_rank
FROM top_actoress
limit 7;  




-- Insight 
-- TAPSEE PANNU IS AMONG TOP ACTRESS IN INDIA  WITH HINDI LANGUAGE AND ACTRESS AVERAGE RATING OF 7.74 AND TOTAL VOTES OF 18061
-- DIVYA DUTTA, KRITI KHARBANDA and SONAKSHI SINHA ARE FOLLOWED BY.
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    title,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies'
    END AS avg_rating_category
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    genre = 'thriller';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
ROUND(AVG(duration),2) AS avg_duration,
SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
Round(AVG(AVG(duration)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genres AS
	(SELECT genre,
		COUNT(m.id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
	FROM movie m
		INNER JOIN genre g
			ON g.movie_id = m.id
	GROUP BY genre LIMIT 3),
movie_summary AS
(SELECT genre, 
	year,
	title AS movie_name,
	CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) AS worldwide_gross_income,
	DENSE_RANK() OVER(PARTITION BY year ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC) AS movie_rank
FROM movie m
	INNER JOIN genre g
		ON g.movie_id = m.id
			INNER JOIN top_3_genres
				USING (genre)
)
SELECT *
FROM movie_summary
HAVING movie_rank<=5
ORDER BY year;

-- WHAT WE HAVE DONE
-- WE HAVE USED ROW_NUMBER BECASUE AS PER THE QUESTION HIGHEST-GROSSING MOVIES OF "EACH YEAR"  THEREFORE ROW NUMBER WILL BE BETTER THAN RANK OR DENSE RANK
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH prod_rank AS 
(
SELECT 
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(order by count(id) DESC) AS production_company_rank
FROM 
	movie AS m 
    INNER JOIN
    ratings AS r 
    ON m.id= r.movie_id
WHERE 
	median_rating >= 8 
    AND 
    production_company IS NOT NULL
    AND 
    POSITION(',' IN languages)>0
GROUP BY 
	production_company
)
SELECT *
FROM prod_rank
WHERE 
production_company_rank <=2;



-- Insight
-- - STAR CINEMA,TWENTIETH CENTURY FOX ARE THE TOP TWO  PRODUCTION HOUSES THAT HAVE  PRODUCED THE HIGHEST NUMBER OF HITS AMONG MULTILINGUAL MOVIES.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress AS 
(
SELECT N.NAME AS actress_name,
SUM(R.TOTAL_VOTES) AS total_votes,
COUNT(DISTINCT R.MOVIE_ID) AS movie_count,
ROUND(AVG(R.avg_rating),2) AS actress_avg_rank,
DENSE_RANK() OVER (ORDER BY Count(DISTINCT CASE WHEN avg_rating > 8 THEN rm.movie_id END) DESC) AS actress_rank
FROM NAMES N 
INNER JOIN 
ROLE_MAPPING RM
ON N.ID = RM.NAME_ID
INNER JOIN 
RATINGS R
ON RM.MOVIE_ID = R.MOVIE_ID
INNER JOIN 
GENRE G
ON G.MOVIE_ID = R.MOVIE_ID
WHERE 
AVG_RATING > 8
AND CATEGORY = 'ACTRESS' 
AND GENRE = 'DRAMA'
GROUP BY actress_name
ORDER BY actress_avg_rank DESC
)
select *
from top_actress
WHERE actress_rank = 1 
ORDER BY total_votes DESC
limit 3 ;


-- Insight
-- TOP 3 ACTRESSES BASED ON NUMBER OF SUPER HIT MOVIES ARE AMANDA LAWRENCE,DENISE GOUGH,SUSAN BROWN

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


 
WITH interval_days AS 
(
SELECT DISTINCT d.name_id,
n.name,
d.movie_id,
duration,
r.avg_rating,
r.total_votes,
m.date_published,
LEAD(date_published, 1) OVER ( PARTITION BY d.name_id ORDER BY  date_published , name_id ) AS next_movie_date
FROM director_mapping AS d 
INNER JOIN names AS n 
ON d.name_id=n.id
INNER JOIN movie AS m
ON m.id=d.movie_id
INNER JOIN ratings AS r
ON r.movie_id=m.id
),
days_difference AS
(
SELECT *, DATEDIFF(next_movie_date, date_published) AS days_diff 	
FROM interval_days
)
select name_id AS director_id,
NAME AS director_name,
COUNT(movie_id) AS number_of_movies,
ROUND(AVG(days_diff),0) AS avg_inter_movie_days,
ROUND(AVG(avg_rating),2) AS avg_rating,
SUM(total_votes) AS total_votes,
MIN(avg_rating) AS min_rating,
MAX(avg_rating)  AS max_rating,
SUM(duration) AS total_duration
from days_difference
GROUP BY director_id
ORDER BY number_of_movies desc , total_duration desc
limit 9;

-- Insight
-- A.L VIJAY AND ABDREW JONES ARE THE DIRECTORS WHICH  HAVE THE HIGHEST NUMBER FOR MOVIES.








