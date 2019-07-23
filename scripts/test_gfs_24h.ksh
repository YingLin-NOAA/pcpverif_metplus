#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

#export MODEL=FV3GFS
export vday=20190720

echo 'Actual output starts here:'

master_metplus.py \
-c ${METPLUS_PATH}/yl/parm/models/gfs_24h.conf \
-c ${METPLUS_PATH}/yl/parm/system.conf.dell
