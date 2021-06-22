# Descriptif des répertoires

## Biblio
Deux sous-répertoires : articles dans lequel sont présents les articles de référence, et notes dans lequel sont listés la majorité des articles vus, avec des notes résumant l'article

## Images
Plot générés par le script R, rangés selon les data utilisées, les stats représentées ou les scénarios suivis

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

###IMPORTANT
Il est possible que ce github subisse des modifications postérieurement au 20/06 (date de rendu du mémoire), en raison de travaux toujours en cours. J'essaierai de faire en sorte que la branche principale soit le moins modifiée possible jusqu'au rendu des notes, mais il est possible que des fusions de branche me soit nécessaire.
