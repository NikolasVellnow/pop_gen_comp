#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0-07:58:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=7G
#SBATCH --job-name=NGSadmix_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in input beagle file with .gz ending
INPUT_BEAGLE=$1

# type in output file prefix
OUT=$2

# number of threads used in angsd
NUM_THREADS=$3


# k-value to start with
K_START=$4

# k-value to start with
K_STOP=$5

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

# execute NGSadmix for different k-values
for K in `seq $K_START $K_STOP`
do
    echo $K
    NGSadmix \
    -likes ${INPUT_BEAGLE} \
    -K ${K} \
    -o ${OUT}_k${K}_${SLURM_JOBID} \
    -P ${NUM_THREADS} \
    -seed 123
    
done



conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

