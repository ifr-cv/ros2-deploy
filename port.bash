#!/bin/bash

# 脚本需要以root权限运行
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# 定义udev规则文件的路径
UDEV_RULES_PATH="/etc/udev/rules.d/99-custom-tty.rules"

# 创建或覆写udev规则文件
echo "KERNEL==\"ttyUSB*\", MODE=\"0666\"" > "$UDEV_RULES_PATH"
echo "KERNEL==\"ttyTHS*\", MODE=\"0666\"" >> "$UDEV_RULES_PATH"

# 输出结果
echo "udev rules for ttyUSB* and ttyTHS* have been written to $UDEV_RULES_PATH"

# 重新加载udev规则
udevadm control --reload-rules && udevadm trigger

# 输出重新加载规则的信息
echo "udev rules reloaded"
