#!/bin/sh
#BSUB -J METpl_24h_3h_test
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3_24h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3_24h.%J
#BSUB -W 00:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus.v3
module load 

echo 'Actual output starts here:'
export vday=20200306
vdayp1=`date -d "$vday + 1 day" +%Y%m%d`

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus.v3/test_24h.`date -u +%Y%m%d%H%M%S`


if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir


# 24h ctc/sl1l2 scores:
export acc=24h # for stats output prefix in GridStatConfig

export model=nam
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/nam/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

exit

