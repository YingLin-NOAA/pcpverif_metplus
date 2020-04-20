#!/bin/sh
set -x
. ~/dots/dot.for.metplus

echo 'actual output starts here:'
export polydir=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/masks/rfcs

export MODEL="PCPRTMA"; export REGRID_TO_GRID="NONE"; export FCST_FIELD="{ name=\"APCP_24\"; level=\"(*,*)\";   }"; export OBS_FIELD="{ name=\"APCP\"; level=\"A24\";   }"; export OBS_WINDOW_BEGIN="-3600"; export OBS_WINDOW_END="3600"; export POINT_STAT_MESSAGE_TYPE="[\"ADPSFC\"]"; export POINT_STAT_GRID="\"FULL\""; export POINT_STAT_POLY="[]"; export POINT_STAT_STATION_ID="[]"; 
/gpfs/dell2/emc/verification/noscrub/Julie.Prestopnik/met/8.1/bin/point_stat /gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.out/pcprtma/bucket/pcprtma.2019091512_A24h /gpfs/dell2/emc/verification/noscrub/Ying.Lin/gauge_nc/good-usa-dlyprcp-20190915.nc /gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/parm/PointStatConfig_gauges -outdir /gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.out/stats/pcprtma -v 3 > /gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.out/logs/master_metplus.log.test 2>&1
