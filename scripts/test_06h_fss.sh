#!/bin/sh
#BSUB -J METpl_fss06_v3
#BSUB -P VERF-T2O
#BSUB -n 4
#BSUB -R affinity[core(4)]
#BSUB -o /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus3_fss06.%J
#BSUB -e /gpfs/dell2/ptmp/Ying.Lin/cron.out/metplus3_fss06.%J
#BSUB -W 12:00
#BSUB -q "dev_shared"
#BSUB -R "rusage[mem=1500]"
#BSUB -R "span[ptile=1]"
set -x
. ~/dots/dot.for.metplus.v3
# loading lsf, impi and CFP for the poe:
module load lsf/10.1
module load impi/18.0.1  
module load CFP/2.0.1

echo 'Actual output starts here:'

export vday=`date +%Y%m%d -d "2 days ago"`

export acc=06h # for stats output prefix in GridStatConfig

export ccpapath=/gpfs/dell1/nco/ops/com/ccpa/prod
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus3/yl/masks/conus14

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metplus/fss06_v3.`date -u +%Y%m%d%H%M%S`
if [ -d $wrkdir ]
then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi
cd $wrkdir

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

  export model=conusfv3
  export MODEL=CONUSFV3
  export modpath=/gpfs/hps2/ptmp/Matthew.Pyle/hiresw/com/hiresw/para
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/conusfv3_06h_fss.conf \
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

exit

