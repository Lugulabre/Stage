# Librairies utilisées
library(colorspace)
library(colorblindr)
library(ggplot2)
library(ggthemes)
library(lattice)
library(plot3D)
library(rriskDistributions)
library(stringr)
require(MASS)

# Fonction de lecture des stats résumées.
# La fonction est prévue pour lire les fichiers de stats résumées 
# dans des répertoires de la forme "Ne100/simu_1" 
# (en modifiant les valeurs de Ne et de simulations). 
# Elle renvoie les résultats sous forme de data frame en ajoutant 
# aux statistiques résumées les colonnes correspondant à 
# l'effectif efficace et la simulation.

#Data frame construction
data.frame.stat = function(seq_ne, max_gen, max_simu){
  #Créer matrice vide qui contiendra les stats
  mat_stat = matrix(data = NA, nrow = length(seq_ne)*max_gen*max_simu, ncol = 65)
  mat_stat = as.data.frame(mat_stat)
  #Compteur pour indiquer les lignes à remplir
  cpt = 0

  for (ne in seq_ne) {
    if (dir.exists(str_c("Ne", toString(ne), "/"))) {
      dir_ne = str_c("Ne", toString(ne), "/") #Répertoire de taille effective
      row_min = cpt*max_gen*max_simu+1 #Ligne min. où on écrit les stats pour le Ne donné
      row_max = (cpt+1)*max_gen*max_simu         #Ligne max. où on écrit les stats  
      mat_stat[row_min:row_max,1] = toString(ne) #Ecriture du Ne correspondant pour les stats qui seront écrites
      cpt = cpt+1                             #Incrémentation du compteur
  
      for (nb_simu in 1:max_simu) {
        dir_simu = str_c("simu_", toString(nb_simu), "/")
        row_min_simu = (nb_simu-1)*max_gen + row_min
        row_max_simu = nb_simu*max_gen + row_min -1
        mat_stat[row_min_simu:row_max_simu,2] = nb_simu
        file_path = str_c(dir_ne, dir_simu, "final_sumstats.txt")
        file_stat = read.table(file_path, header = TRUE) #Lecture fichier stat résumées
        #Suppression 1ère colonne, contenant uniquement chiffres pour tri en bash. 
        mat_stat[row_min_simu:row_max_simu,3:63] = file_stat
        #Ajout de la contribution s1,0 initiale pour pouvoir calculer les delta de proportion d'admixture ultérieurement
        file_path_s1.0 = str_c(dir_ne, dir_simu, str_c("simu_",nb_simu,".par") )
        file_stat_s1.0 = read.table(file_path_s1.0, header = TRUE)
        mat_stat[row_min_simu:row_max_simu,64] = file_stat_s1.0$c1
        mat_stat[row_min_simu:row_max_simu,65] = file_stat_s1.0$c2
      }
        #print(dim(mat_stat))
    }
  }
        
  #Attribution nom colonnes selon appelation stat par MetHis
  colnames(mat_stat) = c("Ne", "simu", names(file_stat), "s1.0", "s2.0")#,"cpt")#, "delta.adm.props")
  #Passage des Ne en facteur
  mat_stat$Ne = factor(as.factor(mat_stat$Ne), levels = as.character(seq_ne))
  #Passage simulations en entier
  mat_stat$simu = as.integer(mat_stat$simu)
  #Passage générations en entier
  mat_stat$Generation = as.integer(mat_stat$Generation)
  #Passage stats en double
  for (numcol in 4:ncol(mat_stat)) {
    mat_stat[,numcol] = as.double(mat_stat[,numcol])
  }
        
  # print(dim(mat_stat))
  return(mat_stat)
}



# Réutilisation de la fonction de lecture de stats résumées pour des populations croissantes.
# Celles-ci sont enregistrées dans des répertoires de la forme "Ne100-XXX/Ne100-1000/simu_1"
# Fonction de lecture des stats résumées. 
# La fonction est prévue pour lire les fichiers de stats résumées dans des 
# répertoires de la forme "NeXXX/simu_XXX" (avec XXX remplacés par les valeurs 
# de Ne et de simulations). Elle renvoie les résultats sous forme de data frame 
# en ajoutant aux statistiques résumées les colonnes correspondant à l'effectif 
# efficace et la simulation.


data.frame.ne.gen = function(seq_ne){
  for (ne in seq_ne) {
    if (dir.exists(str_c("Ne", ne))) {
      dir_ne = str_c("Ne", ne, "/simu_1/")
      setwd(dir_ne)
      file_tmp = read.table("simu_1.par", header = TRUE)
      
      if (ne == seq_ne[1]) {
        mat_ne_inc = as.data.frame(file_tmp[,2])
      }else{
        mat_ne_inc = cbind(mat_ne_inc, file_tmp[,2])
      }
      setwd("../../")
    }
  }
  return(mat_ne_inc)
}



data.frame.increase = function(seq_ne_ini, seq_combi, max_simu = 1){
  mat_inc = c()
  for (ne_ini in seq_ne_ini) {
    if (dir.exists(str_c("Ne", ne_ini, "-XXX/"))) {
      dir_ne = str_c("Ne", ne_ini, "-XXX/")
      setwd(dir_ne)
      motif_detect = str_c("^",ne_ini,"-")
      vec_ne_tmp = seq_combi[which(str_detect(seq_combi, motif_detect))]
      mat_tmp = data.frame.stat(seq_ne = vec_ne_tmp, max_gen = 101, max_simu = max_simu)
      mat_ne = data.frame.ne.gen(seq_ne = vec_ne_tmp)
      # print(mat_ne)
      vec_tmp = as.integer(unlist(str_split(mat_tmp$Ne, "-")))
      mat_tmp$ne_gen = unlist(mat_ne, use.names = F)
      # print(length(vec_tmp))
      mat_tmp$n0 = vec_tmp[seq(1,length(vec_tmp),2)]
      mat_tmp$nf = vec_tmp[seq(2,length(vec_tmp),2)]
      if (ne_ini == seq_ne_ini[1]) {
        mat_inc = mat_tmp
      }else{
        mat_inc = rbind(mat_inc, mat_tmp)
      }
      
      setwd("../")
      #print(dim(mat_pop_inc))
    }
  }
  return(na.omit(mat_inc))
}


