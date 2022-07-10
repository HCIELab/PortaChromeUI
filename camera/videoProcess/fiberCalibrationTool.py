# importing the required libraries

from xmlrpc.client import boolean
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import sys
import numpy as np
import cv2 as cv

class Window(QMainWindow):

    isObversed = True
    areaThreshold = 0.001
    curLED = 1
    findFirstLed = False
    startFrame = 0
    blinkingInterval = 0
    f = open("ledPos.txt", "a")

    def __init__(self):
        super().__init__()

        # set the title
        self.setWindowTitle("Fiber Calibration Tool")
        width = 1430
        height = 600
        # setting the fixed width of window
        self.setFixedWidth(width)
        self.setFixedHeight(height)
        # self.setStyleSheet("background-color: white;")

        # display window tile
        self.label = QLabel(self)
        self.label.move(50, 20)
        self.label.setText("Fiber Calibration Tool")
        self.label.setFont(QFont("SansSerif", 35))
        self.label.resize(self.label.sizeHint())

        # display obverse image
        self.ledImageObverse = QLabel(self)
        self.ledImageObverse.move(50, 100)
        self.ledImageObverse.resize(640, 360)
        pixmap = QPixmap('obverse.png')
        self.ledImageObverse.setPixmap(pixmap)

        # display reverse image
        self.ledImageReverse = QLabel(self)
        self.ledImageReverse.move(740, 100)
        self.ledImageReverse.resize(640, 360)
        pixmap1 = QPixmap('reverse.png')
        self.ledImageReverse.setPixmap(pixmap1)

        # select obverse/reverse button
        self.selectSideBtn = QPushButton("Select Obverse", self)
        self.selectSideBtn.move(50, 510)
        self.selectSideBtn.resize(300, 50)
        self.selectSideBtn.clicked.connect(self.changeSide)

        # import video button
        self.importBtn = QPushButton("Import Video", self)
        self.importBtn.move(350, 510)
        self.importBtn.resize(300, 50)
        self.importBtn.clicked.connect(self.selectAndProcess)

        # export data button
        self.exportBtn = QPushButton("Export Data", self)
        self.exportBtn.move(650, 510)
        self.exportBtn.resize(300, 50)
        self.exportBtn.clicked.connect(self.exportData)

        # label "threshold"
        self.thresholdLabel = QLabel(self)
        self.thresholdLabel.move(950, 520)
        self.thresholdLabel.setText("Detection\nThreshold")

        # label value of slider
        self.thresholdValue = QLabel(self)
        self.thresholdValue.move(1050, 520)
        self.thresholdValue.setText("10")

        # add a slider to control threshold value
        self.thresholdSlider = QSlider(Qt.Horizontal, self)
        self.thresholdSlider.move(1080, 510)
        self.thresholdSlider.setMinimum(0)
        self.thresholdSlider.setMaximum(50)
        self.thresholdSlider.setValue(10)
        self.thresholdSlider.setTickPosition(QSlider.TicksBelow)
        self.thresholdSlider.setTickInterval(10)
        self.thresholdSlider.resize(300, 50)
        self.thresholdSlider.valueChanged.connect(self.changeThreshold)

        # show all the widget
        self.show()

    # select and process video
    def selectAndProcess(self):
        fileName = self.selectVideo()
        self.findFirstLed = False
        
        self.curLED = 1
        print("curLED: ", self.curLED)
        resultImg = self.processVideo(fileName)
        height, width, channel = resultImg.shape
        bytesPerLine = 3 * width
        qImg = QImage(resultImg.data, width, height, bytesPerLine,
                      QImage.Format_RGB888).rgbSwapped()
        # scale the QImage
        qImg = qImg.scaled(640, 360, Qt.KeepAspectRatio)

        qImg.bits()
        img_pix = QPixmap.fromImage(qImg)
        if(self.isObversed):
            self.ledImageObverse.setPixmap(img_pix)
        else:
            self.ledImageReverse.setPixmap(img_pix)

    def exportData(self):
        return

    def changeSide(self):

        self.isObversed = not self.isObversed
        if(self.isObversed):
            # change button text to "Select Obversed"
            self.selectSideBtn.setText("Select Obverse")
        else:
            # change button text to "Select Reverse"
            self.selectSideBtn.setText("Select Reverse")

    def selectVideo(self):
        # fileName = QFileDialog.getOpenFileName(self, 'OpenFile')
        fileName = QFileDialog.getOpenFileName(
            self, "Open File", "/Users/kangyixiao/EchoFile/coding/fiber_GUI/camera/#scanning-samples")
        # split file name with '\''
        result = fileName[0]
        return result

    # check if the first led begin blinking


    def startCapture(self, thresh, curFrame):
        whiteAreaSize = sum(sum(thresh))
        whiteProportion = whiteAreaSize / (thresh.shape[0]*thresh.shape[1])
        if(whiteProportion >= self.areaThreshold):
            
            print("find first LED")
            self.startFrame = curFrame
            self.curLed = 1
            print("startFrame"+str(self.startFrame))
            return True
        else:
            return False


    def canCapture(self, curFrame):
        if curFrame - (self.curLED * self.blinkingInterval)-self.startFrame < 0.5 and curFrame - (self.curLED * self.blinkingInterval)-self.startFrame > - 0.5:
            self.curLED += 1
            print("curLED"+str(self.curLED))
            return True
        else:
            return False


    def findCenter(self, img, resultImg, curFrame, rgbResultImg):
        # convert image to grayscale image
        gray_image = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        # convert the grayscale image to binary image
        ret, thresh = cv.threshold(gray_image, 230, 255, 0)
        # calculate moments of binary image
        M = cv.moments(thresh)

        # calculate x,y coordinate of center
        try:
            cX = int(M["m10"] / M["m00"])
            cY = int(M["m01"] / M["m00"])
        except:
            return img, resultImg
        #  highlight the center

        if self.canCapture(curFrame) is True:
            # print("canCapture")
            #  highlight the center
            # self.f.write(str(cX) + " " + str(cY) + '\n')
            cv.circle(resultImg, (cX, cY), 5, (255, 255, 255), -1)
            cv.circle(rgbResultImg, (cX, cY), 5, (0, 0, 255), -1)
            # cv.imshow("Image", resultImg)
        return img, resultImg, rgbResultImg

    def processVideo(self, fileName):
        cap = cv.VideoCapture(fileName)
        # get total frame number
        totalFrame = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
        fps = cap.get(cv.CAP_PROP_FPS)
        print("fps: " + str(fps))
        self.blinkingInterval = fps*0.4
        self.findFirstLed = False
        print("blinking interval: " + str(self.blinkingInterval))

        # concatenate image Horizontally
        resultImgRGB = np.zeros((1920, 1080, 3), np.uint8)
        
        # while cap.isOpened():
        for curFrame in range(totalFrame):
            if(not cap.isOpened()):
                break
            ret, frame = cap.read()
            # if frame is read correctly ret is True
            if not ret:
                print("Can't receive frame (stream end?). Exiting ...")
                break

            if self.findFirstLed == False:
                gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
                resultImg = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
                # filter the image with a threshold
                ret, thresh = cv.threshold(gray, 230, 255, cv.THRESH_BINARY)
                self.findFirstLed = self.startCapture(thresh, curFrame)
                rgbResultImg = frame
                frame, resultImg,rgbResultImg = self.findCenter(frame, resultImg, curFrame,rgbResultImg)
            else:
                
                # show the image
                frame, resultImg,rgbResultImg = self.findCenter(frame, resultImg, curFrame,rgbResultImg)
        

        cap.release()
        # cv.destroyAllWindows()
        self.f.close()
        return rgbResultImg

    def changeThreshold(self):
        newVal = self.thresholdSlider.value()
        self.areaThreshold = newVal/10000
        # change threshold value to
        self.thresholdValue.setText(str(newVal))

# create pyqt5 app
App = QApplication(sys.argv)
# create the instance of our Window
window = Window()
# start the app
sys.exit(App.exec())
