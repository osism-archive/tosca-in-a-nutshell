#!/usr/bin/env bash
#
# Ystia Forge
# Copyright (C) 2018 Bull S. A. S. - Bull, Rue Jean Jaures, B.P.68, 78340, Les Clayes-sous-Bois, France.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.
#


source ${utils_scripts}/utils.sh
log begin
ensure_home_var_is_set

log info "Uninstall DummyLogsGenerator..."
INSTALL_DIR=${HOME}/${NODE}
rm -rf ${INSTALL_DIR}
rm -f ${YSTIA_DIR}/.${NODE}*
rm -f ${LOG_PATH}

log end

