-- Assessment Solution


-- Data analysis questions:
-- 1.	Does the data require cleaning (missing values/outlier treatment etc.)?

--

-- As null is not an expected input for the country column, we can consider it as a missing
-- value that needs to be addressed within a data cleaning process. Same thing goes for the
-- missing values of some rows with NULL values in the product_category_id column.

--

-- a.	If not, how did you assess that the data is clean?

-- Yes, we need to clean the data and do it accordingly to the same type of data (country text, product_category_id
-- integer). I prefer to fill this NULL data with 0 and Unknown (integer, and string [text]).

-- b.	If yes clean the data as per your understanding and proceed with clean data.

--Data cleaning

-- First, we address this situation using SQL:

-- Update the records with NULL product_category_id values to a default value (e.g., 0)

UPDATE sql_test
SET product_category_id = 0
WHERE product_category_id IS NULL;

-- After executing this query, we can verify the changes by running a SELECT query:

SELECT *
FROM sql_test
WHERE product_category_id IS NULL;

-- No we update the records with null country values to a default value of our choice (mine will be 'Unknown')

UPDATE sql_test
SET country = 'Unknown'
WHERE country IS NULL;

-- After executing this query, we can verify the changes by running a SELECT query:

SELECT *
FROM sql_test
WHERE country IS NULL;

--

-- Now, as the data set is quite large, a good data cleaning practice would be to identify outliers,
-- we can analyze the values of each column and look for extreme or unexpected values.

-- I will identify potential outliers in numeric columns:

-- For each numeric column, we calculate summary statistics like minimum, maximum, mean, median,
-- and standard deviation.
-- Look for values that significantly deviate from the typical range or show unusual patterns.

-- Query to calculate summary statistics for the revenue column:

SELECT
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    AVG(revenue) AS avg_revenue,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue,
    STDDEV(revenue) AS stddev_revenue
FROM sql_test;

--I got these results from my query

-- "min_revenue"	"max_revenue"   	"avg_revenue"	    "median_revenue"	"stddev_revenue"
--    -348.27	       366704.73    458.3952657445089084	    77.25       	1753.719853426999

-- Minimum Revenue: The minimum revenue value of -348.27 indicates that there are some transactions in the dataset with
-- negative revenue values. This could be due to refunds, discounts, or other factors. Further investigation is needed
-- to understand the reasons behind these negative values and their impact on the overall revenue.

-- Maximum Revenue: The maximum revenue value of 366,704.73 suggests that there are some high-value transactions in
-- the dataset. These high-revenue transactions could be from large orders, premium products, or special promotions.
-- Analyzing these high-value transactions can provide insights into customer behavior, product preferences, or
-- successful marketing strategies.

-- Average Revenue: The average (mean) revenue value of approximately 458.40 represents the typical revenue value across
-- all transactions. This provides a baseline understanding of the average transaction value. Comparing individual
-- transaction revenue to the average can help identify outliers or exceptional cases.

-- Median Revenue: The median revenue value of 77.25 indicates that there is a significant difference between the
-- average and the median. This suggests that the distribution of revenue values is skewed, with a few transactions
-- having high revenue values while the majority of transactions have lower revenue values. Understanding this
-- difference can be important when making decisions based on revenue figures.

-- Standard Deviation: The standard deviation of approximately 1,753.72 reflects a large amount of variability in the
-- revenue values. This indicates that the revenue amounts vary significantly across transactions. Analyzing the factors
-- contributing to this variability can provide insights into customer segments, product categories, or other business
-- factors that impact revenue.

-- Data consistency:
-- Now me must ensure that the data is consistent and follows the expected format and data types for each column.
-- For example, check if dates are properly formatted, numeric fields contain valid numeric values, and text fields are
-- correctly represented.

-- First we check for date consistency

SELECT *
FROM sql_test
WHERE order_creation_date IS NULL OR order_creation_date < '1900-01-01' OR order_creation_date > '2100-12-31';
-- we see no data, so we keep going with:

-- Check for revenue consistency

SELECT *
FROM sql_test
WHERE CAST(revenue AS text) !~ '^(-)?\d+(\.\d+)?$';
-- we see no data, so we can keep going.

-- This was all for data cleaning.

-- 2.	How has hp.com been performing over the years?
-- a.	Compare the sales volumes, total revenue, number of orders and exact count of customers across years.

SELECT EXTRACT(YEAR FROM order_creation_date) AS year,
       COUNT(DISTINCT order_number) AS num_orders,
       COUNT(DISTINCT email_id) AS num_customers,
       SUM(quantity) AS total_sales_volume,
       SUM(revenue) AS total_revenue
FROM sql_test
GROUP BY year
ORDER BY year;

-- In this query:

-- We use the EXTRACT function to extract the year from the order_creation_date column.
-- The COUNT(DISTINCT order_number) gives the number of unique orders.
-- The COUNT(DISTINCT email_id) gives the count of unique customers.
-- The SUM(quantity) calculates the total sales volume.
-- The SUM(revenue) calculates the total revenue.
-- We group the results by year and order them in ascending order.

