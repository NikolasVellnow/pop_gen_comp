#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0-07:58:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=get_HWE_with_angsd_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in output file name
OUT=$2

# number of threads used in angsd
NUM_THREADS=$3


T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

angsd \
-b $SAMPLE_LIST \
-rf all_chroms_excl_Z_mt_LGE22.txt \
-doHWE 1 \
-minHetFreq 0.0 \
-doMajorMinor 1 \
-GL 1 \
-doMaf 1 \
-minMapQ 30 \
-minQ 20 \
-SNP_pval 1e-6 \
-out ${OUT}_${SLURM_JOBID} \
-P $NUM_THREADS


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

