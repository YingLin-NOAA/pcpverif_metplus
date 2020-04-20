#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

# Test verifying pcprtma 24h accum against CCPA.  Just to make sure that
#   PcpCombine works for pcprtma, before we run verif of pcprtma24h against 
#   daily gauges. 

export vday=20190805

echo 'Actual output starts here:'

master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma_g2g_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
