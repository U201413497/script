#!/bin/bash

_INSTALL(){
apt update && apt install unzip
tsocks wget -O nezha-agent.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm.zip
unzip nezha-agent.zip -d /usr/local/bin/nezha
rm nezha-agent.zip
touch /usr/local/bin/config.yml
echo -n "Enter your client_secret:"
read client_secret
echo -n "Enter your server:"
read server
uuid=$(cat /proc/sys/kernel/random/uuid)
chmod +x /usr/local/bin/nezha/nezha-agent
cat >/usr/local/bin/config.yml <<-EOF
client_secret: $client_secret
debug: false
disable_auto_update: false
disable_command_execute: false
disable_force_update: false
disable_nat: false
disable_send_query: false
gpu: false
insecure_tls: false
ip_report_period: 1800
report_delay: 1
server: $server
skip_connection_count: false
skip_procs_count: false
temperature: false
tls: false 
use_gitee_to_upgrade: false
use_ipv6_country_code: true
uuid: $uuid
EOF
touch /etc/systemd/system/nezha-agent.service
echo "
[Unit]
Description=nezha-agent
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/nezha/nezha-agent -c /usr/local/bin/config.yml
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nezha-agent.service
systemctl daemon-reload
systemctl enable nezha-agent.service
systemctl start nezha-agent.service
}

_INSTALL
