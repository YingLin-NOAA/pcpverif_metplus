#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

echo 'Actual output starts here:'

#export vday=`date +%Y%m%d -d "4 day ago"`
export vday=20191001
export acc=06h # for stats output prefix in GridStatConfig

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

# FV3SAR runs are made on phase2: where to get it on phase2 dev?
#   find out whether the hostname starts with 'v' or 'm':
h1=`hostname|cut -c 1-1`
if [ $h1 = m ]
then
  disk2=tp2
else
  disk2=gp2
fi

export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/$disk2/ptmp/Benjamin.Blake/com/fv3cam/para

for vhr in 00 06 12 18
do
  export vhr
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
done
