#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(tidyverse)

old_samplesheet = read.csv(args[1])

for (i in unique(old_samplesheet$platform)){
  
  sub <- old_samplesheet[old_samplesheet$platform==i,]
  sub$primer_set <- str_remove_all(sub$primer_set, "resources/") %>%
    str_remove_all("_primers.bed")
  
  if (i == "illumina" &
      length(list.files(args[2], pattern = "*R2.fastq.gz")) > 0){
    
    for (j in unique(sub$primer_set)){
      
      primer_sub <- sub[sub$primer_set == j,]
      
      samples = data.frame("sample" = primer_sub$file_basename,
                           "fastq_1" = paste(args[2], "/", primer_sub$file_basename, "_R1.fastq.gz", sep = ""),
                           "fastq_2" = paste(args[2], "/", primer_sub$file_basename, "_R2.fastq.gz", sep = ""))
      
      write.csv(samples,
                paste(args[3], "/", tolower(i), "_", tolower(j), "_samplesheet.csv", sep = ""),
                quote = F, row.names = F)
      
    }
    
  } else {
    
    for (j in unique(sub$primer_set)){
      
      primer_sub <- sub[sub$primer_set == j,]
      
      samples = data.frame("sample" = primer_sub$file_basename,
                           "barcode" = row.names(primer_sub))
      
      write.csv(samples,
                paste(args[3], "/", tolower(i), "_", tolower(j), "_samplesheet.csv", sep = ""),
                quote = F, row.names = F)
      
    }
    
  }
  
}