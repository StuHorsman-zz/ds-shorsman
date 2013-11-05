#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    newline = json.loads(line)
    # print newline['type'] and aggregate 
    print '%s\t%s' % (newline['type'], 1)
