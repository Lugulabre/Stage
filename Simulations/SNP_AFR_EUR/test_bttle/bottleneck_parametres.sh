#!/bin/bash

#depuis répertoire Stage/Simulations/old_methis_pop_increase

debut=$(date +%s)

for alpha in 0.1 0.5 0.9; do
    if [[ ! -d  "alpha$alpha" ]]; then
        mkdir "alpha$alpha"
    fi

    for nu in 1 25 49; do

        if [[ $nu -lt 10 ]]; then
            nu_div="0$nu"
        else
            nu_div="$nu"
        fi

        if [[ ! -d  "alpha$alpha/Nu0.$nu_div" ]]; then
            mkdir "alpha$alpha/Nu0.$nu_div"
        fi

        for (( ne0 = 1000; ne0 < 1001; ne0=ne0+2 )); do
            if [[ ! -d  "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX" ]]; then
                mkdir "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX"
            fi
            
            for (( nen = 1000; nen < 1001; nen=nen+2 )); do
                if [[ ! -d  "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX/Ne$ne0-$nen" ]]; then
                    mkdir "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX/Ne$ne0-$nen"
                fi

                for (( tps_gen = 10; tps_gen < 100; tps_gen=tps_gen+10 )); do
                    rm -r  "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX/Ne$ne0-$nen/bottle$tps_gen"
                    mkdir "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX/Ne$ne0-$nen/bottle$tps_gen"

                    ne0red=`echo "$alpha *$ne0" | bc`
                    ne0red=${ne0red%.*}
                    ((size_max_ne = $nen*2))

                    ../../../tools/MetHis_modif/generate_params_nu.py -S 1 -N $tps_gen -P "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX/Ne$ne0-$nen/bottle$tps_gen" --Ne "$ne0red/Inc/$nen-$nen" --contrib_s1 default/Pulse/0 --contrib_s2 default/Pulse/0 --Nu $nu --force-rewrite

                    ./modif_param.R $alpha $nu_div $ne0 $nen $tps_gen

                    ../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "alpha$alpha/Nu0.$nu_div/Ne$ne0-XXX/Ne$ne0-$nen/bottle$tps_gen/" --nb-simul 1 --nb-thread 30 --input-path ../../../tools/MetHis_modif/example_dataset/data_50k.arp

                done

            done

        done

    done
    
done


fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"

