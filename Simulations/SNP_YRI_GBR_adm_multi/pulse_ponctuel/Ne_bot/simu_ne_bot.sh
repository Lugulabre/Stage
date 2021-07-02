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

    for alpha in 0.1 0.5 0.9; do
        if [[ ! -d  "s1.0_0.$s1/alpha$alpha" ]]; then
            mkdir "s1.0_0.$s1/alpha$alpha"
        fi

        for nu in 0.01 0.25 0.49; do
            # 0.25 0.49

            if [[ ! -d  "s1.0_0.$s1/alpha$alpha/Nu$nu" ]]; then
                mkdir "s1.0_0.$s1/alpha$alpha/Nu$nu"
            fi

            for tps_gen in 20 50 80; do
                if [[ ! -d  "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen" ]]; then
                    mkdir "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen"
                fi
                
                for (( ne0 = 1000; ne0 < 1001; ne0=ne0+1000 )); do
                    if [[ ! -d  "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX" ]]; then
                        mkdir "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX"
                    fi

                    for (( nen = 1000; nen < 1001; nen=nen+1000 )); do

                        rm -r  "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen"
                        mkdir "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen"

                        ne0red=`echo "$alpha *$ne0" | bc`
                        ne0red=${ne0red%.*}
                        ((size_max_ne = $nen*2))

                        ../../../../tools/MetHis_modif/generate_params_nu.py -S 20 -N $tps_gen -P "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen" --Ne "$ne0red/Inc/$nen-$nen" --contrib_s1 0.$s1/Pulse/1/$pop1-$pop1 --contrib_s2 0.$s2/Pulse/0 --Nu $nu --force-rewrite

                        ../../../../tools/MetHis_modif/bottleneck_param_s10_adm_cst.py -S10 $s1 -A $alpha -U $nu -ne0 $ne0 -nef $nen -B $tps_gen -G 100 -S 20 -S1 0 -S2 0

                        ../../../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 50000 --max-Ne $size_max_ne --prefix "s1.0_0.$s1/alpha$alpha/Nu$nu/bottle$tps_gen/Ne$ne0-XXX/Ne$ne0-$nen/" --nb-simul 20 --nb-thread 20 --input-path ../../../../tools/MetHis_modif/example_dataset/data_50k.arp

                    done

                done

            done

        done

    done
done


fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"