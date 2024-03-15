# values are the values that you want to plot 
# color is the color of the visualization, in a tuple of (R,G,B) values
def visualization_text (values, color):
    R,G,B = color

    pixel_values = transform_values_pixel(values)
    output_string = ""
    color_string = f"{R},{G},{B}"
    blank_string = "255,255,255"
    order_flip = True

    for pixel_value_bar in pixel_values:
        if order_flip: 
            pixel_value_bar = pixel_value_bar[::-1]

        order_flip = not order_flip

        # a bar is something like (1,1,1,0,0,0)
        for value in pixel_value_bar: 
            if value == 1: 
                output_string = output_string + color_string + "#"
            elif value == 0:
                output_string = output_string + blank_string + "#"
    return output_string

# turns a value into 1,1,1,0,0,0 arrays 
# where the number of 1 is larger when the input values are larger 
def transform_values_pixel(input_values):
    # Each group should be visualized within a block of 6
    bar_size = 6
    pixel_array = []

    maximum = max(input_values)
    minimum = min(input_values)
    
    for value in input_values:
        # Normalize the value within the range 0 to bar_size
        normalized_value = int((value - minimum) / (maximum - minimum) * (bar_size))  if maximum != minimum else 1
        # Create a block for each value with proportional visualization
        block = [1] * normalized_value + [0] * (bar_size - normalized_value)
        pixel_array.append(block)
    
    return pixel_array


def read_data_from_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
        if len(lines) < 2:
            print("Error: The file must contain at least two lines.")
            return [], []

        altitude_values = [int(val) for val in lines[0].strip().split(',')]
        heartrate_values = [int(val) for val in lines[1].strip().split(',')]

        return altitude_values, heartrate_values

# Read data from file
altitude_values, heartrate_values = read_data_from_file('data.txt')

# Validate the input
if altitude_values and heartrate_values:
    # Transform the arrays
    altitude_output_string = visualization_text(altitude_values[0:18][::-1], (0,0,0))
    heartrate_output_string = visualization_text(heartrate_values[0:18], (0,0,0))

    # Print the resulting array
    with open("color_array.txt", 'w') as file:
        file.write(heartrate_output_string + altitude_output_string )
