

CREATE OR REPLACE FUNCTION fill_column_fin(dt_id int, col_val real)
RETURNS table(idv int, col real)
AS $$

SELECT dt_id, COALESCE( col_val, FIRST_VALUE(col_val) OVER(PARTITION BY generic_group ORDER BY dt_id ASC)) AS col_val
	FROM (SELECT dt_id, col_val, COUNT(col_val) OVER (ORDER BY dt_id ASC) AS generic_group 
		  FROM public.financial_aggregates_refactor
		  	ORDER BY dt_id ASC);
$$ LANGUAGE SQL;

-- CREATE TABLE temp_table
-- AS SELECT dt_id,
-- COALESCE(col_val, 
-- FIRST_VALUE(col_val) OVER(
-- PARTITION BY generic_group ORDER BY datetime_id ASC)) AS data_filled
-- FROM (
-- SELECT dt_id, col_val,
-- COUNT(col_val) OVER (ORDER BY dt_id ASC) AS generic_group
-- FROM table_core
-- ORDER BY
-- dt_id ASC);

-- UPDATE public.brisbane_clean_data
-- SET
-- "carbon_monoxide_(ppm)" = public.temp_table.data_filled
-- FROM
-- public.temp_table
-- WHERE
-- (public.brisbane_clean_data.datetime_id = temp_table.datetime_id);
--## Checker
-- SELECT datetime_id,"carbon_monoxide_(ppm)"
-- FROM public.brisbane_clean_data
-- WHERE "carbon_monoxide_(ppm)" IS NULL
--  OR brisbane_clean_data.datetime_id IN(6200,6201,6202,6203,6468,6469,6470)
-- ORDER BY datetime_id ASC;