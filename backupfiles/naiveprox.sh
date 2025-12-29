#!/usr/bin/bash
if ! lsof -i tcp:443 | grep -q "naiveprox"; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 未发现 naiveproxy 进程，正在重启容器..."
    
    # 2. 执行重启命令
    # 注意：这里根据您截图中显示的容器名称前缀进行重启
    docker restart trojan-panel-core
    
    if [ $? -eq 0 ]; then
        echo "重启成功。"
    else
        echo "重启失败，请检查容器名称是否正确。"
    fi
else
    # 如果有输出，则不做处理
    echo "$(date '+%Y-%m-%d %H:%M:%S') - naiveproxy 运行正常。"
fi
