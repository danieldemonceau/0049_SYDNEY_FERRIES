DROP TRIGGER setgeom_trigger ON ferries_hist;
DROP TRIGGER setgeom_trigger ON ferries;
DROP FUNCTION setgeom();
CREATE OR REPLACE FUNCTION setgeom()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $BODY$
BEGIN
	EXECUTE 'UPDATE ' || TG_TABLE_NAME || ' SET geom = ST_SetSRID(ST_Point(longitude, latitude), 4326) WHERE geom IS NULL';
	RETURN NEW;
END
$BODY$;

CREATE TRIGGER setgeom_trigger
AFTER INSERT
ON ferries_hist
FOR EACH ROW
EXECUTE PROCEDURE setgeom();

CREATE TRIGGER setgeom_trigger
AFTER INSERT
ON ferries
FOR EACH ROW
EXECUTE PROCEDURE setgeom();
