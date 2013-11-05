#!/usr/bin/env python

import sys

# input comes from STDIN
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    
    # parse the input we got from mapper.py
    print '%s\t%s' % (line, "")