#!/bin/bash
HELL=/bin/bash 
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# 更新功能,所有系统通用【等待更新】

cat <<EOF
*********************************************************************
    __     __                      ______            
   / /    /_/____   __  __ _  __ / ____/__  __ ____ 
  / /    / // __ \ / / / /| |/_// / __ / / / // __ \
 / /___ / // / / // /_/ /_>  < / /_/ // /_/ // / / /
/_____//_//_/ /_/ \__,_//_/|_| \____/ \__,_//_/ /_/ 
                                                    

Version:4.0
Author:sun977
Mail:jiuwei977@foxmail.com
Date:2024.6.16

更新日志:
	2024.06.16:
		1、优化最近24h变化文件只看文件不看目录,同时排除目录/proc,/dev,/sys,/run
		2、修改了找不到高危端口的文件bug
		3、增加了检测系统环境变量的功能[.bashrc|.bash_profile|.zshrc|.viminfo等]
		4、增加了journalctl日志输出

检查说明:
	1.首先采集原始信息保存到当前目录的 output/liuxcheck_[your-ip]_[date]/check_file 目录下
	2.将系统日志、应用日志打包并保存到当前目录的 output/liuxcheck_[your-ip]_[date]/check_file/log 目录下
	3.在检查过程中检查项的结果会输出到当前目录 output/liuxcheck_[your-ip]_[date]/check_file/checkresult.txt 文件中
	4.在检查过程中若发现存在问题则直接输出到当前目录 output/liuxcheck_[your-ip]_[date]/check_file/saveDangerResult.txt 文件中
	5.有些未检查可能存在问题的需要人工分析原始文件
	6.脚本编写环境Centos7,在实际使用过程中若发现问题可以邮件联系:jiuwei977@foxmail.com
	7.使用过程中若在windows下修改再同步到Linux下,请使用dos2unix工具进行格式转换,不然可能会报错
	8.在使用过程中必须使用root账号,不然可能导致某些项无法分析
	9.checkrules目录下存放的是一些检测规则,可以根据实际情况进行修改

如何使用:
	1.需要将本脚本上传到相应的服务器中
	2.执行 chmod +x linuxcheck.sh
	3.执行 ./linuxcheck.sh 即可运行检查

功能设计:
	1.采集系统基础环境信息
	2.将原始数据进行分析,并找出存在可疑或危险项
	3.增加基线检查的功能
	4.黑客工具检查功能
	5.所有系统通用(待定)

检查内容:
	1.系统基础信息
		1.1 IP地址信息
		1.2 系统内核版本
		1.3 系统发行版本
		1.4 系统版本信息
	2.网络连接
		2.1 ARP表项
		2.2 ARP攻击
		2.3 网络连接信息
			2.3.1 网络连接情况
			2.3.1 网络DNS
		2.4 网卡工作模式
			2.4.1 网卡混杂模式
			2.4.2 网卡监听模式
		2.5 网络路由
			2.5.1 网络路由表
			2.5.2 网络路由转发
		2.6 防火墙策略
			2.6.1 firewalld策略
			2.6.2 iptables策略
	3.端口信息
		3.1 TCP开放端口
		3.2 TCP高危端口
		3.3 UDP开放端口
		3.4 UDP高危端口
	4.系统进程
		4.1 系统进程
		4.2 守护进程
	5.自启动项
		5.1 用户自启动项
		5.2 系统自启动项
		5.3 危险启动项分析
	6.定时任务
		6.1 系统定时任务收集
		6.2 系统定时任务分析
		6.3 用户定时任务收集
		6.4 用户定时任务分析
	7.系统服务
	8.关键文件检查
		8.1 hosts文件
		8.2 公钥文件
		8.3 私钥文件
		8.4 authorized_keys文件
		8.5 known_hosts文件
		8.6 tmp目录检查
		8.7 环境变量检查
		8.8 /root下隐藏文件检查
	9.用户登录情况
		9.1 正在登陆的用户
		9.2 用户信息[passwd文件]
		9.3 超级用户信息
		9.4 克隆用户信息
		9.5 可登录用户信息
		9.6 非系统用户信息
		9.7 检查shadow文件
		9.8 空口令用户
		9.9 空口令且可登录用户
		9.10 口令未加密用户
		9.11 用户组信息
			9.11.1 用户组信息
			9.11.2 特权用户组
			9.11.3 相同GID用户组
			9.11.4 相同用户组名
		9.12 sshd登陆配置
			9.12.1 sshd配置
			9.12.2 空口令登录
			9.12.3 root远程登录
			9.12.4 ssh协议版本
		9.13 文件权限
			9.13.1 etc文件权限
			9.13.2 shadow文件权限
			9.13.3 passwd文件权限
			9.13.4 group文件权限
			9.13.5 securetty文件权限
			9.13.6 services文件权限
			9.13.7 grub.conf文件权限
			9.13.8 xinetd.conf文件权限
			9.13.9 lilo.conf文件权限
			9.13.10 limits.conf文件权限
		9.14 文件属性
			9.14.1 passwd文件属性
			9.14.2 shadow文件属性
			9.14.3 gshadow文件属性
			9.14.4 group文件属性
		9.15 useradd和userdel时间属性
			9.15.1 useradd时间属性
			9.15.2 userdel时间属性
	10.配置策略检查(基线检查)
		10.1 远程访问策略
			10.1.1 远程允许策略
			10.1.2 远程拒绝策略
		10.2 账号与密码策略
			10.2.1 密码有效期策略
				10.2.1.1 口令生存周期
				10.2.1.2 口令更改最小时间间隔
				10.2.1.3 口令最小长度
				10.2.1.4 口令过期时间天数
			10.2.2 密码复杂度策略
			10.2.3 密码已过期用户
			10.2.4 账号超时锁定策略
			10.2.5 grub密码策略检查
			10.2.6 lilo密码策略检查
		10.3 selinux策略
		10.4 sshd配置
			10.4.1 sshd配置
			10.4.2 空口令登录
			10.4.3 root远程登录
			10.4.4 ssh协议版本
		10.5 NIS配置策略
		10.6 Nginx配置策略
			10.6.1 原始配置
			10.6.2 可疑配置
		10.7 SNMP配置检查
	11.历史命令
		11.1 系统历史命令
			11.1.1 系统操作历史命令
			11.1.2 是否下载过脚本文件
			11.1.3 是否增加过账号
			11.1.4 是否删除过账号
			11.1.5 历史可疑命令
			11.1.6 本地下载文件
			11.1.7 yum下载记录
			11.1.8 关闭历史命令记录
		11.2 数据库历史命令
	12.可疑文件检查
		12.1 检查脚本文件
		12.2 检查webshell文件(需要第三方工具)
		12.3 检查最近变动的敏感文件
		12.4 检查最近变动的所有文件
		12.5 黑客工具检查
	13.系统文件完整性校验
	14.系统日志分析
		14.1 日志配置与打包
			14.1.1 查看日志配置
			14.1.2 日志是否存在
			14.1.3 日志审核是否开启
			14.1.4 自动打包日志
		14.2 secure日志分析
			14.2.1 成功登录
			14.2.2 登录失败
			14.2.3 窗口登陆情况
			14.2.4 新建用户与用户组
		14.3 message日志分析
			14.3.1 传输文件
			14.3.2 历史使用DNS
		14.4 cron日志分析
			14.4.1 定时下载
			14.4.2 定时执行脚本
		14.5 yum日志分析
			14.5.1 下载软件情况
			14.5.2 卸载软件情况
			14.5.3 下载可疑软件
		14.6 dmesg日志分析
			14.6.1 内核自检分析
		14.7 btmp日志分析
			14.7.1 错误登录分析
		14.8 lastlog日志分析
			14.8.1 所有用户最后一次登录分析
		14.9 wtmp 日志分析
			14.9.1 所有用户登录分析
		14.10 journalctl 日志输出
	15.内核检查
		15.1 内核信息
		15.2 异常内核
	16.安装软件(rpm)
		16.1 安装软件
		16.2 可疑软件
	17.环境变量
	18.性能分析
		18.1 磁盘使用
			18.1.1 磁盘使用情况
			18.1.2 磁盘使用过大
		18.2 CPU
			18.2.1 CPU情况
			18.2.2 占用CPU前五进程
			18.2.3 占用CPU较多资源进程
		18.3 内存
			18.3.1 内存情况
			18.3.2 占用内存前五进程
			18.3.3 占用内存占多进程
		18.4 系统运行及负载
			18.4.1 运行时间及负载情况
	19.统一结果打包
		19.1 系统原始日志统一打包
		19.2 检查脚本日志统一打包

*********************************************************************
EOF

# 脚本转换确保可以在Linux下运行
dos2unix linuxcheck.sh
date=$(date +%Y%m%d)
# 取出本机器上第一个非回环地址的IP地址,用于区分导出的文件
ipadd=$(ifconfig -a | grep -w inet | grep -v 127.0.0.1 | awk 'NR==1{print $2}')

# 创建输出目录变量，当前目录下的output目录
current_dir=$(pwd)  
check_file="${current_dir}/output/linuxcheck_${ipadd}_${date}/check_file"
log_file="${check_file}/log"

# 删除原有的输出目录
rm -rf $check_file
rm -rf $log_file

# 创建新的输出目录 检查目录 日志目录
mkdir -p $check_file
mkdir -p $log_file
echo "检查发现危险项,请注意:" > ${check_file}/dangerlist.txt
echo "" >> $check_file/dangerlist.txt

# 判断目录是否存在
if [ ! -d "$check_file" ];then
	echo "检查${check_file}目录不存在,请检查"
	exit 1
fi

if [ $(whoami) != "root" ];then
	echo "安全检查必须使用root账号,否则某些项无法检查"
	exit 1
fi

# 在 check_file 下追加模式打开文件，将输出结果展示在终端且同时保存到对应文件中 
cd $check_file  
saveCheckResult="tee -a checkresult.txt" 
saveDangerResult="tee -a dangerlist.txt"

################################################################


echo "LinuxGun 正在检查..."  | $saveCheckResult
echo "==========1.系统基础信息==========" | $saveCheckResult
echo "[1.0]正在采集系统基础信息:" && "$saveCheckResult"
echo "[1.1]IP地址信息[ip add]:" | $saveCheckResult
# ip=$(ifconfig -a | grep -w inet | awk '{print $2}')
ip=$(ip add | grep -w inet | awk '{print $2}')

# 判断ip是否为空
if [ -n "$ip" ];then
	(echo "[+]本机IP地址信息:" && echo "$ip")  | $saveCheckResult
else
	echo "[!]本机未配置IP地址" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[1.2]系统内核版本[uname -a]:" | $saveCheckResult
corever=$(uname -a)
if [ -n "$corever" ];then
	(echo "[+]系统内核版本信息:" && echo "$corever") | $saveCheckResult
