CREATE PROCEDURE Frontfill_Column(a1 integer,b2 real, tablename varchar)
LANGUAGE 'plpgsql'
AS
BEGIN
-- Execute
DROP TABLE IF EXISTS  "temp_table" CASCADE;
-- Temp_Table
CREATE TABLE temp_table
AS SELECT a1,
COALESCE( b2, 
FIRST_VALUE(b2) OVER(
PARTITION BY generic_group ORDER BY "a1" ASC)) AS data_filled
FROM (
SELECT a1, b2,
COUNT(b2) OVER (ORDER BY a1 ASC) AS generic_group
FROM tablename 
ORDER BY
a1 ASC);
--Update Funct.
UPDATE tablename
SET b2 = public.temp_table.data_filled
FROM public.temp_table
 WHERE (tablename.a1 = temp_table.a1)
 AND tablename.b2 IS NULL;
DROP TABLE IF EXISTS "temp_table" CASCADE;
COMMIT;
END;
$$;