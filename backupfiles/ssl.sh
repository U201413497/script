#!/bin/bash

_INSTALL(){
  apt-get update
  apt install -y socat cron curl
  echo -n "Enter your domain:"
  read domain
  mkdir /root/$domain
  curl https://get.acme.sh | sh
  cd /root/.acme.sh/
  ./acme.sh --server https://api.buypass.com/acme/directory --register-account --accountemail 'u201413794@gmail.com'
  export CF_Key="2721a50b7beaa571d9ed25fc63ce3fb31b14c"
  export CF_Email="u201413794@gmail.com"
  ./acme.sh --server https://api.buypass.com/acme/directory --issue -d $domain --dns dns_cf --force
  sleep 5
  ./acme.sh --install-cert -d $domain  --key-file /root/$domain/private.key --fullchain-file /root/$domain/certificate.crt
  ./acme.sh  --upgrade  --auto-upgrade
}
_INSTALL
