#!/bin/bash

dir=/data/biodb/V2/new_set
dbcsv=/data/biodb/V2/MD_descriptors.csv
sub1=_+
sub2=_-
PY=/data/biodb/SCRIPTS

#printf "%s," "Class" "Compound" "Batch" "Water_1st" "ERR_WA1" "Water_2nd" "ERR_WA2" "RMSF" "ERR_RMSF" "MPA" "ERR_MPA" "MAXPA" "ERR_MAXPA"  "Asphericity" "ERR_ASP" "Acylindricity" "ERR_ACY" "Kappa2" "ERR_K2" "glob" "pbf" "primary_amine" > $dbcsv

printf "%s," "Class" "Compound" "Batch" "Water_1st" "ERR_WA1" "Water_2nd" "ERR_WA2" "RMSF" "ERR_RMSF" "Asphericity" "ERR_ASP" "Acylindricity" "ERR_ACY" "Kappa2" "ERR_K2" > $dbcsv

printf "\n" >> $dbcsv

for class in `ls $dir`; do
echo $class
for mol in `ls $dir/$class`; do
echo $mol
printf "%s," ${class} >> $dbcsv

dest=${dir}/${class}/${mol}
if [ ${dest} != $dbcsv ]; then
	# 62 63 64 65 solvation shells
        wat1st=$(awk 'BEGIN{s=0}{s=s+$2}END{print s/NR}' ${dest}/mdyn/ana/solvation.dat)
        wat1_err=$(awk '{dt=$2-avg;avg+=dt/NR;mean2+=dt*($2-avg)}END{print sqrt(mean2/NR)}' ${dest}/mdyn/ana/solvation.dat)
        wat2nd=$(awk 'BEGIN{s=0}{s=s+$3}END{print s/NR}' ${dest}/mdyn/ana/solvation.dat)
        wat2_err=$(awk '{dt=$3-avg;avg+=dt/NR;mean2+=dt*($3-avg)}END{print sqrt(mean2/NR)}' ${dest}/mdyn/ana/solvation.dat)
        # 66 67 RMSF
        grep -v "@" ${dest}/mdyn/ana/rmsf.xvg | grep -v "#" | awk '{print $2}' > tmpfile
        rmsf=$(awk 'BEGIN{s=0}{s=s+$1}END{print s/NR}' tmpfile)
        rmsf_err=$(awk '{dt=$1-avg;avg+=dt/NR;mean2+=dt*($1-avg)}END{print sqrt(mean2/NR)}' tmpfile)
        rm tmpfile
	
	 # 72 73 74 75 76 77 asphericity acylindricity k2
         asp=$(awk 'BEGIN{s=0}{s=s+$5}END{print s/NR}' ${dest}/mdyn/ana/COLVAR)
         asp_err=$(awk '{dt=$5-avg;avg+=dt/NR;mean2+=dt*($5-avg)}END{print sqrt(mean2/NR)}' ${dest}/mdyn/ana/COLVAR)
         acyl=$(awk 'BEGIN{s=0}{s=s+$6}END{print s/NR}' ${dest}/mdyn/ana/COLVAR)
         acyl_err=$(awk '{dt=$6-avg;avg+=dt/NR;mean2+=dt*($6-avg)}END{print sqrt(mean2/NR)}' ${dest}/mdyn/ana/COLVAR)
         k2=$(awk 'BEGIN{s=0}{s=s+$7}END{print s/NR}' ${dest}/mdyn/ana/COLVAR)
         k2_err=$(awk '{dt=$7-avg;avg+=dt/NR;mean2+=dt*($7-avg)}END{print sqrt(mean2/NR)}' ${dest}/mdyn/ana/COLVAR)

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
	printf "%.1f," ${wat1st} >> $dbcsv
        printf "%.1f," ${wat1_err} >> $dbcsv
        printf "%.1f," ${wat2nd} >> $dbcsv
        printf "%.1f," ${wat2_err} >> $dbcsv
        printf "%.6f," ${rmsf} >> $dbcsv
        printf "%.6f," ${rmsf_err} >> $dbcsv
	printf "%.2f," ${asp} >> $dbcsv
        printf "%.2f," ${asp_err} >> $dbcsv
        printf "%.2f," ${acyl} >> $dbcsv
        printf "%.2f," ${acyl_err} >> $dbcsv
        printf "%.2f," ${k2} >> $dbcsv
        printf "%.2f," ${k2_err} >> $dbcsv
	printf "\n" >> $dbcsv
	echo "Done with ${dest}"
	
fi
done
done
