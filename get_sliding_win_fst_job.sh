#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=2:58:00
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=get_sliding_win_fst_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in file name 1 without "saf.idx" ending (to provide saf files)
NAME1=$1

# type in file name 2 without "saf.idx" ending (to provide saf files)
NAME2=$2

# number of threads used in angsd
NUM_THREADS=$3

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

realSFS \
fst \
stats2 \
"${NAME1}"_"${NAME2}".fst.idx \
-fold 1 \
-win 1000 \
-step 500 \
-P $NUM_THREADS \
> "${NAME1}"_"${NAME2}"_win_1kb_step_500b.sliding_window


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

