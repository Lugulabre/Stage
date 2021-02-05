#!/bin/bash

#depuis répertoire Stage/Simulations/old_methis_pop_increase

debut=$(date +%s)

for (( ne0 = 50; ne0 < 120; ne0=ne0+20 )); do
    #echo $ne0
    for (( nen = 120; nen < 10000; nen=nen*3 )); do
        #echo $nen
        if [ nen-ne0 > 0 ]; then
            #statements
            rm -r "Ne$ne0-$nen"
            mkdir "Ne$ne0-$nen"
            ((size_max_ne = $nen*2))

            ../../tools/MetHis_modif/generate_params.py -S 100 -N 100 -P "Ne$ne0-$nen/" --Ne "$ne0/Inc/$nen-$nen" --contrib_s1 default/Pulse/0 --contrib_s2 default/Pulse/0 --force-rewrite

            ../../tools/MetHis_modif/MetHis --sampling 25/25/25 --nb-snp 500 --max-Ne $size_max_ne --prefix "Ne$ne0-$nen/" --nb-simul 100 --nb-thread 10 --input-path ../../tools/MetHis/example_dataset/input_example.txt
        else
            rm -r "Ne$ne0-$nen"
        fi
    done

done

#../../tools/MetHis/generate_params.py -S 10 -N $j -P "Ne$a/gen$j" --Ne "$a/Con/$a-$a" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite True
#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix "gen$j" --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"
