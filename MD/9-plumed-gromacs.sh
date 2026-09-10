#!/bin/bash

dir="/data/biodb/SCRIPTS/bin"

drug=$(ls *_solv.parm7 | awk 'BEGIN{FS="_solv"}{print $1}')
PDB=${drug}.pdb
DCD=${drug}_imaged_skip1.dcd
TRR=${drug}_imaged_skip1.trr

##substitution of number of atoms of ligand in plumed.inp file
var1=$(grep MOL -o ${drug}_solv.pdb | wc -l)
var2=`expr ${var1} - 1`
sed -i "s/XXXXX/${var2}/g" plumed.inp
##
echo
echo "RUNNING catdcd on ${lig}"
echo
$dir/catdcd -o ${DCD} -otype dcd -netcdf ${drug}_imaged_skip1.nc > output_catdcd
$dir/catdcd -o ${TRR} -otype trr -netcdf ${drug}_imaged_skip1.nc > output_catdcd2
echo
echo "DONE catdcd on ${lig}"
echo
echo "DRIVER on ${lig}"
echo
#driver -pdb ${PDB} -dcd ${DCD} -plumed plumed.inp -ncv 6 -dt 0.01 > output_driver
plumed driver --pdb ${drug}.pdb --mf_dcd ${drug}_imaged_skip1.dcd --plumed plumed.inp --timestep 0.01 > output_driver
echo
echo "DONE driver on ${lig}"
echo
echo "RMSF gromacs on ${lig}"
echo
echo 2 | gmx_mpi_d rmsf -f ${TRR} -s ${drug}_closest-to-average_free.pdb > output_gromacs
echo
echo "DONE RMSF gromacs on ${lig}"
echo
