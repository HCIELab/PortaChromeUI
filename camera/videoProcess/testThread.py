from xmlrpc.client import boolean
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import sys
import numpy as np
import cv2
import os

class ProcessWorker(QObject):
    imageChanged = pyqtSignal(QImage)
    
    def doWork(self):
        self.image_list = ['../#scanning-samples/BG.png','../#scanning-samples/test1.png']
        for f in self.image_list:
            img = cv2.imread(f)
            # img = cv2qimage(img, False)
            self.imageChanged.emit(img)
            QThread.msleep(1)

class Widget(QWidget):
    def __init__(self, parent=None):
        QWidget.__init__(self, parent)
        lay = QVBoxLayout(self)
        gv = QGraphicsView()
        lay.addWidget(gv)
        scene = QGraphicsScene(self)
        gv.setScene(scene)
        self.pixmap_item = QGraphicsPixmapItem()
        scene.addItem(self.pixmap_item)

        self.workerThread = QThread()
        self.worker = ProcessWorker()
        self.worker.moveToThread(self.workerThread)
        self.workerThread.finished.connect(self.worker.deleteLater)
        self.workerThread.started.connect(self.worker.doWork)
        self.worker.imageChanged.connect(self.setImage)
        self.workerThread.start()


    @pyqtSlot(QImage)
    def setImage(self, image):
        pixmap = QPixmap.fromImage(image)
        self.pixmap_item.setPixmap(pixmap)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    w = Widget()
    w.show()
    sys.exit(app.exec_())