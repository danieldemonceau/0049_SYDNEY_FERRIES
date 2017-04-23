DROP VIEW ferries_view;
CREATE VIEW ferries_view AS
SELECT label "boat", time_text "time",
ROUND(cast(bearing AS numeric), 2) bearing,
ROUND(cast(speed AS numeric), 2) speed, geom
FROM ferries;
