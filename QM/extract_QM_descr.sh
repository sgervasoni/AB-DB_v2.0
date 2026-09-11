#!/bin/bash

# Extraction of QM descriptors from the Gaussian output (mol.log)
# The polarizability is computed with the python script g16_polar_p3.py

# DFT energy
DFT=$(grep "SCF Done" mol.log | awk '{print $5}')
echo "QM_ENE= $DFT"
# HOMO & LUMO
if grep -q "Beta virt" mol.log; then
    homo=$(grep "Beta  occ. eigenvalues" mol.log | tail -1 | awk '{print $NF}')
    lumo=$(grep "Beta virt. eigenvalues" mol.log | head -1 | awk '{print $5}')
else
    homo=$(grep "Alpha  occ. eigenvalues" mol.log | tail -1 | awk '{print $NF}')
    lumo=$(grep "Alpha virt. eigenvalues" mol.log | head -1 | awk '{print $5}')
fi
echo "HOMO= $homo    LUMO= $lumo"
# HL gap in a.u
gap=$(echo $lumo $homo | awk '{print $1 - $2}')
echo "GAP= $gap"
# Dipole moment
dipole=$(grep " X= " mol.log | awk '{print $8}')
echo "DIP= $dipole"
# Compute polarizability
python g16_polar_p3.py mol.log > pol.txt	
# Isotropic polarizability
isopol=$(awk '{print $2}' pol.txt)
echo "POL_ISO= $isopol"
# Anisotropic polarizability
anisopol=$(awk '{print $3}' pol.txt)
echo "POL_ANI= $anisopol"
# Rotational constants
rota=$(grep "Rotational constants" mol.log | awk '{print $4}')
rotb=$(grep "Rotational constants" mol.log | awk '{print $5}')
rotc=$(grep "Rotational constants" mol.log | awk '{print $6}')
echo "ROT_A= $rota    ROT_B= $rotb    ROT_C=$rotc"
# E CV S
ene=$(grep "Total     " mol.log | awk '{print $2}')
cv=$(grep "Total     " mol.log | awk '{print $3}')
entro=$(grep "Total     " mol.log | awk '{print $4}')
echo "E_TH= $ene    CV= $cv    S=$entro"
