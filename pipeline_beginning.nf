params.reads = " "
params.out = ""
params.bowtie_index = "$baseDir/data/db/FN433596"
params.cpus = 3

outDir = file(params.out)

readChannel = Channel.fromFilePairs("${params.reads}/*{1,2}.{fastq,fq}.gz").ifEmpty { exit 1, "Cannot find any reads file in ${params.reads}" }

process mapping {

    conda "bioconda::bowtie2=2.3.4.2"

    cpus params.cpus
    publishDir "$outDir", mode: 'copy'

    input:
    set pair_id, file(reads) from readChannel

    output:
    set pair_id, file("*.sam") into mappingChannel

    script:
    """
    bowtie2 -q -1 ${reads[0]} -2 ${reads[1]} -x ${params.bowtie_index} -S ${pair_id}.sam -p ${task.cpus} --very-sensitive-local
    """
}
