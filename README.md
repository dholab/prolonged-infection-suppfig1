# Intrahost SARS-CoV-2 Variant Analysis - Halfmann et al. 2022, Supplemental Figure 1

## Overview

In [Halfmann et al. 2022, _Evolution of a globally unique SARS-CoV-2 Spike E484T monoclonal antibody escape mutation in a persistently infected, immunocompromised individual_](https://www.medrxiv.org/content/10.1101/2022.04.11.22272784v1), we document an extraordinary case of prolonged, SARS-CoV-2 infection within a single host, which lasted nearly 500 days. While viral infections are normally summarized with consensus sequences, which collapse the viral population's genetic diversity into a single sequence, viruses can undergo rapid evolutionary diversification within a host. This diversification can be especially pronounced after antiviral treatments, which, like antibiotics with bacteria, can set the stage for an evolutionary arms race between the pathogen and the host.

To explore how the virus's within-host diversity changed after treatment with the Bamlanivimab monoclonal antibody, we re-sequenced all twelve timepoints on an Illumina MiSeq instrument, which has fewer sequencing errors that can prevent us from detecting low-frequency nucleotide variants. Raw Illumina reads for all timepoints have been deposited at SRA BioProject PRJNA836936. This pipeline handles processing, analysis, and visualization of these reads.

To do so, the pipeline automates the 3 major steps of our analysis:

1. Download reads from SRA.
2. Quality-control, identify mutations, and annotate protein effects in the Illumina reads.
3. Visualize these mutations over the course of the nearly 500 day infection.

## Quick Start

This pipeline requires a small handful of preinstalled utilities: NextFlow, Docker, git, R, and the R libraries Tidyverse and Biostrings. If these utilities are already installed on your machine, simply clone the pipeline into a directory of your choice, like so:

```
git clone https://github.com/nrminor/prolonged-infection-suppfig1.git .
```

And then, in the workflow directory you chose, run:

```
bash run_pipeline.sh
```

If you do not have the aforementioned utilities installed, proceed to the following detailed instructions.

## Detailed Instructions

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
nextflow run 3_plot_data/prolonged_infection_suppfig1.nf \
--input_data '2_viralrecon/results/' \
-w 3_plot_data/work
```

## Troubleshooting
