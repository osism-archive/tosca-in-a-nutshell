#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#



. ${utils_scripts}/utils.sh

lock "$(basename $0)"

ensure_home_var_is_set

if [[ -e "${YSTIA_DIR}/.${SOURCE_NODE}-preconfiguresourceFlag" ]]; then
    unlock "$(basename $0)"
    exit 0
fi

INSTALL_DIR=$(eval readlink -f "${INSTALL_DIR}")

touch ${INSTALL_DIR}/work/.agentmode

addresses=( $(get_multi_instances_attribute "SERVER_IP" "TARGET") )
declare -p addresses
# quote array values TODO check if we can use a better  solution to do it
addresses=( ${addresses[@]/#/\"} )
addresses=( ${addresses[@]/%/\"} )
addr_block="$(join_list "," ${addresses[*]})"

sed -i -e "/client_addr/ a\  \"recursors\": [${addr_block}], \n\
  \"retry_join\": [${addr_block}]," ${INSTALL_DIR}/config/1_main_conf.json

log info "Consul Agent configured to connects to server on [${addr_block}]"

touch "${YSTIA_DIR}/.${SOURCE_NODE}-preconfiguresourceFlag"
unlock "$(basename $0)"
