#!/bin/bash

dir=/data/biodb/V2/new_set
dbcsv=/data/biodb/V2/descriptors/QM_descriptors_xtb.csv
sub1=_+
sub2=_-
PY=/data/biodb/SCRIPTS

printf "%s," "Class" "Compound" "Batch" "DFT_energy" "HOMO" "LUMO" "HL_gap" "Dipole" "Isotropic_pol" "Anisotropic_pol" "Rot_const_A" "Rot_const_B" "Rot_const_C" "E_thermal" "CV" "S" > $dbcsv

printf "\n" >> $dbcsv

for class in cyclic-polypeptides lipo-glyco-peptides phospho-glyco-lipids polymyxin riminofenazines; do
echo $class
for mol in `ls $dir/$class`; do
echo $mol
printf "%s," ${class} >> $dbcsv

dest=${dir}/${class}/${mol}
if [ ${dest} != $dbcsv ]; then
	# 49 DFT energy
        DFT=$(grep "SCF Done" ${dest}/chgs/mol.log | awk '{print $5}')
        # 50 HOMO 51 LUMO
        if grep -q "Beta virt" ${dest}/chgs/mol.log; then
        	homo=$(grep "Beta  occ. eigenvalues" ${dest}/chgs/mol.log | tail -1 | awk '{print $NF}')
                lumo=$(grep "Beta virt. eigenvalues" ${dest}/chgs/mol.log | head -1 | awk '{print $5}')
        else
                homo=$(grep "Alpha  occ. eigenvalues" ${dest}/chgs/mol.log | tail -1 | awk '{print $NF}')
                lumo=$(grep "Alpha virt. eigenvalues" ${dest}/chgs/mol.log | head -1 | awk '{print $5}')
        fi
        # 52 HL gap in a.u
        gap=$(echo $lumo $homo | awk '{print $1 - $2}')
        #HLgap=$(echo $gap 27.2116 | awk '{print $1 * $2}')
        #echo "HL gap in eV: "$HLgap
        # 53 dipole moment
        dipole=$(grep " X= " ${dest}/chgs/mol.log | awk '{print $8}')

	# Compute polarizability
	python /das/ab-db/descr_script/xtb_polar_p3.py ${dest}/geom/freq.out > ${dest}/geom/pol.txt	

        # 54 isotropic polarizability
        isopol=$(awk '{print $2}' ${dest}/geom/pol.txt)
        # 55 anisotropic polarizability
        anisopol=$(awk '{print $3}' ${dest}/geom/pol.txt)
        # 56 57 58 rotational constants
        rota=$(grep "Rotational constants" ${dest}/chgs/mol.log | awk '{print $4}')
        rotb=$(grep "Rotational constants" ${dest}/chgs/mol.log | awk '{print $5}')
        rotc=$(grep "Rotational constants" ${dest}/chgs/mol.log | awk '{print $6}')
        # 59 60 61 E CV S
        ene=$(grep "Total     " ${dest}/geom/mol.log | awk '{print $2}')
        cv=$(grep "Total     " ${dest}/geom/mol.log | awk '{print $3}')
        entro=$(grep "Total     " ${dest}/geom/mol.log | awk '{print $4}')

	# PRINTING
	if [[ "$mol" == *"$sub1"* ]]; then
        	mol1=`echo $mol | cut -f1 -d"_"`;
                printf "%s," ${mol1} >> $dbcsv

        elif [[ "$mol" == *"$sub2"* ]];
                then mol1=`echo $mol | cut -f1 -d"_"`;
                printf "%s," ${mol1} >> $dbcsv

        else
                printf "%s," ${mol} >> $dbcsv
        fi

	printf "%s," "1" >> $dbcsv
	printf "%.8f," ${DFT} >> $dbcsv
        printf "%.5f," ${homo} >> $dbcsv
        printf "%.5f," ${lumo} >> $dbcsv
        printf "%.5f," ${gap} >> $dbcsv
        printf "%.2f," ${dipole} >> $dbcsv
        printf "%.2f," ${isopol} >> $dbcsv
        printf "%.2f," ${anisopol} >> $dbcsv
        printf "%.7f," ${rota} >> $dbcsv
        printf "%.7f," ${rotb} >> $dbcsv
        printf "%.7f," ${rotc} >> $dbcsv
        printf "%s," ${ene} >> $dbcsv
        printf "%s," ${cv} >> $dbcsv
        printf "%s," ${entro} >> $dbcsv
	printf "\n" >> $dbcsv
	echo "Done with ${dest}"
	
fi
done
done
