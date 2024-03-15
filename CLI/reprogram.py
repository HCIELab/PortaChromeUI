import sys
import numpy as np
import serial
import time
# import bluetooth
from scipy.optimize import minimize


RGB_SCALE = 255
CMYK_SCALE = 1
serial_port = "/dev/tty.usbserial-130"
baud_rate = 9600

# row 1: cyan; row 2: magenta; row 3: yellow
# col 1: red;  col 2: green  ; col 3: blue
# the total time to achieve total desaturation according to experiment
# unit: second
inf= 1000000
FULL_DEACTIVATION_TIME = [[250,125,400],[200,62,75],[1000,62,10]]

# note that we don't have a k value because our dye is only cmy
def rgb_to_cmyk(r, g, b):
    # rgb [0,255] -> cmy [0,1]
    c = 1 - r / RGB_SCALE
    m = 1 - g / RGB_SCALE
    y = 1 - b / RGB_SCALE

    return c * CMYK_SCALE, m * CMYK_SCALE, y * CMYK_SCALE

# convert cmyk to rgb color
def cmyk_to_rgb(c,m,y,k=0):
    r = RGB_SCALE*(1-c)*(1-k)
    g = RGB_SCALE*(1-m)*(1-k)
    b = RGB_SCALE*(1-y)*(1-k)
    return int(r), int(g), int(b)


# Pure Cyan: RGB(182,168, 249) 
# Pure Magenta:RGB(237, 117,140)
# Pure Yellow: RBG(250, 223, 87)
def standardCMY_to_ourCMY(c,m,y,k=0):
    pureCyan = (0.75,0.25,0)
    pureMagenta = (0.25, 0.75, 0)
    pureYellow = (0,0,1)

    resC = c*pureCyan[0] + m*pureMagenta[0] + y*pureYellow[0]
    resM = c*pureCyan[1] + m*pureMagenta[1] + y*pureYellow[1]
    resY = c*pureCyan[2] + m*pureMagenta[2] + y*pureYellow[2]
    return resC, resM, resY

# used to find the optmized time to desaturate photochormic dye into a target color 
class Deactivation:
    debug = False

    def __init__(self, debug=False):
        deactivation_speed = []
        for i in range(3):
            row = []
            for j in range(3):
                row.append(1 / FULL_DEACTIVATION_TIME[i][j]  )
            deactivation_speed.append(row)
        self.deactivation_speed = np.array(deactivation_speed)


    def compute_deactivation_time(self,
                                  target_color,
                                  bound = None,
                                  original_color=[1, 1, 1]  # our default is to saturate all dye to the full level 
                                  ):
        color_to_deactivate = np.array(original_color) - np.array(target_color)
        
        A = self.deactivation_speed
        b = color_to_deactivate

        def objective(x):
            desaturation_level = np.minimum(np.dot(A, x), 1)
            color_difference = (np.linalg.norm(desaturation_level - b))**2
            time = np.max(x)
            return 5000 * color_difference + time


        # Perform optimization with constraints 
        # about the longest time they are supposed to shine for 
        bounds = [(0, None)] * 3
        if bound:
            bounds = [(0, bound)] * 3
        else:
            bounds = [(0, None)] * 3
        results = minimize(objective, [0,0,0], bounds=bounds)
        
        if results.success:
            deactivation_time = results.x
            realColor = np.maximum(original_color - A.dot(deactivation_time), 0)
            # print("bound:"+str(bound)+str(bounds))
            # print("inputColor(CMY):"+str(target_color))
            # print("b:"+str(b))
            # print("realColor (CMY):"+str(realColor))
            # print("deactivation_time:"+str(deactivation_time) + "\n")

            return deactivation_time, realColor
        else:
            print("Optimization failed")
            exit("Optimization failed")
            return None, None
    



def main():
    # parse the txt file that contains the color array
    # if you didn't input one, then it will default to color_array.txt
    filename =  sys.argv[1] if len(sys.argv) >= 2 else "color_array.txt"
    bound =  sys.argv[2] if len(sys.argv) >= 3 else "3600" # sets the worst case to an hour if the user doesn't input anything

    # read colors of leds sent by processing
    fread = open(filename,"r")
    target_colors = fread.read().split("#")
    fread.close()

    # keep track of the color changing time overall (max over all pixels)
    max_color_changing_time = 0
    desaturation_string = f"v#"
    display_string = f"d#"

    # calculate the desaturations one by one
    for i in range(len(target_colors)-1):
        color = target_colors[i].split(',')
        c,m,y = rgb_to_cmyk(int(color[0]),int(color[1]),int(color[2]))

        d = Deactivation();
        desaturation_time, result_CMY = d.compute_deactivation_time([c,m,y], bound = int(bound))
        
        # the calculated color is in standard CMY dye, now we convert to our dye
        # and then convert them back to RGB so that it can be previewed 
        result_CMY_converted = standardCMY_to_ourCMY(result_CMY[0],result_CMY[1],result_CMY[2]) 
        realR, realG, realB = cmyk_to_rgb(result_CMY_converted[0],result_CMY_converted[1],result_CMY_converted[2])

        # compute the time needed for the RGB light
        rTime = int(desaturation_time[0])
        gTime = int(desaturation_time[1])
        bTime = int(desaturation_time[2])
        
        # HOT FIX
        # if (i < 108):
        #     rTime *= 1.2
        #     gTime *= 1.2
        #     bTime *= 1.2


        display_string += f"{color[0]},{color[1]},{color[2]}#"
        desaturation_string += f"{rTime},{gTime},{bTime}#"

        max_color_changing_time = max(max_color_changing_time, rTime, gTime, bTime)
        

    # Sending over the color changing time and preview color
    # data_to_send = "d#0,0,255#0,0,255#*v#3,2,1#,2,2,0#*"
    data_to_send = f"{display_string}*{desaturation_string}*"

    try:
        # Open the serial port
        with serial.Serial(serial_port, baud_rate, timeout=10) as ser:
            # Encode the string to bytes and send it over serial
            ser.write(bytes(data_to_send, "utf-8"))
            
            
            # Wait for a response (optional)
            time.sleep(2)  # Adjust the sleep time as necessary
            while ser.in_waiting:
                print("Received:", ser.readline().decode().strip())
                
    except serial.SerialException as e:
        print(f"Error opening serial port: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

    

if __name__ == "__main__":
    main()

