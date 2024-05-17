#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0-07:58:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=depth_per_site_all_chroms_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in output file name without file ending
OUT=$2

# number of threads used in samtools depth
NUM_THREADS=$3

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate samtools

# write sequencing depth at every position to text file
samtools depth -H -@ $NUM_THREADS -f $SAMPLE_LIST -o ${OUT}_${SLURM_JOBID}.txt


gzip ${OUT}_${SLURM_JOBID}.txt


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

