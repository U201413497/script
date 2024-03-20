#!/bin/bash

_INSTALL(){
  apt install curl wget sudo -y
  echo -n "Enter your domain:"
  read domain
  echo -n "Enter your username:"
  read username
  echo -n "Enter your password:"
  read password
  echo -n "Enter your email:"
  read email
  wget https://github.com/U201413497/script/releases/download/xray/xray
  wget https://github.com/U201413497/script/releases/download/caddy/caddy
  mv /root/caddy /usr/bin/ && chmod +x /usr/bin/caddy
  mkdir /etc/caddy
  touch /etc/caddy/Caddyfile
  echo ":443, $domain
        tls $email
        route {
          forward_proxy {
            basic_auth $username $password
            hide_ip
            hide_via
            probe_resistance secert.localhost
            upstream socks5://127.0.0.1:8080
                       }
            reverse_proxy https://demo.cloudreve.org {
            header_up Host {upstream_hostport}
            header_up X-Forwarded-Host {host}
                                                     }
             }" > /etc/caddy/Caddyfile
  touch /etc/systemd/system/caddy.service
  echo "
  [Unit]
  Description=Caddy HTTP/2 web server
  Documentation=https://caddyserver.com/docs
  After=network-online.target
  Wants=network-online.target systemd-networkd-wait-online.service

  [Service]
  ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
  ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile
  Restart=always
  RestartPreventExitStatus=23
  AmbientCapabilities=CAP_NET_BIND_SERVICE

  [Install]
  WantedBy=multi-user.target" > /etc/systemd/system/caddy.service
  mv /root/xray /usr/local/bin/ && chmod +x /usr/local/bin/xray
  mkdir /usr/local/etc/xray && touch /usr/local/etc/xray/config.json
  echo "
  {
  "\"inbounds"\": [
    {
      "\"tag"\": "\"socks"\",
      "\"port"\": 8080,
      "\"listen"\": "\"127.0.0.1"\",
      "\"protocol"\": "\"socks"\",
      "\"settings"\": {
          "\"udp"\": true
                  }
    }
  ],
  "\"outbounds"\": [
    { 
      "\"tag"\": "\"outbound-warp"\",
      "\"protocol"\": "\"socks"\",
      "\"settings"\": {
        "\"servers"\": [
          {
            "\"address"\": "\"127.0.0.1"\",
            "\"port"\": 40000
          }
        ]
      }
    },
    {
      "\"tag"\": "\"direct"\",
      "\"protocol"\": "\"freedom"\"
    }
  ],
  "\"routing"\": {
    "\"domainStrategy"\": "\"IPOnDemand"\",
    "\"rules"\": [
      {
        "\"type"\": "\"field"\",
        "\"ip"\": [ "\"::/0"\" ],
        "\"outboundTag"\": "\"direct"\"
      },
      {
        "\"type"\": "\"field"\",
        "\"ip"\": [ "\"0.0.0.0/0"\" ],
        "\"outboundTag"\": "\"outbound-warp"\"
      }
    ]
  }
}" > /usr/local/etc/xray/config.json
  touch /etc/systemd/system/xray.service
  echo "
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/xray.service
  systemctl daemon-reload
  systemctl enable caddy.service xray.service
  apt-get -y purge apache2-* bind9-* xinetd samba-* nscd-* portmap sendmail-* sasl2-bin
  apt-get -y purge lynx memtester unixodbc python-* odbcinst-*  tcpdump ttf-*
  apt-get autoremove && apt-get clean
  wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh c
  systemctl start caddy.service xray.service
}

_INSTALL
