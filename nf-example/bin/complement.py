#!/usr/bin/env python3

import argparse

def get_args():
    '''
    This function parses and return arguments passed in
    '''
    parser = argparse.ArgumentParser(
    prog='complement.py',
    description='complement DNA sequence in fasta file')
    parser.add_argument('fasta', help="path to fasta input file")

    args = parser.parse_args()

    infile = args.fasta

    return(infile)

def complement_sequence(sequence):
    comp_dict = {"A":"T", "T":"A", "G":"C", "C":"G"}
    comp_seq = ""
    for base in str(sequence):
        comp_seq += comp_dict[base]
    return(comp_seq)

def get_basename(filename):
    dotsplit = filename.split(".")
    if len(dotsplit) == 1 :
        basename = filename
    else:
        basename = ".".join(dotsplit[:-1])
    return(basename)

if __name__ == "__main__":
    INFILE = get_args()
    OUTFILE = get_basename(INFILE)+".complement.fa"

    with open(INFILE, "r") as f:
        with open(OUTFILE, "w") as fw:
            for line in f:
                line = line.rstrip()
                if line.startswith(">"):
                    fw.write(line+"\n")
                else:
                    fw.write(complement_sequence(line)+"\n")
