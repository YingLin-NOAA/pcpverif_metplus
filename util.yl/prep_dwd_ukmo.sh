#!/bin/sh
set -x
if [ $# -eq 1 ]
then
  day=$1
else
  day=`date +%Y%m%d -d "1 day ago"`
fi

# DWD data sent at 03:10Z $dayp1
# UKMO 12Z data sent at 20:00Z $day
# Run this job in cron at 10:00Z for $daym1

WGRIB2=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.1.1/exec/wgrib2

DCOM=/gpfs/dell1/nco/ops/dcom/prod/$day/qpf_verif
MYDCOM=/gpfs/dell2/ptmp/Ying.Lin/metplus.v3.out/dcom_intlqpf/$day

mkdir -p $MYDCOM

for cyc in 00 12
do 
  ukmoinput=$DCOM/ukmo.${day}${cyc}
  if [ -s $ukmoinput ]; then
    for fhr in 12 24 36 48 60 72 84 96
    do
      cycle=${day}${cyc}
      vtime=`$NDATE +$fhr $cycle`
      matchstring='vt='`echo $vtime`
      $WGRIB2 $ukmoinput -match $matchstring -grib $MYDCOM/ukmo.${cycle}_${fhr}
    done
  fi
done

cd $DCOM
for file in `ls -1 dwd_*`
do
  $WGRIB2 $file -set_var APCP -set_int 3 60 359750000 -grid -grib $MYDCOM/$file
done

exit




  
