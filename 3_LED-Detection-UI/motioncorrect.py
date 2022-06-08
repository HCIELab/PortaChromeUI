# import the opencv library
import cv2

# define a video capture object
import numpy as np
import serial as serial


vid = cv2.VideoCapture(1)
vid.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
vid.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
# ser = serial.Serial('/dev/ttyUSB0')
ct = 0
while (True):

    # Capture the video frame
    # by frame
    ret, colframe = vid.read()
    frame = cv2.cvtColor(colframe, cv2.COLOR_BGR2GRAY)
    threshval, binary = cv2.threshold(frame, 160, 255, cv2.THRESH_BINARY)
    largekernel = np.ones((binary.shape[1] // 100, binary.shape[1] // 100), np.uint8)
    smallkernel = np.ones((binary.shape[1] // 200, binary.shape[1] // 200), np.uint8)
    dilbinary = cv2.dilate(binary, smallkernel)

    cv2.imshow('original', colframe)
    # ser.write(str(ct))
    ct += 1
    # the 'q' button is set as the
    # quitting button you may use any
    # desired button of your choice
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# After the loop release the cap object
vid.release()
# Destroy all the windows
cv2.destroyAllWindows()
