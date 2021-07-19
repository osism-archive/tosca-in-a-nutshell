#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#

source ${utils_scripts}/utils.sh
log begin
ensure_home_var_is_set

[ $# -ne 3 ] && exit 1

STOP_FLAG="${YSTIA_DIR}/.${NODE}-stop"
STOPPED_FLAG="${YSTIA_DIR}/.${NODE}-stopped"

LOG_PATH=$1
TOTAL_LOGS_NB=$2
DELAY_S=$3

hostname=$(hostname)
mkdir -p $(dirname ${LOG_PATH})

>$LOG_PATH
for (( c=1; c<=$TOTAL_LOGS_NB; c++ ))
do
    DATE=`date +"%d-%m-%Y %H:%M:%S.000"`
    echo "${DATE} - hostname=${hostname},logfile=${LOG_PATH},nb=${c}" >>$LOG_PATH
    if [[ -f ${STOP_FLAG} ]]; then
        break
    fi
    sleep $DELAY_S
done

while [[ "1" == "1"  ]] ; do
    if [[ -f ${STOP_FLAG} ]]; then
        break
    fi
    sleep 10
done

touch ${STOPPED_FLAG}
log end

exit 0