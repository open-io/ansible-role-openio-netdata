#!/bin/bash

PCS_COMMAND="/usr/sbin/pcs"
DRBDADM_COMMAND="/usr/sbin/drbdadm"
results[0]=0
all_tests='pcs_resource_status pcs_resource_status_nodes drbd_status pcs_constraint_location pcs_oiofs_master pcs_stonith pcs_vip_status pcs_samba_status pcs_nfs_status'
silent=0

function pcs_resource_status() {
    ${PCS_COMMAND} status | grep -qEi "stop|fail"
    if [ $? -eq 0 ]; then
        echo KO - A resource is stopped; return 1
    else
        # no resource stopped or failed
        echo OK - all resource started; return 0
    fi
}

function pcs_resource_status_nodes() {
    ${PCS_COMMAND} status nodes| grep -qE "Offline:$"
    if [ $? -eq 0 ]; then
        # no nodes offline
        echo OK - No node offline; return 0
    else
        echo KO - A node is offline; return 1
    fi
}

function drbd_status() {
    ${DRBDADM_COMMAND} status | grep -qEi "Secondary|Connecting|Diskless|StandAlone|Inconsistent"
    if [ $? -eq 0 ]; then
        echo KO - Issue on DRDB; return 1
    else
        # all nodes are primary and disk UpToDate
        echo OK - DRBD is healthy; return 0
    fi
}

function pcs_constraint_location() {
    ${PCS_COMMAND} constraint location | grep -qEi "Enabled"
    if [ $? -eq 0 ]; then
        # a constraint on the location of a resource is defined
        echo KO - A constraint location is defined; return 1
    else
        echo OK - no constraint location defined; return 0
    fi
}

function pcs_oiofs_master() {
    nb_res_oiofs=$(${PCS_COMMAND} status | grep gridinit-oiofs | wc -l)
    nb_master_node_oiofs=$(${PCS_COMMAND} status | grep -A1 gridinit-oiofs | grep Masters | sed -e 's/.*Masters: \[ \(.*\) \]/\1/' | wc -w)
    if [ "${nb_master_node_oiofs}" -ne "${nb_res_oiofs}" ]; then
        # A resource oiofs has too many master or no master
        echo KO - A resource oiofs has an incorrect master count; return 1
    else
        echo OK - OIOFS; return 0
    fi
}

function pcs_stonith() {
    ${PCS_COMMAND} stonith | grep -qEi "stopped"
    if [ $? -eq 0 ]; then
        # A fence resource is down
        echo KO - A fence resource is stopped; return 1
    else
        echo OK - All fence resources are started; return 0
    fi
}

function pcs_vip_status() {
    ${PCS_COMMAND} status | grep 'vip-' | grep -qEi "stopped"
    if [ $? -eq 0 ]; then
        # The VIP is down: downtime
        echo KO - The VIP is down !; return 1
    else
        echo OK - The VIP is started; return 0
    fi
}

function pcs_samba_status() {
    ${PCS_COMMAND} status | grep -qEi 'samba-clone'
    if [ $? -ne 0 ]; then
        # No samba exports
        echo OK - No samba-clone resource; return 0
    else
        systemctl status nmb smb winbind 2>/dev/null | grep -i active | grep -qEi "inactive|dead"
        if [ $? -eq 0 ]; then
            echo  KO - A essentiel samba service is down; return 1
        else
            echo  OK - All essentiel samba services are started ; return 0
        fi

    fi
}

function pcs_nfs_status() {
    ${PCS_COMMAND} status | grep -qEi 'nfs-clone'
    if [ $? -ne 0 ]; then
        # No nfs exports
        echo OK - No nfs-clone resource; return 0
    else
        systemctl status nfs-server 2>/dev/null | grep -i active | grep -qEi "inactive|dead"
        if [ $? -eq 0 ]; then
            echo  KO - The nfs-server service  is down; return 1
        else
            echo  OK - The nfs-server is started ; return 0
        fi

    fi
}

# main
if [ "$1" = "-q" ]; then
    silent=1
    shift
fi

probes=$(if [[ -z "${@}" ]]; then echo ${all_tests}; else echo $@; fi)
for probe in ${probes}; do
    if [ $silent -eq 0 ]; then
        eval "${probe}"
    else
        eval "${probe}" | awk '{print $1}'
    fi
    results+=( $? )
done

if [ $silent -eq 1 ]; then
    exit 0
else
    exit $(dc <<< '[+]sa[z2!>az2!>b]sb'"${results[*]}lbxp")
fi
