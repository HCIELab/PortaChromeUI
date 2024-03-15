

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
# SHIFT_Y = 30
# HEX_RADIUS = 50
# HORIZONTAL_NUM = 18
# VERTICAL_NUM = 12
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
# SHIFT_X = 500
# SHIFT_Y = 30
# HEX_RADIUS = 40
# HORIZONTAL_NUM = 6
# VERTICAL_NUM = 18
# ans = ""

# for i in range(VERTICAL_NUM):
#     for j in range(HORIZONTAL_NUM):
#         y = 1.5 * HEX_RADIUS * i + SHIFT_Y
#         if i % 2 == 0:
#             x = 1.732 * HEX_RADIUS * j + 1.732/2 * HEX_RADIUS + SHIFT_X
#         else:
#             x = 5 * 1.732 * HEX_RADIUS  - 1.732 * HEX_RADIUS * j + SHIFT_X

#         ans += str(int(x)) + ',' + str(int(y)) + ';'

# m = 11.5* 1.732 * HEX_RADIUS
# n = 1.5 * HEX_RADIUS * (VERTICAL_NUM-1)

# # ans += '\n'

# for i in range(VERTICAL_NUM):
#     for j in range(HORIZONTAL_NUM):
#         y = n - 1.5 * HEX_RADIUS * i + SHIFT_Y
#         if i % 2 == 0:
#             x = m - 1.732/2 * HEX_RADIUS - 1.732 * HEX_RADIUS * j + SHIFT_X
#         else:
#             x = m - 5 * 1.732 * HEX_RADIUS + 1.732 * HEX_RADIUS * j + SHIFT_X
#         ans += str(int(x)) + ',' + str(int(y)) + ';'


# print(ans)
       
# version 2023.12.09, 216 leds, Yunyi

# SHIFT_X = 500
# SHIFT_Y = 30
# HEX_RADIUS = 40
# HORIZONTAL_NUM = 6
# VERTICAL_NUM = 18
# ans = []

# # Generate the coordinates in the normal order
# for i in range(VERTICAL_NUM):
#     for j in range(HORIZONTAL_NUM):
#         y = 1.5 * HEX_RADIUS * i + SHIFT_Y
#         if i % 2 == 0:
#             x = 1.732 * HEX_RADIUS * j + 1.732/2 * HEX_RADIUS + SHIFT_X
#         else:
#             x = 5 * 1.732 * HEX_RADIUS  - 1.732 * HEX_RADIUS * j + SHIFT_X

#         ans.append((int(x), int(y)))

# m = 11.5 * 1.732 * HEX_RADIUS
# n = 1.5 * HEX_RADIUS * (VERTICAL_NUM - 1)

# for i in range(VERTICAL_NUM):
#     for j in range(HORIZONTAL_NUM):
#         y = n - 1.5 * HEX_RADIUS * i + SHIFT_Y
#         if i % 2 == 0:
#             x = m - 1.732/2 * HEX_RADIUS - 1.732 * HEX_RADIUS * j + SHIFT_X
#         else:
#             x = m - 5 * 1.732 * HEX_RADIUS + 1.732 * HEX_RADIUS * j + SHIFT_X

#         ans.append((int(x), int(y)))

# # Reverse the array
# ans.reverse()

# # Convert to string
# ans_str = ';'.join([f'{x},{y}' for x, y in ans])

# print(ans_str)

# version 2023.12.09, 216 LEDs, Yunyi, horizontal
# SHIFT_X = 500
# SHIFT_Y = 30
# HEX_RADIUS = 40
# HORIZONTAL_NUM = 6
# VERTICAL_NUM = 18
# ans = []

# # Adjust these to shift the rotated array as needed
# NEW_SHIFT_X = 450
# NEW_SHIFT_Y = 150

# # Calculate the height and width of the original array
# total_height = 1.5 * HEX_RADIUS * (VERTICAL_NUM - 1)
# total_width = 1.732 * HEX_RADIUS * (HORIZONTAL_NUM - 1)

# # Generate the coordinates in the normal order and rotate them
# for i in range(VERTICAL_NUM):
#     for j in range(HORIZONTAL_NUM):
#         original_y = 1.5 * HEX_RADIUS * i + SHIFT_Y
#         if i % 2 == 0:
#             original_x = 1.732 * HEX_RADIUS * j + 1.732/2 * HEX_RADIUS + SHIFT_X
#         else:
#             original_x = 5 * 1.732 * HEX_RADIUS - 1.732 * HEX_RADIUS * j + SHIFT_X

#         # Rotating the array clockwise
#         x = total_height - (original_y - SHIFT_Y) + NEW_SHIFT_X
#         y = original_x - SHIFT_X + NEW_SHIFT_Y

#         ans.append((int(x), int(y)))

# m = 11.5 * 1.732 * HEX_RADIUS
# n = 1.5 * HEX_RADIUS * (VERTICAL_NUM - 1)

# for i in range(VERTICAL_NUM):
#     for j in range(HORIZONTAL_NUM):
#         original_y = n - 1.5 * HEX_RADIUS * i + SHIFT_Y
#         if i % 2 == 0:
#             original_x = m - 1.732/2 * HEX_RADIUS - 1.732 * HEX_RADIUS * j + SHIFT_X
#         else:
#             original_x = m - 5 * 1.732 * HEX_RADIUS + 1.732 * HEX_RADIUS * j + SHIFT_X

#         # Rotating the array clockwise
#         x = total_height - (original_y - SHIFT_Y) + NEW_SHIFT_X
#         y = original_x - SHIFT_X + NEW_SHIFT_Y

#         ans.append((int(x), int(y)))


# # Reverse the array
# ans.reverse()

# # Convert to string
# ans_str = ';'.join([f'{x},{y}' for x, y in ans])

# print(ans_str)


# 2023-12-12 Yunyi Customize 9 by 9 

SHIFT_X = 1
SHIFT_Y = 30
HEX_RADIUS = 40
HORIZONTAL_NUM = 9
VERTICAL_NUM = 8
ans = []

# Adjust these to shift the rotated array as needed
NEW_SHIFT_X = 500
NEW_SHIFT_Y = 250

# Calculate the height and width of the original array
total_height = 1.5 * HEX_RADIUS * (VERTICAL_NUM - 1)
total_width = 1.732 * HEX_RADIUS * (HORIZONTAL_NUM - 1)

# Generate the coordinates in the normal order and rotate them
for i in range(VERTICAL_NUM):
    for j in range(HORIZONTAL_NUM):
        original_y = 1.5 * HEX_RADIUS * i + SHIFT_Y
        if i % 2 == 0:
            original_x = 1.732 * HEX_RADIUS * j + 1.732/2 * HEX_RADIUS + SHIFT_X
        else:
            original_x = 5 * 1.732 * HEX_RADIUS - 1.732 * HEX_RADIUS * j + SHIFT_X

        # Rotating the array clockwise
        x = total_height - (original_y - SHIFT_Y) + NEW_SHIFT_X
        y = original_x - SHIFT_X + NEW_SHIFT_Y

        ans.append((int(x), int(y)))



# Reverse the array
ans.reverse()

# Convert to string
ans_str = ';'.join([f'{x},{y}' for x, y in ans])

print(ans_str)


