#!/bin/bash
dircount=`find . -type d -name "temperature"|wc -l`
phontext=""
dostext=""
#if [ -f "./phononplot" -o -f "./phononplot.pdf" ]
#then
#rm ./phononplot
#rm ./phononplot.pdf
#fi
#remove old dos pdf plot if present
#if [ -f "./dosplot" -o -f "./dosplot.pdf" ]
#then
#rm ./phononplot
#rm ./phononplot.pdf
#fi
for (( i=1; i<=${dircount}; i++)){
  dirs=`find . -type d -name "temperature"|sed -n ${i}p`
  echo ${dirs}
  temp=`find . -type d -name "temperature"|sed -n ${i}p|awk -F "/" '{print $3}'|awk -F "_" '{print $2}'`
  echo ${temp}
  snapshots=`find . -type d -name "temperature"|sed -n ${i}p|awk -F "/" '{print $3}'|awk -F "_" '{print $3}'`
  echo ${snapshots}
  if [ -f "${dirs}/mode_grun.dat" -a -f "${dirs}/dos_tet.dat" ]
  then
    if [ -f "${dirs}/mode_grun.dat" ]
    then
      if (( ${i}<${dircount} ))
      then
        phontext+="\"$dirs/mode_grun.dat\" u 3:(\$7*0.123984\) w p pt ${i} ps 0.4 ti \"${temp}-${snapshots}\"," #was 3:7
        dostext+="\"$dirs/dos_tet.dat\" u \(\$2*0.123984\):3 w l lw 1 lt ${i} ti \"${temp}-${snapshots} \"," #was 2:3
      fi
      if (( ${i}==${dircount} ))
      then
        phontext+="\"$dirs/mode_grun.dat\" u 3:(\$7*0.123984\) w p pt ${i} ps 0.4 ti \"${temp}-${snapshots}\""
        dostext+="\"$dirs/dos_tet.dat\" u \(\$2*0.123984\):3 w l lw 1 lt ${i} ti \"${temp}-${snapshots} \""
      fi
    fi
  fi
}
#echo $phontext
#plot phonon
if [ -f "./phonon.gp" ]
then
  sed "s|abctext|${phontext}|g" phonon.gp > phonon_disp.gp
  if [ -f "./phonon_disp.gp" ]
  then
    gnuplot ./phonon_disp.gp
  fi
fi
#plot dos
if [ -f "./dos.gp" ]
then
  sed "s|abctext|${dostext}|g" dos.gp > dos_disp.gp
  if [ -f "./dos_disp.gp" ]
  then
    gnuplot ./dos_disp.gp
  fi
fi
#variation of phonon/DOS, different snapshots at specific temperature
temp_folders=`find . -type d -name "Si_[0-9]*K_VASP"|wc -l`
for (( i=1; i<=${temp_folders}; i++ )){
temp_snaps=`find . -type d -name "Si_[0-9]*K_VASP"|sed -n ${i}p`
echo ${temp_snaps}
snap=`find ${temp_snaps} -type d -name "Si_[0-9]*K_[0-9]*_Snapshots"|wc -l`
each_temp_phonon=""
each_temp_dos=""
for (( j=1; j<=${snap}; j++ )){
  snap_each=`find ${temp_snaps} -type d -name "Si_[0-9]*K_[0-9]*_Snapshots"|sed -n ${j}p`
  echo ${snap_each}
  each_temp=`echo ${snap_each}|awk -F "/" '{print $2}'|awk -F "_" '{print $2}'`
  echo ${each_temp}
  each_temp_snap=`echo ${snap_each}|awk -F "/" '{print $3}'|awk -F "_" '{print $3}'`
  echo ${each_temp_snap}
  if (( ${j}<${snap} ))
  then
    each_temp_phonon+="\"${snap_each}/FOCEX-run/temperature/mode_grun.dat\" u 3:(\$7*0.123984\) w p pt ${j} ps 0.4 ti \"${each_temp}-${each_temp_snap}\","
    each_temp_dos+="\"${snap_each}/FOCEX-run/temperature/dos_tet.dat\" u \(\$2*0.123984\):3 w l lw 1 lt ${j} ti \"${each_temp}-${each_temp_snap} \","
  fi
  if (( ${j}==${snap} ))
  then
    each_temp_phonon+="\"${snap_each}/FOCEX-run/temperature/mode_grun.dat\" u 3:(\$7*0.123984\) w p pt ${j} ps 0.4 ti \"${each_temp}-${each_temp_snap}\""
    each_temp_dos+="\"${snap_each}/FOCEX-run/temperature/dos_tet.dat\" u \(\$2*0.123984\):3 w l lw 1 lt ${j} ti \"${each_temp}-${each_temp_snap} \""
  fi
}
echo ${each_temp_phonon}
echo "*************************************************************"
echo ${each_temp_dos}
phonfile=`echo "phononplot-${each_temp}"`
sed "s|phononplot|${phonfile}|g;s|differentK|${each_temp}|g;s|abctext|${each_temp_phonon}|g" phonon_temp.gp > phonon_${each_temp}.gp
gnuplot phonon_${each_temp}.gp
wait $!
dosfile=`echo "dosplot-${each_temp}"`
sed "s|dosplot|${dosfile}|g;s|differentK|${each_temp}|g;s|abctext|${each_temp_dos}|g" dos_temp.gp > dos_${each_temp}.gp
gnuplot dos_${each_temp}.gp
wait $!
}

