
# type in path to text file with list of bam files
FILE=$1


T0=$(date +%T)
echo "Start data processing:"
echo $T0

while read line
do
    echo "$line"
    FILENAME=${line%.bam*}
    echo $FILENAME
    echo "bla" > ${FILENAME}_trimmed.bam
done <$FILE


T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"
