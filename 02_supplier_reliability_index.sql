/* BUSINESS CASE: Supplier Reliability & Fulfillment Risk
OBJECTIVE:    Analyze the delay between Funding and the first merchant repayment 
              per supplier to detect potential shipping or manufacturing delays.
INSIGHT:       Suppliers with high average delays may represent a secondary 
              risk factor for merchant cash flow and Treyd’s recovery.
*/

WITH RANKS AS(
SELECT P.SupplierName,
R.PO_ID,
P.FundingDate,
R.RepaymentDate,
ROW_NUMBER() OVER(PARTITION BY R.PO_ID ORDER BY ISNULL(REPAYMENTDATE,GETDATE())) 
Repayment_RANK
FROM PurchaseOrders P LEFT JOIN Repayments R
ON P.PO_ID = R.PO_ID
)
, DAYS_TO_FIRST_REPAY AS
(
SELECT * ,
DATEDIFF(DAY,FundingDate, ISNULL(REPAYMENTDATE,GETDATE())) DAYS_TO_FIRST_REPAY
FROM RANKS R
WHERE Repayment_RANK = 1
)
SELECT SUPPLIERNAME, 
COUNT(DISTINCT PO_ID) #PURCHASES,
AVG(DAYS_TO_FIRST_REPAY) AVG_DAYS_TO_FIRST_REPAY
FROM DAYS_TO_FIRST_REPAY
GROUP BY SupplierName