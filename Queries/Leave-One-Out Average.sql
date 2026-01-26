/*
Business Scenario
We want to compare each merchant’s Average Order Value (AOV) against the Average AOV of all other merchants in the same Industry, 
excluding the merchant being analyzed.

Clear Objective
For every merchant, calculate:

    Their own Personal AOV (Average TotalAmount per PO).

    The LOO Industry Average: The average AOV of all other merchants in that same industry.

    The Variance
*/


WITH MERCHANT_AVG_PURCHASE AS 
(
SELECT 
    MerchantID,
    AVG(TotalAmount) AS AOV
FROM PurchaseOrders
GROUP BY MerchantID
),
CALCULATING_LOO AS (

SELECT * 
,(SUM(AOV) OVER() - AOV) /(NULLIF(COUNT(AOV) OVER()- 1,0)) AS LOO
FROM MERCHANT_AVG_PURCHASE
)
SELECT *,
FORMAT(AOV/ NULLIF(LOO,0),'P') AS Variance
FROM CALCULATING_LOO