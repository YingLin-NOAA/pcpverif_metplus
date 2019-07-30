#!/bin/ksh
set -x
. ~/dots/dot.for.metplus

echo 'Actual output starts here:'

master_metplus.py \
-c ${METPLUS_PATH}/parm/use_cases/qpf/examples/ruc-vs-s2grib.conf \
-c ${METPLUS_PATH}/yl/parm/system.conf.dell
