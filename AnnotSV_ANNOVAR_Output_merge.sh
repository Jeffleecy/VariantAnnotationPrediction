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

TIME=`date +%Y%m%d%H%M`
logfile=./${TIME}_${ID}_run.log
exec 3<&1 4<&2
exec >$logfile 2>&1
set -euo pipefail
set -x

# update your files path here
module add pkg/Anaconda3
gene_list="./input/gene_list.txt" 
sample_para_list="./input/sample_para_list.txt"
data_folder='./input'
output="./output/merging_output.txt"
# reference_version only hg38 or hg19
reference_version='hg19'


# Execution
python  AnnotSV_ANNOVAR_data_merge.py -g ${gene_list} -para_list ${sample_para_list} -dfolder ${data_folder} -o ${output} -ref ${reference_version}
