#!/bin/sh
set -x
. ~/dots/dot.for.metplus
module load prod_util/1.1.3 # for FINDDATE
echo 'Actual output starts here:'

export vday=20190910
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

FINDDATE=$UTILROOT/ush/finddate.sh
vdayp1=`$FINDDATE $vday d+1`

# for runs made on phase2 (tide/gyre): tp2 or gp2?  We're running the verif job
# on the Dell, but some models (e.g. fv3sar) might be running on phase1.  If
#     host        h1      disc (on tide or gyre)
#     mars        m       tp1
#     venus       v       gp1
#  
h1=`hostname|cut -c 1-1`
if [ $h1 = m ]; then
  disc=tp
elif [ $h1 = v ]; then
  disc=gp
else
  echo Verif job is running on unknown host.  Exit.
fi

# prod CCPA directory is $COMCCPA.$day:

COMCCPA=/gpfs/dell1/nco/ops/com/ccpa/prod/ccpa
MYCCPA=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.out/ccpa/renamed3h

export model=fv3sar
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/${disc}2/ptmp/Benjamin.Blake/com/fv3cam/para

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

/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell
