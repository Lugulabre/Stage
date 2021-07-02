#!/usr/bin/env Rscript

library(stringr)

setwd("~/Documents/git_repository/Stage/Simulations/SNP_AFR_EUR/new_methis_bottleneck_50000_snp/")
arguments = commandArgs(trailingOnly = TRUE)

alpha = arguments[1]
nu = arguments[2]
ne0 = arguments[3]
nen = arguments[4]
bottle = arguments[5]

path_tot = str_c("alpha",alpha,"/Nu",nu,"/bottle",bottle,
                 "/Ne",ne0,"-XXX/Ne",ne0,"-",nen,"/simu_1/simu_1.par")

file_tmp = read.table(path_tot, header = TRUE)
c1_tmp = file_tmp$c1[1]
c2_tmp = file_tmp$c2[1]
file_tmp[1,3:4] = c(0,0)
file_tmp = rbind(c(0,ne0,c1_tmp,c2_tmp), file_tmp)

for (row_sup in 1:(101-nrow(file_tmp)) ){
  file_tmp = rbind(file_tmp, c(0,nen,0,0))
}
file_tmp[,1] = c(0:100)

write.table(file_tmp, file = str_c(path_tot), append = FALSE,
            quote = FALSE, sep = "\t", na = "-", row.names = FALSE)

