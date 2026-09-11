#!/bin/bash

# DFT energy
DFT=$(grep "SCF Done" mol.log | awk '{print $5}')
# HOMO & LUMO
if grep -q "Beta virt" mol.log; then
    homo=$(grep "Beta  occ. eigenvalues" mol.log | tail -1 | awk '{print $NF}')
    lumo=$(grep "Beta virt. eigenvalues" mol.log | head -1 | awk '{print $5}')
else
    homo=$(grep "Alpha  occ. eigenvalues" mol.log | tail -1 | awk '{print $NF}')
    lumo=$(grep "Alpha virt. eigenvalues" mol.log | head -1 | awk '{print $5}')
fi
# HL gap in a.u
gap=$(echo $lumo $homo | awk '{print $1 - $2}')
# Dipole moment
dipole=$(grep " X= " mol.log | awk '{print $8}')
# Compute polarizability
python g09_polar_p3.py mol.log > pol.txt	
# Isotropic polarizability
isopol=$(awk '{print $2}' pol.txt)
# Anisotropic polarizability
anisopol=$(awk '{print $3}' pol.txt)
# Rotational constants
rota=$(grep "Rotational constants" mol.log | awk '{print $4}')
rotb=$(grep "Rotational constants" mol.log | awk '{print $5}')
rotc=$(grep "Rotational constants" mol.log | awk '{print $6}')
# E CV S
ene=$(grep "Total     " mol.log | awk '{print $2}')
cv=$(grep "Total     " mol.log | awk '{print $3}')
entro=$(grep "Total     " mol.log | awk '{print $4}')
