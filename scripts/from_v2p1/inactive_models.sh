# This file holds code fragments previously in use (models not active now):
#
# 24h:
export model=rapx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Ming.Hu/com/rap/prod
w${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=hrrrx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Benjamin.Blake/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_24h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 3h:
export model=rapx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Ming.Hu/com/rap/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

export model=hrrrx
export MODEL=`echo $model | tr a-z A-Z`
export modpath=/gpfs/hps3/ptmp/Benjamin.Blake/com/hrrr/prod
${YLMETPLUS_PATH}/ush/master_metplus.py \
  -c ${YLMETPLUS_PATH}/yl/parm/models/${model}_03h.conf \
  -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

# 6h FSS:
  export model=rapx
  export MODEL=RAPX
  export modpath=/gpfs/hps3/ptmp/Ming.Hu/com/rap/prod
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/rap_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

  export model=hrrrx
  export MODEL=HRRRX
  export modpath=/gpfs/hps3/ptmp/Benjamin.Blake/com/hrrr/prod
  ${YLMETPLUS_PATH}/ush/master_metplus.py \
    -c ${YLMETPLUS_PATH}/yl/parm/models/hrrrx_06h_fss.conf \
    -c ${YLMETPLUS_PATH}/yl/parm/system.conf.dell

