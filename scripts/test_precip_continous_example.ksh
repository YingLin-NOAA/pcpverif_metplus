#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

# test the parm/use_cases/grid_to_grid/examples/precip_continous.conf
# this example just tests the pcpcombine's subtract (1 deg GFS f48-f24), no
# actual calculation of scores. 

# Note that the sample QPF data is not in 
#   /usrx/local/dev/packages/met/METplus/METplus-2.1_sample_data 
#     (PROJ_DIR defined in yl/parm/system.conf.dell
# So for this test, revise system.conf.dell to point PROJ_DIR to
#    /gpfs/dell2/emc/verification/noscrub/Julie.Prestopnik/METplus/METplus-2.0.4_sample_data



echo 'Actual output starts here:'

master_metplus.py \
-c ${METPLUS_PATH}/parm/use_cases/grid_to_grid/examples/precip_continuous.conf \
-c ${METPLUS_PATH}/yl/parm/system.conf.dell
