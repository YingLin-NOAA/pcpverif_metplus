#!/bin/ksh
set -x
. ~/dot.for.metplus

#export MODEL=FV3GFS
export vday=20190601

echo 'Actual output starts here:'

master_metplus.py \
-c ${METPLUS_PATH}/yl/parm/models/fv3gfs_24h.conf \
-c ${METPLUS_PATH}/yl/parm/system.conf.wcoss
