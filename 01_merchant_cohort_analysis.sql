/* BUSINESS CASE: Merchant Cohort Performance
OBJECTIVE:    Group merchants by their Join Month to calculate the average 
              value of their initial funding request.
INSIGHT:       Helps Marketing determine if the platform is attracting 
              larger enterprise clients over time (Up-market trend analysis).
*/


/* 
TABLES: PO: FIRST FUND FOR EVERY MERCHANT 
MERCHANTS:FOR EVERY MONTH & YEAR, AVG(FIRST FUNDS), COUNT (THE MERCHANTS)
NOTE: count the number of signed-up merchants even those who doesn't purchase
*/
with ORDERED_FUNDS AS
(
SELECT P.PO_ID,
P.MerchantID,
P.TotalAmount,
P.FundingDate,
ROW_NUMBER() OVER (PARTITION BY MERCHANTID ORDER BY FUNDINGDATE) FUND_ORDER
FROM PurchaseOrders P
)

SELECT 
FORMAT(M.JoinedDate,'yyyy-MM') MONTH,
AVG(F.TotalAmount) as AVG_first_fund,
COUNT(M.MerchantID) #MERCHANTS
FROM Merchants M LEFT JOIN ORDERED_FUNDS F
ON M.MerchantID =F.MerchantID
WHERE FUND_ORDER = 1
GROUP BY FORMAT(M.JoinedDate,'yyyy-MM')
/* using row number enabled us to eliminate 1 cte because we filter on the row number.
when using first value, we need to either filter by first value  = amount or by grouping by the merchant is
*/