#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

export vday=20190909

export model=gfs
export MODEL=`echo $model | tr a-z A-Z`

echo 'Actual output starts here:'
export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14


master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/gfs_24h_fss.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
