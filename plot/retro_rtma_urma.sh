#!/bin/sh
set -x
#day=20191007

wrkdir=/gpfs/dell2/stmp/Ying.Lin/retro-rtma-urma-daily-plot
if [ -d $wrkdir ]; then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi

cd $wrkdir

day1=20190914
day2=20191014
UTILROOT=/gpfs/dell1/nco/ops/nwprod/prod_util.v1.1.2
FINDDATE=$UTILROOT/ush/finddate.sh

day=$day1
while [ $day -le $day2 ];
do



for anl in pcprtma pcprtma2p8 
do
  anlfile=$anl.${day}12_a24h
  cp $metout/$anl/bucket/$anlfile .
  python $pyscript/pltpcp_nc.py $anlfile conus
done

for anl in pcpurma pcpurma2p8 
do
  anlfile=$anl.${day}12_a24h
  cp $metout/$anl/bucket/$anlfile .
  python $pyscript/pltpcp_nc.py $anlfile conus
done

scp pcprtma*.${day}12_a24h.png wd22yl@emcrzdm:$rzdmdir/pcprtma/daily/.
scp pcpurma*.${day}12_a24h.png wd22yl@emcrzdm:$rzdmdir/pcpurma/daily/.
#ssh wd22yl@emcrzdm "cd $rzdmdir/pcprtma/daily/; cp pcprtma.${day}12_a24h.png pcprtma.latest_a24h.png; cp pcprtma2p8.${day}12_a24h.png pcprtma2p8.latest_a24h.png" 
#ssh wd22yl@emcrzdm "cd $rzdmdir/pcpurma/daily/; cp pcpurma.${day}12_a24h.png pcpurma.latest_a24h.png; cp pcpurma2p8.${day}12_a24h.png pcpurma2p8.latest_a24h.png" 

day=`$FINDDATE $day d+1`
done


