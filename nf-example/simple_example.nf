#!/usr/bin/env nextflow

params.fasta = "$baseDir/data/*.fa"
params.results = "$baseDir/results"

fasta = Channel.fromPath(params.fasta)

process reverse {
    input:
        file(fa) from fasta

    output:
        file("*.reversed.fa") into reverse_fasta

    script:
        """
        reverse.py $fa
        """
}
