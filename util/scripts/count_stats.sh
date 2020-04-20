#!/bin/sh
# count the number of QPF verif stats files in a yyyymmdd/ directory.
# 
# Stats are either
#   grid_stat_ctc_sl1l2_xxh_MODEL_*
# or
#   grid_stat_fss__xxh_MODEL_*
# 
vday=$1
log=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.stats/counts/$vday.log
statdir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.stats/$vday

wrkdir=/gpfs/dell2/stmp/Ying.Lin/metstatscount
if [ -d $wrkdir ]; then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir 
fi

cd $statdir
ls -1 grid_stat_ctc* | awk -F "_" '{print $6}' | sort -u > $wrkdir/models_ctcsl1l2
ls -1 grid_stat_fss* | awk -F "_" '{print $5}' | sort -u > $wrkdir/models_fss

cd $wrkdir
cat models_ctcsl1l2 models_fss  | sort -u > models_list

cd $statdir




