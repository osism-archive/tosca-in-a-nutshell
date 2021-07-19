#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#

. ${utils_scripts}/utils.sh

INSTALL_DIR=$(eval readlink -f "${INSTALL_DIR}")

log begin

if [[ ! -e ${INSTALL_DIR}/work/.agentmode ]]; then
    log info "Configuring Consul to run in server mode"
    # We are not configured to connect to a server so let's start as a server by our own
    addresses=( $(get_multi_instances_attribute "IP_ADDRESS") )
    number_of_masters=${#addresses[@]}
    # quote array values TODO check if we can use a better  solution to do it
    addresses=( ${addresses[@]/#/\"} )
    addresses=( ${addresses[@]/%/\"} )
    addr_block="$(join_list "," ${addresses[*]})"
    sed -i -e "/client_addr/ a\  \"server\": true,\n\
  \"bootstrap_expect\": ${number_of_masters},\n\
  \"retry_join\": [${addr_block}]," ${INSTALL_DIR}/config/1_main_conf.json
    # TODO: To completly take into account the reverse DNS, we should define a recursor toward the Openstack DNS
    #       However, this does'nt work with this Consul version 0.5.2 (ok with a more recent one)
    log end "Consul configured to run in server mode"
else
    # In agent mode the preconfigure_source script already setup the connection to masters
    log end "Consul configured to run in agent mode"
fi