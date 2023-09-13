#  Version 1.0: 144 led, four regions, every part is 6*6

def transform(string, horizontal_gap, vertical_gap):
    pairs = string.split(';')
    result = []
  
    for pair in pairs:
        numbers = pair.split(',')
        print(numbers)
        if(numbers[0] == ''): continue
        numbers[0] = str(int(numbers[0]) + horizontal_gap)
        numbers[1] = str(int(numbers[1]) + vertical_gap)
        result.append(','.join(numbers))
    
    transformed_string = ';'.join(result)
    return transformed_string


# HEXRADIUS means the distence from the center of the hexagon to its edge
HEX_RADIUS = 50
HORIZONTAL_NUM = 6
VERTICAL_NUM = 6
SHIFT_X = 100
SHIFT_Y = 100

HORIZONTAL_GPA = HEX_RADIUS/4
VERTICAL_GPA = HEX_RADIUS/2

topLeft = ""
for i in range(HORIZONTAL_NUM):
    for j in range(VERTICAL_NUM):
        x = i*HEX_RADIUS*2+SHIFT_X
        if i%2== 0:
            # from buttom to up
            y = j*HEX_RADIUS*2+SHIFT_Y
            topLeft += str(x) + ',' + str(y) + ';'
        else:
            # from up to buttom
            y = (2*VERTICAL_NUM-1)*HEX_RADIUS - j*HEX_RADIUS*2+SHIFT_Y
            topLeft += str(x) + ',' + str(y) + ';'

topRight = transform(topLeft, HORIZONTAL_GPA+6*2*HEX_RADIUS, 0)
bottomLeft = transform(topLeft, 0, VERTICAL_GPA+6*2*HEX_RADIUS)
bottomRight = transform(topLeft, HORIZONTAL_GPA+6*2*HEX_RADIUS, VERTICAL_GPA+6*2*HEX_RADIUS)
ans = topLeft + topRight + ";"+bottomLeft+';' + bottomRight
print(ans)





