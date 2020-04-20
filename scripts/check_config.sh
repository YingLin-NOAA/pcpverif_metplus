#!/bin/sh

set -x
. ~/dots/dot.for.metplus.v3
module load 

# use this script to check config files:

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`

acc=24h
${YLMETPLUS_PATH}/ush/validate_config.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

acc=03h
${YLMETPLUS_PATH}/ush/validate_config.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

acc=06h
${YLMETPLUS_PATH}/ush/validate_config.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}_fss.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

exit

