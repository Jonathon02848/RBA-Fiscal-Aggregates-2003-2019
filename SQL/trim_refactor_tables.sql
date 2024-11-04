-- #################################################
-- -- Financial Trim
--  CREATE TABLE financial_aggregates_trim AS(
-- 	SELECT * FROM public.financial_aggregates_raw
-- 		WHERE datetime_id >316
-- 		AND datetime_id <521
-- 	ORDER BY "datetime_id" ASC );

-- #################################################
-- -- Credit Trim
--  CREATE TABLE credit_aggregates_trim AS(
-- 	SELECT * FROM public.lending_credit_aggregates_raw
-- 		WHERE datetime_id >316
-- 		AND datetime_id <521
-- 	ORDER BY "datetime_id" ASC );

-- #################################################
--Monetary trim
-- CREATE TABLE monetary_aggregates_trim AS(
-- 	SELECT * FROM public.monetary_aggregates_raw
-- 		WHERE datetime_id > 522
-- 		AND datetime_id < 727
-- 	ORDER BY "datetime_id" ASC);

-- #################################################
-- REFACTORED TABLES
-- #################################################
--Financial Refactor
--  CREATE TABLE financial_aggregates_refactor AS(
--  SELECT ROW_NUMBER() OVER (ORDER BY public.financial_aggregates_trim.datetime_id ASC)::int AS "dt_id", *
-- 	FROM public.financial_aggregates_trim
-- 	ORDER BY "dt_id" ASC);
--SELECT * FROM public.financial_aggregates_refactor ORDER BY "dt_id" ASC 

-- -- Format ID:
-- Care w/ procedure.
-- ALTER TABLE public.financial_aggregates_refactor
-- RENAME COLUMN "datetime_id" TO "old_id";
-- ALTER TABLE public.financial_aggregates_refactor
-- RENAME COLUMN "dt_id" TO "datetime_id";
-- ALTER TABLE public.financial_aggregates_refactor
-- DROP COLUMN "old_id";
--SELECT * FROM public.financial_aggregates_refactor ORDER BY "datetime_id" ASC 

-- #################################################
--Credit Refactor
--  CREATE TABLE credit_aggregates_refactor AS(
--  SELECT ROW_NUMBER() OVER (ORDER BY public.credit_aggregates_trim.datetime_id ASC)::int AS "dt_id", *
-- 	FROM public.credit_aggregates_trim
-- 	ORDER BY "dt_id" ASC);
-- SELECT * FROM public.credit_aggregates_refactor ORDER BY "dt_id" ASC 

-- Format ID:
-- ALTER TABLE public.credit_aggregates_refactor
-- RENAME COLUMN "datetime_id" TO "old_id";
-- ALTER TABLE public.credit_aggregates_refactor
-- RENAME COLUMN "dt_id" TO "datetime_id";
-- ALTER TABLE public.credit_aggregates_refactor
-- DROP COLUMN "old_id";
--SELECT * FROM public.credit_aggregates_refactor ORDER BY "datetime_id" ASC 


-- #################################################
-- Monetary Refactor
--  CREATE TABLE monetary_aggregates_refactor AS(
--  SELECT ROW_NUMBER() OVER (ORDER BY public.monetary_aggregates_trim.datetime_id ASC)::int AS "dt_id", *
-- 	FROM public.monetary_aggregates_trim
-- 	ORDER BY "dt_id" ASC);
-- SELECT * FROM public.monetary_aggregates_refactor ORDER BY "dt_id" ASC 


-- -- Format ID:

-- ALTER TABLE public.monetary_aggregates_refactor
-- RENAME COLUMN "datetime_id" TO "old_id";
-- ALTER TABLE public.monetary_aggregates_refactor
-- RENAME COLUMN "dt_id" TO "datetime_id";
-- ALTER TABLE public.monetary_aggregates_refactor
-- DROP COLUMN "old_id";
-- SELECT * FROM public.monetary_aggregates_refactor ORDER BY "datetime_id" ASC 

-- #################################################


