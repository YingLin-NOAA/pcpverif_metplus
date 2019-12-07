#!/bin/sh
#BSUB -J METpl_24h_3h
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_24h_3h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_24h_3h.%J
#BSUB -W 01:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus
module load 

echo 'Actual output starts here:'
if [ $# -eq 0 ]
then
  export vday=20191119
else
  export vday=$1
fi
vdayp1=`$UTILROOT/ush/finddate.sh $vday d+1`

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus/24h-3h.`date -u +%Y%m%d%H%M%S`


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

export acc=03h # for stats output prefix in GridStatConfig


# 3h ctc/sl1l2 for RAP/HRRR:

export model=hrrrx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Benjamin.Blake/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell


