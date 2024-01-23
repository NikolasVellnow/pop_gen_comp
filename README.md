# Population genomics comparison Parus major
This is a collection of scripts to perform a population genomics comparison between egg samples from Bielefeld, Germany, vs. adult blood samples from across Europe. A range of standard population genomics measures will be calculated and compared.

## Relatedness
In order to calculate meaningful pop gen measures the individuals within our samples need not be related.
For this I used ngsRelate to caclulate pairwise measures of relatedness (Hedrick et al 2015) with the script `ngsrelate_job.sh`:
```sh
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
```

## Sexing
The sex of the samples (also the eggs) can be estimated by comparing the sequencing coverage at a "typical" autosome and the Z-chromsome. I used the script `cov_ratio_job.sh` to calculate the ratio of the coverage for these two chromosomes:

```sh
#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=06:30:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=300M
#SBATCH --job-name=cov_ratio_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in output file name
OUT=$2

# number of samples
NUM_SAMPLES=$3
((MAX_COL=$NUM_SAMPLES+2))


# number of threads used in samtools
NUM_THREADS=$4

touch $OUT

T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate samtools

# write header
#echo "sample\tcov_NC_031770.1\tcov_NC_031799.1\tratio_Z_over_3" > $OUT
echo -e "sample\tcov_mt_NC_040875.1\tcov_NC_031770.1\tcov_NC_031799.1\tratio_Z_over_3" > $OUT

# get average coverage for "typical" chromosome 3 = NC_031770.1 and Z chromosome
samtools depth -H -@ $NUM_THREADS -f $SAMPLE_LIST | \
awk 'NR==1{OFS=FS="\t";for (i=3;i<='"$MAX_COL"';i++) samples[i]=$i}\
$1=="NC_031770.1"{j++; for (i=3;i<='"$MAX_COL"';i++) sum_3[i]+=$i} \
$1=="NC_031799.1"{k++; for (i=3;i<='"$MAX_COL"';i++) sum_z[i]+=$i}\
$1=="NC_040875.1"{l++; for (i=3;i<='"$MAX_COL"';i++) sum_mt[i]+=$i}\
END{for(i=3;i<='"$MAX_COL"';i++) print samples[i]"\011"\
sum_mt[i]/(l+0.0001)"\011"\
sum_3[i]/(j+0.0001)"\011"\
sum_z[i]/(k+0.0001)"\011"\
(sum_z[i]/(k+0.0001))/((sum_3[i]/(j+0.0001))+0.0001)}' >> $OUT


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

```

## Site frequency spectrum
For the following four analyses the site allele frequency likelihoods are needed. I generated them with angsd with the following script `get_saf_likelihoods_with_angsd_job.sh`:

```sh
#!/bin/bash -l
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0-16:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=get_saf_likelihoods_with_angsd_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of samples
SAMPLE_LIST=$1

# type in output file name
OUT=$2

# number of threads used in angsd
NUM_THREADS=$3

# path to reference genome
PATH_REF=/home/mnikvell/Desktop/work/data/genomes/refseq/vertebrate_other/GCF_001522545.3/GCF_001522545.3_Parus_major1.1_genomic.fna


T0=$(date +%T)
echo "Start data processing:"
echo $T0

conda activate angsd

angsd \
-b $SAMPLE_LIST \
#-rf regions_sfs.txt \
-doSaf 1 \
-out ${OUT}_${SLURM_JOBID} \
-anc $PATH_REF \
-GL 2 \
-minMapQ 30 \
-minQ 20 \
-P $NUM_THREADS


conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

``````

The outputs are a **.saf.gz** file, a **saf.pos.gz** file and a **saf.idx** file. These are binary files containing the allele frequency likelihoods, positions the blocks of data in the index file. 

