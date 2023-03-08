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


def is_terminal(stream) -> bool:
  """ Is there a terminal attached? """
  if not hasattr(stream, 'isatty'): return False
  if not stream.isatty(): return False
  return True


useColor = is_terminal(sys.stdout)
def UseColor(color: bool=None) -> bool:
  """ Print in Color or Not flag. """
  global useColor
  if color is not None:
    useColor = color
    if useColor: init()
    else: deinit()
    print(Style.RESET_ALL, end='')
  return useColor

ScreenColumns, ScreenRows = get_terminal_size()
def getScreenColumns() -> int:
  """ Get current screen columns. """
  global ScreenColumns, ScreenRows
  ScreenColumns, ScreenRows = get_terminal_size()
  return ScreenColumns
def getScreenRows() -> int:
  """ Get current screen columns. """
  global ScreenColumns, ScreenRows
  ScreenColumns, ScreenRows = get_terminal_size()
  return ScreenRows


def printerr(*args, **kwargs):
  """
  printerr(*args, prefix='!!', sep='\n', end='', back=Black.BLACK,
      color=Fore.RED, style=Style.NORMAL)
  """
  # global useColor
  prefix = kwargs.get('prefix', '!! ')
  sep = kwargs.get('sep', '\n')
  if useColor: print(kwargs.get('back', Back.BLACK) + kwargs.get('color', Fore.RED) + kwargs.get('style', Style.NORMAL), sep='', end='', file=sys.stderr)
  for arg in args:
    if prefix: print(prefix, end='', file=sys.stderr)
    print(arg, sep, end='', file=sys.stderr)
  if useColor: print(Style.RESET_ALL, sep='', end='', file=sys.stderr)


def printinfo(*args, **kwargs):
  """
  printinfo(*args, prefix='# ', sep='\n', end='', back=Black.BLACK,
      color=Fore.WHITE, style=Style.DIM)
  """
  # global useColor
  prefix = kwargs.get('prefix', '# ')
  sep = kwargs.get('sep', '\n')
  if useColor: print(kwargs.get('back', Back.BLACK) + kwargs.get('color', Fore.WHITE) + kwargs.get('style', Style.DIM), sep='', end='')
  for arg in args:
    if prefix: print(prefix, end='')
    print(arg, sep, end='')
  if useColor: print(Style.RESET_ALL, sep='', end='')


def printstd(*args, **kwargs):
  """
  printstd(*args, prefix='', sep='\n', end='', back=Black.BLACK,
      color=Fore.WHITE, style=Style.NORMAL)
  """
  # global useColor
  prefix = kwargs.get('prefix', '')
  sep = kwargs.get('sep', '\n')
  if useColor: print(kwargs.get('back', Back.BLACK) + kwargs.get('color', Fore.WHITE) + kwargs.get('style', Style.NORMAL), sep='', end='')
  for arg in args:
    if prefix: print(prefix, end='')
    print(arg, sep, end='')
  if useColor: print(Style.RESET_ALL, sep='', end='')


def printlog(*args, **kwargs):
  """
  printlog(*args, prefix='', sep='\n', end='', back=Black.BLACK,
      color=Fore.WHITE, style=Style.NORMAL)
  """
  # global useColor, ScriptDir, ScriptName
  import time
  file = os.path.realpath(__file__)
  file = os.path.dirname(file) + '/dv.log'
  file = kwargs.get('file', file)
  prefix = kwargs.get('prefix', str(time.time())+': ')
  sep = kwargs.get('sep', '\n')
  for arg in args:
    writefile(file, prefix+arg+sep, 'a', 'utf-8')

def readfile(filepath: str, encoding: str='utf-8') -> str:
  """ Read contents of filename into string. """
  with open(filepath, 'r', encoding=encoding) as infile:
    return infile.read()

def writefile(filename: str, string: str, mode: str='w', encoding: str='utf-8') -> str:
  """ Write string to filename. """
  with open(filename, mode, encoding=encoding) as f:
    f.write(string)


