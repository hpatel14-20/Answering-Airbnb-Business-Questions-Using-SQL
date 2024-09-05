## We will first look at our dataset. 
Let's limit the dataset to 20 rows for now

Add code then screenshot

The dataset has a mix of numerical and categorical columns with details such name of the host and the listing, neighborhood and neighborhood group, the room type, availability in a year (365 days), price and more.


Now we can ask ourselves some questions to learn about the dataset. What are the top ten neighborhoods with the most expensive average listings?

Add code and screenshot

The most expensive neighborhood's are Fort Wadsworth and Woodrow. 

Now let's take a look at the cheapest average listing price:

code and screenshot

The top 3 cheapest average listing is in Bull's Head, Hunt's Point and Tremont.

Next we will look at the average listing price by room type across all NYC listing:

code and screenshot

On average, entire home are the most expensive room types to rent. It is interesting to note that the average price difference for an entire home to private room is a 58% drop however, from a private room to a shared room it is only 28% cheaper. This is likely due to entire homes having full kitchens, private rooms, backyards and everything included in the property vs a private room and shared room does not include all aspects of the property.


Next we will take a look at the different number of room types as well as how many available days in a year each room type has in the past 365 days:

code and screenshot

Entire homes make up 52% of all listings, Private rooms make up 46% and shared rooms make up 2%.

Entire homes are available 52% of the time, Private rooms 45% and shared rooms 3% of the time in a 365 day period. This closely aligns with the number of rooms available for each type.

Next we will see if there is a correlation between number of reviews and availability in a 365 day period:

code and screenshot

The correlation is very low. Let's see if there is a correlation between price and availability in a 365 day period:

code and screenshot

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






