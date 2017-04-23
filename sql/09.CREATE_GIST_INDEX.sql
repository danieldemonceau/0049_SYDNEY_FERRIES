DROP INDEX ferries_gix;
CREATE INDEX ferries_gix ON ferries_hist USING GIST (geom);
VACUUM ANALYZE ferries_hist;
