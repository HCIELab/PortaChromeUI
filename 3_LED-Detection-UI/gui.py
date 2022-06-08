from tkinter import *
from PIL import Image, ImageTk

w = 800
h = 600
root = Tk()  # background window
canvas = Canvas(root, width=w, height=h, bg='white')
canvas.pack()
img = ImageTk.PhotoImage(Image.open("test.png"))
back = ImageTk.PhotoImage(Image.open("background.jpg"))
canvas.create_image(100, 100, image=back)
canvas.create_image(100, 100, image=img)


def move(e):
    global img
    img = ImageTk.PhotoImage(Image.open("test.png"))
    canvas.create_image(e.x, e.y, image=img)


canvas.bind("<B1-Motion>", move)

root.mainloop()
