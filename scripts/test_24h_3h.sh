#!/bin/sh
#BSUB -J METpl_24h_3h_test
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3_24h_3h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3_24h_3h.%J
#BSUB -W 00:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus.v3
module load 

echo 'Actual output starts here:'
export vday=20200127
vdayp1=`date -d "$vday + 1 day" +%Y%m%d`

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

export model=conusnest
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/nam/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=conusnmmb
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=conusarw
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=conusarw2
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

#${YLMETPLUS_PATH}/ush/validate_config.py \

exit

# 3h ctc/sl1l2:
export acc=03h # for stats output prefix in GridStatConfig


# Assuming that CCPA 3h files are already copied to $MYCCPA by the main 
# METplus 3h run. 
METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus.v3.out
MYCCPA=${METPLUS_OUT}/ccpa/renamed3h
if [ ! -d $MYCCPA ]
then
  mkdir -p $MYCCPA
fi

COMCCPA=$ccpapath/ccpa
cp $COMCCPA.$vday/00/ccpa.t00z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}00.03h
cp $COMCCPA.$vday/06/ccpa.t03z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}03.03h
cp $COMCCPA.$vday/06/ccpa.t06z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}06.03h
cp $COMCCPA.$vday/12/ccpa.t09z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}09.03h
cp $COMCCPA.$vday/12/ccpa.t12z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}12.03h
cp $COMCCPA.$vday/18/ccpa.t15z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}15.03h
cp $COMCCPA.$vday/18/ccpa.t18z.03h.hrap.conus.gb2   $MYCCPA/ccpa.${vday}18.03h
cp $COMCCPA.$vdayp1/00/ccpa.t21z.03h.hrap.conus.gb2 $MYCCPA/ccpa.${vday}21.03h


export model=conusnest
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/nam/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=conusnmmb
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

exit

