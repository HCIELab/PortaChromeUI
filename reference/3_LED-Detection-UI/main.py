# import the opencv library
import cv2
import serial
import time
# define a video capture object
import numpy as np


###################################
# PARAMETERS
VIDEO_ID = 0  # change this between 0 and 1 (maybe 2) until the correct camera comes up
ARDUINO_SERIAL_PORT_NAME = 'COM7'  # change this to the Arduino serial port name
ATTEMPTS = 50  # number of attempts the camera has to find the lights before it moves on to the next group
VERBOSE = True  # set to true if you want debugging statements
THRESHOLD = 150  # change this to raise/lower detection threshold for light. Max val is 255

###################################

def color(col):
    output = [0, 0, 0]
    onindex = np.argmax(col)
    output[onindex] = 1
    for i in range(0, 3):
        if i != onindex:
            if col[onindex] - col[i] < col[onindex] / 2.5:
                output[i] = 1
    return color_to_idx(output)


def color_to_idx(col):
    if col[0] and col[1] and col[2]:
        return 6
    if col[0] and ~col[1] and col[2]:
        return 5
    if col[0] and col[1] and ~col[2]:
        return 4
    if ~col[0] and col[1] and col[2]:
        return 3
    if ~col[0] and ~col[1] and col[2]:
        return 2
    if ~col[0] and col[1] and ~col[2]:
        return 1
    return 0


def write_read(x):
    arduino.write(bytes(str(x), "utf-8"))


def string_list_generate(start, end):
    out = ""
    for i in range(start, end):
        out += str(i) + ""
    return out


def locate_leds(target_led_count):
    ret, colframe = vid.read()
    colframe[55, 222] = (0, 0, 0)
    colframe[55, 223] = (0, 0, 0)
    colframe[55, 224] = (0, 0, 0)
    frame = cv2.cvtColor(colframe, cv2.COLOR_BGR2GRAY)
    threshval, binary = cv2.threshold(frame, THRESHOLD, 255, cv2.THRESH_BINARY)
    largekernel = np.ones((binary.shape[1] // 130, binary.shape[1] // 130), np.uint8)
    smallkernel = np.ones((binary.shape[1] // 200, binary.shape[1] // 200), np.uint8)
    dilbinary = cv2.dilate(binary, largekernel)
    halos = cv2.bitwise_xor(dilbinary, binary)
    halos = cv2.dilate(halos, smallkernel)
    binary = halos
    threshmask = cv2.cvtColor(binary, cv2.COLOR_GRAY2BGR)
    maskframe = cv2.bitwise_and(colframe, threshmask)
    contours, hierarchy = cv2.findContours(dilbinary, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    output = [None for _ in range(target_led_count)]
    if True:  # len(contours) == target_led_count:
        for c in range(len(contours)):
            singlemask = np.zeros(binary.shape, np.uint8)
            cv2.drawContours(singlemask, contours, c, (255, 255, 255), -1)
            singlemask = cv2.bitwise_and(halos, singlemask)
            mean = cv2.mean(colframe, mask=singlemask)
            M = cv2.moments(contours[c])
            try:
                cx = int(M['m10'] / M['m00'])
                cy = int(M['m01'] / M['m00'])
                mean = [round(c) for c in mean]
                colorid = color(mean)
                maskframe = cv2.putText(maskframe, str(colorid), (cx, cy), 0, 0.3, (0, 255, 0), 1)
                output[colorid] = (cx, cy)
            except:
                pass
    cv2.imshow('halos', halos)
    cv2.imshow('frame', maskframe)
    cv2.imshow('original', colframe)
    cv2.waitKey(1)
    return output
    # Display the resulting frame


vid = cv2.VideoCapture(VIDEO_ID)  # CHANGE THIS IF WEBCAM SELECTION IS WRONG
vid.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
vid.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
# ser = serial.Serial('/dev/ttyUSB0')
ct = 0
LEDct = 21
allcoords = output = [(0, 0) for _ in range(LEDct)]
# arduino = serial.Serial(port=ARDUINO_SERIAL_PORT_NAME, baudrate=9600)
time.sleep(2)
# debug
# write_read(0)
time.sleep(0.5)
ret, test = vid.read()
coordmap = np.zeros(test.shape, np.uint8)
while True:

    for indexed in range(0, LEDct, 7):  # search through LED string in groups of 7, indexed is first in the lined
        # send indexed to arduino so it knows where to start group of 7
        # debug
        # write_read(indexed)
        if VERBOSE:
            print(indexed)
        time.sleep(0.5)
        coords = [None]  # coordinates of each of the LEDs in group of 7
        attempts = 0  # how long the script has been searching for the set of all 7
        best = [None for _ in range(7)]  # the most complete set of coordinates for the group of 7
        while None in coords and attempts < ATTEMPTS:  # while there are missing coordinates and the script hasn't been
            # running too long
            attempts += 1
            if VERBOSE:
                print(coords)
            coords = locate_leds(min(LEDct - indexed, 7))
            if coords.count(None) < best.count(None):
                best = coords  # record the most complete set
        for i in range(len(coords)):
            # copy the most complete set to a master record with all LEDs (not just the 7 in the group)
            allcoords[i + indexed] = best[i]
    if VERBOSE:
        print(allcoords)
    # at this point the script's tried to locate all LEDs
    non_null = [i for i in range(LEDct) if allcoords[i] is not None]  # list of LED numbers with valid coordinates
    for idx in range(LEDct):
        if allcoords[idx] is None and len(non_null) > 0:  # if the LED has not been successfully mapped
            # locate LEDs with valid indices that are as close as possible to the missing LED
            non_null_l = list(filter(lambda k: k < idx, non_null))
            non_null_r = list(filter(lambda k: k > idx, non_null))
            if len(non_null_l) > 0 and len(non_null_r) > 0:
                left_idx = max(non_null_l)
                right_idx = min(non_null_r)
                # extrapolate the position of the missing LED based on which coordinates are closest
                allcoords[idx] = ((allcoords[left_idx][0] + allcoords[right_idx][0]) // 2,
                                  (allcoords[left_idx][1] + allcoords[right_idx][1]) // 2,)
    for led in range(LEDct):
        if allcoords[led] is not None:
            coordmap = cv2.putText(coordmap, str(led), (allcoords[led][0], allcoords[led][1]), 0, 0.4, (0, 255, 0), 1)
            coordmap = cv2.circle(coordmap, (allcoords[led][0], allcoords[led][1]), 2, (255, 255, 255), 1)
        cv2.imshow('detected', coordmap)
        cv2.waitKey(1)
        print(allcoords)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# After the loop release the cap object
vid.release()
# Destroy all the windows
cv2.destroyAllWindows()
