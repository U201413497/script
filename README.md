# script
## KVM swap setting: apt update && apt install -y curl && bash <(curl -Ls https://raw.githubusercontent.com/U201413497/script/main/swap/swap.sh)
## IPv6 Only VPS to set up vless+ws+tls+warp: apt update && apt install -y curl && bash <(curl -Ls https://raw.githubusercontent.com/U201413497/script/main/xray/vless-ws-tls-warp.sh)
## KVM bbr ：wget --no-check-certificate https://github.com/U201413497/script/raw/main/bbr/bbr.sh && chmod +x bbr.sh && ./bbr.sh && rm bbr.sh
## mieru : wget --no-check-certificate https://raw.githubusercontent.com/U201413497/script/main/mieru/mieru.sh && chmod +x mieru.sh && ./mieru.sh
## IPv6 Only VPS to set up naiveproxy: apt update && apt install -y curl && bash <(curl -Ls https://raw.githubusercontent.com/U201413497/script/main/naiveproxy/v6naiveproxy.sh)
## scaleway ipv6 Only VPS to setup naiveproxy echo -e "nameserver 2a01:4f8:c2c:123f::1" > /etc/resolv.conf && apt install -y curl && bash <(curl -Ls https://raw.githubusercontent.com/U201413497/script/main/scaleway/ipv6-caddy2-xray-warp-naiveproxy.sh)
## scaleway to debian 12 wget -O- https://github.com/U201413497/script/releases/download/debian12/a.gz | gunzip | dd of=/dev/sdb status=progress root abcd@1234 IPv4
