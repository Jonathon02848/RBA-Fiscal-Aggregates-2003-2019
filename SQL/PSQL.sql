-- #########################################################
--PSQL Code - 

\copy ( SELECT * FROM financial_aggregates_refactor ORDER BY "datetime_id" ASC) TO 'D:\Projects\Project 1 Finance\Use one of these\FinanceMetrics\Crop\FinFilled.csv' DELIMITER ',' CSV HEADER
\copy ( SELECT * FROM credit_aggregates_refactor ORDER BY "datetime_id" ASC) TO 'D:\Projects\Project 1 Finance\Use one of these\FinanceMetrics\Crop\CreditFilled.csv' DELIMITER ',' CSV HEADER
\copy ( SELECT * FROM monetary_aggregates_refactor ORDER BY "datetime_id" ASC) TO 'D:\Projects\Project 1 Finance\Use one of these\FinanceMetrics\Crop\MonetaryFilled.csv' DELIMITER ',' CSV HEADER

-- #########################################################
--Submitted Code:
\copy ( SELECT * FROM financial_aggregates_fill ORDER BY "datetime_id" ASC) TO 'D:\Projects\Project 1 Finance\Use one of these\FinanceMetrics\Crop\FinFilled.csv' DELIMITER ',' CSV HEADER
\copy ( SELECT * FROM credit_aggregates_fill ORDER BY "datetime_id" ASC) TO 'D:\Projects\Project 1 Finance\Use one of these\FinanceMetrics\Crop\CreditFilled.csv' DELIMITER ',' CSV HEADER
\copy ( SELECT * FROM monetary_aggregates_fill ORDER BY "datetime_id" ASC) TO 'D:\Projects\Project 1 Finance\Use one of these\FinanceMetrics\Crop\MonetaryFilled.csv' DELIMITER ',' CSV HEADER


