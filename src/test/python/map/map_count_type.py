#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    newline = json.loads(line)
    # print type so we can understand the spread of the data
    print '%s\t%s' % (newline['type'], 1)
