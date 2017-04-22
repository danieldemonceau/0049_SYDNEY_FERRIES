from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *
from qgis.gui import *
from qgis.utils import iface
from PyQt4.QtCore import QTimer

timer = QTimer()

timer.setInterval(10000)
QObject.connect(timer, SIGNAL("timeout()"),
qgis.utils.iface.mapCanvas().refreshAllLayers)
timer.start()
