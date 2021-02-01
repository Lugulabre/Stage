#!/bin/bash

#depuis répertoire Stage/Simulations/test_gen_par_gen

debut=$(date +%s)

for (( pow = 2; pow < 5; pow++ )); do
    #echo $pow
    ((size_ne = 10**$pow))
    ((size_max_ne = $size_ne*2))
    rm -r "Ne$size_ne"
    mkdir "Ne$size_ne"
    for (( nb_gen = 1; nb_gen < 101; nb_gen++ )); do

        ../../tools/MetHis/generate_params.py -S 100 -N $nb_gen -P "Ne$size_ne/gen$nb_gen" --Ne "$size_ne/Con/$size_ne-$size_ne" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite

        ../../tools/MetHis/MetHis --nb-snp 500 --max-Ne $size_max_ne --prefix "Ne$size_ne/gen$nb_gen" --nb-simul 100 --nb-thread 30 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

    done
done

#../../tools/MetHis/generate_params.py -S 10 -N $j -P "Ne$a/gen$j" --Ne "$a/Con/$a-$a" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite True
#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix "gen$j" --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "$duree secondes"