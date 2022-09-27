#!/usr/local/bin/python3
import argparse

if __name__ == '__main__':
    PARSER = argparse.ArgumentParser(description="Converts a word into an FST")
    PARSER.add_argument('word', help='a word')
    args = PARSER.parse_args()
    
    for i,c in enumerate(args.word):
        print("%d %d %s %s" % (i, i+1, c, c) )
    print(i+1)
