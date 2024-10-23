-- Misc Scratch

-- DROP TABLE IF EXISTS  "temp_table_low_filled" CASCADE;
-- CREATE TABLE temp_table_low_filled  AS(
-- 	SELECT ROW_NUMBER() OVER (ORDER BY datetime_id DESC)::int AS "dt_id",*
-- 	FROM (SELECT * FROM temp_table_low WHERE datetime_id <103 ORDER BY "datetime_id" DESC)
-- 	ORDER BY "dt_id" ASC
-- 	);