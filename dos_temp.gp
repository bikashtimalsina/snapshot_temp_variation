set terminal postscript enhanced color
set output "dosplot"
set title "DOS with different snapshots at differentK"
set xlabel "meV"
set key outside right
plot abctext
!ps2pdf dosplot
