#!/bin/env bash
# Citra IT - Excelencia em TI
# @Author: luciano@citrait.com.br
# @Description: Script para sincronizar a pasta sysvol do servidor
# _secundario samba buscando os dados do servidor PDC.
# @Date: 04/03/2023 Version: 1.0
# Obs.: Validado para ser executado no zentyal 7-dev

fsmo_line=$(samba-tool fsmo show 2>/dev/null | grep -Po "PdcEmulationMasterRole owner:\sCN=NTDS Settings,CN=([^,]+)")
pdc_owner=$(echo $fsmo_line | python3 -c 'print(input().split(",")[-1].replace("CN=",""))')

domain_line=$(samba-tool domain info 127.0.0.1 2>/dev/null | grep -oE "Domain\s+: (.*)")
domain=$(echo $domain_line | python3 -c 'import re; a=input(); print(re.search("Domain\s+: (.*)",a).group(1))')

logger "Starting replicating sysvol from $pdc_owner to this samba server..."

# push cwd to sysvol for this domain
pushd /var/lib/samba/sysvol/$domain

# replicating using smbclient
smbclient //$pdc_owner.$domain/sysvol -c "recurse; prompt; cd $domain; mget Policies; mget Scripts" -P

# reset acls.
/usr/bin/samba-tool ntacl sysvolreset 2>/dev/null

logger "samba sysvol replication finished with PDC $pdc_owner"

