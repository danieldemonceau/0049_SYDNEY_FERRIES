DROP TABLE lines;
CREATE TABLE lines AS 
SELECT fh.vehicle_id, fh.label, ST_LineToCurve(ST_MakeLine(fh.geom ORDER BY time_posix)) geom FROM ferries_hist fh GROUP BY fh.vehicle_id, fh.label;
-- DROP INDEX lines_gix;
CREATE INDEX lines_gix ON lines USING GIST (geom);
VACUUM ANALYZE lines;
