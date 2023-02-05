import os
import sys
import curses

# Get the curses window, turn off echoing of keyboard to screen, turn on
# instant (no waiting) key response, and use special values for cursor keys
screen = curses.initscr()
curses.noecho()
curses.cbreak()
screen.keypad(True)

# Set up colors
curses.start_color()
curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_BLACK)
curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_WHITE)

# Create the form
form = curses.newwin(10, 40, 0, 0)
form.border(0)
form.addstr(1, 1, 'Name:', curses.color_pair(1))
form.addstr(2, 1, 'Address:', curses.color_pair(1))
form.addstr(3, 1, 'Phone Number:', curses.color_pair(1))
form.addstr(5, 1, 'Submit', curses.color_pair(2))

# Get user input
name_field = curses.newwin(1, 28, 1, 11)
address_field = curses.newwin(1, 28, 2, 11)
phone_field = curses.newwin(1, 28, 3, 11)
submit_field = curses.newwin(1, 28, 5, 11)

name_field.bkgd(' ', curses.color_pair(2))
address_field.bkgd(' ', curses.color_pair(2))
phone_field.bkgd(' ', curses.color_pair(2))
submit_field.bkgd(' ', curses.color_pair(2))

# Set initial focus
form.move(1, 11)
form.refresh()

# Get user input
name = name_field.getstr().decode('utf-8')
address = address_field.getstr().decode('utf-8')
phone = phone_field.getstr().decode('utf-8')

# Display the results
form.addstr(7, 1, 'Name: ' + name, curses.color_pair(1))
form.addstr(8, 1, 'Address: ' + address, curses.color_pair(1))
form.addstr(9, 1, 'Phone Number: ' + phone, curses.color_pair(1))

# Exit
curses.nocbreak()
screen.keypad(0)
curses.echo()
curses.endwin()

print(name, address, phone)
