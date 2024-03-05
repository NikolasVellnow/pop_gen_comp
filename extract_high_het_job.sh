#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:15:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=7G
#SBATCH --job-name=extract_high_het_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to hwe file with heterozygosity column
FILE=$1


T0=$(date +%T)
echo "Start data processing:"
echo $T0

FILENAME=$(basename "$FILE" .hwe.gz)
echo $FILENAME

zcat ${FILE} | awk '$10>0.90' | gzip > ${FILENAME}_high_het_sites.hwe.gz

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"
