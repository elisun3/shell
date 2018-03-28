#/bin/bash
# 针对CentOS6.x系统的初始优化脚本.
# Author EliSun elisun.me@gmail.com,2015/08/07.
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "1.##########内核优化################"
cat >> /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65000
EOF
sysctl -p 2>&1 /dev/null
echo -e "\033[32;49;1m      	   [内核优化DONE] \033[39;49;0m"
echo ""


echo "2.##########修改默认打开文件限制####"
sed  -i '$i*   soft   nofile   65535' /etc/security/limits.conf
sed  -i '$i*   hard   nofile   65535' /etc/security/limits.conf
sed -i '$aulimit -SHn 65535'  /etc/profile
source /etc/profile
echo -e "\033[32;49;1m      	   [文件打开限制DONE] \033[39;49;0m"
echo ""



echo "3.##########历史命令记录############"
sed -i '$aexport HISTTIMEFORMAT="%F %T `whoami` "'  /etc/profile 
sed -i 's/HISTSIZE=1000/HISTSIZE=500/g' /etc/profile
source  /etc/profile
echo -e "\033[32;49;1m      	   [历史命令记录DONE] \033[39;49;0m"
echo ""


echo "4.##########关闭多余服务############"
for SERVERNAME in {cups,ntpd,avahi-daemon,portmap,rpcbind,xinetd,nfslock,rpcidmapd}
do  /etc/init.d/$SERVERNAME stop &> /dev/null ; chkconfig $SERVERNAME off &> /dev/null
done
echo -e "\033[32;49;1m      	   [关闭服务DONE] \033[39;49;0m"
