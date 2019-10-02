#!/bin/sh
#BSUB -J GFSverif
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_gfs.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_gfs.%J
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

export model=gfs
export MODEL=`echo $model | tr a-z A-Z`

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus.wrkdir
if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

export acc=24h # for stats output prefix in GridStatConfig

# 24h ctc/sl1l2 scores:
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 24h FSS:
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h_fss.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 3h ctc/sl1l2: 
export acc=03h # for stats output prefix in GridStatConfig
# Copy CCPA 3-hourly to metplus.out/ccpa/renamed3h, since in the prod CCPA 
# directory the path/file names are designed for GEFS cycles and too convoluted.
# Rename them to make things easier for METplus:

METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus.out
MYCCPA=${METPLUS_OUT}/ccpa/renamed3h
if [ -d $MYCCPA ]
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

${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

