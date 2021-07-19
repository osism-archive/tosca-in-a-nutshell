#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#


# Enviroment variables
# LOGSTASH_HOME: Logstash install home directory
# KAFKA_ZK_BASE_DNS_SRV_NAME: ZooKeeper Service base DNS name

source ${utils_scripts}/utils.sh
ensure_home_var_is_set

lock "$(basename $0)"

flag="${YSTIA_DIR}/.${SOURCE_NODE}-preconfiguresource-input-Flag"

if [[ -e "${flag}" ]]; then
    log info "Kafka input already configured, skipping."
    unlock "$(basename $0)"
    exit 0
fi


source ${YSTIA_DIR}/${SOURCE_NODE}-service.env

mkdir -p ${LOGSTASH_HOME}/conf

LS_JAVA_OPTS=${JAVA_OPTS}
cat > ${LOGSTASH_HOME}/conf/1-kafka_logstash_inputs.conf << END
input {
    kafka {
        topics => ["${TOPIC_NAME}"]
        bootstrap_servers => "kafka.service.ystia:9092"
        group_id => "${SOURCE_NODE}"
    }
}
END

touch "${flag}"
unlock "$(basename $0)"
