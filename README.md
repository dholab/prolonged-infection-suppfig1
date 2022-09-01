### Step 1: Download Reads from Sequence Read Archive

```
nextflow run 1_download_fastqs/sc2_read_downloader.nf
```

### Step 2: Run ViralRecon

Run samplesheet maker script:
```
Rscript 2_viralrecon/scripts/samplesheet_maker.R \
$(pwd)/1_download_fastqs/resources/samplesheet.csv \
$(pwd)/1_download_fastqs/reads/ \
$(pwd)/2_viralrecon/
```

Run on ARTIC v4.1 samples:
```
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
```

Run on ARTIC v3 sample:
```
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
```


### Step 3: Run iSNV PlotteR

```
nextflow run 3_plot_data/prolonged_infection_suppfig1.nf --input_data '2_viralrecon/results/' -w 3_plot_data/work
```
