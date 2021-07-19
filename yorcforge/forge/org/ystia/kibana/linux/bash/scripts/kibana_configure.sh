#!/bin/bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#


source ${utils_scripts}/utils.sh
log begin

# To set variables for the proxy
ensure_home_var_is_set

# To set KIBANA_HOME
source ${YSTIA_DIR}/kibana_env.sh

log info "Configuring Kibana "

# Allow connection for remote users
sudo sed -i "s/#server.host: \"localhost\"/server.host: \"0.0.0.0\"/" ${KIBANA_HOME}/config/kibana.yml

# Setup systemd service
sudo cp ${scripts}/systemd/kibana.service /etc/systemd/system/kibana.service
sudo sed -i -e "s/{{USER}}/${USER}/g" -e "s@{{KIBANA_HOME}}@${KIBANA_HOME}@g" /etc/systemd/system/kibana.service
sudo systemctl daemon-reload
#sudo systemctl enable kibana.service