function find_snap(){
  declare -i counter
  dirfound=`find . -type d -name "Si_[0-9]*K_$1_Snapshots"|wc -l`
  if (( ${dirfound} > 0 ))
  then
    counter=1
    dirs=`find . -type d -name "Si_[0-9]*K_$1_Snapshots"`
    phonon_snap=""
    dos_snap=""
    for dir in $dirs
    do
      echo "$dir/FOCEX-run/temperature"
      temp_val=`echo $dir|awk -F "/" '{print $2}'|awk -F "_" '{print $2}'`
      if (( ${counter} < ${dirfound} ))
      then
        phonon_snap+="\"${dir}/FOCEX-run/temperature/mode_grun.dat\" u 3:(\$7*0.123984\) w p pt ${counter} ps 0.4 ti \"$1-Snapshots-${temp_val}\","
        dos_snap+="\"${dir}/FOCEX-run/temperature/dos_tet.dat\" u \(\$2*0.123984\):3 w l lw 1 lt ${counter} ti \"$1-Snapshots-${temp_val} \","
      fi
      if (( ${counter} == ${dirfound} ))
      then
        phonon_snap+="\"${dir}/FOCEX-run/temperature/mode_grun.dat\" u 3:(\$7*0.123984\) w p pt ${counter} ps 0.4 ti \"$1-Snapshots-${temp_val}\""
        dos_snap+="\"${dir}/FOCEX-run/temperature/dos_tet.dat\" u \(\$2*0.123984\):3 w l lw 1 lt ${counter} ti \"$1-Snapshots-${temp_val} \""
      fi
      counter=counter+1
    done
    snap_folder=`echo "phononplot-$1_Snapshots"`
    dos_folder=`echo "dosplot-$1_Snapshots"`
    sed "s|phononplot|${snap_folder}|g;s|knum|$1|g;s|abctext|${phonon_snap}|g" phonon_snapshots.gp > phonon_$1_Snapshots.gp
    sed "s|dosplot|${dos_folder}|g;s|knum|$1|g;s|abctext|${dos_snap}|g" dos_snapshots.gp > dos_$1_Snapshots.gp
    gnuplot phonon_$1_Snapshots.gp
    #wait $1
    gnuplot dos_$1_Snapshots.gp
    #wait $1
  fi
}

for (( i=1; i<=50; i++ )){
find_snap $i
}

pdfcheck=`ls *.pdf|wc -l`
if (( ${pdfcheck} > 0 ))
then
if [ -d "./Data" ]
then
rm -rf ./Data
fi
mkdir ./Data
mv ./*.pdf ./Data
fi

junkcheck_phonon=`ls phonon*[0-9]*_Snapshots|wc -l`
junkcheck_dos=`ls dos*[0-9]*_Snapshots|wc -l`
junkcheck_phonon_temp=`ls phononplot-[0-9]*K|wc -l`
junkcheck_dos_temp=`ls dosplot-[0-9]*K|wc -l`

if (( ${junkcheck_phonon} > 0 && ${junkcheck_dos} > 0 && ${junkcheck_phonon_temp} > 0 && ${junkcheck_dos_temp} > 0 ))
then
if [ -f "./Extra" ]
then
rm -rf ./Extra
fi
mkdir ./Extra
for files in `ls phonon*[0-9]*_Snapshots`
do
mv $files ./Extra
done
for files in `ls dos*[0-9]*_Snapshots`
do
mv $files ./Extra
done
for files in `ls phononplot-[0-9]*K`
do
mv $files ./Extra
done
for files in `ls dosplot-[0-9]*K`
do
mv $files ./Extra
done
mv phononplot ./Extra
mv dosplot ./Extra
fi
