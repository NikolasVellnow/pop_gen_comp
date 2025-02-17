#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:58:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=coverage_template_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# Name of input bam file
INBAM=$1

echo $INBAM

# Directory for output
OUTDIR=$2

FILENAME=$(basename "$INBAM" .bam)
echo $FILENAME

# create output directory if it doesn't exist yet
if [ ! -d "$OUTDIR" ]; then
mkdir "$OUTDIR"
fi

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate samtools

samtools coverage -d 0 "${INBAM}" > ${OUTDIR}${FILENAME}_cov.txt

conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

