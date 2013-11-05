#!/usr/bin/env python

import sys
import json

# input comes from STDIN (standard input)
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # test if the line can be loaded.  if not, catch 
    # exception and dump the record
    try:
        jsonline = json.loads(line)
    except ValueError:
        # write the results to STDOUT (standard output);
        # what we output here will be the input for the
        # Reduce step, i.e. the input for reducer.py
        #
        # tab-delimited; the trivial word count is 1
        print '%s\t%s' % (line, "")   

