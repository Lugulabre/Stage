#!/bin/bash

#depuis répertoire Stage/Simulations/old_methis_pop_increase

debut=$(date +%s)

for nu in 0.01 0.25 0.49; do

    if [[ ! -d  "Nu$nu" ]]; then
        mkdir "Nu$nu"
    fi

    for (( ne0 = 100; ne0 < 101; ne0=ne0+10 )); do
        
        if [[ ! -d "Nu$nu/Ne$ne0-XXX" ]]; then
            mkdir "Nu$nu/Ne$ne0-XXX"
        fi

        for nen in 10000; do
            #echo $nen
            #((nen=$ne0*$pre_nen))
            #comp=$nen-$ne0
            #if [[ $comp -gt 0 ]]; then
                #statements
            rm -r "Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen"
            mkdir "Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen"
            ((size_max_ne = $nen*2))

            ../../../../../tools/MetHis_modif/generate_params_nu.py -S 100 -N 100 -P "Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen/" --Ne "$ne0/Inc/$nen-$nen" --contrib_s1 0.5/Pulse/0 --contrib_s2 0.5/Pulse/0 --Nu $nu --force-rewrite

            ../../../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen/" --nb-simul 100 --nb-thread 20 --input-path ../../../../../tools/MetHis_modif/example_dataset/data_50k.arp
            #else
            #    rm -r "Nu$nu/Ne$ne0-XXX/Ne$ne0-$nen"
            #fi
        done

    done

done

#../../tools/MetHis/generate_params.py -S 10 -N $j -P "Ne$a/gen$j" --Ne "$a/Con/$a-$a" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite True
#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix "gen$j" --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"

