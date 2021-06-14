#!/bin/bash

#depuis répertoire Stage/Simulations/new_methis_pop_size_diff

debut=$(date +%s)


for s1 in 1 5 75; do

    if [[ ! -d  "s1.0_0.$s1" ]]; then
        mkdir "s1.0_0.$s1"
    fi

    if [[ $s1 = 1 ]]; then
        s2='9'
    elif [[ $s1 = 5 ]]; then
        s2='5'
    else
        s2='25'
    fi

    for gen in 80; do

        if [[ ! -d  "s1.0_0.$s1/gen$gen" ]]; then
            mkdir "s1.0_0.$s1/gen$gen"
        fi

        for pow in 100 ; do
            #echo $pow
            ((size_ne = $pow))
            ((size_max_ne = $size_ne*2))
            rm -r "s1.0_0.$s1/gen$gen/Ne$size_ne"
            mkdir "s1.0_0.$s1/gen$gen/Ne$size_ne"

            ../../../../tools/MetHis_modif/generate_params.py -S 1 -N $gen -P "s1.0_0.$s1/gen$gen/Ne$size_ne/" --Ne "$size_ne/Con/$size_ne-$size_ne" --contrib_s1 0.$s1/Pulse/0 --contrib_s2 0.$s2/Pulse/0 --force-rewrite

            ../../../../tools/MetHis_modif/MetHis --sampling 50/50/50 --nb-snp 50000 --max-Ne $size_max_ne --prefix "s1.0_0.$s1/gen$gen/Ne$size_ne" --nb-simul 1 --nb-thread 20 --input-path ../../../../tools/MetHis_modif/example_dataset/data_50k.arp --save-data True

        done

    done


done

#../../tools/MetHis/generate_params.py -S 10 -N $j -P "Ne$a/gen$j" --Ne "$a/Con/$a-$a" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite True
#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix "gen$j" --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"
