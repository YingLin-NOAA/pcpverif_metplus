#!/bin/sh
set -x
if [ $# -eq 0 ]
then
  export vday=`date +%Y%m%d -d "2 day ago"`
else
  export vday=$1
fi

vyear=${vday:0:4}
SCRIPT=/gpfs/dell2/emc/verification/noscrub/Ying.Lin/metplus3/yl/plot
METOUT=/gpfs/dell2/ptmp/Ying.Lin/metplus3.out
wrkdir=/gpfs/dell2/stmp/Ying.Lin/plot_href_mean

if [ -d $wrkdir ]; then
  rm -f $wrkdir/*
else
  mkdir -p $wrkdir
fi

cd $wrkdir

for infile in `ls -1 $METOUT/href*/bucket/$vday/*`
do
  echo $infile
  filename=$(basename $infile)
  # change $model.v$yyyymmdd12_fxxx_a24h to $model.v$yyyymmdd12.xxxh
  # to work with current QPF vs. QPE page: 
  newname=`echo $filename | sed 's/_f/./' | sed 's/_a24//'`
  python $SCRIPT/logan_surrogate_svr.py $infile
  convert -scale 65% $filename.png $newname.gif
done

scp *.gif wd22yl@emcrzdm:/home/www/emc/htdocs/mmb/ylin/pcpverif/daily/$vyear/$vday/
  
