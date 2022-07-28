set terminal postscript enhanced color
set output "phononplot"
set title "Phonon dispersion with different temperature for knum snapshots"
set ylabel "meV"
set key outside right
plot abctext
!ps2pdf phononplot
