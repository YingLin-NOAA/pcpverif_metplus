#!/bin/sh
set -x
. ~/dots/dot.for.metplus
echo 'Actual output starts here:'

export vday=20190905
export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14
# for runs made on phase2 (tide/gyre): tp2 or gp2?  We're running the verif job
# on the Dell, but some models (e.g. fv3sar) might be running on phase1.  If
#     host        h1      disc (on tide or gyre)
#     mars        m       tp1
#     venus       v       gp1
#  
h1=`hostname|cut -c 1-1`
if [ $h1 = m ]; then
  disc=tp2
elif [ $h1 = v ]; then
  disc=gp2
else
  echo Verif job is running on unknown host.  Exit.
fi

export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/$disc/ptmp/Benjamin.Blake/com/fv3cam/para

master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

