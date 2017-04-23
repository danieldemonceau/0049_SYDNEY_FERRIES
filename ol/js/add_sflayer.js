var osmLayer = new ol.layer.Tile({
  source: new ol.source.OSM()
});

var params_lines = {'LAYERS': 'sydney_ferries:lines'}
var wmsSource_lines = new ol.source.TileWMS({
  url: 'http://jupiter:8080/geoserver/sydney_ferries/wms',
  params: params_lines
})

var wmsLayer_lines = new ol.layer.Tile({
  source: wmsSource_lines
});

var params_ferries = {'LAYERS': 'sydney_ferries:ferries'}
var wmsSource_ferries = new ol.source.TileWMS({
  url: 'http://jupiter:8080/geoserver/sydney_ferries/wms',
  params: params_ferries
})

var wmsLayer_ferries = new ol.layer.Tile({
  source: wmsSource_ferries
});

var view = new ol.View({
  center: ol.proj.fromLonLat([151.215256, -33.856159]),
  zoom: 15
})

var container = document.getElementById('popup');
var content = document.getElementById('popup-content');
var closer = document.getElementById('popup-closer');

closer.onclick = function() {
  overlay.setPosition(undefined);
  closer.blur();
  return false;
};

var overlay = new ol.Overlay(({
  element: container,
  autoPan: true,
  autoPanAnimation: {
    duration: 250
  }
}));

var map = new ol.Map({
  overlays: [overlay],
  target: 'map',
  layers: [osmLayer/*, wmsLayer_lines*/, wmsLayer_ferries],
  view: view
});

map.on('singleclick', function(evt) {
  document.getElementById('info').innerHTML = '';
  var viewResolution = /** @type {number} */ (view.getResolution());
  var coordinate = evt.coordinate;
  var hdms = ol.coordinate.toStringHDMS(coordinate);
  var url = wmsSource_ferries.getGetFeatureInfoUrl(
    coordinate, viewResolution, 'EPSG:3857',
    {'INFO_FORMAT': 'text/html',
    'propertyName': 'boat,time,bearing,speed'});
    if (url) {
      // content.innerHTML = '<p>' + url + '</p>';
      content.innerHTML = '<iframe seamless width="450px" height="125px" border-width="0px" border-radius:"200px" seamless src="' + url + '"></iframe>';
      // content.innerHTML = url;
      overlay.setPosition(coordinate);
    }
  });

var refreshLayer = function(){
  wmsSource_ferries.updateParams({"time": Date.now()});
  // wmsSource.refresh();
  updateTimer = setTimeout(function() {
    refreshLayer();
  }, 5000);
}

refreshLayer();
