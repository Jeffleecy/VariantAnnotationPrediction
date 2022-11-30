# Variant annotation and prediction
 
## Description 
 This repository includes the codes used in:
1. annotating VCF files using the [ANNOVAR](https://annovar.openbioinformatics.org/en/latest/) software 
2. annotating and ranking of human structural variations with [AnnotSV](https://lbgi.fr/AnnotSV/acknowledgments) software 
3. merging the annotation results from ANNOVAR and AnnotSV in a single file
4. predicting the effects of variants through [Ensembl Variant Effect Predictor (VEP)](https://asia.ensembl.org/info/docs/tools/vep/index.html)
 
## Dependencies
These codes are based on Python 3.10 and shell scripts and are executed in the Linux environment.
 
 
## Scripts
#### ANNOVAR_hg19.sh
   - Input: a VCF file of interest
   - Function: annotate the VCF file using ANNOVAR based on the hg19 reference genome
   - Output: a text file recording information on the variants investigated
   
#### ANNOVAR_hg38.sh
   - Input: a VCF file of interest
   - Function: annotate the VCF file using ANNOVAR based on the hg38 reference genome
   - Output: a text file recording information on the variants investigated

#### AnnotSV.sh
   - Input: a VCF file or a BED file with structural variants
   - Function: annotate the structural variants in the input file and rank them based on the joint consensus recommendation of ACMG and ClinGen ([Riggs et al., 2020](https://www.nature.com/articles/s41436-019-0686-8))
   - Output: a text file recording information on the variants investigated

#### AnnotSV_ANNOVAR_Output_merge.py
   - Function: merge the text files generated by ANNOVAR and AnnotSV in order to filter out the variants of interest more efficiently
   
#### AnnotSV_ANNOVAR_Output_merge.sh
#### Ensembl_VEP_hg19.sh
#### Ensembl_VEP_hg38.sh
