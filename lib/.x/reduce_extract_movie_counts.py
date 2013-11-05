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
            movie_id = key_list[1]
            total_count = sum(int(count) for current_key, count in group)
            print "%s%s%s%s%d" % (user_id, separator, movie_id, separator, total_count)
        except ValueError:
            # count was not a number, so silently discard this item
            pass

if __name__ == "__main__":
    main()
    
