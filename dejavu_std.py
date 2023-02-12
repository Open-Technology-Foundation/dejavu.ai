"""
Generic functions
"""
# pylint: disable=global-statement
# pylint: disable=too-many-arguments
# pylint: disable=wildcard-import
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=multiple-statements
# pylint: disable=broad-exception-caught

import os
import sys
import readline
import fnmatch
import shutil
import atexit
import glob
import random
import math
from shutil import get_terminal_size
from colorama import init, deinit, Fore, Back, Style
init()

def has_color(stream):
  """ Is there a terminal attached? """
  if not hasattr(stream, 'isatty'): return False
  if not stream.isatty(): return False
  return True

useColor = has_color(sys.stdout)
def UseColor(color=None):
  """ Print in Color or Not flag. """
  global useColor
  if color is not None:
    useColor = color
    if useColor: init()
    else: deinit()
  return useColor

ScreenColumns, ScreenRows = get_terminal_size()
def getScreenColumns():
  """ Get current screen columns. """
  global ScreenColumns, ScreenRows
  ScreenColumns, ScreenRows = get_terminal_size()
  return ScreenColumns
def getScreenRows():
  """ Get current screen columns. """
  global ScreenColumns, ScreenRows
  ScreenColumns, ScreenRows = get_terminal_size()
  return ScreenRows

def printerr(*args, **kwargs):
  """ Print to stderr with optional color. """
  output=kwargs.get('file', sys.stderr)
  if useColor:
    print(kwargs.get('back', Back.BLACK)+kwargs.get('color', Fore.RED) + kwargs.get('style', Style.NORMAL), end='', file=output)
  for arg in args:
    print(kwargs.get('prefix', '!!')+arg, end=kwargs.get('end', '\n'), file=output)
  if useColor: print(Style.RESET_ALL, end='', file=output)

def printinfo(*args, **kwargs):
  """ Print info to std with optional color. """
  output=kwargs.get('file', sys.stdout)
  if useColor:
    print(kwargs.get('back', Back.BLACK) + kwargs.get('color', Fore.WHITE) + kwargs.get('style', Style.DIM), end='', file=output)
  for arg in args:
    print(kwargs.get('prefix', '# ')+arg, end=kwargs.get('end', '\n'), file=output)
  if useColor: print(Style.RESET_ALL, end='', file=output)

def printstd(*args, **kwargs):
  """ Print to std with optional color. """
  output=kwargs.get('file', sys.stdout)
  if useColor:
    print(kwargs.get('back', Back.BLACK)+kwargs.get('color', Fore.WHITE) + kwargs.get('style', Style.NORMAL), end='', file=output)
  for arg in args:
    print(arg, end=kwargs.get('end', '\n'), file=output)
  if useColor: print(Style.RESET_ALL, end='', file=output)


def readfile(filepath, encoding='utf-8'):
  """ Read contents of filename into string. """
  with open(filepath, 'r', encoding=encoding) as infile:
    return infile.read()

def writefile(filename, string, mode='w', encoding='utf-8'):
  """ Write string to filename. """
  with open(filename, mode, encoding=encoding) as f:
    f.write(string)


def tempname(label='tmp', ext='.tmp'):
  """ Return a temporary dirname/filename located in TMPDIR or /tmp. """
  tmpdir = os.getenv('TMPDIR')
  if not tmpdir: tmpdir = '/tmp'
  os.makedirs(tmpdir, exist_ok=True)
  rand = random.randint(11420,99420)
  base = os.path.basename(__file__)
  #return "{0}/dv-{1}-{2}{3}".format(tmpdir, label, , ext)
  return f"{tmpdir}/{base}-{label}-{rand}{ext}"


def escstr(string):
  """ Escape \n\t\r in string. """
  return string.replace('\n','\\n').replace('\r','\\r').replace('\t','\\t')


def is_num(string):
  """ Is this string a number? """
  try:
    float(string)
    return True
  except ValueError:
    return False

def url_split(url):
    protocol, remainder = url.split("://")
    host, path = remainder.split("/", 1)
    return protocol, host, path

def int_list(input_string, minVal, maxVal, revSort=False):
  """ Return an ordered list of numbers. """
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
  except Exception as e:
    printerr('Exception error in int_list '+str(e))
    return False
  if len(range_list) == 0: return False
  range_list = list(set(range_list))
  range_list.sort()
  if revSort: return range_list[::-1]
  return range_list


SHELL = ''
def getShell():
  """ Define SHELL to use. """
  global SHELL
  SHELL = os.environ.get('SHELL')
  if not SHELL: SHELL = '/bin/bash'
  SHELL = SHELL.strip()
  os.environ['SHELL'] = SHELL
  return SHELL
getShell()

HOME = ''
def getHome():
  """ Define HOME to use. """
  global HOME
  HOME = os.environ.get('HOME')
  if not HOME: HOME = os.getcwd()
  HOME = HOME.strip()
  os.environ['HOME'] = HOME
  return HOME
getHome()

USER = ''
def getUser():
  """ Define SHELL to use. """
  global USER
  USER = os.environ.get('USER')
  if USER == '': USER = os.getenv('LOGNAME')
  if USER == '': USER = os.getenv('USERNAME')
  if USER == '': USER = os.getenv('USER_NAME')
  if not USER: USER = 'USER'
  USER = USER.strip()
  os.environ['USER'] = USER
  return USER
getUser()

