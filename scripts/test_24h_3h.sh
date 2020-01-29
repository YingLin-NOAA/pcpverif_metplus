#!/bin/sh
#BSUB -J METpl_24h_3h_test
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3_24h_3h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3_24h_3h.%J
#BSUB -W 03:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus.v3
module load 

echo 'Actual output starts here:'
export vday=20200125

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus.v3/24h-3h.`date -u +%Y%m%d%H%M%S`


if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir


# 24h ctc/sl1l2 scores:
export acc=24h # for stats output prefix in GridStatConfig

export model=conusnmmb
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod
#${YLMETPLUS_PATH}/ush/validate_config.py \
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

exit

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/oconus_new/com/hiresw/para
${YLMETPLUS_PATH}/ush/validate_config.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
#${YLMETPLUS_PATH}/ush/master_metplus.py \


exit

# 3h ctc/sl1l2:
export acc=03h # for stats output prefix in GridStatConfig
# Assuming that CCPA 3h files are already copied to $MYCCPA by the main 
# METplus 3h run. 

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/oconus_new/com/hiresw/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell


