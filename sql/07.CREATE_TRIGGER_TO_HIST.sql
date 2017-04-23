DROP TRIGGER sendtohist_trigger ON ferries;
DROP FUNCTION sendtohist();
CREATE OR REPLACE FUNCTION sendtohist()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $BODY$
DECLARE
  vid text;
BEGIN
  INSERT INTO ferries_hist (entity_id, trip_id, vehicle_id, label, time_text, time_posix, latitude, longitude, bearing, speed) VALUES (NEW.entity_id, NEW.trip_id, NEW.vehicle_id, NEW.label, NEW.time_text, NEW.time_posix, NEW.latitude, NEW.longitude, NEW.bearing, NEW.speed);

	RETURN NEW;
END
$BODY$;

CREATE TRIGGER sendtohist_trigger
AFTER INSERT
ON ferries
FOR EACH ROW
EXECUTE PROCEDURE sendtohist();
