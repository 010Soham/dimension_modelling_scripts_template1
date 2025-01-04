CREATE TYPE sales_summary AS (
    fiscal_year INTEGER,       
    total_orders INTEGER,      
    total_revenue REAL,        
    total_cost REAL,           
    net_profit REAL            
);



CREATE TABLE customers (
    customer_name TEXT,            
    customer_height TEXT,          
    customer_college TEXT,         
    country TEXT,                  
    signup_year TEXT,              
    signup_round TEXT,             
    customer_id TEXT,              
    sales_summary sales_summary[],  
    current_year INTEGER,          
    PRIMARY KEY(customer_name, current_year)
);


SELECT MIN(fiscal_year) FROM customer_fiscal_years;


WITH yesterday AS (
    SELECT * FROM customers
    WHERE current_year = 1985
),
today AS (
    SELECT * FROM customer_fiscal_years
    WHERE fiscal_year = 1986
)
SELECT * FROM today t FULL OUTER JOIN yesterday y
ON t.customer_name = y.customer_name;



WITH yesterday AS (
    SELECT * FROM customers
    WHERE current_year = 1985
),
today AS (
    SELECT * FROM customer_fiscal_years
    WHERE fiscal_year = 1986
)
SELECT 
    COALESCE(t.customer_name, y.customer_name) AS customer_name,
    COALESCE(t.customer_height, y.customer_height) AS customer_height,
    COALESCE(t.customer_college, y.customer_college) AS customer_college,
    COALESCE(t.signup_year, y.signup_year) AS signup_year,
    COALESCE(t.signup_round, y.signup_round) AS signup_round,
    COALESCE(t.customer_id, y.customer_id) AS customer_id,
    CASE 
        WHEN y.sales_summary IS NULL
        THEN ARRAY[ROW(
            t.fiscal_year,
            t.total_orders,
            t.total_revenue,
            t.total_cost,
            t.net_profit
        )::sales_summary]
        WHEN t.fiscal_year IS NOT NULL THEN y.sales_summary || ARRAY[ROW(
            t.fiscal_year,
            t.total_orders,
            t.total_revenue,
            t.total_cost,
            t.net_profit
        )::sales_summary]
        ELSE y.sales_summary
    END AS sales_summary,
    COALESCE(t.fiscal_year, y.current_year + 1) AS current_year
            
FROM today t FULL OUTER JOIN yesterday y
ON t.customer_name = y.customer_name;




INSERT INTO customers
WITH yesterday AS (
    SELECT *
    FROM customers
    WHERE current_year = 1985
),
today AS (
    SELECT *
    FROM customer_fiscal_years
    WHERE fiscal_year = 1986
)
SELECT 
    COALESCE(t.customer_name, y.customer_name) AS customer_name,
    COALESCE(t.customer_height, y.customer_height) AS customer_height,
    COALESCE(t.customer_college, y.customer_college) AS customer_college,
    COALESCE(t.country, y.country) AS country,
    COALESCE(t.signup_year, y.signup_year) AS signup_year,
    COALESCE(t.signup_round, y.signup_round) AS signup_round,
    COALESCE(t.customer_id, y.customer_id) AS customer_id,
    CASE 
        WHEN y.sales_summary IS NULL
        THEN ARRAY[ROW(
            t.fiscal_year,
            t.total_orders,
            t.total_revenue,
            t.total_cost,
            t.net_profit
        )::sales_summary]
        WHEN t.fiscal_year IS NOT NULL
        THEN y.sales_summary || ARRAY[ROW(
            t.fiscal_year,
            t.total_orders,
            t.total_revenue,
            t.total_cost,
            t.net_profit
        )::sales_summary]
        ELSE y.sales_summary
    END AS sales_summary,
    COALESCE(t.fiscal_year, y.current_year + 1) AS current_year
FROM today t
FULL OUTER JOIN yesterday y
    ON t.customer_name = y.customer_name;