else
	echo "[!]未发现内核版本信息" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[1.3]作系统信息[/etc/*-release]:" | $saveCheckResult
systemver=$(cat /etc/*-release)
if [ -n "$systemver" ];then
	(echo "[+]系统版本信息:" && echo "$systemver") | $saveCheckResult
else
	echo "[!]未发现系统版本信息" | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "==========2.网络连接情况==========" | $saveCheckResult
echo "[2.0]正在采集ARP表信息:" && "$saveCheckResult"
echo "[2.1]ARP表项[arp -a -n]:" | $saveCheckResult
arp=$(arp -a -n)
if [ -n "$arp" ];then
	(echo "[+]ARP表项如下:" && echo "$arp") | $saveCheckResult
else
	echo "[!]未发现arp表" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# 原理：通过解析arp表并利用awk逻辑对MAC地址进行计数和识别，然后输出重复的MAC地址以及它们的出现次数
# 该命令用于统计arp表中的MAC地址出现次数，并显示重复的MAC地址及其出现频率。
# 具体解释如下：
# - `arp -a -n`：查询ARP表，并以IP地址和MAC地址的格式显示结果。
# - `awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}'`：使用awk命令进行处理。
#   - `{++S[$4]}`：对数组S中以第四个字段（即MAC地址）作为索引的元素加1进行计数。
#   - `END {for(a in S) {if($2>1) print $2,a,S[a]}}`：在处理完所有行之后，遍历数组S。
#     - `for(a in S)`：遍历数组S中的每个元素。
#     - `if($2>1)`：如果第二个字段（即计数）大于1，则表示这是一个重复的MAC地址。
#     - `print $2,a,S[a]`：打印重复的MAC地址的计数、MAC地址本身和出现的次数。

echo "[2.2]正在检测是否存在ARP攻击[arp -a -n]:" | $saveCheckResult
echo "[原理]:通过解析arp表并利用awk逻辑对MAC地址进行计数和识别,然后输出重复的MAC地址以及它们的出现次数" | $saveCheckResult
arpattack=$(arp -a -n | awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}')
if [ -n "$arpattack" ];then
	(echo "[!]发现存在ARP攻击:" && echo "$arpattack") | $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现ARP攻击" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.3]正在采集网络连接信息:" && "$saveCheckResult"
echo "[2.3.1]正在检查网络连接情况[netstat -anlp]:" | $saveCheckResult
netstat=$(netstat -anlp | grep ESTABLISHED)
netstatnum=$(netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}')
if [ -n "$netstat" ];then
	(echo "[+]建立网络连接情况如下:" && echo "$netstat") | $saveCheckResult
	if [ -n "$netstatnum" ];then
		(echo "[+]各个状态的数量如下:" && echo "$netstatnum") | $saveCheckResult
	fi
else
	echo "[+]未发现网络连接" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[2.3.2]正在检查网络DNS[/etc/resolv.conf]:" | $saveCheckResult
resolv=$(more /etc/resolv.conf | grep ^nameserver | awk '{print $NF}') 
if [ -n "$resolv" ];then
	(echo "[+]该服务器使用以下DNS服务器:" && echo "$resolv") | $saveCheckResult
else
	echo "[+]未发现DNS服务器" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.4]正在检查网卡模式[ip addr]:" | $saveCheckResult
# ifconfigmode=$(ifconfig -a | grep flags | awk -F '[: = < >]' '{print "网卡:",$1,"模式:",$5}')
ifconfigmode=$(ip addr | grep '<' | awk  '{print "网卡:",$2,"模式:",$3}' | sed 's/<//g' | sed 's/>//g')
if [ -n "$ifconfigmode" ];then
	(echo "网卡工作模式如下:" && echo "$ifconfigmode") | $saveCheckResult
else
	echo "[+]未找到网卡模式相关信息,请人工分析" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.4.1]正在分析是否有网卡处于混杂模式[ifconfig]:" | $saveCheckResult
Promisc=`ifconfig | grep PROMISC | gawk -F: '{ print $1}'`
if [ -n "$Promisc" ];then
	(echo "[!]网卡处于混杂模式:" && echo "$Promisc") | $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现网卡处于混杂模式" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[2.4.2]正在分析是否有网卡处于监听模式[ifconfig]:" | $saveCheckResult
Monitor=`ifconfig | grep -E "Mode:Monitor" | gawk -F: '{ print $1}'`
if [ -n "$Monitor" ];then
	(echo "[!]网卡处于监听模式:" && echo "$Monitor") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现网卡处于监听模式" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.5]正在采集网络路由信息:" && "$saveCheckResult"
echo "[2.5.1]正在检查路由表[route -n]:" | $saveCheckResult
route=$(route -n)
if [ -n "$route" ];then
	(echo "[+]路由表如下:" && echo "$route") | $saveCheckResult
else
	echo "[+]未发现路由器表" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.5.2]正在分析是否开启转发功能[/proc/sys/net/ipv4/ip_forward]:" | $saveCheckResult
#数值分析
#1:开启路由转发
#0:未开启路由转发
ip_forward=`more /proc/sys/net/ipv4/ip_forward | gawk -F: '{if ($1==1) print "1"}'`
if [ -n "$ip_forward" ];then
	echo "[!]该服务器开启路由转发,请注意!" |  $saveDangerResult  | $saveCheckResult
else
	echo "[+]该服务器未开启路由转发" | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "[2.6]正在采集防火墙策略:" && "$saveCheckResult"
echo "[2.6.1]正在检查firewalld策略[systemctl status firewalld]:" | $saveCheckResult
firewalledstatus=$(systemctl status firewalld | grep "active (running)")
firewalledpolicy=$(firewall-cmd --list-all)
if [ -n "$firewalledstatus" ];then
	echo "[+]该服务器防火墙已打开"
	if [ -n "$firewalledpolicy" ];then
		(echo "[+]防火墙策略如下" && echo "$firewalledpolicy") | $saveCheckResult
	else
		echo "[!]防火墙策略未配置,建议配置防火墙策略!" |  $saveDangerResult | $saveCheckResult
	fi
else
	echo "[!]防火墙未开启,建议开启防火墙" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.6.2]正在检查iptables策略[service iptables status]:" | $saveCheckResult
firewalledstatus=$(service iptables status | grep "Table" | awk '{print $1}')  # 有"Table:",说明开启,没有说明未开启
firewalledpolicy=$(iptables -L)
if [ -n "$firewalledstatus" ];then
	echo "[+]iptables已打开"
	if [ -n "$firewalledpolicy" ];then
		(echo "[+]iptables策略如下" && echo "$firewalledpolicy") | $saveCheckResult
	else
		echo "[!]iptables策略未配置,建议配置iptables策略!" |  $saveDangerResult | $saveCheckResult
	fi
else
	echo "[!]iptables未开启,建议开启防火墙" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "==========3.端口信息==========" | $saveCheckResult
echo "[3.1]正在检查TCP开放端口[netstat -antlp]:" | $saveCheckResult
echo "[说明]TCP或UDP端口绑定在0.0.0.0、127.0.0.1、192.168.1.1这种IP上只表示这些端口开放" | $saveCheckResult
echo "[说明]只有绑定在0.0.0.0上局域网才可以访问" | $saveCheckResult
listenport=$(netstat -anltp | grep LISTEN | awk  '{print $4,$7}' | sed 's/:/ /g' | awk '{print $2,$3}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
if [ -n "$listenport" ];then
	(echo "[+]该服务器开放TCP端口以及对应的服务:" && echo "$listenport") | $saveCheckResult
else
	echo "[!]系统未开放TCP端口" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

accessport=$(netstat -anltp | grep LISTEN | awk  '{print $4,$7}' | egrep "(0.0.0.0|:::)" | sed 's/:/ /g' | awk '{print $(NF-1),$NF}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
if [ -n "$accessport" ];then
	(echo "[!]以下TCP端口面向局域网或互联网开放,请注意！" && echo "$accessport") | $saveCheckResult
else
	echo "[+]端口未面向局域网或互联网开放" | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "[3.2]正在检查TCP高危端口[netstat -antlp]:" | $saveCheckResult
echo "[说明]开放端口 dangerstcpports.txt 中的定义的端口匹配,匹配成功则为高危端口" | $saveCheckResult
tcpport=`netstat -anlpt | awk '{print $4}' | awk -F: '{print $NF}' | sort | uniq | grep '[0-9].*'`
count=0
if [ -n "$tcpport" ];then
	for port in $tcpport
	do
		# 进入到 checkrules 目录下
		for i in `cat ./checkrules/dangerstcpports.txt`
		do
			tcpport=`echo $i | awk -F "[:]" '{print $1}'`
			desc=`echo $i | awk -F "[:]" '{print $2}'`
			process=`echo $i | awk -F "[:]" '{print $3}'`
			if [ $tcpport == $port ];then
				echo "$tcpport,$desc,$process" | $saveDangerResult | $saveCheckResult
				count=count+1
			fi
		done
	done
fi
if [ $count = 0 ];then
	echo "[+]未发现TCP高危端口" | $saveCheckResult
else
	echo "[!]请人工对TCP危险端口进行关联分析与确认" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[3.3]正在检查UDP开放端口[netstat -anlup]:" | $saveCheckResult
udpopen=$(netstat -anlup | awk  '{print $4,$NF}' | grep : | sed 's/:/ /g' | awk '{print $2,$3}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
if [ -n "$udpopen" ];then
	(echo "[+]该服务器开放UDP端口以及对应的服务:" && echo "$udpopen") | $saveCheckResult
else
	echo "[!]系统未开放UDP端口" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

udpports=$(netstat -anlup | awk '{print $4}' | egrep "(0.0.0.0|:::)" | awk -F: '{print $NF}' | sort -n | uniq)
if [ -n "$udpports" ];then
	echo "[+]以下UDP端口面向局域网或互联网开放:" | $saveCheckResult
	for port in $udpports
	do
		nc -uz 127.0.0.1 $port
		if [ $? -eq 0 ];then
			echo $port  | $saveCheckResult
		fi
	done
else 
	echo "[+]未发现在UDP端口面向局域网或互联网开放." | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[3.4]正在检查UDP高危端口[netstat -anlup]:"
echo "[说明]开放端口 dangersudpports.txt 中的定义的端口匹配,匹配成功则为高危端口" | $saveCheckResult
udpport=`netstat -anlpu | awk '{print $4}' | awk -F: '{print $NF}' | sort | uniq | grep '[0-9].*'`
count=0
if [ -n "$udpport" ];then
	for port in $udpport
	do
		for i in `cat ./checkrules/dangersudpports.txt`
		do
			udpport=`echo $i | awk -F "[:]" '{print $1}'`
			desc=`echo $i | awk -F "[:]" '{print $2}'`
			process=`echo $i | awk -F "[:]" '{print $3}'`
			if [ $udpport == $port ];then
				echo "$udpport,$desc,$process" | $saveDangerResult | $saveCheckResult
				count=count+1
			fi
		done
	done
fi
if [ $count = 0 ];then
	echo "[+]未发现UDP高危端口" | $saveCheckResult
else
	echo "[!]请人工对UDP危险端口进行关联分析与确认"
fi
printf "\n" | $saveCheckResult


echo "==========4.系统进程==========" | $saveCheckResult
echo "[4.1]正在检查系统进程[ps -aux]:" | $saveCheckResult
ps=$(ps -aux)
if [ -n "$ps" ];then
	(echo "[+]系统进程如下:" && echo "$ps") | $saveCheckResult
else
	echo "[+]未发现系统进程" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[4.2]正在检查守护进程[/etc/xinetd.d/rsync]:" | $saveCheckResult
if [ -e /etc/xinetd.d/rsync ];then
	(echo "[+]系统守护进程:" && more /etc/xinetd.d/rsync | grep -v "^#") | $saveCheckResult
else
	echo "[+]未发现守护进程" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "==========5.启动项情况==========" | $saveCheckResult
echo "[5.1]正在检查用户自定义启动项[chkconfig --list]:" | $saveCheckResult
chkconfig=$(chkconfig --list | grep -E ":on|启用" | awk '{print $1}')
if [ -n "$chkconfig" ];then
	(echo "[+]用户自定义启动项:" && echo "$chkconfig") | $saveCheckResult
else
	echo "[!]未发现用户自定义启动项" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[5.2]正在检查系统自启动项[systemctl list-unit-files]:" | $saveCheckResult
systemchkconfig=$(systemctl list-unit-files | grep enabled | awk '{print $1}')
if [ -n "$systemchkconfig" ];then
	(echo "[+]系统自启动项如下:" && echo "$systemchkconfig")  | $saveCheckResult
else
	echo "[+]未发现系统自启动项" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[5.3]正在分析危险启动项[chkconfig --list]:" | $saveCheckResult
dangerstarup=$(chkconfig --list | grep -E ":on|启用" | awk '{print $1}' | grep -E "\.(sh|per|py|exe)$")
if [ -n "$dangerstarup" ];then
	(echo "[!]发现危险启动项:" && echo "$dangerstarup") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现危险启动项" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========6.定时任务==========" | $saveCheckResult
echo "[6.1]正在检查系统定时任务[/etc/crontab]:" | $saveCheckResult
syscrontab=$(more /etc/crontab | grep -v "# run-parts" | grep run-parts)
if [ -n "$syscrontab" ];then
	(echo "[!]发现存在系统定时任务:" && more /etc/crontab ) |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现系统定时任务" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

# if [ $? -eq 0 ]表示上面命令执行成功;执行成功输出的是0；失败非0
#ifconfig  echo $? 返回0，表示执行成功
# if [ $? != 0 ]表示上面命令执行失败


echo "[6.2]正在分析系统可疑任务[/etc/cron*/* | /var/spool/cron/*]:" | $saveCheckResult
dangersyscron=$(egrep "((chmod|useradd|groupadd|chattr)|((wget|curl)*\.(sh|pl|py|exe)$))"  /etc/cron*/* /var/spool/cron/*)
if [ $? -eq 0 ];then
	(echo "[!]发现下面的定时任务可疑,请注意!" && echo "$dangersyscron") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现可疑系统定时任务" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[6.3]正在收集用户定时任务[crontab -l]:" | $saveCheckResult
crontab=$(crontab -l)
if [ $? -eq 0 ];then
	(echo "[!]发现用户定时任务如下:" && echo "$crontab") | $saveCheckResult
else
	echo "[+]未发现用户定时任务"  | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[6.4]正在分析用户定时任务[crontab -l]:" | $saveCheckResult
danger_crontab=$(crontab -l | egrep "((chmod|useradd|groupadd|chattr)|((wget|curl).*\.(sh|pl|py|exe)))")
if [ $? -eq 0 ];then
	(echo "[!]发现可疑定时任务,请注意!" && echo "$danger_crontab") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现可疑定时任务" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========7.系统服务信息==========" | $saveCheckResult
echo "[7.1]正在检查运行服务[systemctl | grep -E "\.service.*running"]:" | $saveCheckResult
services=$(systemctl | grep -E "\.service.*running" | awk -F. '{print $1}')
if [ -n "$services" ];then
	(echo "[+]以下服务正在运行：" && echo "$services") | $saveCheckResult
else
	echo "[!]未发现正在运行的服务！" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========8.关键文件检查==========" | $saveCheckResult
echo "[8.1]正在检查hosts文件[/etc/hosts](未检查.bash_history|.zsh_history文件):" | $saveCheckResult
hosts=$(more /etc/hosts)
if [ -n "$hosts" ];then
	(echo "[+]hosts文件如下:" && echo "$hosts") | $saveCheckResult
else
	echo "[+]未发现hosts文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.2]正在检查公钥文件[/root/.ssh/*.pub]:" | $saveCheckResult
if [  -e /root/.ssh/*.pub ];then
	echo "[!]发现公钥文件,请注意!"  |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现公钥文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.3]正在检查私钥文件[/root/.ssh/id_rsa]:" | $saveCheckResult
if [ -e /root/.ssh/id_rsa ];then
	echo "[!]发现私钥文件,请注意!" |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现私钥文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.4]正在检查authorized_keys文件[/root/.ssh/authorized_keys]:" | $saveCheckResult
echo "[说明]authorized_keys文件是用于SSH密钥认证的文件,它用于存储用户在远程登录时所允许的公钥,可定位谁可以免密登陆该主机" | $saveCheckResult
authkey=$(more /root/.ssh/authorized_keys)
if [ -n "$authkey" ];then
	(echo "[!]发现被授权登录的用户公钥信息如下" && echo "$authkey") | $saveCheckResult
else
	echo "[+]未发现被授权登录的用户公钥信息" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.5]正在检查known_hosts文件[/root/.ssh/known_hosts]:" | $saveCheckResult
echo "[说明]known_hosts文件是用于存储SSH服务器公钥的文件,可用于排查当前主机可横向范围,快速定位可能感染的主机" | $saveCheckResult
knownhosts=$(more /root/.ssh/known_hosts | awk '{print $1}')
if [ -n "$knownhosts" ];then
	(echo "[!]发现已知远程主机公钥信息如下:" && echo "$knownhosts") | $saveCheckResult
else
	echo "[+]未发现已知远程主机公钥信息" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.6]正在检查tmp目录[/tmp]:" | $saveCheckResult
echo "[说明]tmp目录是用于存放临时文件的目录,可用于存放木马文件,可用于存放病毒文件,可用于存放破解文件" | $saveCheckResult
(ls -alt /tmp) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[8.7]正在检查环境变量文件[.bashrc|.bash_profile|.zshrc|.viminfo等]:" | $saveCheckResult
echo "[说明]环境变量文件是用于存放用户环境变量的文件,可用于后门维持留马等(需要人工检查有无权限维持痕迹)" | $saveCheckResult
# 定义环境变量文件的位置列表
envfile="/root/.bashrc /root/.bash_profile /root/.zshrc /root/.viminfo /etc/profile /etc/bashrc /etc/environment"
for file in $envfile;do
	if [ -e $file ];then
		echo "[+]环境变量文件:$file" | $saveCheckResult
		more $file | $saveCheckResult
		printf "\n" | $saveCheckResult
		# 文件内容中是否包含关键字 curl http https wget 等关键字
		if [ -n "$(more $file | grep -E "curl|wget|http|https|python")" ];then
			echo "[!]发现环境变量文件[$file]中包含curl|wget|http|https|python等关键字!" | $saveDangerResult | $saveCheckResult
		fi 
	else
		echo "[+]环境变量文件:$file" | $saveCheckResult
	fi
done
printf "\n" | $saveCheckResult


echo "[8.8]正在检查/root的隐藏文件[cat -alt /root]" | $saveCheckResult
echo "[说明]隐藏文件以.开头,可用于存放木马文件,可用于存放病毒文件,可用于存放破解文件"  | $saveCheckResult
(ls -alt /root) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "==========9.用户登陆情况==========" | $saveCheckResult
echo "[9.1]正在检查正在登录的用户[who]:" | $saveCheckResult
(echo "[+]系统登录用户:" && who ) | $saveCheckResult
printf "\n" | $saveCheckResult
(echo "[+]系统最后登陆用户:" && last ) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.2]正在查看用户信息[/etc/passwd]:" | $saveCheckResult
echo "[说明]用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell[共7个字段]" | $saveCheckResult
more /etc/passwd  | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.3]正在检查是否存在超级用户[/etc/passwd]:" | $saveCheckResult
echo "[+]UID=0的为超级用户,系统默认root的UID为0" | $saveCheckResult
Superuser=`more /etc/passwd | egrep -v '^root|^#|^(\+:\*)?:0:0:::' | awk -F: '{if($3==0) print $1}'`
if [ -n "$Superuser" ];then
	echo "[!]除root外发现超级用户:" |  $saveDangerResult | $saveCheckResult
	for user in $Superuser
	do
		echo $user | $saveCheckResult
		if [ "${user}" = "toor" ];then
			echo "[!]BSD系统默认安装toor用户,其他系统默认未安装toor用户,若非BSD系统建议删除该账号" | $saveCheckResult
		fi
	done
else
	echo "[+]未发现超级用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.4]正在检查是否存在克隆用户[/etc/passwd]:" | $saveCheckResult
echo "[+]UID相同为克隆用户" | $saveCheckResult
uid=`awk -F: '{a[$3]++}END{for(i in a)if(a[i]>1)print i}' /etc/passwd`
if [ -n "$uid" ];then
	echo "[!]发现下面用户的UID相同:" |  $saveDangerResult | $saveCheckResult
	(more /etc/passwd | grep $uid | awk -F: '{print $1}') |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现相同UID的用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.5]正在检查可登录的用户[/etc/passwd]:" | $saveCheckResult
loginuser=`cat /etc/passwd  | grep -E "/bin/bash$" | awk -F: '{print $1}'`
if [ -n "$loginuser" ];then
	echo "[!]以下用户可以登录主机:" |  $saveDangerResult | $saveCheckResult
	for user in $loginuser
	do
		echo $user |  $saveDangerResult | $saveCheckResult
	done
else
	echo "[+]未发现可以登录的用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.6]正在检查非系统本身自带用户[/etc/login.defs]" | $saveCheckResult
if [ -f /etc/login.defs ];then
	uid=$(grep "^UID_MIN" /etc/login.defs | awk '{print $2}')
	(echo "系统最小UID为"$uid) | $saveCheckResult
	nosystemuser=`gawk -F: '{if ($3>='$uid' && $3!=65534) {print $1}}' /etc/passwd`
	if [ -n "$nosystemuser" ];then
		(echo "以下用户为非系统本身自带用户:" && echo "$nosystemuser") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]未发现除系统本身外的其他用户" | $saveCheckResult
	fi
fi
printf "\n" | $saveCheckResult


echo "[9.7]正在检查shadow文件[/etc/shadow]:" | $saveCheckResult
echo "[说明]用户名:加密密码:最后一次修改时间:最小修改时间间隔:密码有效期:密码需要变更前的警告天数:密码过期后的宽限时间:账号失效时间:保留字段[共9个字段]" | $saveCheckResult
(echo "[+]shadow文件如下:" && more /etc/shadow ) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.8]正在检查空口令用户[/etc/shadow]:" | $saveCheckResult
echo "[原理]shadow文件中密码字段(第二个字段)为空的用户即为空口令用户" | $saveCheckResult
nopasswd=`gawk -F: '($2=="") {print $1}' /etc/shadow`
if [ -n "$nopasswd" ];then
	(echo "[!]以下用户口令为空:" && echo "$nopasswd") | $saveCheckResult
else
	echo "[+]未发现空口令用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# 原理:
# 1. 从`/etc/passwd`文件中提取使用`/bin/bash`作为shell的用户名。
# 2. 从`/etc/shadow`文件中获取密码字段为空的用户名。
# 3. 检查`/etc/ssh/sshd_config`中SSH服务器配置是否允许空密码。
# 4. 遍历步骤1中获取的每个用户名，并检查其是否与步骤2中获取的任何用户名匹配，并且根据步骤3是否允许空密码进行判断。如果存在匹配，则打印通知，表示存在空密码且允许登录的用户。
# 5. 最后，根据是否找到匹配，打印警告消息，要求人工分析配置和账户，或者打印消息表示未发现空口令且可登录的用户。
echo "[9.9]正在检查空口令且可登录的用户[/etc/passwd|/etc/shadow|/etc/ssh/sshd_config]:" | $saveCheckResult
#允许空口令用户登录方法
#1.passwd -d username
#2.echo "PermitEmptyPasswords yes" >>/etc/ssh/sshd_config
#3.service sshd restart
passwdUser=$(cat /etc/passwd  | grep -E "/bin/bash$" | awk -F: '{print $1}')
noSetPwdUser=$(gawk -F: '($2=="") {print $1}' /etc/shadow)
isPermit=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
flag=""
for a in $passwdUser
do
    for b in $noSetPwdUser
    do
        if [ "$a" = "$b" ] && [ -n "$isPermit" ];then
            echo "[!]发现空口令且可登录用户:"$a  	| $saveDangerResult | $saveCheckResult
            flag=1
        fi
    done
done
if [ -n "$flag" ];then
	echo "请人工分析配置和账号" | $saveCheckResult
else
	echo "[+]未发现空口令且可登录用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.10]正在检查口令未加密用户[/etc/passwd]:" | $saveCheckResult
noenypasswd=$(awk -F: '{if($2!="x") {print $1}}' /etc/passwd)
if [ -n "$noenypasswd" ];then
	(echo "[!]以下用户口令未加密:" && echo "$noenypasswd") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现口令未加密的用户"  | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.11]正在检查用户组信息:" | $saveCheckResult
echo "[9.11.1]正在检查用户组信息[/etc/group]:" | $saveCheckResult
echo "[+]用户组信息如下:"
(more /etc/group | grep -v "^#") | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.11.2]正在检查特权用户[/etc/group]:" | $saveCheckResult
roots=$(more /etc/group | grep -v '^#' | gawk -F: '{if ($1!="root"&&$3==0) print $1}')
if [ -n "$roots" ];then
	echo "[!]除root用户外root组还有以下用户:" |  $saveDangerResult | $saveCheckResult
	for user in $roots
	do
		echo $user |  $saveDangerResult | $saveCheckResult
	done
else 
	echo "[+]除root用户外root组未发现其他用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.11.3]正在检查相应GID用户组[/etc/group]:" | $saveCheckResult
groupuid=$(more /etc/group | grep -v "^$" | awk -F: '{print $3}' | uniq -d)
if [ -n "$groupuid" ];then
	(echo "[!]发现相同GID用户组:" && echo "$groupuid") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现相同GID的用户组" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.11.4]正在检查相同用户组名[/etc/group]:" | $saveCheckResult
groupname=$(more /etc/group | grep -v "^$" | awk -F: '{print $1}' | uniq -d)
if [ -n "$groupname" ];then
	(echo "[!]发现相同用户组名:" && echo "$groupname") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现相同用户组名" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12]正在检查SSHD登陆配置:" | $saveCheckResult
echo "[9.12.1]正在检查sshd配置[/etc/ssh/sshd_config]:" | $saveCheckResult
sshdconfig=$(more /etc/ssh/sshd_config | egrep -v "#|^$")
if [ -n "$sshdconfig" ];then
	(echo "[+]sshd配置文件如下:" && echo "$sshdconfig") | $saveCheckResult
else
	echo "[!]未发现sshd配置文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12.2]正在检查是否允许SSH空口令登录[/etc/ssh/sshd_config]:" | $saveCheckResult
emptypasswd=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
nopasswd=`gawk -F: '($2=="") {print $1}' /etc/shadow`
if [ -n "$emptypasswd" ];then
	echo "[!]允许空口令登录,请注意!"
	if [ -n "$nopasswd" ];then
		(echo "[!]以下用户空口令:" && echo "$nopasswd") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]但未发现空口令用户" | $saveCheckResult
	fi
else
	echo "[+]不允许空口令用户登录" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12.3]正在检查是否允许SSH远程root登录[/etc/ssh/sshd_config]:" | $saveCheckResult
cat /etc/ssh/sshd_config | grep -v ^# |grep "PermitRootLogin no"
if [ $? -eq 0 ];then
	echo "[+]root不允许登陆,符合要求" | $saveCheckResult
else
	echo "[!]允许root远程登陆,不符合要求,建议/etc/ssh/sshd_config添加PermitRootLogin no" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12.4]正在检查SSH协议版本[/etc/ssh/sshd_config]:" | $saveCheckResult
echo "[说明]需要详细的SSH版本信息另行检查,防止SSH版本过低,存在漏洞" | $saveCheckResult
protocolver=$(more /etc/ssh/sshd_config | grep -v ^$ | grep Protocol | awk '{print $2}')
if [ "$protocolver" -eq "2" ];then
	echo "[+]openssh使用ssh2协议,符合要求" 
else
	echo "[!]openssh未ssh2协议,不符合要求"
fi


echo "[9.13]正在检查登陆相关文件权限:" | $saveCheckResult
echo "[9.13.1]正在检查etc文件权限[etc]:" | $saveCheckResult
etc=$(ls -l / | grep etc | awk '{print $1}')
if [ "${etc:1:9}" = "rwxr-x---" ]; then
    echo "[+]/etc/权限为750,权限正常" | $saveCheckResult
else
    echo "[!]/etc/文件权限为:""${etc:1:9}","权限不符合规划,权限应改为750" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.2]正在检查shadow文件权限[/etc/shadow ]:" | $saveCheckResult
shadow=$(ls -l /etc/shadow | awk '{print $1}')
if [ "${shadow:1:9}" = "rw-------" ]; then
    echo "[+]/etc/shadow文件权限为600,权限符合规范" | $saveCheckResult
else
    echo "[!]/etc/shadow文件权限为:""${shadow:1:9}"",不符合规范,权限应改为600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.3]正在检查passwd文件权限[/etc/passwd]:" | $saveCheckResult
passwd=$(ls -l /etc/passwd | awk '{print $1}')
if [ "${passwd:1:9}" = "rw-r--r--" ]; then
    echo "[+]/etc/passwd文件权限为644,符合规范" | $saveCheckResult
else
    echo "[!]/etc/passwd文件权限为:""${passwd:1:9}"",权限不符合规范,建议改为644" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.4]正在检查group文件权限[/etc/group ]:" | $saveCheckResult
group=$(ls -l /etc/group | awk '{print $1}')
if [ "${group:1:9}" = "rw-r--r--" ]; then
    echo "[+]/etc/group文件权限为644,符合规范" | $saveCheckResult
else
    echo "[!]/etc/goup文件权限为""${group:1:9}","不符合规范,权限应改为644" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.5]正在检查securetty文件权限[/etc/securetty]:" | $saveCheckResult
securetty=$(ls -l /etc/securetty | awk '{print $1}')
if [ "${securetty:1:9}" = "-rw-------" ]; then
    echo "[+]/etc/securetty文件权限为600,符合规范" | $saveCheckResult
else
    echo "[!]/etc/securetty文件权限为""${securetty:1:9}","不符合规范,权限应改为600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.6]正在检查services文件权限[/etc/services]:" | $saveCheckResult
services=$(ls -l /etc/services | awk '{print $1}')
if [ "${services:1:9}" = "-rw-r--r--" ]; then
    echo "[+]/etc/services文件权限为644,符合规范" | $saveCheckResult
else
    echo "[!]/etc/services文件权限为""$services:1:9}","不符合规范,权限应改为644" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.7]正在检查grub.conf文件权限[/etc/grub.conf]:" | $saveCheckResult
grubconf=$(ls -l /etc/grub.conf | awk '{print $1}')
if [ "${grubconf:1:9}" = "-rw-------" ]; then
    echo "[+]/etc/grub.conf文件权限为600,符合规范" | $saveCheckResult
else
    echo "[!]/etc/grub.conf文件权限为""${grubconf:1:9}","不符合规范,权限应改为600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.8]正在检查xinetd.conf文件权限[/etc/xinetd.conf]:" | $saveCheckResult
xinetdconf=$(ls -l /etc/xinetd.conf | awk '{print $1}')
if [ "${xinetdconf:1:9}" = "-rw-------" ]; then
    echo "[+]/etc/xinetd.conf文件权限为600,符合规范" | $saveCheckResult
else
    echo "[!]/etc/xinetd.conf文件权限为""${xinetdconf:1:9}","不符合规范,权限应改为600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.9]正在检查lilo.conf文件权限[/etc/lilo.conf ]:" | $saveCheckResult
if [ -f /etc/lilo.conf ];then
liloconf=$(ls -l /etc/lilo.conf | awk '{print $1}')
	if [ "${liloconf:1:9}" = "-rw-------" ];then
		echo "/etc/lilo.conf文件权限为600,符合要求" | $saveCheckResult
	else
		echo "/etc/lilo.conf文件权限不为600,不符合要求,建议设置权限为600" | $saveCheckResult
	fi
else
	echo "/etc/lilo.conf文件夹不存在,不检查,符合要求"
fi
printf "\n" | $saveCheckResult


echo "[9.13.10]正在检查limits.conf文件权限[/etc/security/limits.conf]:" | $saveCheckResult
cat /etc/security/limits.conf | grep -v ^# | grep core
if [ $? -eq 0 ];then
	soft=`cat /etc/security/limits.conf | grep -v ^# | grep core | awk -F ' ' '{print $2}'`
	for i in $soft
	do
		if [ $i = "soft" ];then
			echo "* soft core 0 已经设置,符合要求" | $saveCheckResult
		fi
		if [ $i = "hard" ];then
			echo "* hard core 0 已经设置,符合要求" | $saveCheckResult
		fi
	done
else 
	echo "没有设置core,建议在/etc/security/limits.conf中添加* soft core 0和* hard core 0"  | $saveCheckResult
fi


echo "[9.14]正在检查登陆相关文件属性:" | $saveCheckResult
echo "[9.14.1]正在检查passwd文件属性:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=`lsattr /etc/passwd | cut -c $x`
	if [ $apend = "i" ];then
		echo "/etc/passwd文件存在i安全属性,符合要求" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/passwd文件存在a安全属性" | $saveCheckResult
		flag=1
	fi
done

if [ $flag = 0 ];then
	echo "/etc/passwd文件不存在相关安全属性,建议使用chattr +i或chattr +a防止/etc/passwd被删除或修改" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# 当一个文件或目录具有 "a" 属性时，只有特定的用户或具有超级用户权限的用户才能够修改、重命名或删除这个文件。
# 其他普通用户在写入文件时只能进行数据的追加操作，而无法对现有数据进行修改或删除。
# 属性 "i" 表示文件被设置为不可修改（immutable）的权限。这意味着文件不能被更改、重命名、删除或链接。
# 具有 "i" 属性的文件对于任何用户或进程都是只读的，并且不能进行写入操作

echo "[9.14.2]正在检查shadow文件属性:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=`lsattr /etc/shadow | cut -c $x`
	if [ $apend = "i" ];then
		echo "/etc/shadow文件存在i安全属性,符合要求" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/shadow文件存在a安全属性" | $saveCheckResult
		flag=1
	fi
done
if [ $flag = 0 ];then
	echo "/etc/shadow文件不存在相关安全属性,建议使用chattr +i或chattr +a防止/etc/shadow被删除或修改" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.14.3]正在检查gshadow文件属性:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=`lsattr /etc/gshadow | cut -c $x`
	if [ $apend = "i" ];then
		echo "/etc/gshadow文件存在i安全属性,符合要求" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/gshadow文件存在a安全属性" | $saveCheckResult
		flag=1
	fi
done
if [ $flag = 0 ];then
	echo "/etc/gshadow文件不存在相关安全属性,建议使用chattr +i或chattr +a防止/etc/gshadow被删除或修改" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.14.4]正在检查group文件属性:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=`lsattr /etc/group | cut -c $x`
	if [ $apend = "i" ];then
		echo "/etc/group文件存在i安全属性,符合要求" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/group文件存在a安全属性" | $saveCheckResult
		flag=1
	fi
done
if [ $flag = 0 ];then
	echo "/etc/group文件不存在相关安全属性,建议使用chattr +i或chattr +a防止/etc/group被删除或修改" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.15]正在检测useradd和userdel时间属性:" | $saveCheckResult
echo "Access:访问时间,每次访问文件时都会更新这个时间,如使用more、cat" | $saveCheckResult
echo "Modify:修改时间,文件内容改变会导致该时间更新" | $saveCheckResult
echo "Change:改变时间,文件属性变化会导致该时间更新,当文件修改时也会导致该时间更新;但是改变文件的属性,如读写权限时只会导致该时间更新，不会导致修改时间更新" | $saveCheckResult
echo "[9.15.1]正在检查useradd时间属性[/usr/sbin/useradd ]:" | $saveCheckResult
echo "[+]useradd时间属性:" | $saveCheckResult
stat /usr/sbin/useradd | egrep "Access|Modify|Change" | grep -v '(' | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[9.15.2]正在检查userdel时间属性[/usr/sbin/userdel]:" | $saveCheckResult
echo "[+]userdel时间属性:" | $saveCheckResult
stat /usr/sbin/userdel | egrep "Access|Modify|Change" | grep -v '(' | $saveCheckResult
printf "\n" | $saveCheckResult


echo "|----------------------------------------------------------------|" | $saveCheckResult
echo "==========10.策略配置检查(基线检查)==========" | $saveCheckResult
echo "[10.1]正在检查远程允许策略:" | $saveCheckResult
echo "[10.1.1]正在检查远程允许策略[/etc/hosts.allow]:" | $saveCheckResult
hostsallow=$(more /etc/hosts.allow | grep -v '#')
if [ -n "$hostsallow" ];then
	(echo "[!]允许以下IP远程访问:" && echo "$hostsallow") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]hosts.allow文件未发现允许远程访问地址" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.1.2]正在检查远程拒绝策略[/etc/hosts.deny]:" | $saveCheckResult
hostsdeny=$(more /etc/hosts.deny | grep -v '#')
if [ -n "$hostsdeny" ];then
	(echo "[!]拒绝以下IP远程访问:" && echo "$hostsdeny") | $saveCheckResult
else
	echo "[+]hosts.deny文件未发现拒绝远程访问地址" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.2]正在检查密码有效期策略:" | $saveCheckResult
echo "[10.2.1]正在检查密码有效期策略[/etc/login.defs ]:" | $saveCheckResult
(echo "[+]密码有效期策略如下:" && more /etc/login.defs | grep -v "#" | grep PASS ) | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[10.2.1.1]正在进行口令生存周期检查:" | $saveCheckResult
passmax=$(cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}')
if [ $passmax -le 90 -a $passmax -gt 0 ];then
	echo "[+]口令生存周期为${passmax}天,符合要求" | $saveCheckResult
else
	echo "[!]口令生存周期为${passmax}天,不符合要求,建议设置为0-90天" | $saveCheckResult
fi

echo "[10.2.1.2]正在进行口令更改最小时间间隔检查:" | $saveCheckResult
passmin=$(cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}')
if [ $passmin -ge 6 ];then
	echo "[+]口令更改最小时间间隔为${passmin}天,符合要求" | $saveCheckResult
else
	echo "[!]口令更改最小时间间隔为${passmin}天,不符合要求,建议设置不小于6天" | $saveCheckResult
fi

echo "[10.2.1.3]正在进行口令最小长度检查:" | $saveCheckResult
passlen=$(cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}')
if [ $passlen -ge 8 ];then
	echo "[+]口令最小长度为${passlen},符合要求" | $saveCheckResult
else
	echo "[!]口令最小长度为${passlen},不符合要求,建议设置最小长度大于等于8" | $saveCheckResult
fi

echo "[10.2.1.4]正在进行口令过期警告时间天数检查:" | $saveCheckResult
passage=$(cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}')
if [ $passage -ge 30 -a $passage -lt $passmax ];then
	echo "[+]口令过期警告时间天数为${passage},符合要求" | $saveCheckResult
else
	echo "[!]口令过期警告时间天数为${passage},不符合要求,建议设置大于等于30并小于口令生存周期" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.2.2]正在检查密码复杂度策略[/etc/pam.d/system-auth]:" | $saveCheckResult
(echo "[+]密码复杂度策略如下:" && more /etc/pam.d/system-auth | grep -v "#") | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[10.2.3]正在检查密码已过期用户[/etc/shadow]:" | $saveCheckResult
NOW=$(date "+%s")
day=$((${NOW}/86400))
passwdexpired=$(grep -v ":[\!\*x]([\*\!])?:" /etc/shadow | awk -v today=${day} -F: '{ if (($5!="") && (today>$3+$5)) { print $1 }}')
if [ -n "$passwdexpired" ];then
	(echo "[+]以下用户的密码已过期:" && echo "$passwdexpired")  | $saveCheckResult
else
	echo "[+]未发现密码已过期用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.2.4]正在检查账号超时锁定策略[/etc/profile]:" | $saveCheckResult
account_timeout=`cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}'` 
if [ "$account_timeout" != ""  ];then
	TMOUT=`cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}'`
	if [ $TMOUT -le 600 -a $TMOUT -ge 10 ];then
		echo "[+]账号超时时间为${TMOUT}秒,符合要求" | $saveCheckResult
	else
		echo "[!]账号超时时间为${TMOUT}秒,不符合要求,建议设置小于600秒" | $saveCheckResult
fi
else
	echo "[!]账号超时未锁定,不符合要求,建议设置小于600秒" | $saveCheckResult 
fi
printf "\n" | $saveCheckResult


echo "[10.2.5]正在检查grub密码策略[/etc/grub.conf]:" | $saveCheckResult
grubpass=$(cat /etc/grub.conf | grep password)
if [ $? -eq 0 ];then
	echo "[+]已设置grub密码,符合要求" | $saveCheckResult 
else
	echo "[!]未设置grub密码,不符合要求,建议设置grub密码" | $saveCheckResult 
fi
printf "\n" | $saveCheckResult


echo "[10.2.6]正在检查lilo密码策略[/etc/lilo.conf]:" | $saveCheckResult
if [ -f  /etc/lilo.conf ];then
	lilopass=$(cat /etc/lilo.conf | grep password 2> /dev/null)
	if [ $? -eq 0 ];then
		echo "[+]已设置lilo密码,符合要求" | $saveCheckResult
	else
		echo "[!]未设置lilo密码,不符合要求,建议设置lilo密码" | $saveCheckResult
	fi
else
	echo "[+]未发现/etc/lilo.conf文件" | $saveCheckResult
fi


echo "[10.3]正在检查selinux策略:" | $saveCheckResult
echo "[10.3.1]正在检查selinux策略:" | $saveCheckResult
(echo "selinux策略如下:" && egrep -v '#|^$' /etc/sysconfig/selinux ) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[10.4]正在检查SSHD配置策略:" | $saveCheckResult
echo "[10.4.1]正在检查sshd配置[/etc/ssh/sshd_config]:" | $saveCheckResult
sshdconfig=$(more /etc/ssh/sshd_config | egrep -v "#|^$")
if [ -n "$sshdconfig" ];then
	(echo "[+]sshd配置文件如下:" && echo "$sshdconfig") | $saveCheckResult
else
	echo "[!]未发现sshd配置文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.4.2]正在检查是否允许SSH空口令登录[/etc/ssh/sshd_config]:" | $saveCheckResult
emptypasswd=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
nopasswd=`gawk -F: '($2=="") {print $1}' /etc/shadow`
if [ -n "$emptypasswd" ];then
	echo "[!]允许空口令登录,请注意!"
	if [ -n "$nopasswd" ];then
		(echo "[!]以下用户空口令:" && echo "$nopasswd") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]但未发现空口令用户" | $saveCheckResult
	fi
else
	echo "[+]不允许空口令用户登录" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.4.3]正在检查是否允许SSH远程root登录[/etc/ssh/sshd_config]:" | $saveCheckResult
cat /etc/ssh/sshd_config | grep -v ^# |grep "PermitRootLogin no"
if [ $? -eq 0 ];then
	echo "[+]root不允许登陆,符合要求" | $saveCheckResult
else
	echo "[!]允许root远程登陆,不符合要求,建议/etc/ssh/sshd_config添加PermitRootLogin no" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.4.4]正在检查SSH协议版本[/etc/ssh/sshd_config]:" | $saveCheckResult
echo "[说明]需要详细的SSH版本信息另行检查,防止SSH版本过低,存在漏洞" | $saveCheckResult
protocolver=$(more /etc/ssh/sshd_config | grep -v ^$ | grep Protocol | awk '{print $2}')
if [ "$protocolver" -eq "2" ];then
	echo "[+]openssh使用ssh2协议,符合要求" 
else
	echo "[!]openssh未ssh2协议,不符合要求"
fi


echo "[10.5]正在检查SNMP配置策略:" | $saveCheckResult
echo "[10.5.1]正在检查nis配置[/etc/nsswitch.conf]:" | $saveCheckResult
nisconfig=$(more /etc/nsswitch.conf | egrep -v '#|^$')
if [ -n "$nisconfig" ];then
	(echo "[+]NIS服务配置如下:" && echo "$nisconfig") | $saveCheckResult
else
	echo "[+]未发现NIS服务配置" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.6]正在检查nginx配置策略:" | $saveCheckResult
echo "[10.6.1]正在检查Nginx配置文件[nginx/conf/nginx.conf]:" | $saveCheckResult
nginx=$(whereis nginx | awk -F: '{print $2}')
if [ -n "$nginx" ];then
	(echo "[+]Nginx配置文件如下:" && more $nginx/conf/nginx.conf) | $saveCheckResult
else
	echo "[+]未发现Nginx服务" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.6.2]正在检查Nginx端口转发配置[nginx/conf/nginx.conf]:" | $saveCheckResult
nginx=$(whereis nginx | awk -F: '{print $2}')
nginxportconf=$(more $nginx/conf/nginx.conf | egrep "listen|server |server_name |upstream|proxy_pass|location"| grep -v \#)
if [ -n "$nginxportconf" ];then
	(echo "[+]可能存在端口转发的情况,请人工分析:" && echo "$nginxportconf") | $saveCheckResult
else
	echo "[+]未发现端口转发配置" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.7]正在检查SNMP配置策略:" | $saveCheckResult
echo "[10.7.1]正在检查SNMP配置[/etc/snmp/snmpd.conf]:." | $saveCheckResult
if [ -f /etc/snmp/snmpd.conf ];then
	public=$(cat /etc/snmp/snmpd.conf | grep public | grep -v ^# | awk '{print $4}')
	private=$(cat /etc/snmp/snmpd.conf | grep private | grep -v ^# | awk '{print $4}')
	if [ "$public" -eq "public" ];then
		echo "发现snmp服务存在默认团体名public,不符合要求" | $saveCheckResult
	fi
	if [ "$private" -eq "private" ];then
		echo "发现snmp服务存在默认团体名private,不符合要求" | $saveCheckResult
	fi
else
	echo "snmp服务配置文件不存在,可能没有运行snmp服务" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "防火墙策略基线在[2.6]节,不在赘述!" | $saveCheckResult
echo "配置策略检查(基线检查)结束!" | $saveCheckResult
echo "|^----------------------------------------------------------------^|" | $saveCheckResult



echo "==========11.历史命令==========" | $saveCheckResult
echo "[11.1]正在检查历史命令[/root/.bash_history]:" | $saveCheckResult
echo "[注意]如果历史命令被清除,请人工使用history命令上机检查(看历史命令序号是否断档)" | $saveCheckResult
history=$(more /root/.bash_history)
if [ -n "$history" ];then
	(echo "[+]操作系统历史命令如下:" && echo "$history") | $saveCheckResult
else
	echo "[!]未发现历史命令,请检查是否记录及已被清除" | $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.2]正在检查历史是否下载过脚本文件[/root/.bash_history]:" | $saveCheckResult
scripts=$(more /root/.bash_history | grep -E "((wget|curl).*\.(sh|pl|py|exe)$)" | grep -v grep)
if [ -n "$scripts" ];then
	(echo "[!]该服务器下载过脚本以下脚本：" && echo "$scripts") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]该服务器未下载过脚本文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.3]正在检查历史是否增加过账号[history]:" | $saveCheckResult
addusers=$(history | egrep "(useradd|groupadd)" | grep -v grep)
if [ -n "$addusers" ];then
	(echo "[!]该服务器增加过以下账号:" && echo "$addusers") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]该服务器未增加过账号" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.4]正在检查历史是否删除过账号[history]:" | $saveCheckResult
delusers=$(history | egrep "(userdel|groupdel)" | grep -v grep)
if [ -n "$delusers" ];then
	(echo "[!]该服务器删除过以下账号:" && echo "$delusers") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]该服务器未删除过账号" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.5]正在检查历史可疑黑客命令:" | $saveCheckResult
echo "[说明]匹配规则可自行维护,列表如下:id|whoami|whois|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|*proxy|msfconsole|msf|frp*|xray|*scan|mv|wget|python*|yum|apt-get" | $saveCheckResult
danger_histroy=$(history | grep -E "(id|whoami|whois|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|*proxy|msfconsole|msf|frp*|xray|*scan|mv|wget|python*|yum|apt-get)" | grep -v grep)
if [ -n "$danger_histroy" ];then
	(echo "[!]发现可疑历史命令" && echo "$danger_histroy") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现可疑历史命令" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.6]正在检查历史命令中CRT下载记录[history | grep sz]:" | $saveCheckResult
uploadfiles=$(history | grep sz | grep -v grep | awk '{print $3}')
if [ -n "$uploadfiles" ];then
	(echo "[!]通过历史日志发现本地主机下载过以下文件:" && echo "$uploadfiles") | $saveCheckResult
else
	echo "[+]通过历史日志未发现本地主机下载过文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.7]正在检查历史命令中主机下载记录[history | grep yum]:" | $saveCheckResult
yum_history=$(history | grep -E "(wget|curl|python*|yum|apt-get|apt)" | grep -v grep )
if [ -n "$yum_history" ];then
	(echo "[!]通过历史日志发现主机下载命令如下:" && echo "$yum_history") | $saveDangerResult | $saveCheckResult
else
	echo "[+]通过历史日志未发现主机下载文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.8]正在检查历史命令中是否有关闭命令历史记录功能[set +o history]:" | $saveCheckResult
echo "[说明]set +o history 是关闭命令历史记录功能,可以通过history命令查看,set -o history是重新打开历史命令记录" | $saveCheckResult
clearhistory=$(history | grep "set +o history" | grep -v grep)
if [ -n "$clearhistory" ];then
	(echo "[!]通过历史日志发现关闭命令历史记录功能命令如下:" && echo "$clearhistory") | $saveDangerResult | $saveCheckResult
else
	echo "[+]通过历史日志未发现关闭命令历史记录功能命令" | $saveCheckResult
fi



echo "[11.2]正在检查数据库操作历史命令[/root/.mysql_history]:" | $saveCheckResult
mysql_history=$(more /root/.mysql_history)
if [ -n "$mysql_history" ];then
	(echo "[+]数据库操作历史命令如下:" && echo "$mysql_history") | $saveCheckResult
else
	echo "[+]未发现数据库历史命令" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========12.可疑文件检查==========" | $saveCheckResult
echo "[12.1]正在检查脚本文件[py|sh|per|pl|exe]:" | $saveCheckResult
echo "[注意]不检查/usr,/etc,/var目录,需要检查请自行修改脚本,脚本需要人工判定是否有害" | $saveCheckResult
scripts=$(find / *.* | egrep "\.(py|sh|per|pl|exe)$" | egrep -v "/usr|/etc|/var")
if [ -n "scripts" ];then
	(echo "[!]发现以下脚本文件,请注意!" && echo "$scripts") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现脚本文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

# 可以放一个rkhunter的tar包,解压后直接运行即可
echo "[12.2]正在检查webshell文件:" | $saveCheckResult
echo "webshell这一块因为技术难度相对较高,并且已有专业的工具,目前这一块建议使用专门的安全检查工具来实现" | $saveCheckResult
echo "请使用rkhunter工具来检查系统层的恶意文件,下载地址:http://rkhunter.sourceforge.net" | $saveCheckResult


echo "[12.3]正在检查最近24小时内变动的敏感文件[py|sh|per|pl|php|asp|jsp|exe]:" | $saveCheckResult
echo "[说明]find / -mtime -1 -type f " | $saveCheckResult
(find / -mtime -1 -type f | grep -E "\.(py|sh|per|pl|php|asp|jsp|exe)$") |  $saveDangerResult | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[12.4]正在检查最近24小时内变动的所有文件:" | $saveCheckResult
#查看最近24小时内有改变的文件类型文件，排除内容目录/proc /dev /sys  
echo "[注意]不检查/proc,/dev,/sys,/run目录,需要检查请自行修改脚本,脚本需要人工判定是否有害" | $saveCheckResult
(find / ! \( -path "/proc/*" -o -path "/dev/*" -o -path "/sys/*" -o -path "/run/*" \) -type f -mtime -1) $saveDangerResult | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[12.5]正在检查全盘是否存在黑客工具[./checkrules/hackertoolslist.txt]:" | $saveCheckResult
# hacker_tools_list="nc sqlmap nmap xray beef nikto john ettercap backdoor *proxy msfconsole msf *scan nuclei *brute* gtfo Titan zgrab frp* lcx *reGeorg nps spp suo5 sshuttle v2ray"
# 从 hacker_tools_list 列表中取出一个工具名然后全盘搜索
# hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
echo "[说明]定义黑客工具列表文件hackertoolslist.txt,全盘搜索该列表中的工具名,如果存在则告警(工具文件可自行维护)" | $saveCheckResult
for hacker_tool in `cat ./checkrules/hackertoolslist.txt`
do
	findhackertool=$(find / -name $hacker_tool 2>/dev/null)
	if [ -n "$findhackertool" ];then
		(echo "[!]发现全盘存在可疑黑客工具:" && echo "$findhackertool") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]未发现全盘存在可疑黑可工具:$hacker_tool" | $saveCheckResult
	fi
	printf "\n" | $saveCheckResult
done


echo "==========13.系统文件完整性校验==========" | $saveCheckResult
# 通过取出系统关键文件的MD5值,一方面可以直接将这些关键文件的MD5值通过威胁情报平台进行查询
# 另一方面,使用该软件进行多次检查时会将相应的MD5值进行对比,若和上次不一样,则会进行提示
# 用来验证文件是否被篡改
echo "[13.1]正在采集系统关键文件MD5:" | $saveCheckResult
echo "[说明]md5查询威胁情报或者用来防止二进制文件篡改(需要人工比对md5值)" | $saveCheckResult
echo "[注]MD5值文件导出位置:${check_file}/sysfile_md5.txt" | $saveCheckResult
file="${check_file}/sysfile_md5.txt"
if [ -e "$file" ]; then 
	md5sum -c "$file" 2>&1; 
else
	md5sum /usr/bin/awk >> $file
	md5sum /usr/bin/basename >> $file
	md5sum /usr/bin/bash >> $file
	md5sum /usr/bin/cat >> $file
	md5sum /usr/bin/chattr >> $file
	md5sum /usr/bin/chmod >> $file
	md5sum /usr/bin/chown >> $file
	md5sum /usr/bin/cp >> $file
	md5sum /usr/bin/csh >> $file
	md5sum /usr/bin/curl >> $file
	md5sum /usr/bin/cut >> $file
	md5sum /usr/bin/date >> $file
	md5sum /usr/bin/df >> $file
	md5sum /usr/bin/diff >> $file
	md5sum /usr/bin/dirname >> $file
	md5sum /usr/bin/dmesg >> $file
	md5sum /usr/bin/du >> $file
	md5sum /usr/bin/echo >> $file
	md5sum /usr/bin/ed >> $file
	md5sum /usr/bin/egrep >> $file
	md5sum /usr/bin/env >> $file
	md5sum /usr/bin/fgrep >> $file
	md5sum /usr/bin/file >> $file
	md5sum /usr/bin/find >> $file
	md5sum /usr/bin/gawk >> $file
	md5sum /usr/bin/GET >> $file
	md5sum /usr/bin/grep >> $file
	md5sum /usr/bin/groups >> $file
	md5sum /usr/bin/head >> $file
	md5sum /usr/bin/id >> $file
	md5sum /usr/bin/ipcs >> $file
	md5sum /usr/bin/kill >> $file
	md5sum /usr/bin/killall >> $file
	md5sum /usr/bin/kmod >> $file
	md5sum /usr/bin/last >> $file
	md5sum /usr/bin/lastlog >> $file
	md5sum /usr/bin/ldd >> $file
	md5sum /usr/bin/less >> $file
	md5sum /usr/bin/locate >> $file
	md5sum /usr/bin/logger >> $file
	md5sum /usr/bin/login >> $file
	md5sum /usr/bin/ls >> $file
	md5sum /usr/bin/lsattr >> $file
	md5sum /usr/bin/lynx >> $file
	md5sum /usr/bin/mail >> $file
	md5sum /usr/bin/mailx >> $file
	md5sum /usr/bin/md5sum >> $file
	md5sum /usr/bin/mktemp >> $file
	md5sum /usr/bin/more >> $file
	md5sum /usr/bin/mount >> $file
	md5sum /usr/bin/mv >> $file
	md5sum /usr/bin/netstat >> $file
	md5sum /usr/bin/newgrp >> $file
	md5sum /usr/bin/numfmt >> $file
	md5sum /usr/bin/passwd >> $file
	md5sum /usr/bin/perl >> $file
	md5sum /usr/bin/pgrep >> $file
	md5sum /usr/bin/ping >> $file
	md5sum /usr/bin/pkill >> $file
	md5sum /usr/bin/ps >> $file
	md5sum /usr/bin/pstree >> $file
	md5sum /usr/bin/pwd >> $file
	md5sum /usr/bin/readlink >> $file
	md5sum /usr/bin/rpm >> $file
	md5sum /usr/bin/runcon >> $file
	md5sum /usr/bin/sed >> $file
	md5sum /usr/bin/sh >> $file
	md5sum /usr/bin/sha1sum >> $file
	md5sum /usr/bin/sha224sum >> $file
	md5sum /usr/bin/sha256sum >> $file
	md5sum /usr/bin/sha384sum >> $file
	md5sum /usr/bin/sha512sum >> $file
	md5sum /usr/bin/size >> $file
	md5sum /usr/bin/sort >> $file
	md5sum /usr/bin/ssh >> $file
	md5sum /usr/bin/stat >> $file
	md5sum /usr/bin/strace >> $file
	md5sum /usr/bin/strings >> $file
	md5sum /usr/bin/su >> $file
	md5sum /usr/bin/sudo >> $file
	md5sum /usr/bin/systemctl >> $file
	md5sum /usr/bin/tail >> $file
	md5sum /usr/bin/tcsh >> $file
	md5sum /usr/bin/telnet >> $file
	md5sum /usr/bin/test >> $file
	md5sum /usr/bin/top >> $file
	md5sum /usr/bin/touch >> $file
	md5sum /usr/bin/tr >> $file
	md5sum /usr/bin/uname >> $file
	md5sum /usr/bin/uniq >> $file
	md5sum /usr/bin/users >> $file
	md5sum /usr/bin/vmstat >> $file
	md5sum /usr/bin/w >> $file
	md5sum /usr/bin/watch >> $file
	md5sum /usr/bin/wc >> $file
	md5sum /usr/bin/wget >> $file
	md5sum /usr/bin/whatis >> $file
	md5sum /usr/bin/whereis >> $file
	md5sum /usr/bin/which >> $file
	md5sum /usr/bin/who >> $file
	md5sum /usr/bin/whoami >> $file
	md5sum /usr/lib/systemd/s >> $file
	md5sum /usr/local/bin/rkh >> $file
	md5sum /usr/sbin/adduser >> $file
	md5sum /usr/sbin/chkconfi >> $file
	md5sum /usr/sbin/chroot >> $file
	md5sum /usr/sbin/depmod >> $file
	md5sum /usr/sbin/fsck >> $file
	md5sum /usr/sbin/fuser >> $file
	md5sum /usr/sbin/groupadd >> $file
	md5sum /usr/sbin/groupdel >> $file
	md5sum /usr/sbin/groupmod >> $file
	md5sum /usr/sbin/grpck >> $file
	md5sum /usr/sbin/ifconfig >> $file
	md5sum /usr/sbin/ifdown >> $file
	md5sum /usr/sbin/ifup >> $file
	md5sum /usr/sbin/init >> $file
	md5sum /usr/sbin/insmod >> $file
	md5sum /usr/sbin/ip >> $file
	md5sum /usr/sbin/lsmod >> $file
	md5sum /usr/sbin/lsof >> $file
	md5sum /usr/sbin/modinfo >> $file
	md5sum /usr/sbin/modprobe >> $file
	md5sum /usr/sbin/nologin >> $file
	md5sum /usr/sbin/pwck >> $file
	md5sum /usr/sbin/rmmod >> $file
	md5sum /usr/sbin/route >> $file
	md5sum /usr/sbin/rsyslogd >> $file
	md5sum /usr/sbin/runlevel >> $file
	md5sum /usr/sbin/sestatus >> $file
	md5sum /usr/sbin/sshd >> $file
	md5sum /usr/sbin/sulogin >> $file
	md5sum /usr/sbin/sysctl >> $file
	md5sum /usr/sbin/tcpd >> $file
	md5sum /usr/sbin/useradd >> $file
	md5sum /usr/sbin/userdel >> $file
	md5sum /usr/sbin/usermod >> $file
	md5sum /usr/sbin/vipw >> $file
fi
printf "\n" | $saveCheckResult


echo "==========14.系统日志分析==========" | $saveCheckResult
echo "[14.1]日志配置与打包:" | $saveCheckResult
echo "[14.1.1]正在检查rsyslog日志配置[/etc/rsyslog.conf]:" | $saveCheckResult
logconf=$(more /etc/rsyslog.conf | egrep -v "#|^$")
if [ -n "$logconf" ];then
	(echo "[+]日志配置如下:" && echo "$logconf") | $saveCheckResult
else
	echo "[!]未发现日志配置文件" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.1.2]正在分析日志文件是否存在:[/var/log/]" | $saveCheckResult
logs=$(ls -l /var/log/)
if [ -n "$logs" ];then
	echo "[+]日志文件存在" | $saveCheckResult
else
	echo "[!]日志文件不存在,请分析是否被清除!" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.1.3]正在分析日志审核是否开启[service auditd status]:" | $saveCheckResult
service auditd status | grep running
if [ $? -eq 0 ];then
	echo "[+]系统日志审核功能已开启,符合要求" | $saveCheckResult
else
	echo "[!]系统日志审核功能已关闭,不符合要求,建议开启日志审核。可使用以下命令开启:service auditd start" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.1.4]打包/var/log日志[脚本最后统一打包]" | $saveCheckResult


echo "[14.2]正在分析secure日志:" | $saveCheckResult
echo "[14.2.1]正在检查日志中登录成功记录[/var/log/secure*]:" | $saveCheckResult
loginsuccess=$(more /var/log/secure* | grep "Accepted password" | awk '{print $1,$2,$3,$9,$11}')
if [ -n "$loginsuccess" ];then
	(echo "[+]日志中分析到以下用户登录成功记录:" && echo "$loginsuccess")  | $saveCheckResult
	(echo "[+]登录成功的IP及次数如下:" && grep "Accepted " /var/log/secure* | awk '{print $11}' | sort -nr | uniq -c )  | $saveCheckResult
	(echo "[+]登录成功的用户及次数如下:" && grep "Accepted" /var/log/secure* | awk '{print $9}' | sort -nr | uniq -c )  | $saveCheckResult
else
	echo "[+]日志中未发现成功登录的情况" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.2]检查日志中登录失败记录(SSH爆破)[/var/log/secure*]:" | $saveCheckResult
loginfailed=$(more /var/log/secure* | grep "Failed password" | awk '{print $1,$2,$3,$9,$11}')
if [ -n "$loginfailed" ];then
	(echo "[!]日志中发现以下登录失败记录:" && echo "$loginfailed") | $saveDangerResult  | $saveCheckResult
	(echo "[!]登录失败的IP及次数如下(疑似SSH爆破):" && grep "Failed password" /var/log/secure* | awk '{print $11}' | sort -nr | uniq -c) | $saveDangerResult  | $saveCheckResult
	(echo "[!]登录失败的用户及次数如下(疑似SSH爆破):" && grep "Failed password" /var/log/secure* | awk '{print $9}' | sort -nr | uniq -c) | $saveDangerResult  | $saveCheckResult
	(echo "[!]SSH爆破用户名的字典信息如下:" && grep "Failed password" /var/log/secure* | perl -e 'while($_=<>){ /for(.*?) from/; print "$1\n";}'|uniq -c|sort -nr) | $saveDangerResult  | $saveCheckResult
else
	echo "[+]日志中未发现登录失败的情况" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.3]正在检查本机窗口登录情况[/var/log/secure*]:" | $saveCheckResult
systemlogin=$(more /var/log/secure* | grep -E "sshd:session.*session opened" | awk '{print $1,$2,$3,$11}')
if [ -n "$systemlogin" ];then
	(echo "[+]本机登录情况:" && echo "$systemlogin") | $saveCheckResult
	(echo "[+]本机登录账号及次数如下:" && more /var/log/secure* | grep -E "sshd:session.*session opened" | awk '{print $11}' | sort -nr | uniq -c) | $saveCheckResult
else
	echo "[!]未发现在本机登录退出情况,请注意!" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.4]正在检查新增用户[/var/log/secure*]:" | $saveCheckResult
newusers=$(more /var/log/secure* | grep "new user"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}')
if [ -n "$newusers" ];then
	(echo "[!]日志中发现新增用户:" && echo "$newusers") |  $saveDangerResult | $saveCheckResult
	(echo "[+]新增用户账号及次数如下:" && more /var/log/secure* | grep "new user" | awk '{print $8}' | awk -F '[=,]' '{print $2}' | sort | uniq -c) | $saveCheckResult
else
	echo "[+]日志中未发现新增加用户" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.5]正在检查新增用户组[/var/log/secure*]:" | $saveCheckResult
newgoup=$(more /var/log/secure* | grep "new group"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}')
if [ -n "$newgoup" ];then
	(echo "[!]日志中发现新增用户组:" && echo "$newgoup") |  $saveDangerResult | $saveCheckResult
	(echo "[+]新增用户组及次数如下:" && more /var/log/secure* | grep "new group" | awk '{print $8}' | awk -F '[=,]' '{print $2}' | sort | uniq -c) | $saveCheckResult
else
	echo "[+]日志中未发现新增加用户组" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.3]正在分析message日志:" | $saveCheckResult
#下面命令仅显示传输的文件名,并会将相同文件名的去重
#more /var/log/message* | grep "ZMODEM:.*BPS" | awk -F '[]/]' '{print $0}' | sort | uniq
echo "[14.3.1]正在检查传输文件[/var/log/message*]:" | $saveCheckResult
zmodem=$(more /var/log/message* | grep "ZMODEM:.*BPS")
if [ -n "$zmodem" ];then
	(echo "[!]传输文件情况:" && echo "$zmodem") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]日志中未发现传输文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.3.2]正在检查日志中使用DNS服务器的情况[/var/log/message*]:" | $saveCheckResult
dns_history=$(more /var/log/messages* | grep "using nameserver" | awk '{print $NF}' | awk -F# '{print $1}' | sort | uniq)
if [ -n "$dns_history" ];then
	(echo "[!]该服务器曾经使用以下DNS:" && echo "$dns_history") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现使用DNS服务器" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.4]正在分析ron日志:" | $saveCheckResult
echo "[14.4.1]正在分析定时下载[/var/log/cron*]:" | $saveCheckResult
cron_download=$(more /var/log/cron* | grep "wget|curl")
if [ -n "$cron_download" ];then
	(echo "[!]定时下载情况:" && echo "$cron_download") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现定时下载情况" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.4.2]正在分析定时执行脚本[/var/log/cron*]:" | $saveCheckResult
cron_shell=$(more /var/log/cron* | grep -E "\.py$|\.sh$|\.pl$|\.exe$") 
if [ -n "$cron_shell" ];then
	(echo "[!]发现定时执行脚本:" && echo "$cron_download") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现定时下载脚本" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# ubuntu 是 more /var/log/apt/* 【后续补充】
echo "[14.5]正在分析yum日志:" | $saveCheckResult
echo "[14.5.1]正在分析使用yum下载软件情况[/var/log/yum*]:" | $saveCheckResult
yum_install=$(more /var/log/yum* | grep Installed | awk '{print $NF}' | sort | uniq)
if [ -n "$yum_install" ];then
	(echo "[+]曾使用yum下载以下软件:"  && echo "$yum_install") | $saveCheckResult
else
	echo "[+]未使用yum下载过软件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.5.2]正在分析使用yum下载脚本文件[/var/log/yum*]:" | $saveCheckResult
yum_installscripts=$(more /var/log/yum* | grep Installed | grep -E "(\.sh$\.py$|\.pl$|\.exe$)" | awk '{print $NF}' | sort | uniq)
if [ -n "$yum_installscripts" ];then
	(echo "[!]曾使用yum下载以下脚本文件:"  && echo "$yum_installscripts") | $saveDangerResult | $saveCheckResult
else
	echo "[+]未使用yum下载过脚本文件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.5.3]正在检查使用yum卸载软件情况[/var/log/yum*]:" | $saveCheckResult
yum_erased=$(more /var/log/yum* | grep Erased)
if [ -n "$yum_erased" ];then
	(echo "[+]使用yum曾卸载以下软件:" && echo "$yum_erased")  | $saveCheckResult
else
	echo "[+]未使用yum卸载过软件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.5.4]正在检查使用yum安装的可疑工具[./checkrules/hackertoolslist.txt]:" | $saveCheckResult
# 从文件中取出一个工具名然后匹配
hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
for hacker_tools in $hacker_tools_list;do
	hacker_tools=$(more /var/log/yum* | awk -F: '{print $NF}' | awk -F '[-]' '{print }' | sort | uniq | grep -E "$hacker_tools")
	if [ -n "$hacker_tools" ];then
		(echo "[!]发现使用yum下载过以下可疑软件:"&& echo "$hacker_tools") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]未发现使用yum下载过可疑软件" | $saveCheckResult
	fi
done
printf "\n" | $saveCheckResult


echo "[14.6]正在分析dmesg日志[dmesg]:" | $saveCheckResult
echo "[14.6.1]正在查看内核自检日志:" | $saveCheckResult
dmesg=$(dmesg)
if [ $? -eq 0 ];then
	(echo "[+]日志自检日志如下：" && "$dmesg" ) | $saveCheckResult
else
	echo "[+]未发现内核自检日志" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.7]正在分析btmp日志[lastb]:" | $saveCheckResult
echo "[16.7.1]正在分析错误登录日志:" | $saveCheckResult
lastb=$(lastb)
if [ -n "$lastb" ];then
	(echo "[+]错误登录日志如下:" && echo "$lastb") | $saveCheckResult
else
	echo "[+]未发现错误登录日志" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.8]正在分析lastlog日志[lastlog]:" | $saveCheckResult
echo "[14.8.1]正在分析所有用户最后一次登录日志:" | $saveCheckResult
lastlog=$(lastlog)
if [ -n "$lastlog" ];then
	(echo "[+]所有用户最后一次登录日志如下:" && echo "$lastlog") | $saveCheckResult
else
	echo "[+]未发现所有用户最后一次登录日志" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.9]正在分析wtmp日志:" | $saveCheckResult
echo "[14.9.1]正在检查历史上登录到本机的用户:" | $saveCheckResult
lasts=$(last | grep pts | grep -vw :0)
if [ -n "$lasts" ];then
	(echo "[+]历史上登录到本机的用户如下:" && echo "$lasts") | $saveCheckResult
else
	echo "[+]未发现历史上登录到本机的用户信息" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.10]正在分析journalctl日志:" | $saveCheckResult
# 检查最近24小时内的journalctl日志
echo "[14.10.1]正在检查最近24小时内的日志[journalctl --since "24 hours ago"]:" | $saveCheckResult
journalctl=$(journalctl --since "24 hours ago")
if [ -n "$journalctl" ];then
	echo "[+]journalctl最近24小时内的日志输出到[$log_file/journalctl.txt]:" | $saveCheckResult
	echo "$journalctl" >> $log_file/journalctl.txt
else
	echo "[+]journalctl未发现最近24小时内的日志" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========15.内核分析==========" | $saveCheckResult
echo "[15.1]正在检查内核信息:." | $saveCheckResult
lsmod=$(lsmod)
if [ -n "$lsmod" ];then
	(echo "[+]内核信息如下:" && echo "$lsmod") | $saveCheckResult
else
	echo "[+]未发现内核信息" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[15.2]正在检查异常内核[lsmod]:" | $saveCheckResult
danger_lsmod=$(lsmod | grep -Ev "ablk_helper|ac97_bus|acpi_power_meter|aesni_intel|ahci|ata_generic|ata_piix|auth_rpcgss|binfmt_misc|bluetooth|bnep|bnx2|bridge|cdrom|cirrus|coretemp|crc_t10dif|crc32_pclmul|crc32c_intel|crct10dif_common|crct10dif_generic|crct10dif_pclmul|cryptd|dca|dcdbas|dm_log|dm_mirror|dm_mod|dm_region_hash|drm|drm_kms_helper|drm_panel_orientation_quirks|e1000|ebtable_broute|ebtable_filter|ebtable_nat|ebtables|edac_core|ext4|fb_sys_fops|floppy|fuse|gf128mul|ghash_clmulni_intel|glue_helper|grace|i2c_algo_bit|i2c_core|i2c_piix4|i7core_edac|intel_powerclamp|ioatdma|ip_set|ip_tables|ip6_tables|ip6t_REJECT|ip6t_rpfilter|ip6table_filter|ip6table_mangle|ip6table_nat|ip6table_raw|ip6table_security|ipmi_devintf|ipmi_msghandler|ipmi_si|ipmi_ssif|ipt_MASQUERADE|ipt_REJECT|iptable_filter|iptable_mangle|iptable_nat|iptable_raw|iptable_security|iTCO_vendor_support|iTCO_wdt|jbd2|joydev|kvm|kvm_intel|libahci|libata|libcrc32c|llc|lockd|lpc_ich|lrw|mbcache|megaraid_sas|mfd_core|mgag200|Module|mptbase|mptscsih|mptspi|nf_conntrack|nf_conntrack_ipv4|nf_conntrack_ipv6|nf_defrag_ipv4|nf_defrag_ipv6|nf_nat|nf_nat_ipv4|nf_nat_ipv6|nf_nat_masquerade_ipv4|nfnetlink|nfnetlink_log|nfnetlink_queue|nfs_acl|nfsd|parport|parport_pc|pata_acpi|pcspkr|ppdev|rfkill|sch_fq_codel|scsi_transport_spi|sd_mod|serio_raw|sg|shpchp|snd|snd_ac97_codec|snd_ens1371|snd_page_alloc|snd_pcm|snd_rawmidi|snd_seq|snd_seq_device|snd_seq_midi|snd_seq_midi_event|snd_timer|soundcore|sr_mod|stp|sunrpc|syscopyarea|sysfillrect|sysimgblt|tcp_lp|ttm|tun|uvcvideo|videobuf2_core|videobuf2_memops|videobuf2_vmalloc|videodev|virtio|virtio_balloon|virtio_console|virtio_net|virtio_pci|virtio_ring|virtio_scsi|vmhgfs|vmw_balloon|vmw_vmci|vmw_vsock_vmci_transport|vmware_balloon|vmwgfx|vsock|xfs|xt_CHECKSUM|xt_conntrack|xt_state")
if [ -n "$danger_lsmod" ];then
	(echo "[!]发现可疑内核模块:" && echo "$danger_lsmod") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现可疑内核模块" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "==========16.安装软件(rpm)==========" | $saveCheckResult
echo "[16.1]正在检查rpm安装软件及版本情况[rpm -qa]:" | $saveCheckResult
software=$(rpm -qa | awk -F- '{print $1,$2}' | sort -nr -k2 | uniq)
if [ -n "$software" ];then
	(echo "[+]系统安装与版本如下:" && echo "$software") | $saveCheckResult
else
	echo "[+]系统未安装软件" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[16.2]正在检查rpm安装的可疑软件:" | $saveCheckResult
# 从文件中取出一个工具名然后匹配
hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
for hacker_tools in $hacker_tools_list;do
	danger_soft=$(rpm -qa | awk -F- '{print $1}' | sort | uniq | grep -E "$hacker_tools")
	if [ -n "$danger_soft" ];then
		(echo "[!]发现安装以下可疑软件:" && echo "$danger_soft") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]未发现安装可疑软件" | $saveCheckResult
	fi
done
printf "\n" | $saveCheckResult


echo "==========17.环境变量==========" | $saveCheckResult
echo "[17.1]正在检查环境变量[env]:" | $saveCheckResult
env=$(env)
if [ -n "$env" ];then
	(echo "[+]环境变量:" && echo "$env") | $saveCheckResult
else
	echo "[+]未发现环境变量" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "==========18.性能分析==========" | $saveCheckResult
echo "[18.1]正在检查磁盘使用情况:" | $saveCheckResult
echo "[18.1.1]正在检查磁盘使用:" | $saveCheckResult
echo "[+]磁盘使用情况如下:" && df -h  | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[18.1.2]正在检查磁盘使用是否过大[df -h]:" | $saveCheckResult
echo "[说明]使用超过70%告警" | $saveCheckResult
df=$(df -h | awk 'NR!=1{print $1,$5}' | awk -F% '{print $1}' | awk '{if ($2>70) print $1,$2}')
if [ -n "$df" ];then
	(echo "[!]硬盘空间使用过高,请注意!" && echo "$df" ) |  $saveDangerResult | $saveCheckResult
else
	echo "[+]硬盘空间足够" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[18.2]正在检查CPU用情况[more /proc/cpuinfo]:" | $saveCheckResult
echo "[18.2.1]正在检查CPU相关信息:" | $saveCheckResult
(echo "CPU硬件信息如下:" && more /proc/cpuinfo ) | $saveCheckResult
(echo "CPU使用情况如下:" && ps -aux | sort -nr -k 3 | awk  '{print $1,$2,$3,$NF}') | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.2.2]正在检查占用CPU前5资源的进程[ps -aux | sort -nr -k 3 | head -5]:" | $saveCheckResult
(echo "占用CPU资源前5进程[ps -aux | sort -nr -k 3 | head -5]:" && ps -aux | sort -nr -k 3 | head -5)  | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.2.3]正在检查占用CPU较大的进程[ps -aux | sort -nr -k 3 | head -5 | awk '{if($3>=20) print $0}']:" | $saveCheckResult
pscpu=$(ps -aux | sort -nr -k 3 | head -5 | awk '{if($3>=20) print $0}')
if [ -n "$pscpu" ];then
	echo "[!]以下进程占用的CPU超过20%:" && echo "UID         PID   PPID  C STIME TTY          TIME CMD" 
	echo "$pscpu" | tee -a 20.2.3_pscpu.txt | $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现进程占用资源超过20%" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[18.3]正在分析内存情况:" | $saveCheckResult
echo "[18.3.1]正在检查内存相关信息:" | $saveCheckResult
(echo "[+]内存信息如下[more /proc/meminfo]:" && more /proc/meminfo) | $saveCheckResult
(echo "[+]内存使用情况如下[free -m]:" && free -m) | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.3.2]正在检查内存占用前5资源的进程:" | $saveCheckResult
(echo "[+]占用内存资源前5进程[ps -aux | sort -nr -k 4 | head -5]:" && ps -aux | sort -nr -k 4 | head -5) | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.3.3]正在检查内存占用较多的进程:" | $saveCheckResult
psmem=$(ps -aux | sort -nr -k 4 | head -5 | awk '{if($4>=2) print $0}')
if [ -n "$psmem" ];then
	echo "[!]以下进程占用的内存超过20%:" && echo "UID         PID   PPID  C STIME TTY          TIME CMD"
	echo "$psmem" |  $saveDangerResult | $saveCheckResult
else
	echo "[+]未发现进程占用内存资源超过20%" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[18.4]系统运行及负载情况:" | $saveCheckResult
echo "[18.4.1]正在检查系统运行时间及负载情况:." | $saveCheckResult
(echo "[+]系统运行时间如下[uptime]:" && uptime) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "==========19.检查日志统一打包==========" | $saveCheckResult
echo "[19.1]正在打包系统原始日志[/var/log]:" | $saveCheckResult
tar -czvf ${log_file}/system_log.tar.gz /var/log/ -P
if [ $? -eq 0 ];then
	echo "[+]日志打包成功" | $saveCheckResult
else
	echo "[!]日志打包失败,请工人导出日志" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[19.2]正在打包脚本检查日志到/output/目录下:" | $saveCheckResult
# zip -r /tmp/linuxcheck_${ipadd}_${date}.zip /tmp/linuxcheck_${ipadd}_${date}/*
tar -zcvf ${current_dir}/output/linuxcheck_${ipadd}_${date}.tar.gz  ${current_dir}/output/linuxcheck_${ipadd}_${date}/* -P
if [ $? -eq 0 ];then
	echo "[+]检查文件打包成功" | $saveCheckResult
else
	echo "[!]检查文件打包失败,请工人导出日志" |  $saveDangerResult | $saveCheckResult
fi


echo "检查结束!" | $saveCheckResult
echo "Version:3.0" | $saveCheckResult
echo "Author:sun97" | $saveCheckResult
echo "Mail:jiuwei977@foxmail.com" |	$saveCheckResult
echo "Date:2024.6.16" | $saveCheckResult
