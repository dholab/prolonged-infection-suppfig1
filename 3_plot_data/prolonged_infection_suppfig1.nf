#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.vcfs = params.input_data + '/**/*.snpeff.vcf.gz'

workflow {

	ch_vcfs = Channel // this channel streams in data on the timepoints sequenced on Illumina instruments
		.fromPath ( params.vcfs )
		. map { file -> tuple( file.simpleName, file )}
		
	ch_consensus_seqs = Channel.fromPath( params.consensus_seqs )
	
	UNZIP_RENAME (
		ch_vcfs
	)

	PLOT_SUPPFIG1 (
		UNZIP_RENAME.out.collect(),
		ch_consensus_seqs
	 )

}


process UNZIP_RENAME {
	
	tag "${timepoint}"
	
	input:
	tuple val(timepoint), path(vcf)
	
	output:
	path("*_ann.vcf")
	
	script:
	"""
	gunzip -c ${vcf} > ${timepoint}_ann.vcf
	"""
	
}

process PLOT_SUPPFIG1 {

	publishDir params.visuals, pattern: '*.pdf', mode: 'move'
	publishDir params.readables, pattern: '*.csv', mode: 'move'

	input:
	path(vcfs)
	path(consensus)

	output:
	file("*.pdf")
	file("*.csv")

	script:
	"""
	SupplementalFigure1_iSNV_frequency_plot.r
	"""

}
