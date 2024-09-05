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

code and screeshot 


2. The executive team also wants to know what percent of listings are problematic (more than 15 days availability in a month)? The team said anything above 10% is concerning.

code and screenshot


3. The executive team also wants to know what listings are the top 20 performers by room type?

code and screenshot


4. Lastly, the executive team wants the listings that have an avg monthly availability above 15 but also have a price that is 75% above average by neighborhood. They would like to send all of these listings an email of how they can increase their revenue or that their price is 75% higher than the average and consider lowering. Age Bracket but we would also be mindful of the neighborhood

code and screenshot






