#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:59:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=get_Taj_D_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in file name without ending (to provide saf files)
NAME=$2

# number of threads used in angsd
# NUM_THREADS=$3

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

thetaStat do_stat "${NAME}".thetas.idx -outnames $NAME


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

