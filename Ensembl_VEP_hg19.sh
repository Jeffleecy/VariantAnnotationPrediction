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


# Don't need to run vt, since the test example is known to be fine
INPUT_VCF_PATH=/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/TestData/T_N_variants_hs37d5.vcf.gz
OUTPUT_VCF_PATH=/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/VEP
SAMPLE_ID=github_VEP_hg19

cd $OUTPUT_VCF_PATH

date > out.log
$VEP_PATH/vep --cache --offline \
    --cache_version 104 \
    --assembly GRCh37 \
    --port 3337 \
    --dir_plugins $VEP_PLUGIN_DIR \
    --dir_cache $VEP_CACHE_DIR \
    -i $INPUT_VCF_PATH \
    --vcf \
    -o ${OUTPUT_VCF_PATH}/${SAMPLE_ID}.vcf \
    --everything \
    --check_existing \
    --plugin SpliceAI,snv=${PLUGIN_DATA}//spliceai_scores.raw.snv.hg19.vcf.gz,indel=${PLUGIN_DATA}/spliceai_scores.raw.indel.hg19.vcf.gz \
    --plugin LoFtool,${PLUGIN_DATA}/LoFtool_scores.txt \
    --plugin ExACpLI,${PLUGIN_DATA}/ExACpLI_values.txt \
    --plugin MPC,${PLUGIN_DATA}/fordist_constraint_official_mpc_values_v2.txt.gz \
    --plugin LOVD \
    --plugin FunMotifs,${PLUGIN_DATA}/blood.funmotifs_sorted.bed.gz,fscore,dnase_seq \
    --plugin PostGAP,${PLUGIN_DATA}/postgap_GRCh37.txt.gz,ALL \
    --plugin satMutMPRA,file=${PLUGIN_DATA}/satMutMPRA_GRCh37_ALL.gz,cols=ALL \
    --fork 10 \
    --force_overwrite

#--plugin FlagLRG,${PLUGIN_DATA}/list_LRGs_transcripts_xrefs.txt \


$VEP_PATH/vep --cache --offline \
    --cache_version 104 \
    --assembly GRCh37 \
    --port 3337 \
    --dir_plugins $VEP_PLUGIN_DIR \
    --dir_cache $VEP_CACHE_DIR \
    -i $INPUT_VCF_PATH \
    -o ${OUTPUT_VCF_PATH}/${SAMPLE_ID}.txt \
    --everything \
    --check_existing \
    --plugin SpliceAI,snv=${PLUGIN_DATA}//spliceai_scores.raw.snv.hg19.vcf.gz,indel=${PLUGIN_DATA}/spliceai_scores.raw.indel.hg19.vcf.gz \
    --plugin LoFtool,${PLUGIN_DATA}/LoFtool_scores.txt \
    --plugin ExACpLI,${PLUGIN_DATA}/ExACpLI_values.txt \
    --plugin MPC,${PLUGIN_DATA}/fordist_constraint_official_mpc_values_v2.txt.gz \
    --plugin LOVD \
    --plugin FunMotifs,${PLUGIN_DATA}/blood.funmotifs_sorted.bed.gz,fscore,dnase_seq \
    --plugin PostGAP,${PLUGIN_DATA}/postgap_GRCh37.txt.gz,ALL \
    --plugin satMutMPRA,file=${PLUGIN_DATA}/satMutMPRA_GRCh37_ALL.gz,cols=ALL \
    --fork 10 \
    --force_overwrite

#--plugin FlagLRG,${PLUGIN_DATA}/list_LRGs_transcripts_xrefs.txt \
