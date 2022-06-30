from kivy.graphics import Rectangle
from kivy.graphics import Color
from kivy.graphics import Line
from kivy.uix.widget import Widget
from kivy.core.window import Window

FIBER_PREVIEW_WIDTH = 600
FIBER_PREVIEW_HEIGHT = 600
FIBER_PREVIEW_X = 70
FIBER_PREVIEW_Y = 400

PADDING = 30
PADDING_HORIZONTAL = PADDING
PADDING_VERTICAL = PADDING

SEGMENT_WIDTH = 50
SEGMENT_HEIGHT = 20
SEGMENT_SPACING = 30

BOTTOM_LEFT = (FIBER_PREVIEW_X + PADDING_HORIZONTAL, FIBER_PREVIEW_Y + PADDING_VERTICAL)
TOP_RIGHT = (FIBER_PREVIEW_X + FIBER_PREVIEW_WIDTH - PADDING_HORIZONTAL, FIBER_PREVIEW_Y + FIBER_PREVIEW_HEIGHT - PADDING_VERTICAL)
N_SEGMENT_EACH_LINE = (FIBER_PREVIEW_WIDTH - 2 * PADDING_HORIZONTAL) // SEGMENT_WIDTH

DEFAULT_COLORS = [
(0.0 ,1, 1),
(0.1 ,1, 1),
(0.2 ,1, 1),
(0.3 ,1, 1),
(0.4 ,1, 1),
(0.5 ,1, 1),
(0.6 ,1, 1),
(0.7 ,1, 1),
(0.8 ,1, 1),
(0.9 ,1, 1),
(1, 1.0 , 1),
(1, 0.9 , 1),
(1, 0.8 , 1),
(1, 0.7 , 1),
(1, 0.6 , 1),
(1, 0.5 , 1),
(1, 0.4, 1),
(1, 0.3 , 1),
(1, 0.3 , 1),
(1, 0.1 , 1),
(1.0, 0.0 , 1),
(0.9, 0.1 , 1),
(0.8, 0.2 , 1),
(0.7, 0.3 , 1),
(0.6, 0.4 , 1),
(0.5, 0.5 , 1),
(0.4, 0.6 , 1),
(0.3, 0.7 , 1),
(0.2, 0.8 , 1),
(0.1, 0.9 , 1),
]

# hide any widget
def hide_widget(wid, dohide=True):
    if hasattr(wid, 'saved_attrs'):
        if not dohide:
            wid.height, wid.size_hint_y, wid.opacity, wid.disabled = wid.saved_attrs
            del wid.saved_attrs
    elif dohide:
        wid.saved_attrs = wid.height, wid.size_hint_y, wid.opacity, wid.disabled
        wid.height, wid.size_hint_y, wid.opacity, wid.disabled = 0, None, 0, True


def top_left_to_global (x, y):
    return (
        BOTTOM_LEFT[0] + x, 
        TOP_RIGHT[1] - y
        )

def global_to_top_left (x, y):
    return (
        x - BOTTOM_LEFT[0],
        TOP_RIGHT[1] - y
        )

def top_left_to_index (x, y):
    if (x > FIBER_PREVIEW_WIDTH) or (y > FIBER_PREVIEW_HEIGHT): 
        return None
    if (x < 0) or (y < 0):
        return None
    horizontal_index = x // SEGMENT_WIDTH    # which column
    vertical_index = y // (SEGMENT_HEIGHT + SEGMENT_SPACING)  # which row
    horizontal_surplus = x % SEGMENT_WIDTH
    vertical_surplus = y % (SEGMENT_HEIGHT + SEGMENT_SPACING)

    if (horizontal_index >= N_SEGMENT_EACH_LINE):
        return None
    if (vertical_surplus > SEGMENT_HEIGHT + 10):  # hardcoded threshold of 10
        return None

    return (vertical_index * N_SEGMENT_EACH_LINE + horizontal_index)

# order: top left; top right; bottom right; bottom left
# global point coordinate
def rectangle_points_by_index(i):
    line_number = i // N_SEGMENT_EACH_LINE
    column_number = i % N_SEGMENT_EACH_LINE
    x_from_top_left = column_number * SEGMENT_WIDTH
    y_from_top_left = line_number*(SEGMENT_HEIGHT + SEGMENT_SPACING)
    x_global, y_global = top_left_to_global(x_from_top_left, y_from_top_left)
    width = SEGMENT_WIDTH - 3
    height = SEGMENT_HEIGHT

    bottom_left = (x_global, y_global - height)
    bottom_right = (x_global + width, y_global - height)
    top_right = (x_global + width, y_global)
    top_left = (x_global, y_global)

    return [top_left, top_right, bottom_right, bottom_left]

