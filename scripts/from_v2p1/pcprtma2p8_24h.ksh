#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

# export for pcprtma_24h.conf:
export MASK_DIR=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/rfcs
export vday=20190910

echo 'Actual output starts here:'

${YLMETPLUS_PATH}/ush/master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma2p8_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
