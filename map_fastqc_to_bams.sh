#!/bin/bash -l
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=18:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=map_fastqc_to_bams_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of bam files
FILE=$1

NUM_THREADS=$2


T0=$(date +%T)
echo "Start data processing:"
echo $T0
conda activate base

while read line
do
    echo "$line"
    FILENAME=${line%.bam*}
    echo $FILENAME
    fastqc $line -t $2
done <$FILE


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"
