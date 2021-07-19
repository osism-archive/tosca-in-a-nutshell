#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#

source ${utils_scripts}/utils.sh
log begin

lock "$(basename $0)"

[ -z ${LOGSTASH_HOME} ] && error_exit "LOGSTASH_HOME not set"

if [[ -e "${YSTIA_DIR}/.${SOURCE_NODE}-ls2esFlag" ]]; then
    log info "Logstash component '${SOURCE_NODE}' already configured with Elasticsearch output"
    unlock "$(basename $0)"
    exit 0
fi


log info "Connecting Logstash to Elasticsearch"
log info "Environment variables : source is ${scripts} - home is ${HOME}"
log info "Elasticsearch cluster name is ${cluster_name}"

# Create conf directory if not already created
mkdir -p ${LOGSTASH_HOME}/conf                                                                                  /
touch "${LOGSTASH_HOME}/conf/3-elasticsearch_logstash_outputs.conf"
# Take into account elk-all-in-one topo. Is consul agent present ?
IS_CONSUL=1
if is_port_open "127.0.0.1" "8500"
then
    host_name="elasticsearch.service.ystia"
elif [[ -n "${ES_PUBLIC_IP}" ]]; then
    host_name="${ES_PUBLIC_IP}"
elif [[ -n "${ES_IP}" ]]; then
    host_name="${ES_IP}"
elif [[ -n "${ES_CAP_IP}" ]]; then
    host_name="${ES_CAP_IP}"
else
    host_name="localhost"
fi
port="9200"
host=$host_name:$port
log info "Elasticsearch host is $host"

if [[ -n "${PROXY}" ]]; then
    proxy_config="\n\t\tproxy => \"${PROXY}\""
fi

#echo -e "output {\n\telasticsearch {\n\t\tcluster => \"${cluster_name}\"\n\t\tprotocol => node\n\t}\n}" >>${LOGSTASH_HOME}/conf/3-elasticsearch_logstash_outputs.conf
echo -e "output {\n\telasticsearch {${proxy_config}\n\t\thosts => [\"$host\"] \n\t}\n}" >>${LOGSTASH_HOME}/conf/3-elasticsearch_logstash_outputs.conf
log info "A4C configure elasticsearch cluster ${cluster_name}"

touch "${YSTIA_DIR}/.${SOURCE_NODE}-ls2esFlag"
log info "Logstash connected to Elasticsearch host ${host}"

unlock "$(basename $0)"

log end