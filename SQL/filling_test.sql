-- #################################################
-- Beginning of Back/Forward Fill process, and making combination set.
-- ALSO EDIT ALTER TABLES TO KEEP ORIGINAL datetime_id
--Note: Create type first for funct.DO NOT NEED?
-- CREATE TYPE mini_table AS (dt_id int, col_val real);

--Table deletion for process tables:
-- DROP TABLE IF EXISTS  "temp_table_low" CASCADE;
-- DROP TABLE IF EXISTS  "temp_table_low_one" CASCADE;

-- DROP TABLE IF EXISTS  "temp_backfill_table" CASCADE;

-- DROP TABLE IF EXISTS  "temp_table_high" CASCADE;
-- DROP TABLE IF EXISTS  "temp_frontfill_table" CASCADE;

-- DROP TABLE IF EXISTS  "financial_aggregates_fill" CASCADE;
-- DROP TABLE IF EXISTS  "credit_aggregates_fill" CASCADE;
-- DROP TABLE IF EXISTS  "monetary_aggregates_fill" CASCADE;

-- #################################################
-- Generating (to-be) filled tables:

-- CREATE TABLE credit_aggregates_fill  AS(
-- 	SELECT * FROM public.credit_aggregates_refactor
-- 	ORDER BY "datetime_id"
-- 	);

-- CREATE TABLE financial_aggregates_fill  AS(
-- 	SELECT * FROM public.financial_aggregates_refactor
-- 	ORDER BY "datetime_id"
-- 	);
	
-- CREATE TABLE monetary_aggregates_fill AS(
-- 	SELECT * FROM public.monetary_aggregates_refactor
-- 	ORDER BY "datetime_id"
-- 	);

-- #################################################
-- -- Generating Backfill temp table procedure
-- -- Set: '--' out to get one you want
-- CREATE TABLE temp_table_low_one  AS(
-- 	SELECT *
-- 	FROM public.financial_aggregates_refactor
-- 	-- FROM public.credit_aggregates_refactor
-- 	-- FROM public.monetary_aggregates_refactor
-- 	WHERE datetime_id <103
-- 	ORDER BY "datetime_id"
-- 	);
--  SELECT * FROM public.temp_table_low_one;

-- --Flipped Low Data:
-- DROP TABLE IF EXISTS  "temp_table_low" CASCADE;
-- CREATE TABLE temp_table_low  AS(
-- 	SELECT ROW_NUMBER() OVER (ORDER BY datetime_id DESC)::int AS "dt_id",
-- 	* FROM temp_table_low_one WHERE datetime_id <103 ORDER BY "dt_id" ASC);
-- --FLIP FUNCTIONS
-- ALTER TABLE temp_table_low
-- 	RENAME COLUMN "datetime_id" TO "old_id";
-- ALTER TABLE temp_table_low
-- 	RENAME COLUMN "dt_id" TO "datetime_id";
-- ALTER TABLE temp_table_low	
-- 	DROP COLUMN "old_id";
-- SELECT * FROM temp_table_low;

-- Test cases:
-- SELECT * FROM temp_table_low WHERE datetime_id IN(98,99,100,101);

-- Flip Data back:
--  DROP TABLE IF EXISTS  "temp_table_low_filled" CASCADE;
-- CREATE TABLE temp_table_low_filled  AS(
-- 	SELECT ROW_NUMBER() OVER (ORDER BY datetime_id DESC)::int AS "dt_id",*
-- 	FROM (SELECT * FROM temp_table_low WHERE datetime_id <103 ORDER BY "datetime_id" DESC)
-- 	ORDER BY "datetime_id" ASC
-- 	);
-- --FLIP FUNCTIONS
-- ALTER TABLE temp_table_low_filled
-- 	RENAME COLUMN "datetime_id" TO "old_id";
-- ALTER TABLE temp_table_low_filled
-- 	RENAME COLUMN "dt_id" TO "datetime_id";
-- ALTER TABLE temp_table_low_filled	
-- 	DROP COLUMN "old_id";
-- SELECT * FROM temp_table_low_filled ORDER BY datetime_id ASC;

-- #################################################
-- -- Generating Frontfill temp table
CREATE TABLE temp_table_high  AS(
	SELECT *
	FROM public.financial_aggregates_refactor
	-- FROM public.credit_aggregates_refactor
	-- FROM public.monetary_aggregates_refactor
	WHERE datetime_id > 101
	ORDER BY "datetime_id" ASC
	);

