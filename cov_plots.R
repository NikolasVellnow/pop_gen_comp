rm(list=ls())
library (qqman)
library(ggplot2)
library(plyr)

setwd("~/sciebo/Postdoc TU Dortmund/pop_gen_comp")
c_m <- read.table(gzfile("coverage_7_males_33062548.txt"), header = T)
c_m$chrom_name <- as.factor(c_m$rname)
c_m$chrom_name <- revalue(c_m$chrom_name,
                          c(NC_031768.1="1",
                            NC_031769.1="2",
                            NC_031770.1="3",
                            NC_031771.1="4",
                            NC_031772.1="4A",
                            NC_031773.1="1A",
                            NC_031774.1="5",
                            NC_031775.1="6",
                            NC_031776.1="7",
                            NC_031777.1="8",
                            NC_031778.1="9",
                            NC_031779.1="10",
                            NC_031780.1="11",
                            NC_031781.1="12",
                            NC_031782.1="13",
                            NC_031783.1="14",
                            NC_031784.1="15",
                            NC_031785.1="17",
                            NC_031786.1="18",
                            NC_031787.1="19",
                            NC_031788.1="20",
                            NC_031789.1="21",
                            NC_031790.1="22",
                            NC_031791.1="23",
                            NC_031792.1="24",
                            NC_031793.1="25LG1",
                            NC_031794.1="25LG2",
                            NC_031795.1="26",
                            NC_031796.1="27",
                            NC_031797.1="28",
                            NC_031799.1="Z",
                            NC_031798.1="LGE22",
                            NC_040875.1="MT"
                          ))

c_m$mean_depth <- c_m$meandepth/7

c_f <- read.table(gzfile("coverage_7_females_33062549.txt"), header = T)
c_f$chrom_name <- as.factor(c_f$rname)

c_f$chrom_name <- revalue(c_f$chrom_name,
                        c(NC_031768.1="1",
                        NC_031769.1="2",
                        NC_031770.1="3",
                        NC_031771.1="4",
                        NC_031772.1="4A",
                        NC_031773.1="1A",
                        NC_031774.1="5",
                        NC_031775.1="6",
                        NC_031776.1="7",
                        NC_031777.1="8",
                        NC_031778.1="9",
                        NC_031779.1="10",
                        NC_031780.1="11",
                        NC_031781.1="12",
                        NC_031782.1="13",
                        NC_031783.1="14",
                        NC_031784.1="15",
                        NC_031785.1="17",
                        NC_031786.1="18",
                        NC_031787.1="19",
                        NC_031788.1="20",
                        NC_031789.1="21",
                        NC_031790.1="22",
                        NC_031791.1="23",
                        NC_031792.1="24",
                        NC_031793.1="25LG1",
                        NC_031794.1="25LG2",
                        NC_031795.1="26",
                        NC_031796.1="27",
                        NC_031797.1="28",
                        NC_031799.1="Z",
                        NC_031798.1="LGE22",
                        NC_040875.1="MT"
                        ))


c_f$mean_depth <- c_f$meandepth/7

########### merge male and female dataframes #######

c_mf <- merge(c_m, c_f,
                 by=c("rname",
                      "startpos",
                      "endpos",
                      "chrom_name"),
                 suffix = c("_m", "_f"))


######## look at all chromosomes and unplaced scaffolds ##########
# number of reads
corr_reads <- ggplot(c_mf,
                     aes(y = numreads_m,
                         x = numreads_f,
                         label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=0, vjust=0)
corr_reads

# number of covered bases
corr_covbases <- ggplot(c_mf,
                        aes(y = covbases_m,
                            x = covbases_f,
                            label = chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=0, vjust=0)
corr_covbases

# percentage of covered bases
corr_coverage <- ggplot(c_mf,
                        aes(y = coverage_m,
                            x = coverage_f,
                            label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_coverage

# mean depth
corr_meandepth <- ggplot(c_mf,
                        aes(y = mean_depth_m,
                            x = mean_depth_f)) +
    geom_abline(intercept = 0, slope = 1) +
    ylim(0,16000) +
    xlim(0,16000) +
    geom_point()
corr_meandepth

# mean base quality in covered region
corr_meanbaseq <- ggplot(c_mf,
                         aes(y = meanbaseq_m,
                             x = meanbaseq_f)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point()
corr_meanbaseq

# mean mapping quality of selected reads
corr_meanmapq <- ggplot(c_mf,
                         aes(y = meanmapq_m,
                             x = meanmapq_f)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point()
corr_meanmapq


######## look only at all "major" chromosomes ##########

cc_mf <- c_mf[1:33,]

# number of reads
corr_reads <- ggplot(cc_mf,
                     aes(y = numreads_m,
                         x = numreads_f,
                         label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_reads

# number of covered bases with depth >=1
corr_covbases <- ggplot(cc_mf,
                     aes(y = covbases_m,
                         x = covbases_f,
                         label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_covbases

# percentage of covered bases
corr_coverage <- ggplot(cc_mf,
                        aes(y = coverage_m,
                            x = coverage_f,
                            label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_coverage



# percentage of covered bases
corr_coverage <- ggplot(cc_mf,
                        aes(y = coverage_m,
                            x = coverage_f,
                            label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_coverage


# mean depth of coverage (excluding MT and Z)
corr_meandepth <- ggplot(cc_mf[1:31,],
                        aes(y = mean_depth_m,
                            x = mean_depth_f,
                            color=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    ylab("mean depth males") +
    xlab("mean depth females") +
    #geom_text(hjust=-0.5, vjust=1) +
    xlim(40,58) +
    ylim(40,58) +
    theme(legend.position='none')

corr_meandepth

library(plotly)

ggplotly(corr_meandepth, show.legend = FALSE)



# mean base quality in covered region
corr_meanbaseq <- ggplot(cc_mf[1:31,],
                         aes(y = meanbaseq_m,
                             x = meanbaseq_f,
                             label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_meanbaseq

# mean mapping quality of selected reads
corr_meanmapq <- ggplot(cc_mf[1:31,],
                         aes(y = meanmapq_m,
                             x = meanmapq_f,
                             label=chrom_name)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=1)
corr_meanmapq
