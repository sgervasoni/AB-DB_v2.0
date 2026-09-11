#!/bin/bash

# Solvation shells
wat1st=$(awk 'BEGIN{s=0}{s=s+$2}END{print s/NR}' solvation.dat)
wat1_err=$(awk '{dt=$2-avg;avg+=dt/NR;mean2+=dt*($2-avg)}END{print sqrt(mean2/NR)}'solvation.dat)
wat2nd=$(awk 'BEGIN{s=0}{s=s+$3}END{print s/NR}' solvation.dat)
wat2_err=$(awk '{dt=$3-avg;avg+=dt/NR;mean2+=dt*($3-avg)}END{print sqrt(mean2/NR)}' solvation.dat)
echo "WAT1= $wat1st		ERR_WAT1= $war1_err"
echo "WAT2= $wat2st		ERR_WAT2= $war2_err"
# RMSF
grep -v "@" rmsf.xvg | grep -v "#" | awk '{print $2}' > tmpfile
rmsf=$(awk 'BEGIN{s=0}{s=s+$1}END{print s/NR}' tmpfile)
rmsf_err=$(awk '{dt=$1-avg;avg+=dt/NR;mean2+=dt*($1-avg)}END{print sqrt(mean2/NR)}' tmpfile)
rm tmpfile
echo "RMSF= $rmsf	ERR_RMSF= $rmsf_err"
# Asphericity, Acylindricity, K2
asp=$(awk 'BEGIN{s=0}{s=s+$5}END{print s/NR}' COLVAR)
asp_err=$(awk '{dt=$5-avg;avg+=dt/NR;mean2+=dt*($5-avg)}END{print sqrt(mean2/NR)}' COLVAR)
echo "ASP= $asp		ERR_ASP=$asp_err"
acyl=$(awk 'BEGIN{s=0}{s=s+$6}END{print s/NR}' COLVAR)
acyl_err=$(awk '{dt=$6-avg;avg+=dt/NR;mean2+=dt*($6-avg)}END{print sqrt(mean2/NR)}' COLVAR)
echo "ACY= $acy		ERR_ACY=$acy_err"
k2=$(awk 'BEGIN{s=0}{s=s+$7}END{print s/NR}' COLVAR)
k2_err=$(awk '{dt=$7-avg;avg+=dt/NR;mean2+=dt*($7-avg)}END{print sqrt(mean2/NR)}' COLVAR)
echo "K2= $k2		ERR_K2=$k2_err"
