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
INPUT="/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/TestData/DF_Fid.vqsr_SNP_INDEL.hc.recaled.vcf.gz"
wkdir="/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/ANNOVAR/"
para="github_ANNOVAR_hg19"

### DO NOT CHANGE
REF="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta"
ANNOVAR="/opt/ohpc/Taiwania3/pkg/biology/ANNOVAR/annovar_20210819/table_annovar.pl"
humandb="/staging/reserve/paylong_ntu/AI_SHARE/reference/annovar_2016Feb01/humandb"

cd ${wkdir}
mkdir -p ${wkdir}
cd ${wkdir}
TIME=`date +%Y%m%d%H%M`
logfile=./${TIME}_${para}_run.log
exec 3<&1 4<&2
exec >$logfile 2>&1
set -euo pipefail
set -x

/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools norm -m- $INPUT -O z -o ${wkdir}/${para}.decom_hg19.vcf.gz
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools norm -f $REF ${wkdir}/${para}.decom_hg19.vcf.gz -O z -o ${wkdir}/${para}.decom_hg19.norm.vcf.gz

$ANNOVAR ${wkdir}/${para}.decom_hg19.norm.vcf.gz $humandb -buildver hg19 -out ${para} -remove -protocol refGene,cytoBand,knownGene,ensGene,gnomad211_genome,avsnp150,TaiwanBiobank-official,gnomad211_exome,TWB1496_AF_final,intervar_20180118,clinvar_20210501,cosmic_coding_GRCh37_v92,cosmic_noncoding_GRCh37_v92,icgc28,dbnsfp41a,cg69,kaviar_20150923,dbscsnv11,spidex,gwava,tfbsConsSites,wgRna,targetScanS -operation gx,r,gx,gx,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput -polish
head -n 1 ${para}.hg19_multianno.txt > ${para}.filtered_annotation.txt
#grep -P "\texonic\t" ${para}.hg19_multianno.txt | grep -P -v "\tsynonymous" >> ${para}.filtered_annotation.txt
grep -e exonic -e splicing ${para}.hg19_multianno.txt | grep -P -v "\tsynonymous" | grep -P -v "\tncRNA_exonic\t" >> ${para}.filtered_annotation.txt
#done</work2/u1067478/Annotation/CGMH_AML/CGMH_AML_NameList.txt
rm ${para}.avinput ${para}.decom_hg19.norm.vcf.gz ${para}.decom_hg19.vcf.gz ${para}.hg19_multianno.vcf