data.frame.increase.nu = function(seq_ne_ini, seq_combi, seq_nu, max_simu = 1){
  for (nu in seq_nu) {
    if(dir.exists(str_c("Nu", nu ))){
      dir_nu = str_c("Nu", nu, "/")
      setwd(dir_nu)
      
      mat_tmp = data.frame.increase(seq_ne_ini, seq_combi, max_simu)
      
      if (nu == seq_nu[1]) {
        mat_pop = data.frame(mat_tmp, U = nu)
      }else{
        mat_tmp = data.frame(mat_tmp, U = nu)
        mat_pop = rbind(mat_pop, mat_tmp)
      }
      setwd("../")
    }
  }
  mat_pop$U = as.factor(mat_pop$U)
  
  return(mat_pop)

}


data.frame.bottleneck = function(lst_ne0, lst_nef, lst_alpha, lst_nu, lst_bottle, max_simu = 1){
  lst_combi = as.data.frame(outer(lst_ne0, lst_nef, FUN="paste", sep="-"))
  lst_combi = as.data.frame.vector(unlist(lst_combi))[[1]]
  cpt = 0
  for (alpha in lst_alpha) {
    for (nu in lst_nu) {
      for (bottle in lst_bottle) {
        change_dir = str_c("alpha", alpha, "/Nu", nu, "/bottle",bottle,"/")
        # print(change_dir)
        if(dir.exists(change_dir)){
          # print(getwd())
          setwd(change_dir)
          mat_tmp = data.frame.increase(lst_ne0, lst_combi, max_simu)
          if (!is.null(nrow(mat_tmp))) {
            col_alpha = rep(alpha, nrow(mat_tmp))
            col_nu = rep(nu, nrow(mat_tmp))
            col_bottle = rep(bottle, nrow(mat_tmp))
            col_bott_u = rep(str_c(bottle, "/", nu), nrow(mat_tmp))
            # col_bott_u = as.numeric(rep(bottle, nrow(mat_tmp)))/as.numeric(rep(nu, nrow(mat_tmp)))
            # col_bott_u = ceiling(col_bott_u/1)*1
            col_u_alpha = rep(str_c(nu, "/", alpha), nrow(mat_tmp))
            # col_u_alpha = as.numeric(rep(nu, nrow(mat_tmp)))/as.numeric(rep(alpha, nrow(mat_tmp)))
            # col_u_alpha = ceiling(col_u_alpha/0.001)*0.001
            mat_tmp = data.frame(mat_tmp, alpha = col_alpha,
                                 U = col_nu, time_botl = col_bottle,
                                 bott_u = col_bott_u, u_alpha = col_u_alpha)
            cpt = cpt+1
          }
          # print(dim(mat_tmp))
          if (alpha==lst_alpha[1] & nu==lst_nu[1] & bottle==lst_bottle[1]) {
            mat_bot = mat_tmp
          }else{
            mat_bot = rbind(mat_bot, mat_tmp)
          }
          setwd("../../../")
        }
      }
    }
  }
  if(!is.null(mat_bot)){
    mat_bot$alpha = as.factor(mat_bot$alpha)
    mat_bot$U = as.factor(mat_bot$U)
    mat_bot$time_botl = as.factor(mat_bot$time_botl)
    mat_bot$bott_u = as.factor(mat_bot$bott_u)
    mat_bot$u_alpha = as.factor(mat_bot$u_alpha)
  }
  return(mat_bot)
}



# Calcul du delta des moyennes de proportion d'admixture :
#   - Par rapport à la moyenne attendue


var.adm = function(s1, gen){
  return( (s1*(1-s1))/(2**gen) )
}

delta.adm.props = function(mat){
  mat$delta.mean.adm.props = NA
  mat$delta.var.adm.props = NA
  # mat$delta.adm.pp = NA
  for (i in 1:nrow(mat)) {
    if (mat$Generation[i] == 0) {
      ref_adm = mat$s1.0[i]
    }
    mat$delta.mean.adm.props[i] = mat$mean.adm.props[i] - ref_adm
    ref_var = var.adm(s1 = ref_adm, gen = mat$Generation[i])
    mat$delta.var.adm.props[i] = mat$var.adm.props[i] - ref_var
    # if (i == 1) {
    #   mat$delta.adm.pp[i] = 0
    # }else{
    #   mat$delta.adm.pp[i] = mat$delta.mean.adm.props[i] - mat$delta.mean.adm.props[i-1]
    # }
  }
  return(mat)
}

delta.adm.props.s2.0 = function(mat){
  mat$delta.mean.adm.props.s2.0 = NA
  
  for (i in 1:nrow(mat)) {
    ref_adm = mat$s1.0[i]
    mat$delta.mean.adm.props.s2.0[i] =  ref_adm - mat$mean.adm.props[i]
  }
  return(mat)
}


# - Par rapport à la génération 0


delta.adm.gen.0 = function(mat){
  mat$delta.adm.gen.0 = NA
  
  for (i in 1:nrow(mat)) {
    if (mat$Generation[i] == 0) {
      ref_adm = mat$mean.adm.props[i]
    }
    mat$delta.adm.gen.0[i] = mat$mean.adm.props[i] - ref_adm
  }
  
  return(mat)
}


# Dans le cas où l'on travaille sur de très nombreuses simulations 
# correspondant à un effectif efficace, cette fonction permet de calculer 
# les statistiques moyennées pour les valeurs de Ne étudiées.


#fonction de calcul d'intervalle de confiance
IC_95 = function(vec){
  sd_vec = sd(vec)
  n_vec = length(vec)
  return(1.96*(sd_vec/sqrt(n_vec)))
}



