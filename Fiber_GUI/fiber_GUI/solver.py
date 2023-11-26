# Echo server program
import socket
import numpy as np
from scipy.optimize import minimize



# FULL_DEACTIVATION_TIME = (
#     (1000.0, 1950.0, 40000.0),
#     (1800.0, 600.0, 650.0),
#     (2400.0, 1000.0, 35.0)
#   ) # Photochromeleon

# row 1: cyan; row 2: magenta; row 3: yellow
# col 1: red;  col 2: green  ; col 3: blue
# FULL_DEACTIVATION_TIME = [[467, 712, 687], [1500, 242, 177], [10000, 900, 20]]
# version 1:
inf= 1000000
FULL_DEACTIVATION_TIME = [[72,160,240],[200,35,40],[1000,80,3]]

RGB_SCALE = 255
CMYK_SCALE = 1


def rgb_to_cmyk(r, g, b):
    if (r, g, b) == (0, 0, 0):
        # black
        return 0, 0, 0, CMYK_SCALE

    # rgb [0,255] -> cmy [0,1]
    c = 1 - r / RGB_SCALE
    m = 1 - g / RGB_SCALE
    y = 1 - b / RGB_SCALE

    # extract out k [0, 1]
    min_cmy = min(c, m, y)
    c = (c - min_cmy) / (1 - min_cmy)
    m = (m - min_cmy) / (1 - min_cmy)
    y = (y - min_cmy) / (1 - min_cmy)
    k = min_cmy

    # rescale to the range [0,CMYK_SCALE]
    return c * CMYK_SCALE, m * CMYK_SCALE, y * CMYK_SCALE, k * CMYK_SCALE

# convert cmyk to rgb color
def cmyk_to_rgb(c,m,y,k):
    r = RGB_SCALE*(1-c)*(1-k)
    g = RGB_SCALE*(1-m)*(1-k)
    b = RGB_SCALE*(1-y)*(1-k)
    return int(r), int(g), int(b)

class Deactivation:
    debug = False

    def __init__(self, debug=False):
        deactivation_speed = []
        for i in range(3):
            row = []
            for j in range(3):
                row.append(1 / FULL_DEACTIVATION_TIME[i][j])
            deactivation_speed.append(row)
        self.deactivation_speed = np.array(deactivation_speed)


    def compute_deactivation_time(self,
                                  target_color,
                                  bound = None,
                                  original_color=[1, 1, 1]
                                  ):
        color_to_deactivate = np.array(original_color) - np.array(target_color)
        
        A = self.deactivation_speed
        b = color_to_deactivate

        def objective(x):
            desaturation_level = np.minimum(np.dot(A, x), 1)
            color_difference = np.linalg.norm(desaturation_level - b)**2
            time = np.max(x)
            return 10000 * color_difference + time


        # Perform optimization with constraints
        if bound:
            print("bound:"+str(bound))
            bounds = [(0, bound)] * 3
        else:
            bounds = [(0, None)] * 3
        results = minimize(objective, [3,3,3], bounds=bounds)
        

        if results.success:
            deactivation_time = results.x
            realColor = np.maximum(original_color - A.dot(deactivation_time), 0)
            print("realColor (CMY):"+str(realColor) +"\n")
            print("deactivation_time:"+str(deactivation_time) +"\n")

            return deactivation_time, realColor
        else:
            print("Optimization failed")
            exit(  "Optimization failed")
            return None, None
    

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)


while True:
    data = conn.recv(1024).decode("utf-8")
    # if data is not None:
    #     print('Received:'+ data)
    dataSent=""
    ledNum=0

    if data:
        maxColorChangingTime = 0
        # read colors of leds sent by processing
        fread = open("/Users/kangyixiao/EchoFile/coding/FiberGUI/Fiber_GUI/fiber_GUI/ledsOri.txt","r")
        rgbs = fread.read().split("#")
        fread.close()
        # write colors of leds after deactivation
        fwirte = open("/Users/kangyixiao/EchoFile/coding/FiberGUI/Fiber_GUI/fiber_GUI/ledsDeactivate.txt","w")
        for i in range(len(rgbs)-1):

            color = rgbs[i].split(',')
            if not data: break
            c,m,y,k = rgb_to_cmyk(int(color[0]),int(color[1]),int(color[2]))
            # do whatever you need to do with the data
          
            # print(color) # Paging Python!
            d = Deactivation();
            if data == "1":
                time, realColor1 = d.compute_deactivation_time([c,m,y])
            else:
                time, realColor1 = d.compute_deactivation_time([c,m,y], bound = int(data))
            ledNum+=1
            realR, realG, realB = cmyk_to_rgb(realColor1[0],realColor1[1],realColor1[2],k)
            rTime = int(time[0])
            gTime = int(time[1])
            bTime = int(time[2])
            maxColorChangingTime = max(maxColorChangingTime, rTime, gTime, bTime)
            dataSent += str(realR)+","+str(realG)+","+str(realB)+","+str(rTime)+","+str(gTime)+","+str(bTime)+ "#"

        print("dataSent:")
        print(dataSent)

        fwirte.write(dataSent)
        fwirte.close()
        # send dataSent to socket 
        strSend = str(int(maxColorChangingTime))+ "\n"
        conn.send(strSend.encode("utf-8"))



conn.close()
# optionally put a loop here so that you start 
# listening again after the connection closes