def tempname(label: str='tmp', ext:str ='.tmp') -> str:
  """ Return a temporary dirname/filename located in TMPDIR or /tmp. """
  tmpdir = os.getenv('TMPDIR')
  if not tmpdir: tmpdir = '/tmp'
  os.makedirs(tmpdir, exist_ok=True)
  rand = random.randint(11420, 99420)
  base = os.path.basename(__file__)
  # return "{0}/dv-{1}-{2}{3}".format(tmpdir, label, , ext)
  return f"{tmpdir}/{base}-{label}-{rand}{ext}"


def tokenize(cmd_line: str, sep=[' ','\t']) -> list:
  """ command line tokenizer """
  tokens = []
  curr_token = ''
  q_mark = None
  for c in cmd_line:
    if c == '"' or c == "'":
      if q_mark is None:
        q_mark = c
      elif q_mark == c:
        q_mark = None
      else:
        curr_token += c
    elif c in sep and q_mark is None:
      if curr_token:
        tokens.append(curr_token)
        curr_token = ''
    else:
      curr_token += c
  if curr_token:
    tokens.append(curr_token)
  return tokens


def escstr(string: str) -> str:
  """ Escape \n\t\r in string. """
  return string.replace('\n', '\\n').replace('\r', '\\r').replace('\t', '\\t')


def is_num(string: str) -> bool:
  """ Is this string a number? """
  try:
    float(string)
    return True
  except ValueError:
    return False


def url_split(url: str):
  """ split url into protocol, host, path """
  protocol, remainder = url.split("://")
  host, path = remainder.split("/", 1)
  return protocol, host, path


def int_list(input_string, minVal: int, maxVal: int, revSort: bool=False):
  """ Return an ordered list of numbers. """
  range_list = []
  if isinstance(input_string, (list, tuple)):
    string = ','.join(input_string).strip()
  else:
    string = input_string.strip()
  string = string.replace(' ', ',').replace(',,', ',').strip(',').lower()
  try:
    numlist = string.split(',')
    for numC in numlist:
      if len(numC.strip()) == 0: continue
      if numC.strip() == 'all':
        numC = str(minVal) + '-' + str(maxVal)
      if '-' in numC:
        stnum, endnum = numC.split('-')
        if len(stnum) == 0:   stnum = int(minVal)
        if len(endnum) == 0:  endnum = int(maxVal)
        stnum, endnum = int(stnum), int(endnum)
        if stnum < minVal or endnum > maxVal:
          printerr(f'Error: out of range {stnum:d}-{endnum:d}')
          continue
        range_list += range(stnum, endnum + 1)
      else:
        if int(numC) < minVal or int(numC) > maxVal: continue
        range_list.append(int(numC))
  except Exception as e:
    printerr('Error in int_list', str(e))
    return False
  if len(range_list) == 0:
    return False
  range_list = list(set(range_list))
  range_list.sort()
  if revSort:
    return range_list[::-1]
  return range_list


SHELL = ''
def getShell() -> str:
  """ Define SHELL to use. """
  global SHELL
  SHELL = os.environ.get('SHELL').strip()
  if not SHELL: SHELL = '/bin/bash'
  os.environ['SHELL'] = SHELL
  return SHELL
getShell()

HOME = ''
def getHome() -> str:
  """ Define HOME to use. """
  global HOME
  HOME = os.environ.get('HOME').strip()
  if not HOME: HOME = os.getcwd()
  os.environ['HOME'] = HOME
  return HOME
getHome()

USER = ''
def getUser() -> str:
  """ Define SHELL to use. """
  global USER
  USER = os.environ.get('USER')
  if len(USER) == 0: USER = os.getenv('LOGNAME')
  if len(USER) == 0: USER = os.getenv('USERNAME')
  if len(USER) == 0: USER = os.getenv('USER_NAME')
  if not USER: USER = 'USER'
  os.environ['USER'] = USER.strip()
  return USER
