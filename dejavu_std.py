import os
import io
import sys
import readline
import atexit
import glob
from colorama import init, Fore, Back, Style
init()

useColor = True
def printUseColor(color=True):
  global useColor
  useColor = color
  return useColor

def printerr(*args, **kwargs):
  global useColor
  output=kwargs.get('file', sys.stderr)
  if useColor: 
    print(kwargs.get('back', Back.BLACK)+kwargs.get('color', Fore.RED) + kwargs.get('style', Style.NORMAL), end='', file=output)
  for arg in args: 
    print(kwargs.get('prefix', '!!')+arg, end=kwargs.get('end', '\n'), file=output)
  if useColor: print(Style.RESET_ALL, end='', file=output)

def printinfo(*args, **kwargs):
  global useColor
  output=kwargs.get('file', sys.stdout)
  if useColor: 
    print(kwargs.get('back', Back.BLACK) + kwargs.get('color', Fore.WHITE) + kwargs.get('style', Style.DIM), end='', file=output)
  for arg in args: 
    print(kwargs.get('prefix', '# ')+arg, end=kwargs.get('end', '\n'), file=output)
  if useColor: print(Style.RESET_ALL, end='', file=output)

def printstd(*args, **kwargs):
  global useColor
  output=kwargs.get('file', sys.stdout)
  if useColor: 
    print(kwargs.get('back', Back.BLACK)+kwargs.get('color', Fore.WHITE) + kwargs.get('style', Style.NORMAL), end='', file=output)
  for arg in args: 
    print(arg, end=kwargs.get('end', '\n'), file=output)
  if useColor: print(Style.RESET_ALL, end='', file=output)


def readfile(filepath, enc='utf-8'):
    with open(filepath, 'r', encoding=enc) as infile:
        return infile.read()

def writefile(filename, string, mode='w', enc='utf-8'):
    with open(filename, mode, encoding=enc) as f:
        f.write(string)


def is_num(string):
  try:
    float(string)
    return True
  except ValueError: return False


def int_list(input_string, minVal, maxVal, revSort=False):
  range_list = []
  try:
    numlist = input_string.lower().split(',')
    for numC in numlist:
      if numC.strip() == '': continue
      if numC.strip() == 'all': numC = str(minVal)+'-'+str(maxVal)
      if '-' in numC:
        stnum, endnum = numC.split('-')
        if stnum == '':   stnum = int(minVal)
        if endnum == '':  endnum   = int(maxVal)
        stnum, endnum = int(stnum), int(endnum)
        if stnum < minVal or endnum > maxVal: 
          printerr('Error out of range'+str(stnum)+'-'+str(endnum))
          continue
        range_list += range(stnum, endnum+1)
      else:
        if int(numC) < minVal or int(numC) > maxVal: continue
        range_list.append(int(numC))
  except: 
    printerr('Exception error in int_list.')
    return False
  if len(range_list) == 0: return False
  range_list = list(set(range_list))
  range_list.sort()
  if revSort: return range_list[::-1]
  else:       return range_list


EDITOR = ''
def getEditor():
  global EDITOR
  EDITOR = os.environ.get('EDITOR')
  if not EDITOR:
    _ent_EDITOR = os.environ.get('_ent_EDITOR')
    if _ent_EDITOR:
      EDITOR = _ent_EDITOR
    elif os.environ.get('SUDO_EDITOR'):
      EDITOR = os.environ.get('SUDO_EDITOR')
    elif os.environ.get('SELECTED_EDITOR'):
      EDITOR = os.environ.get('SELECTED_EDITOR')
    elif os.path.isfile(os.path.join(os.environ.get('HOME'), '.selected_editor')):
      with open(os.path.join(os.environ.get('HOME'), '.selected_editor')) as f:
        SELECTED_EDITOR = f.read()
      if SELECTED_EDITOR:
        EDITOR = SELECTED_EDITOR
    elif os.path.isfile('/etc/alternatives/editor'):
      EDITOR = '/etc/alternatives/editor'
    else:
      EDITOR = '/bin/less'
  return EDITOR
getEditor()

BROWSER = ''
def getBrowser():
  global BROWSER
  BROWSER = os.environ.get('BROWSER')
  if not BROWSER:
    _ent_BROWSER = os.environ.get('_ent_BROWSER')
    if _ent_BROWSER:
      BROWSER = _ent_BROWSER
    elif os.path.isfile('/usr/bin/w3m'):
      BROWSER = '/usr/bin/w3m'
    elif os.path.isfile('/usr/bin/lynx'):
      BROWSER = '/usr/bin/lynx'
    else:
      BROWSER = '/bin/less'
  return BROWSER
getBrowser()


# readline() history file +atExit
def initHistory(filename, ext='.history'):
  historyFile = os.path.dirname(filename)+'/.'+os.path.basename(filename)+ext
  try:
      readline.read_history_file(historyFile)
      readline.set_history_length(200)
  except FileNotFoundError:
      writefile(historyFile, '')
  atexit.register(readline.write_history_file, historyFile)
  return historyFile


def selectFile(dirs, prompt='Select File: ', home=''):
  files = [ '' ]
  for root in dirs:
    for file in glob.glob("**/*.dv", root_dir=root, recursive=True):
      files.append((root+'/'+file).replace(home, '~').replace('./',''))
  selection = 0
  for index, file in enumerate(files):
    if index == 0: continue
    printstd(str(index) + ': ' + file)
  while True:
    try:
      selection = int(input(prompt))
    except KeyboardInterrupt:
      selection = 0; break
    except:
      printerr('Select 0-'+str(len(files)-1)); continue
    if selection == 0: break
    if selection >= 1 and selection < len(files): break
    else: printerr('Invalid selection.')
  return(files[selection])
