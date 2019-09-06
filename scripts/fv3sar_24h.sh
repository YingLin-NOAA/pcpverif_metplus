#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export vday=20190902
export modpath=/gpfs/gp2/ptmp/Benjamin.Blake/com/fv3cam/para
export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
echo 'Actual output starts here:'

master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/fv3sar_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
