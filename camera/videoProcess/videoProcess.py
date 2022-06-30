
import numpy as np
import cv2 as cv
# from datetime import datetime
import time

areaThreshold = 0.003
cap = cv.VideoCapture('../clips/IMG_1086.MOV')
blinkingInterval = 1000  # 1s

deltaInterval = 100

curBlinkLED = 0  # id of current Blink LED
start_time = int(round(time.time() * 1000))
firstLEDTime = start_time  # the time when first LED starts blinking
lastBlinkTime = start_time  # the time when last LED starts blinking
findFirstLed = False


# check if the first led begin blinking
def startCapture(thresh):
    global findFirstLed
    global lastBlinkTime
    global firstLEDTime
    
    whiteAreaSize = sum(sum(thresh))
    whiteProportion = whiteAreaSize / (thresh.shape[0]*thresh.shape[1])
    if(whiteProportion >= areaThreshold):
        firstLEDTime = int(round(time.time() * 1000)) - start_time
        lastBlinkTime = firstLEDTime
        print("find first LED, start time:"+str(firstLEDTime))
        return True
    else:
        return False


def canCapture():
    global lastBlinkTime
    global curBlinkLED
    if findFirstLed is False:
        return False
    else:
        timeAfterFirstBlink = int(round(time.time() * 1000)) - firstLEDTime - start_time
        if (timeAfterFirstBlink - lastBlinkTime) > blinkingInterval/2:
            # print("Blinking"+str(timeAfterFirstBlink))

            if(timeAfterFirstBlink > (curBlinkLED+1)*blinkingInterval - deltaInterval) and (timeAfterFirstBlink < (curBlinkLED+1)*blinkingInterval + deltaInterval):
                curBlinkLED += 1
                lastBlinkTime = timeAfterFirstBlink
                print("find"+str(curBlinkLED)+"LED, time:"+str(lastBlinkTime))
                return True
    return False

# find the center of the white area
def findCenter(img):
    # convert image to grayscale image
    gray_image = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

    # convert the grayscale image to binary image
    ret,thresh = cv.threshold(gray_image,230,255,0)

    # calculate moments of binary image
    M = cv.moments(thresh)

    # calculate x,y coordinate of center
    cX = int(M["m10"] / M["m00"])
    cY = int(M["m01"] / M["m00"])

    # put text and highlight the center
    cv.circle(img, (cX, cY), 20, (0, 0, 255), -1)
    cv.putText(img, "centroid", (cX - 25, cY - 25),cv.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
    cv.imshow("Image", img)


    
def main():
    global findFirstLed
    while cap.isOpened():
        ret, frame = cap.read()
        # if frame is read correctly ret is True
        if not ret:
            print("Can't receive frame (stream end?). Exiting ...")
            break

        if findFirstLed == False:
            gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            # filter the image with a threshold
            ret, thresh = cv.threshold(gray, 230, 255, cv.THRESH_BINARY)
            cv.imshow('frame', gray)
            findFirstLed = startCapture(thresh)
        else:
            if canCapture() is True:
                # show the image
                cv.imshow('frame', frame)
                findCenter(frame)
        if cv.waitKey(1) == ord('q'):
            break

    # every one second capture the image from the video stream

    cap.release()
    cv.destroyAllWindows()


main()
