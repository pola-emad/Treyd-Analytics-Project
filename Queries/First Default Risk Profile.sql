/*
Business Scenario
At Treyd, we finance inventory by paying suppliers on behalf of merchants. 
The merchant then repays us over a fixed term. 
A critical risk metric is the "Time to First Default.
" We define a "default" as any repayment that is more than 30 days past its due date.

Risk Analysts want to understand which merchants are "serial defaulters" versus those who had a one-time struggle.

Clear Objective
Write a query to identify all merchants who have defaulted at least once. For these merchants,
return:

    The Merchant ID.

    The Date of their very first default (the date the payment became 31 days overdue).

    The Total number of defaults they have had to date.

    The Total amount currently outstanding across all their defaulted payments.
*/
with defaulters as

(

SELECT *,

CASE

WHEN REPAYMENTDATE IS NULL THEN AMOUNT

ELSE 0

END OUTSTANDING_AMOUNT

FROM Repayments R

WHERE DATEDIFF(DAY, R.DueDate,

ISNULL(R.RepaymentDate,GETDATE()) -- IF THE MERCHANT DIDN'T PAY TILL TODAY

)>30

)



SELECT MERCHANTID ,

COUNT(*) #DEFAULTS,

DATEADD(DAY,31,MIN(DueDate)) first_date_to_default,

SUM(OUTSTANDING_AMOUNT) OUTSTANDING_AMOUNT

FROM DEFAULTERS D

GROUP BY MERCHANTID