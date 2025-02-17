#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:58:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=get_sfs_with_angsd_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All


# type in file name without "saf.idx" ending (to provide saf files)
NAME=$1

# number of threads used in angsd
NUM_THREADS=$2

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

realSFS "${NAME}".saf.idx -maxIter 100 -fold 1 -P $NUM_THREADS > "${NAME}".sfs


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

