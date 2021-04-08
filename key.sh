#/bin/sh
apt-get update -y
apt-get install curl -y
yum clean all
yum make cache
yum install curl -y
echo '============================
      SSH Key Installer
	 V1.0 Alpha
	Author:Kirito
============================'
cd ~
mkdir .ssh
cd .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA2VpNHNe0okp25vYFxpvLFjPZkK5l4wEXQ8XJUan7lR4kSbayWxdSeN7iJdN4tJac8RCHdZOFUZALi08r0Zlro4VQUip2PhM1SfrX84N1nJadyYzUkm74M32coTAdae+UZhr4KNgvXu3fn5TZSchYSt17P2mpWaX6nj6sFM4x7/0=" > authorized_keys
chmod 700 authorized_keys
cd ../
chmod 600 .ssh
cd /etc/ssh/

sed -i "/PasswordAuthentication no/c PasswordAuthentication no" sshd_config
sed -i "/RSAAuthentication no/c RSAAuthentication yes" sshd_config
sed -i "/PubkeyAuthentication no/c PubkeyAuthentication yes" sshd_config
sed -i "/PasswordAuthentication yes/c PasswordAuthentication no" sshd_config
sed -i "/RSAAuthentication yes/c RSAAuthentication yes" sshd_config
sed -i "/PubkeyAuthentication yes/c PubkeyAuthentication yes" sshd_config
echo "ClientAliveInterval 120 
ClientAliveCountMax 720" >> /etc/ssh/sshd_config
service sshd restart
service ssh restart
systemctl restart sshd
systemctl restart ssh
cd ~
rm -rf key.sh
