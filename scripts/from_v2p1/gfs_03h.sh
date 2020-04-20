#!/bin/sh
set -x
. ~/dots/dot.for.metplus
module load prod_util/1.1.3 # for FINDDATE
echo 'Actual output starts here:'

export vday=20190914
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

export acc=03h # for stats output prefix in GridStatConfig

FINDDATE=$UTILROOT/ush/finddate.sh
vdayp1=`$FINDDATE $vday d+1`

# prod CCPA directory is $COMCCPA.$day:

COMCCPA=/gpfs/dell1/nco/ops/com/ccpa/prod/ccpa
METPLUS_OUT=/gpfs/dell2/ptmp/Ying.Lin/metplus.out
MYCCPA=${METPLUS_OUT}/ccpa/renamed3h
if [ ! -d $MYCCPA ]
then
  mkdir -p $MYCCPA
fi

export model=gfs
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod

# Copy CCPA 3-hourly to metplus.out/ccpa/renamed3h, since in the prod CCPA 
# directory the path/file names are too convoluted.  

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
