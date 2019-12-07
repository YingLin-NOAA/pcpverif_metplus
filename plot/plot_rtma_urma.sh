#!/bin/sh
set -x

metout=/gpfs/dell2/ptmp/Ying.Lin/metplus.out
pyscript=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus/yl/plot
rzdmdir=/home/www/emc/htdocs/users/verification/precip/rtma-urma.v2.8/daily/plots
plotarch=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus.rtma-urma.images

# Where is the ST4 directory (v2.8.0 output run on prod phase2)? 
h1=`hostname|cut -c 1-1`
if [ $h1 = m ]; then
  disc=tp2
elif [ $h1 = v ]; then
  disc=gp2
else
  exit
  echo plot job is running on unknown host.  Exit.
fi

if [ $# -gt 0 ]; then
  day=$1
else
  echo need input yyyymmdd
fi

#st4dir=/gpfs/dell2/ptmp/Ying.Lin/wget_st4
#st4dir=/gpfs/dell2/nco/ops/com/pcpanl/prod/pcpanl.$day
wrkdir=/gpfs/dell2/stmp/Ying.Lin/rtma-urma-daily-plot
if [ -d $wrkdir ]; then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi

cd $wrkdir

#day1=20191016
#day2=20191025
UTILROOT=/gpfs/dell1/nco/ops/nwprod/prod_util.v1.1.2
FINDDATE=$UTILROOT/ush/finddate.sh

#day=$day1
#while [ $day -le $day2 ];
#do

st4dir=/gpfs/${disc}/ptmp/emc.rtmapara/com/pcpanl/para/pcpanl.$day
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
  scp pcprtma3.$day.png wd22yl@emcrzdm:$rzdmdir/rtma/.
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
  scp pcpurma2.$day.png wd22yl@emcrzdm:$rzdmdir/urma/.
fi

#day=`$FINDDATE $day d+1`
#done


