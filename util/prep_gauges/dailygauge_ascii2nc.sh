#!/bin/sh
set -x
. /usrx/local/prod/lmod/lmod/init/ksh
module use /usrx/local/dev/modulefiles
module load met/8.1

# Convert ascii list of daily gauges in verf precip.yyyymmdd to NetCDF. 

echo 'Actual output starts here:'

date
if [ $# -eq 0 ]
then
  export vday=`date +%Y%m%d -d "1 day ago"`
else
export vday=$1
fi

export PS4='$SECONDS + '

NOSCRUB=/gpfs/dell2/emc/verification/noscrub/Ying.Lin
MET_HOME=$NOSCRUB/metplus/yl/util/prep_gauges
GAUGENCDIR=$NOSCRUB/gauge_nc

# The ascii gauge file is in 
#  /gpfs/tp1[gp1]/nco/ops/com/verf/prod/precip.yyyymmdd, depending on whether 
#  this dell job is run on Mars or Venus:
#
host1=`hostname | cut -c 1-1`
if [ $host1 = m ]; then
  p1disk=tp1
elif [ $host1 = v ]; then
  p1disk=gp1
else
  echo 'Host machine is neither Mars nor Venus.  EXIT - landed on wrong planet.'
  exit
fi
VERFDIR=/gpfs/$p1disk/nco/ops/com/verf/prod/precip.$vday

wrkdir=/gpfs/dell2/stmp/Ying.Lin/gauge2nc

if [ -d $wrkdir ]; then
  rm -rf $wrkdir/*
else
  mkdir -p $wrkdir
fi 

cd $wrkdir

# Has there already been a gauge file in NetCDF?

if [ ! -s $GAUGENCDIR/good-usa-dlyprcp-${vday}.nc ]
then
  export gauge_dir=$VERFDIR
  if [ -s $gauge_dir/good-usa-dlyprcp-${vday} ]
  then
    export desc="from_APCP"
    export model_var=APCP
    export DATA_OUTgauge=$GAUGENCDIR
    python ${MET_HOME}/precip_ascii2nc.py 
  else
    echo '$gauge_dir/good-usa-dlyprcp-${vday} not found!  Exit.'
  fi
fi


date
exit
