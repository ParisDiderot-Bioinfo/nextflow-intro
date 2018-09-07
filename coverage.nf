workflow.onComplete {
    //any worlflow property can be used here
    if ( workflow.success ) {
        println "Pipeline Complete"
    }
    println "Command line: $workflow.commandLine"
}

workflow.onError {
    println "Oops .. something went wrong"
}

params.reads = " "
params.out = ""
params.bowtie_index = ""
params.cpus = 3

outDir = file(params.out)

readChannel = Channel.fromFilePairs("${params.reads}/*{1,2}.{fastq,fq}.gz").ifEmpty { exit 1, "Cannot find any reads file in ${params.reads}" }

process mapping {
    cpus params.cpus
    publishDir "$outDir", mode: 'copy'
    
    input:
    set pair_id, file(reads) from readChannel
    
    output:
    set pair_id, file("*.sam") into mappingChannel
    
    shell:
    '''
    bowtie2 -q -1 !{reads[0]} -2 !{reads[1]} -x !{params.bowtie_index} -S !{pair_id}.sam -p !{params.cpus} --very-sensitive-local
    '''
}

process samtools_view {
    cpus params.cpus
    publishDir "$outDir", mode: 'copy'
    
    input:
    set pair_id, file(sam) from mappingChannel
    
    output:
    set pair_id, file("*.bam") into bamChannel
    
    shell:
    '''
    samtools view -b -@ !{params.cpus} -o !{pair_id}.bam !{sam}
    '''
}

process samtools_sort {
    cpus params.cpus
    publishDir "$outDir", mode: 'copy'
    
    input:
    set pair_id, file(bam) from bamChannel
    
    output:
    set pair_id, file("sorted*.bam") into sortbamChannel
    
    shell:
    '''
    samtools sort -@ !{params.cpus} -o sorted_!{pair_id}.bam !{bam}
    '''
}

process bedtools {
    publishDir "$outDir", mode: 'copy'
    
    input:
    set pair_id, file(sortbam) from sortbamChannel
    
    output:
    file("*.gcbout") into finishChannel
    
    shell:
    '''
    genomeCoverageBed -ibam !{sortbam} > !{pair_id}.gcbout
    '''
}
