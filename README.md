# HP-CRM
HP CRM management assessment

Instructions for this assessment:

Problem overview:
We are HP CRM management team. We have to design a targeted campaign focusing on certain set of customers. For this, we want to understand past performance and know certain hp KPIs that will help us in building this campaign. The data provided is transactional data from HP store for 5 years that means every row is an item in an order placed by a customer. You will have to download the data, upload it in your local SQL environment and answer the following questions using SQL. Please provide a brief write-up on the questions along with SQL codes and inline comments that you would have used to respond to the question. For SQL queries, you can use CTE’s or temp tables as per the need.

Data Repository: 
Data.sql (part of zip file) file contains all SQL for table creation and data insertion. 

Data Dictionary: 
NOTE: One customer can have multiple orders in which case the same email id will have multiple order numbers associated to it. Similarly, an order can have one or multiple products. In case of multiple products in the order, the order number will be the same but the product sku will be different.
As per above - Each row represents 1 item of an order

email_id - customer who placed the order
country - country to which the customer belonged
order_number - the order number of the order
order_creation_date - date along with timestamp denoting the date and time on which the order was placed
order_type - if the order was placed on website (web) or through telesales (ts)
customer_segment - If the customer was an individual (consumer) or working for a business (Business)
product_sku - the product identifier
product_category_id – ID of the Product type (ex. Laptop, desktop, printer, supply, accessory etc.) purchased
quantity - units purchased corresponding to product_number_option purchased
revenue - total revenue corresponding to product_number_option purchased

 
Data analysis questions:
1.	Does the data require cleaning (missing values/outlier treatment etc.)? 
a.	If not, how did you assess that the data is clean?
b.	If yes clean the data as per your understanding and proceed with clean data. 
2.	How has hp.com been performing over the years? 
a.	Compare the sales volumes, total revenue, number of orders and exact count of customers across years.
b.	Detect trends at week level across the years
c.	product_category_id sales volume variation – Any trend?
3.	Segment all customers in the data using the following rules. The groups should be mutually exclusive i.e. one customer should fall only in one group and higher ranked group gets priority (ex. If a customer falls in group 1 and group 3 then group 1 gets priority)
a.	Group 1: Customers with >2000 total revenue in last 1 year
b.	Group 2: Customers with >2000 total revenue in last 2 years
c.	Group 3: Customers with >2000 total revenue in any 2 consecutive years (in the entire data provided)
d.	Group 4: Customers with <2000 in last 2 years
e.	Group 5: Customers from the complete set with 0 revenue in last 2 years 
4.	What has been the yearly_quarterly trends for the following.
a.	acquisition rate (customers placing their first order with HP)
b.	repeat rate (customers placing any order after the first order with HP)
c.	drop rate (cust who haven’t placed an order with HP in 2 consecutive years) 
Note: As most of the questions are open-ended data exploration, logical approach to the solution and coding skills will be looked at closely while evaluation. Hence, though the results need to make business sense, actual 'correctness' of the results bear less importance. 

Submission format
We require the following from you:
1. pgSQL code with succinct inline comments
2. A brief write-up explaining how you went about the steps and data analysis and observations.
