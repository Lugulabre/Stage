# Descriptif des répertoires

## Biblio
Deux sous-répertoires : "articles" dans lequel sont présents les articles de référence, et "notes" dans lequel sont listés la majorité des articles vus, avec des notes résumant l'article

## Images
Plot générés par les script R.
4 répertoires sont présents :
- Ne : sont présents ici les graphiques montrant le Ne en fonction des générations pour les différents scénarios démographiques
- pulse_fondation : graphiques pour un scénario d'admixture à la fondation
- pulse_fondation_multi_simu : graphiques pour un scénario d'admixture à la fondation pour des simulations multiples moyennées (nb : 100 simulations par scénario)
- pulse_ponctuel : graphiques pour un scénario d'admixture ponctuel (1 pulse de chaque génération source pour des populations constantes, 1 pulse de s1 pour des populations croissantes et avec goulot d'étranglement)
- pulse_recurrent : graphiques pour un scénario d'admixture récurrente

Dans chaque répertoire, on trouve des sous-répertoires correspondants à différentes statistiques :
- mean.He : Hétérozygotie moyenne
- Fst.s1.adm : indice de fixation entre s1 et la population métissée
- Fst.s2.adm : indice de fixation entre s2 et la population métissée
- mean.F : indice de consanguinité moyen
- f3
- mean.adm : taux d'admixture moyen
- var.adm : variance du taux d'admixture
- delta.mean.adm : différence entre le taux d'admixture moyen observé et attendu
- delta.var.adm : différence entre la variance du taux d'admixture observée et attendue
- delta.adm0.adm : différence entre le taux d'admixture moyen à la génération g et celui à la génération 0
- hist.adm.props : distribution du taux d'admixture sur 100 générations (en gif)
- stat_generation_0 : certaines statistiques choisies pour observer leur comportement en fonction du s1.0 à la génération 0
- stat_generation_100 : certaines statistiques choisies pour observer leur comportement en fonction du s1.0 à la génération 100

Dans chacun des répertoires de statistiques sont présents 3 sous-répertoires : 
- Ne_bot : pour des populations avec goulot d'étranglement
- Ne_cst : pour des populations constantes
- Ne_inc : pour des populations croissantes

## Journal
Suivi personnel du stage

## scriptR
Scripts en R permettant de traiter les données des simulations.
Les fonctions utilisées sont dans le script "functions.R".
Le rmarkdown "new_methis_50000_snp_simple_adm.Rmd" contient les scripts permettant de travailler sur le scénario d'admixture à la fondation pour des simulations simples.
Le rmarkdown "new_methis_50000_snp_simple_adm_multi.Rmd" contient les scripts permettant de travailler sur le scénario d'admixture à la fondation pour des simulations multiples et moyennées.
Le rmarkdown "new_methis_50000_snp_complex_adm.Rmd" contient les scripts permettant de travailler sur les scénarios d'admixture récurrente et ponctuelle.

## Simulations
Le répertoire SNP_AFR_EUR contient les simulations pour un scénario d'admixture à la fondation.
Le répertoire SNP_YRI_GBR_multi contient les simulations pour les scénarios d'admixture récurrente et ponctuelle.
Chaque sous-répertoire contient un type de simulation et de scénario simulés selon des paramètres pouvant être modifiés.
Scénarios démographiques simulés : populations constantes de différentes tailles initiales, populations croissantes et bottleneck.
Les répertoires les plus essentiels sont ceux utilisant 50000 SNP sur les data utilisées.
(! Les simulations ne sont pas disponibles sur le répertoire github pour des raisons de taille de stockage)

## tools
Les outils utilisés pour les simulations (nb : MetHis_save est l'outil MetHis modifié pour être utilisé en séquentiel + modification du U + implémentation du bottleneck).
Les scripts implémentés sont "bottleneck_param.py" et "bottleneck_param_s10_adm_cst.py" dans le répertoire Methis_save. Les scripts modifiés sont "generate_params_nu.py", "src/simul.c" et "src/sumstats.c" dans le répertoire Methis_save.

