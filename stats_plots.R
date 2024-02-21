rm(list=ls())
library(ggplot2)
library(readxl)
library(plyr)
setwd("~/sciebo/Postdoc TU Dortmund/pop_gen_comp")


dat <- read_excel("stats_per_chrom.xlsx",
                              sheet = "data_wide")

dat$tW_per_site_adults <- dat$tW_adults/dat$nSites_adults
dat$tW_per_site_eggs <- dat$tW_eggs/dat$nSites_eggs

dat$tP_per_site_adults <- dat$tP_adults/dat$nSites_adults
dat$tP_per_site_eggs <- dat$tP_eggs/dat$nSites_eggs

dat$chrom_name <- revalue(dat$Chr_eggs,
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

summary(dat)


# number of sites
nSites <- ggplot(dat, aes(x=nSites_eggs,
                y=nSites_adults,
                label=chrom_name)) +
    geom_point() +
    geom_text(hjust=-0.5, vjust=0.5) +
    xlim(0, 1.8e+08) +
    geom_abline(intercept = 0, slope = 1)

ggsave(file="nSites.pdf", plot=nSites, width=6, height=5)


# Watterson's theta
theta_W <- ggplot(dat, aes(x=tW_per_site_eggs,
                y=tW_per_site_adults,
                label=chrom_name)) +
    geom_point()  +
    geom_text(hjust=-0.5, vjust=0.5) +
    xlim(0.0025, 0.008) +
    ylim(0.0025, 0.0065) +
    geom_abline(intercept = 0, slope = 1)

ggsave(file="theta_W.pdf", plot=theta_W, width=6, height=5)

# pairwise nucleotide diversity
theta_pairwise <- ggplot(dat, aes(x=tP_per_site_eggs,
                y=tP_per_site_adults,
                label=chrom_name)) +
    geom_point()  +
    geom_text(hjust=-0.5, vjust=0.5) +
    xlim(0.002, 0.0072) +
    ylim(0.002, 0.006) +
    geom_abline(intercept = 0, slope = 1)

ggsave(file="theta_pairwise.pdf", plot=theta_pairwise, width=6, height=5)

# Tajima's D
Tajima_D <- ggplot(dat, aes(x=Tajima_eggs,
                y=Tajima_adults,
                label=chrom_name)) +
    geom_point()  +
    geom_text(hjust=-0.5, vjust=0.5) +
    xlim(-0.65, -0.05) +
    ylim(-0.65, -0.1) +
    geom_abline(intercept = 0, slope = 1)


ggsave(file="Tajima_D.pdf", plot=Tajima_D, width=6, height=5)
