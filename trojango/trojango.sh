#!/bin/bash

_INSTALL(){
  cp /etc/resolv.conf /etc/resolv.conf.bak
  echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2a00:1098:2c::1\nnameserver 2a01:4f9:c010:3f02::1" > /etc/resolv.conf
  apt update && apt install curl wget sudo vim gnupg lsb-release proxychains4 socat nginx -y
  sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/U201413497/script/main/trojan-go/trojan-go-quickstart.sh)"
  echo -n "Enter your domain:"
  read domain
  echo -n "Enter your CF_Key:"
  read CF_Key
  echo -n "Enter your CF_Email:"
  read CF_Email
  echo -n "Enter your email:"
  read email
  echo -n "Enter your password:"
  read password
  echo -n "Enter your path with /:"
  read path
  curl https://get.acme.sh | sh
  cd /root/.acme.sh/
  ./acme.sh --server https://api.buypass.com/acme/directory --register-account --accountemail '$email'
  export CF_Key="\"$CF_Key"\"
  export CF_Email="\"$CF_Email"\"
  ./acme.sh --server https://api.buypass.com/acme/directory --issue -d $domain --dns dns_cf --force
  ./acme.sh --install-cert -d panel.848586.xyz  --key-file /etc/trojan-go/private.key --fullchain-file /etc/trojan-go/certificate.crt
  ./acme.sh  --upgrade  --auto-upgrade
  chmod -R 755 /etc/trojan-go
  wget https://github.com/U201413497/script/releases/download/xray/xray
  mv /root/xray /usr/local/bin/ && chmod +x /usr/local/bin/xray
  cat >/etc/trojan-go/config.json <<-EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$password"
    ],
    "ssl": {
        "cert": "/etc/trojan-go/certificate.crt",
        "key": "/etc/trojan-go/private.key",
        "sni": "$domain"
    },
    "websocket": {
      "enabled": true,
      "path": "$path",
      "host": "$domain"
                 },
    "forward_proxy": {
    "enabled": true,
    "proxy_addr": "127.0.0.1",
    "proxy_port": 8080,
                  }
}
EOF
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
            "\"port"\": 9090
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
  systemctl enable xray.service
  curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg |  gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
  apt update && apt install -y cloudflare-warp
  warp-cli register
  sleep 3
  warp-cli set-mode proxy
  sleep 3
  warp-cli set-proxy-port 9090
  sleep 3
  warp-cli connect
  sleep 3
  warp-cli enable-always-on
  sleep 3
  curl -Ls https://raw.githubusercontent.com/U201413497/script/main/naiveproxy/proxychains4.conf -o proxychains4.conf
  mv proxychains4.conf /etc/proxychains4.conf
  cp /etc/resolv.conf.bak /etc/resolv.conf
  systemctl start trojan-go.service xray.service
}

_INSTALL
