rm(list=ls())
library (qqman)
library(ggplot2)
library(plyr)

setwd("~/sciebo/Postdoc TU Dortmund/pop_gen_comp")

######## 7 unrelated female eggs ##########
#f_1kb <- read.table(gzfile("test_out_win_1000_stef_500.csv.gz"), header = T)
f_10kb <- read.table(gzfile("hwe_female_eggs_win_10kb_step_5kb.csv.gz"), header = T)

f_10kb$chrom_name <- f_10kb$Chromo

f_10kb$chrom_name <- revalue(f_10kb$chrom_name,
                        c(NC_031768.1=1,
                          NC_031769.1=2,
                          NC_031770.1=3,
                          NC_031771.1=4,
                          NC_031772.1=4.5,
                          NC_031773.1=1.5,
                          NC_031774.1=5,
                          NC_031775.1=6,
                          NC_031776.1=7,
                          NC_031777.1=8,
                          NC_031778.1=9,
                          NC_031779.1=10,
                          NC_031780.1=11,
                          NC_031781.1=12,
                          NC_031782.1=13,
                          NC_031783.1=14,
                          NC_031784.1=15,
                          NC_031785.1=17,
                          NC_031786.1=18,
                          NC_031787.1=19,
                          NC_031788.1=20,
                          NC_031789.1=21,
                          NC_031790.1=22,
                          NC_031791.1=23,
                          NC_031792.1=24,
                          NC_031793.1=25.0,
                          NC_031794.1=25.5,
                          NC_031795.1=26,
                          NC_031796.1=27,
                          NC_031797.1=28
                        ))
f_10kb$chrom_name <- as.numeric(f_10kb$chrom_name)
f_10kb$SNP <- NA

f_10kb$chromosome <- revalue(f_10kb$Chromo,
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
                            NC_031797.1="28"
                          ))

f_high <- f_10kb[f_10kb$hetFreq>0.5,]


#f_sample <- f_high[sample(nrow(f_high), nrow(f_high)*0.01),]


one_chrom_f <- manhattan(subset(f_10kb, chrom_name == 25), chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          main = "7 females, window size = 10kb, step = 5kb")

one_chrom_f

all_chroms_f <- manhattan(f_10kb, chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          main = "7 females, window size = 10kb, step = 5kb")

all_chroms_f


#ggsave(file="het_7_females_win_10kb_step_5kb.pdf",
       #plot=all_chroms,
       #width=12,
       #height=5)



######## 7 unrelated male eggs ##########

m_10kb <- read.table(gzfile("hwe_male_eggs_win_10kb_step_5kb.csv.gz"),
                     header = T)

m_10kb$chrom_name <- m_10kb$Chromo

m_10kb$chrom_name <- revalue(m_10kb$chrom_name,
                        c(NC_031768.1=1,
                          NC_031769.1=2,
                          NC_031770.1=3,
                          NC_031771.1=4,
                          NC_031772.1=4.5,
                          NC_031773.1=1.5,
                          NC_031774.1=5,
                          NC_031775.1=6,
                          NC_031776.1=7,
                          NC_031777.1=8,
                          NC_031778.1=9,
                          NC_031779.1=10,
                          NC_031780.1=11,
                          NC_031781.1=12,
                          NC_031782.1=13,
                          NC_031783.1=14,
                          NC_031784.1=15,
                          NC_031785.1=17,
                          NC_031786.1=18,
                          NC_031787.1=19,
                          NC_031788.1=20,
                          NC_031789.1=21,
                          NC_031790.1=22,
                          NC_031791.1=23,
                          NC_031792.1=24,
                          NC_031793.1=25.0,
                          NC_031794.1=25.5,
                          NC_031795.1=26,
                          NC_031796.1=27,
                          NC_031797.1=28
                        ))
m_10kb$chrom_name <- as.numeric(m_10kb$chrom_name)

m_10kb$SNP <- NA

m_10kb$chromosome <- revalue(m_10kb$Chromo,
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
                               NC_031797.1="28"
                             ))

m_10kb_high <- m_10kb[m_10kb$hetFreq>0.5,]


#p_sample <- p_high[sample(nrow(p_high), nrow(p_high)*0.01),]


one_chrom_m <- manhattan(subset(m_10kb, chrom_name == 4), chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          main = "7 males, window size = 10kb, step = 5kb")
one_chrom_m

all_chroms_m <- manhattan(m_10kb, chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          main = "7 males, window size = 10kb, step = 5kb")
all_chroms_m

####### merge male and female data ########

mf_10kb <- merge(m_10kb, f_10kb,
                 by=c("Chromo",
                      "chrom_name",
                      "chromosome",
                      "win_start",
                      "win_end"),
                 suffix = c("_m", "_f"))

