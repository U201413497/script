#!/usr/bin/bash

wget --no-check-certificate https://raw.githubusercontent.com/U201413497/script/main/backupfiles/naiveprox.sh && chmod +x naiveprox.sh

(crontab -l 2>/dev/null; echo "* * * * * /root/naiveprox.sh") | crontab -

echo "设置完成！脚本 naiveprox.sh 将每分钟运行一次。"
echo "你可以使用 'crontab -l' 命令查看当前所有的定时任务。"