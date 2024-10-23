-- #####################################################
--Queries

-- ######	CORE	######

-- Query 1: Finance, Credit and Monetary Statistics:
DROP TABLE IF EXISTS "Query: Finance Measures" CASCADE;

CREATE TABLE "Query: Finance Measures" AS(
SELECT datetime_id AS "DateTime ID",
	* FROM finance_statistics ORDER BY datetime_id ASC)
ALTER TABLE "Query: Finance Measures"
DROP COLUMN datetime_id;
SELECT * FROM "Query: Finance Measures" ORDER BY "DateTime ID" ASC;
-- PSQL
--\copy ( SELECT * FROM "Query: Finance Measures" ORDER BY "DateTime ID" ASC) TO 'D:\Projects\Project 1 Finance\Project\FinanceMetrics\Queries\QueryFinance.csv' DELIMITER ',' CSV HEADER

-- #####################################################

-- Query 2: Housing-Relevant Queries:
DROP TABLE IF EXISTS "Query: Housing" CASCADE;

CREATE TABLE "Query: Housing & Personal" AS(
SELECT datetime_id AS "DateTime ID",
	"Report Month",
	"Financial Growth: Monthly Housing Credit",
	"Financial Growth: 12-Month Housing Credit",
	"Financial Growth: Monthly Self-Occupied Housing Credit",
	"Financial Growth: 12-Month Self-Occupied Housing Credit",
	"Financial Growth: Monthly Investor Housing Credit",
	"Financial Growth: 12-Month Investor Housing Credit",
	"Credit Aggregate: Monthly Self-Occupied Housing",
	"Credit Aggregate: Season-Adj Monthly Self-Occupied Housing",
	"Credit Aggregate: Monthly Personal Cred.",
	"Credit Aggregate: Season-Adj Monthly Personal Cred."
	FROM finance_statistics ORDER BY datetime_id ASC);
--ALTER TABLE "Query: Housing"
--DROP COLUMN datetime_id;
SELECT * FROM "Query: Housing & Personal" ORDER BY "DateTime ID" ASC;
-- PSQL
--\copy ( SELECT * FROM "Query: Housing & Personal" ORDER BY "DateTime ID" ASC) TO 'D:\Projects\Project 1 Finance\Project\FinanceMetrics\Queries\QueryHousingPersonal.csv' DELIMITER ',' CSV HEADER

-- #####################################################

-- Query 3: Business-Relevant Queries
DROP TABLE IF EXISTS "Query: Business" CASCADE;

CREATE TABLE "Query: Business" AS(
SELECT datetime_id AS "DateTime ID",
	"Report Month",
	"Financial Growth: Monthly Non-Fin Businesses",
	"Financial Growth: 12-Month Non-Fin Businesses",
	"Financial Growth: Monthly Business",
	"Financial Growth: 12-Month Business",
	"Financial Growth: Monthly Exc-Fin Businesses",
	"Financial Growth: 12-Month Exc-Fin Businesses",
	"Credit Aggregate: Monthly Bank Loans Exc-Fin Businesses",
	"Credit Aggregate: Monthly Bank Loans, Business",
	"Credit Aggregate: Monthly NBFI Loans Exc-Fin Businesses",
	"Credit Aggregate: Monthly NBFI Loans, Business",
	"Credit Aggregate: Monthly AFI Loans & Advances Exc-Fin Business",
	"Credit Aggregate: Monthly Bills on Issue to Non-Fin Business",
	"Credit Aggregate: Monthly Narrow Cred. Exc-Fin Business",
	"Credit Aggregate: Monthly Narrow Cred. Business",
	"Credit Aggregate: Season-Adj Monthly Narrow Cred. Business",
	"Credit Aggregate: Monthly Total Cred. Exc-Fin Business",
	"Credit Aggregate: Season-Adj Monthly Total Cr. Exc-Fin Business",
	"Credit Aggregate: Monthly Non-Fin Business",
	"Credit Aggregate: Season-Adj Monthly Non-Fin Business",
	"Credit Aggregate: Monthly Business",
	"Credit Aggregate: Season-Adj Monthly Business"
	FROM finance_statistics ORDER BY datetime_id ASC)
SELECT * FROM "Query: Business" ORDER BY "DateTime ID" ASC;
-- PSQL
-- \copy ( SELECT * FROM "Query: Business" ORDER BY "DateTime ID" ASC) TO 'D:\Projects\Project 1 Finance\Project\FinanceMetrics\Queries\QueryBusiness.csv' DELIMITER ',' CSV HEADER

-- #####################################################

-- Query 4:  Money Supply Queries
DROP TABLE IF EXISTS "Query: Monetary" CASCADE;

CREATE TABLE "Query: Monetary" AS(
SELECT datetime_id AS "DateTime ID",
	"Report Month",
	"Monetary Aggregate: M1 Money Supply",
	"Monetary Aggregate: M3 Money Supply",
	"Monetary Aggregate: Monthly Broad Money",
	"Monetary Aggregate: Seasonally-Adjusted M1 Money Supply",
	"Monetary Aggregate: Seasonally-Adjusted M3 Money Supply",
	"Monetary Aggregate: Seasonally-Adjusted Monthly Broad Money",
	"Monetary Aggregate: Base Money Supply",
	"Financial Growth: Monthly M3 Money",
	"Financial Growth: 12-Month M3 Money",
	"Financial Growth: Monthly Broad Money",
	"Financial Growth: 12-Month Broad Money"	
	FROM finance_statistics ORDER BY datetime_id ASC)
SELECT * FROM "Query: Monetary" ORDER BY "DateTime ID" ASC;
-- PSQL
-- \copy ( SELECT * FROM "Query: Monetary" ORDER BY "DateTime ID" ASC) TO 'D:\Projects\Project 1 Finance\Project\FinanceMetrics\Queries\QueryMonetary.csv' DELIMITER ',' CSV HEADER
