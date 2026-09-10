#! /bin/bash

mkdir pdb
drug=$(ls *_solv.parm7 | awk 'BEGIN{FS="_solv"}{print $1}')
TOP=${drug}.parm7
IMAGED=${drug}_imaged_skip1.nc

cat > cpptraj_extract_lig.in <<EOF
parm ${TOP} [topsolv]
trajin ${IMAGED} parm [topsolv] 1 1000000 100
trajout ./pdb/${drug}.pdb multi pdb keepext
EOF

nice -n 19 cpptraj -i cpptraj_extract_lig.in > cpptraj_extract_lig.out

cd pdb
for i in $(ls *.*)
do
file=$(basename ${i})
obabel ${file}.pdb -O ${file}.sdf >& output_sdfbabel
done

for i in $(ls *.sdf)
do
file=$(basename ${i})
/home/sgervasoni/opt/chemaxon/jchemsuite/bin/cxcalc minimalprojectionarea maximalprojectionarea ${file} >> tmp.txt
done

cat <<EOF >head
#Minimal projection area Maximal projection area
EOF

awk 'NR%2==0 {print $0}' tmp.txt > tmp
tail -n +2 tmp > tmp1
cat head tmp1 > min-max-vol.txt
awk '(NR>1){n+=1}{print n-1,$2}' min-max-vol.txt > tmp2
tail -n +2 tmp2 > tmp3
awk '{printf "%10.4f %10.2f \n",$1/10,$2}' tmp3 > ../${drug}_mpa.txt
rm tmp.txt head tmp tmp1 tmp2 tmp3

cd ..

tar cvzf pdb.tgz ./pdb/* ; rm -rf pdb