INSERT INTO customers
WITH yesterday AS (
    SELECT *
    FROM customers
    WHERE current_year = 1986
),
today AS (
    SELECT *
    FROM customer_fiscal_years
    WHERE fiscal_year = 1987
)
SELECT 
    COALESCE(t.customer_name, y.customer_name) AS customer_name,
    COALESCE(t.customer_height, y.customer_height) AS customer_height,
    COALESCE(t.customer_college, y.customer_college) AS customer_college,
    COALESCE(t.country, y.country) AS country,
    COALESCE(t.signup_year, y.signup_year) AS signup_year,
    COALESCE(t.signup_round, y.signup_round) AS signup_round,
    COALESCE(t.customer_id, y.customer_id) AS customer_id,
    CASE 
        WHEN y.sales_summary IS NULL
        THEN ARRAY[
            ROW(
                t.fiscal_year,
                t.total_orders,
                t.total_revenue,
                t.total_cost,
                t.net_profit
            )::sales_summary
        ]
        WHEN t.fiscal_year IS NOT NULL
        THEN y.sales_summary || ARRAY[
            ROW(
                t.fiscal_year,
                t.total_orders,
                t.total_revenue,
                t.total_cost,
                t.net_profit
            )::sales_summary
        ]
        ELSE y.sales_summary
    END AS sales_summary,
    COALESCE(t.fiscal_year, y.current_year + 1) AS current_year
        
FROM today t
FULL OUTER JOIN yesterday y
    ON t.customer_name = y.customer_name
SELECT *
FROM customers
WHERE current_year = 1987;


SELECT 
    customer_name,
    UNNEST(sales_summary)::sales_summary AS sales_summary
FROM customers
WHERE current_year = 2021
  AND customer_name = 'Philip Joe';



WITH unnested AS (
    SELECT customer_name,
           UNNEST(sales_summary)::sales_summary AS sales_summary
    FROM customers
    WHERE current_year = 2001
      AND customer_name = 'Philip Joe'
)
SELECT 
    customer_name,
    (sales_summary::sales_summary).*
FROM unnested;





WITH unnested AS (
    SELECT customer_name,
           UNNEST(sales_summary)::sales_summary AS sales_summary
    FROM customers
    WHERE current_year = 2001
)
SELECT 
    customer_name,
    (sales_summary::sales_summary).*
FROM unnested;





CREATE TYPE scoring_class AS ENUM ('star', 'good', 'average', 'bad');


CREATE TABLE customers (
    customer_name TEXT,
    customer_height TEXT,
    customer_college TEXT,
    country TEXT,
    signup_year TEXT,
    signup_round TEXT,
    customer_id TEXT,
    sales_summary sales_summary[],
    customer_rating scoring_class,
    years_since_last_year INTEGER,
    current_year INTEGER,
    PRIMARY KEY(customer_name, current_year)
);



INSERT INTO customers
WITH yesterday AS (
    SELECT *
    FROM customers
    WHERE current_year = 1996
),
today AS (
    SELECT *
    FROM customer_fiscal_years
    WHERE fiscal_year = 1997
)
SELECT 
    COALESCE(t.customer_name, y.customer_name) AS customer_name,
    COALESCE(t.customer_height, y.customer_height) AS customer_height,
    COALESCE(t.customer_college, y.customer_college) AS customer_college,
    COALESCE(t.country, y.country) AS country,
    COALESCE(t.signup_year, y.signup_year) AS signup_year,
    COALESCE(t.signup_round, y.signup_round) AS signup_round,
    COALESCE(t.customer_id, y.customer_id) AS customer_id,
    CASE 
        WHEN y.sales_summary IS NULL
        THEN ARRAY[ROW(
            t.fiscal_year,
            t.total_orders,
            t.total_revenue,
            t.total_cost,
            t.net_profit
        )::sales_summary]
        WHEN t.fiscal_year IS NOT NULL THEN y.sales_summary || ARRAY[ROW(
            t.fiscal_year,
            t.total_orders,
            t.total_revenue,
            t.total_cost,
            t.net_profit
        )::sales_summary]
        ELSE y.sales_summary
    END AS sales_summary,
    CASE 
        WHEN t.fiscal_year IS NOT NULL THEN
            CASE 
                WHEN t.total_revenue > 20 THEN 'star'
                WHEN t.total_revenue > 15 THEN 'good'
                WHEN t.total_revenue > 10 THEN 'average'
                ELSE 'bad'
            END::scoring_class
        ELSE y.customer_rating
    END AS customer_rating,
    CASE 
        WHEN t.fiscal_year IS NOT NULL THEN 0
        ELSE y.years_since_last_year + 1
    END AS years_since_last_year,
    COALESCE(t.fiscal_year, y.current_year + 1) AS current_year
        
FROM today t
FULL OUTER JOIN yesterday y
    ON t.customer_name = y.customer_name;




SELECT
    customer_name,
    (sales_summary[CARDINALITY(sales_summary)]::sales_summary).total_revenue /
    CASE
        WHEN (sales_summary[1]::sales_summary).total_revenue = 0 THEN 1
        ELSE (sales_summary[1]::sales_summary).total_revenue
    END AS ratio
FROM customers
WHERE current_year = 2001
ORDER BY 2 DESC;
