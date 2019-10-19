#!/bin/sh
set -x
#day=20191007

metout=/gpfs/dell2/ptmp/Ying.Lin/metplus.out
pyscript=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/plot
rzdmdir=/home/www/emc/htdocs/users/verification/precip/rtma-urma.v2.8
plotarch=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.rtma-urma.images
st4dir=/gpfs/dell2/ptmp/Ying.Lin/wget_st4
wrkdir=/gpfs/dell2/stmp/Ying.Lin/rtma-urma-daily-plot
if [ -d $wrkdir ]; then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi

cd $wrkdir

day1=20190801
day2=20191013
#day2=20191014
UTILROOT=/gpfs/dell1/nco/ops/nwprod/prod_util.v1.1.2
FINDDATE=$UTILROOT/ush/finddate.sh

day=$day1
while [ $day -le $day2 ];
do

mkdir -p $plotarch/$day

for anl in pcprtma pcprtma2p8 
do
  anlfile=$anl.${day}12_a24h
  cp $metout/$anl/bucket/$anlfile .
  err=$?
  if [ $err -eq 0 ]; then
    python $pyscript/pltpcp_nc.py $anlfile conus
    cp $anlfile.png $plotarch/$day/.
  fi
done

rtma1=pcprtma.${day}12_a24h.png
rtma2=pcprtma2p8.${day}12_a24h.png
st4=$st4dir/st4_conus.${day}12.24h.gif
if [ -s $rtma1 -a -s $rtma2 -a -s $st4 ]
then
  montage -geometry 480x425 $rtma1 $rtma2 $st4 pcprtma3.$day.png
  cp pcprtma3.$day.png $plotarch/$day/.
  scp pcprtma3.$day.png wd22yl@emcrzdm:$rzdmdir/pcprtma/daily/.
fi

for anl in pcpurma pcpurma2p8 
do
  anlfile=$anl.${day}12_a24h
  cp $metout/$anl/bucket/$anlfile .
  err=$?
  if [ $err -eq 0 ]; then
    python $pyscript/pltpcp_nc.py $anlfile wexp
    cp $anlfile.png $plotarch/$day/.
  fi
done

urma1=pcpurma.${day}12_a24h.png
urma2=pcpurma2p8.${day}12_a24h.png
if [ -s $urma1 -a -s $urma2 ]
then
  montage -geometry 480x425 $urma1 $urma2 pcpurma2.$day.png
  cp pcpurma2.$day.png $plotarch/$day/.
  scp pcpurma2.$day.png wd22yl@emcrzdm:$rzdmdir/pcpurma/daily/.
fi

day=`$FINDDATE $day d+1`
done


