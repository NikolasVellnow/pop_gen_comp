#!/bin/bash -l
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=2-00:00:00 
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --job-name=depth_sliding_wins_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All



# type in path to python script
PY_SCRIPT=$1

# type in path to data file with coverage values for all positions
DATA_FILE_PATH=$2

# type in output file name with .gz ending
OUT=$3

# type in window size
WIN_SIZE=$4

# type in window step size
STEP_SIZE=$5

DATA_FILE="$(basename -- $DATA_FILE_PATH)"

OUT_PATH=/scratch/mnikvell/depth_sliding_wins_job_${SLURM_JOBID}/

# create directories in scratch-dir
rm -rf /scratch/mnikvell/depth_sliding_wins_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/depth_sliding_wins_job_${SLURM_JOBID}/

T0=$(date +%T)
echo "Start copying data file:"
echo $T0

# copy data file
cp -a "${DATA_FILE_PATH}" "${OUT_PATH}"

T1=$(date +%T)
echo "Finished copying data file:"
echo $T1

# check content of scratch dir
ls "${OUT_PATH}"


python3 "${PY_SCRIPT}" -i "${OUT_PATH}${DATA_FILE}" -ws "${WIN_SIZE}" -st "${STEP_SIZE}" -o "${OUT}"


# copy outputs back to
cp -a "${OUT_PATH}." /"work/mnikvell/scripts/pop_gen_comp/"
rm -rf "${OUT_PATH}"



