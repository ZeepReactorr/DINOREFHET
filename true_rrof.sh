#!/bin/bash

rm -rf ~/RROF/RROF_success_8
mkdir ~/RROF/RROF_success_8

minimap2 -c -k 12 -w 4 ~/RROF/idplus.fasta ~/RROF/idplus.fasta -X > ~/RROF/RROF_success_8/minimap_output.paf

racon -q 10 ~/RROF/idplus.fasta ~/RROF/RROF_success_8/minimap_output.paf ~/RROF/idplus.fasta > ~/RROF/RROF_success_7/racon_0.fasta

for i in $(seq 0 0);
do
	declare -i PREC=$i-1
	echo $PREC
	minimap2 -x splice ~/RROF/RROF_success_3/racon_$PREC.fasta ~/RROF/RROF_success_3/racon_$PREC.fasta -X > ~/RROF/RROF_success_3/minimap_output$i.paf
	
	racon -q 7  ~/RROF/RROF_success_3/racon_$PREC.fasta ~/RROF/RROF_success_3/minimap_output$i.paf ~/RROF/RROF_success_3/racon_$PREC.fasta > ~/RROF/RROF_success_3/racon_$i.fasta
done

assembly-stats ~/RROF/RROF_success_8/racon_0.fasta >> ~/RROF/RROF_success_8/stats.txt
assembly-stats ~/to_compare/epi2me_consensus/fastq_transcriptome.fas >> ~/RROF/RROF_success_8/stats.txt

cd ~/RROF/RROF_success_8/ || exit

dnadiff ~/to_compare/epi2me_consensus/fastq_transcriptome.fas ~/RROF/RROF_success_8/racon_0.fasta

