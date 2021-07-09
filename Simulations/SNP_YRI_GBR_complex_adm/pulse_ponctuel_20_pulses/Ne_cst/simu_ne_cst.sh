#!/bin/bash

#depuis répertoire Stage/Simulations/new_methis_pop_size_diff

debut=$(date +%s)

for s1 in 1 5 75; do

    if [[ ! -d  "s1.0_0.$s1" ]]; then
        mkdir "s1.0_0.$s1"
    fi

    pop1='0.25'
    pop2='0.25'

    if [[ $s1 = 1 ]]; then
        s2='9'
    elif [[ $s1 = 5 ]]; then
        s2='5'
    else
        s2='25'
    fi

    for ne in 100 1000 10000; do
        #echo $pow
        ((size_ne = $ne))
        
        ((size_max_ne = $size_ne*2))
        rm -r "s1.0_0.$s1/Ne$size_ne"
        mkdir "s1.0_0.$s1/Ne$size_ne"

        ../../../../tools/MetHis_modif/generate_params.py -S 20 -N 100 -P "s1.0_0.$s1/Ne$size_ne/" --Ne "$size_ne/Con/$size_ne-$size_ne" --contrib_s1 0.$s1/Pulse/20/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1/$pop1-$pop1 --contrib_s2 0.$s2/Pulse/0 --force-rewrite

        ../../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "s1.0_0.$s1/Ne$size_ne" --nb-simul 20 --nb-thread 30 --input-path ../../../../tools/MetHis_modif/example_dataset/data_50k.arp

    done
done


fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"
