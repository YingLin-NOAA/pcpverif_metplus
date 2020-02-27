#!/bin/sh
#BSUB -J METpl_fss06
#BSUB -P VERF-T2O
#BSUB -n 4
#BSUB -R affinity[core(4)]
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_fss06.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus_fss06.%J
#BSUB -W 12:00
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R "span[ptile=1]"
set -x
. ~/dots/dot.for.metplus
# loading lsf, impi and CFP for the poe:
module load lsf/10.1
module load impi/18.0.1  
module load CFP/2.0.1

echo 'Actual output starts here:'

export vday=`date +%Y%m%d -d "2 days ago"`
#export vday=20191001

export acc=06h # for stats output prefix in GridStatConfig

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus/fss06.`date -u +%Y%m%d%H%M%S`
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
  disk3=td3
else
  disk2=gp2
  disk3=gd3
fi

# poe scripts sleep 00/06/12/18 seconds so there'll more likely be separate 
#  METplus logs (currently time stamp of logs is only out to 'second'.
#  Note that in the poe scripts below, when model/MODEL are defined in the script,
#  it doesn't get 'carried over' to the later part of the poe script, so
#  ${$model}_06h_fss.conf doesn't work, it needs to be spelled out as e.g.
#    gfs_06h_fss.conf.
for hr in 00 06 12 18
do
  cat > run_fss_${hr}.sh <<EOF
  sleep $hr 
  export vhr=$hr

  export model=fv3sar
  export MODEL=FV3SAR
  export modpath=/gpfs/$disk3/ptmp/emc.campara/com/fv3cam/para
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=fv3sarx
  export MODEL=FV3SARX
  export modpath=/gpfs/$disk2/ptmp/emc.campara/com/fv3cam/para
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/fv3cam_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=gfs
  export MODEL=GFS
  export modpath=/gpfs/dell1/nco/ops/com/gfs/prod
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/gfs_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=rap
  export MODEL=RAP
  export modpath=/gpfs/hps/nco/ops/com/rap/prod
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/rap_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=hrrr
  export MODEL=HRRR
  export modpath=/gpfs/hps/nco/ops/com/hrrr/prod
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/hrrr_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=conusfv3
  export MODEL=CONUSFV3
  export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/oconus_new/com/hiresw/para
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/conusfv3_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=cmc
  export MODEL=CMC
  export modpath=/gpfs/dell1/nco/ops/dcom/prod/
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/cmc_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=cmcglb
  export MODEL=CMCGLB
  export modpath=/gpfs/dell1/nco/ops/dcom/prod/
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/cmcglb_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

EOF
  echo run_fss_${hr}.sh >> poescript
done
chmod 755 run_fss*.sh

echo 
echo Here is the poescript for making FSS06 computations valid at 00/06/12/18Z:
cat poescript
echo 

mpirun -l cfp poescript

# 6h FSS runs much longer than the 24h/3h runs (even including the FSS24h).  So
# run METplus load here:

/gpfs/dell2/emc/verification/noscrub/Ying.Lin/awsmv/load.metplus/loadit_oneday.sh > /gpfs/dell2/ptmp/Ying.Lin/cron.out/awsload_qpf.out 2>&1

exit

