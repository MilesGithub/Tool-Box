# Load sample information
SAMPLES = [line.strip().split("\t")[0] for line in open("data/samples.tsv") if line.strip()]

rule all:
    input:
        expand("results/counts/{sample}.counts.txt", sample=SAMPLES)

rule trim_reads:
    input:
        r1="data/raw_reads/{sample}_R1.fastq.gz",
        r2="data/raw_reads/{sample}_R2.fastq.gz"
    output:
        r1="results/trimmed_reads/{sample}_R1.trimmed.fastq.gz",
        r2="results/trimmed_reads/{sample}_R2.trimmed.fastq.gz"
    shell:
        "fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2}"

rule align_reads:
    input:
        r1="results/trimmed_reads/{sample}_R1.trimmed.fastq.gz",
        r2="results/trimmed_reads/{sample}_R2.trimmed.fastq.gz"
    output:
        "results/alignments/{sample}.bam"
    params:
        index="ref/genome_index"
    shell:
        "hisat2 -x {params.index} -1 {input.r1} -2 {input.r2} | samtools sort -o {output}"

rule count_reads:
    input:
        "results/alignments/{sample}.bam"
    output:
        "results/counts/{sample}.counts.txt"
    params:
        gtf="ref/annotations.gtf"
    shell:
        "featureCounts -a {params.gtf} -o {output} {input}"
