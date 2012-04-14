#!/usr/bin/env python

import sys, re

LINE_RE = re.compile(r'^([A-Z/]{2,4}) (\d{3})   (\d{5}) (.{1,31})\s*(\d)')

def parse_line(line):
    m = LINE_RE.match(line)
    if m is not None:
        return m.group(1,2,3,4,4)

def parse(fin, fout):
    for line in fin:
        res = parse_line(line)
        if res is not None:
            print res

if __name__ == '__main__':
    # get input file handle, stdin in none passed
    fin = sys.stdin if len(sys.argv) < 2 else open(sys.argv[1], 'r')
    
    # get output file handle, stdout if none passed
    fout = sys.stdout if len(sys.argv) < 3 else open(sys.argv[2], 'w')
    
    parse(fin, fout)

    
        
    
    
