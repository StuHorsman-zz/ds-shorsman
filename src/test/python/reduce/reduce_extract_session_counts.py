#!/usr/bin/env python

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
    #   current_key - string containing session_id
    #   group - iterator yielding all items
    for current_key, group in groupby(data, itemgetter(0)):
        try:
            # Setup the session list
            sessionList = [0] * 19
            for k, v in group:
                            
                if 'Account' in v:
                    sessionList[0] += 1
                    
                if 'AddToQueue' in v:
                    sessionList[1] += 1
                    
                if 'Advance' in v:
                    sessionList[2] += 1
                
                if 'Home' in v:
                    sessionList[3] += 1
                    
                if 'Hover' in v:
                    sessionList[4] += 1
                    
                if 'ItemPage' in v:
                    sessionList[5] += 1
                    
                if 'Login' in v:
                    sessionList[6] += 1
                    
                if 'Logout' in v:
                    sessionList[7] += 1
                    
                if 'Pause' in v:
                    sessionList[8] += 1
                    
                if 'Play' in v:
                    sessionList[9] += 1
                    
                if 'Position' in v:
                    sessionList[10] += 1
                    
                if 'Queue' in v:
                    sessionList[11] += 1
                
                if 'Rate' in v:
                    sessionList[12] += 1
                    
                if 'Recommendations' in v:
                    sessionList[13] += 1
                    
                if 'Resume' in v:
                    sessionList[14] += 1
                    
                if 'Search' in v:
                    sessionList[15] += 1
                    
                if 'Stop' in v:
                    sessionList[16] += 1
                
                if 'VerifyPassword' in v:
                    sessionList[17] += 1
                
                if 'WriteReview' in v:
                    sessionList[18] += 1
                
            print '%s%s%s' % (current_key, "\t", "\t".join(map(str, sessionList)))
                            
        except ValueError:
            # count was not a number, so silently discard this item
            pass

if __name__ == "__main__":
    main()
