#!/bin/sh
#BSUB -J METpl_24h_3h_v3
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus3_24h_3h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus3_24h_3h.%J
#BSUB -W 03:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus.v3
module load 

echo 'Actual output starts here:'
if [ $# -eq 0 ]
then
  export vday=`date +%Y%m%d -d "2 day ago"`
else
  export vday=$1
fi

# vdayp1 is for 3h ccpa:
vdayp1=`date -d "$vday + 1 day" +%Y%m%d`  

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus3/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus/24h-3h_v3.`date -u +%Y%m%d%H%M%S`

if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

# 24h ctc/sl1l2 scores:
export acc=24h # for stats output prefix in GridStatConfig

export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/hiresw/com/hiresw/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# The CAMs - note that the cams share the same config file fv3cam_24h.conf
export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/ptmp/emc.campara/fv3sar
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=fv3sarx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/emc.campara/fv3sarx
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=fv3sarda
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/emc.campara/fv3sarda
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=firewx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/nam/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=nssl4arw
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/dcom/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# HREF avrg/mean/pmmn:
export modpath=/gpfs/hps/nco/ops/com/hiresw/prod

export mtype=avrg
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export mtype=mean
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export mtype=pmmn
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# HREFv3 avrg/lavg/lpmm/mean/pmmn:

export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/com/hiresw/test
export mtype=avrg
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefv3ens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export mtype=lavg
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefv3ens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export mtype=lpmm
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefv3ens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export mtype=mean
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefv3ens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export mtype=pmmn
export MTYPE=`echo $mtype | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/hrefv3ens_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 3h ctc/sl1l2:
export acc=03h # for stats output prefix in GridStatConfig

# Copy CCPA 3-hourly to metplus.out/ccpa/renamed3h, since in the prod CCPA 
# directory the path/file names are designed for GEFS cycles and too convoluted.
# Rename them to make things easier for METplus:

METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus3.out
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

# 
export model=conusfv3
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/hiresw/com/hiresw/para
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# For CAMs (they share a common config file):
export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps/ptmp/emc.campara/fv3sar
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=fv3sarx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/emc.campara/fv3sarx
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=fv3sarda
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps2/ptmp/emc.campara/fv3sarda
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell


