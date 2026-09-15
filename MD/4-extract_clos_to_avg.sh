#! /bin/bash

# File names are consistent with those presented in AB-DB v2.0
# Please insert the compound name
drug=INSERT_COMPOUND_NAME

TOP=${drug}.parm7
TRAJ=md_NPT.nc
IMAGED=md_imaged_skip1.nc
IMAGED_SOLUTE=${drug}_imaged_skip1.nc

# Extract the conformation closest to average structure of the ligand from the imaged trajectory
cat > cpptraj_closest.in <<EOF
parm ${TOP} [top]
reference ${drug}_avg.pdb [avg]
trajin ${IMAGED_SOLUTE}
rmsd ref [avg] out rmsd-from-average.xvg
EOF

nice -n 19 cpptraj -i cpptraj_closest.in > cpptraj_closest.out

cat << EOF > min.awk 
BEGIN{minframe=0;min1=100000}
{
    if (\$1 !~ /[0-9]/ || NR == 1) {
            next
        }
    if (\$2 <= min1){
            min1=\$2
            minframe=\$1
        }
}
END{printf"%d %.3f",minframe,min1}
EOF

framefree=$(awk -f min.awk rmsd-from-average.xvg | awk '{print $1}')
framefree=$((${framefree}-1))

cat << EOF > extract-frame.tcl
package require Tcl
mol new ${drug}_avg.pdb type pdb first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
mol addfile ${IMAGED_SOLUTE} type netcdf first ${framefree} last ${framefree} step 1 filebonds 1 autobonds 1 waitfor all
[atomselect top all frame 1] writepdb ${drug}_closest-to-average_free.pdb
quit
EOF

vmd -dispdev none -e extract-frame.tcl > out_vmd

rm extract-frame.tcl min.awk
