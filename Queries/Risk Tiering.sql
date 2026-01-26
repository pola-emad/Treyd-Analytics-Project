/*
Business Scenario
Treyd needs to automate risk levels to help the collections team focus their efforts. 
A merchant's risk isn't just about what they owe right now, but also their historical reliability.

Clear Objective
Assign each merchant to one of three tiers (Red, Amber, Green) based on their repayment behavior.

The Rules:

    Red: > 1 current default (Unpaid and DueDate is > 30 days ago).

    Amber: Exactly 1 current default OR ≥ 2 historical defaults (Paid, but RepaymentDate was > 30 days after DueDate).

    Green: All other merchants.
*/
with Default_events as

(

SELECT 

R.RepaymentID,

MERCHANTID,

DUEDATE,

REPAYMENTDATE,

AMOUNT,

DATEDIFF(DAY,DUEDATE,ISNULL(REPAYMENTDATE,GETDATE())) OVERDUE_DAYS,

DATEADD(DAY,31,DueDate) trigger_date_to_default



FROM Repayments R

WHERE 

DATEDIFF(DAY, R.DueDate,

ISNULL(R.RepaymentDate,GETDATE()))>30 -- IF THE MERCHANT DIDN'T PAY TILL TODAY



)

-- count current defaults

-- count historical defaults

,DEFAULT_COUNTS AS

(

SELECT MerchantID,

SUM(CASE WHEN RepaymentDate IS NOT NULL THEN 1 ELSE 0 END) HISTORICAL_DEFAULTS,

SUM( CASE WHEN REPAYMENTDATE IS NULL 

THEN CASE WHEN OVERDUE_DAYS>30 THEN 1 ELSE 0 END

ELSE 0

END) CURRENT_DEFAULTS



FROM Default_events

GROUP BY MerchantID

),

FLAGGED_MERCHANTS AS 

(

SELECT *,

CASE

WHEN CURRENT_DEFAULTS >1 THEN 'RED'

WHEN CURRENT_DEFAULTS = 1 OR HISTORICAL_DEFAULTS>2 THEN 'AMBER'

ELSE 'GREEN'

END CATEGROY

FROM DEFAULT_COUNTS

)

SELECT * FROM FLAGGED_MERCHANTS