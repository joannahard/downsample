SAMPLES, = glob_wildcards("data/input/{smp}.reAligned.bwa.bam")


rule all:
    input:
        expand("data/output/temp/{smp}.sub.bwa.bam", smp=SAMPLES),
        expand("data/output/temp/{smp}.sub.sorted.bwa.bam", smp=SAMPLES),
        expand("data/output/temp/{smp}.sub.sorted.bwa.bam.bai", smp=SAMPLES)

rule samtools_downsample:
    input:
        "data/input/{smp}.reAligned.bwa.bam"
    output:
        temp("data/output/temp/{smp}.sub.bwa.bam")
    params:
        fraction = config["fraction"]
    shell:
        "samtools view -bs {params.fraction} {input} > {output}"


rule samtools_sort:
    input:
        "data/output/temp/{smp}.sub.bwa.bam"
    output:
        "data/output/temp/{smp}.sub.sorted.bwa.bam"
    shell:
        "samtools sort {input} -o {output}"


rule samtools_index:
    input:
        "data/output/temp/{smp}.sub.sorted.bwa.bam"
    output:
        "data/output/temp/{smp}.sub.sorted.bwa.bam.bai"
    shell:
        "samtools index {input}"
