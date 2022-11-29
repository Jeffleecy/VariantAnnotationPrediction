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

# BASIC INFO
INPUT_PATH="/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/DRAGEN/NTUH_Deafness/202209_hg38_graph_WGS/DE7456"
sample_list=/staging/biology/u1272905/Jeff_Variants_2022/SV_AnnotSV/WS_SampleList.txt
OUTPUT_PATH="/staging/biology/u1272905/Jeff_Variants_2022/SV_AnnotSV/WS_wkdir"
hg="hg38_alt"
#-----------------------------------------------------------------------------------------------------------------------------------

# TOOL PATH
source /opt/ohpc/Taiwania3/pkg/biology/AnnotSV/AnnotSV_v3.0.9/env.sh
export PATH=/opt/ohpc/Taiwania3/pkg/biology/BEDTOOLS/BEDTOOLS_v2.29.1/bin/:$PATH
export PATH=/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/:$PATH
AnnotSV=/opt/ohpc/Taiwania3/pkg/biology/AnnotSV/AnnotSV_v3.0.9/bin/AnnotSV
#gnomad=/work2/lynn88065/Software/Download #v.21

while read -r ID ;
do
        echo "Now is processing ${ID}_${hg}"

        mkdir -p $OUTPUT_PATH/${ID}_${hg}
        cd $OUTPUT_PATH/${ID}_${hg}
        TIME=`date +%Y%m%d%H%M`
        logfile=./${TIME}_${para}_run.log
        exec 3<&1 4<&2
        exec >$logfile 2>&1
        set -euo pipefail
        set -x

        # "use SV / CNV / Repeats VCF to run AnnotSV"
            SV_VCF=$INPUT_PATH/${ID}_dragen_v4.0.3_hs38DH_graph.sv.vcf.gz
           CNV_VCF=$INPUT_PATH/${ID}_dragen_v4.0.3_hs38DH_graph.cnv.vcf.gz
        REPEAT_VCF=$INPUT_PATH/${ID}_dragen_v4.0.3_hs38DH_graph.repeats.vcf.gz

        # run AnnotSV
        $AnnotSV -SVinputFile $SV_VCF    -bedtools bedtools -genomeBuild GRCh38 -metrics us -outputDir $OUTPUT_PATH/${ID}_${hg} -outputFile ${ID}_${hg}_sv.sorted.vcf.annotSV.output.tsv >& AnnotSV_sv.log

        $AnnotSV -SVinputFile $CNV_VCF   -bedtools bedtools -genomeBuild GRCh38 -metrics us -outputDir $OUTPUT_PATH/${ID}_${hg} -outputFile ${ID}_${hg}_cnv.sorted.vcf.annotSV.output.tsv >& AnnotSV_cnv.log

        $AnnotSV -SVinputFile $REPEAT_VCF  -bedtools bedtools -genomeBuild GRCh38 -metrics us -outputDir $OUTPUT_PATH/${ID}_${hg}  -outputFile ${ID}_${hg}_repeats.sorted.vcf.annotSV.output.tsv >& AnnotSV_repeats.log

done<$sample_list

echo "Finish ${ID}_${hg}"
