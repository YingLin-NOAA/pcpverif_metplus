#!/bin/sh

set -x
. ~/dots/dot.for.metplus.v3
module load 

# use this script to check config files:

acc=24h
${YLMETPLUS_PATH}/ush/validate_config.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/ecmwf_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

exit

