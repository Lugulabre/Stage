#!/bin/bash

#depuis répertoire Stage/Simulations/old_methis_pop_increase

debut=$(date +%s)

for alpha in 0.1; do
    if [[ ! -d  "alpha$alpha" ]]; then
        mkdir "alpha$alpha"
    fi

    for nu in 0.01 0.25 0.49; do
        # 0.25 0.49

        if [[ ! -d  "alpha$alpha/Nu$nu" ]]; then
            mkdir "alpha$alpha/Nu$nu"
        fi

        for tps_gen in 80; do
            if [[ ! -d  "alpha$alpha/Nu$nu/bottle$tps_gen" ]]; then
                mkdir "alpha$alpha/Nu$nu/bottle$tps_gen"
            fi
            
            for (( ne0 = 1000; ne0 < 1001; ne0=ne0+1000 )); do
                if [[ ! -d  "alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX" ]]; then
                    mkdir "alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX"
                fi

                for (( nen = 1000; nen < 1001; nen=nen+1000 )); do

                    rm -r  "alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen"
                    mkdir "alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen"

                    ne0red=`echo "$alpha *$ne0" | bc`
                    ne0red=${ne0red%.*}
                    ((size_max_ne = $nen*2))

                    ../../../../../tools/MetHis_modif/generate_params_nu.py -S 100 -N $tps_gen -P "alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen" --Ne "$ne0red/Inc/$nen-$nen" --contrib_s1 0.1/Pulse/0 --contrib_s2 0.9/Pulse/0 --Nu $nu --force-rewrite

                    ../../../../../tools/MetHis_modif/bottleneck_param.py -A $alpha -U $nu -ne0 $ne0 -nef $nen -B $tps_gen -G 100 -S 100

                    ../../../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen/" --nb-simul 100 --nb-thread 20 --input-path ../../../../../tools/MetHis_modif/example_dataset/data_50k.arp

                done

            done

        done

    done

done


fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"

