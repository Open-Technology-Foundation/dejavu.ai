import os
import io
import sys
from colorama import init, Fore, Back, Style
init()

global useColor
useColor = True

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


def file_get_contents(filepath):
    with open(filepath, 'r', encoding='utf-8') as infile:
        return infile.read()

def file_put_contents(filename, string, mode='w'):
    with open(filename, mode) as f:
        f.write(string)


def is_numeric(string):
  try:
    float(string)
    return True
  except ValueError: return False


def int_list(input_string, minVal, maxVal, revSort=False):
  range_list = []
  try:
    numlist = input_string.split(',')
    for numC in numlist:
      if numC.strip() == '': continue
      if numC.strip() == 'all': numC = '1-'
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


global EDITOR, BROWSER
EDITOR = ''; BROWSER = ''
def getEDITOR():
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
  return EDITOR
getEDITOR()

def getBROWSER():
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
  return BROWSER
getBROWSER()
