#!/bin/bash

script_file="$(realpath $0)"
script_name="$(basename $script_file)"
script_dir="$(dirname $script_file)"
service_name="${script_name%.*}.service"
service_file="${script_dir}/${service_name}"
deploy_name="ifr-auto-${service_name}"
deploy_file="/etc/systemd/system/${deploy_name}"
echo "[ifr-auto] [DEBUG] values:"
echo "[ifr-auto] [DEBUG] script_file = ${script_file}"
echo "[ifr-auto] [DEBUG] script_name = ${script_name}"
echo "[ifr-auto] [DEBUG] script_dir = ${script_dir}"
echo "[ifr-auto] [DEBUG] service_name = ${service_name}"
echo "[ifr-auto] [DEBUG] service_file = ${service_file}"
echo "[ifr-auto] [DEBUG] deploy_name = ${deploy_name}"
echo "[ifr-auto] [DEBUG] deploy_file = ${deploy_file}"

# 检查 service 文件是否存在
if [[ -f "$service_file" ]]; then
    echo "[ifr-auto] 找到文件 $service_file，准备复制..."
    sudo cp "$service_file" "${deploy_file}"

    if [[ $? -eq 0 ]]; then
        echo "[ifr-auto] 文件已成功复制到 ${deploy_file}"
        services=$(sudo systemctl list-units --type=service --state=running --no-legend | grep '^ifr-auto-' | awk '{print $1}')

        # 停止并禁用这些服务
        for service in $services; do
            echo "[ifr-auto] 停止并禁用服务: $service"
            sudo systemctl stop "$service"
            sudo systemctl disable "$service"
        done

        
        echo "[ifr-auto] sudo systemctl daemon-reload"
        sudo systemctl daemon-reload
        echo "[ifr-auto] systemctl enable ${deploy_name}"
        sudo systemctl enable "$deploy_name"
        echo "[ifr-auto] systemctl start ${deploy_name}"
        sudo systemctl start "$deploy_name"
        echo "[ifr-auto] systemctl status ${deploy_name}"
        sudo systemctl status "$deploy_name"

    else
        echo "[ifr-auto] 复制文件时发生错误。"
    fi
else
    echo "[ifr-auto] 在目录 $script_dir 中没有找到文件 $service_file。"
fi
