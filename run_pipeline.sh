#!/bin/bash

echo ------------------------------------
echo DOWNLOADING FASTQ FILES FROM SEQUENCE READ ARCHIVE
echo AND CREATING SAMPLE SHEETS FOR EACH PRIMER SET
echo ------------------------------------

nextflow run 1_download_fastqs/sc2_read_downloader.nf && \
Rscript 2_viralrecon/scripts/samplesheet_maker.R \
$(pwd)/1_download_fastqs/resources/samplesheet.csv \
$(pwd)/1_download_fastqs/reads/ \
$(pwd)/2_viralrecon/ && \
echo SAMPLE SHEETS ARE MADE AND READY FOR VARIANT ANALYSIS

echo ------------------------------------
echo NOW RUNNING NF-CORE/VIRALRECON TO IDENTIFY LOW-
echo FREQUENCY VARIANTS IN ILLUMINA ARTIC V4.1 SAMPLES
echo ------------------------------------

nextflow run nf-core/viralrecon \
--input 2_viralrecon/illumina_articv4.1_samplesheet.csv \
--outdir 2_viralrecon/results/articv41/ \
--platform illumina \
--protocol amplicon \
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 4.1 \
--skip_assembly \
--max_cpus "4" \
--max_memory "16 GB" \
-w 2_viralrecon/work/ \
-profile docker

echo ------------------------------------
echo NOW RUNNING NF-CORE/VIRALRECON TO IDENTIFY LOW-
echo FREQUENCY VARIANTS IN ILLUMINA ARTIC V3 SAMPLES
echo ------------------------------------

nextflow run nf-core/viralrecon \
--input 2_viralrecon/illumina_articv3_samplesheet.csv \
--outdir 2_viralrecon/results/articv3/ \
--platform illumina \
--protocol amplicon \
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 3 \
--skip_assembly \
--max_cpus "4" \
--max_memory "16 GB" \
-w 2_viralrecon/work/ \
-profile docker

echo ------------------------------------
echo NF-CORE/VIRALRECON COMPLETE. NOW PLOTTING THE RESULTS
echo ------------------------------------

nextflow run 3_plot_data/prolonged_infection_suppfig1.nf \
--input_data '2_viralrecon/results/' \
-w 3_plot_data/work
