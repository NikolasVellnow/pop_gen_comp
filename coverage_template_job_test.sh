#!/bin/bash -l

# Name of input bam file
INBAM=$1

echo $INBAM

# Directory for output
OUTDIR=$2

#FILENAME=${INBAM%.bam*}
FILENAME=$(basename "$INBAM" .bam)
echo $FILENAME

# create output directory if it doesn't exist yet
if [ ! -d "$OUTDIR" ]; then
mkdir "$OUTDIR"
fi

T0=$(date +%T)
echo "Start data processing:"
echo $T0

#conda activate samtools

samtools coverage "${INBAM}" > ${OUTDIR}${FILENAME}_cov.txt

#"${OUTDIR}"${FILENAME}_cov.txt
#conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

