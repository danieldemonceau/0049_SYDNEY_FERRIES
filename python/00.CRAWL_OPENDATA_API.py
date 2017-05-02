# import requests
from google.transit import gtfs_realtime_pb2
from psycopg2 import sql
import urllib2
import time
import psycopg2
import threading


hostname = '192.168.1.87'
username = 'themagiscian'
password = ''
database = 'sydney_transport'

transport = 'ferries'

COUNT = 0

def doQuery(conn, query, data):
    cur = conn.cursor()
    cur.execute(query, data)
    if "INSERT INTO" not in cur.mogrify(query):
        print cur.mogrify(query)

try:
    connection = psycopg2.connect(host=hostname, user=username, password=password, dbname=database)
    feed = gtfs_realtime_pb2.FeedMessage()
    req = urllib2.Request('https://api.transport.nsw.gov.au/v1/gtfs/vehiclepos/' + transport)
    req.add_header('Accept', 'application/x-google-protobuf')
    req.add_header('Authorization', 'apikey ')
except e:
    print e

def getPositions():
    global COUNT
    threading.Timer(10.0, getPositions).start()
    response = urllib2.urlopen(req)
    feed.ParseFromString(response.read())
    doQuery(connection, """BEGIN""", None)
    for entity in feed.entity:
        query = "INSERT INTO {} (entity_id, trip_id, vehicle_id, label, time_text, time_posix, latitude, longitude, bearing, speed) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);"
        data = (str(entity.id), str(entity.vehicle.trip.trip_id), str(entity.vehicle.vehicle.id), str(entity.vehicle.vehicle.label), str(time.ctime(int(entity.vehicle.timestamp))), str(entity.vehicle.timestamp), str(entity.vehicle.position.latitude), str(entity.vehicle.position.longitude), str(entity.vehicle.position.bearing), str(entity.vehicle.position.speed))
        doQuery(connection, sql.SQL(query).format(sql.Identifier(transport)), data)
    doQuery(connection, "SELECT deleteduplicate();", None)
    doQuery(connection, sql.SQL("SELECT createGistIndex('{}');").format(sql.Identifier(transport)), None)
    if COUNT%50 == 0:
        doQuery(connection, sql.SQL("SELECT createGistIndex('{}');").format(sql.Identifier(transport + '_hist')), None)
        doQuery(connection, """COMMIT""", None)
        doQuery(connection, sql.SQL("VACUUM ANALYZE {};").format(sql.Identifier(transport + '_hist')), None)
    else:
        doQuery(connection, """COMMIT""", None)
    COUNT += 1

getPositions()
# connection.close()
