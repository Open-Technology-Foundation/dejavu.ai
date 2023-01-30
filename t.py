import pyperclip

def intercept_paste(text):
    # Intercept the pressing of the Shift-Ctrl-v key
    if pyperclip.paste() == 'shift-ctrl-v':
        # Change the contents of the paste buffer
        pyperclip.copy(text.replace('new', 'old'))
        # Paste the changed contents
        pyperclip.paste()

# Call the function
intercept_paste('This is the new paste buffer contents')
tt=input(":")