-- Results

"year"	"num_orders"	"num_customers"	"total_sales_volume"	"total_revenue"
2012	    39107	        34738	        121541	            46325639.69
2013	    130516	        97132	        418296	            130774876.16
2014	    182852	        140913	        359768	            175282802.08
2015	    258645	        200174	        533314	            197756808.74
2016	    291795	        224446	        580978	            209380031.49

-- b.	Detect trends at week level across the years

SELECT EXTRACT(YEAR FROM order_creation_date) AS year,
       EXTRACT(WEEK FROM order_creation_date) AS week,
       COUNT(DISTINCT order_number) AS num_orders,
       SUM(quantity) AS total_sales_volume,
       SUM(revenue) AS total_revenue
FROM sql_test
GROUP BY year, week
ORDER BY year, week;

-- In this query:

-- We use the EXTRACT function to extract the year and week from the order_creation_date column.
-- The COUNT(DISTINCT order_number) gives the number of unique orders.
-- The SUM(quantity) calculates the total sales volume.
-- The SUM(revenue) calculates the total revenue.
-- We group the results by year and week and order them in ascending order.

--I'll attach the results in the week_trend.txt file

-- c.	product_category_id sales volume variation – Any trend?
SELECT product_category_id,
       EXTRACT(YEAR FROM order_creation_date) AS year,
       SUM(quantity) AS sales_volume
FROM sql_test
GROUP BY product_category_id, year
ORDER BY product_category_id, year;

-- In this query:

-- We select the product_category_id, extract the year from the order_creation_date, and calculate the sum of the
-- quantity column.
-- We group the results by product_category_id and year and order them in ascending order.

-- Results are in product_column.txt It shows a positive trend with a great increase from 2012 to 2013
-- from 2013 to 2015 it stood increasing, but at a minor rate compared to 2012, almost same goes from
-- 2015 to 2015. We see a drastic stop from 2013 to 2014 because it barely increased. We might learn from 2012 and
-- avoid what happen in 2013

--I also made a visualization of the data with Power BI where you can see the data trending.

--

-- 3.	Segment all customers in the data using the following rules. The groups should be mutually exclusive i.e. one
-- customer should fall only in one group and higher ranked group gets priority (ex. If a customer falls in group 1
-- and group 3 then group 1 gets priority)
-- a.	Group 1: Customers with >2000 total revenue in last 1 year
-- b.	Group 2: Customers with >2000 total revenue in last 2 years
-- c.	Group 3: Customers with >2000 total revenue in any 2 consecutive years (in the entire data provided)
-- d.	Group 4: Customers with <2000 in last 2 years
-- e.	Group 5: Customers from the complete set with 0 revenue in last 2 years

WITH customer_revenue AS (
  SELECT email_id,
         EXTRACT(YEAR FROM order_creation_date) AS year,
         SUM(revenue) AS total_revenue
  FROM sql_test
  GROUP BY email_id, year
),
customer_groups AS (
  SELECT email_id,
         CASE
           WHEN MAX(year) = EXTRACT(YEAR FROM CURRENT_DATE) - 1 AND SUM(total_revenue) > 2000 THEN 1 -- Group 1
           WHEN MAX(year) >= EXTRACT(YEAR FROM CURRENT_DATE) - 2 AND SUM(total_revenue) > 2000 THEN 2 -- Group 2
           WHEN SUM(total_revenue) > 2000 THEN 3 -- Group 3
           WHEN MAX(year) >= EXTRACT(YEAR FROM CURRENT_DATE) - 2 AND SUM(total_revenue) < 2000 THEN 4 -- Group 4
           ELSE 5 -- Group 5
         END AS customer_group
  FROM customer_revenue
  GROUP BY email_id
)
SELECT email_id, customer_group
FROM customer_groups;

-- 1. The code begins by defining two Common Table Expressions (CTEs): `customer_revenue`
--    and `customer_groups`.

-- 2. The `customer_revenue` CTE calculates the total revenue for each customer in each year.
--    It extracts the year from the `order_creation_date` column and groups the data by
--    `email_id` and `year`. The `SUM(revenue)` calculates the total revenue for each
--    combination of `email_id` and `year`.

-- 3. The `customer_groups` CTE assigns a customer group to each `email_id` based on the
--    specified rules. It uses the results from the `customer_revenue` CTE.

--    For each `email_id`, the `CASE` statement evaluates the conditions in the following
--    order:

--      If the maximum year in the dataset is equal to the previous year (i.e.,
--      `MAX(year) = EXTRACT(YEAR FROM CURRENT_DATE) - 1`) and the total revenue is greater
--      than 2000, the customer is assigned to Group 1.

