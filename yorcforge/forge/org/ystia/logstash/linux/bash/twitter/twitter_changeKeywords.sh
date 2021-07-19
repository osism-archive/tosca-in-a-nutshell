#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#

source ${utils_scripts}/utils.sh
log begin

source ${lsscripts}/logstash_utils.sh

ensure_home_var_is_set

# get LOGSTASH_HOME
source ${YSTIA_DIR}/${HOST}-service.env

log info "Update Twitter keywords property: "
log info "    keywords: ${keywords}"


if [[ "$(grep -c "keywords" "${LOGSTASH_HOME}/conf/1-${NODE}_logstash_inputs.conf")" != "0" ]]; then

    if [[ "${keywords}" == "" ]]; then

        del_conf_property $LOGSTASH_HOME/conf/1-${NODE}_logstash_inputs.conf "keywords" || error_exit "Reconfiguration failed"

    else

        replace_conf_value $LOGSTASH_HOME/conf/1-${NODE}_logstash_inputs.conf "keywords" "${keywords}" || error_exit "Reconfiguration failed"

    fi

elif [[ "${keywords}" != "" ]]; then

    add_conf_property $LOGSTASH_HOME/conf/1-${NODE}_logstash_inputs.conf "keywords" "${keywords}" || error_exit "Reconfiguration failed"

fi

send_sighup_ifneeded

log end