#Passage en moyenne
data.frame.mean = function(df_stat, max_gen, seq_ne, col_mean, col_cstt){
  if (length(col_mean)+length(col_cstt) != ncol(df_stat)) {
    stop("all columns must be specified")
  }
  
  lrow = length(seq_ne)
  df_mean = matrix(data = NA, nrow = lrow*max_gen, ncol = ncol(df_stat))
  df_mean = as.data.frame(df_mean)
  df_ic = df_mean
  df_sd = df_mean
  cpt = 0
  
  for (ne in seq_ne) {
    df_tmp = df_stat[which(df_stat$Ne == ne),]
    
    row_min = cpt*max_gen+1
    row_max = (cpt+1)*max_gen
    
    for (cstt in col_cstt) {
      # print(as.character(df_tmp[1, cstt]))
      df_mean[row_min:row_max, cstt] = as.character(df_tmp[1, cstt])
      df_ic[row_min:row_max, cstt] = as.character(df_tmp[1, cstt])
      df_sd[row_min:row_max, cstt] = as.character(df_tmp[1, cstt])
    }
    
    cpt = cpt+1
    
    for (gen in 0:(max_gen-1) ) {
      df_mean[row_min+gen, 3] = gen
      df_ic[row_min+gen, 3] = gen
      df_mean[row_min+gen, col_mean] = apply(df_tmp[which(df_tmp$Generation == gen), col_mean], 2, mean)
      df_ic[row_min+gen, col_mean] = apply(df_tmp[which(df_tmp$Generation == gen), col_mean], 2, IC_95)
      df_sd[row_min+gen, col_mean] = apply(df_tmp[which(df_tmp$Generation == gen), col_mean], 2, sd)
    }
  }
  
  colnames(df_mean) = colnames(df_stat)
  df_mean$Ne = as.factor(df_mean$Ne)
  df_mean$Generation = as.integer(df_mean$Generation)
  
  colnames(df_ic) = colnames(df_stat)
  df_ic$Ne = as.factor(df_ic$Ne)
  df_ic$Generation = as.integer(df_ic$Generation)
  
  colnames(df_sd) = colnames(df_stat)
  df_sd$Ne = as.factor(df_sd$Ne)
  df_sd$Generation = as.integer(df_sd$Generation)
  return(list(df_mean, df_ic, df_sd))
}



data.frame.mean.u = function(df_stat, max_gen, seq_combi, seq_u, col_mean, col_cstt){
  for (u in seq_u){
    all_df = data.frame.mean(df_stat = df_stat[which(df_stat$U == u),],
                             max_gen = max_gen, seq_ne = seq_combi,
                             col_mean = col_mean, col_cstt = col_cstt)
    if (u == seq_u[1]) {
      df_tot_mean = all_df[[1]]
      df_tot_ic = all_df[[2]]
      df_tot_sd = all_df[[3]]
    }else{
      df_tot_mean = rbind(df_tot_mean, all_df[[1]])
      df_tot_ic = rbind(df_tot_ic, all_df[[2]])
      df_tot_sd = rbind(df_tot_sd, all_df[[3]])
    }
  }
  df_tot_mean$U = as.factor(as.numeric(df_tot_mean$U))
  df_tot_ic$U = as.factor(as.numeric(df_tot_ic$U))
  df_tot_sd$U = as.factor(as.numeric(df_tot_sd$U))
  return(list(df_tot_mean, df_tot_ic, df_tot_sd))
}


data.frame.mean.bottle = function(df_stat, max_gen, seq_combi, seq_u,
                                  seq_alpha, seq_bottle, col_mean, col_cstt){
  for (alpha in seq_alpha) {
    df_alpha = df_stat[which(df_stat$alpha == alpha),]
    for (u in seq_u) {
      df_u = df_alpha[which(df_alpha$U == u),]
      for (bottle in seq_bottle) {
        df_bot = df_u[which(df_u$time_botl == bottle),]
        all_df = data.frame.mean(df_stat = df_bot, max_gen = max_gen,
                                 seq_ne = seq_combi, col_mean = col_mean,
                                 col_cstt = col_cstt)
        if (alpha == seq_alpha[1] && u == seq_u[1] && bottle == seq_bottle[1]) {
          df_tot_mean = all_df[[1]]
          df_tot_ic = all_df[[2]]
          df_tot_sd = all_df[[3]]
        }else{
          df_tot_mean = rbind(df_tot_mean, all_df[[1]])
          df_tot_ic = rbind(df_tot_ic, all_df[[2]])
          df_tot_sd = rbind(df_tot_sd, all_df[[2]])
        }
      }
    }
  }
  df_tot_mean$U = as.factor(as.numeric(df_tot_mean$U))
  df_tot_mean$alpha = as.factor(as.numeric(df_tot_mean$alpha))
  df_tot_mean$time_botl = as.factor(df_tot_mean$time_botl)
  df_tot_mean$bott_u = as.factor(df_tot_mean$bott_u)
  df_tot_mean$u_alpha = as.factor(df_tot_mean$u_alpha)
  
  df_tot_ic$U = as.factor(as.numeric(df_tot_ic$U))
  df_tot_ic$alpha = as.factor(as.numeric(df_tot_ic$alpha))
  df_tot_ic$time_botl = as.factor(df_tot_ic$time_botl)
  df_tot_ic$bott_u = as.factor(df_tot_ic$bott_u)
  df_tot_ic$u_alpha = as.factor(df_tot_ic$u_alpha)
  
  df_tot_sd$U = as.factor(as.numeric(df_tot_sd$U))
  df_tot_sd$alpha = as.factor(as.numeric(df_tot_sd$alpha))
  df_tot_sd$time_botl = as.factor(df_tot_sd$time_botl)
  df_tot_sd$bott_u = as.factor(df_tot_sd$bott_u)
  df_tot_sd$u_alpha = as.factor(df_tot_sd$u_alpha)
  return(list(df_tot_mean, df_tot_ic, df_tot_sd))
}


# Fonction d'extraction d'une sous-matrice à partir d'une 
# matrice principale en fonction de valeurs choisies de Ne devant 
# être présentes dans la matrice initiale.


