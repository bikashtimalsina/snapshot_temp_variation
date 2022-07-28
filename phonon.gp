set terminal postscript enhanced color
set output "phononplot"
set title "Phonon dispersion with different snapshots at different temperature"
set ylabel "meV"
set key outside right
plot abctext
!ps2pdf phononplot
