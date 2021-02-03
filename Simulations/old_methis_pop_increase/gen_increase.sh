#!/bin/bash

#depuis répertoire Stage/Simulations/old_methis_pop_increase

debut=$(date +%s)

for (( ne0 = 30; ne0 < 120; ne0=ne0+20 )); do
    #echo $ne0
    for (( nen = 100; nen < 10000; nen=nen*3 )); do
    	#echo $nen
    	rm -r "Ne$ne0-$nen"
    	mkdir "Ne$ne0-$nen"
    	((size_max_ne = $nen*2))
    	for (( nb_gen = 1; nb_gen < 101; nb_gen++ )); do

    		../../tools/MetHis/generate_params.py -S 100 -N $nb_gen -P "Ne$ne0-$nen/gen$nb_gen" --Ne "$ne0/Inc/$nen-$nen" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite

    		../../tools/MetHis/MetHis --sampling 25/25/25 --nb-snp 500 --max-Ne $size_max_ne --prefix "Ne$ne0-$nen/gen$nb_gen" --nb-simul 100 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt

    	done

    done

done

#../../tools/MetHis/generate_params.py -S 10 -N $j -P "Ne$a/gen$j" --Ne "$a/Con/$a-$a" --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default --force-rewrite True
#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix "gen$j" --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Durée totale : $duree secondes"

