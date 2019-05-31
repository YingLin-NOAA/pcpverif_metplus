#!/bin/ksh
set -x
. ~/dot.for.metplus

# test the parm/use_cases/grid_to_grid/examples/precip_continous.conf
# this example just tests the pcpcombine's subtract (1 deg GFS f48-f24), no
# actual calculation of scores. 

echo 'Actual output starts here:'

master_metplus.py \
-c ${METPLUS_PATH}/parm/use_cases/grid_to_grid/examples/precip_continuous.conf \
-c ${METPLUS_PATH}/yl/parm/system.conf.wcoss
