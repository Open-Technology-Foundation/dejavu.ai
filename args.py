#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import re

def main(argv):
    args = []
    verbose = 0
    cmd = ''
    Version = '0.3'
    while len(argv):
        arg = argv.pop(0).strip()
        if not arg: continue
        if arg in ('-c', '--cmd'):
            if len(argv) > 1: cmd = argv.pop(0)
        elif arg in ('-v', '--verbose'):
            verbose = 1
        elif arg in ('-q', '--quiet'):
            verbose = 0
        elif arg in ('-V', '--version'):
            print(Version)
            return 0
        elif arg in ('-h', '--help'):
            print('help')
            return 0
        elif re.match(r'^-[cvqVh]', arg):
            argv = [''] + ['-%s' % c for c in arg[1:]] + argv
        elif re.match(r'^--', arg):
            print('Invalid option %s' % arg, file=sys.stderr)
        elif arg[0:1] == '-':
            print('Invalid option %s' % arg, file=sys.stderr)
        else:
            print('adding args [', arg, ']')
            args.append(arg)

    if not len(args):
        print('No parameter specified.', file=sys.stderr)
#        return 1

    print(args)
    print('verbose', verbose)
    print('cmd', cmd)
    print('ver', Version)
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