-- #################################################
-- Visual checker

--SELECT * FROM public.temp_table_low_one ORDER BY datetime_id ASC;
--SELECT * FROM public.temp_table_high ORDER BY datetime_id ASC;

-- #################################################
-- CORE PROCEDURE: TEMP TABLE GENERATION, UPDATE AND APPLICATION
-- BOTH LOW AND HIGH (BACKFILL/FORWARDFILL HERE)
-- DROP TABLE IF EXISTS  "temp_table" CASCADE;
-- CREATE TABLE temp_table
-- AS SELECT datetime_id,
-- COALESCE(m12_non_financial_business_cg_fa, 
-- FIRST_VALUE(m12_non_financial_business_cg_fa) OVER(
-- PARTITION BY generic_group ORDER BY datetime_id ASC)) AS data_filled
-- FROM (SELECT datetime_id, m12_non_financial_business_cg_fa, 
-- 	  COUNT(m12_non_financial_business_cg_fa) OVER (ORDER BY datetime_id ASC) AS generic_group
-- 	  FROM public.temp_table_low ORDER BY datetime_id ASC);
-- --It does work!!!
-- SELECT * FROM public.temp_table;

-- UPDATED TABLE:
-- UPDATE public.temp_table_low
-- SET
-- m12_non_financial_business_cg_fa = public.temp_table.data_filled
-- FROM
-- public.temp_table
-- WHERE
-- (public.temp_table_low.datetime_id = temp_table.datetime_id);
-- -- Checker
-- SELECT datetime_id,m12_non_financial_business_cg_fa
-- FROM public.temp_table_low
-- WHERE m12_non_financial_business_cg_fa IS NULL
--  OR temp_table_low.datetime_id IN(98,99,100,101,102)
-- ORDER BY datetime_id ASC;
	
-- -- FOR BACKFILL FLIP DATA BACK:
--  DROP TABLE IF EXISTS  "temp_table_low_filled" CASCADE;
-- CREATE TABLE temp_table_low_filled  AS(
-- 	SELECT ROW_NUMBER() OVER (ORDER BY datetime_id DESC)::int AS "dt_id",*
-- 	FROM (SELECT * FROM temp_table_low WHERE datetime_id <103 ORDER BY "datetime_id" DESC)
-- 	ORDER BY "datetime_id" ASC	);
-- --FLIP FUNCTIONS
-- ALTER TABLE temp_table_low_filled
-- 	RENAME COLUMN "datetime_id" TO "old_id";
-- ALTER TABLE temp_table_low_filled
-- 	RENAME COLUMN "dt_id" TO "datetime_id";
-- ALTER TABLE temp_table_low_filled	
-- 	DROP COLUMN "old_id";
-- SELECT * FROM temp_table_low_filled ORDER BY datetime_id ASC;

-- ENSURE FILL IS UP TO DATE BEFORE UPDATING!!

-- FILLED AGGREGATE UPDATE FUNCTION:
-- UPDATE public.financial_aggregates_fill
-- 	SET 
-- 		m12_non_financial_business_cg_fa = public.temp_table_low_filled.m12_non_financial_business_cg_fa
-- 	FROM
-- 		public.temp_table_low_filled -- public.temp_table_high
-- 	WHERE
-- 		public.financial_aggregates_fill.datetime_id = public.temp_table_low_filled.datetime_id;

--CHECK
-- SELECT * 
-- 	FROM public.financial_aggregates_fill
-- WHERE m12_non_financial_business_cg_fa IS NULL
-- OR datetime_id IN(1,2,3,4,5,97,98,99,100,101,102)
-- ORDER BY datetime_id ASC;
	
-- public.credit_aggregates_fill
-- public.financial_aggregates_fill
-- public.monetary_aggregates_fill
-- #################################################

SELECT * FROM public.financial_aggregates_fill ORDER BY datetime_id ASC;

-- -- HIGH VERSION - Seperate to remove added step

-- DROP TABLE IF EXISTS  "temp_table" CASCADE;
-- CREATE TABLE temp_table
-- AS SELECT datetime_id,
-- COALESCE(m_business_cg_fa, 
-- FIRST_VALUE(m_business_cg_fa) OVER(
-- PARTITION BY generic_group ORDER BY datetime_id ASC)) AS data_filled
-- FROM (SELECT datetime_id, m_business_cg_fa, 
-- 	  COUNT(m_business_cg_fa) OVER (ORDER BY datetime_id ASC) AS generic_group
-- 	  FROM public.temp_table_high ORDER BY datetime_id ASC);
-- SELECT * FROM public.temp_table;
-- --UPDATED TABLE:

