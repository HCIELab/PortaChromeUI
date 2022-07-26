# importing the required libraries

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import sys
import numpy as np
import cv2 as cv


class Window(QMainWindow):
    topPadding = 100
    leftPadding = 100
    rightPadding = 100
    bottomPadding = 10
    fiberHeight = 100
    fiberWidth = 900
    textHeight = 20
    titleHeight = 35
    centralPaddingHori = 100
    centralPaddingVert = 30
    def __init__(self):
        super().__init__()

        # set the title
        self.setWindowTitle("Color Gradient Viewer")
        self.height = self.topPadding + self.fiberHeight + 2* self.centralPaddingVert + self.textHeight*2 + self.titleHeight + self.bottomPadding
        self.width = self.leftPadding + self.fiberWidth + self.rightPadding
        # setting the fixed width of window
        self.setFixedWidth(self.width)
        self.setFixedHeight(self.height)
        # self.setStyleSheet("background-color: white;")

        # display window tile
        self.title = QLabel(self)
        self.title.move(self.leftPadding, 20)
        self.title.setText("Color Gradient Viewer")
        self.title.setFont(QFont("SansSerif", 35))
        self.title.resize(self.title.sizeHint())

        # draw fiber background

        self.fiber = QLabel(self)
        self.fiber.move(self.leftPadding, self.rightPadding)
        self.fiber.resize(self.fiberWidth, self.fiberHeight)
        pixmap1 = QPixmap('fiber.png')
        self.fiber.setPixmap(pixmap1)

        # draw text :led number
        self.ledNumText = QLabel(self)
        self.ledNumText.move(self.leftPadding, self.topPadding+self.fiberHeight+self.centralPaddingVert)
        self.ledNumText.setText("LED Number:")
        self.ledNumText.setFont(QFont("SansSerif", 20))
        self.ledNumText.resize(self.ledNumText.sizeHint())

        self.ledNum = QLineEdit(self)
        self.ledNum.move(self.leftPadding+self.ledNumText.width()+10, self.topPadding+self.fiberHeight+self.centralPaddingVert)
        self.ledNum.setValidator(QIntValidator())

        # draw text :led distance
        self.ledDistanceText = QLabel(self)
        self.ledDistanceText.move(self.leftPadding, self.topPadding+self.fiberHeight+2*self.centralPaddingVert+self.ledNumText.height())
        self.ledDistanceText.setText("LED Distance:")
        self.ledDistanceText.setFont(QFont("SansSerif", 20))
        self.ledDistanceText.resize(self.ledDistanceText.sizeHint())

        self.ledDistance = QLineEdit(self)
        self.ledDistance.move(self.leftPadding+self.ledDistanceText.width()+10, self.topPadding+self.fiberHeight+2*self.centralPaddingVert+self.ledNumText.height())
        self.ledDistance.setValidator(QIntValidator())

        # draw text :set No.x LED
        self.setNumText = QLabel(self)
        ithX = self.leftPadding+self.ledDistanceText.width()+ 10 + self.ledDistance.width() + self.centralPaddingHori
        ithY = self.topPadding+self.fiberHeight+self.centralPaddingVert
        self.setNumText.move(ithX, ithY)
        self.setNumText.setText("Set No.          LED:")
        self.setNumText.setFont(QFont("SansSerif", 20))
        self.setNumText.resize(self.setNumText.sizeHint())

        # draw current set id
        self.curSetId = QLineEdit(self)
        self.curSetId.move(ithX+ 80, ithY)
        self.curSetId.setValidator(QIntValidator())
        # set mask text as 1
        self.curSetId.setInputMask("1")
        self.curSetId.resize(self.curSetId.sizeHint())
        self.curSetId.resize(20, self.curSetId.height())

        # draw text : "R:     s" 
        self.redText = QLabel(self)
        self.redText.move(ithX, ithY+self.curSetId.height()+self.centralPaddingVert)
        self.redText.setText("R:           s")
        self.redText.setFont(QFont("SansSerif", 20))
        self.redText.resize(self.redText.sizeHint())

        # draw current red value
        self.curRed = QLineEdit(self)
        self.curRed.move(ithX+30, ithY+self.curSetId.height()+self.centralPaddingVert)
        self.curRed.setValidator(QIntValidator())
        self.curRed.setInputMask("30")
        self.curRed.resize(self.curRed.sizeHint())
        self.curRed.resize(30, self.curRed.height())

        # draw text : "G:     s"
        self.greenText = QLabel(self)
        self.greenText.move(ithX+ self.centralPaddingHori, ithY+self.curSetId.height()+self.centralPaddingVert)
        self.greenText.setText("G:           s")
        self.greenText.setFont(QFont("SansSerif", 20))
        self.greenText.resize(self.greenText.sizeHint())

        # draw current green value
        self.curGreen = QLineEdit(self)
        self.curGreen.move(ithX+40+self.centralPaddingHori, ithY+self.curSetId.height()+self.centralPaddingVert)
        self.curGreen.setValidator(QIntValidator())
        self.curGreen.setInputMask("30")
        self.curGreen.resize(self.curGreen.sizeHint())
        self.curGreen.resize(30, self.curGreen.height())

        # draw text : "B:     s"
        self.blueText = QLabel(self)
        self.blueText.move(ithX + self.centralPaddingHori*2, ithY+self.curSetId.height()+self.centralPaddingVert)
        self.blueText.setText("B:           s")
        self.blueText.setFont(QFont("SansSerif", 20))
        self.blueText.resize(self.blueText.sizeHint())

        # draw current blue value
        self.curBlue = QLineEdit(self)
        self.curBlue.move(ithX+40+self.centralPaddingHori*2, ithY+self.curSetId.height()+self.centralPaddingVert)
        self.curBlue.setValidator(QIntValidator())
        self.curBlue.setInputMask("30")
        self.curBlue.resize(self.curBlue.sizeHint())
        self.curBlue.resize(30, self.curBlue.height())




        # e1 = QLineEdit()
        # e1.setValidator(QIntValidator())
        # e1.setMaxLength(4)
        # e1.setAlignment(Qt.AlignRight)
        # e1.setFont(QFont("Arial",20))


        self.show()




# create pyqt5 app
App = QApplication(sys.argv)
# create the instance of our Window
window = Window()
# start the app
sys.exit(App.exec())
