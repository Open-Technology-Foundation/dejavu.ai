import os
import sys
from colorama import init, Fore, Back, Style
init()

def printinfo(msg, suffix='# '):
  print(Style.DIM + suffix + msg + Style.RESET_ALL)

def cmdhelp():
  printinfo('DéjàVu System Commands')
  cmds = [
    [ '!status',           'Show status of current environment.' ],
    [ '!temperature [f]',  'Display or Set Temperature.', 'Valid value for f is 0.0 - 1.0' ],
    [ '!list [range]',     'List current conversation.', 'If range omitted, lists entire conversation.'],
    [ '!delete range',     'Delete conversation items.' ],
    [ '!prompt',           'Display current pre-conversation information.' ],
    [ '!summarize [what]', 'Where what can be prompt, conv, or all', 'Default is all.' ],
    [ '!save [file]',      'Save current conversation. If file is not specified', 'then saves to current conversation file.' ],
    [ '!exec [cmd...]',    'Execute a shell command.' ],
    [ '!exit',             'Exit DéjàVu.' ]
  ]
  for cmd in cmds:
    printinfo(format('%18s: %s' % (cmd[0], cmd[1])))
    cmd=cmd[2:]
    for cd in cmd:
      printinfo(format('%18s  %s' % ('', cd)))

cmdhelp()
# Print current parameters
#def cmdstatus(all=False):
#  def pp(pref, suff):
#    printinfo(format('%13s %s' % (pref+':', '{}'.format(suff))))
#  printinfo('DéjàVu GPT-3 Terminal vs '+ Version +' |  Enter ! for help.')
#  pp(   'Conv. File',  os.path.basename(ConvFile))
