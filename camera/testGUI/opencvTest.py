import numpy as np
import cv2
import cvui

WINDOW_NAME = 'CVUI Test'

cvui.init(WINDOW_NAME)
frame = np.zeros((600, 800, 3), np.uint8)

while True:
    frame[:] = (49, 52, 49)
    cvui.text(frame, 10, 15, 'Hello world!')
    cvui.button(frame, 110, 80, "Hello, world!")
    # Update cvui internal stuff
    cvui.update()

    # Show window content
    cv2.imshow(WINDOW_NAME, frame)

    if cv2.waitKey(20) == 27:
        break