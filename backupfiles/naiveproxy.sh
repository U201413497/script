#!/usr/bin/bash
while true
do
  if pgrep -x "naiveproxy"
 > /dev/null
  then
    echo "[$(date)] NaiveProxy 正在运行"
  else
    echo "[$(date)] 警告：NaiveProxy 已停止"
    docker start naiveproxy
  fi
done
