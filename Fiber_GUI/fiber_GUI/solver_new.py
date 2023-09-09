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
FULL_DEACTIVATION_TIME = [[3500,2000,3600],[2000,2000,1000],[inf,4500,60]]

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
                                  original_color=[1, 1, 1]):
        color_to_deactivate = np.array(original_color) - np.array(target_color)
        
        A = self.deactivation_speed
        b = color_to_deactivate

        def objective(x):
            return np.linalg.norm(A.dot(x) - b)**2

        # Initial guess
        x0 = np.array([1, 1, 1])

        # Perform optimization with constraints
        bounds = [(0, None)] * 3
        results = minimize(objective, x0, bounds=bounds)
        deactivation_time
        realColor

        if result.success:
            deactivation_time = result.x
            realColor = A.dot(deactivation_time)
        else:
            print("Optimization failed")
            return None, None
    


HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
dataSent=""
ledNum=0

while True:
    data = conn.recv(1024).decode("utf-8")
    # if data is not None:
    #     print('Received:'+ data)

    if data =="1":
        # read colors of leds sent by processing
        fread = open("ledsOri.txt","r")
        rgbs = fread.read().split("#")
        fread.close()
        # write colors of leds after deactivation
        fwirte = open("ledsDeactivate.txt","w")
        for i in range(len(rgbs)-1):

            color = rgbs[i].split(',')
            if not data: break
            c,m,y,k = rgb_to_cmyk(int(color[0]),int(color[1]),int(color[2]))
            # do whatever you need to do with the data
          
            # print(color) # Paging Python!
            d = Deactivation();
            time, realColor1 = d.compute_deactivation_time([c,m,y])
            ledNum+=1
            realR, realG, realB = cmyk_to_rgb(realColor1[0],realColor1[1],realColor1[2],k)
            print("time:"+str(time))
            dataSent += str(realR)+","+str(realG)+","+str(realB)+"#"

        print("dataSent"+dataSent)
        print("ledNum"+str(ledNum))
        fwirte.write(dataSent)
        fwirte.close()
        # send dataSent to socket 
        conn.send("0\n".encode("utf-8"))



conn.close()
# optionally put a loop here so that you start 
# listening again after the connection closes




