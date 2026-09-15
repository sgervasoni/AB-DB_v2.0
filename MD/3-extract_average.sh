#! /bin/bash

# File names are consistent with those presented in AB-DB v2.0
# Please insert the compound name
drug=INSERT_COMPOUND_NAME

TOP=${drug}_solv.parm7
TRAJ=md_NPT.nc
IMAGED=md_imaged_skip1.nc
IMAGED_SOLUTE=${drug}_imaged_skip1.nc

# Extract the average structure of the ligand from the imaged trajectory
cat > cpptraj_extract.in <<EOF
parm ${drug}.parm7 [top]
trajin ${IMAGED_SOLUTE}
average ${drug}_avg.pdb pdb start 1 stop 1000000
EOF

nice -n 19 cpptraj -i cpptraj_extract.in > cpptraj_extract.out
