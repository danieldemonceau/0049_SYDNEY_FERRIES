DROP FUNCTION createGistIndex(VARCHAR);
CREATE OR REPLACE FUNCTION createGistIndex(table2Index VARCHAR)
RETURNS void
LANGUAGE plpgsql
AS $BODY$
DECLARE
  t2i varchar := replace(table2Index, '"', '');
BEGIN
  EXECUTE 'DROP INDEX IF EXISTS ' || t2i || '_gix;';
  EXECUTE 'CREATE INDEX ' || t2i || '_gix ON ' || t2i || ' USING GIST (geom);';
END
$BODY$;
