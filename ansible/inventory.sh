#!/usr/bin/env bash
#
# Dynamic inventory for ansible to use terraform output
#
###################################################################################################

cat << EOM
{
    "yorc": {
        "hosts": $(terraform -chdir=../terraform output -json | jq '.yorc_ips.value')
    }
}
EOM