def snake_index_to_normal(snake_index):
    if (snake_index // N_SEGMENT_EACH_LINE) % 2 == 1:
        return N_SEGMENT_EACH_LINE - snake_index - 1
    else:
        return snake_index

def normal_index_to_snake(normal_index):
    if (normal_index // N_SEGMENT_EACH_LINE) % 2 == 1:
        return N_SEGMENT_EACH_LINE - normal_index - 1
    else:
        return normal_index

# preview the fiber by drawing a lot of rectangles that represent 
# the corresponding segments
class FiberPreview(Widget):
    def __init__(self, fiber_length = 60, **kwargs):
        super().__init__()

        with self.canvas:
            # draw the canvas background
            self.background_color = Color(0.3,0.3,0.3)
            self.background = Rectangle(
                pos=(FIBER_PREVIEW_X, FIBER_PREVIEW_Y), 
                size=(FIBER_PREVIEW_WIDTH, FIBER_PREVIEW_HEIGHT)
                )
            
            self.length = fiber_length             # record fiber length
            self.colors = [] # populate initial colors
            for i in range(self.length):
                self.colors.append(DEFAULT_COLORS[i % len(DEFAULT_COLORS)])

            self.segments = []
            self.highlight=Line(point=[], width=3)
            self.selected_segment_index = 0

            self.redraw_segments(initializing = True)

    def remove_all_segments(self):
        for segment in self.segments:
            self.canvas.remove(segment)
        return


    def redraw_segments(self, initializing = False):
        if (not initializing):
            self.remove_all_segments()

        with self.canvas:
            for i in range (self.length):
                Color(self.colors[i][0], self.colors[i][1], self.colors[i][2])
                self.segments.append(self.rectangle_by_index(i))
        return

    def rectangle_by_index(self, i):  # i is normal index 
        line_number = i // N_SEGMENT_EACH_LINE
        column_number = i % N_SEGMENT_EACH_LINE
        x_from_top_left = column_number * SEGMENT_WIDTH
        y_from_top_left = line_number*(SEGMENT_HEIGHT + SEGMENT_SPACING)
        x_global, y_global = top_left_to_global(x_from_top_left, y_from_top_left)

        return Rectangle(
                pos=(x_global, y_global - SEGMENT_HEIGHT), # rectangle starts from bottom left
                size=(SEGMENT_WIDTH - 3,SEGMENT_HEIGHT)
                )

    def update_highlight(self):
        self.canvas.remove(self.highlight)
        with self.canvas:
            Color(1,1,1)
            points = rectangle_points_by_index(self.selected_segment_index)
            points.append(points[0])
            flattened_points = [coordinate for point in points for coordinate in point]
            self.highlight = Line(
                points=flattened_points, 
                width=3.5)


    def on_touch_down(self, touch):
        # find out what's the selected segment
        (x_global, y_global) = touch.pos
        x_top_left, y_top_left = global_to_top_left(x_global, y_global)
        selected_segment_index = top_left_to_index(x_top_left, y_top_left)
        if (selected_segment_index != None and selected_segment_index < self.length):
            self.selected_segment_index = int(selected_segment_index)
        else: 
            return

        self.update_highlight()
        return

    # public functions # 
    def change_fiber_length(self, new_length):
        if (new_length > self.length):
            for i in range(self.length - 1, new_length):
                self.colors.append(DEFAULT_COLORS[i % len(DEFAULT_COLORS)])
        else:
            for i in range(new_length, self.length):
                self.colors.pop()

        self.length = new_length
        self.redraw_segments()

        if new_length <= self.selected_segment_index:
            self.selected_segment_index = 0
            self.update_highlight()


        return 

    # update the color of the selected segment to color
    # color in the form of (R, G, B)
    # max is 1
    def update_color(self, color):
        self.canvas.remove(self.segments[self.selected_segment_index])
        self.colors[self.selected_segment_index] = color
        with self.canvas:
            Color(color[0], color[1], color[2])
            self.segments[self.selected_segment_index] = self.rectangle_by_index(self.selected_segment_index)
        return