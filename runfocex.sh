#!/bin/bash
if [ -d "./FOCEX-run" ]
then
echo "Directory present, cleaning it..."
rm -rf ./FOCEX-run
fi
mkdir ./FOCEX-run
if [ ! -f "./configuration/SC_unperturbed.POSCAR" ]
then
cp ./configuration/POSCAR ./FOCEX-run/POSCAR1
fi
if [ -f "./configuration/SC_unperturbed.POSCAR" ]
then
cp ./configuration/SC_unperturbed.POSCAR ./FOCEX-run/POSCAR1
fi
if [ ! -f "./configuration/POSCAR" ]
then
cp ./configuration/SC_unperturbed.POSCAR ./FOCEX-run/POSCAR1
fi
cp ./configuration/pos-force.txt ./FOCEX-run/OUTCAR1
cp ../params.inp ./FOCEX-run/params.inp
if [ -f "/Users/bikashtimalsina/UniversityOfVirginia/Project/Si_Temperature_Dependent_VASP_Files/Anharmonic-lattice-dynamics/FOCEX/fc234-13" ]
then
cp /Users/bikashtimalsina/UniversityOfVirginia/Project/Si_Temperature_Dependent_VASP_Files/Anharmonic-lattice-dynamics/FOCEX/fc234-13 ../fc234
fi
cp ../fc234 ./FOCEX-run
cd ./FOCEX-run
if [ -x "./fc234" -a -f "./OUTCAR1" -a -f "./POSCAR1" -a -f "./OUTCAR1" -a -f "./params.inp" ]
then
./fc234
wait $!
fi
if [ -f "./fc1_temp.dat" -a -f "./fc2_temp.dat" -a -f "./fc3_temp.dat" -a -f "./fc4_temp.dat" ]
then
mkdir ./temperature
cd ./temperature
cp ../fc1_temp.dat ./fc1.dat
cp ../fc2_temp.dat ./fc2.dat
cp ../fc3_temp.dat ./fc3.dat
cp ../fc4_temp.dat ./fc4.dat
cp ../POSCAR1 .
cp ../OUTCAR1 .
cp ../params.inp .
cp ../fc1_fit_temp.dat ./fc1_fit.dat
cp ../fc2_fit_temp.dat ./fc2_fit.dat
cp ../fc3_fit_temp.dat ./fc3_fit.dat
cp ../fc4_fit_temp.dat ./fc4_fit.dat
cp ../lat_fc.dat .
cp /Users/bikashtimalsina/UniversityOfVirginia/Project/Si_Temperature_Dependent_VASP_Files/Anharmonic-lattice-dynamics/THERMACOND/thermsplit-10 ./thermalsplit
cp ../../../params.phon .
cp ../../../params.born .
cp ../../../kpbs.in .
cp ../../../phonon.gp .
cp ../../../dos.gp .
./thermalsplit
wait $!
if [ -f "./mode_grun.dat" -a -f "./dos_tet.dat" ]
then
gnuplot ./phonon.gp
wait $!
gnuplot ./dos.gp
wait $!
fi
cd ..
fi
if [ -f "./fc1.dat" -a -f "./fc2.dat" -a -f "./fc3.dat" -a -f "./fc4.dat" ]
then
mkdir ./zeroK
cd ./zeroK
cp ../fc1.dat ./fc1.dat
cp ../fc2.dat ./fc2.dat
cp ../fc3.dat ./fc3.dat
cp ../fc4.dat ./fc4.dat
cp ../POSCAR1 .
cp ../OUTCAR1 .
cp ../params.inp .
cp ../fc1_fit.dat ./fc1_fit.dat
cp ../fc2_fit.dat ./fc2_fit.dat
cp ../fc3_fit.dat ./fc3_fit.dat
cp ../fc4_fit.dat ./fc4_fit.dat
cp ../lat_fc.dat .
cp /Users/bikashtimalsina/UniversityOfVirginia/Project/Si_Temperature_Dependent_VASP_Files/Anharmonic-lattice-dynamics/THERMACOND/thermsplit-10 ./thermalsplit
cp ../../../params.phon .
cp ../../../params.born .
cp ../../../kpbs.in .
cp ../../../phonon.gp .
cp ../../../dos.gp .
./thermalsplit
wait $!
if [ -f "./mode_grun.dat" -a -f "./dos_tet.dat" ]
then
gnuplot ./phonon.gp
wait $!
gnuplot ./dos.gp
wait $!
fi
cd ..
fi
#compare two cases for phonon/DOS at zerok and 300K respectively
if [ -d "./temperature" -a -d "./zeroK" ]
then
cp ../../phonon_zero_temp.gp .
cp ../../dos_zero_temp.gp .
gnuplot ./phonon_zero_temp.gp
wait $!
gnuplot ./dos_zero_temp.gp
wait $!
fi
cd ..
