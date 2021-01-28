#Script pour analyser résultats de la simumation génération par génération
#Avec retour à une nouvelle simulation pour calculer les stats à chaque génération

library(stringr)

setwd("../Simulations/stat_gen_par_gen_TCL_64-8192")

#Paramètres modifiables
min_ne = 6
max_ne = 13
max_gen = 100
max_simu = 100
base_used = 2

#Lecture des données statistiques résumées
Ne_all = list()

for (pow in c(min_ne:max_ne)) {
  dir_ne = str_c("Ne", toString(base_used**pow), "/")
  setwd(dir_ne)
  Ne_all[[pow]] = list()
  for (nb_gen in 1:max_gen) {
    dir_gen = str_c("gen", toString(nb_gen), "/")
    setwd(dir_gen)
    Ne_all[[pow]][[nb_gen]] = data.frame()
    for (nb_simu in 1:max_simu) {
      dir_simu = str_c("simu_", toString(nb_simu), "/")
      setwd(dir_simu)
      getwd()
      if (nb_simu == 1) {
        Ne_all[[pow]][[nb_gen]] = read.table("final_sumstats.txt",
                                             header = TRUE)
      }else{
        Ne_all[[pow]][[nb_gen]] = rbind(Ne_all[[pow]][[nb_gen]],
                                        read.table("final_sumstats.txt",
                                                   header = TRUE))
      }

      setwd("../")
    }
    setwd("../")
  }
  setwd("../")
}



for (i in 2:3) {
  vec_mean = c()
  for (j in 1:100) {
    vec_mean[j] = mean(Ne_all[[i]][[j]]$mean.het.adm)
  }
  plot(vec_mean, type = "l")
}