extract_sub_mat = function(all_mat, list_ne){
  all_rows = c()
  for (ne in as.character(list_ne)) {
    all_rows = append(all_rows, which(all_mat[,1] == ne))
  }
  return(all_mat[all_rows,])
}


# Fonction d'affichage des graphiques en 2D, avec un background blanc 
# et les lignes horizontales de quadrillage affichées.
# Cette fonction permet d'afficher les lignes reliant les points ou les 
# lignes de régression. Il est possible de passer en paramètres la variable 
# selon laquelle les points seront colorés, les groupes selon lesquels les 
# points sont reliés, l'affichage ou non de la légende (l'affichage se fait 
# par défaut), la taille des points et le type de ligne utilisé.


#Plot function
#Affichage d'une stat au cours des générations
plot_stat_gen = function(df, gen, stat, group_col = c(), color_col, titre, ligne = TRUE, legd = TRUE,
                         size_point = 0.1, line_t = "solid"){
  p = ggplot(df, aes(x = gen, y = stat,
                     group = group_col, color = color_col)) + ggtitle(titre)
  
  if (ligne) {
    p = p + geom_point(size = size_point, show.legend = legd)+
      geom_line(aes(linetype = line_t), show.legend = legd)
  }else{
    #smooth de la courbe pour obtenir régression et tempérer variabilité due au TCL
    p = p + geom_point(size = size_point, show.legend = legd)+ geom_smooth(show.legend = legd)
  }
  p = p + scale_fill_OkabeIto()
  p = p + theme_classic()
  p = p + theme(axis.title.x = element_text(size = 18),
                axis.title.y = element_text(size = 18))
  p = p + theme(panel.grid.major.y = element_line(size = 0.5,
                                                  linetype = 'solid',
                                                  colour = "#BABABA"),
                panel.grid.minor.y = element_line(size = 0.25,
                                                  linetype = 'solid',
                                                  colour = "#CECECE"))
  
  return(p)
}


# Cette fonction d'affichage de graphique reprend la précédente, 
# en affichant uniquement les courbes de régression sans les points.


#Plot function
#Affichage d'une stat au cours des générations
plot_without_point = function(df, gen, stat, color_col, titre, legd = TRUE){
  p = ggplot(df, aes(x = gen, y = stat, color = color_col)) + ggtitle(titre)
  
  #smooth de la courbe pour obtenir régression et tempérer variabilité due au TCL
  p = p + geom_smooth(show.legend = legd)
  p = p + theme_classic()
  p = p + theme(panel.grid.major.y = element_line(size = 0.5,
                                                  linetype = 'solid',
                                                  colour = "#BABABA"),
                panel.grid.minor.y = element_line(size = 0.25,
                                                  linetype = 'solid',
                                                  colour = "#CECECE"))
  #print(p)
  return(p)
}


# Cette fonction permet de rajouter à un plot existant :
# - des lignes verticales (pour les goulots d'étranglement par exemple)
# - un titre aux légendes de couleurs et de types de ligne
# - de modifier les types de lignes utilisés


improve_plot_bottle = function(p, vec_abline, lab_col, lab_line, vec_linetype, vec_abtype = c("solid")){
  if (length(vec_abtype) < length(vec_abline) ){
    vec_abtype = rep(vec_abtype, length(vec_abline))
  }
  for (rg_abl in 1:length(vec_abline)) {
    p = p + geom_vline(xintercept = vec_abline[rg_abl], size = 0.4,
                       color = "orange", linetype = vec_abtype[rg_abl])
  }
  p = p + labs(color = lab_col, linetype = lab_line) + scale_linetype_manual(values=vec_linetype)
  return(p)
}


# Fonction pour une représentation graphique à l'aide d'un gif, 
# pour suivre l'évolution de la distribution des proportions d'admixture 
# dans la population.


hist.gif.props.adm = function(mat, select_stat, select_seq, title, title_leg,
                              seq_gen = c(seq(1,10,1), seq(11,101,10)),
                              vec_col = c("#A5260A", "#F6DC12", "#87E990", "#FFE4C4",
                                          "#E67E30", "#79F8F8", "#A10684", "#8B6C42"),
                              vec_col_mean = c("#F9429E", "#FF7F00", "#00FF00", "#00FFFF",
                                               "#0F056B", "#884DA7", "#FE1B00", "#01796F")){
  
  png(file="example%03d.png", width=600, heigh=400)
  for (line in seq_gen) {
    cpt_col = 1
    for (var in select_seq) {
      rg_select = which(colnames(mat) == select_stat)
      mat_tmp = mat[which(mat[,rg_select] == var),]
      vec_y = c(mat_tmp$perc0.adm.props[line],
                mat_tmp$perc10.adm.props[line],
                mat_tmp$perc20.adm.props[line],
                mat_tmp$perc30.adm.props[line],
                mat_tmp$perc40.adm.props[line],
                mat_tmp$perc50.adm.props[line],
                mat_tmp$perc60.adm.props[line],
                mat_tmp$perc70.adm.props[line],
                mat_tmp$perc80.adm.props[line],
                mat_tmp$perc90.adm.props[line],
                mat_tmp$perc100.adm.props[line])

      if (var == select_seq[1]) {
        hist(vec_y, breaks = vec_y, main = line-1, col = vec_col[cpt_col], xlim = c(-0.2,1.2),
             xlab = "adm props")
        abline(v = mat_tmp$mean.adm.props[line], col = vec_col_mean[cpt_col])
        cpt_col = cpt_col+1
      }else{
        hist(vec_y, breaks = vec_y, add = TRUE, col = vec_col[cpt_col], xlab = "adm props")
        abline(v = mat_tmp$mean.adm.props[line], col = vec_col_mean[cpt_col])
        cpt_col = cpt_col+1
      }
    }
    legend("topleft", title=title_leg,legend = select_seq,
           fill = vec_col[1:cpt_col], cex=0.8) 
  }

  dev.off()
  system(str_c("convert -delay 120 *.png ",title,".gif"))
  file.remove(list.files(pattern=".png"))

}



# Fonctions d'écriture des plots dans des fichiers
# - Pour des populations de taille constante

