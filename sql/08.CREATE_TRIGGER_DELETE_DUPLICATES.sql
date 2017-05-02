DROP FUNCTION deleteduplicate();
CREATE OR REPLACE FUNCTION deleteduplicate()
RETURNS void
LANGUAGE plpgsql
AS $BODY$
DECLARE
   vid text;
BEGIN

  FOR vid IN SELECT DISTINCT vehicle_id FROM ferries
  LOOP
    RAISE NOTICE 'DELETE FROM ferries WHERE vehicle_id = % AND time_posix NOT IN (SELECT MAX(time_posix) FROM ferries WHERE vehicle_id = %)', vid, vid;
    EXECUTE 'DELETE FROM ferries WHERE vehicle_id = ''' || vid || ''' AND time_posix NOT IN (SELECT MAX(time_posix) FROM ferries WHERE vehicle_id = ''' || vid || ''')';
  END LOOP;

  DELETE FROM ferries
  WHERE id NOT IN (
    SELECT MAX(f.id)
    FROM ferries As f
    GROUP BY f.vehicle_id, f.time_posix
  );

  DELETE FROM ferries_hist
  WHERE id NOT IN (
    SELECT MAX(f.id)
    FROM ferries_hist As f
    GROUP BY f.vehicle_id, f.time_posix
  );
END
$BODY$;
