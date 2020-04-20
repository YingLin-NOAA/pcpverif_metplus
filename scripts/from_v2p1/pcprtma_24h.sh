#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

# export for pcprtma_24h.conf:
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/rfcs
export vday=20191001

export model=pcprtma
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell2/nco/ops/com/rtma/prod
export obspath=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/gauge_nc

echo 'Actual output starts here:'

${YLMETPLUS_PATH}/ush/master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
