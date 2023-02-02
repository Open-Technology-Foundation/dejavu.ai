import os
import sys
from colorama import init, Fore, Back, Style
init()
from markdown import markdownFromFile
import random

Back=[
  Back.BLACK,
  Back.RED,
  Back.GREEN,
  Back.YELLOW,
  Back.BLUE,
  Back.MAGENTA,
  Back.CYAN,
  Back.WHITE ]

for b in Back:
  print(Fore.WHITE+b+Style.NORMAL+'testing one two three'+Style.RESET_ALL)
  print(Fore.WHITE+b+Style.DIM+'testing one two three'+Style.RESET_ALL)