write_cstt_plot = function(name_stat, mat, name_file,min_y, max_y, name_x = "Generation",
                           xlab = "Generation", ylab = ""){
  num_col_y = which(colnames(mat) == name_stat)
  num_col_x = which(colnames(mat) == name_x)
  p = plot_stat_gen(mat, mat[,num_col_x], 
                    mat[,num_col_y], mat$Ne, mat$Ne,ligne = T,
                    str_c(name_stat, " en fonction des générations\n selon différentes Ne initiales"))
  p = p+ylim(min_y, max_y)+ labs(color = "Ne") + guides(linetype = FALSE)
  p = p+xlab(xlab)+ylab(ylab)
  if (name_stat == "mean.het.adm") {
    p=p+geom_hline(yintercept = 0.062, linetype = "dashed", color = "#DFAF2C")
    p=p+annotate(geom = "text",x = 1,y = 0.0635,label="s1",color = "#DFAF2C")
    p=p+geom_hline(yintercept = 0.049, linetype = "dashed", color = "#318CE7")
    p=p+annotate(geom = "text",x = 1,y = 0.0475,label="s2",color = "#318CE7")
  }
  ggsave(filename =  str_c("../../Images/", name_file, ".png"), plot = p,
         width = 6, height = 5)
}


# - Pour des populations croissantes

write_increase_plot = function(name_stat, mat, name_file, min_y, max_y, name_x = "Generation",
                               name_color = "Ne", name_line = "U",
                               labcolor = "ne0-nef", labline = "U",
                               xlab = "Generation", ylab = ""){
  num_col_y = which(colnames(mat) == name_stat)
  num_col_x = which(colnames(mat) == name_x)
  num_col_color = which(colnames(mat) == name_color)
  num_col_line = which(colnames(mat) == name_line)
  
  p = plot_stat_gen(df = mat, gen = mat[,num_col_x], 
                    stat = mat[,num_col_y], group_col = c(),
                    color_col = mat[,num_col_color], line_t = mat[,num_col_line],
                    titre = str_c(name_stat," en fonction des générations\n selon différentes croissances de populations"),
                    legd = TRUE)
  
  p = improve_plot_bottle(p =p, vec_abline = c(), lab_col = labcolor,
                          lab_line = labline, vec_linetype = c("solid", "longdash", "dotted"))
  p = p + ylim(min_y, max_y)
  p = p+xlab(xlab)+ylab(ylab)
  if (name_stat == "mean.het.adm") {
    p=p+geom_hline(yintercept = 0.062, linetype = "dashed", color = "#DFAF2C")
    p=p+annotate(geom = "text",x = 1,y = 0.0635,label="s1",color = "#DFAF2C")
    p=p+geom_hline(yintercept = 0.049, linetype = "dashed", color = "#318CE7")
    p=p+annotate(geom = "text",x = 1,y = 0.0475,label="s2",color = "#318CE7")
  }
  ggsave(filename =  str_c("../../Images/", name_file, ".png"), plot = p,
         width = 6, height = 5)
}



# - Pour des populations avec goulot d'étranglement

write_bottle_plot = function(name_stat, mat, name_file, min_y, max_y,
                             name_x = "Generation", time_bott = c(21, 51, 81),
                             name_color = "u_alpha", name_line = "time_botl",
                             labcol = "U/alpha", labline = "tb",
                             vec_abtype = c("solid", "dashed", "dotted"),
                             xlab = "Generation", ylab = ""){

  num_col_y = which(colnames(mat) == name_stat)
  num_col_x = which(colnames(mat) == name_x)
  num_col_color = which(colnames(mat) == name_color)
  num_col_line = which(colnames(mat) == name_line)

  p = plot_stat_gen(mat, mat[,num_col_x], 
                    mat[,num_col_y], c(),
                    mat[,num_col_color],
                    line_t = mat[,num_col_line],
                    str_c(name_stat, " en fonction des générations\n selon différents bottleneck\n (Ne0 = Nef = 1000)"),
                    TRUE, legd = TRUE)
  p = improve_plot_bottle(p =p, vec_abline = time_bott,
                          lab_col = labcol,
                          lab_line = labline,
                          vec_linetype = c("solid", "longdash", "dotted", "dotdash", "dashed"),
                          vec_abtype = vec_abtype)
  p = p+ylim(min_y, max_y)
  p = p+xlab(xlab)+ylab(ylab)
  if (name_stat == "mean.het.adm") {
    p=p+geom_hline(yintercept = 0.062, linetype = "dashed", color = "#DFAF2C")
    p=p+annotate(geom = "text",x = 1,y = 0.0635,label="s1",color = "#DFAF2C")
    p=p+geom_hline(yintercept = 0.049, linetype = "dashed", color = "#318CE7")
    p=p+annotate(geom = "text",x = 1,y = 0.0475,label="s2",color = "#318CE7")
  }
  ggsave(filename =  str_c("../../Images/", name_file, ".png"), plot = p,
         width = 6, height = 5)
}


# - Ecriture de plusieurs plots selon differents tb

boucle_plot_bottle = function(mat, vec_stat, name_stat, vec_bott,size_pop = 1000){
  for (bott in vec_bott) {
    new_mat = mat[which(mat$time_botl == bott),]
    new_vec = vec_stat[which(mat$time_botl == bott)]
    
    p = plot_stat_gen(new_mat, new_mat$Generation, 
                      new_vec, c(),
                      new_mat$alpha, size_point = 0,
                      str_c(name_stat, " en fonction des générations\nbottleneck ",
                            bott, " N0 ",size_pop," Nf ",size_pop),
                      TRUE,legd = TRUE, line_t = new_mat$U)
    
    p = improve_plot_bottle(p = p, vec_abline = c(1,bott+1), lab_col = "alpha",
                            lab_line = "U", vec_linetype = c("solid", "longdash", "dotted"))
    
    print(p)
  }
}


# - Ajout de l'IC 95 quand calcul de moyenne

