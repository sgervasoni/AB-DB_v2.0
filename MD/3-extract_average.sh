#! /bin/bash

drug=$(ls *_solv.parm7 | awk 'BEGIN{FS="_solv"}{print $1}')
TOP=${drug}_solv.parm7
TRAJ=md_NPT.nc
IMAGED=md_imaged_skip1.nc
IMAGED_SOLUTE=${drug}_imaged_skip1.nc

###extract the average structure of the ligand from the imaged trajectory
cat > cpptraj_extract.in <<EOF
parm ${drug}.parm7 [top]
trajin ${IMAGED_SOLUTE}
average ${drug}_avg.pdb pdb start 1 stop 1000000
EOF

nice -n 19 cpptraj -i cpptraj_extract.in > cpptraj_extract.out
