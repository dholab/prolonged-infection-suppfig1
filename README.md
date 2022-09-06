# Intrahost SARS-CoV-2 Variant Analysis - Halfmann and Minor et al. 2022, Supplemental Figure 1

## Overview

In [Halfmann and Minor et al. 2022, _Evolution of a globally unique SARS-CoV-2 Spike E484T monoclonal antibody escape mutation in a persistently infected, immunocompromised individual_](https://www.medrxiv.org/content/10.1101/2022.04.11.22272784v1), we document an extraordinary case of prolonged, SARS-CoV-2 infection within a single host, which lasted nearly 500 days. While viral infections are normally summarized with consensus sequences, which collapse the viral population's genetic diversity into a single sequence, viruses can undergo rapid evolutionary diversification within a host. This diversification can be especially pronounced after antiviral treatments, which, like antibiotics with bacteria, can set the stage for an evolutionary arms race between the pathogen and the host.

To explore how the virus's within-host diversity changed after treatment with the Bamlanivimab monoclonal antibody, we re-sequenced all twelve timepoints on an Illumina MiSeq instrument, which has fewer sequencing errors that can prevent us from detecting low-frequency nucleotide variants. Raw Illumina reads for all timepoints have been deposited at SRA BioProject PRJNA836936. This pipeline handles processing, analysis, and visualization of these reads.

To do so, the pipeline automates the 3 major steps of our analysis:

1. Download reads from SRA.
2. Quality-control, identify mutations, and annotate protein effects in the Illumina reads.
3. Visualize these mutations over the course of the nearly 500 day infection.

## Quick Start

This pipeline requires a small handful of preinstalled utilities: NextFlow, Docker, git, R, and the R libraries Tidyverse and Biostrings. If these utilities are already installed on your machine, simply clone the pipeline into a directory of your choice, like so:

```
git clone https://github.com/dholab/prolonged-infection-suppfig1.git .
```

And then, in the workflow directory you chose, run:

```
bash run_pipeline.sh
```

If you do not have the aforementioned utilities installed, proceed to the following detailed instructions.

## Detailed Instructions

As above, our first step will be to run `git clone`, which will bring the workflow files into your directory of choice:

```
git clone https://github.com/dholab/prolonged-infection-suppfig1.git .
```

Next, make sure you have the Docker Engine installed. To install Docker, simply visit the Docker installation page at [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/).

### Nextflow Installation

This workflow uses the [NextFlow](https://www.nextflow.io/) workflow manager. We recommend you install NextFlow to your system in one of the two following ways:

#### 1) Installation with Conda

1. Install the miniconda python distribution, if you haven't already: [https://docs.conda.io/en/latest/miniconda.html](https://docs.conda.io/en/latest/miniconda.html)
2. Install the `mamba` package installation tool in the command line, if not already installed:
   `conda install -y -c conda-forge mamba`
3. Install Nextflow to your base environment:
   `mamba install -c bioconda nextflow `

#### 2) Installation with curl

1. Run the following line in a directory where you'd like to install NextFlow, and run the following line of code:
   `curl -fsSL https://get.nextflow.io | bash`
2. Add this directory to your $PATH. If on MacOS, a helpful guide can be viewed [here](https://www.architectryan.com/2012/10/02/add-to-the-path-on-mac-os-x-mountain-lion/).

To double check that the installation was successful, type `nextflow -v` into the terminal. If it returns something like `nextflow version 21.04.0.5552`, you are ready to proceed.

### Running the workflow

With the pipeline file bundle cloned, Docker installed, and NextFlow installed, you are ready to reproduce our findings. To do so, simply change into the workflow directory and run the following in the BASH terminal:

```
bash run_pipeline.sh
```

This script will run the pipeline, step by step.

### Step-by-step Run

If the above script produces errors, or you would like to oversee the pipeline as each step runs, you may run each step yourself, as follows.

#### Step 1: Download Reads from Sequence Read Archive

```
nextflow run 1_download_fastqs/sc2_read_downloader.nf
```

#### Step 2: Run ViralRecon

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

#### Step 3: Run iSNV PlotteR

```
nextflow run 3_plot_data/prolonged_infection_suppfig1.nf \
--input_data '2_viralrecon/results/' \
-w 3_plot_data/work
```

## Troubleshooting

The pipeline nf-core/viralrecon is resource intensive, and may encounter a number of snags depending on what resources are available on your system and how you have Docker configured. See `2_viralrecon/README.md` for our recommendations on this.
