#!/bin/sh
#BSUB -J METpl_24h_3h
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_24h_3h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_24h_3h.%J
#BSUB -W 03:58
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
  export vday=`date +%Y%m%d -d "2 day ago"`
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

export acc=24h # for stats output prefix in GridStatConfig

# 24h ctc/sl1l2 scores:

export model=gfs
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 24h FSS for GFS:
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h_fss.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 24h ctc/sl1l2 scores for RAP/HRRR: 
export model=rap
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/rap/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=rapx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Ming.Hu/com/rap/prod
w${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=hrrr
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=hrrrx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Benjamin.Blake/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/oconus_new/com/hiresw/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 24h ctc/sl1l2 scores for CAMs: 
export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/ptmp/Benjamin.Blake/com/fv3cam/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=fv3sarx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/$disk2/ptmp/emc.campara/com/fv3cam/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 24h ctc/sl1l2 scores for CMC/CMCGLB (same modpath):
export modpath=/gpfs/dell1/nco/ops/dcom/prod/

export model=cmc
export MODEL=`echo $model | tr a-z A-Z`
# 24h ctc/sl1l2 scores:
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=cmcglb
export MODEL=`echo $model | tr a-z A-Z`
# 24h ctc/sl1l2 scores:
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 3h ctc/sl1l2:
export acc=03h # for stats output prefix in GridStatConfig

# Copy CCPA 3-hourly to metplus.out/ccpa/renamed3h, since in the prod CCPA 
# directory the path/file names are designed for GEFS cycles and too convoluted.
# Rename them to make things easier for METplus:

METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus.out
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

export model=gfs
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 3h ctc/sl1l2 for RAP/HRRR:
export model=rap
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/rap/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=rapx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Ming.Hu/com/rap/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=hrrr
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/nco/ops/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=hrrrx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Benjamin.Blake/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/oconus_new/com/hiresw/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 3h ctc/sl1l2 for CAMs:
export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/ptmp/Benjamin.Blake/com/fv3cam/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=fv3sarx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/$disk2/ptmp/Eric.Rogers/com/fv3cam/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

