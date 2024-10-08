## Key Takeaways
Exploratory:

1. The top 3 most expensive neighbhorhoods are Fort Wadsworth, Woodrow and Tribeca. This helps the executive team understand the most expensive places to stay in NYC. 
2. The cheapest neighbhorhoods are Bull's Head, Hunts Point and Tremon. This helps the executive team understand the cheapest places to stay in NYC. 
3. The executive team asked if there was a correlation between availability, price/number of reviews to see if it is worth pulling specific listings related to these variables. There is no correlation between the price or number of reviews and availability in a 365 day period.

Answering Specific Business Issues:

5. The executive team asked what listings have an average monthly availability of greater than 15 (available for more than half the month). We successfully extracted listings that fall in this category for the team to flag these listings. 
6. The executive team also needed to know what % of listings have an average availability greater than 15 days. 30% of listings have a average monthly availability greater than 15 days which is alot. This informs the executive team there is room for growth with the current listings they (see code below).
7. The executive team also wanted listings that have the highest revenue by room type. To calculate revenue I took 365 days and subtracted it by the number of available days for a booking to get the number of booked days and then multiplied that by price. I successfully provided the executive team listings that have the highest revenue by room type (see code below). Surprisingly "Furnished room in Astoria" which is a private room had the 2nd highest revenue amongst all listings.
8. Lastly, the executive team wanted to find out which listings they need to send an email to and also promote on third party websites that have an average monthly availability above 15 and a price that is 75% above the average in that neighborhood. I succesfully provided the executive team listings that fit this criteria in order for Airbnb to help its hosts increase their revenue and for Airbnb corporate to collect more in fees. 





## Exploaratory Data Analysis
Let's limit the dataset to 20 rows for now and view the columns we have

```  sql
select * from Airbnb_NYC LIMIT 20;
```

<img width="1421" alt="Screenshot 2024-09-04 at 9 33 33 PM" src="https://github.com/user-attachments/assets/5aa7b3d9-c46f-4e3a-8db0-203ca70e333a">


The dataset has a mix of numerical and categorical columns with details such name of the host and the listing, neighborhood and neighborhood group, the room type, availability in a year (365 days), price and more.


Now we can ask ourselves some questions to learn about the dataset. What are the top ten neighborhoods with the most expensive average listings?

```  sql
SELECT neighbourhood, ROUND(AVG(price), 1) AS Average_Price
FROM Airbnb_NYC 
GROUP BY neighbourhood
ORDER BY Average_Price DESC LIMIT 10;
```
<img width="416" alt="Screenshot 2024-09-04 at 9 34 43 PM" src="https://github.com/user-attachments/assets/184374f4-e827-4330-935d-9f8c6e60b9c3">


The most expensive neighborhood's are Fort Wadsworth and Woodrow. 

Now let's take a look at the cheapest average listing price:


``` sql
SELECT neighbourhood, ROUND(AVG(price), 1) AS Average_Price
FROM Airbnb_NYC 
GROUP BY neighbourhood
ORDER BY Average_Price ASC LIMIT 10;
```
<img width="693" alt="Screenshot 2024-09-04 at 9 35 33 PM" src="https://github.com/user-attachments/assets/1b6ecded-841e-43cf-b7e1-a01f8f80182c">

The top 3 cheapest average listing is in Bull's Head, Hunt's Point and Tremont.

Next we will look at the average listing price by room type across all NYC listing:

code and screenshot
``` sql
SELECT room_type, ROUND(AVG(price), 1) AS Average_Price_roomtype
FROM Airbnb_NYC 
GROUP BY room_type
ORDER BY Average_Price_roomtype;
```

<img width="925" alt="Screenshot 2024-09-04 at 9 36 36 PM" src="https://github.com/user-attachments/assets/b3d7da03-9e7f-4206-9313-2b2b89e7a14a">


On average, entire home are the most expensive room types to rent. It is interesting to note that the average price difference for an entire home to private room is a 58% drop however, from a private room to a shared room it is only 28% cheaper. This is likely due to entire homes having full kitchens, private rooms, backyards and everything included in the property vs a private room and shared room does not include all aspects of the property.


