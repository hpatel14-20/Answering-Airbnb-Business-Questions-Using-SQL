/*Explorator Analysis*/

/*Show me the top ten neighborhoods with the most expensive average listings*/
SELECT neighbourhood, ROUND(AVG(price), 1) AS Average_Price
FROM Airbnb_NYC 
GROUP BY neighbourhood
ORDER BY Average_Price DESC LIMIT 10;

/*Show me the top ten neighborhoods with the most cheapest average listings*/
SELECT neighbourhood, ROUND(AVG(price), 1) AS Average_Price
FROM Airbnb_NYC 
GROUP BY neighbourhood
ORDER BY Average_Price ASC LIMIT 10;

/*What is the median listing price by room type accross all NYC listing?*/

SELECT room_type, ROUND(AVG(price), 1) AS Average_Price_roomtype
FROM Airbnb_NYC 
GROUP BY room_type
ORDER BY Average_Price_roomtype;

/*What room_type has the most availability?*/
SELECT room_type, Count(price) AS count_roomtype
FROM Airbnb_NYC 
GROUP BY room_type
ORDER BY count_roomtype ;

/*Is there a correlation between number of reviews and availbility in a year?*/
SELECT 
    (COUNT(*) * SUM(number_of_reviews * availability_365) - SUM(number_of_reviews) * SUM(availability_365)) /
    (SQRT((COUNT(*) * SUM(number_of_reviews * number_of_reviews) - SUM(number_of_reviews) * SUM(number_of_reviews)) *
          (COUNT(*) * SUM(availability_365 * availability_365) - SUM(availability_365) * SUM(availability_365)))) 
          AS correlation_coefficient
FROM Airbnb_NYC;

/*Is there a correlation between price and availbility in a year?*/
SELECT CORR(price, availability_365) AS correlation_coefficient
FROM Airbnb_NYC;

SELECT 
    (COUNT(*) * SUM(price * availability_365) - SUM(price) * SUM(availability_365)) /
    (SQRT((COUNT(*) * SUM(price * price) - SUM(price) * SUM(price)) *
          (COUNT(*) * SUM(availability_365 * availability_365) - SUM(availability_365) * SUM(availability_365)))) 
    AS correlation_coefficient
FROM Airbnb_NYC;





/* Business issues*/

/* The airbnb executive team that overlooks NYC listings wants to know what listings are the most problematic and lack generating revenue?*/

/* To do this we will provide the executive team listings that have a high number of availability per month.
Our dataset does not have rows which describe whether a lsiting is active or not. Therefore we will need to set a threshold to define what is considered "problematic" since
some listings will have a healthy number of unbooked nights. We will define a problematic listing as average avaibility per month of 15 or more (50% or more of the month)*/


SELECT 
   name, room_type, host_name, availability_365 / 12 AS Avg_avail
FROM 
    Airbnb_NYC 
WHERE 
    availability_365 / 12 >= 15;

/* The executive team wants to know what is the percentage of these problematic listings (listigs above 50% avg availability in a month) of the total to know if this is a major issue. To them, anything above 10% is an issue*/

SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Airbnb_NYC) AS percentage
FROM 
    Airbnb_NYC 
WHERE 
    availability_365 / 12 >= 15;

/* The query shows there are 30% of listings that are problematic (more than 50% avg availability in a month)*/
/*We can give the listings, room type and host name to the excecutive team to market these listings on third party sites more heavily since there is room for growth in these listings.*/

/*The executive team also wants to know what listings are the top 20 performers by room type? For this we will need to calculate the revenue per year.
*/
SELECT price * (365 - availability_365) AS Revenue, name, room_type
FROM Airbnb_NYC
GROUP BY name
ORDER BY Revenue DESC limit 20;

/*Lastly, the executive team wants the listings that have an avg monthly availability above 15 but also ahve a price that is 75% above average by neighbohood.
they would like to send all of these listings an email of how they can incresae their revenue or that their price is 75% higher than the average and consider lowering.Age Bracket
but we would also be mindful of the neighborhood*/


SELECT 
    name,
    neighbourhood,
    price
FROM 
    Airbnb_NYC
WHERE 
    monthyl_avg_avail_ > 15 
    AND price > (
        SELECT AVG(price) * 1.75
        FROM Airbnb_NYC AS subquery
        WHERE subquery.neighbourhood = Airbnb_NYC.neighbourhood
    );
