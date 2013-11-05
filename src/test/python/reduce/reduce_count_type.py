#!/usr/bin/env python

from operator import itemgetter
import sys

current_movie_key = None
current_count = 0
movie_key = None

# input comes from STDIN
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    movie_key, count = line.split('\t', 1)

    # convert count (currently a string) to int
    try:
        count = int(count)
    except ValueError:
        # count was not a number, so silently
        # ignore/discard this line
        continue

    # this IF-switch only works because Hadoop sorts map output
    # by key (here: word) before it is passed to the reducer
    if current_movie_key == movie_key:
        current_count += count
    else:
        if current_movie_key:
            # write result to STDOUT
            print '%s\t%s' % (current_movie_key, ",", current_count)
        current_count = count
        current_movie_key = movie_key

# do not forget to output the last word if needed!
if current_movie_key == movie_key:
    print '%s\t%s' % (current_movie_key, ",", current_count)