corr_mf <- ggplot(mf_10kb, aes(y = hetFreq_m, x = hetFreq_f)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point(aes(colour = factor(chromosome))) +
    facet_wrap("chromosome")

corr_mf

ggsave(file="het_corr_m_vs_f_win_10kb_step_5kb.pdf",
       plot=corr_mf,
       width=10,
       height=8)


######## 7 male adults (GBE birds) ##########

gbe_10kb <- read.table(gzfile("hwe_7adults_win_10kb_step_5kb.csv.gz"),
                     header = T)

gbe_10kb$chrom_name <- gbe_10kb$Chromo

gbe_10kb$chrom_name <- revalue(gbe_10kb$chrom_name,
                             c(NC_031768.1=1,
                               NC_031769.1=2,
                               NC_031770.1=3,
                               NC_031771.1=4,
                               NC_031772.1=4.5,
                               NC_031773.1=1.5,
                               NC_031774.1=5,
                               NC_031775.1=6,
                               NC_031776.1=7,
                               NC_031777.1=8,
                               NC_031778.1=9,
                               NC_031779.1=10,
                               NC_031780.1=11,
                               NC_031781.1=12,
                               NC_031782.1=13,
                               NC_031783.1=14,
                               NC_031784.1=15,
                               NC_031785.1=17,
                               NC_031786.1=18,
                               NC_031787.1=19,
                               NC_031788.1=20,
                               NC_031789.1=21,
                               NC_031790.1=22,
                               NC_031791.1=23,
                               NC_031792.1=24,
                               NC_031793.1=25.0,
                               NC_031794.1=25.5,
                               NC_031795.1=26,
                               NC_031796.1=27,
                               NC_031797.1=28
                             ))
gbe_10kb$chrom_name <- as.numeric(gbe_10kb$chrom_name)

gbe_10kb$SNP <- NA

gbe_10kb$chromosome <- revalue(gbe_10kb$Chromo,
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
                               NC_031797.1="28"
                             ))

gbe_10kb_high <- gbe_10kb[gbe_10kb$hetFreq>0.5,]


#p_sample <- p_high[sample(nrow(p_high), nrow(p_high)*0.01),]


one_chrom_gbe <- manhattan(subset(gbe_10kb, chrom_name == 4), chr = "chrom_name",
                         bp = "win_start",
                         p = "hetFreq",
                         logp = FALSE,
                         ylab = "obs. frequency of heterozygotes",
                         main = "7 adults (GBE), window size = 10kb, step = 5kb")
one_chrom_gbe

all_chroms_gbe <- manhattan(gbe_10kb, chr = "chrom_name",
                          bp = "win_start",
                          p = "hetFreq",
                          logp = FALSE,
                          ylab = "obs. frequency of heterozygotes",
                          main = "7 adults (GBE), window size = 10kb, step = 5kb")
all_chroms_gbe

par(mfrow=c(3,1))

# c(bottom, left, top, right)
par(mar = c(4,5,2,0))
manhattan(gbe_10kb, chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          xlab = "",
          main = "7 adults (GBE), window size = 10kb, step = 5kb")

manhattan(m_10kb, chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          xlab = "",
          main = "7 males, window size = 10kb, step = 5kb")

manhattan(f_10kb, chr = "chrom_name",
          bp = "win_start",
          p = "hetFreq",
          logp = FALSE,
          ylab = "obs. frequency of heterozygotes",
          main = "7 females, window size = 10kb, step = 5kb")

par(mfrow=c(1,1))




####### merge male eggs and male adults (GBE) data ########

m_gbe_10kb <- merge(m_10kb, gbe_10kb,
                 by=c("Chromo",
                      "chrom_name",
                      "chromosome",
                      "win_start",
                      "win_end"),
                 suffix = c("_m", "_gbe"))

corr_m_gbe <- ggplot(m_gbe_10kb, aes(y = hetFreq_gbe, x = hetFreq_m)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point(aes(colour = factor(chromosome))) +
    facet_wrap("chromosome")

corr_m_gbe

ggsave(file="het_corr_m_vs_gbe_win_10kb_step_5kb.pdf",
       plot=corr_m_gbe,
       width=10,
       height=8)

####### merge male adults (GBE) and female eggs data ########

gbe_f_10kb <- merge(gbe_10kb, f_10kb,
                    by=c("Chromo",
                         "chrom_name",
                         "chromosome",
                         "win_start",
                         "win_end"),
                    suffix = c("_gbe","_f"))

corr_gbe_f <- ggplot(gbe_f_10kb, aes(y = hetFreq_gbe, x = hetFreq_f)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point(aes(colour = factor(chromosome))) +
    facet_wrap("chromosome")

corr_gbe_f

ggsave(file="het_corr_gbe_vs_f_win_10kb_step_5kb.pdf",
       plot=corr_gbe_f,
       width=10,
       height=8)


# figure <- ggarrange(all_chroms_gbe + rremove("ylab") + rremove("xlab"),
#                     all_chroms_m + rremove("ylab") + rremove("xlab"),
#                     all_chroms_f + rremove("ylab") + rremove("xlab"),
#                     labels = "AUTO",
#                     vjust=1.0,
#                     hjust=-1,
#                     ncol = 1, nrow = 3)
# 
# require(grid)
# figure <- annotate_figure(figure,
#                           left = textGrob("bla", rot = 90, vjust = 1, gp = gpar(cex = 1.3)),
#                           bottom = textGrob("time points", gp = gpar(cex = 1.3)))

