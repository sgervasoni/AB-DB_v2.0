#!/bin/bash
#
nargs=${#@}
if [ $nargs != 1 ]; then
    echo "usage: `basename $0` gaussian_output"
    exit
fi
#
file=$1
#
# opt.xyz: no. of atoms
#
natoms=`head -1 g16.xyz`
echo $natoms > opt.xyz
#
# opt.xyz: new line
#
echo "" >> opt.xyz
#
# opt.xyz: geometry
#
tail -$natoms g16.xyz | awk '{printf "%-10s %10f %10f %10f\n",$1,$2,$3,$4}' >> opt.xyz
#
# freq.dat
#
grep "Frequencies" $file > freq
grep "IR Inten" $file > int
/data/biodb/V2/QM_script/gaussian_freq.pl freq int > freq.dat
rm freq int
#
# energy.dat
#
grep "SCF Done:" $file | awk '{print $5}' | nl > energy.dat
#
