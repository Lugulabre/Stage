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

hist(mat_stat$mean.het.s1)

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


## Exemple article
data(human)
cv.modsel <- cv4postpr(models, stat.3pops.sim,
                       nval = 50, tol = .01,
                       method = "mnlogistic")
plot(cv.modsel)
stat.italy.sim <- subset(stat.3pops.sim,
                         subset=models=="bott")
cv.res.reg <- cv4abc(data.frame(Na = par.italy.sim [,"Ne"]),
                     stat.italy.sim, nval = 200,
                     tols = c(.005,.001), method = "loclinear")
plot(cv.res.reg, caption = "Ne")
res <- abc(target = stat.voight["italian",], param = data.frame(Na = par.italy.sim [, "Ne"]),
             + sumstat = stat.italy.sim, tol = 0.005, transf = c("log"), method = "neuralnet")
plot(res, param = par.italy.sim [, "Ne"])
