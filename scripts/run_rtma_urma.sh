#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

echo 'Actual output starts here:'

if [ $# -eq 0 ]
then
  export vday=`date +%Y%m%d -d "2 day ago"`
else
  export vday=$1
fi

# export for ${model}_24h.conf:
MET=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl
export polydir=$MET/masks/rfcs
export obspath=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/gauge_nc

# v2.8 para runs on prod wcoss phase 2.   Find out where to get the data. 
h1=`hostname | cut -c 1-1`
if [ $h1 = m ]; then
  disk2=tp2
  otherdell=venus
elif [ $h1 = v ]; then
  disk2=gp2
  otherdell=mars
else
  echo Marchine is neither Mars nor Venus.  Exit.  
fi

# Find out if the gauge .nc file exists.  If not, try getting it from $otherdell
gaugefile=good-usa-dlyprcp-${vday}.nc
gaugefileok=NO

if [ -s $obspath/$gaugefile ]; then
  gaugefileok=YES
else
  scp Ying.Lin@${otherdell}:$obspath/$gaugefile $obspath/.
  err=$?
  if [ $err -eq 0 ]; then 
    gaugefileok=YES
  else
    $MET/util/prep_gauges/dailygauge_ascii2nc.sh $vday
    if [ -s $obspath/$gaguefile ]; then
      gaugefileok=YES
    else
      echo gauge file not available, remake failed.  Exit
      exit
    fi
  fi # copy from the other dell machine successful?
fi   # nc gauge file already on disk? 

export model=pcprtma
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell2/nco/ops/com/rtma/prod

${YLMETPLUS_PATH}/ush/master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=pcprtma2p8
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/${disk2}/ptmp/emc.rtmapara/com/rtma/para

${YLMETPLUS_PATH}/ush/master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=pcpurma
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell2/nco/ops/com/urma/prod

${YLMETPLUS_PATH}/ush/master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcpurma_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=pcpurma2p8
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/${disk2}/ptmp/emc.rtmapara/com/urma/para

${YLMETPLUS_PATH}/ush/master_metplus.py \
-c ${YLMETPLUS_PATH}/yl/parm/models/pcpurma_24h.conf \
-c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
