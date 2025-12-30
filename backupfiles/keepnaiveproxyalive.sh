#!/bin/bash

_INSTALL(){
  wget --no-check-certificate https://raw.githubusercontent.com/U201413497/script/main/backupfiles/naiveproxy.sh && chmod +x naiveproxy.sh
  touch /etc/systemd/system/naiveproxy.service
  echo "
  [Unit]
  Description=Keep naiveproxy alive

  [Service]
  ExecStart=/root/naiveproxy.sh
  Restart=always

  [Install]
  WantedBy=multi-user.target" > /etc/systemd/system/naiveproxy.service

  systemctl daemon-reload
  systemctl start naiveproxy.service
  systemctl enable naiveproxy.service
}
_INSTALL
