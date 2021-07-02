# Descriptif des répertoires

## Biblio
Trois sous-répertoires : "articles" dans lequel sont présents les articles de référence, "notes_biblio" dans lequel sont listés la majorité des articles vus, avec des notes résumant l'article et "notes_perso".

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

##rapport&presentations
Le répertoire contient le rapport final ainsi que deux présentations effectuées pendant le stage.

## scriptR
Scripts en R permettant de traiter les données des simulations.
Les fonctions utilisées sont dans le script "functions.R".

Le rmarkdown "new_methis_50000_snp_simple_adm.Rmd" contient les scripts permettant de travailler sur le scénario d'admixture à la fondation pour des simulations simples.

Le rmarkdown "new_methis_50000_snp_simple_adm_multi.Rmd" contient les scripts permettant de travailler sur le scénario d'admixture à la fondation pour des simulations multiples et moyennées.

Le rmarkdown "new_methis_50000_snp_complex_adm.Rmd" contient les scripts permettant de travailler sur les scénarios d'admixture récurrente et ponctuelle.

Le rmarkdown "comparaison_admixture.Rmd" contient les scripts permettant de comparer le calcul du taux d'admixture de MetHis et de ADMIXTURE.

## Simulations
Le répertoire "SNP_YRI_GBR_foundation_adm" contient les simulations pour un scénario d'admixture à la fondation.
Sont présents dans ce répertoire les simulations pour des populations constantes ("Ne_cst"), des populations croissantes ("Ne_inc") et avec goulot d'étranglement ("Ne_bot").

Pour des populations croissantes, le suffixe "U_fix" est ajouté pour les populations croissantes où le u déterminant l'incurvation est fixé.

Le suffixe "multi" est ajouté pour les simulations multiples (100 simulations).

"ns_modif" est le répertoire où la taille d'échantillonage est modifiée.

"s1.0_modif" est le répertoire où le s1.0 est modifié et fixé (0.1, 0.5, 0.75 et 0.9).

"test_logiciel_admixture" contient les simulations utilisées pour la comparaison avec le logiciel ADMIXTURE.

Les répertoires "old_methis" sont ceux avec les simulations effectuées avec MetHis qui n'est pas en séquentiel.

Le répertoire "SNP_YRI_GBR_complex_adm" contient les simulations pour les scénarios d'admixture récurrente et ponctuelle.
Le sous-répertoire "pulse_ponctuel" contient les simulations avec : 
- un pulse de s1 et un pulse de s2 à 0.25 pour Ne_cst
- un pulse de s1 à 0.25 pour Ne_inc et Ne_bot

Le sous-répertoire "pulse_recurrent" contient les simulations avec des pulses récurrents à chaque génération avec des taux entre 0.05 et 0.1 (cf rapport&presentations/Rapport -> Matériel et méthodes).

Le sous-répertoire "pulse_recurrent" contient les simulations avec des pulses récurrents à chaque génération avec des taux entre 0.01 et 0.02.

(! Les simulations ne sont pas disponibles sur le répertoire github pour des raisons de taille de stockage)

## tools
"MetHis" contient l'outil MetHis initial.

"MetHis_modif" contient l'outil MetHis modifié pour être utilisé en séquentiel hard-codé.

"MetHis_save" contient l'outil MetHis modifié pour être utilisé en séquentiel de manière optionnelle, en plus des scripts utilisés pour générer une population avec goulot d'étranglement. Les modifications implémentées sont indiquées dans le document "MetHis_save/modifications_methis.txt".

"admixture_alexander" contient les tests effectués avec ADMIXTURE qui sont analysés avec le script "comparaison_admixture.Rmd"