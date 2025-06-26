create database ecomm_return;

CREATE TABLE return_analysis (
    Customer_ID INT NOT NULL,
    Purchase_Date DATE NOT NULL,
    Purchase_Hour TIME NOT NULL,
    Product_Category TEXT NOT NULL,
    Product_Price DECIMAL(10 , 2 ) NOT NULL,
    Quantity INT NOT NULL,
    Total_Purchase_Amount DECIMAL(10 , 2 ) NOT NULL,
    Payment_Method TEXT NOT NULL,
    Customer_Age INT NOT NULL,
    return_code INT NOT NULL,
    Customer_Name TEXT NOT NULL,
    Gender TEXT NOT NULL,
    Churn INT NOT NULL,
    Return_Status TEXT NOT NULL
);

SELECT 
    *
FROM
    return_analysis;

ALTER TABLE return_analysis
ADD COLUMN Order_ID INT AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT 
    *
FROM
    return_analysis;

-- 1.	What is the overall return rate across the company?
SELECT 
    COUNT(Order_ID),
    ROUND(SUM(CASE
                WHEN Return_Status = 'Return' THEN 1
                ELSE 0
            END) * 100 / COUNT(Order_ID),
            2) AS RETURN_RATE
FROM
    return_analysis;

-- 2.	What are the top 5 product categories by return rate?
SELECT 
    Product_Category,
    ROUND(SUM(CASE
                WHEN Return_Status = 'Return' THEN 1
                ELSE 0
            END) * 100 / COUNT(Order_ID),
            2) AS RETURN_RATE,
    ROUND(SUM(CASE
                WHEN Return_Status != 'Return' THEN 1
                ELSE 0
            END) * 100 / COUNT(Order_ID),
            2) AS NOT_RETURN_RATE
FROM
    return_analysis
GROUP BY Product_Category
ORDER BY RETURN_RATE DESC;

-- 3.	How do return rates vary by user payment method?
SELECT 
    Payment_Method,
    ROUND(SUM(CASE
                WHEN Return_Status = 'Return' THEN 1
                ELSE 0
            END) * 100 / COUNT(Order_ID),
            2) AS RETURN_RATE,
    ROUND(SUM(CASE
                WHEN Return_Status != 'Return' THEN 1
                ELSE 0
            END) * 100 / COUNT(Order_ID),
            2) AS NOT_RETURN_RATE
FROM
    return_analysis
GROUP BY Payment_Method
ORDER BY RETURN_RATE DESC;

-- 4.	What is the average order value of returned vs. non-returned items
SELECT 
    Return_Status,
    Product_Category,
    COUNT(Order_ID) AS TOTAL_ORDER,
    ROUND(SUM(Total_Purchase_Amount), 2) AS TOTAL_REVENEU,
    ROUND(SUM(Total_Purchase_Amount) / COUNT(order_ID),
            2) AS AOV
FROM
    return_analysis
GROUP BY Product_Category , Return_Status
ORDER BY Product_Category , Return_Status DESC;

