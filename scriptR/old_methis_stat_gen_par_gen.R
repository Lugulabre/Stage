#Script pour analyser résultats de la simumation génération par génération
#Avec retour à une nouvelle simulation pour calculer les stats à chaque génération

library(stringr)
library(ggplot2)

setwd("Documents/git_repository/Stage/Simulations/old_methis_pop_size_diff")

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


#Afficher graphique d'une stat choisie
for (i in min_ne:max_ne) {
  vec_mean = c()
  for (j in 1:max_gen) {
    vec_mean[j] = mean(Ne_all[[i]][[j]]$mean.het.adm)
    
  }
  if (i == min_ne) {
    plot(vec_mean, type = "l", col = i, ylim = c(0,0.1))
  }else{
    lines(c(1:100),vec_mean, type = 'l', col = i)
  }
}
legend("topleft",
       legend = c("Ne64", "Ne128", "Ne256", "Ne512",
                  "Ne1024", "Ne2048", "Ne4096", "Ne8192"), 
       col = c(min_ne:max_ne),
       lty =1, cex = 0.5)


#Graphique sur une seule stat avec ggplot (nb : Fst s1_adm)
#Ne entre 64 et 8192 en doublant à chaque simu

mat_Fst_1_adm = matrix(data = NA, nrow = (max_ne-min_ne+1)*max_gen,
                       ncol = 3)

for (pow in c(min_ne:max_ne)) {
  dir_ne = str_c("Ne", toString(base_used**pow), "/")
  setwd(dir_ne)
  row_min = (pow-min_ne)*100+1
  row_max = (pow-min_ne+1)*100
  mat_Fst_1_adm[row_min:row_max,1] = str_c("Ne", toString(base_used**pow))
  for (nb_gen in 1:max_gen) {
    dir_gen = str_c("gen", toString(nb_gen), "/")
    setwd(dir_gen)
    mat_Fst_1_adm[row_min+nb_gen-1,2] = nb_gen
    for (nb_simu in 1:max_simu) {
      dir_simu = str_c("simu_", toString(nb_simu), "/")
      setwd(dir_simu)
      if (nb_simu == 1) {
        stock_tmp = read.table("final_sumstats.txt",
                               header = TRUE)
      }else{
        stock_tmp = rbind(stock_tmp,
                          read.table("final_sumstats.txt",
                                     header = TRUE))
      }
      setwd("../")
    }
    mat_Fst_1_adm[row_min+nb_gen-1,3] = mean(stock_tmp$mean.het.adm)
    setwd("../")
  }
  setwd("../")
}

mat_Fst_1_adm = as.data.frame(mat_Fst_1_adm)
colnames(mat_Fst_1_adm) = c("Ne", "gen", "Fst")
mat_Fst_1_adm$gen = as.integer(mat_Fst_1_adm$gen)
mat_Fst_1_adm$Fst = as.double(mat_Fst_1_adm$Fst)

#Graphiques de Fst 1-adm avec ggplot
p = ggplot(mat_Fst_1_adm, aes(x = gen, y = Fst, color = Ne)) +
  ggtitle("Htz en fonction des générations\n selon différentes Ne initiales")
p = p + geom_point(size = 2) + geom_line(size=0.8)
p = p + geom_point(size = 2)+ geom_smooth()
p


#Pareil, avec Ne entre 60 et 100 par pas de 10

min_ne = 6
max_ne = 10
max_gen = 100
max_simu = 100
base_used = 10

mat_Fst_1_adm_bis = matrix(data = NA, nrow = (max_ne-min_ne+1)*max_gen,
                           ncol = 3)

for (pow in c(min_ne:max_ne)) {
  dir_ne = str_c("Ne", toString(base_used*pow), "/")
  setwd(dir_ne)
  row_min = (pow-min_ne)*100+1
  row_max = (pow-min_ne+1)*100
  mat_Fst_1_adm[row_min:row_max,1] = str_c("Ne", toString(base_used**pow))
  for (nb_gen in 1:max_gen) {
    dir_gen = str_c("gen", toString(nb_gen), "/")
    setwd(dir_gen)
    mat_Fst_1_adm[row_min+nb_gen-1,2] = nb_gen
    for (nb_simu in 1:max_simu) {
      dir_simu = str_c("simu_", toString(nb_simu), "/")
      setwd(dir_simu)
      if (nb_simu == 1) {
        stock_tmp = read.table("final_sumstats.txt",
                               header = TRUE)
      }else{
        stock_tmp = rbind(stock_tmp,
                          read.table("final_sumstats.txt",
                                     header = TRUE))
      }
      setwd("../")
    }
    mat_Fst_1_adm[row_min+nb_gen-1,3] = mean(stock_tmp$Fst.s1.adm)
    setwd("../")
  }
  setwd("../")
}

mat_Fst_1_adm = as.data.frame(mat_Fst_1_adm)
colnames(mat_Fst_1_adm) = c("Ne", "gen", "Fst")
mat_Fst_1_adm$gen = as.integer(mat_Fst_1_adm$gen)
mat_Fst_1_adm$Fst = as.double(mat_Fst_1_adm$Fst)

#Graphiques de Fst 1-adm avec ggplot
p = ggplot(mat_Fst_1_adm, aes(x = gen, y = Fst, color = Ne)) +
  ggtitle("Fst en fonction des générations\n selon différentes Ne initiales")
p = p + geom_point(size = 2) + geom_line(size=0.8)
p = p + geom_point(size = 2)+ geom_smooth()
p
