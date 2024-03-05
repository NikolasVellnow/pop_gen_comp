#!/bin/bash -l
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=7G
#SBATCH --job-name=map_qualimap_to_bams_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of bam files
FILE=$1

NUM_THREADS=$2


T0=$(date +%T)
echo "Start data processing:"
echo $T0
conda activate quali

while read line
do
    echo "$line"
    FILENAME=$(basename "$line" .bam)
    echo $FILENAME
    qualimap bamqc \
    -bam $line \
    -c \
    -cl 150 \
    -ip \
    -nt $2 \
    -outfile ${FILENAME}_qualimap_${SLURM_JOBID}\
    --java-mem-size=40G
done <$FILE


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"
