#!/usr/bin/python3
import os
import subprocess

args=[ 'atexit', 'datetime', 'json', 'openai', 'os', 'random', 're', 'readline', 'shutil', 'subprocess', 'sys', 'textwrap', 'time', 'pynput', 'colorama' ] 
for arg in args:
    if arg in [ 'sys','os','math','time','random','json','re','string','argparse','datetime','collections','itertools','functools','contextlib','urllib','logging','pdb','types','weakref','abc','fractions','heapq','bisect','copy','pprint','enum','statistics' ]:
        continue
    print(arg)


#    try:
#        subprocess.run(["pip", 'install', arg])
#    except: print('error')
    

