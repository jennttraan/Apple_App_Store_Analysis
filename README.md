# Apple Store Apps Analysis And Exploration
 ![2cc82193d173c6011b28cb0a70c2ee08](https://github.com/jennttraan/Apple_Store_App_Review/assets/144400508/d72ac93a-3293-46cf-883e-8d907ce865a1)


## Business Task

Analyzing Apple Store app reviews and categories will help software engineers and stakeholders develop apps that will be competitive and have better reviews in the market. 
1. What were the most popular apps?
2. What affects user ratings, such as languages?
3. What categories of apps do the best in the market?


## Processing The Data

Full script can be found [here](https://github.com/jennttraan/Apple_Store_App_Review/blob/main/App_Store_SQL.sql).

Check the number of unique apps ids in both data sets. 
```
SELECT COUNT(DISTINCT id) AS 'UniqueAppIDs'
FROM AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppIDs 
FROM appleStore_description_combined;
```

Get an overview of apps' ratings

```
SELECT min(user_rating) AS MinRating,
		max(user_rating) AS MaxRating,
        avg(user_rating) AS Avgrating
FROM AppleStore;
```

Do paid apps have higher ratings than free apps?

```
SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
         END AS App_Type,
         avg(user_rating) AS AvgRating
FROM AppleStore
GROUP BY App_Type;
```

Check if apps with more supported languages have high ratings.

```
SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
           END AS language_bucket,
           avg(user_rating) AS AvgRating
 FROM AppleStore
 GROUP BY language_bucket
 ORDER BY AvgRating DESC;
 ```
Is there correlation between length of app descriptions and user ratings?

 ```
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
```

## Conclusion

After analyzing the data I found that:
<br>
1. Paid apps have better ratings. Users who pay for an app may have higher engagement which leads to better ratings. Stakeholders should consider charging a certain amount.  
2. Apps supporting between 10 and 30 language have better ratings. Focus on the right languages for the consumers.
3. Finance and books have the lowest ratings. This shows that the users of these kinds of apps are not having their needs meet. It's an opportunity to develop a better quality app that will  address those needs.
4. The longer app descriptions also have higher ratings. Users prefer an understanding of the app before using it.
5. Games and Entertainment have the highest number of apps. It is an oversaturated market, but may also suggest high user demand. 
