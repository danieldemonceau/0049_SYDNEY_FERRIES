DROP TABLE ferries_hist;
CREATE TABLE ferries_hist (
  id serial NOT NULL PRIMARY KEY,
  entity_id varchar(36) NOT NULL ,
  trip_id varchar(10),
  vehicle_id varchar(4) NOT NULL ,
  label varchar(20) NOT NULL ,
  time_text varchar(24),
  time_posix integer,
  latitude double precision,
  longitude double precision,
  bearing double precision,
  speed double precision,
  geom geometry(Point, 4326)
);
