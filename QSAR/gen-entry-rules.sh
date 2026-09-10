#!/bin/bash
#. $HOME/miniconda/etc/profile.d/conda.sh
#conda activate entry-cli-env
#
#newgrp db
#umask 006
#
#for class in Streptogramins; do
for class in $(ls -d */) 
do
class=$(basename $class)
cd $class
for compound in $(ls -d */) 
do
compound=$(basename $compound)
#echo "Compound: "$compound
cd $compound/geom
# remove existing files
	rm -f opt.smi opt.csv
	#/usr/local/openbabel3/bin/obabel -isdf opt.sdf -osmi -Oopt.smi
	babel opt.sdf opt.smi
    # openbabel sets no molecule name, add
	cat opt.smi | tr -d '\n' > opt.tmp
	echo "$compound" >> opt.tmp
	mv opt.tmp opt.smi
	python /biodb/SCRIPTS/calc_props.py -b opt.smi
	if [ $? == "0" ]; then
		echo $compound "calc_props.py completed"
	else
		echo $compound "calc_props.py error"
	fi
cd ../../
done
cd ../
done

exit 0