write_ic_var_plot = function(df, xaxis, yaxis, group_col, color_col, title,
                             ylim_inf, ylim_sup, lgd_txt, name_file_1,
                             ylim_inf_2, ylim_sup_2, var_axis, name_file_2,
                             line_t = c("solid"), bot = c(),xlab="Generation",
                             ylab="stat",line_bot=FALSE){
  p = plot_stat_gen(df, xaxis, yaxis, group_col, color_col, ligne = T,
                    title, legd = TRUE,line_t = line_t)
  p = p + ylim(ylim_inf, ylim_sup)
  p = p + guides(linetype = FALSE)
  p = p + labs(color = lgd_txt)
  if (!is.null(bot)) {
    for (i in c(1:length(bot))) {
      p = p + geom_vline(xintercept = bot[i], size = 0.4,
                         color = "orange", linetype = "solid")
    }
  }
  p = p + xlab(xlab) + ylab(ylab)
  if (line_bot==TRUE) {
    p=p+geom_vline(xintercept = 81, size = 0.4,color = "orange")
  }
  print(p)
  ggsave(filename =  str_c("../../Images/", name_file_1, ".png"), plot = p)
  
  p = p + ylim(ylim_inf_2, ylim_sup_2)
  p = p+geom_errorbar(aes(ymin = yaxis - var_axis, ymax = yaxis + var_axis), width=0.6)
  
  ggsave(filename =  str_c("../../Images/", name_file_2, ".png"),plot = p)
  return(p)
}


# - Ecriture pour une génération

write_one_gen = function(df, xaxis, yaxis, color_group, xlab, ylab, t_file, t_plot,
                         add_line = FALSE, line_val = c(), line_txt = c(), line_txt_pos = c(),
                         line_col = c()){
  p = ggplot(df, aes(x = xaxis, y = yaxis, color = color_group))
  p = p+geom_point()
  p = p + xlab(xlab) + ylab(ylab)
  p = p + scale_fill_OkabeIto()
  p = p + theme_classic()
  p = p + ggtitle(t_plot)
  p = p + theme(panel.grid.major.y = element_line(size = 0.5,
                                                  linetype = 'solid',
                                                  colour = "#BABABA"),
                panel.grid.minor.y = element_line(size = 0.25,
                                                  linetype = 'solid',
                                                  colour = "#CECECE"))
  
  if (add_line) {
    for (i in 1:length(line_val)) {
      p = p+geom_hline(yintercept = line_val[i], linetype = "dashed", color = line_col[i])
      p = p+annotate(geom="text", x=0, y=line_txt_pos[i], label=line_txt[i], color=line_col[i])
    }
  }
  ggsave(filename =  str_c("../../Images/",t_file, ".png"), plot = p)
  return(p)
}

# Fonction d'affichage de graphique pour des admixtures complexes 
# (admixture récurrente et admixture two pulses)

plot_adm_ponctuel_ne_cst = function(lst_mat, seq_ne, seq_s1, name_stat, min_y, max_y, name_x = "Generation",
                                    name_color = "time_pulse_s1",yas1 = 0.027,yas2=0.022,
                                    name_dir = "",xlab="Generation",ylab="stat",title = FALSE){
  for (i in 1:length(lst_mat)) {
    for (ne in seq_ne) {
      mat_tmp = lst_mat[[i]][which(lst_mat[[i]]$Ne == ne),]
      num_col_y = which(colnames(mat_tmp) == name_stat)
      num_col_x = which(colnames(mat_tmp) == name_x)
      num_col_color =  which(colnames(mat_tmp) == name_color)
      
      p=plot_stat_gen(df = mat_tmp, gen = mat_tmp[,num_col_x],
                      stat = mat_tmp[,num_col_y], group_col = as.factor(mat_tmp$simu),
                      color_col = mat_tmp[,num_col_color],titre = str_c(name_stat," en fonction de ",name_x,
                                                                        ", \ns1.0 = ", seq_s1[i], ", Ne = ", ne))
      p=p+scale_color_gradientn(colours = c("#F7230C","orange","#F6DC12","#D1B606","#582900"))
      p=p+labs(color = name_color) + guides(linetype = FALSE)
      p=p+ylim(min_y, max_y)
      if (name_stat == "mean.het.adm") {
        p=p+geom_hline(yintercept = 0.062, linetype = "dashed", color = "#DFAF2C")
        p=p+annotate(geom = "text",x = 1,y = 0.0635,label="s1",color = "#DFAF2C")
        p=p+geom_hline(yintercept = 0.049, linetype = "dashed", color = "#318CE7")
        p=p+annotate(geom = "text",x = 1,y = 0.0475,label="s2",color = "#318CE7")
      }
      
      vec_s1 = mat_tmp$time_pulse_s1[which(mat_tmp$Generation == 0)]
      vec_s2 = mat_tmp$time_pulse_s2[which(mat_tmp$Generation == 0)]
      for (rg_pulse in c(1:length(vec_s1))) {
        pos_x_s1 = vec_s1[rg_pulse]
        pos_y_s1 = mat_tmp[(rg_pulse-1)*101+1+pos_x_s1, num_col_y]
        pos_x_s2 = vec_s2[rg_pulse]
        pos_y_s2 = mat_tmp[(rg_pulse-1)*101+1+pos_x_s2, num_col_y]
        p = p+geom_point(aes_string(x=pos_x_s1, y=pos_y_s1), colour="blue", shape = 17)
        p = p+geom_point(aes_string(x=pos_x_s2, y=pos_y_s2), colour="green", shape = 19)
      }
      
      p=p+annotate("text", x=5.5,y=yas1,label="s1", color = "blue")
      p=p+annotate("point", x=2,y=yas1, color = "blue",shape=17)
      p=p+annotate("text", x=5.5,y=yas2,label="s2", color = "green")
      p=p+annotate("point", x=2,y=yas2, color = "green")
      
      p = p + xlab(xlab) + ylab(ylab)

      if (!title) {
        p=p+ggtitle(label = element_blank())
      }
      
      if (name_dir != "") {
        name_file = str_c(name_dir,"/Ne_cst/",name_stat,"_cst_s10_", seq_s1[i],
                          "_ne_",ne,"_",name_color)
        ggsave(filename =  str_c("../../Images/pulse_ponctuel/", name_file, ".png"), plot = p,
               width = 6, height = 5)
      }

      print(p)
    }
  }
}


