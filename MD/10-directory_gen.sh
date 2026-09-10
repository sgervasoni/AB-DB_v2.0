#!/bin/bash
# Creation of a single pdb file with clusters rep
for i in $(seq 0 9); do cat cl.c${i}.pdb >> clusters.pdb ; done
# Generation of different formats 
for j in $(ls cl.c*.pdb)
do
filelig=$(basename ${j})
namelig=$(echo ${filelig} |  awk 'BEGIN{FS="."}{print $2}')
echo ${namelig}
babel ${filelig} ${namelig}.sd > output_babel1
babel ${filelig} ${namelig}.mol2 > output_babel2
(
. ${MGLENV}
${PYTHONPATH}/AutoDockTools/Utilities24/prepare_ligand4.py -Z -l ${namelig}.mol2 -o ${namelig}.pdbqt > output_pl
)
done
#
# create a .tar archive for the files generated
#
mkdir lig
mv cl.*.pdb c*.sd c*.pdbqt c*.mol2 ./lig
tar cvzf lig.tgz lig/* > output_tar
