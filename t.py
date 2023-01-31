import os
import sys
from Xlib import display

try:
    d = display.Display()
    display_name = d.get_display_name()
except: print('No kb'); exit()

tt='123'
if display_name:
    print("Display server is running on %s %s" % [ display_name, tt ])
else:
    print("No display server is running")

exit()

from pynput.keyboard import Key, Controller

keyboard = Controller()

# Insert the string
#keyboard.type('This is the string you want to insert')
#SYSADMIN:
#add an input() statement
#TECHLEAD:
input_string = input('Please enter a string: ')
keyboard.type(input_string+'\n\n')
input('input: ')
