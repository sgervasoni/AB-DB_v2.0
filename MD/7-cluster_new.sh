#! /bin/bash

# File names are consistent with those presented in AB-DB v2.0
# Please insert the compound name
drug=INSERT_COMPOUND_NAME

TOP=${drug}.parm7
IMAGED_SOLUTE=${drug}_imaged_skip1.nc

cat > cpptraj_clusters.in <<EOF
parm ${TOP} [top]
trajin ${IMAGED_SOLUTE} parm [top] 10000
cluster :1 \\
    hieragglo clusters 10 averagelinkage \\
    srmsd[:1] mass nofit \\
    sieve 9 random \\
    out cnumvtime.dat \\
    summary summary.dat \\
    info info.dat \\
    repout cl repfmt pdb \\
    singlerepout cl.nc singlerepfmt netcdf \\
EOF

nice -n 19 cpptraj -i cpptraj_clusters.in > cpptraj_clusters.out
