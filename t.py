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
