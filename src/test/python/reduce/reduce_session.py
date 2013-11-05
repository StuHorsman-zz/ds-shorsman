#!/usr/bin/env python

import sys
from itertools import groupby
from operator import itemgetter

map_output = open("/home/stuart/ds-shorsman/data/weblog.session", "r")

def read_mapper_output(map_output, separator='\t'):
    for line in map_output:
        yield line.rstrip().split(separator, 1)
        
def groupby_even_odd(items):
    f = lambda x: 'even' if x % 2 == 0 else 'odd'
    gb = groupby(sorted(items, key=f), f)
    for k, items in gb:
        print '%s: %s' % (k, ','.join(map(str, items)))

def main(separator='\t'):
    # input comes from STDIN (standard input)
    data = read_mapper_output(map_output, separator=separator)
    
    #print list(data)
    
    for k, g in groupby(data, itemgetter(0)):
        mylist = map(str, g)
        print mylist[0]
    # groupby groups multiple key-values pairs by key,
    # and creates an iterator that returns consecutive keys and their group:
    # current_key - string containing the key
    # group - iterator yielding all values
    
#     groups = []
#     uniquekeys = []
#     #data = sorted(data, key=keyfunc)
#     for k, g in groupby(data, itemgetter(0)):
#         values = groups.append(list(g))      # Store group iterator as a list
#         print '%s' % (values)
        #uniquekeys.append(k)
#     
#     gb = groupby(data, itemgetter(0))
#     for k, items in gb:
#         #print '%s: %s' % (k, '\t'.join(map(str, items)))
#         mylist = map(str, items)
#         print mylist
#         #print '%s: %s' % (k, map(str, items))
#         #print type(items)
        
#         try:
#             #print "%s%s%s" % (current_key, '\t', ','.join(map(str, group)))
#                 print (map(str, group))
#             for i in group:
#                 print i[-1]
                            
#         except ValueError:
#             # count was not a number, so silently discard this item
#             pass
        

        
        #print groupby_even_odd(1,2,3,4,5,6,7,8,9)

if __name__ == "__main__":
    main()
