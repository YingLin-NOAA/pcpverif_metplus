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
export vday=20200420
vdayp1=`date -d "$vday + 1 day" +%Y%m%d`

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus3/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus.v3/test_24h.`date -u +%Y%m%d%H%M%S`


if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

export acc=24h # for stats output prefix in GridStatConfig

# 24h ctc/sl1l2 scores for HREF and HREFv3 means.  Note that each group of means
# under HREF and HREFv3 shares the same config file (one config for HREF,
# another for HREFv3).  Only the mean type changes. 

# HREF mean/pmmn:
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod

export mtype=avrg
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

exit

