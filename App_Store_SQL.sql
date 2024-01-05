CREATE TABLE applestore_description_combined AS 

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4;

/* There stakeholder is an app developer seeking to answers to questions like:
What app categorgories are most popular?
What prize should I set?
How can I maximize user ratings? *\

**EXPLORATORY DATA ANALYSIS**

--Check the number of unique apps ids in both data sets. 

SELECT COUNT(DISTINCT id) AS 'UniqueAppIDs'
FROM AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppIDs 
FROM appleStore_description_combined;

--No duplicate or missing ids 

--Check for any missing values in key fields AppleStore

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating is NULL;

SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc is NULL;

--No missing values, data set is clean

--Find out the the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER by Numapps DESC;

--Clearly, games and entertainment are the most made apps

--Get an overview od apps' ratings

SELECT min(user_rating) AS MinRating,
		max(user_rating) AS MaxRating,
        avg(user_rating) AS Avgrating
FROM AppleStore;

--Avg rating of all apps is 3.55

**DATA ANALYSIS**

--Do paid apps have higher ratings than free apps?

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
         END AS App_Type,
         avg(user_rating) AS AvgRating
FROM AppleStore
GROUP BY App_Type;

-- Free apps = 3.38 paid apps = 3.72

--Check if apps with more supported languages have high ratings

SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
           END AS language_bucket,
           avg(user_rating) AS AvgRating
 FROM AppleStore
 GROUP BY language_bucket
 ORDER BY AvgRating DESC;
 
 -- 10-30 lang = 4.13, >30 = 3.78, <10 3.37 Dont need to work on so many languages
 
 -Check genres with low ratings
 
 SELECT prime_genre,
 		avg(user_rating) AS Avg_Rating
 FROM AppleStore
 GROUP BY prime_genre
 ORDER BY Avg_Rating ASC
 LIMIT 10;
 
 --Catalogs and Finance have the worst ratings
 
 --Is there correlation between length of app descriptions and user ratings
 
 SELECT CASE
 			WHEN length(b.app_desc) <500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
         END AS description_length_bucket,
         avg(a.user_rating) AS average_rating
 
 FROM AppleStore AS A
 JOIN
 	applestore_description_combined AS B
ON 
	A.id = B.id
GROUP BY description_length_bucket
 ORDER BY average_rating DESC;
 
 -- Long = 3.855 Medium = 3.233 Short = 2.53
 
 --Check the top-rated apps for each genre
 
 SELECT 
 	prime_genre,
    track_name,
    user_rating
 FROM(
 SELECT 
 	prime_genre,
    track_name,
    user_rating,
    RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank 
    FROM 
    AppleStore) AS a 
WHERE 
    a.rank = 1
 
 -- Top performing apps are in business and books