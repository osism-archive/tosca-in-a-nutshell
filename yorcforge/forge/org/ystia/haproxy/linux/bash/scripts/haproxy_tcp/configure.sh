#!/bin/bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#


source $utils_scripts/utils.sh

log begin

HOSTNAME=`hostname`
directory="/tmp/fastconnect.haproxy/${NODE}"
conf_file="${directory}/haproxy-part.cfg"
mkdir -p "${directory}"
cat $scripts/haproxy_tcp/files/haproxy-part.cfg | sudo tee --append "${conf_file}"
sudo sed -i -e "s/\[NODE\]/${NODE}/g"  $conf_file
sudo sed -i -e "s/\[PORT\]/${PORT}/g"  $conf_file
cat $conf_file | sudo tee --append /etc/haproxy/haproxy.cfg

## Enable logging using rsyslog
sudo sed -i -e "13s/#$ModLoad/$ModLoad/g" /etc/rsyslog.conf
sudo sed -i -e "14s/#$UDPServerRun/$UDPServerRun/g" /etc/rsyslog.conf
echo -e "local2.*    /var/log/haproxy.log" | sudo tee --append "/etc/rsyslog.d/haproxy.conf"
sudo service rsyslog restart

log end
