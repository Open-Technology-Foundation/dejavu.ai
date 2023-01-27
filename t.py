#!/usr/bin/python3
import os
import sys
import time
import random
import subprocess

PRG='dejavu.install'

import time
import random
import subprocess
REPOSITORY='https://github.com/GaryDean/dejavu.ai.git'
Verbose = True
tempdir = None

while len(sys.argv) > 0:
  arg = sys.argv.pop(0)
  if arg == "--pid":
    if len(sys.argv) > 0:
      print('pid')
      #subprocess.call(["kill", "-9", sys.argv.pop()], stdout=open(os.devnull, "w") )
  elif arg in ["-u", "--upgrade"]:
    tempdir = "/tmp/{0}-upgrade-{1}".format(PRG, random.randint(0, 9999))
    subprocess.call(["git", "clone", REPOSITORY, tempdir])
    subprocess.call([tempdir + "/" + PRG, "--pid", str(os.getpid()), "-{0}".format("v" if verbose_ else "q")])
    exit()
  elif arg in ["-v", "--verbose"]:
    Verbose = 1
  elif arg in ["-q", "--quiet"]:
    Verbose = 0
  elif arg in ["-h", "--help"]:
    print(PRG, '[-v|--verbose] [-q|--quiet] [-u|--upgrade] [TrainingFileName]');
    exit()
  else:
    TrainingFile = arg