plot_adm_ponctuel_ne_cst_last_pulse = function(lst_mat, seq_ne, seq_s1, name_stat,
                                               min_y, max_y, name_x = "Generation"){
  for (i in 1:length(lst_mat)) {
    for (ne in seq_ne) {
      mat_tmp = lst_mat[[i]][which(lst_mat[[i]]$Ne == ne),]
      num_col_y = which(colnames(mat_tmp) == name_stat)
      num_col_x = which(colnames(mat_tmp) == name_x)
      
      p=plot_stat_gen(df = mat_tmp, gen = mat_tmp[,num_col_x],
                      stat = mat_tmp[,num_col_y], group_col = as.factor(mat_tmp$simu),
                      color_col = pmax(mat_tmp$time_pulse_s1, mat_tmp$time_pulse_s2),
                      titre = str_c(name_stat," en fonction de ",name_x,
                                    ", \ns1.0 = ", seq_s1[i], ", Ne = ", ne))
      p=p+scale_color_gradientn(colours = c("#F7230C","orange","#F6DC12","#D1B606","#582900"))
      p=p+labs(color = "time pulse s1") + guides(linetype = FALSE)
      p=p+ylim(min_y, max_y)
      print(p)

    }
  }
}


plot_adm_ponctuel_ne_cst_minus = function(lst_mat, seq_ne, seq_s1, name_stat,
                                          min_y, max_y, name_x = "Generation"){
  for (i in 1:length(lst_mat)) {
    for (ne in seq_ne) {
      mat_tmp = lst_mat[[i]][which(lst_mat[[i]]$Ne == ne),]
      num_col_y = which(colnames(mat_tmp) == name_stat)
      num_col_x = which(colnames(mat_tmp) == name_x)
      
      p=plot_stat_gen(df = mat_tmp, gen = mat_tmp[,num_col_x],
                      stat = mat_tmp[,num_col_y], group_col = as.factor(mat_tmp$simu),
                      color_col = (100 - pmax(mat_tmp$time_pulse_s1, mat_tmp$time_pulse_s2))*10 +
                        abs(mat_tmp$time_pulse_s1 - mat_tmp$time_pulse_s2),
                      titre = str_c(name_stat," en fonction de ",name_x,
                                    ", \ns1.0 = ", seq_s1[i], ", Ne = ", ne))
      p=p+scale_color_gradientn(colours = c("#F7230C","orange","#F6DC12","#D1B606","#582900"))
      p=p+labs(color = "time pulse s1") + guides(linetype = FALSE)
      p=p+ylim(min_y, max_y)
      print(p)
      
    }
  }
}

plot_adm_ponctuel_ne_inc = function(lst_mat, seq_ne, seq_s1, seq_u, name_stat,
                                    min_y, max_y, name_x = "Generation",name_dir="",
                                    xlab="Generation",ylab="stat",yas1 = 0.027,
                                    title=FALSE){
  for (i in 1:length(lst_mat)) {
    for (ne in seq_ne) {
      for (u in seq_u) {
        mat_tmp = lst_mat[[i]][which(lst_mat[[i]]$Ne == ne),]
        mat_tmp = mat_tmp[which(mat_tmp$U ==  u),]
        num_col_y = which(colnames(mat_tmp) == name_stat)
        num_col_x = which(colnames(mat_tmp) == name_x)
        
        p=plot_stat_gen(df = mat_tmp, gen = mat_tmp[,num_col_x],
                        stat = mat_tmp[,num_col_y], group_col = as.factor(mat_tmp$simu), 
                        color_col = mat_tmp$time_pulse_s1, titre = str_c(name_stat," en fonction de ",name_x,
                                                                         ", \ns1.0 = ", seq_s1[i], ", Ne0-Nef = ", ne,
                                                                         ", U = ",u))
        p=p+scale_color_gradientn(colours = c("#F7230C","orange","#F6DC12","#D1B606","#582900"))
        p=p+labs(color = "time pulse s1")  + guides(linetype = FALSE)
        p=p+ylim(min_y, max_y)
        
        vec_s1 = mat_tmp$time_pulse_s1[which(mat_tmp$Generation == 0)]
        for (rg_pulse in c(1:length(vec_s1))) {
          pos_x_s1 = vec_s1[rg_pulse]
          pos_y_s1 = mat_tmp[(rg_pulse-1)*101+1+pos_x_s1, num_col_y]
          p = p+geom_point(aes_string(x=pos_x_s1, y=pos_y_s1), colour="blue", shape = 17)
        }
        
        if (name_stat == "mean.het.adm") {
          p=p+geom_hline(yintercept = 0.062, linetype = "dashed", color = "#DFAF2C")
          p=p+annotate(geom = "text",x = 1,y = 0.0635,label="s1",color = "#DFAF2C")
          p=p+geom_hline(yintercept = 0.049, linetype = "dashed", color = "#318CE7")
          p=p+annotate(geom = "text",x = 1,y = 0.0475,label="s2",color = "#318CE7")
        }
        
        p = p + xlab(xlab) + ylab(ylab)
        if (!title) {
          p=p+ggtitle(label = element_blank())
        }
        
        p=p+annotate("text", x=5.5,y=yas1,label="s1", color = "blue")
        p=p+annotate("point", x=2,y=yas1, color = "blue",shape=17)
        
        if (name_dir != "") {
          name_file = str_c(name_dir,"/Ne_inc/",name_stat,"_cst_s10_", seq_s1[i],
                            "_ne_",ne,"_u_",u)
          ggsave(filename =  str_c("../../Images/pulse_ponctuel/", name_file, ".png"), plot = p,
                 width = 6, height = 5)
        }

        print(p)
      }
    }
  }
}

