#! /bin/bash

# File names are consistent with those presented in AB-DB v2.0
# Please insert the compound name
drug=INSERT_COMPOUND_NAME

TOP=${drug}_solv.parm7
IMAGED=md_imaged_skip1.nc

cat > cpptraj_hbonds.in <<EOF
parm ${TOP} [topsolv]
trajin ${IMAGED} parm [topsolv] 10000
hbond hbonds1 out hbonds.agr :1 angle 135 dist 3.4 \\
series avgout hbonds_averages.dat printatomnum \\
solventdonor ":2-1000000 & !@/O" solventacceptor ":2-1000000 & @/O" \\
solvout hbonds_solute-solvent.dat bridgeout hbond_bridges.dat
run
runanalysis lifetime out lifetime-intramol-hbonds.dat hbonds1[solutehb]
runanalysis lifetime out lifetime-intermol-hbonds.dat hbonds1[solventhb]
EOF

nice -n 19 cpptraj -i cpptraj_hbonds.in > cpptraj_hbonds.out
