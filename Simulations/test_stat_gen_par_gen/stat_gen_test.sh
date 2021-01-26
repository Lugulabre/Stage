#!/bin/bash

#depuis répertoire Stage

for (( i = 1; i < 5; i++ )); do
	#statements
	((a = 10**$i))
	echo $a
done

#../../tools/MetHis/generate_params.py -S 10 -N 100 -P gen1 --Ne 100/Con/100-100 --contrib_s1 default/Pulse/1/default --contrib_s2 default/Pulse/1/default


#../../tools/MetHis/MetHis --nb-snp 500 --max-Ne 200 --prefix gen1 --nb-simul 10 --nb-thread 20 --input-path ../../tools/MetHis/example_dataset/input_example.txt 
