#!/usr/bin/env python

import sys
from itertools import groupby
from operator import itemgetter

def read_mapper_output(map_output, separator='\t'):
    for line in map_output:
        yield line.rstrip().split(separator, 1)

def main(separator='\t'):
    # input comes from STDIN (standard input)
    data = read_mapper_output(sys.stdin, separator=separator)
    # groupby groups multiple key-values pairs by key,
    # and creates an iterator that returns consecutive keys and their group:
    # current_key - string containing the key
    # group - iterator yielding all values
    for current_key, group in groupby(data, itemgetter(0)):
        try:
            print "%s%s%d" % (current_key, separator, 0)
        except ValueError:
            # count was not a number, so silently discard this item
            pass

if __name__ == "__main__":
    main()
    
    
        
