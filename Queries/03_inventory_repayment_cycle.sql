/* BUSINESS CASE: Inventory Turnover & Repayment Cycle
OBJECTIVE:    Calculate the number of days between Supplier Funding and 
              Final Debt Settlement for fully repaid Purchase Orders.
INSIGHT:       Measures the efficiency of the merchant's supply chain and 
              validates the accuracy of the funding terms provided by Treyd.
*/

--- GETTING COMPLETELY REPAID purchases
WITH BASE AS (
	SELECT DISTINCT PO_ID
	FROM Repayments
	EXCEPT
	SELECT DISTINCT PO_ID
	FROM Repayments
	WHERE RepaymentDate IS NULL
)

,BASE2 AS(
SELECT PO_ID,
MAX(REPAYMENTDATE) last_repayment_date
FROM Repayments R
WHERE R.PO_ID IN (SELECT PO_ID FROM BASE)
GROUP BY PO_ID
)
SELECT P.PO_ID,
P.MERCHANTID,
P.FUNDINGDATE,
B.last_repayment_date,
DATEDIFF(DAY,P.FundingDate,B.last_repayment_date) Cycle_days
FROM PurchaseOrders P INNER JOIN BASE2 B
ON B.PO_ID = P.PO_ID


