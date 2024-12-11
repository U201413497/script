#!/bin/bash

_INSTALL(){
  echo -e "nameserver 8.8.8.8\nnameserver 2001:4860:4860:0:0:0:0:8888" > /etc/resolv.conf
  chattr +i /etc/resolv.conf
  apt update && apt install wget sudo -y
  echo -n "Enter your domain:"
  read domain
  echo -n "Enter your username:"
  read username
  echo -n "Enter your password:"
  read password
  echo -n "Enter your email:"
  read email
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
            probe_resistance
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
  systemctl daemon-reload
  systemctl enable caddy.service
  echo net.core.default_qdisc=fq >> /etc/sysctl.conf && echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf && sysctl -p
  systemctl start caddy.service
}

_INSTALL
