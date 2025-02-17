
# type in path to text file with list of bam files
FILE=$1


T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate samtools

while read line
do
    echo "$line"
    FILENAME=${line%.bam*}
    echo $FILENAME
    dorado trim $line | samtools fastq -@ 8 - | gzip > ${FILENAME}_trimmed.fastq.gz
done <$FILE

conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"
