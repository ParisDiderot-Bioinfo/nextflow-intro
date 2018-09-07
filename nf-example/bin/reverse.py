#!/usr/bin/env python3

import argparse

def get_args():
    '''
    This function parses and return arguments passed in
    '''
    parser = argparse.ArgumentParser(
    prog='reverse.py',
    description='reverse DNA sequence in fasta file')
    parser.add_argument('fasta', help="path to fasta input file")

    args = parser.parse_args()

    infile = args.fasta

    return(infile)

def reverse_sequence(sequence):
    return(sequence[::-1])

def get_basename(filename):
    dotsplit = filename.split(".")
    if len(dotsplit) == 1 :
        basename = filename
    else:
        basename = ".".join(dotsplit[:-1])
    return(basename)

if __name__ == "__main__":
    INFILE = get_args()
    OUTFILE = get_basename(INFILE)+".reversed.fa"

    with open(INFILE, "r") as f:
        with open(OUTFILE, "w") as fw:
            for line in f:
                line = line.rstrip()
                if line.startswith(">"):
                    fw.write(line+"\n")
                else:
                    fw.write(reverse_sequence(line)+"\n")
