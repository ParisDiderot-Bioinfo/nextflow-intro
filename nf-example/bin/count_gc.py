#!/usr/bin/env python3

import argparse

def get_args():
    '''
    This function parses and return arguments passed in
    '''
    parser = argparse.ArgumentParser(
    prog='count_gc.py',
    description='Compute GC percent of sequence in fasta file')
    parser.add_argument('fasta', help="path to fasta input file")

    args = parser.parse_args()

    infile = args.fasta

    return(infile)

def gc_sequence(sequence):
    seqlen = len(str(sequence))
    gc = 0
    for base in str(sequence):
        if base.upper() == "G" or base.upper() == "C":
            gc += 1
    if gc > 0:
        print("GC content : "+ str(round(gc/seqlen*100,2)) + "%")
        return("GC content : "+ str(round(gc/seqlen*100,2)) + "%")
    else:
        print("GC content : 0%")
        return("GC content : 0%")

def get_basename(filename):
    dotsplit = filename.split(".")
    if len(dotsplit) == 1 :
        basename = filename
    else:
        basename = ".".join(dotsplit[:-1])
    return(basename)

if __name__ == "__main__":
    INFILE = get_args()
    OUTFILE = get_basename(INFILE)+".gc.txt"

    with open(INFILE, "r") as f:
        with open(OUTFILE, "w") as fw:
            for line in f:
                line = line.rstrip()
                if line.startswith(">"):
                    print(line)
                    fw.write(line+"\n")
                else:
                    fw.write(gc_sequence(line)+"\n")
