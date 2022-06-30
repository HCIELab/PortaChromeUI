from kivy.config import Config
Config.set('graphics','resizable', False)
Config.set('graphics', 'width', '800')
Config.set('graphics', 'height', '600')

from kivy.app import App
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.relativelayout import RelativeLayout
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
from kivy.uix.colorpicker import ColorPicker
# from kivy.uix.colorpicker import ColorWheel
# from kivy.graphics import Rectangle
# from kivy.graphics import Color
# from kivy.graphics import Line
# from kivy.uix.widget import Widget
# from kivy.core.window import Window

# import serial
# import time
import argparse
import math
from kivy.logger import Logger
from fiber_preview import *
from saturation_calculation import *





def RGB1toCMY1(RGB_color = (255, 0, 0)):
    return [1-c for c in RGB_color]



class ChromoFiberUI(App):
    def __init__(self, arduino_port):
        super().__init__()
        if __debug__:
          self.arduino = serial.Serial(arduino_port, baudrate=9600)
          time.sleep(2)
        else: 
          self.arduino = None
        Logger.info("Initialized")
        
    def build(self):
        # title bar
        self.title = "ChromoFiber"

        # layout
        self.window = RelativeLayout(size=(800, 600))

        # Logo Label
        self.logo_text = Label(
            text="[b]ChromoFiber Design Tool[/b]",
            markup=True,
            font_size = 45,
            color="#e3f6ff",
            size_hint=(.4, .1),
            pos=(0, 1075)
            )
        self.window.add_widget(self.logo_text)


        # display a fiber
        self.fiber_length_input_label = Label(
            text="Fiber Length",
            markup=True,
            font_size = 30,
            color="#e3f6ff",
            size_hint=(0.2, .1),
            pos=(0, 1000)
            )
        self.window.add_widget(self.fiber_length_input_label)

        self.fiber_length_input = TextInput(
            text="60",
            size_hint=(0.1, .05),
            pos=(260, 1030)
            )
        self.window.add_widget(self.fiber_length_input)



        self.fiber_length_confirm = Button(
            text = "Confirm",
            background_color = "#00ffce",
            size_hint=(0.1, .05),
            pos=(450, 1030)
            )
        self.fiber_length_confirm.bind(on_press=self.confirm_fiber_length)
        self.window.add_widget(self.fiber_length_confirm)

        # fiber preview
        self.fiber_preview = FiberPreview(
            # pos=(20,20),
            # size=(300, 300)
            )
        self.window.add_widget(self.fiber_preview)



        # color picker 
        self.color_picker = ColorPicker(
                pos=(700,420),
                size_hint=(0.48,0.48)
            )
        self.window.add_widget(self.color_picker)
        self.color_picker.bind(color=self.pick_color)



        # light up button
        self.light_button = Button(
            text = "Start Color Changing",
            bold = True,
            background_color = "#ffbaca",
            size_hint = (0.25, 0.1),
            pos = (620, 170)
            )
        self.light_button.bind(on_press=self.display_color)
        self.window.add_widget(self.light_button)

        return self.window

    def run_color_changing(self, instance):
        # print(self.fiber_preview.colors)

        # v - stands for visible light
        # grammar: v + time to shine light + "#" + color for each pixel
        # sample: v0160
        string_to_send = "v" + str(len(self.fiber_preview.colors)).zfill(3) + "#"
        deactivation = Deactivation()
        for color in self.fiber_preview.colors:
            # print(deactivation.compute_deactivation_time(RGB1toCMY1(color)))
            deactivation_time = deactivation.compute_deactivation_time(RGB1toCMY1(color))
            deactivation_time_str= [str(math.floor(time)).zfill(3) for time in deactivation_time]
            string_to_concatenate = deactivation_time_str[0] + "," + deactivation_time_str[1] + "," + deactivation_time_str[2] + "#"
            string_to_send += string_to_concatenate
        Logger.info("string to send")
        Logger.info(string_to_send)

  
    
        # string_to_send = "v003#005,004,003#001,001,001#010,009,008#" # debug
        if self.arduino != None:
            self.arduino.write(bytes(string_to_send, "utf-8"))
             # debugs
            # print(self.arduino.readline())

    def display_color(self, instance):
        # print(self.fiber_preview.colors)
        # send the color to arduino
        # d - stands for displaying color
        # sample: d#255,255,000#000,127,255#127,127,127#
        string_to_send = "d#"
        for color in self.fiber_preview.colors:
            red = str(math.floor(color[0]*255 ) ).zfill(3)
            green = str(math.floor(color[1]*255 ) ).zfill(3)
            blue = str(math.floor(color[2]*255 ) ).zfill(3)
            string_to_concatenate = red + "," + green + "," + blue + "#"
            string_to_send += string_to_concatenate

        Logger.info("string_to_send")
        Logger.info( string_to_send)
        if self.arduino != None:
            self.arduino.write(bytes(string_to_send, "utf-8"))
        return

    def pick_color(self, instance, value):
        color = (value[0], value[1], value[2])  # get color from the color picker; RGBA to RGB
        self.fiber_preview.update_color(color)
        return

    def confirm_fiber_length(self, instance):
        self.fiber_preview.change_fiber_length(int(self.fiber_length_input.text))
        
        return




###### Parser ######
parser = argparse.ArgumentParser()
parser.add_argument("arduinoport", help="your arduino port for a light controller. For Ubuntu, use ls /dev/tty* to find. For Mac, use /dev/tty.*")
args = parser.parse_args()

ChromoFiberUI(args.arduinoport).run()