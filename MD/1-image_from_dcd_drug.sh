#! /bin/bash

# File names are consistent with those presented in AB-DB v2.0
# Please insert the compound name
drug=INSERT_COMPOUND_NAME

TOP=${drug}_solv.parm7
ANNEAL=anneal.nc
QUENCH=quench.nc
EQ=equilibrate_NPT.nc
TRAJ=md_NPT.nc
IMAGED=md_imaged_skip1.nc

# Atoms for centering need to be changed accordingly
cat > cpptraj_image.in <<EOF
parm   ${drug}_solv.parm7 [topsolv]
trajin ${ANNEAL} parm [topsolv]
trajin ${QUENCH} parm [topsolv]
trajin ${EQ}     parm [topsolv]
trajin ${TRAJ}   parm [topsolv]
center ":1 & @XXXXX & !@H="
autoimage anchor :1
trajout ${IMAGED} netcdf parm [topsolv]
EOF

nice -n 19 cpptraj -i cpptraj_image.in > cpptraj_image.out
