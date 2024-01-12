#!/bin/bash

_INSTALL(){
	if [ -f /etc/centos-release ]; then
		yum install -y wget curl unzip zip
	else
		apt update && apt install -y wget curl unzip zip
	fi
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
	echo -n "Enter your Port:"
	read Port
	echo -n "Enter your Name:"
	read Name
	echo -n "Enter your Password:"
	read Password
	echo -n "TCP Or UDP:"
	read TU
        VERSION=$(curl -fsSL https://api.github.com/repos/enfein/mieru/releases/latest | grep tag_name | sed -E 's/.*"v(.*)".*/\1/')
        DOWNLOADURL1="https://github.com/enfein/mieru/releases/download/v$VERSION/mita_"$VERSION"_amd64.deb"
	DOWNLOADURL2="https://github.com/enfein/mieru/releases/download/v$VERSION/mieru_"$VERSION"_windows_amd64.zip"
	IP=$(curl ifconfig.me)
	wget -q "$DOWNLOADURL1"
	wget -q "$DOWNLOADURL2"
	wget --no-check-certificate https://raw.githubusercontent.com/U201413497/mieru-script/main/start.bat
	wget --no-check-certificate https://raw.githubusercontent.com/U201413497/mieru-script/main/stop.bat
	mkdir /root/client
	unzip -d /root/client mieru_"$VERSION"_windows_amd64.zip
	apt install ./mita_"$VERSION"_amd64.deb
	touch server.json
	touch /root/client/client.json
	echo "{
            "\"portBindings"\": [
        {
            "\"port"\": $Port,
            "\"protocol"\": "\"$TU"\"
        }
                                ],
            "\"users"\": [
        {
            "\"name"\": "\"$Name"\",
            "\"password"\": "\"$Password"\"
        }
                         ],
            "\"loggingLevel"\": "\"INFO"\",
            "\"mtu"\": 1400
}" > /root/server.json
	echo "{
            "\"profiles"\": [
        {
            "\"profileName"\": "\"default"\",
            "\"user"\": {
                "\"name"\": "\"$Name"\",
                "\"password"\": "\"$Password"\"
                        },
            "\"servers"\": [
                {
                    "\"ipAddress"\": "\"$IP"\",
                    "\"domainName"\": "\""\",
                    "\"portBindings"\": [
                        {
                            "\"port"\": $Port,
                            "\"protocol"\": "\"$TU"\"
                        }
                                        ]
                 }
                           ],
             "\"mtu"\": 1400
        }
                        ],
             "\"activeProfile"\": "\"default"\",
             "\"socks5Port"\": 1080,
             "\"httpProxyPort"\": 1081,
             "\"httpProxyListenLAN"\": true
}" > /root//client/client.json
    cp /root/start.bat /root/client
    cp /root/stop.bat /root/client
    zip -q -r client.zip /root/client
    rm mieru_"$VERSION"_windows_amd64.zip
    rm mita_"$VERSION"_amd64.deb
    rm bbr.sh
    rm -rf client
    rm -rf mieru-script
    rm start.bat
    rm stop.bat
    mita apply config server.json
    mita start
    mita status
}

_INSTALL
