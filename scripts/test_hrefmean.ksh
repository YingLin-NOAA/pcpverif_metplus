#!/bin/ksh
set -x
. ~/dot.for.metplus

echo 'Actual output starts here:'

master_metplus.py \
-c ${METPLUS_PATH}/parm/use_cases/qpf/examples/hrefmean-vs-qpe.conf \
-c ${METPLUS_PATH}/yl/parm/system.conf.wcoss
