DROP VIEW ferries;
CREATE VIEW ferries AS 
SELECT DISTINCT ON (vehicle_id) time_posix, label, time_text, geom FROM ferries_hist ORDER BY vehicle_id, time_posix DESC;