plot_adm_ponctuel_ne_bot = function(lst_mat, seq_ne, seq_s1, seq_u, seq_alpha,
                                    seq_bot, name_stat, min_y, max_y, name_x = "Generation",
                                    name_dir = "",xlab="Generation",ylab="stat",
                                    yas1 = 0.027,title=FALSE){
  for (i in 1:length(lst_mat)) {
    for (ne in seq_ne) {
      for (u in seq_u) {
        for (alpha in seq_alpha) {
          for (bot in seq_bot) {
            mat_tmp = lst_mat[[i]][which(lst_mat[[i]]$Ne == ne),]
            mat_tmp = mat_tmp[which(mat_tmp$U ==  u),]
            mat_tmp = mat_tmp[which(mat_tmp$alpha ==  alpha),]
            mat_tmp = mat_tmp[which(mat_tmp$time_botl ==  bot),]
            num_col_y = which(colnames(mat_tmp) == name_stat)
            num_col_x = which(colnames(mat_tmp) == name_x)
            
            p=plot_stat_gen(df = mat_tmp, gen = mat_tmp[,num_col_x],
                            stat = mat_tmp[,num_col_y], group_col = as.factor(mat_tmp$simu), 
                            color_col = mat_tmp$time_pulse_s1,
                            titre = str_c(name_stat," en fonction de ",name_x,
                                          ", \ns1.0=", seq_s1[i], ",Ne0-Nef=", ne,
                                          ",U=",u, ",a=",alpha,",tb=",bot))
            p=p+scale_color_gradientn(colours = c("#F7230C","orange","#F6DC12","#D1B606","#582900"))
            p=p+labs(color = "time pulse s1")  + guides(linetype = FALSE)
            p=p+ylim(min_y, max_y)
            
            vec_s1 = mat_tmp$time_pulse_s1[which(mat_tmp$Generation == 0)]
            for (rg_pulse in c(1:length(vec_s1))) {
              pos_x_s1 = vec_s1[rg_pulse]
              pos_y_s1 = mat_tmp[(rg_pulse-1)*101+1+pos_x_s1, num_col_y]
              p = p+geom_point(aes_string(x=pos_x_s1, y=pos_y_s1), colour="blue", shape = 17)
            }
            p=p+geom_vline(xintercept = bot+1, size = 0.4,color = "orange")
            
            if (name_stat == "mean.het.adm") {
              p=p+geom_hline(yintercept = 0.062, linetype = "dashed", color = "#DFAF2C")
              p=p+annotate(geom = "text",x = 1,y = 0.0635,label="s1",color = "#DFAF2C")
              p=p+geom_hline(yintercept = 0.049, linetype = "dashed", color = "#318CE7")
              p=p+annotate(geom = "text",x = 1,y = 0.0475,label="s2",color = "#318CE7")
            }
            
            if (!title) {
              p=p+ggtitle(label = element_blank())
            }
            p = p + xlab(xlab) + ylab(ylab)
            p=p+annotate("text", x=5.5,y=yas1,label="s1", color = "blue")
            p=p+annotate("point", x=2,y=yas1, color = "blue",shape=17)
            
            if (name_dir != "") {
              name_file = str_c(name_dir,"/Ne_bot/",name_stat,"_cst_s10_", seq_s1[i],
                                "_ne_",ne,"_u_",u,"_alpha_", alpha, "_bot_", bot)
              ggsave(filename =  str_c("../../Images/pulse_ponctuel/", name_file, ".png"), plot = p,
                     width = 6, height = 5)
            }
            
            print(p)
          }
        }
        
      }
    }
  }
}


# Affichage des histogrammes pour comparer MetHis et ADMIXTURE

hist_one_line = function(df, color = "#F6DC12", color2 = "#F9429E"){
  vec_y = c(df$perc0.adm.props,
            df$perc10.adm.props,
            df$perc20.adm.props,
            df$perc30.adm.props,
            df$perc40.adm.props,
            df$perc50.adm.props,
            df$perc60.adm.props,
            df$perc70.adm.props,
            df$perc80.adm.props,
            df$perc90.adm.props,
            df$perc100.adm.props)
  
  hist(vec_y, breaks = vec_y, main=df$Generation, col = color, xlim = c(-0.1, 1.1))
  abline(v = df$mean.adm.props, col = color2, lty = 2, lwd=3)
  
}


hist_methis = function(seq_gen){
  df_methis = data.frame.stat(seq_ne = c(100), max_gen = 81, max_simu = 1)
  
  lst_met_gen = list()
  cpt = 1
  for (gen in seq_gen) {
    lst_met_gen[[cpt]] = df_methis[which(df_methis$Generation == gen),]
    cpt = cpt+1
  }
  
  for (i in 1:length(lst_met_gen)) {
    hist_one_line(lst_met_gen[[i]])
  }
  return(lst_met_gen)
}


hist_admixture = function(seq_gen){
  lst_adm_gen = list()
  cpt=1
  for (gen in seq_gen) {
    lst_adm_gen[[cpt]] = read.table(str_c("simu_1_g",gen,".2.Q"), header = FALSE)
    if (gen > 19) {
      lst_adm_gen[[cpt]] = lst_adm_gen[[cpt]][50:100,]
    }else{
      lst_adm_gen[[cpt]] = lst_adm_gen[[cpt]][1:50,]
    }
    cpt=cpt+1
  }
  for (i in c(1:length(lst_adm_gen))) {
    hist(lst_adm_gen[[i]]$V1, col = "#F6DC12", xlim = c(-0.1, 1.1))
    abline(v = mean(lst_adm_gen[[i]]$V1), col = "#F9429E", lty = 2, lwd=3)
  }
  return(lst_adm_gen)
}


hist_only_admixture = function(lst, vec_col, seq_gen){
  if (length(lst) != length(vec_col) & length(lst) != length(seq_gen)) {
    print("Length list =/= length vector columns")
    return()
  }
  
  for (i in c(1:length(lst))) {
    hist(lst[[i]][,vec_col[i]], col = "#F6DC12", xlim = c(-0.1, 1.1), main = seq_gen[i])
    abline(v = mean(lst[[i]][,vec_col[i]]), col = "#F9429E", lty = 2, lwd=3)
  }
}


