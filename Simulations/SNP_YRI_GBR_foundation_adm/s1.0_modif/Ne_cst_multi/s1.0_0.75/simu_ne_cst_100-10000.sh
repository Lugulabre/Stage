#!/bin/bash

#depuis répertoire Stage/Simulations/new_methis_pop_size_diff

debut=$(date +%s)

for pow in 100 1000 10000; do
    #echo $pow
    ((size_ne = $pow))
    ((size_max_ne = $size_ne*2))
    rm -r "Ne$size_ne"
    mkdir "Ne$size_ne"

    ../../../../../tools/MetHis_modif/generate_params.py -S 100 -N 100 -P "Ne$size_ne/" --Ne "$size_ne/Con/$size_ne-$size_ne" --contrib_s1 0.75/Pulse/0 --contrib_s2 0.25/Pulse/0 --force-rewrite

    ../../../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "Ne$size_ne" --nb-simul 100 --nb-thread 20 --input-path ../../../../../tools/MetHis_modif/example_dataset/data_50k.arp

done

#../../tools/MetHis/generate_params.py -S 10 -N $j -P "Ne$a/gen$j" --Ne "$a/Con/$a-$a" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite True
#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix "gen$j" --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"