getUser()

EDITOR = ''
def getEditor() -> str:
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
def getBrowser() -> str:
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


def initHistory(filename: str, ext: str='.history') -> str:
  """ readline() history file +atExit """
  historyFile = os.path.dirname(filename) + '/.' + os.path.basename(filename) + ext
  try:
    readline.read_history_file(historyFile)
    readline.set_history_length(200)
  except FileNotFoundError:
    writefile(historyFile, '')
  atexit.register(readline.write_history_file, historyFile)
  return historyFile


def copy_files_recursive(src_dir: str, dest_dir: str, wildcard: str='*', **kwargs) -> bool:
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


def get_directories(path:str='./', recursive=False) ->list:
  directories = []
  try:
    for item in os.listdir(path):
      item_path = os.path.join(path, item)
      if os.path.isdir(item_path):
          directories.append(item_path)
          if recursive:
            directories.extend(get_directories(item_path))
  except:
    pass
  return sorted(directories)


def input_key(key_prompt, keys=['y', 'n'], abortwith=['n']):
  """
  script = 'text.dv'
  key = input_key(f'Edit/Run {script}?', ['3-4', '6-9', 'e', 'r'], ['q','0'])
  """
  valid_keys = abortwith
  for k in keys:
    if '-' in k and (k[0] >= '0' and k[0] <= '9'):
      min_val, max_val = k.split('-')
      for n in range(int(min_val), int(max_val)+1):
        valid_keys.append(str(n))
    else:
      valid_keys.append(k)
  try:
    while (
        key_select := input(f'{key_prompt} {"/".join(keys)}: ')
      ) not in valid_keys:
      pass
  except KeyboardInterrupt:
    key_select = abortwith[0]
    print('^C', file=sys.stderr)
  except Exception as e:
    printerr(e)
    pass
  return key_select


def selectList(itemlist, sel_prompt, truncate=0):
  maxlen = max(len(x) for x in itemlist)
  if truncate and maxlen > truncate:
    maxlen = truncate
  numpad = len(str(maxlen))
  totalpad = maxlen + numpad + 3
  ScreenColumns = getScreenColumns() - 1
  numrows = math.ceil(len(itemlist) / int(ScreenColumns / totalpad))
  output = [''] * numrows
  row = 0
  for index, item in enumerate(itemlist):
    if row == numrows: row = 0
    output[row] += (f'{index+1:{numpad}d}. {item[0:maxlen]}').ljust(totalpad, ' ')
    row += 1
  print('\n'.join(output))
  selection = 0
  key = input_key(sel_prompt, [f'1-{len(itemlist)}', 'q'], ['q','0'])
  if key in ['q', '0']: return ''
  selection = int(key)
  return itemlist[selection - 1]


def getfiles(dirs: str='.', globule: str='*', **kwargs):
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
      farr = '.' + farr[len(pwdfiles):]
    elif farr.startswith(HOME):
      farr = '~' + farr[len(HOME):]
    get_files.append(farr)
  get_files.sort()
  return get_files


# pylint: disable=too-many-locals
def selectFile(dirs: str, globule: str='*', selprompt: str='Select File: ', **kwargs) -> str:
  """ Select a file from a list. """
  dfiles = getfiles(dirs, globule, shorten=kwargs.get('shorten', True))
  if len(dfiles) == 0:
    printerr('No files found.')
    return ''
  dfile = selectList(dfiles, selprompt)
  if len(dfile) == 0: return ''
  return os.path.realpath(os.path.expanduser(dfile))


def find_file(filename: str, **kwargs) -> str:
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
      filename = os.path.realpath(filename)
      if mustexist and not os.path.exists(filename): return ''
      return filename
    except Exception:
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
    filename = os.path.realpath(filename)
    if mustexist and not os.path.exists(filename): return ''
    return filename
  except:
    return ''


# end
