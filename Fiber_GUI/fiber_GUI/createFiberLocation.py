

# #  Version 1.0: 144 led, four regions, every part is 6*6
# # HEXRADIUS means the distence from the center of the hexagon to its edge
# HEX_RADIUS = 50
# HORIZONTAL_NUM = 6
# VERTICAL_NUM = 6
# SHIFT_X = 100
# SHIFT_Y = 100

# def transform(string, horizontal_gap, vertical_gap):
#     pairs = string.split(';')
#     result = []
  
#     for pair in pairs:
#         numbers = pair.split(',')
#         print(numbers)
#         if(numbers[0] == ''): continue
#         numbers[0] = str(int(numbers[0]) + horizontal_gap)
#         numbers[1] = str(int(numbers[1]) + vertical_gap)
#         result.append(','.join(numbers))
    
#     transformed_string = ';'.join(result)
#     return transformed_string


# HORIZONTAL_GPA = HEX_RADIUS/4
# VERTICAL_GPA = HEX_RADIUS/2

# topLeft = ""
# for i in range(HORIZONTAL_NUM):
#     for j in range(VERTICAL_NUM):
#         x = i*HEX_RADIUS*2+SHIFT_X
#         if i%2== 0:
#             # from buttom to up
#             y = j*HEX_RADIUS*2+SHIFT_Y
#             topLeft += str(x) + ',' + str(y) + ';'
#         else:
#             # from up to buttom
#             y = (2*VERTICAL_NUM-1)*HEX_RADIUS - j*HEX_RADIUS*2+SHIFT_Y
#             topLeft += str(x) + ',' + str(y) + ';'

# topRight = transform(topLeft, HORIZONTAL_GPA+6*2*HEX_RADIUS, 0)
# bottomLeft = transform(topLeft, 0, VERTICAL_GPA+6*2*HEX_RADIUS)
# bottomRight = transform(topLeft, HORIZONTAL_GPA+6*2*HEX_RADIUS, VERTICAL_GPA+6*2*HEX_RADIUS)
# ans = topLeft + topRight + ";"+bottomLeft+';' + bottomRight
# print(ans)



# #  Version 1.0: 72 led, two regions, every part is 6*6

# SHIFT_X = 600
# SHIFT_Y = 100
# HEX_RADIUS = 50
# HORIZONTAL_NUM = 6
# VERTICAL_NUM = 6
# ans = ""
# for i in range(HORIZONTAL_NUM):
#     y = i*HEX_RADIUS*2+SHIFT_Y
    
#     for j in range(VERTICAL_NUM):
#         if i%2 == 0:
#             x = SHIFT_X-HEX_RADIUS -2*HEX_RADIUS*j
#             ans += str(x) + ',' + str(y) + ';'
#         else:
#             x = SHIFT_X- 10 * HEX_RADIUS + 2*HEX_RADIUS*j
#             ans += str(x) + ',' + str(y) + ';'
# print(ans)

# # version 2022.12.07, 108 leds

# SHIFT_X = 325
# SHIFT_Y = 330
# HEX_RADIUS = 50
# HORIZONTAL_NUM = 18
# VERTICAL_NUM = 6
# ans = ""

# for i in range(HORIZONTAL_NUM):
#     for j in range(VERTICAL_NUM):
#         x = 1.5 * HEX_RADIUS * i + SHIFT_X
#         if i % 2 == 0:
#             y = 1.732 * HEX_RADIUS * j + SHIFT_Y
#         else:
#             y = 4.5 * 1.732 * HEX_RADIUS  - 1.732 * HEX_RADIUS * j + SHIFT_Y

#         ans += str(int(x)) + ',' + str(int(y)) + ';'
# print(ans)

# version 2022.12.07, 216 leds
SHIFT_X = 500
SHIFT_Y = 30
HEX_RADIUS = 40
HORIZONTAL_NUM = 6
VERTICAL_NUM = 18
ans = ""

for i in range(VERTICAL_NUM):
    for j in range(HORIZONTAL_NUM):
        y = 1.5 * HEX_RADIUS * i + SHIFT_Y
        if i % 2 == 0:
            x = 1.732 * HEX_RADIUS * j + 1.732/2 * HEX_RADIUS + SHIFT_X
        else:
            x = 5 * 1.732 * HEX_RADIUS  - 1.732 * HEX_RADIUS * j + SHIFT_X

        ans += str(int(x)) + ',' + str(int(y)) + ';'

m = 11.5* 1.732 * HEX_RADIUS
n = 1.5 * HEX_RADIUS * (VERTICAL_NUM-1)

# ans += '\n'

for i in range(VERTICAL_NUM):
    for j in range(HORIZONTAL_NUM):
        y = n - 1.5 * HEX_RADIUS * i + SHIFT_Y
        if i % 2 == 0:
            x = m - 1.732/2 * HEX_RADIUS - 1.732 * HEX_RADIUS * j + SHIFT_X
        else:
            x = m - 5 * 1.732 * HEX_RADIUS + 1.732 * HEX_RADIUS * j + SHIFT_X
        ans += str(int(x)) + ',' + str(int(y)) + ';'


print(ans)
       
