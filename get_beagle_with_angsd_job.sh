#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0-07:58:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=7G
#SBATCH --job-name=get_beagle_with_angsd_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in output file name
OUT=$2

# number of threads used in angsd
NUM_THREADS=$3

# path to reference genome
PATH_REF=/home/mnikvell/Desktop/work/data/genomes/refseq/vertebrate_other/GCF_001522545.3/GCF_001522545.3_Parus_major1.1_genomic.fna


T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

angsd \
-b $SAMPLE_LIST \
-rf only_Z.txt \
-doMajorMinor 1 \
-doMaf 1 \
-out ${OUT}_${SLURM_JOBID} \
-anc $PATH_REF \
-GL 1 \
-doGlf 2 \
-SNP_pval 1e-6 \
-minMapQ 30 \
-minQ 20 \
-P $NUM_THREADS

conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