--      If the maximum year in the dataset is greater than or equal to two years ago (i.e.,
--      `MAX(year) >= EXTRACT(YEAR FROM CURRENT_DATE) - 2`) and the total revenue is greater
--      than 2000, the customer is assigned to Group 2.

--      If the total revenue is greater than 2000 (without considering the year), the
--      customer is assigned to Group 3.

--      If the maximum year in the dataset is greater than or equal to two years ago and the
--      total revenue is less than 2000, the customer is assigned to Group 4.

--      For all other cases, the customer is assigned to Group 5.

--    The result is a table with `email_id` and `customer_group` columns, where each row
--    represents a customer and their corresponding group.

-- 4. Finally, the outer SELECT statement retrieves the `email_id` and `customer_group` from
--    the `customer_groups` CTE. This result represents the segmentation of customers based on
--    the specified rules.

--

-- 4.	What has been the yearly_quarterly trends for the following.

-- a.	acquisition rate (customers placing their first order with HP)

--    This query calculates the acquisition rate by counting the number of distinct `email_id`
--    values for each year and quarter. It excludes customers who placed orders before the
--    earliest order creation date in the dataset, assuming those customers are not new
--    acquisitions. The result is grouped by year and quarter, providing the acquisition count
--    for each period.

SELECT
    EXTRACT(YEAR FROM order_creation_date) AS year,
    EXTRACT(QUARTER FROM order_creation_date) AS quarter,
    COUNT(DISTINCT email_id) AS acquisition_count
FROM
    public.sql_test
WHERE
    email_id IN (
        SELECT email_id
        FROM (
            SELECT
                email_id,
                ROW_NUMBER() OVER (PARTITION BY email_id ORDER BY order_creation_date) AS rn
            FROM
                public.sql_test
        ) sub
        WHERE rn = 1
    )
GROUP BY
    year, quarter
ORDER BY
    year, quarter;

--Result

2013	4	33172
2014	1	31898
2014	2	32120
2014	3	40595
2014	4	54688
2015	1	55394
2015	2	52612
2015	3	58641
2015	4	67268
2016	1	68452
2016	2	57957
2016	3	64179
2016	4	72403

-- b.	repeat rate (customers placing any order after the first order with HP)

--    This query calculates the repeat rate by counting the number of distinct `email_id`
--    values for each year and quarter. It includes customers who placed orders after the
--    earliest order creation date in the dataset, assuming those customers have made repeat
--    purchases. The result is grouped by year and quarter, providing the repeat count for each
--    period.

SELECT
    EXTRACT(YEAR FROM order_creation_date) AS year,
    EXTRACT(QUARTER FROM order_creation_date) AS quarter,
    COUNT(DISTINCT email_id) AS repeat_count
FROM
    public.sql_test
WHERE
    email_id IN (
        SELECT email_id
        FROM (
            SELECT
                email_id,
                ROW_NUMBER() OVER (PARTITION BY email_id ORDER BY order_creation_date) AS rn
            FROM
                public.sql_test
        ) sub
        WHERE rn > 1
    )
GROUP BY
    year, quarter
ORDER BY
    year, quarter;

--Results

2012	1	10
2012	2	2
2012	3	9534
2012	4	25960
2013	1	25004
2013	2	28830
2013	3	23611
2013	4	31098
2014	1	20388
2014	2	20388
2014	3	25147
2014	4	34997
2015	1	37455
2015	2	37592
2015	3	40904
2015	4	43847
2016	1	47121
2016	2	39502
2016	3	43053
2016	4	46324

-- c.	drop rate (cust who haven’t placed an order with HP in 2 consecutive years)

SELECT
    EXTRACT(YEAR FROM order_creation_date) AS year,
    COUNT(DISTINCT email_id) AS drop_count
FROM
    public.sql_test
WHERE
    email_id IN (
        SELECT DISTINCT email_id
        FROM public.sql_test
        WHERE EXTRACT(YEAR FROM order_creation_date) = (
            SELECT MAX(EXTRACT(YEAR FROM order_creation_date))
            FROM public.sql_test
        ) - 1
    )
    AND email_id NOT IN (
        SELECT DISTINCT email_id
        FROM public.sql_test
        WHERE EXTRACT(YEAR FROM order_creation_date) = (
            SELECT MAX(EXTRACT(YEAR FROM order_creation_date))
            FROM public.sql_test
        )
    )
GROUP BY
    year
ORDER BY
    year;

--It have no results, so it means that there are no customers who meet the criteria for the drop rate
-- (customers who haven't placed an order with HP in 2 consecutive years).

-- The query is designed to identify customers who have placed an order in the previous year but have not placed any
-- orders in the current year. The query checks for customers who have orders in the year prior to the maximum year in
-- the dataset but do not have any orders in the maximum year.

-- Since we are not getting any results, it suggests that all customers in your dataset have either placed orders in
-- the current year or have not placed any orders in the previous year. Therefore, there are no customers who fall into
-- the "drop rate" category according to the defined criteria.