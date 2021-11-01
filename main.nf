params.reads='s3://algaetranscriptomics/CHK17*_R{1,2}_001.fastq.gz'
geno='s3://hic.genome/PGA_scaffolds.fasta'
cdnas='s3://algaetranscriptomics/F0_ref_transcripts.fasta'

Channel
	.fromFilePairs(params.reads)
	.ifEmpty {error "Cannot find any reads matching: ${params.reads}"}
	.set { read_pairs_ch }
/*  
process Augustus {

	input:
	path genom from geno
	
	output:
	file 'aug.gtf' into abinitio
  file 'aug.codingseq' into cdnas
	
	"""
	augustus --species=chlorella --codingseq=on --softmasking=0 $genom > aug.gtf
	getAnnoFasta.pl aug.gtf
	
	"""
	

}
*/

process kallistoindex {

  input:
  path cdna from cdnas
  
  output:
  file 'cdna.index' into index
  
  """
  kallisto index $cdna -i cdna.index
  """
  
 }

process kallisto {

  memory '4G'

  input:
  tuple val(pair_id), path(reads) from read_pairs_ch
  path cdnaindex from index
  
  output:
  file "${pair_id}_mapped.tar.gz" into quantdir
  
  
  """
  kallisto quant -i $cdnaindex "${pair_id}_R1_001.fastq.gz" "${pair_id}_R2_001.fastq.gz" -b 1000 -o "${pair_id}_mapped"
  tar -zcvf "${pair_id}_mapped.tar.gz" "${pair_id}_mapped"
  
  """
  
 }
  



