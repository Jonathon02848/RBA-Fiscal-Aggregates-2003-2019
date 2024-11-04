-- #################################################
--Reformatting checks
-- DELETE FROM public.credit_aggregates_fill;
-- SELECT * FROM public.credit_aggregates_fill;

-- DELETE FROM public.financial_aggregates_fill;
-- SELECT * FROM public.financial_aggregates_fill;

-- DELETE FROM public.monetary_aggregates_fill;
-- SELECT * FROM public.monetary_aggregates_fill;

-- #################################################
-- UNIQUES FOR FULL JOIN:
ALTER TABLE public.financial_aggregates_fill
RENAME COLUMN "datetime_id" TO "datetime_id_1";
ALTER TABLE public.financial_aggregates_fill
RENAME COLUMN "month_date" TO "month_date_1";

ALTER TABLE public.credit_aggregates_fill
RENAME COLUMN "datetime_id" TO "datetime_id_2";
ALTER TABLE public.credit_aggregates_fill
RENAME COLUMN "month_date" TO "month_date";

-- ALTER TABLE public.financial_aggregates
-- DROP COLUMN "old_id";

-- #################################################
CREATE TABLE financial_composite AS(
SELECT * FROM public.monetary_aggregates_fill
FULL JOIN public.financial_aggregates_fill ON public.financial_aggregates_fill.datetime_id_1 = public.monetary_aggregates_fill.datetime_id
FULL JOIN public.credit_aggregates_fill ON public.credit_aggregates_fill.datetime_id_2 = public.monetary_aggregates_fill.datetime_id)
SELECT * FROM public.financial_aggregates;

-- #################################################
-- Cropping data clones:
ALTER TABLE public.financial_composite
DROP COLUMN "datetime_id_1",
DROP COLUMN "month_date_1",
DROP COLUMN "datetime_id_2",
DROP COLUMN "month_date_2";
SELECT * FROM public.financial_composite;

-- #################################################
-- DROP Unfilled
ALTER TABLE public.financial_composite
DROP COLUMN "m_select_fin_business_cg_fa",
DROP COLUMN "m12_select_fin_business_cg_fa",
DROP COLUMN "m_total_incselectfin_business_cg_fa",
DROP COLUMN "m12_total_incselectfin_business_cg_fa",
DROP COLUMN "m_house_loan_switch_lca",
DROP COLUMN "m_total_incselectfin_business_lca",
DROP COLUMN "mseadj_total_incselectfin_business_lca",
DROP COLUMN "m_business_incselectfin_lca",
DROP COLUMN "mseadj_business_incselectfin_lca";
SELECT * FROM public.financial_composite;

-- #################################################
-- PRE-RENAMING FOR QUERY CLARITY:
-- Truncated names edited in post.

ALTER TABLE public.finance_statistics
RENAME COLUMN month_date TO report_month;
ALTER TABLE public.finance_statistics
RENAME COLUMN "month_date" TO "Month Date";
--##############################################
--Monetary
ALTER TABLE public.finance_statistics
RENAME COLUMN m_currency_ma TO "Monetary Aggregate: Monthly Currency";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_transaction_deposits_adi_ma TO "Monetary Aggregate: Monthly Transaction Deposits w/ ADIs";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_m1_ma TO "Monetary Aggregate: M1 Money Supply";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_deposit_certificates_adi_ma TO "Monetary Aggregate: Monthly Certificate Deposits w/ ADIs";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_non_transaction_deposits_adi_ma TO "Monetary Aggregate: Monthly Non-Transaction Deposits w/ ADIs";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_m3_ma TO "Monetary Aggregate: M3 Money Supply";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_other_borrowing_privsect_afi_ma TO "Monetary Aggregate: Monthly Private Sector Borrowing (Other) w/ ADIs";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_broad_money_ma TO "Monetary Aggregate: Monthly Broad Money";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_currency_ma TO "Monetary Aggregate: Seasonally-Adjusted Currency";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_m1_ma TO "Monetary Aggregate: Seasonally-Adjusted M1 Money Supply";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_m3_ma TO "Monetary Aggregate: Seasonally-Adjusted M3 Money Supply";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_broad_money_ma TO "Monetary Aggregate: Seasonally-Adjusted Monthly Broad Money";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_base_money_ma TO "Monetary Aggregate: Base Money Supply";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_offshore_borrow_afi_ma TO "Monetary Aggregate: Monthly Offshore Borrowings w/AFIs";
--##############################################
-- Financial Growth
ALTER TABLE public.finance_statistics
RENAME COLUMN m_housing_cg_fa TO "Financial Growth: Monthly Housing Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_housing_cg_fa TO "Financial Growth: 12-Month Housing Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_owned_housing_cg_fa TO "Financial Growth: Monthly Self-Occupied Housing Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_owned_housing_cg_fa TO "Financial Growth: 12-Month Self-Occupied Housing Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_investor_housing_cg_fa TO "Financial Growth: Monthly Investor Housing Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_investor_housing_cg_fa TO "Financial Growth: 12-Month Investor Housing Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_other_personal_cg_fa TO "Financial Growth: Monthly Credit (Other)";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_other_personal_cg_fa TO "Financial Growth: 12-Month Credit (Other)";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_non_financial_business_cg_fa TO "Financial Growth: Monthly Non-Fin Businesses";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_non_financial_business_cg_fa TO "Financial Growth: 12-Month Non-Fin Businesses";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_business_cg_fa TO "Financial Growth: Monthly Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_business_cg_fa TO "Financial Growth: 12-Month Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_total_excfin_businss_cg_fa TO "Financial Growth: Monthly Exc-Fin Businesses";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_total_excfin_businss_cg_fa TO "Financial Growth: 12-Month Exc-Fin Businesses";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_total_cg_fa TO "Financial Growth: Monthly Total Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_total_cg_fa TO "Financial Growth: 12-Month Total Credit";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_m3_cg_fa TO "Financial Growth: Monthly M3 Money";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_m3_cg_fa TO "Financial Growth: 12-Month M3 Money";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_broad_money_cg_fa TO "Financial Growth: Monthly Broad Money";

