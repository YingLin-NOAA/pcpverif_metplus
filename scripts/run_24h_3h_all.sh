#!/bin/sh
#BSUB -J METpl_24h_3h
#BSUB -P VERF-T2O
#BSUB -n 1
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3b2_24h_3h.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_v3b2_24h_3h.%J
#BSUB -W 03:58
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R affinity[core(1)]
#BSUB -R "span[ptile=1]"

set -x
. ~/dots/dot.for.metplus.v3b2
module load 

echo 'Actual output starts here:'
if [ $# -eq 0 ]
then
  export vday=`date +%Y%m%d -d "2 day ago"`
else
  export vday=$1
fi
vdayp1=`date -d "$vday + 1 day" +%Y%m%d`

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus.v3b2/24h-3h.`date -u +%Y%m%d%H%M%S`


if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

export acc=24h # for stats output prefix in GridStatConfig

# 24h ctc/sl1l2 scores:

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

export model=nam
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/nam/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=dwd
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell2/ptmp/Ying.Lin/metplus.v3b2.out/dcom_intlqpf
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=ecmwf
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/dcom/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=jma
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/dcom/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=metfr
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/dcom/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=ukmo
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell2/ptmp/Ying.Lin/metplus.v3b2.out/dcom_intlqpf
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# SREF 24h: separate config files for srmean and srfreqm, same config file
#   for all the individual members:

export modpath=/gpfs/dell2/nco/ops/com/sref/prod

export model=srmean
export MODEL=`echo $model | tr a-z A-Z`

${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=srfreqm
export MODEL=`echo $model | tr a-z A-Z`
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

for dycore in arw nmb
do
  export dycore
  for mem in ctl n1 n2 n3 n4 n5 n6 p1 p2 p3 p4 p5 p6
  do 
    export mem
    export model=sr${dycore}${mem}
    export MODEL=`echo $model | tr a-z A-Z`

    ${YLMETPLUS_PATH}/ush/master_metplus.py \
      -c ${YLMETPLUS_PATH}/yl/parm/models/sref_${acc}.conf \
      -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
  done
done


# -------------------------
# 3h ctc/sl1l2:

export acc=03h # for stats output prefix in GridStatConfig

# Copy CCPA 3-hourly to metplus.out/ccpa/renamed3h, since in the prod CCPA 
# directory the path/file names are designed for GEFS cycles and too convoluted.
# Rename them to make things easier for METplus:

METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus.v3b2.out
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

export model=nam
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/nam/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_${acc}.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell


