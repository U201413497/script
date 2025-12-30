#!/bin/bash

# --- 配置区 ---
CONFIG_PATH="/etc/juicity/server.json"  # 修改为你的 juicity 配置文件绝对路径
RESTART_CMD="systemctl restart juicity-server" # 修改为你的重启命令

# --- 逻辑区 ---

# 检查 jq 是否安装
if ! command -v jq &> /dev/null; then
    echo "错误: 请先安装 jq (sudo apt install jq)"
    exit 1
fi

show_usage() {
    echo "用法:"
    echo "  $0 add <UUID> <密码>    - 添加新用户"
    echo "  $0 del <UUID>           - 删除指定用户"
    echo "  $0 list                 - 列出所有用户"
}

case "$1" in
    add)
        if [ -z "$2" ] || [ -z "$3" ]; then
            show_usage
            exit 1
        fi
        # 使用 jq 添加键值对
        jq ".users += {\"$2\": \"$3\"}" "$CONFIG_PATH" > "${CONFIG_PATH}.tmp" && mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"
        echo "用户 $2 已添加。"
        $RESTART_CMD && echo "服务已重启。"
        ;;

    del)
        if [ -z "$2" ]; then
            show_usage
            exit 1
        fi
        # 使用 jq 删除键
        jq "del(.users.\"$2\")" "$CONFIG_PATH" > "${CONFIG_PATH}.tmp" && mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"
        echo "用户 $2 已删除。"
        $RESTART_CMD && echo "服务已重启。"
        ;;

    list)
        echo "当前用户列表 (UUID : 密码):"
        jq -r '.users | to_entries | .[] | "\(.key) : \(.value)"' "$CONFIG_PATH"
        ;;

    *)
        show_usage
        ;;
esac
