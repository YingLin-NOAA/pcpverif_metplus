#!/bin/sh
#BSUB -J METplus_cam
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_fv3cam.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_fv3cam.%J
#BSUB -W 03:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus

echo 'Actual output starts here:'
if [ $# -eq 0 ]
then
  export vday=`date +%Y%m%d -d "2 day ago"`
else
  export vday=$1
fi


export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus_cam.wrkdir
if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

# FV3SAR runs are made on phase2: where to get it on phase2 dev?
#   find out whether the hostname starts with 'v' or 'm':
h1=`hostname|cut -c 1-1`
if [ $h1 = m ]
then
  disk2=tp2
else
  disk2=gp2
fi

for model in fv3sar fv3sarx
do 
  export model
  export MODEL=`echo $model | tr a-z A-Z`
  if [ $model = fv3sar ]; then
    export modpath=/gpfs/$disk2/ptmp/Benjamin.Blake/com/fv3cam/para
  elif [ $model = fv3sarx ]; then
    export modpath=/gpfs/$disk2/ptmp/Eric.Rogers/com/fv3cam/para
  fi
  
  # 24h ctc/sl1l2 scores:
  export acc=24h # for stats output prefix in GridStatConfig
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_24h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  # 3h ctc/sl1l2: 
  export acc=03h # for stats output prefix in GridStatConfig
  # Assuming this job is run after GFS 3h verif, so the CCPA 3h has already been
  # renamed/copied over to metplus.out
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_03h.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

done  # run 3h/24h verif for fv3sar, fv3sarx


