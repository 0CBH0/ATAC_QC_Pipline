#!/bin/bash
f=$1
src="/md01/xuyc7/data/RTT/"
dst="/md01/xuyc7/test/"
genome="/md01/xuyc7/library/GRCm38.p6.genome"
annotation="/md01/xuyc7/library/gencode.vM23.annotation.gtf"
sfxa="_combined_R1.fastq.gz"
sfxb="_combined_R2.fastq.gz"
f=$(ls "$src"*_R1.fastq.gz | awk -v p="$sfxa" '{sub(p,"",$1); print $1}' | awk -v p="$src" '{sub(p,"",$1);print $1}' | uniq | awk 'NR=='"$f"'{print $0}')
fastp --detect_adapter_for_pe -i "$src""$f""$sfxa" -I "$src""$f""$sfxb" -o "$dst""$f"_R1.filter.fastq -O "$dst""$f"_R2.filter.fastq -j "$dst""$f".json -h "$dst""$f".html
bowtie2 -p 8 --very-sensitive -x "$genome" -1 "$dst""$f"_R1.filter.fastq -2 "$dst""$f"_R2.filter.fastq | samblaster --excludeDups --addMateTags | samtools view -F 4 -u - | samtools sort -@ 8 -o "$dst""$f".bam -
samtools index "$dst""$f".bam
ATACFragQC -i "$dst""$f".bam -r "$annotation" -o -m C
