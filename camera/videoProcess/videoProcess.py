
import numpy as np
import cv2 as cv
# from datetime import datetime


areaThreshold = 0.0005
cap = cv.VideoCapture('../#scanning-samples/test4mov')
# get total frame number
totalFrame = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
fps = cap.get(cv.CAP_PROP_FPS)
# fps = 60
print("fps: " + str(fps))
blinkingInterval = fps*0.4
print("blinking interval: " + str(blinkingInterval))
deltaInterval = 100
curLED = 1
findFirstLed = False
startFrame = 0
f = open("ledPos.txt", "a")

# check if the first led begin blinking


def startCapture(thresh, curFrame):
    global findFirstLed
    global lastBlinkTime
    global firstLEDTime
    global startFrame
    whiteAreaSize = sum(sum(thresh))
    whiteProportion = whiteAreaSize / (thresh.shape[0]*thresh.shape[1])
    print("whiteProportion"+str(whiteProportion))
    if(whiteProportion >= areaThreshold):
        # firstLEDTime = int(round(time.time() * 1000)) - start_time
        # lastBlinkTime = firstLEDTime
        print("find first LED")
        startFrame = curFrame
        print("startFrame"+str(startFrame))
        return True
    else:
        return False


def canCapture(curFrame):
    global curLED
   
    if curFrame - (curLED * blinkingInterval)-startFrame < 0.5 and curFrame - (curLED * blinkingInterval)-startFrame > - 0.5:
        print("curLED"+str(curLED))
        print(curFrame - (curLED * blinkingInterval)-startFrame)
        curLED += 1

        return True
    else:
        return False


def findCenter(img, resultImg, curFrame):
    # convert image to grayscale image
    gray_image = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    # convert the grayscale image to binary image
    ret, thresh = cv.threshold(gray_image, 230, 255, 0)
    # calculate moments of binary image
    M = cv.moments(thresh)

    # calculate x,y coordinate of center
    cX = int(M["m10"] / M["m00"])
    cY = int(M["m01"] / M["m00"])

    #  highlight the center
    cv.circle(img, (cX, cY), 5, (0, 0, 255), -1)
    cv.imshow("img", img)
    # cv.putText(img, "centroid", (cX - 25, cY - 25),
    #            cv.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
    if canCapture(curFrame) is True:
        print("canCapture")
        #  highlight the center
        f.write(str(cX) + " " + str(cY) + '\n')
        cv.circle(resultImg, (cX, cY), 5, (255, 255, 255), -1)
        # cv.imshow("Image", resultImg)
    return img, resultImg


def findMaxLightArea(img):
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    # find contours of all the components and holes
    gray_temp = gray.copy()  # copy the gray image because function
    # findContours will change the imput image into another
    contours, hierarchy = cv.findContours(
        gray_temp, cv.RETR_TREE, cv.CHAIN_APPROX_NONE)

    # find the area of all the contours and fill it with 0 expect the largest contour
    area = []
    for i in range(len(contours)):
        area.append(cv.contourArea(contours[i]))
    max_idx = np.argmax(area)
    # for i in range(len(contours)):
    #     if(i == max_idx):
    #         continue
    #     cv.fillConvexPoly(gray, contours[i], 0)
    cv.fillConvexPoly(gray, contours[max_idx], 0)
    cv.imshow("gray", gray)
    return gray

def main():

    global findFirstLed

    # concatenate image Horizontally
    resultImgRGB = np.zeros((1920, 1080, 3), np.uint8)
    curLED = 0
    # while cap.isOpened():
    for curFrame in range(totalFrame):

        ret, frame = cap.read()

        # if frame is read correctly ret is True
        if not ret:
            print("Can't receive frame (stream end?). Exiting ...")
            break

        if findFirstLed == False:
            gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            resultImg = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            # filter the image with a threshold
            
            ret, thresh = cv.threshold(resultImg, 230, 255, cv.THRESH_BINARY)
            # resultImg = findMaxLightArea(resultImg)
            # cv.imshow('thresh', thresh)
            findFirstLed = startCapture(thresh, curFrame)
        else:

            # show the image
            frame, resultImg = findCenter(frame, resultImg, curFrame)
            resultImgRGB = cv.cvtColor(resultImg, cv.COLOR_GRAY2RGB)

        # Hori = np.concatenate((frame, resultImgRGB), axis=1)
        # # btnImg = np.zeros((300, 2160, 3), np.uint8)
        # btnImg = cv.imread('button.png')
        # Hori2 = np.concatenate((Hori, btnImg), axis=0)
        # cv.imshow('HORIZONTAL', Hori2)
        if cv.waitKey(1) == ord('q'):
            break

    cap.release()
    cv.destroyAllWindows()
    f.close()


main()
