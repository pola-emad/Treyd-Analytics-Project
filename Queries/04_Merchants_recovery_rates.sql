/*
--Business Scenario:
When Treyd funds a Purchase Order, 
that amount is the Principal. We want to see, at a Merchant level, 
what percentage of their total funded principal has been repaid to date.

-- Clear Objective
calculate the Cumulative Recovery Rate for each merchant.
*/


/* 
1. GET THE TOTAL FUND FOR EACH MERCHANT
2. GET THE TOTAL REPAY FOR EACH MERCHANT
3. GET THE RECOVERY RATE

*/
WITH MERCHANT_FUNDS AS(
SELECT MerchantID,
SUM(TotalAmount) AS TOTAL_FUND
FROM PurchaseOrders
GROUP BY MerchantID
),
MERCHANT_REPAYMET AS(
SELECT MerchantID,
SUM(Amount) TOTAL_REPAID_AMOUNT
FROM Repayments
WHERE RepaymentDate IS NOT NULL -- EXCLUDING ONLY THE UNPAID REPAYMENTS NOT THE LATE ONES
GROUP BY MerchantID
)

-- MAIN QUERY

SELECT 
MF.MerchantID,
M.MerchantName,
MF.TOTAL_FUND,
ISNULL(TOTAL_REPAID_AMOUNT,0) AS TOTAL_REPAID_AMOUNT,
ISNULL(TOTAL_REPAID_AMOUNT,0)/ TOTAL_FUND AS RECOVERY_RATE

FROM MERCHANT_FUNDS MF LEFT JOIN MERCHANT_REPAYMET MR
ON MF.MerchantID = MR.MerchantID
LEFT JOIN Merchants M 
ON MF.MerchantID = M.MerchantID 

