#!/usr/bin/sh
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SAMPLE_NAME         # Job name
#SBATCH -p ngs48G           # Partition Name 
#SBATCH -c 14               # Core numbers
#SBATCH --mem=46g           # Memory size
#SBATCH -o out.log          # Path to the standard output file 
#SBATCH -e err.log          # Path to the standard error ouput file
#SBATCH --mail-user=@gmail.com    # email
#SBATCH --mail-type=FAIL              # When to send an email = NONE, BEGIN, END, FAIL, REQUEUE, or ALL

### Please define the following variables
INPUT="/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/TestData/T_N_variants_hg38.vcf.gz"
wkdir=/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/ANNOVAR
para="SAMPLE_NAME_github_ANNOVAR_hg38"

### DO NOT CHANGE
REF=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg38/Homo_sapiens_assembly38.fasta
ANNOVAR="/opt/ohpc/Taiwania3/pkg/biology/ANNOVAR/annovar_20210819/table_annovar.pl"
humandb="/staging/reserve/paylong_ntu/AI_SHARE/reference/annovar_2016Feb01/humandb/"


cd ${wkdir}
mkdir -p ${wkdir}
cd ${wkdir}
TIME=`date +%Y%m%d%H%M`
logfile=./${TIME}_${para}_run.log
exec 3<&1 4<&2
exec >$logfile 2>&1
set -euo pipefail
set -x

/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools norm -m- $INPUT -O z -o ${wkdir}/${para}.decom_hg38.vcf.gz
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools norm -f $REF ${wkdir}/${para}.decom_hg38.vcf.gz -O z -o ${wkdir}/${para}.decom_hg38.norm.vcf.gz

$ANNOVAR ${wkdir}/${para}.decom_hg38.norm.vcf.gz $humandb -buildver hg38 -out ${para} -remove -protocol refGene,cytoBand,knownGene,ensGene,gnomad30_genome,avsnp150,gnomad211_exome,intervar_20180118,clinvar_20210501,dbnsfp41a,icgc28,revel -operation gx,r,gx,gx,f,f,f,f,f,f,f,f -nastring . -vcfinput -polish
head -n 1 ${para}.hg38_multianno.txt > ${para}.filtered_annotation.txt
grep -e exonic -e splicing ${para}.hg38_multianno.txt | grep -P -v "\tsynonymous" | grep -P -v "\tncRNA_exonic\t" >> ${para}.filtered_annotation.txt
rm ${para}.avinput ${para}.decom_hg38.norm.vcf.gz ${para}.decom_hg38.vcf.gz ${para}.hg38_multianno.vcf
