#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

echo 'Actual output starts here:'

#export vday=`date +%Y%m%d -d "4 day ago"`
export vday=20200122 
export acc=06h # for stats output prefix in GridStatConfig

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/oconus_new/com/hiresw/para

for vhr in 00 06 12 18
do
  export vhr
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
done
