# type in path to text file with list of bam files
FILELIST=$1

# path to template script with file name
TEMPATH=$2

# Directory for output
OUTDIR=$3


T0=$(date +%T)
echo "Start data processing:"
echo $T0

while read line
do
    sbatch ${TEMPATH} ${line} ${OUTDIR}
done <$FILELIST

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

