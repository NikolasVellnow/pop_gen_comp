#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:58:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=get_sfs_per_chrom_with_angsd_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of chromosomes to be analyzed
CHROM_LIST=$1

# type in file name without "saf.idx" ending (to provide saf files)
NAME=$2

# number of threads used in angsd
NUM_THREADS=$3

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

while read line
do
    CHROM_NAME=$line
    echo $CHROM_NAME
    
    realSFS \
    "${NAME}".saf.idx \
    -maxIter 100 \
    -fold 1 \
    -r $CHROM_NAME \
    -P $NUM_THREADS \
    > "${NAME}"_"${CHROM_NAME}".sfs
done <$CHROM_LIST

conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

