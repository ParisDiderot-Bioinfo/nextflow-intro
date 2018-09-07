#!/usr/bin/env nextflow

params.fasta = "$baseDir/data/subset/*.fa"
params.results = "$baseDir/results"
params.blastdb = "$baseDir/data/db/ecoliK12"

fasta = Channel.fromPath(params.fasta)
fa2blast = Channel.fromPath(params.fasta)

process reverse {
    tag "$fa"

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

    tag "$fa"

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
    tag "$fa"

    input:
        file(fa) from reverse_complement_fasta

    output:
        file("*.gc.txt") into gc_out

    script:
        """
        count_gc.py $fa
        """
}

process concat {
    publishDir "${params.results}/gc", mode: 'copy'

    input:
        file(gc) from gc_out.collect()

    output:
        file("summary.txt") into summary

    script:
        """
        cat *.gc.txt > summary.txt
        """
}

process blast {
    tag "$fa"

    publishDir "${params.results}/blast", mode: 'copy'

    conda 'bioconda::blast'

    input:
        file(fa) from fa2blast

    output:
        file("*.out") into blast_result

    script:
        outfile = fa.baseName+".out"
        """
        blastn -db ${params.blastdb} -query $fa -out $outfile -outfmt 6
        """
}
