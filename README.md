# ATAC_QC_Pipline
The shell script for QC of ATAC

## Requirement
* fastp (https://github.com/OpenGene/fastp)
* bowtie2 (https://github.com/BenLangmead/bowtie2)
* samblaster (https://github.com/GregoryFaust/samblaster)
* samtools (https://github.com/samtools/samtools)
* ATACFragQC (https://github.com/0CBH0/ATACFragQC)

## Script
~~~
# xxx is the name of fastq files
fastp --detect_adapter_for_pe -i <xxx_R1.fastq.gz> -I <xxx_R2.fastq.gz> -o temp.filter.fastq -O temp.filter.fastq
bowtie2 --very-sensitive -x <genome> -1 temp.filter.fastq -2 temp.filter.fastq | samblaster --excludeDups --addMateTags | samtools view -F 4 -u - | samtools sort -@ 8 -o <xxx.bam> -
samtools index <xxx.bam>
ATACFragQC -i <xxx.bam> -r <annotation.gtf> -o -m C
~~~
Or edit the header of example.sh to run the pipline automatically.
