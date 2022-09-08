# importing the required libraries

from xmlrpc.client import boolean
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import sys
import numpy as np
import cv2 as cv
import os


class Window(QMainWindow):

    isObversed = True
    areaThreshold = 0.001
    curLED = 1
    findFirstLed = False
    startFrame = 0
    blinkingInterval = 0

    # const for UI settings
    subWinWidth = 480  # 1920/4
    subWinHeight = 270

    # horizonal paddings
    leftPadding = 50
    # distance between two subwinows
    centralPadding1 = 50
    # distance betwwen right window and slider
    centralPadding2 = 50
    rightPadding = 50

    # vertical paddings
    topPadding = 100
    bottomPadding = 50
    centralPaddingHori = 30
    centralPaddingVertical = 50
    # button & slider setting
    btnHeight = 50
    # sliderWidth = 50
    # sliderTopPadding = 40
    # sliderHeight = subWinHeight - sliderTopPadding

    # export bgImage
    bgImage = None
    # bgImage path to be saved
    # f = open(
    #     "/Users/kangyixiao/EchoFile/coding/fiber_GUI/Fiber_GUI/fiber_GUI/ledPos.txt",
        # "w")
    ledPositions = ""
    ledPosText = "Fiber 1:\n"

    def __init__(self):
        super().__init__()

        # set the title
        self.setWindowTitle("ChromoFiber Calibration Tool")
        width = self.leftPadding + self.subWinWidth*2 + self.rightPadding + self.centralPaddingVertical 
        height = self.topPadding + self.subWinHeight + self.centralPaddingHori * 2 + self.btnHeight * 2 + self.bottomPadding

        # setting the fixed width of window
        self.setFixedWidth(width)
        self.setFixedHeight(height)
        # self.setStyleSheet("background-color: white;")

        # display window tile
        self.label = QLabel(self)
        self.label.move(self.leftPadding, 20)
        self.label.setText("ChromoFiber Calibration Tool")
        self.label.setFont(QFont("SansSerif", 25))
        self.label.resize(self.label.sizeHint())

        # # display obverse image
        self.ledImageFront = QLabel(self)
        self.ledImageFront.move(self.leftPadding, self.topPadding)
        self.ledImageFront.resize(self.subWinWidth, self.subWinHeight)
        pixmap = QPixmap('noVideo.png')
        self.ledImageFront.setPixmap(pixmap)

        # display back image
        # backImgX = self.leftPadding+ self.subWinWidth + self.centralPadding1
        # self.ledImageReverse = QLabel(self)
        # self.ledImageReverse.move(backImgX, self.topPadding)
        # self.ledImageReverse.resize(self.subWinWidth, self.subWinHeight)
        # pixmap1 = QPixmap('noVideo.png')
        # self.ledImageReverse.setPixmap(pixmap1)

        # select obverse/reverse button
        FrontBtnY = self.topPadding + self.subWinHeight + self.centralPaddingHori
        self.upLoadFrontBtn = QPushButton("Upload Scanned Video", self)
        self.upLoadFrontBtn.move(
            self.leftPadding,
            self.topPadding + self.subWinHeight + self.centralPaddingHori)
        self.upLoadFrontBtn.resize(self.subWinWidth, self.btnHeight)
        self.upLoadFrontBtn.clicked.connect(self.uploadFrontView)
        self.upLoadFrontBtn.setFont(QFont("SansSerif", 18))

        # export data button
        self.exportBtn = QPushButton("Extract LED Positions", self)
        self.exportBtn.move(
            self.leftPadding,
            FrontBtnY + self.btnHeight + self.centralPaddingHori)
        self.exportBtn.resize(self.subWinWidth, self.btnHeight)
        self.exportBtn.clicked.connect(self.exportData)
        self.exportBtn.setFont(QFont("SansSerif", 18))

        # text line edit fro led Positions
        self.ledPosLineEdit = QLineEdit(self)
        self.ledPosLineEdit.move(self.leftPadding+ self.subWinWidth+self.centralPaddingVertical, self.topPadding)
        self.ledPosLineEdit.resize(self.subWinWidth, self.subWinHeight + 2*self.btnHeight+ 2*self.centralPaddingHori)

        # text for led positions(I need a lable because text line don't have word wrapping, so everything is in one line)
        self.ledPosLabel = QLabel(self)
        self.ledPosLabel.move(self.leftPadding+ self.subWinWidth+self.centralPaddingVertical, self.topPadding)
        self.ledPosLabel.resize(self.subWinWidth, self.subWinHeight + 2*self.btnHeight+ 2*self.centralPaddingHori)
        self.ledPosLabel.setWordWrap(True)

        # show all the widget
        self.show()

    # upload front side
    def uploadFrontView(self):
        self.selectAndProcess(True)

    def uploadBackView(self):
        self.selectAndProcess(False)

    # select and process video
    def selectAndProcess(self, side):
        fileName = self.selectVideo()
        self.findFirstLed = False

        self.curLED = 0
        print("curLED: ", self.curLED)
        resultImg = self.processVideo(fileName)
        self.bgImage = resultImg
        height, width, channel = resultImg.shape
        bytesPerLine = 3 * width
        qImg = QImage(resultImg.data, width, height, bytesPerLine,
                      QImage.Format_RGB888).rgbSwapped()
        # scale the QImage
        qImg = qImg.scaled(640, 360, Qt.KeepAspectRatio)

        qImg.bits()
        img_pix = QPixmap.fromImage(qImg)
        if (side):
            self.ledImageFront.setPixmap(img_pix)
        else:
            self.ledImageReverse.setPixmap(img_pix)

        # set the textline edit the positions of leds
        if self.ledPositions != "":
            self.ledPosLabel.setText(self.ledPosText+'\n finish')


    def exportData(self):

        # Using cv2.imwrite() method
        # Saving the image
        try:
            options = QFileDialog.Options()
            options |= QFileDialog.DontUseNativeDialog
            bgImage_path, _ = QFileDialog.getSaveFileName(
                self,
                "Please specify the path for background image",
                "/Users/kangyixiao/EchoFile/coding/fiber_GUI/Fiber_GUI/fiber_GUI/images/bgImage.png",
                "All Files (*);;Image Files (*.png)",
                options=options)
            ledPos_path, _ = QFileDialog.getSaveFileName(
                self,
                "Please specify the path for background image",
                "/Users/kangyixiao/EchoFile/coding/fiber_GUI/Fiber_GUI/fiber_GUI/ledPos.txt",
                "All Files (*);;Text Files (*.txt)",
                options=options)
            if bgImage_path:
                print("bgImage_path:"+ bgImage_path)
            if self.bgImage is not None:
                print("bgImage is not None")
                cv.imwrite(bgImage_path, self.bgImage)
            if ledPos_path:
                print("ledPos_path:"+ ledPos_path)
            if self.ledPositions != "":
                outputFile = open(ledPos_path, 'w')
                outputFile.write(self.ledPositions)
                outputFile.close()
        except:
            print(
                "Export failed, please input a valid path for image(.png, .jpg)."
            )

        return

    def changeSide(self):

        self.isObversed = not self.isObversed
        if (self.isObversed):
            # change button text to "Select Obversed"
            self.upLoadFrontBtn.setText("Select Obverse")
        else:
            # change button text to "Select Reverse"
            self.upLoadFrontBtn.setText("Select Reverse")

    def selectVideo(self):
        # fileName = QFileDialog.getOpenFileName(self, 'OpenFile')
        fileName = QFileDialog.getOpenFileName(
            self, "Open File",
            "/Users/kangyixiao/EchoFile/coding/fiber_GUI/camera/#scanning-samples"
        )
        # split file name with '\''
        result = fileName[0]
        return result

    # check if the first led begin blinking

    def startCapture(self, thresh, curFrame):
        whiteAreaSize = sum(sum(thresh))
        whiteProportion = whiteAreaSize / (thresh.shape[0] * thresh.shape[1])
        if (whiteProportion >= self.areaThreshold):

            print("find first LED")
            self.startFrame = curFrame
            self.curLed = 0
            print("startFrame" + str(self.startFrame))
            return True
        else:
            return False

    def canCapture(self, curFrame):
        if curFrame - (self.curLED * self.blinkingInterval
                       ) - self.startFrame < 0.5 and curFrame - (
                           self.curLED *
                           self.blinkingInterval) - self.startFrame > -0.5:
            self.curLED += 1
            print("curLED" + str(self.curLED))
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
            self.ledPositions += str(cX) + "," + str(cY) + ';'
            self.ledPosText += "\tLED " + str(self.curLED) + ", X position: " + str(cX) + ",\t Y position:" + str(cY) + '\n'
            cv.circle(resultImg, (cX, cY), 10, (255, 255, 255), -1)
            cv.circle(rgbResultImg, (cX, cY), 10, (100, 100, 255), -1)
            # cv.imshow("Image", resultImg)
        return img, resultImg, rgbResultImg

    def processVideo(self, fileName):
        cap = cv.VideoCapture(fileName)
        # get total frame number
        totalFrame = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
        fps = cap.get(cv.CAP_PROP_FPS)
        print("fps: " + str(fps))
        self.blinkingInterval = fps * 0.4
        self.findFirstLed = False
        print("blinking interval: " + str(self.blinkingInterval))

        # concatenate image Horizontally
        resultImgRGB = np.zeros((1920, 1080, 3), np.uint8)

        # while cap.isOpened():
        for curFrame in range(totalFrame):
            if (not cap.isOpened()):
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
                frame, resultImg, rgbResultImg = self.findCenter(
                    frame, resultImg, curFrame, rgbResultImg)
            else:

                # show the image
                frame, resultImg, rgbResultImg = self.findCenter(
                    frame, resultImg, curFrame, rgbResultImg)

        cap.release()
        # cv.destroyAllWindows()
        
        return rgbResultImg

   

    # def changeThreshold(self):
    #     newVal = self.thresholdSlider.value()
    #     self.areaThreshold = newVal/10000
    #     # change threshold value to
    #     self.thresholdValue.setText(str(newVal))


# create pyqt5 app
App = QApplication(sys.argv)
# create the instance of our Window
window = Window()

# start the app
sys.exit(App. exec ())
