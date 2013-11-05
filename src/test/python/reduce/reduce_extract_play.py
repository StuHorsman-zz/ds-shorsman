#!/usr/bin/env python

from operator import getitem
from operator import itemgetter
from itertools import groupby
import sys

def read_mapper_output(file, separator='\t'):
    for line in file:
        yield line.rstrip().split(separator, 1)

def main(separator='\t'):
    # input comes from STDIN (standard input)
    data = read_mapper_output(sys.stdin, separator=separator)
    
    # groupby groups multiple user_id sessions pairs by user_id,
    # and creates an iterator that returns consecutive keys and their group:
    #   current_key - string containing the concatenated key (user_id, session_id)
    #   group - iterator yielding all items
    for current_key, group in groupby(data, itemgetter(0)):
        try:
            key_list = current_key.split(',')
            user_id = key_list[0]
            session_id = key_list[1]
            
            # Loop through the items in group and extract created_at and action type
            for i in group:
                value_list = getitem(i, 1).split(',')
                created_at = value_list[0]
                action = value_list[1]
                movie_id = value_list[2]
                # print out the sessionised output
                print '%s\t%s\t%s\t%s\t%s' % (user_id, created_at, action, movie_id, session_id)
                
        except ValueError:
            # count was not a number, so silently discard this item
            pass

if __name__ == "__main__":
    main()
