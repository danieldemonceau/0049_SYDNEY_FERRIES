DROP VIEW ferries;
CREATE VIEW ferries AS 
SELECT DISTINCT ON (vehicle_id) entity_id, label, time_posix, time_text, bearing, speed, geom FROM ferries_hist ORDER BY vehicle_id, time_posix DESC;
