DROP FUNCTION set_geom();
CREATE OR REPLACE FUNCTION set_geom()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $BODY$
BEGIN
	UPDATE ferries_hist SET geom = ST_SetSRID(ST_Point(longitude, latitude),4326) WHERE geom IS NULL;
	RETURN NEW;
END
$BODY$;

DROP TRIGGER set_geom_trigger ON ferries_hist;
CREATE TRIGGER set_geom_trigger
AFTER INSERT
ON ferries_hist
FOR EACH ROW
EXECUTE PROCEDURE set_geom();