UPDATE public.temp_table_high
SET
m_business_cg_fa = public.temp_table.data_filled
FROM
public.temp_table
WHERE
(public.temp_table_high.datetime_id = temp_table.datetime_id);
-- Checker
SELECT datetime_id,m_business_cg_fa
FROM public.temp_table_high
WHERE m_business_cg_fa IS NULL
 OR temp_table_high.datetime_id IN(198,199,200,201,202)
ORDER BY datetime_id ASC;
UPDATE public.financial_aggregates_fill
	SET 
		m_business_cg_fa = public.temp_table_high.m_business_cg_fa
	FROM
		public.temp_table_high
	WHERE
		public.financial_aggregates_fill.datetime_id = public.temp_table_high.datetime_id;
		
-- public.credit_aggregates_fill
-- public.financial_aggregates_fill
-- public.monetary_aggregates_fill
-- #################################################

--End: Null Checkers
--NULLS - Fin Temp Tables
-- SELECT 
-- 	SUM(CASE WHEN "m_housing_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_1",
-- 	SUM(CASE WHEN "m12_housing_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_2",
-- 	SUM(CASE WHEN "m_owned_housing_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_3",
-- 	SUM(CASE WHEN "m12_owned_housing_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_4",
-- 	SUM(CASE WHEN "m_investor_housing_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_5",
-- 	SUM(CASE WHEN "m12_investor_housing_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_6",
-- 	SUM(CASE WHEN "m_other_personal_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_7",
-- 	SUM(CASE WHEN "m12_other_personal_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_8",
-- 	SUM(CASE WHEN "m_non_financial_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_9",
-- 	SUM(CASE WHEN "m12_non_financial_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_10",
-- 	SUM(CASE WHEN "m_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_11",
-- 	SUM(CASE WHEN "m12_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_12",
-- 	SUM(CASE WHEN "m_select_fin_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_13",
-- 	SUM(CASE WHEN "m12_select_fin_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_14",
-- 	SUM(CASE WHEN "m_total_excfin_businss_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_15",
-- 	SUM(CASE WHEN "m12_total_excfin_businss_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_16",
-- 	SUM(CASE WHEN "m_total_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_17",
-- 	SUM(CASE WHEN "m12_total_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_18",
-- 	SUM(CASE WHEN "m_total_incselectfin_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_19",
-- 	SUM(CASE WHEN "m12_total_incselectfin_business_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_20",
-- 	SUM(CASE WHEN "m_m3_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_21",
-- 	SUM(CASE WHEN "m12_m3_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_22",
-- 	SUM(CASE WHEN "m_broad_money_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_23",
-- 	SUM(CASE WHEN "m12_broad_money_cg_fa" IS NULL THEN 1 ELSE 0 END) AS "null_24"

-- FROM public.financial_aggregates_fill;

-- FROM public.financial_aggregates_refactor;


-- #################################################

--CreditNULLS
-- SELECT 
-- 	SUM(CASE WHEN "m_loans_advances_bank_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_1",
-- 	SUM(CASE WHEN "m_loans_advances_bank_lca" IS NULL THEN 1 ELSE 0 END) AS "null_2",
-- 	SUM(CASE WHEN "m_loans_advances_nbfi_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_3",
-- 	SUM(CASE WHEN "m_loans_advances_nbfi_lca" IS NULL THEN 1 ELSE 0 END) AS "null_4",
-- 	SUM(CASE WHEN "m_loans_advances_afi_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_5",
-- 	SUM(CASE WHEN "m_loans_advances_afi_lca" IS NULL THEN 1 ELSE 0 END) AS "null_6",
-- 	SUM(CASE WHEN "m_nonfin_issue_bills_lca" IS NULL THEN 1 ELSE 0 END) AS "null_7",
-- 	SUM(CASE WHEN "m_issue_bills_lca" IS NULL THEN 1 ELSE 0 END) AS "null_8",
-- 	SUM(CASE WHEN "m_narrow_c_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_9",
-- 	SUM(CASE WHEN "mseadj_narrow_c_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_10",
-- 	SUM(CASE WHEN "m_narrow_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_11",
-- 	SUM(CASE WHEN "mseadj_narrow_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_12",
-- 	SUM(CASE WHEN "m_total_c_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_13",
-- 	SUM(CASE WHEN "mseadj_total_c_excfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_14",
-- 	SUM(CASE WHEN "m_total_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_15",
-- 	SUM(CASE WHEN "m_total_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_16",
-- 	SUM(CASE WHEN "m_owner_housing_lca" IS NULL THEN 1 ELSE 0 END) AS "null_17",
-- 	SUM(CASE WHEN "mseadj_owner_housing_lca" IS NULL THEN 1 ELSE 0 END) AS "null_18",
-- 	SUM(CASE WHEN "m_investor_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_19",
-- 	SUM(CASE WHEN "mseadj_investor_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_20",
-- 	SUM(CASE WHEN "m_personal_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_21",
-- 	SUM(CASE WHEN "mseadj_personal_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_22",
-- 	SUM(CASE WHEN "m_nonfin_business_c_lca" IS NULL THEN 1 ELSE 0 END) AS "null_23",
-- 	SUM(CASE WHEN "mseadj_nonfin_business_lca" IS NULL THEN 1 ELSE 0 END) AS "null_24",
-- 	SUM(CASE WHEN "m_business_lca" IS NULL THEN 1 ELSE 0 END) AS "null_25",
-- 	SUM(CASE WHEN "mseadj_business_lca" IS NULL THEN 1 ELSE 0 END) AS "null_26",
-- 	SUM(CASE WHEN "m_govsector_lending_afi_lca" IS NULL THEN 1 ELSE 0 END) AS "null_27",
-- 	SUM(CASE WHEN "m_house_loan_switch_lca" IS NULL THEN 1 ELSE 0 END) AS "null_28",
-- 	SUM(CASE WHEN "m_total_incselectfin_business_lca" IS NULL THEN 1 ELSE 0 END) AS "null_29",
-- 	SUM(CASE WHEN "mseadj_total_incselectfin_business_lca" IS NULL THEN 1 ELSE 0 END) AS "null_30",
-- 	SUM(CASE WHEN "m_business_incselectfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_31",
-- 	SUM(CASE WHEN "mseadj_business_incselectfin_lca" IS NULL THEN 1 ELSE 0 END) AS "null_32"
-- FROM public.lending_credit_aggregates_raw;

-- #################################################

-- MonetaryNULLS
-- SELECT 
-- 	SUM(CASE WHEN "m_currency_ma" IS NULL THEN 1 ELSE 0 END) AS "null_1",
-- 	SUM(CASE WHEN "m_transaction_deposits_adi_ma" IS NULL THEN 1 ELSE 0 END) AS "null_2",
-- 	SUM(CASE WHEN "m_m1_ma" IS NULL THEN 1 ELSE 0 END) AS "null_3",
-- 	SUM(CASE WHEN "m_deposit_certificates_adi_ma" IS NULL THEN 1 ELSE 0 END) AS "null_4",
-- 	SUM(CASE WHEN "m_non_transaction_deposits_adi_ma" IS NULL THEN 1 ELSE 0 END) AS "null_5",
-- 	SUM(CASE WHEN "m_m3_ma" IS NULL THEN 1 ELSE 0 END) AS "null_6",
-- 	SUM(CASE WHEN "m_other_borrowing_privsect_afi_ma" IS NULL THEN 1 ELSE 0 END) AS "null_7",
-- 	SUM(CASE WHEN "m_broad_money_ma" IS NULL THEN 1 ELSE 0 END) AS "null_8",
-- 	SUM(CASE WHEN "mseadj_currency_ma" IS NULL THEN 1 ELSE 0 END) AS "null_9",
-- 	SUM(CASE WHEN "mseadj_m1_ma" IS NULL THEN 1 ELSE 0 END) AS "null_10",
-- 	SUM(CASE WHEN "mseadj_m3_ma" IS NULL THEN 1 ELSE 0 END) AS "null_11",
-- 	SUM(CASE WHEN "mseadj_broad_money_ma" IS NULL THEN 1 ELSE 0 END) AS "null_12",
-- 	SUM(CASE WHEN "m_base_money_ma" IS NULL THEN 1 ELSE 0 END) AS "null_13",
-- 	SUM(CASE WHEN "m_offshore_borrow_afi_ma" IS NULL THEN 1 ELSE 0 END) AS "null_14"
-- FROM public.monetary_aggregates_raw;

-- FROM public.temp_table_low;
-- FROM public.temp_table_high;