ALTER TABLE public.finance_statistics
RENAME COLUMN m12_broad_money_cg_fa TO "Financial Growth: 12-Month Broad Money";
--#####################################################
-- Credit & Financial Aggs
ALTER TABLE public.finance_statistics
RENAME COLUMN m_loans_advances_bank_excfin_lca TO "Credit Aggregate: Monthly Bank Loans Exc-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_loans_advances_bank_lca TO "Credit Aggregate: Monthly Bank Loans, Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_loans_advances_nbfi_excfin_lca TO "Credit Aggregate: Monthly NBFI Loans Exc-Fin Businesses";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_loans_advances_nbfi_lca TO "Credit Aggregate: Monthly NBFI Loans, Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_loans_advances_afi_excfin_lca TO "Credit Aggregate: Monthly AFI Loans & Advances Exc-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_loans_advances_afi_lca TO "Credit Aggregate: Monthly AFI Loans & Advances";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_nonfin_issue_bills_lca TO "Credit Aggregate: Monthly Bills on Issue to Non-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_issue_bills_lca TO "Credit Aggregate: Monthly Bills on Issue";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_narrow_c_excfin_lca TO "Credit Aggregate: Monthly Narrow Cred. Exc-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_narrow_c_excfin_lca TO "Credit Aggregate: Season-Adj Monthly Narrow Cred. Exc-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_narrow_c_lca TO "Credit Aggregate: Monthly Narrow Cred. Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_narrow_c_lca TO "Credit Aggregate: Season-Adj Monthly Narrow Cred. Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_total_c_excfin_lca TO "Credit Aggregate: Monthly Total Cred. Exc-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_total_c_excfin_lca TO "Credit Aggregate: Season-Adj Monthly Total Cr. Exc-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_total_c_lca TO "Credit Aggregate: Monthly Total";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_total_c_lca TO "Credit Aggregate: Season-Adj Monthly Total";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_owner_housing_lca TO "Credit Aggregate: Monthly Self-Occupied Housing";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_owner_housing_lca TO "Credit Aggregate: Season-Adj Monthly Self-Occupied Housing";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_investor_c_lca TO "Credit Aggregate: Monthly Investor Cred.";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_investor_c_lca TO "Credit Aggregate: Season-Adj Monthly Investor Cred.";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_personal_c_lca TO "Credit Aggregate: Monthly Personal Cred.";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_personal_c_lca TO "Credit Aggregate: Season-Adj Monthly Personal Cred.";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_nonfin_business_c_lca TO "Credit Aggregate: Monthly Non-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_nonfin_business_lca TO "Credit Aggregate: Season-Adj Monthly Non-Fin Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_business_lca TO "Credit Aggregate: Monthly Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN mseadj_business_lca TO "Credit Aggregate: Season-Adj Monthly Business";

ALTER TABLE public.finance_statistics
RENAME COLUMN m_govsector_lending_afi_lca TO "Credit Aggregate: Monthly Gov-Sector Lending";

