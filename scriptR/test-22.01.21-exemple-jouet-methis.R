setwd("Documents/git_repository/Stage/tools/MetHis/test/")

library(abc)
library(abcrf)
library(stringr)

#Lire les stats des différentes simulations de l'exemple
for (i in c(1:10)) {
  directory = str_c("simu_", as.character(i))
  file_name = str_c(directory, "/final_sumstats.txt")
  if (i == 1) {
    mat_stat = read.table(file_name, header = TRUE)
  }else{
    mat_stat = rbind(mat_stat, read.table(file_name, header = TRUE))
  }
}

abc(mat_stat)


require(abc.data)
data(musigma2)
?musigma2

## The rejection algorithm
##
rej <- abc(target=stat.obs, param=par.sim, sumstat=stat.sim,
           tol=.1, method = "rejection") 

## ABC with local linear regression correction without/with correction
## for heteroscedasticity 
##
lin <- abc(target=stat.obs, param=par.sim, sumstat=stat.sim, tol=.1, hcorr =
             FALSE, method = "loclinear", transf=c("none","log"))
linhc <- abc(target=stat.obs, param=par.sim, sumstat=stat.sim, tol=.1, method =
               "loclinear", transf=c("none","log")) 

## posterior summaries
##
linsum <- summary(linhc, intvl = .9)
linsum
## compare with the rejection sampling
summary(linhc, unadj = TRUE, intvl = .9)

## posterior histograms
##
hist(linhc, breaks=30, caption=c(expression(mu),
                                 expression(sigma^2))) 

## diagnostic plots: compare the 2 'abc' objects: "loclinear",
## "loclinear" with correction for heteroscedasticity
##
plot(lin, param=par.sim)
plot(linhc, param=par.sim)
