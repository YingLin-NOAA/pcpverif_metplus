#!/bin/sh
set -x
. ~/dots/dot.for.metplus

echo Actual output starts here
# Assumming we are plotting masks as *.nc files in the parent directory:
for maskfile in `cd ..; ls -1 *.nc`
do
  regname=`echo $maskfile | sed 's/.nc//'`
  plot_data_plane ../$maskfile $regname.ps 'name="'$regname'"; level="(*,*)";' -title $regname
done
