#!/usr/local/bin/python3
from __future__ import print_function
import argparse
import sys
import re
import textwrap

vowel = [letra for letra in 'AEIOU']
consonant = [letra for letra in 'BCDFGHJKLMNPQRSTVWXYZ']
#vogcons = vowel + consonant
symbol = vowel + consonant + [letra for letra in '0']

usage_msg='''Examples of usage:
Consider the following transducer (without weights), written in our format
    0 1 vowel =
    1 3 symbol =
    1 4 [^A-EH-Z0] =
it will be converted into
    0 1 A A
    ...
    0 1 U U
    1 3 A A
    ...
    1 3 Z Z
    1 3 0 0
    1 4 F F
    1 4 G G

Consider fthe following transducer (with weights), written in our format
    0 2 consonant = 1.0
    1 3 [abc] = 0.8
it will be converted into
    0 2 B B 1.0
    0 2 C C 1.0
    ...
    0 2 Z Z 1.0
    1 3 A A 0.8
    1 3 B B 0.8
    1 3 C C 0.8

The symbol "=" indicates that the output will be the same as the input'''

def print_line(f, t, i, o, w=None):
    if o == "=": o = i
    if w == None:
        print("%s\t%s\t%s\t%s" % (f, t, i, o))
    else:
        print("%s\t%s\t%s\t%s\t%s" % (f, t, i, o, w))


def expand(line):
    cols = line.strip().split()
    if len(cols) == 1:
        print("%s" % cols[0])

    elif 4 <= len(cols) <= 5:
        weight = None
        if len(cols) == 5: weight = cols[4]

        if cols[2] == "vowel":
            for s in vowel:
                print_line(cols[0], cols[1], s, cols[3], weight)
        elif cols[2] == "consonant":
            for s in consonant:
                print_line(cols[0], cols[1], s, cols[3], weight)
        elif cols[2] == "symbol":
            for s in symbol:
                print_line(cols[0], cols[1], s, cols[3], weight)
        elif cols[2].startswith("["):  # Regular expression
            for s in symbol:
                if re.search(cols[2], s) != None:
                    print_line(cols[0], cols[1], s, cols[3], weight)
        else:
            print_line(cols[0], cols[1], cols[2], cols[3], weight)
    else:
        print("Error, incorrect number of colunms:", cols, file=sys.stderr)


if __name__ == '__main__':
    PARSER = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
        description="Converts an FST written in our compact notation into a nice FST that can be used by openfst",
        epilog=textwrap.dedent(usage_msg))
    PARSER.add_argument('file', help='input file')
    args = PARSER.parse_args()

    with open(args.file) as f:
        while True:
            line = f.readline()
            if line == '': break
            if not re.match("^\s*$",line): expand(line)
