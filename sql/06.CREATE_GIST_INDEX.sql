DELETE FROM ferries_hist
WHERE id IN (SELECT id
              FROM (SELECT id,
                             ROW_NUMBER() OVER (partition BY entity_id ORDER BY id) AS rnum
                     FROM ferries_hist) t
              WHERE t.rnum > 1);
DROP INDEX ferries_gix;
CREATE INDEX ferries_gix ON ferries_hist USING GIST (geom);
VACUUM ANALYZE ferries_hist;