EDITOR = ''
def getEditor():
  """ Define EDITOR to use. """
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
    elif os.path.isfile(f'{HOME}/.selected_editor'):
      with open(os.path.join(f'{HOME}/.selected_editor'), encoding='ASCII') as f:
        SELECTED_EDITOR = f.read()
      if SELECTED_EDITOR:
        EDITOR = SELECTED_EDITOR
    elif os.path.isfile('/etc/alternatives/editor'):
      EDITOR = '/etc/alternatives/editor'
    else:
      EDITOR = '/bin/less'
  EDITOR = EDITOR.strip()
  os.environ['EDITOR'] = EDITOR
  return EDITOR
getEditor()

BROWSER = ''
def getBrowser():
  """ Define BROWSER to use. """
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
  BROWSER = BROWSER.strip()
  os.environ['BROWSER'] = BROWSER
  return BROWSER
getBrowser()


def initHistory(filename, ext='.history'):
  """ readline() history file +atExit """
  historyFile = os.path.dirname(filename)+'/.'+os.path.basename(filename)+ext
  try:
    readline.read_history_file(historyFile)
    readline.set_history_length(200)
  except FileNotFoundError:
    writefile(historyFile, '')
  atexit.register(readline.write_history_file, historyFile)
  return historyFile


def copy_files_recursive(src_dir, dest_dir, wildcard='*', **kwargs):
  """
  success = copy_files_recursive(src_dir, dest_dir, wildcard='*', **kwargs):
  Copy all files matching wildcard from src_dir to dest_dir,
  recursively, but only if these files are newer or do not exist in dest_dir.
  # Usage example
  if not copy_files_recursive('/usr/share/dejavu.ai', '/home/sysadmin/.dv', '*.dv', verbose=True):
    printerr('Copy error')
  """
  copy_verbose = kwargs.get('verbose', False)
  success = False
  try:
    for root, dirs, files in os.walk(src_dir):
      for filename in files:
        if fnmatch.fnmatch(filename, wildcard):
          src_file = os.path.join(root, filename)
          dest_file = os.path.join(dest_dir, filename)
          if not os.path.exists(dest_file) or os.stat(src_file).st_mtime > os.stat(dest_file).st_mtime:
            if copy_verbose: printinfo(f'Copying {src_file} to {dest_file}')
            shutil.copy2(src_file, dest_file)
    success = True
  except (shutil.Error, shutil.SameFileError):
    printerr('Error: Source and destination are the same file.')
  except OSError:
    printerr('Error: Invalid source or destination path.')
  return success


def getfiles(dirs='.', globule='*', **kwargs):
  """ get a list of files """ 
  shorten = kwargs.get('shorten', False)
  get_files = []
  for root in dirs:
    for file in glob.glob(f'{root}/{globule}', recursive=True):
      get_files.append(os.path.realpath(file))
  arr = list(set(get_files))
  if not shorten:
    arr.sort()
    return arr
  # shorten
  pwdfiles = os.getcwd()
  HOME = os.environ.get('HOME', pwdfiles)
  get_files = []
  for farr in arr:
    if farr.startswith(pwdfiles):
      farr = '.'+farr[len(pwdfiles):]
    elif farr.startswith(HOME):
      farr = '~'+farr[len(HOME):]
    get_files.append(farr)
  get_files.sort()
  return get_files

# pylint: disable=too-many-locals
def selectFile(dirs, globule='*', selprompt='Select File: ', **kwargs):
  """ Select a file from a list. """
  dfiles = getfiles(dirs, globule, shorten=kwargs.get('shorten', True))
  if len(dfiles) == 0:
    printerr('No files found.')
    return ''
  maxlen = max(len(x) for x in dfiles)
  numpad = len(str(maxlen))
  totalpad = maxlen + numpad + 3
  ScreenColumns = getScreenColumns()-1
  numrows = math.ceil(len(dfiles) / int(ScreenColumns/totalpad))
  output = [''] * numrows
  row = 0
  for index, file in enumerate(dfiles):
    if row == numrows: row = 0
    output[row] += (f'{index+1:{numpad}d}. {file}').ljust(totalpad, ' ')
    row += 1
  print('\n'.join(output))
  selection = 0
  while True:
    try:
      selection = int(input(selprompt))
    except KeyboardInterrupt:
      print()
      return ''
    except Exception:
      printerr('Select 1-' + str(len(dfiles)) + ', 0 to exit.'); continue
    if 0 <= selection <= len(dfiles): break
    printerr('Select 1-' + str(len(dfiles)) + ', 0 to exit.'); continue
  if selection == 0: return ''
  return os.path.realpath(dfiles[selection-1])

def find_file(filename, **kwargs):
  """
  fqfn = find_file(filename, 
                    ext='.dv', 
                    mustexist=True, 
                    searchpaths=sys.path)
  # if not mustexist and file does not exist 
  # then defaults to sys.path[0]+'/'+filename.ext
  # return '' if fail.
  """
  if len(filename) == 0: return ''
  mustexist = kwargs.get('mustexist', True)
  searchpaths = kwargs.get('searchpaths', sys.path)
  ext = kwargs.get('ext', '')
  if ext and not ext.startswith('.'): ext = '.' + ext
  if ext and not filename.endswith(ext): filename += ext

  if '/' in filename:
    try:
      return os.path.realpath(filename, strict=mustexist)
    except:
      return ''

  if not os.path.exists(filename):
    for path in searchpaths:
      # if not must exist, then default path is first entry in searchpaths[]
      if not mustexist:
        filename = f'{path}/{filename}'
        break
      if os.path.exists(f'{path}/{filename}'):
        filename = f'{path}/{filename}'
        break

  try:
    return os.path.realpath(filename, strict=mustexist)
  except:
    return ''


#end
