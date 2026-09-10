#! /bin/bash

drug=$(ls *_solv.parm7 | awk 'BEGIN{FS="_solv"}{print $1}')
TOP=${drug}_solv.parm7
IMAGED=md_imaged_skip1.nc

cat > cpptraj_water.in <<EOF
parm ${TOP} [topsolv]
trajin ${IMAGED} parm [topsolv] 10000 
watershell :1 solvation.dat lower 3.4 upper 5 noimage :WAT
EOF

nice -n 19 cpptraj -i cpptraj_water.in > cpptraj_water.out
