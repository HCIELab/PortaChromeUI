import numpy as np
import cv2 as cv
import cvui

WINDOW_NAME = 'CVUI Test'

cvui.init(WINDOW_NAME)
mainWin = np.zeros((600, 800, 3), np.uint8)
cv.mat  = cv.imread("test.png")

while True:
    mainWin[:] = (209, 52, 49)
    cvui.text(mainWin, 10, 15, 'Hello world!')
    cvui.button(mainWin, 110, 80, "Hello, world!")
    img.copyto(mainWin)
    # Update cvui internal stuff
    cvui.update()

    # Show window content
    cv.imshow(WINDOW_NAME, mainWin)

    if cv.waitKey(1) == ord('q'):
            break