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

process complement {
    input:
        file(fa) from reverse_fasta
    output:
        file("*.complement.fa") into reverse_complement_fasta

    script:
        """
        complement.py $fa
        """
}

process countGC {
    input:
        file(fa) from reverse_complement_fasta

    output:
        file("*.gc.txt") into gc_out
        stdout gc_result

    script:
        """
        count_gc.py $fa
        """
}

gc_result.subscribe { println it }
