#!/bin/bash -l
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=ngsrelate_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in output file name with file extension (e.g. ".txt")
OUT=$2

# number of samples
NUM_SAMPLES=$3

# number of threads used in angsd and ngsrelate
NUM_THREADS=$4

touch $OUT

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

angsd \
-b $SAMPLE_LIST \
-rf all_chroms_excl_Z_mt_LGE22.txt \
-gl 2 \
-domajorminor 1 \
-snp_pval 1e-6 \
-domaf 1 \
-minmaf 0.05 \
-doGlf 3 \
-P $NUM_THREADS \
-out angsdput_relatedness_${SLURM_JOBID}

zcat angsdput_relatedness_${SLURM_JOBID}.mafs.gz | cut -f5 | sed 1d > freqs_${SLURM_JOBID}

# create temp list of sample names to use in ngsrelate
cat $SAMPLE_LIST | \
grep -oP '(?<=/data/).*(?=bam)' | \
grep -oP '(?<=/).*(?=_)'| \
grep -oPi '^[a-z0-9]*' > sample_ids_${SLURM_JOBID}.txt



ngsRelate -p $NUM_THREADS -z sample_ids_${SLURM_JOBID}.txt -g angsdput_relatedness_${SLURM_JOBID}.glf.gz -n $NUM_SAMPLES -f freqs_${SLURM_JOBID} -O $OUT

rm sample_ids_${SLURM_JOBID}*
# rm freqs_${SLURM_JOBID}*
# rm angsdput_relatedness_${SLURM_JOBID}*

conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

