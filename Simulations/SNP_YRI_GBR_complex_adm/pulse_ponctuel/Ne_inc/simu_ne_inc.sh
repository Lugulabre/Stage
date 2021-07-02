#!/bin/bash

#depuis répertoire Stage/Simulations/new_methis_pop_size_diff

debut=$(date +%s)

for s1 in 1 5 75; do

    if [[ ! -d  "s1.0_0.$s1" ]]; then
        mkdir "s1.0_0.$s1"
    fi

    pop1='0.25'

    if [[ $s1 = 1 ]]; then
        s2='9'
    elif [[ $s1 = 5 ]]; then
        s2='5'
    else
        s2='25'
    fi

    for nu in 0.01 0.25 0.49; do

        if [[ ! -d  "s1.0_0.$s1/Nu$nu" ]]; then
            mkdir "s1.0_0.$s1/Nu$nu"
        fi

        for ne0 in 100; do
            
            if [[ ! -d "s1.0_0.$s1/Nu$nu/Ne$ne0-XXX" ]]; then
                mkdir "s1.0_0.$s1/Nu$nu/Ne$ne0-XXX"
            fi

            for nen in 400; do

                rm -r "s1.0_0.$s1/Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen"
                mkdir "s1.0_0.$s1/Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen"
                ((size_max_ne = $nen*2))

                ../../../../tools/MetHis_modif/generate_params_nu.py -S 20 -N 100 -P "s1.0_0.$s1/Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen/" --Ne "$ne0/Inc/$nen-$nen" --contrib_s1 0.$s1/Pulse/1/$pop1-$pop1 --contrib_s2 0.$s2/Pulse/0 --Nu $nu --force-rewrite

                ../../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "s1.0_0.$s1/Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen/" --nb-simul 20 --nb-thread 20 --input-path ../../../../tools/MetHis_modif/example_dataset/data_50k.arp

            done

        done

    done
done


fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"
