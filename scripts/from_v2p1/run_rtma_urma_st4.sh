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

run_pcprtma=1
run_pcprtma2p8=1
run_pcpurma=1
run_pcpurma2p8=1
run_st4=1
run_st4x=1

# export for ${model}_24h.conf:
MET=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl
export polydir=$MET/masks/rfcs
export obspath=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/gauge_nc

# v2.8 para runs on prod wcoss phase 2.   Find out where to get the data. 
# 2019/10/25: move the METplus verif for pcprtma/urma/st4 to prod dell, to
#   minimize disruptions.  
h1=`hostname | cut -c 1-1`
if [ $h1 = m ]; then
  disk2=tp2
  otherdell=venus
elif [ $h1 = v ]; then
  disk2=gp2
  otherdell=mars
else
  echo Marchine is neither Mars nor Venus.  Exit.  
  exit
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

if [ $run_pcprtma -eq 1 ]; then
  export model=pcprtma
  export MODEL=`echo $model | tr a-z A-Z`
  export modpath=/gpfs/dell2/nco/ops/com/rtma/prod

  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
fi

if [ $run_pcprtma2p8 -eq 1 ]; then
  export model=pcprtma2p8
  export MODEL=`echo $model | tr a-z A-Z`
  export modpath=/gpfs/${disk2}/ptmp/emc.rtmapara/com/rtma/para

  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/pcprtma_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
fi

if [ $run_pcpurma -eq 1 ]; then
  export model=pcpurma
  export MODEL=`echo $model | tr a-z A-Z`
  export modpath=/gpfs/dell2/nco/ops/com/urma/prod

  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/pcpurma_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
fi

if [ $run_pcpurma2p8 -eq 1 ]; then
  export model=pcpurma2p8
  export MODEL=`echo $model | tr a-z A-Z`
  export modpath=/gpfs/${disk2}/ptmp/emc.rtmapara/com/urma/para

  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/pcpurma_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
fi

# Prod ST4 is gzip'd.  Copy it over to metplus.out:
if [ $run_st4 -eq 1 ]; then
  PRDST4DIR=/gpfs/dell2/nco/ops/com/pcpanl/prod/pcpanl.$vday
  METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus.out
  MYPRDST4=${METPLUS_OUT}/st4/gunzpd
  if [ ! -d $MYPRDST4 ]
  then
    mkdir -p $MYPRDST4
  fi
  gunzip -c $PRDST4DIR/ST4.${vday}12.24h.gz > $MYPRDST4/ST4.${vday}12.24h

  export model=st4
  export MODEL=`echo $model | tr a-z A-Z`
  export modpath=$MYPRDST4
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
fi

if [ $run_st4x -eq 1 ]; then
  export model=st4x
  export MODEL=`echo $model | tr a-z A-Z`
  export modpath=/gpfs/${disk2}/ptmp/emc.rtmapara/com/pcpanl/para
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
fi

exit


