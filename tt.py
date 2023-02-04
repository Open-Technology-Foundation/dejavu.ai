import os
import sys

from std import file_get_contents, file_put_contents, \
                EDITOR, BROWSER, \
                int_list, is_numeric, \
                useColor, printinfo, printerr, printstd, printUseColor
#from colorama import init, Fore, Back, Style
#init()
#from markdown import markdownFromFile
#import random
cmdTypeAhead = []
if True:
  if True:
    file = 'example-script'

    #file = sys.argv.pop(0)
    if not '.dv' in file: file += '.dv'
    if not os.path.exists(file):
      if not '/' in file: file = UserHome + '/' + file
      if not os.path.exists(file):
        printerr('File \''+file+'\' does not exist.')
        exit()

    lne = file_get_contents(file)
    Lines = lne.split('\n')
    lne   = ''
    while len(Lines) > 0:
      line = Lines.pop(0).rstrip()
      if not line: continue
      if line[0] == '#': continue
      # handle \ line continuations
      if line[-1] == '\\': lne += line[0:-1]; continue

      lne += line.rstrip('\r\n')
      if not lne: lne=''; continue
      
      if lne[0] == '!':
        tok = lne.split()
        if tok[0] == '!prompt' and len(tok) > 1:
          if tok[1] != '"""': 
            cmdTypeAhead.append('!prompt '+' '.join(tok[1:]))
            lne = ''
            continue
          prompt = ''
          while len(Lines) > 0:
            line = Lines.pop(0).rstrip()
            if line == '"""':
              cmdTypeAhead.append('!prompt '+prompt)
              break
            prompt += line + '\\n'
        else:
          cmdTypeAhead.append(' '.join(tok))
        lne = ''
        continue
      cmdTypeAhead.append(lne)
      lne = ''
    lne = lne.rstrip('\r\n')
    if lne: cmdTypeAhead.append(lne)
    lne = ''
#printinfo('[start '+file+']')
printinfo('\n'.join(cmdTypeAhead), prefix='')
#printinfo('[end]')
