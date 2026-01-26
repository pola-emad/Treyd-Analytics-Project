/* BUSINESS CASE: Portfolio Concentration Risk (Pareto Analysis)
OBJECTIVE:    Identify the top tier of merchants responsible for 20% (or 65%) 
              of total funding volume using a running total approach.
INSIGHT:       Ensures the portfolio is sufficiently diversified to withstand 
              the failure of any single high-volume client.
*/

/* 
1. get the total fund
2. get the commulative fund percentage
3. filter by 20% of total

*/

-- GETTING THE TOTAL FUND
DECLARE @TOTALFUND INT
SET @TOTALFUND =(
SELECT SUM(TotalAmount) TotalFund
FROM PurchaseOrders);

with merchant_fund as
(
SELECT M.MerchantID ,
M.MERCHANTNAME,
SUM(TotalAmount) TOTALAMOUNT
FROM PurchaseOrders P INNER JOIN Merchants M
ON M.MerchantID = P.MerchantID
GROUP BY M.MerchantID,M.MERCHANTNAME
),

COMMULATIVE_FUND AS(
SELECT* ,
SUM(F.TOTALAMOUNT) OVER(ORDER BY TOTALAMOUNT DESC ,MerchantID)/@TOTALFUND COMM_FUND
FROM MERCHANT_FUND F
),

PREV_COMM_FUND AS
(
	SELECT*,
	ISNULL(LAG(C.COMM_FUND) OVER ( ORDER BY TOTALAMOUNT DESC ,MerchantID),0) PREV_COMM_FUND
	FROM COMMULATIVE_FUND C
)

SELECT 
C.MerchantName,
C.TOTALAMOUNT,
FORMAT(C.COMM_FUND,'P') COMM_FUND

FROM PREV_COMM_FUND C
WHERE C.PREV_COMM_FUND < 0.65
