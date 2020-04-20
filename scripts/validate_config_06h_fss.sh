#!/bin/sh
set -x
. ~/dots/dot.for.metplus.v3

# simple script used to validate the model fss06h ocnfig file. 
echo 'Actual output starts here:'

export vday=`date +%Y%m%d -d "2 days ago"`

export acc=06h # for stats output prefix in GridStatConfig

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus3/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus/fss06_v3.`date -u +%Y%m%d%H%M%S`
if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

# poe scripts sleep 00/06/12/18 seconds so there'll more likely be separate 
#  METplus logs (currently time stamp of logs is only out to 'second'.
#  Note that in the poe scripts below, when model/MODEL are defined in the script,
#  it doesn't get 'carried over' to the later part of the poe script, so
#  ${$model}_06h_fss.conf doesn't work, it needs to be spelled out as e.g.
#    gfs_06h_fss.conf.
for hr in 00
do
  cat > run_fss_${hr}.sh <<EOF
  sleep $hr 
  export vhr=$hr

  export model=fv3sar
  export MODEL=FV3SAR
  export modpath=/gpfs/hps/ptmp/emc.campara/fv3sar
  ${YLMETPLUS_PATH}/ush/validate_config.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

EOF
done
chmod 755 run_fss_00.sh
run_fss_00.sh

exit

