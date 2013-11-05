#!/usr/bin/env python

import sys
import re
import json

for line in sys.stdin:
    line = line.strip()
    newline = json.loads(line)
    # print type(newline.keys()) and print(newline.keys()
    # can be used to understand the data
    # This is used to understand the data
    print '%s\t%s' % (newline.keys(), 1)  
