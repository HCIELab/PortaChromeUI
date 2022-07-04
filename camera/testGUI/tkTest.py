import tkinter as tk


root = tk.Tk()
root.title('Tkinter Window - Center')

window_width = 1000
window_height = 600

# get the screen dimension
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()

# find the center point
center_x = int(screen_width/2 - window_width / 2)
center_y = int(screen_height/2 - window_height / 2)

# set the position of the window to the center of the screen
root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')


# download button
def download_clicked():
    showinfo(
        title='Information',
        message='Download button clicked!'
    )

# download_icon = tk.PhotoImage(file='test.png')
download_button = tk.Button(
    root,
    # image=download_icon,
    text='Exit',
    command=download_clicked
)

download_button.pack(
    ipadx=1,
    ipady=5,
    expand=True
)

root.mainloop()
