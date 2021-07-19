#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#


source ${utils_scripts}/utils.sh
log begin

# Avoid ERROR: {max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]}
sudo sysctl -w vm.max_map_count=262144

sudo systemctl start elasticsearch.service

sleep 3
wait_for_port_to_be_open "127.0.0.1" "9300" 240  || error_exit "Cannot open port 9300"
sleep 3

# Configure shards and replicas
TEMPLATE_NAME='template_all'
TEMPLATE_INDEX="http://localhost:9200/_template/${TEMPLATE_NAME}"
TEMPLATE_JSON_FILE=${YSTIA_DIR}/${NODE}-${TEMPLATE_NAME}.json
CURL='/usr/bin/curl'
OP='-XPUT'
cat > ${TEMPLATE_JSON_FILE} << EOF
{
  "template" : "*",
  "order" : 0,
  "settings" : {
    "number_of_shards" : ${number_of_shards},
    "number_of_replicas" : ${number_of_replicas}
  }
}
EOF
$CURL $OP -H 'Content-Type: application/json' $TEMPLATE_INDEX -d @${TEMPLATE_JSON_FILE} || error_exit "Failed executing Elasticsearch configuration with number_of_shards ${number_of_shards} and number_of_replicas ${number_of_replicas}" $?

log end
