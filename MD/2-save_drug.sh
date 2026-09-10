#! /bin/bash

drug=$(ls *_solv.parm7 | awk 'BEGIN{FS="_solv"}{print $1}')
TOP=${drug}_solv.parm7
IMAGED=md_imaged_skip1.nc
IMAGED_SOLUTE=${drug}_imaged_skip1.nc

#atoms to be centered needs to be changed accordingly
cat > cpptraj_save.in <<EOF
parm ${drug}_solv.parm7 [topsolv]
trajin ${IMAGED} parm [topsolv] 
strip :2-100000
center ":1 & @XXXXX & !@H="
rmsd ":1 & @XXXXX & !@H=" first
trajout ${IMAGED_SOLUTE} netcdf 
EOF

nice -n 19 cpptraj -i cpptraj_save.in > cpptraj_save.out
