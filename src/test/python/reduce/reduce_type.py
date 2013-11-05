#!/usr/bin/env python

import sys

# input comes from STDIN
for line in sys.stdin:
    
    # remove leading and trailing whitespace
    line = line.strip()
    
    # split the line.  first 3 elements are key, 
    # the rest are all values
    data = line.split('\t')
    key = '\t'.join(data[:3])
    values = '\t'.join(data[3:])
        
    # parse the input we got from mapper.py
    print '%s\t%s' % (key, values)

    
