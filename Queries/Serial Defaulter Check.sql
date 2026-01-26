/* 
Treyd's Risk team wants to know if a merchant is a "Serial Defaulter".
The Task: calculate the average number of days between defaults for each merchant who has defaulted more than once.
*/
with base as

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

, base2 as

(

SELECT *,

LEAD(trigger_date_to_default) OVER( PARTITION BY MERCHANTID 

ORDER BY trigger_date_to_default) NEXT_DEFAULT

FROM BASE

),

BASE3 AS(

SELECT * ,

DATEDIFF(DAY,trigger_date_to_default,NEXT_DEFAULT) DAYS_BETWEEN_DEFAULTS

FROM BASE2

)





SELECT MerchantID,



AVG(DAYS_BETWEEN_DEFAULTS) AVG_DAYS_BETWEEN_DEFAULTS

FROM BASE3

GROUP BY MerchantID

HAVING COUNT(REPAYMENTID)>1