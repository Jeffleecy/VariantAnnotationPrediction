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

source /work/opt/ohpc/Taiwania3/pkg/biology/Ensembl-VEP/Ensembl-VEP_v104.3/env.sh
export PATH=/opt/ohpc/Taiwania3/pkg/biology/HTSLIB/htslib_v1.13/bin/:$PATH
SOFTWARE=/work/opt/ohpc/Taiwania3/pkg/biology
REF=/staging/reserve/paylong_ntu/AI_SHARE/reference/VEP_ref
VEP_CACHE_DIR=${SOFTWARE}/DATABASE/VEP/Cache
VEP_PLUGIN_DIR=${SOFTWARE}/DATABASE/VEP/Cache/Plugins
PLUGIN_DATA=${VEP_CACHE_DIR}/Data_for_plugins
VEP_PATH=${SOFTWARE}/Ensembl-VEP/Ensembl-VEP_v104.3
VEP_FASTA=${REF}/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
ExACpLI_BAM=${REF}/GCF_000001405.38_GRCh38.p12_knownrefseq_alns.bam
#HTSLIB_PATH=/pkg/biology/HTSLIB/HTSLIB_v1.10.2/bin/
#export PATH=$HTSLIB_PATH:$PATH

#module load biology/Perl/default
#INPUT_VCF_PATH=/staging/reserve/paylong_ntu/AI_SHARE/reference/GIAB/NA12878_HG001/NISTv3.3.2/GRCh38/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_PGandRTGphasetransfer.vcf.gz
INPUT_VCF_PATH=/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/TestData/T_N_variants_hg38.vcf.gz
OUTPUT_VCF_PATH=/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/VEP
SAMPLE_ID=github_VEP_hg38

cd $OUTPUT_VCF_PATH

date > out.log
$VEP_PATH/vep --cache --offline \
    --cache_version 104 \
    --merged \
    --assembly GRCh38 \
    --port 3337 \
    --dir_plugins $VEP_PLUGIN_DIR \
    --dir_cache $VEP_CACHE_DIR \
    -i $INPUT_VCF_PATH \
    --vcf \
    -o ${OUTPUT_VCF_PATH}/${SAMPLE_ID}.vcf \
    --check_existing \
    --plugin SpliceAI,snv=${PLUGIN_DATA}/spliceai_scores.raw.snv.hg38.vcf.gz,indel=${PLUGIN_DATA}/spliceai_scores.raw.indel.hg38.vcf.gz \
    --plugin LoFtool,${PLUGIN_DATA}/LoFtool_scores.txt \
    --plugin ExACpLI,${PLUGIN_DATA}/ExACpLI_values.txt \
    --fasta $VEP_FASTA \
    --bam $ExACpLI_BAM \
    --fork 20 \
    --force_overwrite \
    --use_transcript_ref \
    --use_given_ref

date >> out.log
echo "Finished --vcf output"  >> out.log

$VEP_PATH/vep --cache --offline \
    --cache_version 104 \
    --merged \
    --assembly GRCh38 \
    --port 3337 \
    --dir_plugins $VEP_PLUGIN_DIR \
    --dir_cache $VEP_CACHE_DIR \
    -i $INPUT_VCF_PATH \
    -o ${OUTPUT_VCF_PATH}/${SAMPLE_ID}.txt \
    --everything \
    --check_existing \
    --plugin LoFtool,${PLUGIN_DATA}/LoFtool_scores.txt \
    --plugin ExACpLI,${PLUGIN_DATA}/ExACpLI_values.txt \
    --fasta $VEP_FASTA \
    --bam $ExACpLI_BAM \
    --plugin SpliceAI,snv=${PLUGIN_DATA}/spliceai_scores.raw.snv.hg38.vcf.gz,indel=${PLUGIN_DATA}/spliceai_scores.raw.indel.hg38.vcf.gz \
    --fork 20 \
    --force_overwrite \
    --use_transcript_ref \
    --use_given_ref

date >> out.log
echo "Finished txt output"  >> out.log
