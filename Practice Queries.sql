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





select count(DISTINCT(name)) from Airbnb_NYC





















/* Now the executive team is asking whether or not there is an issue of supply. Are these more listings available than there consumers booking them?
 We will check to see if there are more listings available than booked in any given month on average This will tell the team that there is room to attract new customers through marketing efforts.
 If there are not that many available to bookings then that means the supply of listings available is in a healthy range overall. The previous study looked at 
 how many listings are there that have a 50% occupancy rate and what percentage have a ~50% availability. Here we are looking at
 the listings with an avg availaibility of 10% or more to identify listings the team can market more on third party sites*/

ALTER TABLE Airbnb_NYC
DROP COLUMN avail_booked_ratio;



/* lets add a column that tells us the avg availability per month for a listing*/
ALTER TABLE Airbnb_NYC
ADD monthyl_avg_avail_ AS (availability_365 / 12);

/* lets add a column that tells us the average amount of booked per month for a listing*/

ALTER TABLE Airbnb_NYC
ADD monthly_avg_booked AS ((365-availability_365)/12);

/* To answer the executives question lets find out the ratio of monthly_average_avail to monthly_avg_booked to see if a listing has an above 1 or below 1 ratio.
An above 1 ratio means that generally for that listing there are more available days than booked and below one means they have more booked days than available.*/

ALTER TABLE Airbnb_NYC
ADD avail_booked_ratio AS (monthyl_avg_avail_/monthly_avg_booked)

ALTER TABLE Airbnb_NYC
ADD COLUMN avail_booked_ratio REAL GENERATED ALWAYS AS (ROUND(monthyl_avg_avail_ / monthly_avg_booked, 1));

SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Airbnb_NYC) AS percentage
FROM 
    Airbnb_NYC 
WHERE 
    avail_booked_ratio >1.0;

/*There are 18% more available listings on the platofrm than there are booked listings on average per month.  
Now we can provide the executive team the specific lisitings that have more than 10% availability than booked so they can promote these listings in search results to help them close bookings which ultimately makes airbnb corporate more money. 
Let's also given them what neighbourhood these are located in and what room_type to give them extra level of detail. 
*/

SELECT name, neighbourhood,room_type
FROM Airbnb_NYC
WHERE avail_booked_ratio >1.1;




UPDATE Airbnb_NYC
SET availability_365 = ROUND(availability_365, 2);



select * from Airbnb_NYC

/* Now we can analyze supply and demand by dividing the availbility by booked. if the value is over 1 then we have more available than booked */
ALTER TABLE Airbnb_NYC
ADD avail_booked_ratio AS (avg_avail / booked)

ALTER TABLE Airbnb_NYC
DROP COLUMN avail_booked_ratio;

ALTER TABLE Airbnb_NYC
DROP COLUMN  avg_avail;

ALTER TABLE Airbnb_NYC
DROP COLUMN booked;

/* How many reviews are there in Brooklyn?
SELECT SUM(number_of_reviews) AS total_reviews
FROM Airbnb_NYC
WHERE neighbourhood_group = 'Brooklyn'; */


/*Calculate the average and group it by neighborhood and order it from highest to lowest
Select neighbourhood, AVG(price) AS Average_Price 
FROM Airbnb_NYC 
GROUP BY neighbourhood 
ORDER BY Average_Price DESC;
*/

/* Only output the highest average by neighbhorhood
SELECT MAX(average_price) AS Highest_avg_price
FROM(
    SELECT AVG(price) AS average_price 
    from Airbnb_NYC group by neighbourhood
    );


Count the number of names there are in total
SELECT COUNT(name) AS Count_listings from Airbnb_NYC;

How many distinct listings are there in the dataset?
SELECT DISTINCT(name) AS Count_listings from Airbnb_NYC;



Changing a specific value in datatable 
Lets change the host name. But first lets check the host name is:
SELECT name, host_name FROM Airbnb_NYC WHERE name = 'Skylit Midtown Castle';

Update the host name to Harsh:

UPDATE Airbnb_NYC SET host_name = 'Harsh' WHERE name = 'Skylit Midtown Castle'

Check if its updated:
SELECT name, host_name FROM Airbnb_NYC WHERE name = 'Skylit Midtown Castle';


Create a mapping table for neighbourhood_group column:

CREATE TABLE group_ID (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    neighbourhood_group TEXT UNIQUE
);

INSERT INTO group_ID (neighbourhood_group)
SELECT DISTINCT neighbourhood_group
FROM Airbnb_NYC;



SELECT id, neighbourhood_group from group_ID


Next look into how to take rows in one column and turn them into a column with values.