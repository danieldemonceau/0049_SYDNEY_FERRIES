# import requests
from google.transit import gtfs_realtime_pb2
import urllib2
import time
import psycopg2
import threading

hostname = '192.168.1.87'
username = 'themagiscian'
password = '***'
database = 'sydney_transport'

# Simple routine to run a query on a database and print the results:
def doQuery(conn, query):
    cur = conn.cursor()
    # cur.execute(query)
    cur.execute(query)
    cur.execute("""commit""")

try:
    connection = psycopg2.connect(host=hostname, user=username, password=password, dbname=database)
    feed = gtfs_realtime_pb2.FeedMessage()
    req = urllib2.Request('https://api.transport.nsw.gov.au/v1/gtfs/vehiclepos/ferries')
    req.add_header('Accept', 'application/x-google-protobuf')
    req.add_header('Authorization', 'apikey pbYQ6iUPa7IKvZioQ9O7mJ20117KRE65xe8p')
except e:
    print e

def getPositions():
    threading.Timer(10.0, getPositions).start()
    response = urllib2.urlopen(req)
    feed.ParseFromString(response.read())
    for entity in feed.entity:
        query = "INSERT INTO ferries_hist (entity_id, trip_id, vehicle_id, label, time_text, time_posix, latitude, longitude, bearing, speed) VALUES ('" + str(entity.id) + "', '" + str(entity.vehicle.trip.trip_id) + "', '" + str(entity.vehicle.vehicle.id) + "', '" + str(entity.vehicle.vehicle.label).replace("'", "''") + "', '" + str(time.ctime(int(entity.vehicle.timestamp))) + "', " + str(entity.vehicle.timestamp) + ", " + str(entity.vehicle.position.latitude) + ", "+str(entity.vehicle.position.longitude) + ", " + str(entity.vehicle.position.bearing) + ", " + str(entity.vehicle.position.speed) + ");"
        doQuery(connection, query)
        # doQuery(connection, "UPDATE ferries_hist SET geom = ST_SetSRID(ST_Point(longitude, latitude),4326) WHERE geom IS NULL;")

getPositions()
# connection.close()