Next we will take a look at the different number of room types as well as how many available days in a year each room type has in the past 365 days:

``` sql
SELECT room_type, SUM(availability_365) AS Room_Type_Availability
FROM Airbnb_NYC 
GROUP BY room_type
ORDER BY Room_Type_Availability ;
```

<img width="731" alt="Screenshot 2024-09-04 at 9 37 39 PM" src="https://github.com/user-attachments/assets/dcec65d4-72f5-4e02-9d45-2bccf9364ee8">

<img width="464" alt="Screenshot 2024-09-04 at 9 39 36 PM" src="https://github.com/user-attachments/assets/641efb60-f03b-48bf-8d7e-601f274b8add">



Entire homes make up 52% of all listings, Private rooms make up 46% and shared rooms make up 2%.

Entire homes are available 52% of the time, Private rooms 45% and shared rooms 3% of the time in a 365 day period. This closely aligns with the number of rooms available for each type.

Next we will see if there is a correlation between number of reviews and availability in a 365 day period:

``` sql
SELECT CORR(number_of_reviews, availability_365) AS correlation_coefficient_review_count
FROM Airbnb_NYC;
```

<img width="760" alt="Screenshot 2024-09-04 at 9 40 57 PM" src="https://github.com/user-attachments/assets/aba86e3b-22f6-47d5-a4cd-30a38f0e991b">


The correlation is very low. Let's see if there is a correlation between price and availability in a 365 day period:

``` sql
SELECT CORR(price, availability_365) AS correlation_coefficient_price
FROM Airbnb_NYC;
```

<img width="686" alt="Screenshot 2024-09-04 at 9 42 03 PM" src="https://github.com/user-attachments/assets/b1abf8ec-5447-40aa-b4b9-1f7d46e8c026">


The correlation is also really low.



## Business Issues:

Now we will move to 4 business questions received from upper management. 

1. The airbnb executive team that overlooks NYC listings wants to know: What listings are the most problematic and generate lower revenues?

``` sql
SELECT 
   name, room_type, host_name, availability_365 / 12 AS Avg_avail
FROM 
    Airbnb_NYC 
WHERE 
    availability_365 / 12 >= 15
Order By Avg_avail DESC;
```

<img width="967" alt="Screenshot 2024-09-04 at 9 44 00 PM" src="https://github.com/user-attachments/assets/f0044898-77a1-4ae5-82a4-fc7edb2f0a11">



2. The executive team also wants to know what percent of listings are problematic (more than 15 days availability in a month)? The team said anything above 10% is concerning.

```sql
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Airbnb_NYC) AS percentage
FROM 
    Airbnb_NYC 
WHERE 
    availability_365 / 12 >= 15;
```

<img width="698" alt="Screenshot 2024-09-04 at 9 45 18 PM" src="https://github.com/user-attachments/assets/bbc992db-b849-4513-84de-d537716cbb75">


3. The executive team also wants to know what listings are the top 20 performers by room type?

```sql
SELECT price * (365 - availability_365) AS Revenue, name, room_type
FROM Airbnb_NYC
GROUP BY name
ORDER BY Revenue DESC limit 20;
```

<img width="1107" alt="Screenshot 2024-09-04 at 9 47 08 PM" src="https://github.com/user-attachments/assets/f2fe34a8-8619-463a-a3fe-0ee8cb611dab">



4. Lastly, the executive team wants the listings that have an avg monthly availability above 15 but also have a price that is 75% above average by neighborhood. They would like to send all of these listings an email of how they can increase their revenue or that their price is 75% higher than the average and consider lowering. Age Bracket but we would also be mindful of the neighborhood

``` sql
SELECT 
    name,
    neighbourhood,
    price
FROM 
    Airbnb_NYC
WHERE 
    monthly_avg_avail > 15 
    AND price > (
        SELECT AVG(price) * 1.75
        FROM Airbnb_NYC AS subquery
        WHERE subquery.neighbourhood = Airbnb_NYC.neighbourhood
    )
ORDER BY price DESC Limit 20;
```


<img width="876" alt="Screenshot 2024-09-04 at 9 48 59 PM" src="https://github.com/user-attachments/assets/4aa397ae-dbf4-46c1-ac67-7c57e0077233">





