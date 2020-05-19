#!/bin/sh
METOUT=/gpfs/dell2/ptmp/Ying.Lin/metplus3.out

for model in hrefv3avrg hrefv3lavg hrefv3lpmm hrefv3mean hrefv3pmmn
do
  cd $METOUT/$model/bucket
  for vday in `ls -1`
  do
    cd $METOUT/$model/bucket/$vday
    for file in `ls -1`
    do
      newfile=`echo $file | sed 's/href/hrefv3/'`
      mv $file $newfile
    done
  done
done

exit


