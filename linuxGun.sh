#!/bin/bash
HELL=/bin/bash 
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# Version: 6.0.2
# Author: Sun977
# Update: 2025-07-02

# 更新功能,所有系统通用【等待更新】
# 模块化：linuxgun.sh --[option] --[module-option] -f 的方式调用各个模块
# 根据参数执行不同的功能 
# [INFO] 提示输出 -- 提示     [+]
# [NOTE] 注意输出 -- 需要注意  
# [WARN] 警告输出 -- 重点关注  [!]
# [KNOW] 知识点
# [ERRO] 错误输出
# [i] 

# 大纲输出函数
print_summary() {
	cat << EOF
	linuxGun 检测项目大纲(summary)
	一.系统信息排查
		- IP地址
		- 系统基础信息
		    - 系统版本信息
		    - 系统发行版本
		- 用户信息分析
		    - 正在登录用户
		    - 系统最后登录用户
		    - 用户信息passwd文件分析
		    - 检查可登录用户
		    - 检查超级用户(除root外)
		    - 检查克隆用户
		    - 检查非系统用户
		    - 检查空口令用户
		    - 检查空口令且可登录用户
		    - 检查口令未加密用户
		    - 用户组信息group文件分析
		    - 检查特权用户组(除root组外)
		    - 相同GID用户组
		    - 相同用户组名
		- 计划任务分析
		    - 系统计划任务
			- 用户计划任务
		- 历史命令分析
		    - 输出当前shell系统历史命令[history]
		    - 输出用系历史命令[.bash_history]
			- 是否下载过脚本文件
			- 是否通过主机下载,传输过文件
			- 是否增加,删除过账号
			- 是否执行过黑客命令
			- 其他敏感命令
			- 检查系统中所有可能的历史文件路径[补充]
			- 输出系统中所有用户的历史文件[补充]
			- 输出数据库操作历史命令
	二.网络链接排查
		- ARP 攻击分析
		- 网络连接分析
		- 端口信息排查
		    - TCP 端口检测
			- TCP 高危端口(自定义高危端口组)
			- UDP 端口检测
			- UDP 高危端口(自定义高危端口组)
		- DNS 信息排查
		- 网卡工作模式
		- 网络路由信息排查
		- 路由转发排查
		- 防火墙策略排查
	三.进程排查
		- ps进程分析
		- top进程分析
		- 规则匹配敏感进程(自定义进程组)
		- 异常进程检测
		- 孤儿进程检测
		- 网络连接和进程映射
		- 进程可疑内存映射
		- 文件描述符异常进程
		- 系统调用表完整性检测
		- 进程启动时间异常检测
		- 进程环境变量异常检测
	四.文件排查
		- 系统服务排查
			- 系统服务收集
			- 系统服务分析
				- 系统自启动服务分析
				- 系统正在运行的服务分析
			- 用户服务分析
		- 敏感目录排查
			- /tmp目录
			- /root目录(隐藏文件)【隐藏文件分析】
		- 特殊文件排查
			- ssh相关文件排查
				- .ssh目录排查
				- 公钥私钥排查
				- authrized_keys文件排查
				- known_hosts文件排查
				- sshd_config文件分析
					- 所有开启的配置(不带#号)
					- 检测是否允许空口令登录
					- 检测是否允许root远程登录
					- 检测ssh协议版本
					- 检测ssh版本
			- 环境变量排查
				- 环境变量文件分析
				- env命令分析
			- hosts文件排查
			- shadow文件排查
				- shadow文件权限
				- shadow文件属性
				- gshadow文件权限
				- gshadow文件属性
			- 24小时变动文件排查
			— SUID/SGID文件排查	
		- 日志文件分析
			- message日志分析
				- ZMODEM传输文件
				- 历史使用DNS情况
			- secure日志分析
				- 登录成功记录分析
				- 登录失败记录分析(SSH爆破)
				- SSH登录成功记录分析
				- 新增用户分析
				- 新增用户组分析
			- 计划任务日志分析(cron)
			    - 定时下载文件
				- 定时执行脚本
			- yum日志分析
			    - yum下载记录
				- yum卸载记录
				- yum安装可疑工具
			- dmesg日志分析[内核自检日志]
			- btmp日志分析[错误登录日志]
			- lastlog日志分析[所有用户最后一次登录日志]
			- wtmp日志分析[所有用户登录日志]
			- journalctl工具日志分析
			   	- 最近24小时日志
			- auditd 服务状态
			- rsyslog 配置文件
	五.后门排查
	六.webshell排查
	七.病毒排查
	八.内存排查
	九.黑客工具排查
		- 黑客工具匹配(规则自定义)
		- 常见黑客痕迹排查(待完成)
	十.内核排查
		- 内核驱动排查
	    - 可疑驱动排查(自定义可疑驱动列表)
	十一.其他排查
		- 可疑脚本文件排查
		- 系统文件完整性校验(MD5)
		- 安装软件排查
	十二.k8s排查
		- 集群信息排查
		- 集群凭据排查
		- 集群敏感文件扫描
		- 集群基线检查
	十三.系统性能分析
		- 磁盘使用情况
		- CPU使用情况
		- 内存使用情况
		- 系统负载情况
		- 网络流量情况
	十四.基线检查
		- 1.账户管理
		    - 1.1 账户审查(用户和组策略) 
		    	- 系统最后登录用户
				- 用户信息passwd文件分析
				- 检查可登录用户
				- 检查超级用户(除root外)
				- 检查克隆用户
				- 检查非系统用户
				- 检查空口令用户
				- 检查空口令且可登录用户
				- 检查口令未加密用户
				- 用户组信息group文件分析
				- 检查特权用户组(除root组外)
				- 相同GID用户组
				- 相同用户组名
			- 1.2 密码策略
		    	- 密码有效期策略
					- 口令生存周期
					- 口令更改最小时间间隔
					- 口令最小长度
					- 口令过期时间天数
				- 密码复杂度策略
				- 密码已过期用户
				- 账号超时锁定策略
				- grub2密码策略检查
				- grub密码策略检查(存在版本久远-弃用)
				- lilo密码策略检查(存在版本久远-弃用)
			- 1.3 远程登录限制
		    	- 远程访问策略(基于 TCP Wrappers)
			    	- 远程允许策略
					- 远程拒绝策略
			- 1.4 认证与授权
				- SSH安全增强
					- sshd配置
					- 空口令登录
					- root远程登录
					- ssh协议版本
				- PAM策略
				- 其他认证服务策略
		- 2.文件权限及访问控制
			- 关键文件保护(文件或目录的权限及属性)
				- 文件权限策略
					- etc文件权限
					- shadow文件权限
					- passwd文件权限
					- group文件权限
					- securetty文件权限
					- services文件权限
					- grub.conf文件权限
					- xinetd.conf文件权限
					- lilo.conf文件权限(存在版本久远-弃用)
					- limits.conf文件权限
					    - core dump 关闭
				- 系统文件属性检查
					- passwd文件属性
					- shadow文件属性
					- gshadow文件属性
					- group文件属性
				- useradd 和 usedel 的时间属性
		- 3.网络配置与服务
			- 端口和服务审计
			- 防火墙配置
				- 允许服务IP端口
			- 网络参数优化
		- 4.selinux策略
		- 5.服务配置策略
			- NIS配置策略
			- SNMP配置检查
			- Nginx配置策略
		- 6.日志记录与监控
			- rsyslog服务
				- 服务开启
				- 文件权限默认
			- audit服务
			- 日志轮转和监控
			- 实时监控和告警
		- 7.备份和恢复策略
		- 8.其他安全配置基准
EOF
}
# ------------------------
# 基础变量定义
# 输出颜色定义
typeset RED='\033[0;31m'
typeset BLUE='\033[0;34m'
typeset YELLOW='\033[0;33m'
typeset GREEN='\033[0;32m'
typeset NC='\033[0m'

# 脚本转换确保可以在Linux下运行
# dos2unix linuxgun.sh # 将windows格式的脚本转换为Linux格式 不是必须

# 初始化环境
init_env(){
	# 基础变量定义
	date=$(date +%Y%m%d)
	# 取出本机器上第一个非回环地址的IP地址,用于区分导出的文件
	ipadd=$(ip addr | grep -w inet | grep -v 127.0.0.1 | awk 'NR==1{print $2}' | sed 's#/\([0-9]\+\)#_\1#') # 192.168.1.1_24

	# 创建输出目录变量,当前目录下的output目录
	current_dir=$(pwd)  
	check_file="${current_dir}/output/linuxcheck_${ipadd}_${date}/check_file"
	log_file="${check_file}/log"
	k8s_file="${check_file}/k8s"

	# 删除原有的输出目录
	rm -rf $check_file
	rm -rf $log_file
	rm -rf $k8s_file

	# 创建新的输出目录 检查目录 日志目录
	mkdir -p $check_file
	mkdir -p $log_file
	mkdir -p $k8s_file  # 20250702 新增 k8s 检查路径

	# 初始化报告文件
	echo "LinuxGun v6.0 检查项日志输出" > ${check_file}/checkresult.txt
	echo "" >> ${check_file}/checkresult.txt
	# echo "检查发现危险项,请注意:" > ${check_file}/dangerlist.txt
	# echo "" >> ${check_file}/dangerlist.txt

	# 判断目录是否存在
	if [ ! -d "$check_file" ];then
		echo "检查 ${check_file} 目录不存在,请检查"
		exit 1
	fi

	# 进入到检查目录
	cd $check_file

}

# 确保当前用户是root用户
ensure_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}[!] 请以 root 权限运行此脚本${NC}"
        exit 1
    fi
}

# 在 check_file 下追加模式打开文件,将输出结果展示在终端且同时保存到对应文件中 
# cd $check_file  
# saveCheckResult="tee -a checkresult.txt" 
# saveDangerResult="tee -a dangerlist.txt"

################################################################

# 颜色：分割线:绿色 检查项:黄色 错误项和注意项:红色 输出项:蓝色

# banner 函数 
echoBanner() {
    echo -e "${YELLOW}****************************************************************${NC}"
    echo -e "${BLUE}      __     __                      ______                     ${NC}"
    echo -e "${BLUE}     / /    /_/____   __  __ _  __ / ____/__  __ ____           ${NC}"
    echo -e "${BLUE}    / /    / // __ \ / / / /| |/_// / __ / / / // __ \\         ${NC}"
    echo -e "${BLUE}   / /___ / // / / // /_/ /_>  < / /_/ // /_/ // / / /          ${NC}"
    echo -e "${BLUE}  /_____//_//_/ /_/ \__,_//_/|_| \____/ \__,_//_/ /_/           ${NC}"
    echo -e "${BLUE}                                                                ${NC}" 
    echo -e "${BLUE}                                     Version:6.0     			${NC}"
    echo -e "${BLUE}                                     Author:sun977   			${NC}"
	echo -e "${BLUE}                                     Mail:jiuwei977@foxmail.com ${NC}"
	echo -e "${YELLOW}****************************************************************${NC}"
    echo -e "${GREEN}检查内容:${NC}"
    echo -e "${GREEN}    1.采集系统基础环境信息${NC}"
	echo -e "${GREEN}    2.网络连接情况分析${NC}"
	echo -e "${GREEN}    3.系统进程信息分析${NC}"
	echo -e "${GREEN}    4.系统文件信息分析${NC}"
	echo -e "${GREEN}    5.后门排查${NC}"
	echo -e "${GREEN}    6.webshell排查${NC}"
	echo -e "${GREEN}    7.病毒信息排查${NC}"
	echo -e "${GREEN}    8.内存信息排查${NC}"
	echo -e "${GREEN}    9.黑客工具排查${NC}"
	echo -e "${GREEN}    10.内核信息排查${NC}"
	echo -e "${GREEN}    11.其他重要排查${NC}"
	echo -e "${GREEN}    12.kubernets信息排查${NC}"
	echo -e "${GREEN}    13.系统性能分析${NC}"
	echo -e "${GREEN}    14.系统基线检查${NC}"
    echo -e "${GREEN}如何使用:${NC}"
    echo -e "${GREEN}    1.需要将本脚本上传到相应的服务器中${NC}"
    echo -e "${GREEN}    2.运行 chmod +x linuxgun.sh 赋予脚本执行权限${NC}"
    echo -e "${GREEN}    3.运行 ./linuxgun.sh 查看使用说明${NC}"
	echo -e "${YELLOW}================================================================${NC}"
}

# 采集系统基础信息【归档 -- systemCheck】
baseInfo(){
    echo -e "${GREEN}==========${YELLOW}1. Get System Info${GREEN}==========${NC}"

    echo -e "${YELLOW}[1.0] 获取IP地址信息[ip addr]:${NC}"
    ip=$(ip addr | grep -w inet | awk '{print $2}')
    if [ -n "$ip" ]; then
        echo -e "${YELLOW}[+] 本机IP地址信息:${NC}" && echo "$ip"
    else
        echo -e "${RED}[!] 本机未配置IP地址${NC}"
    fi
    printf "\n"

    echo -e "${YELLOW}[1.1] 系统版本信息[uname -a]:${NC}"
    unameInfo=$(uname -a)
    if [ -n "$unameInfo" ]; then
        osName=$(echo "$unameInfo" | awk '{print $1}')      # 内核名称
        hostName=$(echo "$unameInfo" | awk '{print $2}')    # 主机名
        kernelVersion=$(echo "$unameInfo" | awk '{print $3}') # 内核版本
        arch=$(echo "$unameInfo" | awk '{print $12}')       # 系统架构
        echo -e "${YELLOW}[+] 内核名称: $osName${NC}"
        echo -e "${YELLOW}[+] 主机名: $hostName${NC}"
        echo -e "${YELLOW}[+] 内核版本: $kernelVersion${NC}"
        echo -e "${YELLOW}[+] 系统架构: $arch${NC}"
    else
        echo -e "${RED}[!] 无法获取系统版本信息${NC}"
    fi
    printf "\n"

    echo -e "${YELLOW}[1.2] 系统发行版本信息:${NC}"
    distro="Unknown"
    releaseFile="/etc/os-release"

    if [ -f "$releaseFile" ]; then
        # 推荐使用 os-release 获取标准化信息
        distro=$(grep "^PRETTY_NAME" "$releaseFile" | cut -d= -f2 | tr -d '"')  # CentOS Linux 7 (Core)
        if [ -n "$distro" ]; then
            echo -e "${YELLOW}[+] 系统发行版本: $distro${NC}"
        else
            echo -e "${YELLOW}[!] 未找到有效的系统发行版本信息${NC}"
        fi
    elif [ -f "/etc/redhat-release" ]; then
        distro=$(cat /etc/redhat-release)
        echo -e "${YELLOW}[+] 系统发行版本: $distro${NC}"
    elif [ -f "/etc/debian_version" ]; then
        debian_ver=$(cat /etc/debian_version)
        distro="Debian GNU/Linux $debian_ver"
        echo -e "${YELLOW}[+] 系统发行版本: $distro${NC}"
    elif [ -f "/etc/alpine-release" ]; then
        alpine_ver=$(cat /etc/alpine-release)
        distro="Alpine Linux $alpine_ver"
        echo -e "${YELLOW}[+] 系统发行版本: $distro${NC}"
	elif [ -f "/etc/kylin-release" ]; then  # 麒麟系统
        kylin_ver=$(cat /etc/kylin-release)
        distro="kylin Linux $kylin_ver"
        echo -e "${YELLOW}[+] 系统发行版本: $distro${NC}"
    elif command -v lsb_release &>/dev/null; then
        distro=$(lsb_release -d | cut -f2)
        echo -e "${YELLOW}[+] 系统发行版本: $distro${NC}"
    else
        echo -e "${YELLOW}[!] 系统发行版本信息未找到,请手动检查${NC}"
    fi
    printf "\n"

    echo -e "${YELLOW}[1.3] 系统启动时间信息[uptime]:${NC}"
    uptimeInfo=$(uptime)
    if [ -n "$uptimeInfo" ]; then
        echo -e "${YELLOW}[+] 系统运行时间信息如下:${NC}"
        echo "$uptimeInfo"
    else
        echo -e "${RED}[!] 无法获取系统运行时间信息${NC}"
    fi
    printf "\n"

    echo -e "${YELLOW}[1.4] 系统虚拟化环境检测:${NC}"
    virtWhat=$(dmidecode -s system-manufacturer 2>/dev/null | grep -i virtualbox || true)
    containerCheck=$(grep -E 'container|lxc|docker' /proc/1/environ 2>/dev/null)  #获取 init/systemd 进程的环境变量
	k8swhat=$(grep -E 'POD_NAMESPACE|KUBERNETES_SERVICE_HOST|kubernetes' /proc/1/environ 2>/dev/null)

    if [ -n "$virtWhat" ]; then
        echo -e "${YELLOW}[+] 虚拟化环境: VirtualBox${NC}"
    elif [ -n "$containerCheck" ]; then
        echo -e "${YELLOW}[+] 运行在容器[container|lxc|docker]环境中${NC}"
	elif [ -n "$k8swhat" ]; then
        echo -e "${YELLOW}[+] 运行在 Kubernetes 集群中${NC}"
    else
        echo -e "${YELLOW}[+] 运行在物理机或未知虚拟化平台${NC}"
    fi
    printf "\n"
}

# 网络信息【完成】
networkInfo(){
    echo -e "${GREEN}==========${YELLOW}2.Network Info${GREEN}==========${NC}"
    echo -e "${YELLOW}[2.0]Get Network Connection Info${NC}"  
    echo -e "${YELLOW}[2.1]Get ARP Table[arp -a -n]:${NC}"  
    arp=$(arp -a -n)
    if [ -n "$arp" ];then
        (echo -e "${YELLOW}[+]ARP Table:${NC}" && echo "$arp")  
    else
        echo -e "${RED}[!]未发现ARP表${NC}"  
    fi
    # 原理：通过解析arp表并利用awk逻辑对MAC地址进行计数和识别,然后输出重复的MAC地址以及它们的出现次数
    # 该命令用于统计arp表中的MAC地址出现次数,并显示重复的MAC地址及其出现频率。
    # 具体解释如下：
    # - `arp -a -n`：查询ARP表,并以IP地址和MAC地址的格式显示结果。
    # - `awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}'`：使用awk命令进行处理。
    #   - `{++S[$4]}`：对数组S中以第四个字段（即MAC地址）作为索引的元素加1进行计数。
    #   - `END {for(a in S) {if($2>1) print $2,a,S[a]}}`：在处理完所有行之后,遍历数组S。
    #     - `for(a in S)`：遍历数组S中的每个元素。
    #     - `if($2>1)`：如果第二个字段（即计数）大于1,则表示这是一个重复的MAC地址。
    #     - `print $2,a,S[a]`：打印重复的MAC地址的计数、MAC地址本身和出现的次数。

    # ARP攻击检查
    echo -e "${YELLOW}[2.2]Check ARP Attack[arp -a -n]:${NC}"  
    echo -e "${YELLOW}[原理]:通过解析arp表并利用awk逻辑对MAC地址进行计数和识别,然后输出重复的MAC地址以及它们的出现次数${NC}"  
    arpattack=$(arp -a -n | awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}')
    if [ -n "$arpattack" ];then
        (echo -e "${RED}[!]发现存在ARP攻击:${NC}" && echo "$arpattack") 
    else
        echo -e "${YELLOW}[+]未发现ARP攻击${NC}"  
    fi

    # 网络连接信息
    echo -e "${YELLOW}[2.3]Get Network Connection Info${NC}"  
    echo -e "${YELLOW}[2.3.1]Check Network Connection[netstat -anlp]:${NC}"  
    netstat=$(netstat -anlp | grep ESTABLISHED) # 过滤出已经建立的连接 ESTABLISHED
    netstatnum=$(netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}')
    if [ -n "$netstat" ];then
        (echo -e "${YELLOW}[+]Established Network Connection:${NC}" && echo "$netstat")  
        if [ -n "$netstatnum" ];then
            (echo -e "${YELLOW}[+]Number of each state:${NC}" && echo "$netstatnum")  
        fi
    else
        echo -e "${YELLOW}[+]No network connection${NC}"  
    fi

    # 端口信息
    ## 检测 TCP 端口
    echo -e "${YELLOW}[2.3.2]Check Port Info[netstat -anlp]:${NC}"  
    echo -e "${YELLOW}[说明]TCP或UDP端口绑定在0.0.0.0、127.0.0.1、192.168.1.1这种IP上只表示这些端口开放${NC}"  
    echo -e "${YELLOW}[说明]只有绑定在0.0.0.0上局域网才可以访问${NC}"  
    echo -e "${YELLOW}[2.3.2.1]Check TCP Port Info[netstat -anltp]:${NC}"  
    tcpopen=$(netstat -anltp | grep LISTEN | awk  '{print $4,$7}' | sed 's/:/ /g' | awk '{print $2,$NF}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
    if [ -n "$tcpopen" ];then
        (echo -e "${YELLOW}[+]Open TCP ports and corresponding services:${NC}" && echo "$tcpopen")  
    else
        echo -e "${RED}[!]No open TCP ports${NC}"  
    fi

    tcpAccessPort=$(netstat -anltp | grep LISTEN | awk  '{print $4,$7}' | egrep "(0.0.0.0|:::)" | sed 's/:/ /g' | awk '{print $(NF-1),$NF}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
    if [ -n "$tcpAccessPort" ];then
        (echo -e "${RED}[!]The following TCP ports are open to the local area network or the Internet, please note!${NC}" && echo "$tcpAccessPort")
    else
        echo -e "${YELLOW}[+]The port is not open to the local area network or the Internet${NC}" 
    fi

    ## 检测 TCP 高危端口
    echo -e "${YELLOW}[2.3.2.2]Check High-risk TCP Port[netstat -antlp]:${NC}"  
    echo -e "${YELLOW}[说明]Open ports in dangerstcpports.txt file are matched, and if matched, they are high-risk ports${NC}"  
    declare -A danger_ports  # 创建关联数组以存储危险端口和相关信息
    # 读取文件并填充关联数组
    while IFS=: read -r port description; do
        danger_ports["$port"]="$description"
    done < "${current_dir}/checkrules/dangerstcpports.txt"
    # 获取所有监听中的TCP端口
    listening_TCP_ports=$(netstat -anlpt | awk 'NR>1 {print $4}' | cut -d: -f2 | sort -u) # 获取所有监听中的TCP端口
    tcpCount=0  # 初始化计数器
    # 遍历所有监听端口
    for port in $listening_TCP_ports; do
        # 如果端口在危险端口列表中
        if [[ -n "${danger_ports[$port]}" ]]; then
            # 输出端口及描述
            echo -e "${RED}[!]$port,${danger_ports[$port]}${NC}"    
            ((tcpCount++))
        fi
    done

    if [ $tcpCount -eq 0 ]; then
        echo -e "${YELLOW}[+]No TCP dangerous ports found${NC}"  
    else
        echo -e "${RED}[!]Total TCP dangerous ports found: $tcpCount ${NC}"    
        echo -e "${RED}[!]Please manually associate and confirm the TCP dangerous ports${NC}"    
    fi

    ## 检测 UDP 端口
    echo -e "${YELLOW}[2.3.2.3]Check UDP Port Info[netstat -anlup]:${NC}"  
    udpopen=$(netstat -anlup | awk  '{print $4,$NF}' | grep : | sed 's/:/ /g' | awk '{print $2,$3}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
    if [ -n "$udpopen" ];then
        (echo -e "${YELLOW}[+]Open UDP ports and corresponding services:${NC}" && echo "$udpopen")  
    else
        echo -e "${RED}[!]No open UDP ports${NC}"  
    fi

    udpAccessPort=$(netstat -anlup | awk '{print $4}' | egrep "(0.0.0.0|:::)" | awk -F: '{print $NF}' | sort -n | uniq)
    # 检查是否有UDP端口
    if [ -n "$udpAccessPort" ]; then
        echo -e "${YELLOW}[+]以下UDP端口面向局域网或互联网开放:${NC}"  
        for port in $udpAccessPort; do
            if nc -z -w1 127.0.0.1 $port </dev/null; then
                echo "$port"  
            fi
        done
    else
        echo -e "${YELLOW}[+]未发现在UDP端口面向局域网或互联网开放.${NC}"  
    fi

    ## 检测 UDP 高危端口
    echo -e "${YELLOW}[2.3.2.4]Check High-risk UDP Port[netstat -anlup]:${NC}"  
    echo -e "${YELLOW}[说明]Open ports in dangersudpports.txt file are matched, and if matched, they are high-risk ports${NC}"  
    declare -A danger_udp_ports  # 创建关联数组以存储危险端口和相关信息
    # 读取文件并填充关联数组
    while IFS=: read -r port description; do
        danger_udp_ports["$port"]="$description"
    done < "${current_dir}/checkrules/dangersudpports.txt"
    # 获取所有监听中的UDP端口
    listening_UDP_ports=$(netstat -anlup | awk 'NR>1 {print $4}' | cut -d: -f2 | sort -u) # 获取所有监听中的UDP端口
    udpCount=0  # 初始化计数器
    # 遍历所有监听端口
    for port in $listening_UDP_ports; do
        # 如果端口在危险端口列表中
        if [[ -n "${danger_udp_ports[$port]}" ]]; then
            # 输出端口及描述
            echo -e "${RED}[!]$port,${danger_udp_ports[$port]}${NC}"    
            ((udpCount++))
        fi
    done

    if [ $udpCount -eq 0 ]; then
        echo -e "${YELLOW}[+]No UDP dangerous ports found${NC}"  
    else
        echo -e "${RED}[!]Total UDP dangerous ports found: $udpCount ${NC}"    
        echo -e "${RED}[!]Please manually associate and confirm the UDP dangerous ports${NC}"    
    fi

    # DNS 信息
    echo -e "${YELLOW}[2.3.3]Check DNS Info[/etc/resolv.conf]:${NC}"  
    resolv=$(more /etc/resolv.conf | grep ^nameserver | awk '{print $NF}')

    if [ -n "$resolv" ];then
        (echo -e "${YELLOW}[+]该服务器使用以下DNS服务器:${NC}" && echo "$resolv")  
    else
        echo -e "${YELLOW}[+]未发现DNS服务器${NC}"  
    fi

    # 网卡模式
    echo -e "${YELLOW}[2.4]Check Network Card Mode[ip addr]:${NC}"  
    ifconfigmode=$(ip addr | grep '<' | awk  '{print "网卡:",$2,"模式:",$3}' | sed 's/<//g' | sed 's/>//g')
    if [ -n "$ifconfigmode" ];then
        (echo -e "${YELLOW}[+]网卡模式如下:${NC}" && echo "$ifconfigmode")  
    else
        echo -e "${RED}[!]未发现网卡模式${NC}"  
    fi

    # 混杂模式
    echo -e "${YELLOW}[2.4.1]Check Promiscuous Mode[ip addr]:${NC}"  
    Promisc=$(ip addr | grep -i promisc | awk -F: '{print $2}')
    if [ -n "$Promisc" ];then
        (echo -e "${RED}[!]网卡处于混杂模式:${NC}" && echo "$Promisc") 
    else
        echo -e "${YELLOW}[+]未发现网卡处于混杂模式${NC}"  
    fi

    # 监听模式
    echo -e "${YELLOW}[2.4.2]Check Monitor Mode[ip addr]:${NC}"  
    Monitor=$(ip addr | grep -i "mode monitor" | awk -F: '{print $2}')
    if [ -n "$Monitor" ];then
        (echo -e "${RED}[!]网卡处于监听模式:${NC}" && echo "$Monitor")
    else
        echo -e "${YELLOW}[+]未发现网卡处于监听模式${NC}"  
    fi

    # 网络路由信息
    echo -e "${YELLOW}[2.5]Get Network Route Info${NC}"  
    echo -e "${YELLOW}[2.5.1]Check Route Table[route -n]:${NC}"  
    route=$(route -n)
    if [ -n "$route" ];then
        (echo -e "${YELLOW}[+]路由表如下:${NC}" && echo "$route")  
    else
        echo -e "${YELLOW}[+]未发现路由器表${NC}"  
    fi

    # 路由转发
    echo -e "${YELLOW}[2.5.2]Check IP Forward[/proc/sys/net/ipv4/ip_forward]:${NC}"  
    ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)  # 1:开启路由转发 0:未开启路由转发
    # 判断IP转发是否开启
    if [ "$ip_forward" -eq 1 ]; then
        echo -e "${RED}[!]该服务器开启路由转发,请注意!${NC}"    
    else
        echo -e "${YELLOW}[+]该服务器未开启路由转发${NC}"  
    fi

    # 防火墙策略
    echo -e "${YELLOW}[2.6]Get Firewall Policy${NC}"  
    echo -e "${YELLOW}[2.6.1]Check Firewalld Policy[systemctl status firewalld]:${NC}"  
    firewalledstatus=$(systemctl status firewalld | grep "active (running)")
    firewalledpolicy=$(firewall-cmd --list-all)
    if [ -n "$firewalledstatus" ];then
        echo -e "${YELLOW}[+]该服务器防火墙已打开${NC}"  
        if [ -n "$firewalledpolicy" ];then
            (echo -e "${YELLOW}[+]防火墙策略如下${NC}" && echo "$firewalledpolicy")  
        else
            echo -e "${RED}[!]防火墙策略未配置,建议配置防火墙策略!${NC}" 
        fi
    else
        echo -e "${RED}[!]防火墙未开启,建议开启防火墙${NC}" 
    fi

    echo -e "${YELLOW}[2.6.2]Check Iptables Policy[service iptables status]:${NC}"  
    firewalledstatus=$(service iptables status | grep "Table" | awk '{print $1}')  # 有"Table:",说明开启,没有说明未开启
    firewalledpolicy=$(iptables -L)
    if [ -n "$firewalledstatus" ];then
        echo -e "${YELLOW}[+]iptables已打开${NC}"  
        if [ -n "$firewalledpolicy" ];then
            (echo -e "${YELLOW}[+]iptables策略如下${NC}" && echo "$firewalledpolicy")  
        else
            echo -e "${RED}[!]iptables策略未配置,建议配置iptables策略!${NC}" 
        fi
    else
        echo -e "${RED}[!]iptables未开启,建议开启防火墙${NC}" 
    fi
    printf "\n"  
}

# 进程信息分析【完成】
processInfo(){
	echo -e "${YELLOW}[+]输出所有系统进程[ps -auxww]:${NC}" && ps -auxww
	echo -e "${YELLOW}[+]检查内存占用top5的进程[ps -aux | sort -nr -k 4 | head -5]:${NC}" && ps -aux | sort -nr -k 4 | head -5
	echo -e "${YELLOW}[+]检查内存占用超过20%的进程[ps -aux | sort -nr -k 4 | awk '{if($4>=20) print $0}' | head -5]:${NC}" && ps -aux | sort -nr -k 4 | awk '{if($4>=20) print $0}' | head -5
	echo -e "${YELLOW}[+]检查CPU占用top5的进程[ps -aux | sort -nr -k 3 | head -5]:${NC}" && ps -aux | sort -nr -k 3 | head -5
	echo -e "${YELLOW}[+]检查CPU占用超过20%的进程[ps -aux | sort -nr -k 3 | awk '{if($3>=20) print }' | head -5]:${NC}" && ps -aux | sort -nr -k 3 | awk '{if($3>=20) print $0}' | head -5
    # 敏感进程匹配[匹配规则]
	echo -e "${YELLOW}[+]根据规则列表 dangerspslist.txt 匹配检查敏感进程${NC}"
	danger_ps_list=$(cat ${current_dir}/checkrules/dangerspslist.txt) # 敏感进程程序名列表
	# 循环输出敏感进程的进程名称和 PID 和 所属用户
	ps_output=$(ps -auxww)
	for psname in $danger_ps_list; do
		filtered_output=$(echo "$ps_output" | awk -v proc="$psname" '
			BEGIN { found = 0 }
			{
				if ($11 ~ proc) {
					print;
					found++;
				}
			}
			END {
				if (found > 0) {
					printf($0)
					printf("\n'${YELLOW}'[!]发现敏感进程: %s, 进程数量: %d'${NC}'\n", proc, found);
				}
			}'
		)
		# 输出敏感进程
		# echo -e "${RED}[!]敏感进程如下:${NC}" && echo "$filtered_output"
		echo -e "${RED}$filtered_output${NC}"
	done
	printf "\n" 

	# 异常进程检测：如果存在 /proc 目录中有进程文件夹,但是在 ps -aux 命令里没有显示的,就认为可能是异常进程
	echo -e "${YELLOW}[+]正在检查异常进程(存在于/proc但不在ps命令中显示):${NC}"
	
	# 获取所有ps命令显示的PID
	ps_pids=$(ps -eo pid --no-headers | tr -d ' ')
	# 获取/proc目录中的所有数字目录(进程PID)
	proc_pids=$(ls /proc/ 2>/dev/null | grep '^[0-9]\+$')
	
	# 检查异常进程
	anomalous_processes=()  # 用于存储异常进程的数组
	for proc_pid in $proc_pids; do
		# 检查该PID是否在ps命令输出中
		if ! echo "$ps_pids" | grep -q "^${proc_pid}$"; then
			# 验证/proc/PID目录确实存在且可访问
			if [ -d "/proc/$proc_pid" ] && [ -r "/proc/$proc_pid/stat" ]; then
				# 尝试读取进程信息
				if [ -r "/proc/$proc_pid/comm" ]; then
					proc_name=$(cat "/proc/$proc_pid/comm" 2>/dev/null || echo "unknown")
				else
					proc_name="unknown"
				fi
				
				if [ -r "/proc/$proc_pid/cmdline" ]; then
					proc_cmdline=$(cat "/proc/$proc_pid/cmdline" 2>/dev/null | tr '\0' ' ' || echo "unknown")
				else
					proc_cmdline="unknown"
				fi
				
				# 获取进程状态
				if [ -r "/proc/$proc_pid/stat" ]; then
					proc_stat=$(cat "/proc/$proc_pid/stat" 2>/dev/null | awk '{print $3}' || echo "unknown")
				else
					proc_stat="unknown"
				fi
				
				# 获取进程启动时间
				if [ -r "/proc/$proc_pid" ]; then
					proc_start_time=$(stat -c %Y "/proc/$proc_pid" 2>/dev/null || echo "unknown")
					if [ "$proc_start_time" != "unknown" ]; then
						proc_start_time=$(date -d @$proc_start_time 2>/dev/null || echo "unknown")
					fi
				else
					proc_start_time="unknown"
				fi
				
				anomalous_processes+=("PID:$proc_pid | Name:$proc_name | State:$proc_stat | StartTime:$proc_start_time | Cmdline:$proc_cmdline")
			fi
		fi
	done
	
	# 输出异常进程结果
	if [ ${#anomalous_processes[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#anomalous_processes[@]} 个异常进程(存在于/proc但不在ps中显示):${NC}"
		for anomalous in "${anomalous_processes[@]}"; do
			echo -e "${RED}[!] $anomalous${NC}"
		done
		echo -e "${RED}[!]建议进一步调查这些进程,可能存在进程隐藏或rootkit感染${NC}"
	else
		echo -e "${YELLOW}[+]未发现异常进程,所有/proc中的进程都能在ps命令中找到${NC}"
	fi
	printf "\n"

	# 高级进程隐藏检测技术
	echo -e "${YELLOW}[+]执行高级进程隐藏检测:${NC}"
	
	# 1. 检查进程树完整性
	echo -e "${YELLOW}[+]检查进程树完整性(孤儿进程检测):${NC}"
	orphan_processes=()
	while IFS= read -r line; do
		# 使用更精确的字段提取,处理不同系统的ps输出格式
		pid=$(echo "$line" | awk '{print $1}')
		ppid=$(echo "$line" | awk '{print $2}')
		# 验证PID和PPID都是数字
		if [[ "$pid" =~ ^[0-9]+$ ]] && [[ "$ppid" =~ ^[0-9]+$ ]]; then
			# 检查父进程是否存在(除了init进程和内核线程)
			if [ "$ppid" != "0" ] && [ "$ppid" != "1" ] && [ "$ppid" != "2" ]; then
				if ! ps -p "$ppid" > /dev/null 2>&1; then
					orphan_processes+=("PID:$pid PPID:$ppid (父进程不存在)")
				fi
			fi
		fi
	done <<< "$(ps -eo pid,ppid 2>/dev/null | tail -n +2)"
	
	if [ ${#orphan_processes[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#orphan_processes[@]} 个可疑孤儿进程:${NC}"
		for orphan in "${orphan_processes[@]}"; do
			echo -e "${RED}[!] $orphan${NC}"
		done
	else
		echo -e "${YELLOW}[+]进程树完整性检查通过${NC}"
	fi
	printf "\n"
	
	# 2. 检查网络连接与进程对应关系
	echo -e "${YELLOW}[+]检查网络连接与进程对应关系:${NC}"
	unknown_connections=()
	
	# 检测操作系统类型并使用相应的命令
	if [[ "$(uname)" == "Darwin" ]]; then  # macOS
		# macOS系统使用lsof命令
		if command -v lsof > /dev/null 2>&1; then
			while IFS= read -r line; do
				# lsof输出格式: COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
				if echo "$line" | grep -E "(TCP|UDP)" > /dev/null; then
					pid=$(echo "$line" | awk '{print $2}')
					# 验证PID是数字且检查进程是否存在
					if [[ "$pid" =~ ^[0-9]+$ ]] && ! ps -p "$pid" > /dev/null 2>&1; then
						proc_name=$(echo "$line" | awk '{print $1}')
						unknown_connections+=("连接: $line (进程PID:$pid Name:$proc_name 不存在)")
					fi
				fi
			done <<< "$(lsof -i -n -P 2>/dev/null | tail -n +2)"
		else
			echo -e "${YELLOW}[+]macOS系统未找到lsof命令,跳过网络连接检查${NC}"
		fi
	else
		# Linux系统使用netstat或ss命令
		if command -v netstat > /dev/null 2>&1; then
			while IFS= read -r line; do
				if echo "$line" | grep -q "/"; then
					pid_info=$(echo "$line" | awk '{print $NF}')
					pid=$(echo "$pid_info" | cut -d'/' -f1)
					if [ "$pid" != "-" ] && [[ "$pid" =~ ^[0-9]+$ ]] && ! ps -p "$pid" > /dev/null 2>&1; then
						unknown_connections+=("连接: $line (进程PID:$pid 不存在)")
					fi
				fi
			done <<< "$(netstat -tulnp 2>/dev/null | grep -v '^Active')"
		else
			# 使用ss命令作为备选
			if command -v ss > /dev/null 2>&1; then
				while IFS= read -r line; do
					if echo "$line" | grep -q "pid="; then
						pid=$(echo "$line" | sed -n 's/.*pid=\([0-9]*\).*/\1/p')
						if [ -n "$pid" ] && [[ "$pid" =~ ^[0-9]+$ ]] && ! ps -p "$pid" > /dev/null 2>&1; then
							unknown_connections+=("连接: $line (进程PID:$pid 不存在)")
						fi
					fi
				done <<< "$(ss -tulnp 2>/dev/null)"
			else
				echo -e "${YELLOW}[+]Linux系统未找到netstat或ss命令,跳过网络连接检查${NC}"
			fi
		fi
	fi
	
	if [ ${#unknown_connections[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#unknown_connections[@]} 个可疑网络连接:${NC}"
		for conn in "${unknown_connections[@]}"; do
			echo -e "${RED}[!] $conn${NC}"
		done
	else
		echo -e "${YELLOW}[+]网络连接与进程对应关系检查通过${NC}"
	fi
	printf "\n"
	
	# 3. 检查进程内存映射异常
	echo -e "${YELLOW}[+]检查进程内存映射异常:${NC}"
	suspicious_maps=()  # 存储可疑内存映射
	for proc_dir in /proc/[0-9]*; do
		if [ -d "$proc_dir" ] && [ -r "$proc_dir/maps" ]; then  # 检查进程目录是否存在和maps文件是否可读
			pid=$(basename "$proc_dir")
			# 检查是否有可疑的内存映射(如可执行的匿名映射)
			## 原理: 通过grep命令匹配maps文件中的rwxp权限的行，并判断是否包含[heap]或[stack]或deleted	
			## rwxp.*\[heap\]: 堆区域具有读写执行权限(异常|正常堆不应该具有可执行权限，只有 rw-)
			## rwxp.*\[stack\]: 栈区域具有读写执行权限(异常|正常栈栈不应该具有可执行权限，只有 rw- 可能是栈溢出攻击，或者 shellcode 直接执行机器码)
			## rwxp.*deleted: 指向已经删除的文件的可执行内存映射(异常|内存马或者恶意代码)
			## 恶意软件删除自身文件但保持在内存中运行
			## 无文件攻击的检测 和 rootkit隐藏技术发现
			suspicious_map=$(grep -E "(rwxp.*\[heap\]|rwxp.*\[stack\]|rwxp.*deleted)" "$proc_dir/maps" 2>/dev/null)
			# 根据可疑映射输出进程名称
			if [ -n "$suspicious_map" ]; then   
				proc_name=$(cat "$proc_dir/comm" 2>/dev/null || echo "unknown")
				suspicious_maps+=("PID:$pid Name:$proc_name 可疑内存映射")
			fi
		fi
	done
	
	if [ ${#suspicious_maps[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#suspicious_maps[@]} 个进程存在可疑内存映射:${NC}"
		for map in "${suspicious_maps[@]}"; do
			echo -e "${RED}[!] $map${NC}"
		done
	else
		echo -e "${YELLOW}[+]进程内存映射检查通过${NC}"
	fi
	printf "\n"
	
	# 4. 检查进程文件描述符异常
	echo -e "${YELLOW}[+]检查进程文件描述符异常:${NC}"
	suspicious_fds=()
	for proc_dir in /proc/[0-9]*; do
		if [ -d "$proc_dir/fd" ] && [ -r "$proc_dir/fd" ]; then
			pid=$(basename "$proc_dir")
			# 检查是否有指向已删除文件的文件描述符
			deleted_files=$(ls -l "$proc_dir/fd/" 2>/dev/null | grep "(deleted)" | wc -l)
			if [ "$deleted_files" -gt 0 ]; then
				proc_name=$(cat "$proc_dir/comm" 2>/dev/null || echo "unknown")
				suspicious_fds+=("PID:$pid Name:$proc_name 有${deleted_files}个已删除文件的文件描述符")
			fi
		fi
	done
	
	if [ ${#suspicious_fds[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#suspicious_fds[@]} 个进程存在可疑文件描述符:${NC}"
		for fd in "${suspicious_fds[@]}"; do
			echo -e "${RED}[!] $fd${NC}"
		done
	else
		echo -e "${YELLOW}[+]进程文件描述符检查通过${NC}"
	fi
	printf "\n"
	
	# 5. 检查系统调用表完整性(需要root权限)
	echo -e "${YELLOW}[+]检查系统调用表完整性:${NC}"
	if [ "$(id -u)" -eq 0 ]; then
		if [ -r "/proc/kallsyms" ]; then
			# 检查sys_call_table符号是否存在
			sys_call_table=$(grep "sys_call_table" /proc/kallsyms 2>/dev/null)
			if [ -n "$sys_call_table" ]; then
				echo -e "${YELLOW}[+]系统调用表符号存在: $sys_call_table ${NC}"
			else
				echo -e "${RED}[!]警告: 无法找到sys_call_table符号,可能被隐藏${NC}"
			fi
			
			# 检查可疑的内核符号
			suspicious_symbols=$(grep -E "(hide|rootkit|stealth|hook)" /proc/kallsyms 2>/dev/null)
			if [ -n "$suspicious_symbols" ]; then
				echo -e "${RED}[!]发现可疑内核符号:${NC}"
				echo "$suspicious_symbols"
			else
				echo -e "${YELLOW}[+]未发现可疑内核符号${NC}"
			fi
		else
			echo -e "${YELLOW}[+]/proc/kallsyms不可读,跳过系统调用表检查${NC}"
		fi
	else
		echo -e "${YELLOW}[+]需要root权限进行系统调用表检查${NC}"
	fi
	printf "\n"
	
	# 6. 检查进程启动时间异常
	echo -e "${YELLOW}[+]检查进程启动时间异常:${NC}"
	time_anomalies=()
	current_time=$(date +%s)
	while IFS= read -r line; do
		pid=$(echo "$line" | awk '{print $1}')
		start_time=$(echo "$line" | awk '{print $2}')
		# 检查启动时间是否在未来(可能的时间篡改)
		if [ "$start_time" -gt "$current_time" ]; then
			proc_name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "unknown")
			time_anomalies+=("PID:$pid Name:$proc_name 启动时间异常(未来时间)")
		fi
	done <<< "$(ps -eo pid,lstart --no-headers | while read -r pid lstart_str; do echo "$pid $(date -d \"$lstart_str\" +%s 2>/dev/null || echo 0)"; done)"
	
	if [ ${#time_anomalies[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#time_anomalies[@]} 个进程启动时间异常:${NC}"
		for anomaly in "${time_anomalies[@]}"; do
			echo -e "${RED}[!] $anomaly${NC}"
		done
	else
		echo -e "${YELLOW}[+]进程启动时间检查通过${NC}"
	fi
	printf "\n"
	
	# 7. 检查进程环境变量异常
	echo -e "${YELLOW}[+]检查进程环境变量异常:${NC}"
	env_anomalies=()
	for proc_dir in /proc/[0-9]*; do
		if [ -r "$proc_dir/environ" ]; then
			pid=$(basename "$proc_dir")
			# 检查可疑的环境变量
			suspicious_env=$(tr '\0' '\n' < "$proc_dir/environ" 2>/dev/null | grep -E "(LD_PRELOAD|LD_LIBRARY_PATH.*\.so|ROOTKIT|HIDE)" 2>/dev/null)
			if [ -n "$suspicious_env" ]; then
				proc_name=$(cat "$proc_dir/comm" 2>/dev/null || echo "unknown")
				env_anomalies+=("PID:$pid Name:$proc_name 可疑环境变量: $(echo \"$suspicious_env\" | head -1)")
			fi
		fi
	done
	
	if [ ${#env_anomalies[@]} -gt 0 ]; then
		echo -e "${RED}[!]发现 ${#env_anomalies[@]} 个进程存在可疑环境变量:${NC}"
		for env in "${env_anomalies[@]}"; do
			echo -e "${RED}[!] $env${NC}"
		done
	else
		echo -e "${YELLOW}[+]进程环境变量检查通过${NC}"
	fi
	printf "\n"
	
}

# 计划任务排查【归档 -- systemCheck】
crontabCheck(){
	# 系统计划任务收集
	echo -e "${YELLOW}输出系统计划任务[/etc/crontab | /etc/cron*/* ]:${NC}" 
	echo -e "${YELLOW}[+]系统计划任务[/etc/crontab]:${NC}" && (cat /etc/crontab | grep -v "^$")  # 去除空行
	echo -e "${YELLOW}[+]系统计划任务[/etc/cron*/*]:${NC}" && (cat /etc/cron*/* | grep -v "^$")

	# 用户计划任务收集
	echo -e "${YELLOW}[+]输出用户计划任务[/var/spool/cron/*]:${NC}" 
	for user_cron in $(ls /var/spool/cron); do
		echo -e "${YELLOW}Cron tasks for user: $user_cron ${NC}"
		cat /var/spool/cron/$user_cron
	done

	# 用户/系统计划任务分析
	hackCron=$(egrep "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))"  /etc/crontab /etc/cron*/* /var/spool/cron/*)  # 输出所有可疑计划任务
	if [ $? -eq 0 ];then
		(echo "${RED}[!]发现下面的定时任务可疑,请注意!${NC}" && echo "$hackCron")  
	else
		echo "${YELLOW}[+]未发现可疑系统定时任务${NC}" 
	fi

	# 系统计划任务状态分析
	echo -e "${YELLOW}[+]检测定时任务访问信息:${NC}" 
	echo -e "${YELLOW}[+]检测定时任务访问信息[stat /etc/crontab | /etc/cron*/* | /var/spool/cron/*]:${NC}" 
	for cronfile in /etc/crontab /etc/cron*/* /var/spool/cron/*; do
		if [ -f "$cronfile" ]; then
			echo -e "${YELLOW}Target cron Info [${cronfile}]:${NC}" && (cat "$cronfile" | grep -v "^$")  # 去除空行
			echo -e "${YELLOW}stat [${cronfile}] ${NC}" && stat "$cronfile" | grep -E "Access|Modify|Change" | grep -v "("
			# 从这里可以看到计划任务的状态[最近修改时间等]
			# "Access:访问时间,每次访问文件时都会更新这个时间,如使用more、cat" 
            # "Modify:修改时间,文件内容改变会导致该时间更新" 
            # "Change:改变时间,文件属性变化会导致该时间更新,当文件修改时也会导致该时间更新;但是改变文件的属性,如读写权限时只会导致该时间更新,不会导致修改时间更新

			# # 检测可疑计划任务[可以写在内部,但是颜色有点问题]
			# echo -e "${YELLOW}[+]检测可疑计划任务:${NC}"
			# hackCron=$(egrep "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))" "$cronfile")
			# if [ $? -eq 0 ];then
			# 	(echo "${RED}[!]发现下面的定时任务可疑,请注意!${NC}" && echo "$hackCron")  
			# else
			# 	echo "${YELLOW}[+]未发现可疑系统定时任务${NC}" 
			# fi
		fi
	done
	printf "\n"
}

# 历史命令排查【归档 -- systemCheck】
historyCheck(){
	# history 和 cat /[user]/.bash_history 的区别
	# history:
	# - 实时历史: history 命令显示的是当前 shell 会话中已经执行过的命令历史,包括那些在当前会话中输入的命令。默认显示 500 条命令,可以通过 -c 参数清除历史记录。
	# - 动态更新: 当你在 shell 会话中执行命令时,这些命令会被实时添加到历史记录中,因此 history 命令的输出会随着你的命令输入而不断更新。
	# - 受限于当前会话: history 命令只显示当前 shell 会话的历史记录。如果关闭了终端再重新打开,history 命令将只显示新会话中的命令历史,除非你使用了历史文件共享设置。
	# - 命令编号: history 命令的输出带有命令编号,这使得引用特定历史命令变得容易。你可以使用 !number 形式来重新执行历史中的任意命令
	# cat /[user]/.bash_history:
	# - 持久化历史: /[user]/.bash_history 文件是 bash shell 保存的命令历史文件,它保存了用户过去执行的命令,即使在关闭终端或注销后,这些历史记录也会被保留下来。
	# - 静态文件: /[user]/.bash_history 是一个文件,它的内容不会随着你当前会话中的命令输入而实时更新。文件的内容会在你退出终端会话时更新,bash 会把当前会话的命令追加到这个文件中。
	# - 不受限于当前会话: cat /[user]/.bash_history 可以显示用户的所有历史命令,包括以前会话中的命令,而不只是当前会话的命令。
	# - 无命令编号: 由于 /[user]/.bash_history 是一个普通的文本文件,它的输出没有命令编号,你不能直接使用 !number 的方式来引用历史命令。
	# 注意: 大多数情况下 linux 系统会为每个用户创建一个 .bash_history 文件。
	# 		set +o history 是关闭命令历史记录功能,set -o history 重新打开[只影响当前的 shell 会话]
	
	# 输出 root 历史命令[history]
	echo -e "${YELLOW}[+]输出当前shell下历史命令[history]:${NC}"
	historyTmp=$(history)
	if [ -n "$historyTmp" ];then
		(echo -e "${YELLOW}[+]当前shell下history历史命令如下:${NC}" && echo "$historyTmp") 
	else
		echo -e "${RED}[!]未发现历史命令,请检查是否记录及已被清除${NC}" 
	fi

	# 读取/root/.bash_history文件的内容到变量history中
	echo -e "${YELLOW}[+]输出操作系统历史命令[cat /root/.bash_history]:${NC}"
	if [ -f /root/.bash_history ]; then
		history=$(cat /root/.bash_history)
		if [ -n "$history" ]; then
			# 如果文件非空,输出历史命令
			(echo -e "${YELLOW}[+]操作系统历史命令如下:${NC}" && echo "$history") 
		else
			# 如果文件为空,输出警告信息
			echo -e "${RED}[!]未发现历史命令,请检查是否记录及已被清除${NC}" 
		fi
	else
		# 如果文件不存在,同样输出警告信息
		echo -e "${RED}[!]未发现历史命令文件,请检查/root/.bash_history是否存在${NC}" 
	fi

	# 历史命令分析
	## 检查是否下载过脚本
	echo -e "${YELLOW}[+]检查是否下载过脚本[cat /root/.bash_history | grep -E '((wget|curl|yum|apt-get|python).*\.(sh|pl|py|exe)$)']:${NC}"
	scripts=$(cat /root/.bash_history | grep -E "((wget|curl|yum|apt-get|python).*\.(sh|pl|py|exe)$)" | grep -v grep)
	if [ -n "$scripts" ]; then
		(echo -e "${RED}[!]发现下载过脚本,请注意!${NC}" && echo "$scripts") 
	else
		echo -e "${YELLOW}[+]未发现下载过脚本${NC}" 
	fi

	## 检查是否通过主机下载/传输过文件
	echo -e "${YELLOW}[+]检查是否通过主机下载/传输过文件[cat /root/.bash_history | grep -E '(sz|rz|scp)']:${NC}"
	fileTransfer=$(cat /root/.bash_history | grep -E "(sz|rz|scp)" | grep -v grep)
	if [ -n "$fileTransfer" ]; then
		(echo -e "${RED}[!]发现通过主机下载/传输过文件,请注意!${NC}" && echo "$fileTransfer") 
	else
		echo -e "${YELLOW}[+]未发现通过主机下载/传输过文件${NC}" 
	fi

	## 检查是否增加/删除过账号
	echo -e "${YELLOW}[+]检查是否增加/删除过账号[cat /root/.bash_history | grep -E '(useradd|groupadd|userdel|groupdel)']:${NC}"
	addDelhistory=$(cat /root/.bash_history | grep -E "(useradd|groupadd|userdel|groupdel)" | grep -v grep)
	if [ -n "$addDelhistory" ]; then
		(echo -e "${RED}[!]发现增加/删除账号,请注意!${NC}" && echo "$addDelhistory") 
	else
		echo -e "${YELLOW}[+]未发现增加/删除账号${NC}" 
	fi

	## 检查是否存在黑客命令 
	echo -e "${YELLOW}[说明]匹配规则可自行维护,列表如下:id|whoami|ifconfig|whois|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|*proxy|msfconsole|msf|frp*|xray|*scan|mv|wget|curl|python*|yum|apt-get${NC}"
	hackCommand=$(cat /root/.bash_history | grep -E "id|whoami|ifconfig|whois|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|*proxy|msfconsole|msf|frp*|xray|*scan|mv|wget|curl|python*|yum|apt-get" | grep -v grep)
	if [ -n "$hackCommand" ]; then
		(echo -e "${RED}[!]发现黑客命令,请注意!${NC}" && echo "$hackCommand") 
	else
		echo -e "${YELLOW}[+]未发现黑客命令${NC}" 
	fi

	## 其他可疑命令[set +o history]等 例如 chattr 修改文件属性
	echo -e "${YELLOW}[+]检查是否存在黑客命令[cat /root/.bash_history | grep -E '(chattr|chmod|rm|set +o history)'${NC}"
	otherCommand=$(cat /root/.bash_history | grep -E "(chattr|chmod|rm|set +o history)" | grep -v grep)
	if [ -n "$otherCommand" ]; then
		(echo -e "${RED}[!]发现其他可疑命令,请注意!${NC}" && echo "$otherCommand") 
	else
		echo -e "${YELLOW}[+]未发现其他可疑命令${NC}" 
	fi

	# 检查历史记录目录,看是否被备份,注意：这里可以看开容器持久化的.bash_history
	echo -e "${YELLOW}[+]输出系统中所有可能的.bash_history*文件路径:${NC}"
	findOut=$(find / -name ".bash_history*" -type f -exec ls -l {} \;) # 输出所有.bash_history文件[包含容器]
	if [ -n "$findOut" ]; then
		echo -e "${YELLOW}以下历史命令文件如有未检查需要人工手动检查,有可能涵盖容器内 history 文件${NC}"
		(echo -e "${YELLOW}[+]系统中所有可能的.bash_history*文件如下:${NC}" && echo "$findOut") 
	else
		echo -e "${RED}[!]未发现系统中存在历史命令文件,请人工检查机器是否被清理攻击痕迹${NC}" 
	fi

	# 输出其他用户的历史命令[cat /[user]/.bash_history]
	# 使用awk处理/etc/passwd文件,提取用户名和主目录,并检查.bash_history文件
	echo -e "${YELLOW}[+]遍历系统用户并输出其的历史命令[cat /[user]/.bash_history]${NC}"
	awk -F: '{
		user=$1
		home=$6
		if (-f home"/.bash_history") {
			print "[----- History for User: "user" -----]"
			system("cat " home "/.bash_history")
			print ""
		}
	}' /etc/passwd
	printf "\n" 

	# 输出数据库操作历史命令
	echo -e "${YELLOW}正在检查数据库操作历史命令[/root/.mysql_history]:${NC}"  
	mysql_history=$(more /root/.mysql_history)
	if [ -n "$mysql_history" ];then
		(echo -e "${YELLOW}[+]数据库操作历史命令如下:${NC}" && echo "$mysql_history")  
	else
		echo -e "${YELLOW}+]未发现数据库历史命令${NC}"  
	fi
	printf "\n"  
}

# 用户信息排查【归档 -- systemCheck】
userInfoCheck(){
	echo -e "${YELLOW}[+]输出正在登录的用户:${NC}" && w  # 正在登录的用户 或者 who 都行
	echo -e "${YELLOW}[+]输出系统最后登录用户:${NC}" && last  # 系统最后登录用户
	# 检查用户信息/etc/passwd
	echo -e "${YELLOW}[+]检查用户信息[/etc/passwd]${NC}"
	echo -e "${YELLOW}[说明]用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell[共7个字段]${NC}"
	echo -e "${YELLOW}[+]show /etc/passwd:${NC}" && cat /etc/passwd
	# 检查可登录用户
	echo -e "${YELLOW}[+]检查可登录用户[cat /etc/passwd | grep -E '/bin/bash$' | awk -F: '{print \$1}']${NC}"
	loginUser=$(cat /etc/passwd  | grep -E "/bin/bash$" | awk -F: '{print $1}')
	if [ -n "$loginUser" ]; then
		echo -e "${RED}[!]发现可登录用户,请注意!${NC}" && echo "$loginUser"
	else
		echo -e "${YELLOW}[+]未发现可登录用户${NC}" 
	fi
	# 检查超级用户[除了 root 外的超级用户]
	echo -e "${YELLOW}[+]检查除root外超级用户[cat /etc/passwd | grep -v -E '^root|^#|^(\+:\*)?:0:0:::' | awk -F: '{if(\$3==0) print \$1}'] ${NC}"
	echo -e "${YELLOW}[说明]UID=0的为超级用户,系统默认root的UID为0 ${NC}"
	superUser=$(cat /etc/passwd | grep -v -E '^root|^#|^(\+:\*)?:0:0:::' | awk -F: '{if($3==0) print $1}')
	if [ -n "$superUser" ]; then
		echo -e "${RED}[!]发现其他超级用户,请注意!${NC}" && echo "$superUser"
	else
		echo -e "${YELLOW}[+]未发现超其他级用户${NC}" 
	fi
	# 检查克隆用户
	echo -e "${YELLOW}[+]检查克隆用户[awk -F: '{a[\$3]++}END{for(i in a)if(a[i]>1)print i}' /etc/passwd] ${NC}"
	echo -e "${YELLOW}[说明]UID相同为克隆用户${NC}"
	cloneUserUid=$(awk -F: '{a[$3]++}END{for(i in a)if(a[i]>1)print i}' /etc/passwd)
	if [ -n "$cloneUserUid" ]; then
		echo -e "${RED}[!]发现克隆用户,请注意!${NC}" && (cat /etc/passwd | grep $cloneUserUid | awk -F: '{print $1}') 
	else
		echo -e "${YELLOW}[+]未发现克隆用户${NC}" 
	fi
	# 检查非系统自带用户
	## 原理：从/etc/login.defs文件中读取系统用户UID的范围,然后从/etc/passwd文件中读取用户UID进行比对,找出非系统自带用户
	echo -e "${YELLOW}[+]检查非系统自带用户[awk -F: '{if (\$3>='\$defaultUid' && \$3!=65534) {print }}' /etc/passwd] ${NC}"
	echo -e "${YELLOW}[说明]从/etc/login.defs文件中读取系统用户UID的范围,然后从/etc/passwd文件中读取用户UID进行比对,UID在范围外的用户为非系统自带用户${NC}"
	if [ -f /etc/login.defs ]; then
		defaultUid=$(grep -E "^UID_MIN" /etc/login.defs | awk '{print $2}')
		noSystemUser=$(awk -F: '{if ($3>='$defaultUid' && $3!=65534) {print $1}}' /etc/passwd)
		if [ -n "$noSystemUser" ]; then
			echo -e "${RED}[!]发现非系统自带用户,请注意!${NC}" && echo "$noSystemUser"
		else
			echo -e "${YELLOW}[+]未发现非系统自带用户${NC}" 
		fi
	fi
	# 检查用户信息/etc/shadow
	# - 检查空口令用户
	echo -e "${YELLOW}[+]检查空口令用户[awk -F: '(\$2=="") {print \$1}' /etc/shadow] ${NC}"
	echo -e "${YELLOW}[说明]用户名:加密密码:最后一次修改时间:最小修改时间间隔:密码有效期:密码需要变更前的警告天数:密码过期后的宽限时间:账号失效时间:保留字段[共9个字段]${NC}"
	echo -e "${YELLOW}[+]show /etc/shadow:${NC}" && cat /etc/shadow 
	echo -e "${YELLOW}[原理]shadow文件中密码字段(第2个字段)为空的用户即为空口令用户 ${NC}"
	emptyPasswdUser=$(awk -F: '($2=="") {print $1}' /etc/shadow)
	if [ -n "$emptyPasswdUser" ]; then
		echo -e "${RED}[!]发现空口令用户,请注意!${NC}" && echo "$emptyPasswdUser"
	else
		echo -e "${YELLOW}[+]未发现空口令用户${NC}" 
	fi
	# - 检查空口令且可登录SSH的用户
	# 原理:
	# 1. 从`/etc/passwd`文件中提取使用`/bin/bash`作为shell的用户名。--> 可登录的用户
	# 2. 从`/etc/shadow`文件中获取密码字段为空的用户名。  --> 空密码的用户
	# 3. 检查`/etc/ssh/sshd_config`中SSH服务器配置是否允许空密码。 --> ssh 是否允许空密码登录
	# 4. 遍历步骤1中获取的每个用户名,并检查其是否与步骤2中获取的任何用户名匹配,并且根据步骤3是否允许空密码进行判断。如果存在匹配,则打印通知,表示存在空密码且允许登录的用户。
	# 5. 最后,根据是否找到匹配,打印警告消息,要求人工分析配置和账户,或者打印消息表示未发现空口令且可登录的用户。
	##允许空口令用户登录方法
	##1.passwd -d username
	##2.echo "PermitEmptyPasswords yes" >>/etc/ssh/sshd_config
	##3.service sshd restart
	echo -e "${YELLOW}[+]检查空口令且可登录SSH的用户[/etc/passwd|/etc/shadow|/etc/ssh/sshd_config] ${NC}"
	userList=$(cat /etc/passwd  | grep -E "/bin/bash$" | awk -F: '{print $1}')
	noSetPwdUser=$(awk -F: '($2=="") {print $1}' /etc/shadow)
	isSSHPermit=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
	flag=""
	for userA in $userList; do
		for userB in $noSetPwdUser; do
			if [ "$userA" == "$userB" ]; then
				if [ -n "$isSSHPermit" ]; then
					echo -e "${RED}[!]发现空口令且可登录SSH的用户,请注意!${NC}" && echo "$userA"
					flag="1"
				else
					echo -e "${YELLOW}[+]发现空口令且不可登录SSH的用户,请注意!${NC}" && echo "$userA"
				fi
			fi
		done
	done
	if [ -n "$flag" ]; then
		echo -e "${YELLOW}[+]未发现空口令且可登录SSH的用户${NC}" 
	fi
	# - 检查口令未加密用户
	echo -e "${YELLOW}[+]检查未加密口令用户[awk -F: '{if(\$2!="x") {print \$1}}' /etc/passwd] ${NC}"
	noEncryptPasswdUser=$(awk -F: '{if($2!="x") {print $1}}' /etc/passwd)
	if [ -n "$noEncryptPasswdUser" ]; then
		echo -e "${RED}[!]发现未加密口令用户,请注意!${NC}" && echo "$noEncryptPasswdUser"
	else
		echo -e "${YELLOW}[+]未发现未加密口令用户${NC}" 
	fi
	# 检查用户组信息/etc/group
	echo -e "${YELLOW}[+]检查用户组信息[/etc/group] ${NC}"
	echo -e "${YELLOW}[说明]组名:组密码:GID:组成员列表[共4个字段] ${NC}"
	echo -e "${YELLOW}[+]show /etc/group:${NC}" && cat /etc/group
	# - 检查特权用户组[除root组之外]
	echo -e "${YELLOW}[+]检查特权用户组[cat /etc/group | grep -v '^#' | awk -F: '{if (\$1!="root"&&\$3==0) print \$1}'] ${NC}"
	echo -e "${YELLOW}[说明]GID=0的为超级用户组,系统默认root组的GID为0 ${NC}"
	privGroupUsers=$(cat /etc/group | grep -v '^#' | awk -F: '{if ($1!="root"&&$3==0) print $1}')
	if [ -n "$privGroupUsers" ]; then
		echo -e "${RED}[!]发现特权用户组,请注意!${NC}" && echo "$privGroupUsers"
	else
		echo -e "${YELLOW}[+]未发现特权用户组${NC}" 
	fi
	# - 检查相同GID的用户组
	echo -e "${YELLOW}[+]检查相同GID的用户组[cat /etc/group | grep -v '^#' | awk -F: '{print \$3}' | uniq -d] ${NC}"
	groupUid=$(cat /etc/group | grep -v "^$" | awk -F: '{print $3}' | uniq -d)
	if [ -n "$groupUid" ];then
		echo -e "${RED}[!]发现相同GID用户组:${NC}" && echo "$groupUid"
	else
		echo -e "${YELLOW}[+]未发现相同GID的用户组${NC}" 
	fi
	# - 检查相同用户组名
	echo -e "${YELLOW}[+]检查相同用户组名[cat /etc/group | grep -v '^$' | awk -F: '{print \$1}' | uniq -d] ${NC}"
	groupName=$(cat /etc/group | grep -v "^$" | awk -F: '{print $1}' | uniq -d)
	if [ -n "$groupName" ];then
		echo -e "${RED}发现相同用户组名:${NC}" && echo "$groupName"
	else
		echo -e "${YELLOW}[+]未发现相同用户组名${NC}" 
	fi
	printf "\n" 
}

# 系统信息排查【完成】   
systemCheck(){
	# 基础信息排查 baseInfo
	baseInfo
	# 用户信息排查 userInfoCheck
	userInfoCheck
	# 计划任务排查 crontabCheck
	crontabCheck
	# 历史命令排查 historyCheck
	historyCheck
}

# 系统自启动服务分析【归档 -- systemServiceCheck】
systemEnabledServiceCheck(){
	# 系统自启动项服务分析
	## 检查老版本机器的特殊文件/etc/rc.local /etc/init.d/* [/etc/init.d/* 和 chkconfig --list 命令一样]
	## 有些用户自启动配置在用户的.bashrc/.bash_profile/.profile/.bash_logout等文件中
	## 判断系统的初始化程序[sysvinit|systemd|upstart(弃用)]
	echo -e "${YELLOW}[+]正在检查自启动服务信息:${NC}"
	echo -e "${YELLOW}[+]正在辨认系统使用的初始化程序${NC}"
	systemInit=$((cat /proc/1/comm)|| (cat /proc/1/cgroup | grep -w "name=systemd" | awk -F : '{print $2}' | awk -F = '{print $2}')) # 多文件判断
	if [ -n "$systemInit" ];then
		echo -e "${YELLOW}[+]系统初始化程序为:$systemInit ${NC}"
		if [ "$systemInit" == "systemd" ];then
			echo -e "${YELLOW}[+]正在检查systemd自启动项[systemctl list-unit-files]:${NC}"
			systemd=$(systemctl list-unit-files | grep -E "enabled" )   # 输出启动项
			systemdList=$(systemctl list-unit-files | grep -E "enabled" | awk '{print $1}') # 输出启动项名称列表
			if [ -n "$systemd" ];then
				echo -e "${YELLOW}[+]systemd自启动项:${NC}" && echo "$systemd"
				# 分析系统启动项 【这里只是启动服务项,不包括其他服务项,所以在这里检查不完整,单独检查吧】
				# 分析systemd启动项
				echo -e "${YELLOW}[+]正在分析危险systemd启动项[systemctl list-unit-files]:${NC}"
				echo -e "${YELLOW}[说明]根据服务名称找到服务文件位置[systemctl show xx.service -p FragmentPath]${NC}"
				echo -e "${YELLOW}[说明]根据服务文件位置找到服务文件并匹配敏感命令${NC}"
				# 循环
				for service in $systemdList; do
					echo -e "${YELLOW}[+]正在分析systemd启动项:$service${NC}"
					# 根据服务名称找到服务文件位置
					servicePath=$(systemctl show $service -p FragmentPath | awk -F "=" '{print $2}')  # 文件不存在的时候程序会中断 --- 20240808
					if [ -n "$servicePath" ];then  # 判断文件是否存在
						echo -e "${YELLOW}[+]找到service服务文件位置:$servicePath${NC}"
						dangerService=$(grep -E "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))" $servicePath)
						if [ -n "$dangerService" ];then
							echo -e "${RED}[!]发现systemd启动项:${service}包含敏感命令或脚本:${NC}" && echo "$dangerService"
						else
							echo -e "${YELLOW}[+]未发现systemd启动项:${service}包含敏感命令或脚本${NC}" 
						fi
					else
						echo -e "${RED}[!]未找到service服务文件位置:$service${NC}"
					fi
				done			

			else
				echo -e "${RED}[!]未发现systemd自启动项${NC}" 
			fi
		elif [ "$systemInit" == "init" ];then
			echo -e "${YELLOW}[+]正在检查init自启动项[chkconfig --list]:${NC}"  # [chkconfig --list实际查看的是/etc/init.d/下的服务]
			init=$(chkconfig --list | grep -E ":on|启用" )
			# initList=$(chkconfig --list | grep -E ":on|启用" | awk '{print $1}')
			if [ -n "$init" ];then
				echo -e "${YELLOW}[+]init自启动项:${NC}" && echo "$init"
				# 如果系统使用的是systemd启动,这里会输出提示使用systemctl list-unit-files的命令
				# 分析sysvinit启动项
				echo -e "${YELLOW}[+]正在分析危险init自启动项[chkconfig --list| awk '{print \$1}' | grep -E '\.(sh|pl|py|exe)$']:${NC}"
				echo -e "${YELLOW}[说明]只根据服务启动名后缀检查可疑服务,并未匹配服务文件内容${NC}"
				dangerServiceInit=$(chkconfig --list| awk '{print $1}' | grep -E "\.(sh|pl|py|exe)$") 
				if [ -n "$dangerServiceInit" ];then
					echo -e "${RED}[!]发现敏感init自启动项:${NC}" && echo "$dangerServiceInit"
				else
					echo -e "${YELLOW}[+]未发现敏感init自启动项:${NC}" 
				fi

			else
				echo -e "${RED}[!]未发现init自启动项${NC}" 
			fi
		else
			echo -e "${RED}[!]系统使用初始化程序本程序不适配,请手动检查${NC}"
			echo -e "${YELLOW}[说明]如果系统使用初始化程序不[sysvinit|systemd]${NC}"
		fi
	else
		echo -e "${RED}[!]未识别到系统初始化程序,请手动检查${NC}"
	fi
}

# 系统运行服务分析【归档 -- systemServiceCheck】
systemRunningServiceCheck(){
	# 系统正在运行服务分析
	echo -e "${YELLOW}[+]正在检查正在运行中服务:${NC}"
	# systemRunningService=$(systemctl | grep -E "\.service.*running")

	echo -e "${YELLOW}[+]正在辨认系统使用的初始化程序${NC}"
	systemInit=$((cat /proc/1/comm)|| (cat /proc/1/cgroup | grep -w "name=systemd" | awk -F : '{print $2}' | awk -F = '{print $2}')) # 多文件判断
	if [ -n "$systemInit" ];then
		echo -e "${YELLOW}[+]系统初始化程序为:$systemInit ${NC}"
		if [ "$systemInit" == "systemd" ];then
			echo -e "${YELLOW}[+]正在检查systemd运行中服务项[systemctl | grep -E '\.service.*running']:${NC}"
			# systemd=$(systemctl list-unit-files | grep -E "enabled" )   # 输出启动项
			systemRunningService=$(systemctl | grep -E "\.service.*running")
			# systemdList=$(systemctl list-unit-files | grep -E "enabled" | awk '{print $1}') # 输出启动项名称列表
			systemRunningServiceList=$(systemctl | grep -E "\.service.*running" | awk '{print $1}')  # 输出启动项名称列表
			if [ -n "$systemRunningService" ];then
				echo -e "${YELLOW}[+]systemd正在运行中服务项:${NC}" && echo "$systemRunningService"
				# 分析系统启动项 【这里只是运行中服务项,不包括其他服务项,所以在这里检查不完整,单独检查吧】
				# 分析systemd运行中的服务
				echo -e "${YELLOW}[+]正在分析危险systemd运行中服务项[systemctl list-unit-files]:${NC}"
				echo -e "${YELLOW}[说明]根据服务名称找到服务文件位置[systemctl show xx.service -p FragmentPath]${NC}"
				echo -e "${YELLOW}[说明]根据服务文件位置找到服务文件并匹配敏感命令${NC}"
				# 循环
				for service in $systemRunningServiceList; do
					echo -e "${YELLOW}[+]正在分析systemd运行中服务项:$service${NC}"
					# 根据服务名称找到服务文件位置
					servicePath=$(systemctl show $service -p FragmentPath | awk -F "=" '{print $2}')  # 文件不存在的时候程序会中断 --- 20240808
					if [ -n "$servicePath" ];then  # 判断文件是否存在
						echo -e "${YELLOW}[+]找到service服务文件位置:$servicePath${NC}"
						dangerService=$(grep -E "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))" $servicePath)
						if [ -n "$dangerService" ];then
							echo -e "${RED}[!]发现systemd运行中服务项:${service}包含敏感命令或脚本:${NC}" && echo "$dangerService"
						else
							echo -e "${YELLOW}[+]未发现systemd运行中服务项:${service}包含敏感命令或脚本${NC}" 
						fi
					else
						echo -e "${RED}[!]未找到service服务文件位置:$service${NC}"
					fi
				done			

			else
				echo -e "${RED}[!]未发现systemd运行中服务项${NC}" 
			fi
		else
			echo -e "${RED}[!]系统使用初始化程序本程序不适配,请手动检查${NC}"
			echo -e "${YELLOW}[说明]如果系统使用初始化程序不[sysvinit|systemd]${NC}"
		fi
	else
		echo -e "${RED}[!]未识别到系统初始化程序,请手动检查${NC}"
	fi
}

# 系统服务收集【归档 -- systemServiceCheck】
systemServiceCollect(){
	# 收集所有的系统服务信息,不做分析
	echo -e "${YELLOW}[+]正在收集系统服务信息(不含威胁分析):${NC}"
	echo -e "${YELLOW}[说明]根据服务名称找到服务文件位置[systemctl show xx.service -p FragmentPath]${NC}"
	echo -e "${YELLOW}[+]正在辨认系统使用的初始化程序${NC}"
	systemInit=$((cat /proc/1/comm)|| (cat /proc/1/cgroup | grep -w "name=systemd" | awk -F : '{print $2}' | awk -F = '{print $2}')) # 多文件判断
	if [ -n "$systemInit" ];then
		echo -e "${YELLOW}[+]系统初始化程序为:$systemInit ${NC}"
		if [ "$systemInit" == "systemd" ];then
			echo -e "${YELLOW}[+]正在收集systemd系统服务项[systemctl list-unit-files]:${NC}"
			systemd=$(systemctl list-unit-files)   # 输出启动项
			if [ -n "$systemd" ];then
				echo -e "${YELLOW}[+]systemd系统服务项如下:${NC}" && echo "$systemd"		
			else
				echo -e "${RED}[!]未发现systemd系统服务项${NC}" 
			fi
		elif [ "$systemInit" == "init" ];then
			echo -e "${YELLOW}[+]正在检查init系统服务项[chkconfig --list]:${NC}"  # [chkconfig --list实际查看的是/etc/init.d/下的服务]
			init=$(chkconfig --list )
			# initList=$(chkconfig --list | grep -E ":on|启用" | awk '{print $1}')
			if [ -n "$init" ];then
				echo -e "${YELLOW}[+]init系统服务项:${NC}" && echo "$init"
				# 如果系统使用的是systemd启动,这里会输出提示使用systemctl list-unit-files的命令
			else
				echo "[!]未发现init系统服务项" 
			fi
		else
			echo -e "${RED}[!]系统使用初始化程序本程序不适配,请手动检查${NC}"
			echo -e "${YELLOW}[说明]如果系统使用初始化程序不[sysvinit|systemd]${NC}"
		fi
	else
		echo -e "${RED}[!]未识别到系统初始化程序,请手动检查${NC}"
	fi
}

# 用户服务分析【归档 -- systemServiceCheck】
userServiceCheck(){
	# 用户自启动项服务分析 /etc/rc.d/rc.local /etc/init.d/*
	## 输出 /etc/rc.d/rc.local
	# 【判断是否存在】
	echo -e "${YELLOW}[+]正在检查/etc/rc.d/rc.local是否存在:${NC}"
	if [ -f "/etc/rc.d/rc.local" ];then
		echo -e "${YELLOW}[+]/etc/rc.d/rc.local存在${NC}"
		echo -e "${YELLOW}[+]正在检查/etc/rc.d/rc.local用户自启动服务:${NC}"
		rcLocal=$(cat /etc/rc.d/rc.local)
		if [ -n "$rcLocal" ];then
			echo -e "${YELLOW}[+]/etc/rc.d/rc.local用户自启动项服务如下:${NC}" && echo "$rcLocal"
		else
			echo -e "${RED}[!]未发现/etc/rc.d/rc.local用户自启动服务${NC}"
		fi

		## 分析 /etc/rc.d/rc.local
		echo -e "${YELLOW}[+]正在分析/etc/rc.d/rc.local用户自启动服务:${NC}"
		dangerRclocal=$(grep -E "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))" /etc/rc.d/rc.local)
		if [ -n "$dangerRclocal" ];then
			echo -e "${RED}[!]发现/etc/rc.d/rc.local用户自启动服务包含敏感命令或脚本:${NC}" && echo "$dangerRclocal"
		else
			echo -e "${YELLOW}[+]未发现/etc/rc.d/rc.local用户自启动服务包含敏感命令或脚本${NC}" 
		fi
	else
		echo -e "${RED}[!]/etc/rc.d/rc.local不存在${NC}"
	fi

	## 分析 /etc/init.d/*
	echo -e "${YELLOW}[+]正在检查/etc/init.d/*用户自启动服务:${NC}"
	dangerinitd=$(egrep "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))"  /etc/init.d/*)
	if [ -n "$dangerinitd" ];then
		(echo -e "${RED}[!]发现/etc/init.d/用户危险自启动服务:${NC}" && echo "$dangerinitd") 
	else
		echo -e "${YELLOW}[+]未发现/etc/init.d/用户危险自启动服务${NC}" 
	fi

	# 有些用户自启动配置在用户的.bashrc|.bash_profile|.profile|.bash_logout|.viminfo 等文件中
	# 检查给定用户的配置文件中是否存在敏感命令或脚本
	check_files() {
		local user=$1
		local home_dir="/home/$user"
		# 特殊处理 root 用户
		if [ "$user" = "root" ]; then
			home_dir="/root"
		fi

		local files=(".bashrc" ".bash_profile" ".profile" ".bash_logout" ".zshrc" ".viminfo")  # 定义检查的配置文件列表
		for file in "${files[@]}"; do
			if [ -f "$home_dir/$file" ]; then  # $home_dir/$file
				echo -e "${YELLOW}[+]正在检查用户: $user 的 $file 文件: ${NC}"
				local results=$(grep -E "((chmod|useradd|groupadd|chattr)|((rm|wget|curl)*\.(sh|pl|py|exe)$))" "$home_dir/$file")
				if [ -n "$results" ]; then
					echo -e "${RED}[+]用户: $user 的 $file 文件存在敏感命令或脚本:${NC}" && echo "$results"
				else
					echo -e "${YELLOW}[+]用户: $user 的 $file 文件不存在敏感命令或脚本${NC}"
				fi
			else
				echo -e "${YELLOW}[+]用户: $user 的 $file 文件不存在${NC}"
			fi
		done
	}

	# 获取所有用户
	for user in $(cut -d: -f1 /etc/passwd); do
		echo -e "${YELLOW}[+]正在检查用户: $user 的自启动服务(.bashrc|.bash_profile|.profile):${NC}"
		check_files "$user"
	done
}

# 系统服务排查 【归档 -- fileCheck】
systemServiceCheck(){
	# 系统服务收集  systemServiceCollect
	systemServiceCollect
	# 系统服务分析
	# - 系统自启动服务分析    systemEnabledServiceCheck
	systemEnabledServiceCheck
	# - 系统正在运行服务分析   systemRunningServiceCheck
	systemRunningServiceCheck
	# 用户服务收集
	# 用户服务分析  userServiceCheck
	userServiceCheck
}

# 敏感目录排查(包含隐藏文件)【归档 -- fileCheck】
dirFileCheck(){
	# /tmp/下
	echo -e "${YELLOW}[+]正在检查/tmp/下文件[ls -alt /tmp]:${NC}"
	echo -e "${YELLOW}[[说明]tmp目录是用于存放临时文件的目录,可用于存放木马文件,可用于存放病毒文件,可用于存放破解文件${NC}"
	tmp_tmp=$(ls -alt /tmp)
	if [ -n "$tmp_tmp" ];then
		echo -e "${YELLOW}[+]/tmp/下文件如下:${NC}" && echo "$tmp"
	else
		echo -e "${RED}[!]未发现/tmp/下文件${NC}"
	fi

	# /root下隐藏文件分析
	echo -e "${YELLOW}[+]正在检查/root/下隐藏文件[ls -alt /root]:${NC}"
	echo -e "${YELLOW}[说明]隐藏文件以.开头,可用于存放木马文件,可用于存放病毒文件,可用于存放破解文件${NC}"  
	root_tmp=$(ls -alt /root)
	if [ -n "$root_tmp" ];then
		echo -e "${YELLOW}[+]/root下隐藏文件如下:${NC}" && echo "$root_tmp"
	else
		echo -e "${RED}[!]未发现/root下隐藏文件${NC}"
	fi

	# 其他
	
}

# SSH登录配置排查 【归档 -- specialFileCheck】
sshFileCheck(){
	# 输出/root/.ssh/下文件
	echo -e "${YELLOW}[+]正在检查/root/.ssh/下文件[ls -alt /root/.ssh]:${NC}"
	ls_ssh=$(ls -alt /root/.ssh)
	if [ -n "$ls_ssh" ];then
		echo -e "${YELLOW}[+]/root/.ssh/下文件如下:${NC}" && echo "$ls_ssh"
	else
		echo -e "${RED}[!]未发现/root/.ssh/存在文件${NC}"
	fi
	printf "\n"

	# 公钥文件分析
	echo -e "${YELLOW}正在检查公钥文件[/root/.ssh/*.pub]:${NC}"
	pubkey=$(cat /root/.ssh/*.pub)
	if [ -n "$pubkey" ];then
		echo -e "${RED}[!]发现公钥文件如下,请注意!${NC}" && echo "$pubkey"
	else
		echo -e "${YELLOW}[+]未发现公钥文件${NC}"
	fi
	printf "\n"

	# 私钥文件分析
	echo -e "${YELLOW}正在检查私钥文件[/root/.ssh/id_rsa]:${NC}" 
	echo -e "${YELLOW}[说明]私钥文件是用于SSH密钥认证的文件,私钥文件不一定叫id_rs,登录方式[ssh -i id_rsa user@ip]${NC}"
	privatekey=$(cat /root/.ssh/id_rsa)
	if [ -n "$privatekey" ];then
		echo -e "${RED}[!]发现私钥文件,请注意!${NC}" && echo "$privatekey"
	else
		echo -e "${YELLOW}[+]未发现私钥文件${NC}"
	fi
	printf "\n" 

	# authorized_keys文件分析
	echo -e "${YELLOW}正在检查被授权登录公钥信息[/root/.ssh/authorized_keys]:${NC}" 
	echo -e "${YELLOW}[说明]authorized_keys文件是用于存储用户在远程登录时所被允许的公钥,可定位谁可以免密登陆该主机" 
	echo -e "${YELLOW}[说明]免密登录配置中需要将用户公钥内容追加到authorized_keys文件中[cat id_rsa.pub >> authorized_keys]"
	authkey=$(cat /root/.ssh/authorized_keys)
	if [ -n "$authkey" ];then
		echo -e "${RED}[!]发现被授权登录的用户公钥信息如下${NC}" && echo "$authkey"
	else
		echo -e "${YELLOW}[+]未发现被授权登录的用户公钥信息${NC}" 
	fi
	printf "\n" 

	# known_hosts文件分析
	echo -e "${YELLOW}正在检查当前设备可登录主机信息[/root/.ssh/known_hosts]:${NC}" 
	echo -e "${YELLOW}[说明]known_hosts文件是用于存储SSH服务器公钥的文件,可用于排查当前主机可横向范围,快速定位可能感染的主机${NC}" 
	knownhosts=$(cat /root/.ssh/known_hosts | awk '{print $1}')
	if [ -n "$knownhosts" ];then
		echo -e "${RED}[!]发现可横向远程主机信息如下:${NC}" && echo "$knownhosts"
	else
		echo -e "${YELLOW}[+]未发现可横向远程主机信息${NC}" 
	fi
	printf "\n" 


	# sshd_config 配置文件分析
	echo -e "${YELLOW}正在检查SSHD配置文件[/etc/ssh/sshd_config]:${NC}" 
	echo -e "${YELLOW}正在输出SSHD文件所有开启配置(不带#号的配置)[/etc/ssh/sshd_config]:"
	sshdconfig=$(cat /etc/ssh/sshd_config | egrep -v "#|^$")
	if [ -n "$sshdconfig" ];then
		echo -e "${YELLOW}[+]sshd_config所有开启的配置如下:${NC}" && echo "$sshdconfig" 
	else
		echo -e "${YELLOW}[!]未发现sshd_config开启任何配置!请留意这是异常现象!${NC}" 
	fi
	printf "\n" 

	## sshd_config 配置文件分析 -- 允许空口令登录分析
	echo -e "${YELLOW}正在检查sshd_config配置--允许SSH空口令登录[/etc/ssh/sshd_config]:${NC}" 
	emptypasswd=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
	nopasswd=$(awk -F: '($2=="") {print $1}' /etc/shadow)
	if [ -n "$emptypasswd" ];then
		echo -e "${RED}[!]发现允许空口令登录,请注意!${NC}"
		if [ -n "$nopasswd" ];then
			echo -e "${RED}[!]以下用户空口令:${NC}" && echo "$nopasswd"
		else
			echo -e "${RED}[+]但未发现空口令用户${NC}" 
		fi
	else
		echo -e "${YELLOW}[+]不允许空口令用户登录${NC}" 
	fi
	printf "\n" 

	## sshd_config 配置文件分析 -- root远程登录分析
	echo -e "${YELLOW}正在检查sshd_config配置--允许SSH远程root登录[/etc/ssh/sshd_config]:${NC}" 
	rootRemote=$(cat /etc/ssh/sshd_config | grep -v ^# | grep "PermitRootLogin yes")
	if [ -n "$rootRemote" ];then
		echo -e "${RED}[!]发现允许root远程登录,请注意!${NC}"
		echo -e "${RED}[!]请修改/etc/ssh/sshd_config配置文件,添加PermitRootLogin no${NC}"
	else
		echo -e "${YELLOW}[+]不允许root远程登录${NC}" 
	fi
	printf "\n" 

	## sshd_config 配置文件分析 -- ssh协议版本分析
	echo -e "${YELLOW}正在检查sshd_config配置--检查SSH协议版本[/etc/ssh/sshd_config]:${NC}" 
	echo -e "${YELLOW}[说明]需要详细的SSH版本信息另行检查,防止SSH协议版本过低,存在漏洞"
	echo -e "${YELLOW}[说明]从OpenSSH7.0开始,已经默认使用SSH协议2版本,只有上古机器这项会不合格${NC}"
	protocolver=$(cat /etc/ssh/sshd_config | grep -v ^$ | grep Protocol | awk '{print $2}')
	if [ -n "$protocolver" ];then
		echo -e "${YELLOW}[+]openssh协议版本如下:${NC}" && echo "$protocolver"
		if [ "$protocolver" -eq "2" ];then
			echo -e "${RED}[+]openssh使用ssh2协议,版本过低!${NC}" 
		fi
	else
		echo -e "${YELLOW}[!]未发现openssh协议版本(未发现并非代表异常)${NC}"
	fi

	# ssh版本分析 -- 罗列几个有漏洞的ssh版本
	echo -e "${YELLOW}正在检查SSH版本[ssh -V]:${NC}"
	sshver=$(ssh -V)
	echo -e "${YELLOW}[+]ssh版本信息如下:${NC}" && echo "$sshver"

	# 上述光检测了root账户下的相关文件的信息，需要增加机器上其他账号的相关文件检测，比如/home/test/.ssh/authorized_keys 等文件 --- 20250708
	# 其他
}


# 检查最近变动文件的函数 
checkRecentModifiedFiles() {
	# 功能: 检查指定时间范围内变动的文件,支持敏感文件和所有文件两种模式
	# 参数1: 时间范围(小时数,默认24)
	# 参数2: 检查类型(sensitive|all,默认sensitive)
	# 使用示例:
	#   checkRecentModifiedFiles                    # 检查最近24小时内的敏感文件
	#   checkRecentModifiedFiles 48                 # 检查最近48小时内的敏感文件
	#   checkRecentModifiedFiles 24 "sensitive"     # 检查最近24小时内的敏感文件
	#   checkRecentModifiedFiles 24 "all"          # 检查最近24小时内的所有文件
	local time_hours=${1:-24}  # 默认24小时
	local check_type=${2:-"sensitive"}  # 默认检查敏感文件
	
	echo -e "${YELLOW}正在检查最近${time_hours}小时内变动的文件:${NC}"
	
	# 定义排除目录列表
	local EXCLUDE_DIRS=(
		"/proc/*"
		"/dev/*"
		"/sys/*"
		"/run/*"
		"/tmp/systemd-private-*"
		"*/node_modules/*"
		"*/.cache/*"
		"*/site-packages/*"
		"*/.vscode-server/*"
		"*/cache/*"
		"*.log"
	)
	
	# 定义敏感文件后缀列表
	local SENSITIVE_EXTENSIONS=(
		"*.py"
		"*.sh"
		"*.per"
		"*.pl"
		"*.php"
		"*.asp"
		"*.jsp"
		"*.exe"
		"*.jar"
		"*.war"
		"*.class"
		"*.so"
		"*.elf"
		"*.txt"
	)
	
	# 计算mtime参数 (小时转换为天数的分数)
	local mtime_param
	if [ "$time_hours" -le 24 ]; then
		mtime_param="-1"  # 24小时内
	else
		local days=$((time_hours / 24))
		mtime_param="-${days}"
	fi
	
	# 构建find命令的排除条件
	local exclude_conditions=()
	for exclude_dir in "${EXCLUDE_DIRS[@]}"; do
		exclude_conditions+=("-not" "-path" "$exclude_dir")
	done
	
	if [ "$check_type" = "sensitive" ]; then
		echo -e "${YELLOW}[说明] 检查敏感文件类型: ${SENSITIVE_EXTENSIONS[*]}${NC}"
		echo -e "${YELLOW}[注意] 排除目录: ${EXCLUDE_DIRS[*]}${NC}"
		
		# 构建文件扩展名条件
		local extension_conditions=()
		for i in "${!SENSITIVE_EXTENSIONS[@]}"; do
			extension_conditions+=("-name" "${SENSITIVE_EXTENSIONS[$i]}")
			if [ $i -lt $((${#SENSITIVE_EXTENSIONS[@]}-1)) ]; then
				extension_conditions+=("-o")
			fi
		done
		
		# 执行find命令查找敏感文件
		local find_result
		find_result=$(find / "${exclude_conditions[@]}" -mtime "$mtime_param" -type f \( "${extension_conditions[@]}" \) 2>/dev/null)
		
		if [ -n "$find_result" ]; then
			echo -e "${RED}[!]发现最近${time_hours}小时内变动的敏感文件:${NC}"
			echo "$find_result"
		else
			echo -e "${YELLOW}[+]未发现最近${time_hours}小时内变动的敏感文件${NC}"
		fi
		
	elif [ "$check_type" = "all" ]; then
		echo -e "${YELLOW}[说明] 检查所有文件类型${NC}"
		echo -e "${YELLOW}[注意] 排除目录: ${EXCLUDE_DIRS[*]}${NC}"
		
		# 执行find命令查找所有文件
		local find_result_all
		find_result_all=$(find / "${exclude_conditions[@]}" -type f -mtime "$mtime_param" 2>/dev/null)
		
		if [ -n "$find_result_all" ]; then
			echo -e "${RED}[!]发现最近${time_hours}小时内变动的所有文件:${NC}"
			echo "$find_result_all"
		else
			echo -e "${YELLOW}[+]未发现最近${time_hours}小时内变动的文件${NC}"
		fi
	else
		echo -e "${RED}[!]错误: 不支持的检查类型 '$check_type',支持的类型: sensitive, all${NC}"
		return 1
	fi
	
	printf "\n"
}


# 特殊文件排查【归档 -- fileCheck】
specialFileCheck(){
	# SSH相关文件排查 -- 调用检查函数 sshFileCheck
	echo -e "${YELLOW}[+]正在检查SSH相关文件[Fuc:sshFileCheck]:${NC}"
	sshFileCheck
	
	# 环境变量分析
	echo -e "${YELLOW}[+]正在检查环境变量文件[.bashrc|.bash_profile|.zshrc|.viminfo等]:${NC}" 
	echo -e "${YELLOW}[说明]环境变量文件是用于存放用户环境变量的文件,可用于后门维持留马等(需要人工检查有无权限维持痕迹)${NC}" 
	env_file="/root/.bashrc /root/.bash_profile /root/.zshrc /root/.viminfo /etc/profile /etc/bashrc /etc/environment"
	for file in $env_file;do
		if [ -e $file ];then
			echo -e "${YELLOW}[+]环境变量文件:$file${NC}"
			more $file
			printf "\n"
			# 文件内容中是否包含关键字 curl http https wget 等关键字
			if [ -n "$(more $file | grep -E "curl|wget|http|https|python")" ];then
				echo -e "${RED}[!]发现环境变量文件[$file]中包含curl|wget|http|https|python等关键字!${NC}" 
			fi 
		else
			echo -e "${YELLOW}[+]未发现环境变量文件:$file${NC}"
		fi
	done
	printf "\n"

	## 环境变量env命令分析
	echo -e "${YELLOW}[+]正在检查环境变量命令[env]:${NC}"
	env_tmp=$(env)
	if [ -n "$env_tmp" ];then
		echo -e "${YELLOW}[+]环境变量命令结果如下:${NC}" && echo "$env_tmp"
	else
		echo -e "${RED}[!]未发现环境变量命令结果${NC}"
	fi
	printf "\n"

	# hosts文件分析
	echo -e "${YELLOW}[+]正在检查hosts文件[/etc/hosts]:${NC}"
	hosts_tmp=$(cat /etc/hosts)
	if [ -n "$hosts_tmp" ];then
		echo -e "${YELLOW}[+]hosts文件如下:${NC}" && echo "$hosts_tmp"
	else
		echo -e "${RED}[!]未发现hosts文件${NC}"
	fi
	printf "\n"

	# shadow文件分析
	echo -e "${YELLOW}[+]正在检查shadow文件[/etc/shadow]:${NC}"
	shadow_tmp=$(cat /etc/shadow)
	if [ -n "$shadow_tmp" ];then
		# 输出 shadow 文件内容
		echo -e "${YELLOW}[+]shadow文件如下:${NC}" && echo "$shadow_tmp"
	else
		echo -e "${RED}[!]未发现shadow文件${NC}"
	fi
	printf "\n"

	## gshadow文件分析
	echo -e "${YELLOW}[+]正在检查gshadow文件[/etc/gshadow]:${NC}"
	gshadow_tmp=$(cat /etc/gshadow)
	if [ -n "$gshadow_tmp" ];then
		# 输出 gshadow 文件内容
		echo -e "${YELLOW}[+]gshadow文件如下:${NC}" && echo "$gshadow_tmp"
	else
		echo -e "${RED}[!]未发现gshadow文件${NC}"
	fi
	printf "\n"

	# 24小时内修改文件分析 - 使用新的函数checkRecentModifiedFiles
	echo -e "${YELLOW}[+]正在检查最近变动的文件(默认24小时内新增/修改):${NC}"
	# 检查敏感文件(默认24小时)
	checkRecentModifiedFiles 24 "sensitive"
	# 检查所有文件(默认24小时)
	checkRecentModifiedFiles 24 "all"

	# SUID/SGID Files 可用于提权 
	## SUID(Set User ID) 文件是一种特殊权限文件,它允许文件拥有者以root权限运行,而不需要root权限。
	## SGID(Set Group ID) 文件是一种特殊权限文件,任何用户运行该文件时都会以文件所属组的权限执行,对于目录,SGID目录下创建的文件会继承该组的权限。
	echo -e "${YELLOW}[+]正在检查SUID/SGID文件:${NC}"
	echo -e "${YELLOW}[注意]如果SUID/SGID文件同时出现在最近24H变换检测中,说明机器有极大概率已经中招${NC}"
	find_suid=$(find / -type f -perm -4000)
	if [ -n "$find_suid" ];then
		echo -e "${YELLOW}[+]SUID文件如下:${NC}" && echo "$find_suid"
	fi

	find_sgid=$(find / -type f -perm -2000)
	if [ -n "$find_sgid" ];then
		echo -e "${YELLOW}[+]SGID文件如下:${NC}" && echo "$find_sgid"
	fi

	# 其他
}

# 系统日志分析【归档 -- fileCheck】
systemLogCheck(){
	# 1 系统有哪些日志类型 [ls /var/log/]
	echo -e "${YELLOW}[+]正在查看系统存在哪些日志文件[ls /var/log]:${NC}"
	# 获取 /var/log 目录下的日志文件列表
	allLog=$(ls /var/log 2>/dev/null)
	# 检查是否成功获取到日志文件列表
	if [ -n "$allLog" ]; then
		echo -e "${YELLOW}[+] 系统存在以下日志文件:${NC}"
		echo "$allLog" | while read -r logFile; do
			echo "- $logFile"
		done
	else
		echo -e "${RED}[!]未找到任何日志文件或无法访问 /var/log 目录,日志目录有可能被删除! ${NC}"
	fi
	printf "\n"

	# 2 message日志分析 [系统消息日志] 排查第一站 【ubuntu系统是/var/log/syslog】
	echo -e "${YELLOW}正在分析系统消息日志[message]:${NC}"
	## 检查传输文件情况
	echo -e "${YELLOW}正在检查是否使用ZMODEM协议传输文件[more /var/log/message* | grep "ZMODEM:.*BPS"]:" 
	zmodem=$(more /var/log/message* | grep "ZMODEM:.*BPS")
	if [ -n "$zmodem" ];then
		(echo -e "${RED}[!]传输文件情况:${NC}" && echo "$zmodem") 
	else
		echo -e "${YELLOW}[+]日志中未发现传输文件${NC}" 
	fi
	printf "\n" 

	## 2.1 检查DNS服务器使用情况
	echo -e "${YELLOW}正在检查日志中该机器使用DNS服务器的情况[/var/log/message* |grep "using nameserver"]:" 
	dns_history=$(more /var/log/messages* | grep "using nameserver" | awk '{print $NF}' | awk -F# '{print $1}' | sort | uniq)
	if [ -n "$dns_history" ];then
		(echo -e "${RED}[!]该服务器曾经使用以下DNS服务器(需要人工判断DNS服务器是否涉黑,不涉黑可以忽略):${NC}" && echo "$dns_history") 
	else
		echo -e "${YELLOW}[+]未发现该服务器使用DNS服务器${NC}" 
	fi
	printf "\n"


	# 3 secure日志分析 [安全认证和授权日志] [ubuntu等是auth.log]
	## 兼容 centOS 和 ubuntu 系统的代码片段 --- 后期优化
	# # 判断系统类型并选择正确的日志文件
	# if [ -f /var/log/auth.log ]; then
	# 	AUTH_LOG="/var/log/auth.log"
	# elif [ -f /var/log/secure ]; then
	# 	AUTH_LOG="/var/log/secure"
	# else
	# 	echo -e "${RED}[!] 无法找到系统安全日志文件（auth.log 或 secure）${NC}"
	# 	AUTH_LOG=""
	# fi

	# if [ -n "$AUTH_LOG" ]; then
	# 	echo -e "${YELLOW}正在检查系统安全日志中登录成功记录[grep 'Accepted' ${AUTH_LOG}* ]:${NC}"

	# 	loginsuccess=$(grep "Accepted" "${AUTH_LOG}" 2>/dev/null)

	# 	if [ -n "$loginsuccess" ]; then
	# 		(echo -e "${YELLOW}[+] 日志中分析到以下用户登录成功记录:${NC}" && echo "$loginsuccess")
	# 		(echo -e "${YELLOW}[+] 登录成功的IP及次数如下:${NC}" && grep "Accepted" "${AUTH_LOG}" | awk '{print $11}' | sort -nr | uniq -c)
	# 		(echo -e "${YELLOW}[+] 登录成功的用户及次数如下:${NC}" && grep "Accepted" "${AUTH_LOG}" | awk '{print $9}' | sort -nr | uniq -c)
	# 	else
	# 		echo "[+] 日志中未发现成功登录的情况"
	# 	fi
	# else
	# 	echo "[!] 跳过安全日志分析：未找到可用的日志文件"
	# fi


	echo -e "${YELLOW}正在分析系统安全日志[secure]:${NC}"
	## SSH安全日志分析
	echo -e "${YELLOW}正在检查系统安全日志中登录成功记录[more /var/log/secure* | grep "Accepted" ]:${NC}" 
	# loginsuccess=$(more /var/log/secure* | grep "Accepted password" | awk '{print $1,$2,$3,$9,$11}')
	loginsuccess=$(more /var/log/secure* | grep "Accepted" )  # 获取日志中登录成功的记录 包括 密码认证和公钥认证
	if [ -n "$loginsuccess" ];then
		(echo -e "${YELLOW}[+]日志中分析到以下用户登录成功记录:${NC}" && echo "$loginsuccess")  
		(echo -e "${YELLOW}[+]登录成功的IP及次数如下:${NC}" && grep "Accepted " /var/log/secure* | awk '{print $11}' | sort -nr | uniq -c )  
		(echo -e "${YELLOW}[+]登录成功的用户及次数如下:${NC}" && grep "Accepted" /var/log/secure* | awk '{print $9}' | sort -nr | uniq -c )  
	else
		echo "[+]日志中未发现成功登录的情况" 
	fi
	printf "\n" 

	## 3.1 SSH爆破情况分析
	echo -e "${YELLOW}正在检查系统安全日志中登录失败记录(SSH爆破)[more /var/log/secure* | grep "Failed"]:" 
	# loginfailed=$(more /var/log/secure* | grep "Failed password" | awk '{print $1,$2,$3,$9,$11}')
	# 如果是对root用户的爆破,$9 是 root,$11 是 IP 
	# 如果是对非root用户的爆破,$9 是 invalid $11 才是 用户名 $13 是 IP
	# from 前面是是用户,后面是 IP
	loginfailed=$(more /var/log/secure* | grep "Failed")  # 获取日志中登录失败的记录
	if [ -n "$loginfailed" ];then
		(echo -e "${RED}[!]日志中发现以下登录失败记录:${NC}" && echo "$loginfailed") 
		# (echo -e "${YELLOW}[!]登录失败的IP及次数如下(疑似SSH爆破):${NC}" && grep "Failed" /var/log/secure* | awk '{print $11}' | sort | uniq -c | sort -nr)  # 问题: $11 会出现 ip 和 username
		(echo -e "${RED}[!]登录失败的IP及次数如下(疑似SSH爆破):${NC}" && grep "Failed" /var/log/secure* | awk 'match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) {print substr($0, RSTART, RLENGTH)}' | sort | uniq -c | sort -nr)  # 优化:只匹配ip	
		# (echo -e "${YELLOW}[!]登录失败的用户及次数如下(疑似SSH爆破):${NC}" && grep "Failed" /var/log/secure* | awk '{print $9}' | sort | uniq -c | sort -nr) 
		# 根据 from 截取  用户名
		(echo -e "${RED}[!]登录失败的用户及次数如下(疑似SSH爆破):${NC}" && 
		{
			grep "Failed" /var/log/secure* | grep -v "invalid user" | awk '/Failed/ {for_index = index($0, "for ") + 4; from_index = index($0, " from "); user = substr($0, for_index, from_index - for_index); print "valid: " user}';
			grep "Failed" /var/log/secure* | grep "invalid user" | awk '/Failed/ {for_index = index($0, "invalid user ") + 13; from_index = index($0, " from "); user = substr($0, for_index, from_index - for_index); print "invalid: " user}';
		} | sort | uniq -c | sort -nr)
		# (echo -e "${YELLOW}[!]SSH爆破用户名的字典信息如下:${NC}" && grep "Failed" /var/log/secure* | perl -e 'while($_=<>){ /for(.*?) from/; print "$1\n";}'| uniq -c | sort -nr) 
	else
		echo -e "${YELLOW}[+]日志中未发现登录失败的情况${NC}" 
	fi
	printf "\n" 

	## 3.2 本机SSH登录成功并建立会话的日志记录
	echo -e "${YELLOW}正在检查本机SSH成功登录记录[more /var/log/secure* | grep -E "sshd:session.*session opened" ]:${NC}" 
	systemlogin=$(more /var/log/secure* | grep -E "sshd:session.*session opened" | awk '{print $1,$2,$3,$11}')
	if [ -n "$systemlogin" ];then
		(echo -e "${YELLOW}[+]本机SSH成功登录情况:${NC}" && echo "$systemlogin") 
		(echo -e "${YELLOW}[+]本机SSH成功登录账号及次数如下:${NC}" && more /var/log/secure* | grep -E "sshd:session.*session opened" | awk '{print $11}' | sort -nr | uniq -c) 
	else
		echo -e "${RED}[!]未发现在本机登录退出情况,请注意!${NC}" 
	fi
	printf "\n" 

	## 3.3 检查新增用户
	echo -e "${YELLOW}正在检查新增用户[more /var/log/secure* | grep "new user"]:${NC}"
	newusers=$(more /var/log/secure* | grep "new user"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}')
	if [ -n "$newusers" ];then
		(echo -e "${RED}[!]日志中发现新增用户:${NC}" && echo "$newusers") 
		(echo -e "${YELLOW}[+]新增用户账号及次数如下:${NC}" && more /var/log/secure* | grep "new user" | awk '{print $8}' | awk -F '[=,]' '{print $2}' | sort | uniq -c) 
	else
		echo -e "${YELLOW}[+]日志中未发现新增加用户${NC}" 
	fi
	printf "\n" 

	## 3.4 检查新增用户组
	echo -e "${YELLOW}正在检查新增用户组[/more /var/log/secure* | grep "new group"]:${NC}" 
	newgoup=$(more /var/log/secure* | grep "new group"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}')
	if [ -n "$newgoup" ];then
		(echo -e "${RED}[!]日志中发现新增用户组:${NC}" && echo "$newgoup") 
		(echo -e "${YELLOW}[+]新增用户组及次数如下:${NC}" && more /var/log/secure* | grep "new group" | awk '{print $8}' | awk -F '[=,]' '{print $2}' | sort | uniq -c) 
	else
		echo -e "${YELLOW}[+]日志中未发现新增加用户组${NC}" 
	fi
	printf "\n" 


	# 4 计划任务日志分析 cron日志分析 [cron作业调度器日志]
	echo -e "${YELLOW}正在分析cron日志:${NC}" 
	echo -e "${YELLOW}正在分析定时下载[/var/log/cron*]:${NC}" 
	cron_download=$(more /var/log/cron* | grep "wget|curl")
	if [ -n "$cron_download" ];then
		(echo -e "${RED}[!]定时下载情况:${NC}" && echo "$cron_download") 
	else
		echo -e "${YELLOW}[+]未发现定时下载情况${NC}" 
	fi
	printf "\n" 

	echo -e "${YELLOW}正在分析定时执行脚本[/var/log/cron*]:${NC}" 
	cron_shell=$(more /var/log/cron* | grep -E "\.py$|\.sh$|\.pl$|\.exe$") 
	if [ -n "$cron_shell" ];then
		(echo -e "${RED}[!]发现定时执行脚本:${NC}" && echo "$cron_download") 
		echo -e "${YELLOW}[+]未发现定时下载脚本${NC}" 
	fi
	printf "\n" 

	# 5 yum 日志分析 【只适配使用 yum 的系统,apt/history.log 的格式和yum 的格式差距较大,还有 dnf 包管理工具也另说】
	echo -e "${YELLOW}正在分析使用yum下载安装过的脚本文件[/var/log/yum*|grep Installed]:${NC}"  
	yum_installscripts=$(more /var/log/yum* | grep Installed | grep -E "(\.sh$\.py$|\.pl$|\.exe$)" | awk '{print $NF}' | sort | uniq)
	if [ -n "$yum_installscripts" ];then
		(echo -e "${RED}[!]曾使用yum下载安装过以下脚本文件:${NC}"  && echo "$yum_installscripts")  
	else
		echo -e "${YELLOW}[+]未发现使用yum下载安装过脚本文件${NC}"  
	fi
	printf "\n"  


	echo -e "${YELLOW}正在检查使用yum卸载软件情况[/var/log/yum*|grep Erased]:${NC}" 
	yum_erased=$(more /var/log/yum* | grep Erased)
	if [ -n "$yum_erased" ];then
		(echo -e "${YELLOW}[+]使用yum曾卸载以下软件:${NC}" && echo "$yum_erased")  
	else
		echo -e "${YELLOW}[+]未使用yum卸载过软件${NC}"  
	fi
	printf "\n"  

	echo -e "${YELLOW}正在检查使用yum安装的可疑工具[./checkrules/hackertoolslist.txt]:"  
	# 从文件中取出一个工具名然后匹配
	hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
	for hacker_tools in $hacker_tools_list;do
		hacker_tools=$(more /var/log/yum* | awk -F: '{print $NF}' | awk -F '[-]' '{print }' | sort | uniq | grep -E "$hacker_tools")
		if [ -n "$hacker_tools" ];then
			(echo -e "${YELLOW}[!]发现使用yum下载过以下可疑软件:${NC}"&& echo "$hacker_tools")  
		else
			echo -e "${YELLOW}[+]未发现使用yum下载过可疑软件${NC}"  
		fi
	done
	printf "\n"  

	
	# 6 dmesg日志分析 [内核环境提示信息,包括启动消息、硬件检测和系统错误]
	echo -e "${YELLOW}正在分析dmesg内核自检日志[dmesg]:${NC}" 
	dmesg=$(dmesg)
	if [ $? -eq 0 ];then
		(echo -e "${YELLOW}[+]日志自检日志如下:${NC}" && echo "$dmesg" ) 
	else
		echo -e "${RED}[!]未发现内核自检日志${NC}" 
	fi
	printf "\n" 


	# 7 btmp 日志分析 [记录失败的登录尝试,包括日期、时间和用户名] 【二进制日志文件,不能直接 cat 查看】
	echo -e "正在分析btmp错误登录日志[lastb]:"  
	lastb=$(lastb)
	if [ -n "$lastb" ];then
		(echo -e "${YELLOW}[+]错误登录日志如下:${NC}" && echo "$lastb") 
	else
		echo -e "${RED}[!]未发现错误登录日志${NC}"  
	fi
	printf "\n"  

	# 8 lastlog 日志分析 [记录最后一次登录的日志,包括日期、时间和用户名]
	echo -e "[14.8]正在分析lastlog最后一次登录日志[lastlog]:"  
	lastlog=$(lastlog)
	if [ -n "$lastlog" ];then
		(echo -e "${YELLOW}[+]所有用户最后一次登录日志如下:${NC}" && echo "$lastlog")  
	else
		echo -e "${RED}[!]未发现所有用户最后一次登录日志${NC}"  
	fi
	printf "\n"  


	# 9 wtmp日志分析 [记录系统关闭、重启和登录/注销事件]
	# 【grep 排除 :0 登录,这个是图形化登录】
	echo -e "${YELLOW}正在分析wtmp日志[last | grep pts | grep -vw :0]:${NC}"  
	echo -e "${YELLOW}正在检查历史上登录到本机的用户(非图形化UI登录):${NC}"  
	lasts=$(last | grep pts | grep -vw :0)
	if [ -n "$lasts" ];then
		(echo -e "${YELLOW}[+]历史上登录到本机的用户如下:${NC}" && echo "$lasts")  
	else
		echo -e "${RED}[!]未发现历史上登录到本机的用户信息${NC}"  
	fi
	printf "\n"  


	# 10 journalctl 日志分析
	# journalctl 的使用方法
	# -u 显示指定服务日志 journalctl -u sshd.service
	# -f 显示实时日志 journalctl -f
	# -k 显示内核环缓冲区中的消息 journalctl -k 
	# -p 显示指定优先级日志 journalctl -p err [emerg、alert、crit、err、warning、notice、info、debug]
	# -o  指定输出格式 journalctl -o json-pretty > logs.json
	echo -e "${YELLOW}正在使用journalctl分析日志:${NC}"  
	# 检查最近24小时内的journalctl日志
	echo -e "${YELLOW}正在检查最近24小时内的日志[journalctl --since "24 hours ago"]:${NC}"  
	journalctl=$(journalctl --since "24 hours ago")
	if [ -n "$journalctl" ];then
		echo -e "${YELLOW}[+]journalctl最近24小时内的日志输出到[$log_file/journalctl_24h.txt]:${NC}"  
		echo "$journalctl" >> $log_file/journalctl_24H.txt
	else
		echo -e "${YELLOW}[!]journalctl未发现最近24小时内的日志${NC}"  
	fi
	printf "\n"
	echo -e "${YELLOW}journalctl 其他使用参数:${NC}"
	echo -e "${YELLOW} -u 显示指定服务日志[journalctl -u sshd.service]${NC}"
	echo -e "${YELLOW} -f 显示实时日志[journalctl -f]${NC}"
	echo -e "${YELLOW} -k 显示内核环缓冲区中的消息[journalctl -k]${NC}"
	echo -e "${YELLOW} -p 显示指定优先级日志[journalctl -p err] [emerg、alert、crit、err、warning、notice、info、debug]${NC}"
	echo -e "${YELLOW} -o 指定输出格式[journalctl -o json-pretty > logs.json]${NC}"
	printf "\n"  

	# 11 auditd 服务状态分析
	echo -e "正在分析日志审核服务是否开启[systemctl status auditd.service]:" 
	# auditd=$(systemctl status auditd.service | grep running)
	auditd=$(systemctl status auditd.service | head  -n 12)
	# if [ $? -eq 0 ];then
	# 	echo "[+]系统日志审核功能已开启,符合要求" 
	# else
	# 	echo "[!]系统日志审核功能已关闭,不符合要求,建议开启日志审核。可使用以下命令开启:service auditd start" 
	# fi
	if [ -n "$auditd" ];then
		(echo -e "${YELLOW}[+]auditd服务信息如下:${NC}" && echo "$auditd")  
	fi
	printf "\n" 

	# 12 rsyslog 日志主配置文件
	echo -e "${YELLOW}正在检查rsyslog主配置文件[/etc/rsyslog.conf]:"  
	logconf=$(more /etc/rsyslog.conf | egrep -v "#|^$")
	if [ -n "$logconf" ];then
		(echo -e "${YELLOW}[+]日志配置如下:${NC}" && echo "$logconf")  
	else
		echo -e "${YELLOW}[!]未发现日志配置文件${NC}"  
	fi
	printf "\n"  

}

# 文件信息排查【完成】
fileCheck(){
	# 系统服务排查 
	systemServiceCheck
	# 敏感目录排查 | 隐藏文件排查 dirFileCheck
	dirFileCheck
	# 特殊文件排查 [SSH相关文件|环境变量相关|hosts文件|shadow文件|24H变动文件|特权文件] sshCheck | specialFileCheck
	specialFileCheck
	# 日志文件分析 [message日志|secure日志分析|计划任务日志分析|yum日志分析 等日志] systemLogCheck 【重点】
	systemLogCheck
}

# 后门排查 【未完成】
backdoorCheck(){
	# 常见后门目录 /tmp /usr/bin /usr/sbin 
	echo -e "${YELLOW}正在检查后门文件:${NC}"
	echo -e "待完善"
	# 检测进程二进制文件的stat修改时间，如果发现近期修改则判定为可疑后门文件 --- 20250707 待增加

}

# webshell 排查 【未完成】
webshellCheck(){
	# 检查网站常见的目录
	# 可以放一个rkhunter的tar包,解压后直接运行即可
	echo -e "${YELLOW}正在检查webshell文件:${NC}"  
	echo -e "${YELLOW}webshell这一块因为技术难度相对较高,并且已有专业的工具,目前这一块建议使用专门的安全检查工具来实现${NC}" 
	echo -e "${YELLOW}请使用rkhunter工具来检查系统层的恶意文件,下载地址:http://rkhunter.sourceforge.net${NC}"  
	printf "\n"  
	# 访问日志
}



# SSH隧道检测
tunnelSSH(){ 
	echo -e "${YELLOW}正在检查SSH隧道${NC}"
	
	# SSH隧道检测
	# 检查网络连接的时候发现2个以上的连接是同一个进程PID，且服务是SSHD的大概率是SSH隧道
	
	## 1. 检测同一PID的多个sshd连接（主要检测方法）
	### [检测的时候发现 unix 连接会干扰判断，所以 netstat 增加-t 参数只显示 tcp 协议的连接(ssh基于tcp)]
	echo -e "${YELLOW}[+]检查同一PID的多个sshd连接:${NC}"
	ssh_connections=$(netstat -anpot 2>/dev/null | grep sshd | awk '{print $7}' | cut -d'/' -f1 | sort | uniq -c | awk '$1 > 1 {print $2, $1}')
	if [ -n "$ssh_connections" ]; then
		echo -e "${RED}[!]发现可疑SSH隧道 - 同一PID存在多个SSHD连接:${NC}"
		echo "$ssh_connections" | while read pid count; do
			if [ -n "$pid" ] && [ "$pid" != "-" ]; then
				echo -e "${RED}  PID: $pid, 连接数: $count${NC}"
				# 显示详细连接信息
				netstat -anpot 2>/dev/null | grep "$pid/sshd" | while read line; do
					echo -e "${YELLOW}    $line${NC}"
				done
				# 显示进程详细信息
				ps_info=$(ps -p $pid -o pid,ppid,user,cmd --no-headers 2>/dev/null)
				if [ -n "$ps_info" ]; then
					echo -e "${YELLOW}    COLUMN: pid - ppid - user - cmd ${NC}"
					echo -e "${YELLOW}    PSINFO: $ps_info${NC}"
				fi
				echo ""
			fi
		done
	else
		echo -e "${GREEN}[+]未发现同一PID的多个sshd连接${NC}"
	fi
	printf "\n"
	
	## 2. 检测SSH本地转发（Local Port Forwarding）
	echo -e "${YELLOW}[+]检查SSH本地转发特征:${NC}"
	# 本地转发命令：ssh -L local_port:target_host:target_port user@ssh_server
	# 特征：SSH进程监听本地端口，将流量转发到远程
	local_forward_ports=$(netstat -tlnp 2>/dev/null | grep sshd | awk '{print $4, $7}' | grep -v ':22')
	if [ -n "$local_forward_ports" ]; then
		echo -e "${YELLOW}[!]发现SSH进程监听非22端口(可能的本地转发):${NC}"
		echo "$local_forward_ports"
		# 检查对应的SSH进程命令行参数
		echo "$local_forward_ports" | while read port_info; do
			pid=$(echo "$port_info" | awk '{print $2}' | cut -d'/' -f1)
			if [ -n "$pid" ] && [ "$pid" != "-" ]; then
				cmd_line=$(ps -p $pid -o cmd --no-headers 2>/dev/null)
				if echo "$cmd_line" | grep -q '\-L'; then
					echo -e "${RED}    [!]确认本地转发: $cmd_line${NC}"
				fi
			fi
		done
	else
		echo -e "${GREEN}[+]未发现SSH本地转发特征${NC}"
	fi
	printf "\n"
	
	## 3. 检测SSH远程转发（Remote Port Forwarding）
	echo -e "${YELLOW}[+]检查SSH远程转发特征:${NC}"
	# 远程转发命令：ssh -R remote_port:local_host:local_port user@ssh_server
	# 特征：SSH客户端连接到远程服务器，远程服务器监听端口
	
	### 3.1 检查SSH进程的命令行参数中是否包含-R选项
	remote_forward_processes=$(ps aux | grep ssh | grep -v grep | grep '\-R')
	if [ -n "$remote_forward_processes" ]; then
		echo -e "${RED}[!]发现SSH远程转发进程:${NC}"
		echo "$remote_forward_processes"
	else
		echo -e "${GREEN}[+]未发现SSH远程转发特征${NC}"
	fi
	
	### 3.2 检查SSH配置文件中的远程转发设置
	remote_forward_config=$(grep -E '^(AllowTcpForwarding|GatewayPorts)' /etc/ssh/sshd_config 2>/dev/null | grep -v 'no')
	if [ -n "$remote_forward_config" ]; then
		echo -e "${YELLOW}[!]SSH配置允许远程转发:${NC}"
		echo "$remote_forward_config"
	fi
	printf "\n"
	
	## 4. 检测SSH动态转发（SOCKS代理）
	echo -e "${YELLOW}[+]检查SSH动态转发(SOCKS代理)特征:${NC}"
	# 动态转发命令：ssh -D local_port user@ssh_server
	# 特征：SSH进程创建SOCKS代理，监听本地端口
	dynamic_forward_processes=$(ps aux | grep ssh | grep -v grep | grep '\-D')
	if [ -n "$dynamic_forward_processes" ]; then
		echo -e "${RED}[!]发现SSH动态转发(SOCKS代理)进程:${NC}"
		echo "$dynamic_forward_processes"
	else
		echo -e "${GREEN}[+]未发现SSH动态转发特征${NC}"
	fi
	printf "\n"
	
	## 5. 检测SSH多级跳板（ProxyJump/ProxyCommand）
	echo -e "${YELLOW}[+]检查SSH多级跳板特征:${NC}"
	# 多级跳板命令：ssh -J jump_host1,jump_host2 target_host
	# 或使用ProxyCommand: ssh -o ProxyCommand="ssh jump_host nc target_host 22" target_host
	
	### 5.1 检查SSH进程的命令行参数
	jump_processes=$(ps aux | grep ssh | grep -v grep | grep -E '(\-J|ProxyCommand|ProxyJump)')
	if [ -n "$jump_processes" ]; then
		echo -e "${RED}[!]发现SSH多级跳板进程:${NC}"
		echo "$jump_processes"
	else
		echo -e "${GREEN}[+]未发现SSH多级跳板进程${NC}"
	fi
	
	### 5.2 检查SSH配置文件中的跳板设置
	if [ -f ~/.ssh/config ]; then
		jump_config=$(grep -E '(ProxyJump|ProxyCommand)' ~/.ssh/config 2>/dev/null)
		if [ -n "$jump_config" ]; then
			echo -e "${YELLOW}[!]SSH配置文件中发现跳板设置:${NC}"
			echo "$jump_config"
		fi
	fi
	printf "\n"
	
	## 6. 检测SSH隧道的网络流量特征
	echo -e "${YELLOW}[+]检查SSH隧道网络流量特征:${NC}"
	# 检查SSH连接的数据传输量异常
	ssh_traffic=$(netstat -i 2>/dev/null | awk 'NR>2 {rx+=$3; tx+=$7} END {if(rx>1000000 || tx>1000000) print "High traffic detected: RX="rx" TX="tx}')
	if [ -n "$ssh_traffic" ]; then
		echo -e "${YELLOW}[!]检测到高网络流量:${NC}"
		echo "$ssh_traffic"
	else
		echo -e "${GREEN}[+]网络流量正常${NC}"
	fi
	printf "\n"
	
	## 7. 检测SSH隧道持久化特征
	echo -e "${YELLOW}[+]检查SSH隧道持久化特征:${NC}"
	
	### 7.1 检查SSH相关的定时任务
	ssh_cron=$(crontab -l 2>/dev/null | grep ssh)
	if [ -n "$ssh_cron" ]; then
		echo -e "${YELLOW}[!]发现SSH相关的定时任务:${NC}"
		echo "$ssh_cron"
	fi
	
	### 7.2 检查SSH相关的systemd服务
	ssh_services=$(systemctl list-units --type=service 2>/dev/null | grep ssh | grep -v sshd)
	if [ -n "$ssh_services" ]; then
		echo -e "${YELLOW}[!]发现SSH相关的自定义服务:${NC}"
		echo "$ssh_services"
	fi
	
	### 7.3 检查SSH相关的启动脚本
	ssh_startup=$(find /etc/init.d /etc/systemd/system /etc/rc.local 2>/dev/null -exec grep -l "ssh.*-[LRD]" {} \; 2>/dev/null)
	if [ -n "$ssh_startup" ]; then
		echo -e "${RED}[!]发现SSH隧道相关的启动脚本:${NC}"
		echo "$ssh_startup"
	fi
	printf "\n"
	
	## 8. 检测其他隧道工具
	echo -e "${YELLOW}[+]检查其他隧道工具:${NC}"
	# 隧道工具列表定义
	tunnel_tools="frp nps ngrok chisel socat nc netcat stunnel proxychains"
	for tool in $tunnel_tools; do
		tool_process=$(ps aux | grep -v grep | grep "$tool")
		if [ -n "$tool_process" ]; then
			echo -e "${RED}[!]发现隧道工具进程: $tool${NC}"
			echo "$tool_process"
		fi
		# 检查工具是否存在于系统中
		tool_path=$(which "$tool" 2>/dev/null)
		if [ -n "$tool_path" ]; then
			echo -e "${YELLOW}[!]系统中存在隧道工具: $tool ($tool_path)${NC}"
		fi
	done
	printf "\n"
	
	echo -e "${GREEN}SSH隧道检测完成${NC}"

}


# 隧道和反弹shell检查
tunnelCheck(){ 
	echo -e "${YELLOW}正在检查隧道和反弹shell${NC}"
	echo -e "待完善"
}

# 病毒排查 【未完成】
virusCheck(){
	# 基础排查
	# 病毒特有行为排查
	echo -e "${YELLOW}正在进行病毒痕迹分析:${NC}"  
	echo -e "待完善"
}

# 内存和VFS排查 【未完成】
memInfoCheck(){
	# /proc/<pid>/[cmdline|environ|fd/*]
	# 如果存在 /proc 目录中有进程文件夹,但是在 ps -aux 命令里没有显示的,就认为可能是异常进程
	echo -e "${YELLOW}正在进行内存分析:${NC}"
	echo -e "待完善"
}

# 黑客工具排查 【完成】
hackerToolsCheck(){
	# 黑客工具排查
	echo -e "${YELLOW}正在检查全盘是否存在黑客工具[./checkrules/hackertoolslist.txt]:${NC}"  
	# hacker_tools_list="nc sqlmap nmap xray beef nikto john ettercap backdoor *proxy msfconsole msf *scan nuclei *brute* gtfo Titan zgrab frp* lcx *reGeorg nps spp suo5 sshuttle v2ray"
	# 从 hacker_tools_list 列表中取出一个工具名然后全盘搜索
	# hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
	echo -e "${YELLOW}[说明]定义黑客工具列表文件hackertoolslist.txt,全盘搜索该列表中的工具名,如果存在则告警(工具文件可自行维护)${NC}"
	hacker_tools_list=$(cat ${current_dir}/checkrules/hackertoolslist.txt)
	for hacker_tool in $hacker_tools_list
	do
		findhackertool=$(find / -name $hacker_tool 2>/dev/null)
		if [ -n "$findhackertool" ];then
			(echo -e "${RED}[!]发现全盘存在可疑黑客工具:$hacker_tool${NC}" && echo "$findhackertool")  
		else
			echo -e "${YELLOW}[+]未发现全盘存在可疑黑可工具:$hacker_tool${NC}"  
		fi
		printf "\n"  
	done
	
	# 常见黑客痕迹排查

}

# 内核排查 【完成】
kernelCheck(){
	# 内核信息排查
	echo -e "${YELLOW}正在检查内核信息[lsmod]:${NC}"  
	lsmod=$(lsmod)
	if [ -n "$lsmod" ];then
		(echo "${YELLOW}[+]内核信息如下:${NC}" && echo "$lsmod")  
	else
		echo "${YELLOW}[+]未发现内核信息${NC}"  
	fi
	printf "\n"  

	echo -e "${YELLOW}正在检查异常内核[lsmod|grep -Ev mod_list]:${NC}"  
	danger_lsmod=$(lsmod | grep -Ev "ablk_helper|ac97_bus|acpi_power_meter|aesni_intel|ahci|ata_generic|ata_piix|auth_rpcgss|binfmt_misc|bluetooth|bnep|bnx2|bridge|cdrom|cirrus|coretemp|crc_t10dif|crc32_pclmul|crc32c_intel|crct10dif_common|crct10dif_generic|crct10dif_pclmul|cryptd|dca|dcdbas|dm_log|dm_mirror|dm_mod|dm_region_hash|drm|drm_kms_helper|drm_panel_orientation_quirks|e1000|ebtable_broute|ebtable_filter|ebtable_nat|ebtables|edac_core|ext4|fb_sys_fops|floppy|fuse|gf128mul|ghash_clmulni_intel|glue_helper|grace|i2c_algo_bit|i2c_core|i2c_piix4|i7core_edac|intel_powerclamp|ioatdma|ip_set|ip_tables|ip6_tables|ip6t_REJECT|ip6t_rpfilter|ip6table_filter|ip6table_mangle|ip6table_nat|ip6table_raw|ip6table_security|ipmi_devintf|ipmi_msghandler|ipmi_si|ipmi_ssif|ipt_MASQUERADE|ipt_REJECT|iptable_filter|iptable_mangle|iptable_nat|iptable_raw|iptable_security|iTCO_vendor_support|iTCO_wdt|jbd2|joydev|kvm|kvm_intel|libahci|libata|libcrc32c|llc|lockd|lpc_ich|lrw|mbcache|megaraid_sas|mfd_core|mgag200|Module|mptbase|mptscsih|mptspi|nf_conntrack|nf_conntrack_ipv4|nf_conntrack_ipv6|nf_defrag_ipv4|nf_defrag_ipv6|nf_nat|nf_nat_ipv4|nf_nat_ipv6|nf_nat_masquerade_ipv4|nfnetlink|nfnetlink_log|nfnetlink_queue|nfs_acl|nfsd|parport|parport_pc|pata_acpi|pcspkr|ppdev|rfkill|sch_fq_codel|scsi_transport_spi|sd_mod|serio_raw|sg|shpchp|snd|snd_ac97_codec|snd_ens1371|snd_page_alloc|snd_pcm|snd_rawmidi|snd_seq|snd_seq_device|snd_seq_midi|snd_seq_midi_event|snd_timer|soundcore|sr_mod|stp|sunrpc|syscopyarea|sysfillrect|sysimgblt|tcp_lp|ttm|tun|uvcvideo|videobuf2_core|videobuf2_memops|videobuf2_vmalloc|videodev|virtio|virtio_balloon|virtio_console|virtio_net|virtio_pci|virtio_ring|virtio_scsi|vmhgfs|vmw_balloon|vmw_vmci|vmw_vsock_vmci_transport|vmware_balloon|vmwgfx|vsock|xfs|xt_CHECKSUM|xt_conntrack|xt_state")
	if [ -n "$danger_lsmod" ];then
		(echo -e "${RED}!]发现可疑内核模块:${NC}" && echo "$danger_lsmod")  
	else
		echo -e "${YELLOW}[+]未发现可疑内核模块${NC}"  
	fi
	printf "\n"  

}

# 其他排查 【完成】
otherCheck(){
	# 可疑脚本文件排查
	echo -e "${YELLOW}正在检查可疑脚本文件[py|sh|per|pl|exe]:${NC}"  
	echo -e "${YELLOW}[注意]不检查/usr,/etc,/var目录,需要检查请自行修改脚本,脚本需要人工判定是否有害${NC}"  
	scripts=$(find / *.* | egrep "\.(py|sh|per|pl|exe)$" | egrep -v "/usr|/etc|/var")
	if [ -n "scripts" ];then
		(echo -e "${RED}[!]发现以下脚本文件,请注意!${NC}" && echo "$scripts")  
	else
		echo -e "${YELLOW}[+]未发现脚本文件${NC}"  
	fi
	printf "\n"  


	# 系统文件完整性校验
	# 通过取出系统关键文件的MD5值,一方面可以直接将这些关键文件的MD5值通过威胁情报平台进行查询
	# 另一方面,使用该软件进行多次检查时会将相应的MD5值进行对比,若和上次不一样,则会进行提示
	# 用来验证文件是否被篡改
	echo -e "${YELLOW}[INFO] md5查询威胁情报或者用来防止二进制文件篡改(需要人工比对md5值)${NC}"  
	echo -e "${YELLOW}[INFO] MD5值文件导出位置: ${check_file}/sysfile_md5.txt${NC}"  

	file="${check_file}/sysfile_md5.txt"

	# 要检查的目录列表
	dirs_to_check=(
		/bin
		/usr/bin
		/sbin
		/usr/sbin
		/usr/lib/systemd
		/usr/local/bin
	)

	if [ -e "$file" ]; then 
		md5sum -c "$file" 2>&1  
	else
		# 清空或创建文件
		> "$file"

		# 遍历每个目录,查找可执行文件
		for dir in "${dirs_to_check[@]}"; do
			if [ -d "$dir" ]; then
				echo -e "${YELLOW}[INFO] 正在扫描目录${NC}: $dir"  

				# 查找当前目录下所有具有可执行权限的普通文件
				find "$dir" -maxdepth 1 -type f -executable | while read -r f; do
					# 输出文件名和MD5值(输出屏幕同时保存到文件中)
					md5sum "$f" | tee -a "$file"  
					# md5sum "$f" >> "$file"
				done
			else
				echo -e "${YELLOW}[WARN] 目录不存在${NC}: $dir"  
			fi
		done
	fi

	# 安装软件排查(rpm)
	echo -e "${YELLOW}正在检查rpm安装软件及版本情况[rpm -qa]:${NC}"  
	software=$(rpm -qa | awk -F- '{print $1,$2}' | sort -nr -k2 | uniq)
	if [ -n "$software" ];then
		(echo -e "${YELLOW}[+]系统安装与版本如下:${NC}" && echo "$software")  
	else
		echo -e "${YELLOW}[+]系统未安装软件${NC}" 
	fi
	printf "\n"  

	echo -e "${YELLOW}正在检查rpm安装的可疑软件:${NC}" 
	# 从文件中取出一个工具名然后匹配
	hacker_tools_list=$(cat ${current_dir}/checkrules/hackertoolslist.txt)
	for hacker_tools in $hacker_tools_list;do
		danger_soft=$(rpm -qa | awk -F- '{print $1}' | sort | uniq | grep -E "$hacker_tools")
		if [ -n "$danger_soft" ];then
			(echo -e "${RED}[!]发现安装以下可疑软件:$hacker_tools${NC}" && echo "$danger_soft") 
		else
			echo -e "${YELLOW}[+]未发现安装可疑软件:$hacker_tools${NC}" 
		fi
	done
	printf "\n" 

}

# 防火墙信息检查函数 归档 -- baselineCheck】
firewallRulesCheck(){
    echo -e "${YELLOW}[+]正在检查防火墙策略（允许/拒绝规则）:${NC}"

    if command -v firewall-cmd &>/dev/null && systemctl is-active --quiet firewalld; then
        echo -e "${YELLOW}[+]检测到 firewalld 正在运行${NC}"
        
        # 获取所有启用的区域
        # ZONES=$(firewall-cmd --get-active-zones | awk '{print $1}')
		ZONES=$(firewall-cmd --get-active-zones | grep -v '^\s*$' | grep -v '^\s' | sort -u)

        for ZONE in $ZONES; do
            echo -e "${RED}[!]区域 [${ZONE}] 的配置:${NC}"
            
            # 允许的服务
            SERVICES=$(firewall-cmd --zone=$ZONE --list-services 2>/dev/null)
            if [ -n "$SERVICES" ]; then
                echo -e "  [+] 允许的服务: $SERVICES"
            else
                echo -e "  [-] 没有配置允许的服务"
            fi

            # 允许的端口
            PORTS=$(firewall-cmd --zone=$ZONE --list-ports 2>/dev/null)
            if [ -n "$PORTS" ]; then
                echo -e "  [+] 允许的端口: $PORTS"
            else
                echo -e "  [-] 没有配置允许的端口"
            fi

            # 允许的源IP
            SOURCES=$(firewall-cmd --zone=$ZONE --list-sources 2>/dev/null)
            if [ -n "$SOURCES" ]; then
                echo -e "  [+] 允许的源IP: $SOURCES"
            else
                echo -e "  [-] 没有配置允许的源IP"
            fi

            # 拒绝的源IP（黑名单）
            DENY_IPS=$(firewall-cmd --zone=$ZONE --list-rich-rules | grep 'reject' | grep 'source address' | awk -F "'" '{print $2}')
            if [ -n "$DENY_IPS" ]; then
                echo -e "  [!] 拒绝的源IP: $DENY_IPS"
            else
                echo -e "  [-] 没有配置拒绝的源IP"
            fi

            printf "\n"
        done

    elif [ -x /sbin/iptables ] && iptables -L -n -v &>/dev/null; then
        echo -e "${YELLOW}[+]检测到 iptables 正在运行${NC}"

        echo -e "${RED}[!]允许的规则(ACCEPT):${NC}"
        iptables -L -n -v | grep ACCEPT
        echo -e "${RED}[!]拒绝的规则(REJECT/DROP):${NC}"
        iptables -L -n -v | grep -E 'REJECT|DROP'

    else
        echo -e "${YELLOW}[+]未检测到 active 的防火墙服务(firewalld/iptables)${NC}"
    fi

    printf "\n"
}

# selinux状态检查函数 【归档 -- baselineCheck】
selinuxStatusCheck(){
    echo -e "${YELLOW}正在检查 SELinux 安全策略:${NC}"

    # 检查是否存在 SELinux 相关命令
    if ! command -v getenforce &>/dev/null && [ ! -f /usr/sbin/getenforce ] && [ ! -f /sbin/getenforce ]; then
        echo -e "${YELLOW}[+]未安装 SELinux 工具,跳过检查${NC}"
        printf "\n"
        return
    fi

    # 获取 SELinux 当前状态
    SELINUX_STATUS=$(getenforce 2>/dev/null)

    case "$SELINUX_STATUS" in
        Enforcing)
            echo -e "${RED}[!]SELinux 正在运行于 enforcing 模式(强制模式)${NC}"
            ;;
        Permissive)
            echo -e "${YELLOW}[~]SELinux 处于 permissive 模式(仅记录不阻止)${NC}"
            ;;
        Disabled)
            echo -e "${RED}[X]SELinux 已禁用(disabled)${NC}"
            printf "\n"
            return
            ;;
        *)
            echo -e "${YELLOW}[?]无法识别 SELinux 状态: $SELINUX_STATUS${NC}"
            printf "\n"
            return
            ;;
    esac

    # 获取 SELinux 策略类型
    SELINUX_POLICY=$(sestatus | grep "Policy from config file" | awk '{print $NF}')
    if [ -n "$SELINUX_POLICY" ]; then
        echo -e "  [+]当前 SELinux 策略类型: ${GREEN}$SELINUX_POLICY${NC}"
    else
        echo -e "  [-]无法获取 SELinux 策略类型"
    fi

    # 获取 SELinux 配置文件中的默认模式
    CONFIG_MODE=$(grep ^SELINUX= /etc/selinux/config | cut -d= -f2)
    if [ -n "$CONFIG_MODE" ]; then
        echo -e "  [i]配置文件中设定的默认模式: ${GREEN}${CONFIG_MODE^^}${NC}"
    else
        echo -e "  [-]无法读取 SELinux 默认启动模式配置"
    fi

    printf "\n"
}

# 基线检查【未完成】
baselineCheck(){
	# 基线检查项
	## 1.账户审查 调用 userInfoCheck 函数
	### 1.1 账户登录信息排查 调用 userInfoCheck 函数  函数需要修改
	echo -e "${YELLOW}==========基线检查==========${NC}" 
	echo -e "${YELLOW}正在检查账户信息:${NC}"
	userInfoCheck
	printf "\n"

	### 1.2 密码策略配置
	echo -e "${YELLOW}正在检查密码策略:${NC}" 
	echo -e "${YELLOW}[+]正在检查密码有效期策略[/etc/login.defs ]:${NC}" 
	(echo -e "${YELLOW}[+]密码有效期策略如下:${NC}" && cat /etc/login.defs | grep -v "#" | grep PASS ) 
	printf "\n" 

	echo -e "${YELLOW}正在进行口令生存周期检查:${NC}"  
	passmax=$(cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}')
	if [ $passmax -le 90 -a $passmax -gt 0 ];then
		echo -e "${YELLOW}[+]口令生存周期为${passmax}天,符合要求(要求:0<密码有效期<90天)${NC}"  
	else
		echo -e "${RED}[!]口令生存周期为${passmax}天,不符合要求,建议设置为1-90天${NC}" 
	fi

	echo -e "${YELLOW}正在进行口令更改最小时间间隔检查:${NC}" 
	passmin=$(cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}')
	if [ $passmin -ge 6 ];then
		echo -e "${YELLOW}[+]口令更改最小时间间隔为${passmin}天,符合要求(不小于6天)${NC}" 
	else
		echo -e "${RED}[!]口令更改最小时间间隔为${passmin}天,不符合要求,建议设置不小于6天${NC}" 
	fi

	echo -e "${YELLOW}正在进行口令最小长度检查:${NC}" 
	passlen=$(cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}')
	if [ $passlen -ge 8 ];then
		echo -e "${YELLOW}[+]口令最小长度为${passlen},符合要求(最小长度不小于8)${NC}" 
	else
		echo -e "${RED}[!]口令最小长度为${passlen},不符合要求,建议设置最小长度大于等于8${NC}" 
	fi

	echo -e "${YELLOW}正在进行口令过期警告时间天数检查:${NC}" 
	passage=$(cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}')
	if [ $passage -ge 30 -a $passage -lt $passmax ];then
		echo -e "${YELLOW}[+]口令过期警告时间天数为${passage},符合要求(要求大于等于30天并小于口令生存周期)${NC}" 
	else
		echo -e "${RED}[!]口令过期警告时间天数为${passage},不符合要求,建议设置大于等于30并小于口令生存周期${NC}" 
	fi
	printf "\n" 

	echo -e "${YELLOW}正在检查密码复杂度策略[/etc/pam.d/system-auth]:${NC}" 
	(echo -e "[+]密码复杂度策略如下:" && cat /etc/pam.d/system-auth | grep -v "#") | 
	printf "\n" 

	echo -e "${YELLOW}正在检查密码已过期用户[/etc/shadow]:${NC}" 
	NOW=$(date "+%s")
	day=$((${NOW}/86400))
	passwdexpired=$(grep -v ":[\!\*x]([\*\!])?:" /etc/shadow | awk -v today=${day} -F: '{ if (($5!="") && (today>$3+$5)) { print $1 }}')
	if [ -n "$passwdexpired" ];then
		(echo -e "${RED}[!]以下用户的密码已过期:${NC}" && echo "$passwdexpired")  
	else
		echo -e "${YELLOW}[+]未发现密码已过期用户${NC}" 
	fi
	printf "\n" 


	echo -e "${YELLOW}正在检查账号超时锁定策略[/etc/profile]:${NC}"  
	account_timeout=$(cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}')
	if [ "$account_timeout" != ""  ];then
		TMOUT=$(cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}')
		if [ $TMOUT -le 600 -a $TMOUT -ge 10 ];then
			echo -e "${YELLOW}[+]账号超时时间为${TMOUT}秒,符合要求${NC}"  
		else
			echo -e "${RED}[!]账号超时时间为${TMOUT}秒,不符合要求,建议设置小于600秒${NC}"  
	fi
	else
		echo -e "${RED}[!]账号超时未锁定,不符合要求,建议设置小于600秒${NC}"  
	fi
	printf "\n"  


	#### 【这是一个通用的文件检查,centOS7 和 ubuntu 等系统都适用】
	# 角色: 这是 GRUB 2 引导加载程序的实际配置文件,包含了启动菜单项和其他引导信息。
	# 内容: 包含了所有可用操作系统条目、内核版本、启动参数等详细信息。这个文件通常非常复杂,并不适合直接手工编辑。
	# 生成方式: 此文件是由 grub2-mkconfig 命令根据 /etc/default/grub 文件中的设置以及其他脚本（如 /etc/grub.d/ 目录下的脚本）自动生成的。
	# 作用: 在系统启动时,GRUB 2 使用此文件来显示启动菜单并加载选定的操作系统或内核
	# /etc/grub2.cfg 是 /boot/grub2/grub.cfg 的软链接,如果要修改 grub 行为,应该修改 /etc/default/grub 文件,然后运行 grub2-mkconfig -o /boot/grub2/grub.cfg 来生成 /boot/grub2/grub.cfg 文件。
	echo -e "${YELLOW}[2.2.4]正在检查grub2密码策略[/boot/grub2/grub.cfg]:${NC}"
	echo -e "[+]grub2密码策略如下:"

	GRUB_CFG="/boot/grub2/grub.cfg"

	# 检查文件是否存在
	if [ ! -f "$GRUB_CFG" ]; then
		echo -e "${RED}[!]文件 $GRUB_CFG 不存在,无法进行 grub2 密码策略检查${NC}"
	else
		# 检查是否配置了加密密码（推荐使用 password_pbkdf2）
		if grep -qE '^\s*password_pbkdf2' "$GRUB_CFG"; then
			echo -e "${GREEN}[+]已设置安全的grub2密码(PBKDF2加密),符合要求${NC}"
		else
			echo -e "${RED}[!]未设置grub2密码,不符合安全要求!建议立即配置grub2密码保护${NC}"
		fi
	fi

	printf "\n"


	### 1.3 远程登录限制 
	#### 1.3.1 远程登录策略 TCP Wrappers
	# TCP Wrappers 是一种用于增强网络安全性的工具,它通过基于主机的访问控制来限制对网络服务的访问。
	# 一些流行的服务如 SSH (sshd)、FTP (vsftpd) 和 Telnet 默认支持 TCP Wrappers。
	# 尽管 TCP Wrappers 提供了一种简单的方法来控制对服务的访问,但随着更高级的防火墙和安全技术（例如 iptables、firewalld）的出现,TCP Wrappers 的使用已经不像过去那样普遍。
	# 然而,在某些环境中,它仍然是一个有效的补充措施。
	echo -e "${YELLOW}正在检查远程登录策略(基于 TCP Wrappers):${NC}"  
	echo -e "${YELLOW}正在检查远程允许策略[/etc/hosts.allow]:${NC}"  
	hostsallow=$(cat /etc/hosts.allow | grep -v '#')
	if [ -n "$hostsallow" ];then
		(echo -e "${RED}[!]允许以下IP远程访问:${NC}" && echo "$hostsallow")  
	else
		echo -e "${YELLOW}[+]hosts.allow文件未发现允许远程访问地址${NC}"  
	fi
	printf "\n"   

	echo -e "${YELLOW}正在检查远程拒绝策略[/etc/hosts.deny]:${NC}"  
	hostsdeny=$(cat /etc/hosts.deny | grep -v '#')
	if [ -n "$hostsdeny" ];then
		(echo -e "${RED}[!]拒绝以下IP远程访问:${NC}" && echo "$hostsdeny")  
	else
		echo -e "${YELLOW}[+]hosts.deny文件未发现拒绝远程访问地址${NC}"  
	fi
	printf "\n"   


	### 1.4 认证与授权
	#### 1.4.1 SSH安全增强 调用函数
	echo -e "[${YELLOW}正在检查SSHD配置策略:${NC}"  
	sshFileCheck
	printf "\n"
	
	#### 1.4.2 PAM策略


	#### 1.4.3 其他认证服务策略 


	## 2. 文件权限及访问控制 
	### 2.1 关键文件保护
	#### 2.1.1 文件权限策略(登录相关文件权限)
	echo -e "${YELLOW}正在检查登陆相关文件权限:${NC}"  
	# echo -e "${YELLOW}正在检查etc文件权限[etc]:${NC}"  
	
	# 检查文件权限函数 (目录不适用)
	check_file_perm(){
		local file_path=$1      # 文件路径
		local expected_perm=$2  # 期望的权限
		local desc=$3 			# 描述

		local RED='\033[0;31m'
		local BLUE='\033[0;34m'
		local YELLOW='\033[0;33m'
		local GREEN='\033[0;32m'
		local NC='\033[0m'

		if [ ! -f "$file_path" ]; then
			echo -e "${RED}[!] 文件 $file_path 不存在！${NC}"
			return
		fi

		local perm=$(stat -c "%A" "$file_path")
		if [ "$perm" == "$expected_perm" ]; then
			echo -e "${YELLOW}[+] $desc 权限正常 ($perm)${NC}"
		else
			echo -e "${RED}[!] $desc 权限异常 ($perm),建议改为 $expected_perm${NC}"
		fi
	}

	echo -e "${YELLOW}正在检查登陆相关文件权限${NC}"
	# check_file_perm "/etc" "drwxr-x---" "/etc (etc)" # /etc 是目录
	check_file_perm "/etc/passwd" "-rw-r--r--" "/etc/passwd (passwd)"
	# check_file_perm "/etc/shadow" "----------" "/etc/shadow (shadow)"
	check_file_perm "/etc/group" "-rw-r--r--" "/etc/group (group)"
	# check_file_perm "/etc/gshadow" "----------" "/etc/gshadow (gshadow)"
	check_file_perm "/etc/securetty" "-rw-------" "/etc/securetty (securetty)"
	check_file_perm "/etc/services" "-rw-r--r--" "/etc/services (services)"
	check_file_perm "/boot/grub2/grub.cfg" "-rw-------" "/boot/grub2/grub.cfg (grub.cfg)"
	check_file_perm "/etc/default/grub" "-rw-r--r--" "/etc/default/grub (grub)"
	check_file_perm "/etc/xinetd.conf" "-rw-------" "/etc/xinetd.conf"
	check_file_perm "/etc/security/limits.conf" "-rw-r--r--" "/etc/security/limits.conf (core dump config)"
	printf "\n"


	# core dump
	# Core Dump（核心转储） 是操作系统在程序异常崩溃（如段错误、非法指令等）时,自动生成的一个文件,记录了程序崩溃时的内存状态和进程信息
	echo -e "${YELLOW}正在检查 core dump 设置[/etc/security/limits.conf]${NC}"
	if (grep -qE '^\*\s+soft\s+core\s+0' /etc/security/limits.conf && grep -qE '^\*\s+hard\s+core\s+0' /etc/security/limits.conf); then
		echo -e "${YELLOW}[+] core dump 已禁用,符合规范${NC}"
		# 虽然 core dump可以辅助排查系统崩溃,但是在生产和安全敏感场景中,core dump推荐禁用
	else
		echo -e "${RED}[!]core dump 未完全禁用,建议添加: * soft core 0 和 * hard core 0 到 limits.conf${NC}"
		# * 所有用户
		# soft 软限制,用户可自行调整上限
		# hard 硬限制,系统管理员可自行调整上限
		# core 0 表示禁止生成core文件
	fi



	#### 2.1.2 系统文件属性
		# 文件属性检查
		# 当一个文件或目录具有 "a" 属性时,只有特定的用户或具有超级用户权限的用户才能够修改、重命名或删除这个文件。
		# 其他普通用户在写入文件时只能进行数据的追加操作,而无法对现有数据进行修改或删除。
		# 属性 "i" 表示文件被设置为不可修改（immutable）的权限。这意味着文件不能被更改、重命名、删除或链接。
		# 具有 "i" 属性的文件对于任何用户或进程都是只读的,并且不能进行写入操作
	# check_file_attributes "/etc/shadow" "/etc/shadow 文件属性" "i"
	check_file_attributes(){
		local file="$1"            # 要检查的文件路径
		local desc="$2"            # 描述信息（可选）
		local required_attr="$3"   # 必须包含的属性,如 "i" 或 "a"（可选）

		local yellow='\033[1;33m'
		local red='\033[0;31m'
		local nc='\033[0m'

		echo -e "${yellow}[+] 正在检查文件属性: $desc (${file})${nc}"

		if [ ! -e "$file" ]; then
			echo -e "${red}[-] 文件 $file 不存在！${nc}"
			return 1
		fi

		# 检查是否支持 lsattr 命令
		if ! command -v lsattr &>/dev/null; then
			echo -e "${red}[-] 未安装 e2fsprogs,无法使用 lsattr 命令,请先安装相关工具包。${nc}"
			return 1
		fi

		# 获取文件属性字符串
		attr=$(lsattr "$file" 2>/dev/null | awk '{print $1}')

		flag=0

		# 检查是否设置 i 属性
		if [[ "$attr" == *i* ]]; then
			echo -e "${yellow}[*] 文件 $file 存在 'i' 安全属性（不可修改/删除）${nc}"
			flag=1
		fi

		# 检查是否设置 a 属性
		if [[ "$attr" == *a* ]]; then
			echo -e "${yellow}[*] 文件 $file 存在 'a' 安全属性（只允许追加）${nc}"
			flag=1
		fi

		# 如果没有设置任何安全属性
		if [ $flag -eq 0 ]; then
			echo -e "${red}[!] 文件 $file 不存在任何安全属性(推荐设置 'i' 或 'a')${nc}"
			echo -e "${red}    建议执行: chattr +i $file (完全保护)或 chattr +a $file (仅追加)${nc}"
			return 1
		else
			return 0
		fi
	}

	echo -e "${YELLOW}正在检查登陆相关文件属性:${NC}"  
	# 调用函数检测文件属性
	check_file_attributes "/etc/passwd" "/etc/passwd 文件属性" 
	check_file_attributes "/etc/shadow" "/etc/shadow 文件属性"
	check_file_attributes "/etc/group" "/etc/group 文件属性"
	check_file_attributes "/etc/gshadow" "/etc/gshadow 文件属性"



	echo -e "${YELLOW}正在检测useradd和userdel时间属性:${NC}"  
	echo -e "${GREEN}Access:访问时间,每次访问文件时都会更新这个时间,如使用more、cat${NC}"  
	echo -e "${GREEN}Modify:修改时间,文件内容改变会导致该时间更新${NC}"  
	echo -e "${GREEN}Change:改变时间,文件属性变化会导致该时间更新,当文件修改时也会导致该时间更新;但是改变文件的属性,如读写权限时只会导致该时间更新,不会导致修改时间更新${NC}"  
	echo -e "${YELLOW}正在检查useradd时间属性[/usr/sbin/useradd ]:${NC}"  
	echo -e "${YELLOW}[+]useradd时间属性:${NC}"  
	stat /usr/sbin/useradd | egrep "Access|Modify|Change" | grep -v '('  
	printf "\n"  

	echo -e "${YELLOW}正在检查userdel时间属性[/usr/sbin/userdel]:${NC}"  
	echo -e "${YELLOW}[+]userdel时间属性:${NC}"  
	stat /usr/sbin/userdel | egrep "Access|Modify|Change" | grep -v '('  
	printf "\n"  




	## 3. 网络配置与服务
	### 3.1 端口和服务审计


	### 3.2 防火墙配置
	#### 防火墙策略检查 firewalld 和 iptables  引用函数
	echo -e "${YELLOW}正在检查防火墙策略:${NC}"
    firewallRulesCheck
	printf "\n"  


	### 3.3 网络参数优化



	## 4. Selinux 策略
	echo -e "${YELLOW}正在检查selinux策略:${NC}"  
	# echo "selinux策略如下:" && grep -vE '#|^\s*$' /etc/sysconfig/selinux
	selinuxStatusCheck
	printf "\n"  

	## 5. 服务配置策略
	### 5.1 NIS(网络信息服务) 配置策略
	# NIS 它允许在网络上的多个系统之间共享一组通用的配置文件,比如密码文件（/etc/passwd）、组文件（/etc/group）和主机名解析文件（/etc/hosts）等
	# NIS 配置问价的一般格式: database: source1 [source2 ...],示例如下:
	# passwd: files nis
	# group: files nis
	# hosts: files dns
	echo -e "${YELLOW}正在检查NIS(网络信息服务)配置:${NC}"
	echo -e "${YELLOW}正在检查NIS配置文件[/etc/nsswitch.conf]:${NC}"  
	nisconfig=$(cat /etc/nsswitch.conf | egrep -v '#|^$')
	if [ -n "$nisconfig" ];then
		(echo -e "${YELLOW}[+]NIS服务配置如下:${NC}" && echo "$nisconfig")  
	else
		echo -e "${RED}[!]未发现NIS服务配置${NC}"  
	fi
	printf "\n"  

	### 5.2 SNMP 服务配置
	# 这个服务不是默认安装的,没安装不存在默认配置文件
	echo -e "${YELLOW}正在检查SNMP(简单网络协议)配置策略:${NC}"  
	echo -e "${YELLOW}正在检查SNMP配置[/etc/snmp/snmpd.conf]:${NC}"  
	if [ -f /etc/snmp/snmpd.conf ];then
		public=$(cat /etc/snmp/snmpd.conf | grep public | grep -v ^# | awk '{print $4}')
		private=$(cat /etc/snmp/snmpd.conf | grep private | grep -v ^# | awk '{print $4}')
		if [ "$public" = "public" ];then
			echo -e "${YELLOW}发现snmp服务存在默认团体名public,不符合要求${NC}"  
			# Community String（团体字符串）:这是 SNMPv1 和 SNMPv2c 中用于身份验证的一个明文字符串。
			# 它类似于密码,用于限制谁可以访问设备的 SNMP 数据。默认情况下,许多设备设置为“public”,这是一个安全隐患,因此建议更改这个值
		fi
		if [ "$private" = "private" ];then
			echo -e "${YELLOW}发现snmp服务存在默认团体名private,不符合要求${NC}"  
		fi
	else
		echo -e "${YELLOW}snmp服务配置文件不存在,可能没有运行snmp服务(使用命令可检测是否安装:[rpm -qa | grep net-snmp])${NC}"  
	fi
	printf "\n"  

	### 5.3 Nginx配置策略
	# 只检查默认安装路径的 nginx 配置文件
	echo -e "${YELLOW}正在检查nginx配置策略:${NC}"  
	echo -e "${YELLOW}正在检查Nginx配置文件[nginx/conf/nginx.conf]:${NC}"  
	# nginx=$(whereis nginx | awk -F: '{print $2}')
	nginx_bin=$(which nginx) 
	if [ -n "$nginx_bin" ];then
		echo -e "${YELLOW}[+]发现主机存在Nginx服务${NC}"  
		echo -e "${YELLOW}[+]Nginx服务二进制文件路径为:$nginx_bin${NC}"  
		# 获取 nginx 配置文件位置,如果 nginx -V 获取不到,则默认为/etc/nginx/nginx.conf
		config_output="$($nginx_bin -V 2>&1)"
		config_path=$(echo "$config_output" | awk '/configure arguments:/ {split($0,a,"--conf-path="); if (length(a[2])>0) print a[2]}')  # 获取 nginx 配置文件路径

		# 如果 awk 命令成功返回了配置文件路径,则使用它,否则使用默认路径
		if [ -n "$config_path" ] && [ -f "$config_path" ]; then
			ngin_conf="$config_path"
		else
			ngin_conf="/etc/nginx/nginx.conf"
		fi

		if [ -f "$ngin_conf" ];then
			(echo -e "${YELLOW}[+]Nginx配置文件可能的路径为:$ngin_conf ${NC}")    # 输出变量值
			echo -e "${YELLOW}[注意]这里只检测nginx.conf主配置文件,其他导入配置文件在主文件同级目录下,请人工排查${NC}"  
			(echo -e "${YELLOW}[+]Nginx配置文件内容为:${NC}" && cat $ngin_conf | grep -v "^$")     # 查看值文件内容
			echo -e "${YELLOW}[+]正在检查Nginx端口转发配置[$ngin_conf]:${NC}"  
			nginxportconf=$(cat $ngin_conf | grep -E "listen|server|server_name|upstream|proxy_pass|location"| grep -v "^$")
			if [ -n "$nginxportconf" ];then
				(echo -e "${YELLOW}[+]可能存在端口转发的情况,请人工分析:${NC}" && echo "$nginxportconf")  
			else
				echo -e "${YELLOW}[+]未发现端口转发配置${NC}"  
			fi
		else
			echo -e "${RED}[!]未发现Nginx配置文件${NC}"  
		fi
	else
		echo -e "${YELLOW}[+]未发现Nginx服务${NC}"  
	fi
	printf "\n"  


	## 6. 日志记录与监控


	## 7. 备份和恢复策略


	## 8. 其他安全配置基准


}

# 检查 Kubernetes 集群基础信息
k8sClusterInfo() {
	# 判断是否为 Kubernetes 环境（目录或命令存在）
    if ! { [ -d /etc/kubernetes ] || command -v kubectl &>/dev/null; }; then
        echo -e "${RED}[!] 未检测到 Kubernetes 环境,退出脚本${NC}"
        exit 0
    fi

    echo -e "${YELLOW}正在检查K8s集群基础信息:${NC}"

	# 检查 Kubernetes 版本信息
    echo -e "\n${YELLOW}[+]正在检查 Kubernetes 版本信息:${NC}"
	# kubectl 命令行工具,通过其向 API server 发送指令
    echo -e "${GREEN}[+] kubectl 版本信息 (客户端/服务端):${NC}"
    if command -v kubectl &>/dev/null; then
        kubectl version 2>&1
    else
        echo -e "${RED}[!] 警告: kubectl 命令未安装,无法获取版本信息${NC}"
    fi

	# kubelet 运行在每个node上运行,用于管理容器的生命周期,检查kubelet服务状态
    echo -e "${GREEN}[+] kubelet 版本信息:${NC}"
    if command -v kubelet &>/dev/null; then
        kubelet --version 2>&1
    else
        echo -e "${RED}[!] 警告: kubelet 命令未安装,无法获取版本信息${NC}"
    fi

    # 检查 Kubernetes 服务状态
    echo -e "${BLUE}1. 检查 Kubernetes 服务状态:${NC}"
    systemctl status kubelet 2>&1 | grep -v "No such process"
    if [ $? -ne 0 ]; then
        echo -e "${RED}kubelet 服务未运行${NC}"
    fi

    echo -e "\n${BLUE}2. 检查集群信息:${NC}"
    kubectl cluster-info 2>&1

    echo -e "\n${BLUE}3. 检查节点状态:${NC}"
    kubectl get nodes 2>&1

    echo -e "\n${BLUE}4. 检查所有命名空间中的 Pod 状态:${NC}"
    kubectl get pods --all-namespaces 2>&1

    echo -e "\n${BLUE}5. 检查系统 Pod 状态:${NC}"
    kubectl get pods -n kube-system 2>&1

    echo -e "\n${BLUE}6. 检查持久卷(PV)状态:${NC}"
    kubectl get pv 2>&1

    echo -e "\n${BLUE}7. 检查持久卷声明(PVC)状态:${NC}"
    kubectl get pvc 2>&1

    echo -e "\n${BLUE}8. 检查服务状态:${NC}"
    kubectl get svc --all-namespaces 2>&1

    echo -e "\n${BLUE}9. 检查部署状态:${NC}"
    kubectl get deployments --all-namespaces 2>&1

    echo -e "\n${BLUE}10. 检查守护进程集状态:${NC}"
    kubectl get daemonsets --all-namespaces 2>&1

    echo -e "\n${BLUE}11. 检查事件信息:${NC}"
    kubectl get events --sort-by=.metadata.creationTimestamp 2>&1

    echo -e "\n${BLUE}12. 检查 Kubernetes 配置文件:${NC}"

    # 定义要检查的 Kubernetes 配置文件路径
    K8S_CONFIG_FILES=(
        "/etc/kubernetes/kubelet.conf"
        "/etc/kubernetes/config"
        "/etc/kubernetes/apiserver"
        "/etc/kubernetes/controller-manager"
        "/etc/kubernetes/scheduler"
    )

    for config_file in "${K8S_CONFIG_FILES[@]}"; do
        if [ -f "$config_file" ]; then
            echo -e "${BLUE}检查配置文件: $config_file${NC}"

            # 检查文件权限
            echo -e "${GREEN}[+] 文件权限:${NC}"
            ls -l "$config_file"

            # 检查常见安全配置项（示例：查看是否设置了认证和授权相关参数）
            echo -e "${GREEN}[+] 关键配置项检查:${NC}"
            grep -E 'client-ca-file|token-auth-file|authorization-mode|secure-port' "$config_file" 2>&1

            # 如果是 kubelet.conf,额外检查是否有 insecure-port 设置为 0
            if [[ "$config_file" == "/etc/kubernetes/kubelet.conf" ]]; then
                echo -e "${GREEN}[+] 检查 kubelet 是否禁用不安全端口:${NC}"
                if grep -q 'insecure-port=0' "$config_file"; then
                    echo -e "${GREEN}✓ 不安全端口已禁用${NC}"
                else
                    echo -e "${RED}[!] 警告: kubelet 的不安全端口未禁用${NC}"
                fi
            fi

            echo -e ""
        else
            echo -e "${RED}[!] 配置文件 $config_file 不存在${NC}"
        fi
    done
}

# 检查 Kubernetes Secrets 安全信息
k8sSecretCheck() {
	# 判断是否为 Kubernetes 环境（目录或命令存在）
    if ! { [ -d /etc/kubernetes ] || command -v kubectl &>/dev/null; }; then
        echo -e "${RED}[!] 未检测到 Kubernetes 环境,退出脚本${NC}"
        exit 0
    fi

    echo -e "${YELLOW}正在检查K8s集群凭据(Secret)信息:${NC}"

    # 创建 k8s 子目录用于存储 Secret 文件
    K8S_SECRET_DIR="${k8s_file}"  # 文件在 init_env 函数已经创建 k8s_file="${check_file}/k8s"
    if [ ! -d "$K8S_SECRET_DIR" ]; then
        mkdir -p "$K8S_SECRET_DIR"
        echo -e "${GREEN}[+] 重新创建目录: $K8S_SECRET_DIR${NC}"
    fi

    echo -e "\n${BLUE}1. 检查 Kubernetes Secrets:${NC}"

    # 获取所有命名空间下的 Secret
    SECRETS=$(kubectl get secrets --all-namespaces 2>&1)
    if echo "$SECRETS" | grep -q "No resources found"; then
        echo -e "${RED}[!] 未发现任何 Secret${NC}"
    else
        echo -e "${GREEN}[+] 发现以下 Secret:${NC}"
        echo "$SECRETS"

        # 列出每个 Secret 的详细信息及其关联的 Pod
        echo "$SECRETS" | awk 'NR>1 {print $1, $2}' | while read -r namespace secret_name; do
            echo -e "\n${BLUE}检查 Secret: $namespace/$secret_name${NC}"

            # 显示 Secret 的详细信息
            kubectl describe secret "$secret_name" -n "$namespace" 2>&1

            # 保存 Secret 原始数据到文件
            SECRET_YAML_FILE="${K8S_SECRET_DIR}/${namespace}_${secret_name}.yaml"
            kubectl get secret "$secret_name" -n "$namespace" -o yaml > "$SECRET_YAML_FILE"
            echo -e "${GREEN}[+] 已保存 Secret 到文件: $SECRET_YAML_FILE${NC}"

            # 检查哪些 Pod 使用了该 Secret
            PODS_USING_SECRET=$(kubectl get pods -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.volumes[?(@.secret.secretName=="'$secret_name'")].secret.secretName}{"\n"}{end}' 2>&1)
            if [ -n "$PODS_USING_SECRET" ]; then
                echo -e "${GREEN}[+] 使用此 Secret 的 Pod:${NC}"
                echo "$PODS_USING_SECRET" | grep -v '^$'
            else
                echo -e "${YELLOW}[i] 此 Secret 当前没有被任何 Pod 使用${NC}"
            fi

            # 检查 Secret 数据内容（以 base64 解码为例）
            echo -e "${GREEN}[+] Secret 数据内容 (Base64 解码):${NC}"
            SECRET_DATA=$(kubectl get secret "$secret_name" -n "$namespace" -o jsonpath='{.data}' 2>&1)
            if [ -n "$SECRET_DATA" ]; then
                echo "$SECRET_DATA" | jq -r 'to_entries[] | "\(.key): \(.value | @base64d)"'
            else
                echo -e "${RED}[i] 无数据或无法获取 Secret 内容${NC}"
            fi
        done
    fi
}

# 收集 Kubernetes 敏感信息（仅查找指定目录下规定后缀的文件）
k8sSensitiveInfo() { 
	# 判断是否为 Kubernetes 环境（目录或命令存在）
    if ! { [ -d /etc/kubernetes ] || command -v kubectl &>/dev/null; }; then
        echo -e "${RED}[!] 未检测到 Kubernetes 环境,退出脚本${NC}"
        exit 0
    fi

    echo -e "${YELLOW}正在收集K8s集群敏感信息(仅查找文件):${NC}"

    # 定义需要扫描的路径列表
    SCAN_PATHS=(
		"/var/lib/kubelet/pods/"
        "/var/run/secrets/kubernetes.io/serviceaccount/"
        "/etc/kubernetes/"
        "/root/.kube/"
        "/run/secrets/"
        "/var/lib/kubelet/config/"
        "/opt/kubernetes/"
        "/usr/local/etc/kubernetes/"
		# "/home/"
		# "/etc/"
		# "/var/lib/docker/"
		# "/usr/"
    )

    # 定义要查找的文件名模式（find -name 格式）
    search_patterns=(
        "*token*"
        "*cert*"
        "*credential*"
        "*.config"
		"*.conf"
        "*.kubeconfig*"
        ".kube/config"
		"ca.crt"
        "namespace"
		"*pass*.*"
		"*.key"
		"*secret"
		"*y*ml"
		"*c*f*g*.json"
    )

    # 创建输出目录用于保存发现的敏感文件
    K8S_SENSITIVE_DIR="${k8s_file}/k8s_sensitive"   # ${check_file}/k8s/k8s_sensitive
    if [ ! -d "$K8S_SENSITIVE_DIR" ]; then
        mkdir -p "$K8S_SENSITIVE_DIR"
        echo -e "${GREEN}[+] 创建目录: $K8S_SENSITIVE_DIR${NC}"
    fi

    # 遍历每个路径
    for path in "${SCAN_PATHS[@]}"; do
        if [ -d "$path" ]; then
            echo -e "${BLUE}[i] 正在扫描路径: $path${NC}"

            # 遍历每个文件模式
            for pattern in "${search_patterns[@]}"; do
                # 使用 find 匹配文件名模式,并安全处理带空格/换行的文件名
                find "$path" -type f -name "$pattern" -print0 2>/dev/null | while IFS= read -r -d '' file; do
                    if [ -f "$file" ]; then
                        echo -e "${RED}[!] 发现敏感文件: $file${NC}"

						# 输出文件内容到终端
						# echo -e "${GREEN}[+] 文件内容如下:${NC}"
						# cat "$file"

                        # 复制文件到输出目录
                        filename=$(basename "$file")
                        cp "$file" "$K8S_SENSITIVE_DIR/${filename}_$(date +%Y%m%d)"
                        echo -e "${GREEN}[+] 已保存敏感文件副本至: $K8S_SENSITIVE_DIR/${filename}_$(date +%Y%m%d)${NC}"
                        echo -e ""
                    fi
                done
            done
        else
            echo -e "${YELLOW}[i] 路径不存在或无权限访问: $path${NC}"
        fi
    done
}

# Kubernetes 基线检查函数
k8sBaselineCheck() {
	# 判断是否为 Kubernetes 环境（目录或命令存在）
    if ! { [ -d /etc/kubernetes ] || command -v kubectl &>/dev/null; }; then
        echo -e "${RED}[!] 未检测到 Kubernetes 环境,退出脚本${NC}"
        exit 0
    fi

    echo -e "${YELLOW}正在执行 Kubernetes 基线安全检查:${NC}"

    echo -e "\n${BLUE}1. 控制平面配置检查:${NC}"
    # 检查 kubelet 配置是否存在 insecure-port=0
    if [ -f /etc/kubernetes/kubelet.conf ]; then
        echo -e "${GREEN}[+] kubelet 是否禁用不安全端口:${NC}"
        if grep -q 'insecure-port=0' /etc/kubernetes/kubelet.conf; then
            echo -e "${GREEN}[+] 不安全端口已禁用${NC}"
        else
            echo -e "${RED}[!] 警告: kubelet 的不安全端口未禁用${NC}"
        fi
    else
        echo -e "${YELLOW}[i] kubelet.conf 文件不存在,跳过检查${NC}"
    fi

    echo -e "\n${BLUE}2. RBAC 授权模式检查:${NC}"
    if [ -f /etc/kubernetes/apiserver ]; then
        echo -e "${GREEN}[+] API Server 是否启用 RBAC:${NC}"
        if grep -q 'authorization-mode=.*RBAC' /etc/kubernetes/apiserver; then
            echo -e "${GREEN}✓ 已启用 RBAC 授权模式${NC}"
        else
            echo -e "${RED}[!] 警告: API Server 未启用 RBAC 授权模式${NC}"
        fi
    else
        echo -e "${YELLOW}[i] apiserver 配置文件不存在,跳过检查${NC}"
    fi

    echo -e "\n${BLUE}3. Pod 安全策略检查:${NC}"
    echo -e "${GREEN}[+] 是否启用 PodSecurityPolicy 或 Pod Security Admission:${NC}"
    psp_enabled=$(kubectl api-resources | grep -E 'podsecuritypolicies|podsecurityadmission')
    if [ -n "$psp_enabled" ]; then
        echo -e "${GREEN}✓ 已启用 Pod 安全策略${NC}"
    else
        echo -e "${RED}[!] 警告: 未检测到任何 Pod 安全策略机制${NC}"
    fi

    echo -e "\n${BLUE}4. 网络策略(NetworkPolicy)检查:${NC}"
    netpolicy_enabled=$(kubectl api-resources | grep networkpolicies)
    if [ -n "$netpolicy_enabled" ]; then
        echo -e "${GREEN}✓ 网络策略功能已启用${NC}"
    else
        echo -e "${RED}[!] 警告: 未启用网络策略(NetworkPolicy),可能导致跨命名空间通信风险${NC}"
    fi

    echo -e "\n${BLUE}5. Secret 加密存储检查:${NC}"
    echo -e "${GREEN}[+] 是否启用 Secret 加密存储:${NC}"
    encryption_config="/etc/kubernetes/encryption-config.yaml"
    if [ -f "$encryption_config" ]; then
        echo -e "${GREEN}✓ 已配置加密存储：$encryption_config${NC}"
    else
        echo -e "${RED}[!] 警告: 未发现 Secret 加密配置文件${NC}"
    fi

    echo -e "\n${BLUE}6. 审计日志检查:${NC}"
    audit_log_path="/var/log/kube-audit/audit.log"
    if [ -f "$audit_log_path" ]; then
        echo -e "${GREEN}✓ 审计日志已启用,路径为: $audit_log_path${NC}"
    else
        echo -e "${RED}[!] 警告: 未发现审计日志文件${NC}"
    fi

    echo -e "\n${BLUE}7. ServiceAccount 自动挂载 Token 检查:${NC}"
    default_sa=$(kubectl get serviceaccount default -o jsonpath='{.automountServiceAccountToken}')
    if [ "$default_sa" = "false" ]; then
        echo -e "${GREEN}✓ 默认 ServiceAccount 未自动挂载 Token${NC}"
    else
        echo -e "${RED}[!] 警告: 默认 ServiceAccount 启用了自动挂载 Token,存在提权风险${NC}"
    fi

    echo -e "\n${BLUE}8. Etcd 安全配置检查:${NC}"
    etcd_config="/etc/kubernetes/manifests/etcd.yaml"
    if [ -f "$etcd_config" ]; then
        echo -e "${GREEN}[+] Etcd 是否启用 TLS 加密:${NC}"
        if grep -q '--cert-file' "$etcd_config" && grep -q '--key-file' "$etcd_config"; then
            echo -e "${GREEN}✓ Etcd 启用了 TLS 加密通信${NC}"
        else
            echo -e "${RED}[!] 警告: Etcd 未启用 TLS 加密通信${NC}"
        fi

        echo -e "${GREEN}[+] Etcd 是否限制客户端访问:${NC}"
        if grep -q '--client-cert-auth' "$etcd_config"; then
            echo -e "${GREEN}✓ Etcd 启用了客户端证书认证${NC}"
        else
            echo -e "${RED}[!] 警告: Etcd 未启用客户端证书认证,可能存在未授权访问风险${NC}"
        fi
    else
        echo -e "${YELLOW}[i] etcd.yaml 配置文件不存在,跳过检查${NC}"
    fi

    echo -e "\n${BLUE}9. 容器运行时安全配置:${NC}"
    echo -e "${GREEN}[+] 是否禁止以 root 用户运行容器:${NC}"
    pod_runasuser=$(kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.spec.securityContext.runAsUser}{"\n"}{end}' | sort -u)
    if echo "$pod_runasuser" | grep -v '^$' | grep -q -v '0'; then
        echo -e "${GREEN}✓ 大多数 Pod 未以 root 用户运行${NC}"
    else
        echo -e "${RED}[!] 警告: 存在以 root 用户运行的容器,请检查 Pod 安全上下文配置${NC}"
    fi

    echo -e "\n${BLUE}10. 特权容器检查:${NC}"
	# 使用检查配置文件件中是否存在 privileged==true 的方式判断是否是特权容器
    privileged_pods=$(kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.spec.containers[?(@.securityContext.privileged==true)]}{"\n"}{end}')
    if [ -z "$privileged_pods" ]; then
        echo -e "${GREEN}✓ 未发现特权容器(privileged)${NC}"
    else
        echo -e "${RED}[!] 警告: 检测到特权容器,建议禁用或限制特权容器运行${NC}"
    fi
}

# k8s排查
k8sCheck() {
    echo -e "${YELLOW}正在检查K8s系统信息:${NC}"
    # 判断环境是否使用 k8s 集群
	if [ -d /etc/kubernetes ] || command -v kubectl &>/dev/null; then 
		echo -e "${YELLOW}[+] 检测到 Kubernetes 环境,开始执行相关检查...${NC}"
		
		# 调用函数
		## 1. 集群基础信息
		k8sClusterInfo
		## 2. 集群安全信息
		k8sSecretCheck
		## 3. 集群敏感信息(会拷贝敏感文件到路径)
		k8sSensitiveInfo
		## 4. 集群基线检查
		k8sBaselineCheck
	else
		echo -e "${RED}[!] 未检测到 Kubernetes 环境,跳过所有 Kubernetes 相关检查${NC}"

	fi
}


# 系统性能评估 【完成】
performanceCheck(){
	# 系统性能评估
	## 磁盘使用情况
	echo -e "${YELLOW}正在检查磁盘使用情况:${NC}"  
	echo -e "${YELLOW}[+]磁盘使用情况如下:${NC}" && df -h   
	printf "\n"  

	echo -e "${YELLOW}正在检查磁盘使用是否过大[df -h]:${NC}"  
	echo -e "${YELLOW}[说明]使用超过70%告警${NC}"  
	df=$(df -h | awk 'NR!=1{print $1,$5}' | awk -F% '{print $1}' | awk '{if ($2>70) print $1,$2}')
	if [ -n "$df" ];then
		(echo -e "${RED}[!]硬盘空间使用过高,请注意!${NC}" && echo "$df" )  
	else
		echo -e "${YELLOW}[+]硬盘空间足够${NC}" 
	fi
	printf "\n"  

	## CPU使用情况
	echo -e "${YELLOW}正在检查CPU用情况[cat /proc/cpuinfo]:${NC}" 
	(echo -e "${YELLOW}CPU硬件信息如下:${NC}" && cat /proc/cpuinfo )  

	## 内存使用情况
	echo -e "${YELLOW}正在分析内存情况:${NC}"  
	(echo -e "${YELLOW}[+]内存信息如下[cat /proc/meminfo]:${NC}" && cat /proc/meminfo)  
	(echo -e "${YELLOW}[+]内存使用情况如下[free -m]:${NC}" && free -m)  
	printf "\n"  

	## 系统运行及负载情况
	echo -e "${YELLOW}系统运行及负载情况:${NC}"  
	echo -e "${YELLOW}正在检查系统运行时间及负载情况:${NC}"  
	(echo -e "${YELLOW}[+]系统运行时间如下[uptime]:${NC}" && uptime)  
	printf "\n"  
	
	# 网络流量情况【没有第三方工具无法检测】
	# yum install nload -y
	# nload ens192 
	echo -e "${YELLOW}网络流量情况:${NC}"
	echo -e "${YELLOW}需要借助第三放工具nload进行流量监控,请自行安装并运行${NC}"
	echo -e "${GREEN}安装命令: yum install nload -y${NC}"
	echo -e "${GREEN}检查命令: nload ens192${NC}"
	
}


# 查找敏感配置文件函数（支持多模式定义）【攻击角度通用】
findSensitiveFiles() {
	# find "/home/" -type f \
	# ! -path "/root/.vscode-server/*" \
	# ! -path "/proc/*" \
	# \( -name '*Jenkinsfile*' -o -name '*.yaml' -o -name '*.yml' -o -name '*.json'  \)
    echo -e "${YELLOW}正在全盘查找敏感配置文件:${NC}"

	# 定义扫描目录
    SCAN_PATHS=(
        "/var/run/secrets/"
        "/etc/kubernetes/"
        "/root/"
        "/home/"
        "/tmp/"
        "/opt/"
		"/etc/"
		"/var/lib/docker/"
		"/usr/"
    )

	# 定义排除目录
    EXCLUDE_DIRS=(
        "/root/.vscode-server/"
        "/proc/"
        "/dev/"
        "/run/"
        "/sys/"
        "*/node_modules/*"
		"*/site-packages/*"
		"*/.cache/*"
    )

	# 定义搜索模式(文件名)
    search_patterns=(
        '*Jenkinsfile*'
        'nacos'
        '*kubeconfig*'
        '.gitlab-ci.yml'
        'conf'
        'config'
        '*.yaml'
        '*.yml'
        '*.json'
        '*.kubeconfig'
        'id_rsa'
        'id_ed25519'
    )

    SENSITIVE_DIR="${check_file}/sensitive_files"
    if [ ! -d "$SENSITIVE_DIR" ]; then
        mkdir -p "$SENSITIVE_DIR"
        echo -e "${GREEN}[+] 创建敏感文件输出目录: $SENSITIVE_DIR${NC}"
    fi

    for path in "${SCAN_PATHS[@]}"; do
        if [ -d "$path" ]; then
            echo -e "${BLUE}[i] 正在扫描路径: $path${NC}"
            find_cmd=(find "$path" -type f)
            for exdir in "${EXCLUDE_DIRS[@]}"; do
                find_cmd+=( ! -path "$exdir*" )
            done
            find_cmd+=( \( )
            for idx in "${!search_patterns[@]}"; do
                find_cmd+=( -name "${search_patterns[$idx]}" )
                if [ $idx -lt $((${#search_patterns[@]}-1)) ]; then
                    find_cmd+=( -o )
                fi
            done
            find_cmd+=( \) )
            files=$("${find_cmd[@]}")
            while IFS= read -r file; do
                [ -z "$file" ] && continue
                echo -e "${RED}[!] 发现敏感文件: $file${NC}"
                # echo -e "${GREEN}[+] 文件内容如下:${NC}"
                # cat "$file"
                filename=$(basename "$file")
                ts=$(date +%Y%m%d%H%M%S)
                cp "$file" "$SENSITIVE_DIR/${ts}_${filename}"
                echo -e "${GREEN}[+] 已保存副本至: $SENSITIVE_DIR/${ts}_${filename}${NC}\n"
            done <<< "$files"
        else
            echo -e "${YELLOW}[i] 路径不存在或无权限访问: $path${NC}"
        fi
    done

}

# 攻击角度信息收集
attackAngleCheck(){
	# 攻击角度信息
	echo -e "${YELLOW}正在进行攻击角度信息采集:${NC}"
	# 调用函数 【查找敏感文件】
	findSensitiveFiles 
	echo -e "${YELLOW}攻击角度信息采集完成${NC}"
}

# 日志统一打包 【完成-暂时没有输出检测报告】
checkOutlogPack(){ 
	# 检查文件统一打包
	echo -e "${YELLOW}正在打包系统原始日志[/var/log]:${NC}"  
	tar -czvf ${log_file}/system_log.tar.gz /var/log/ -P >/dev/null 2>&1
	if [ $? -eq 0 ];then
		echo -e "${YELLOW}[+]日志打包成功${NC}"  
	else
		echo -e "${RED}[!]日志打包失败,请工人导出系统原始日志${NC}"  
	fi
	printf "\n"  


	echo -e "${YELLOW}正在打包linuGun检查日志到/output/目录下:${NC}"  
	# zip -r /tmp/linuxcheck_${ipadd}_${date}.zip /tmp/linuxcheck_${ipadd}_${date}/*
	tar -zcvf ${current_dir}/output/linuxcheck_${ipadd}_${date}.tar.gz  ${current_dir}/output/linuxcheck_${ipadd}_${date}/* -P >/dev/null 2>&1
	if [ $? -eq 0 ];then
		echo -e "${YELLOW}[+]检查文件打包成功${NC}"  
	else
		echo -e "${RED}[!]检查文件打包失败,请工人导出日志${NC}"  
	fi
	
}


#### 主函数入口 ####
main() {
	# 将标准输入的内容同时输出到终端和文件
	log2file() {
		local log_file_path="$1"
		tee -a "$log_file_path" 
	}
	# funcA | log2file "log.txt"
	# --all 输出的函数后面都带上这个输出

	# 初始化环境【含有一些定义变量,必须放在最开头调用】
	init_env
	# 确保 root 权限执行
	ensure_root

    # 检查是否提供了参数
    if [ $# -eq 0 ]; then
		echoBanner
        usage
        exit 1
    fi

    local run_all=false
    local modules=()  # 模块列表,参数选定的模块会追加到这个列表中

    # 解析所有参数
    for arg in "$@"; do
        # 参数和模块绑定  --system[参数] modules+=("system") 模块名 $module 执行函数
        case "$arg" in
            -h|--help)
                usage
                exit 0
                ;;
			--show)
				print_summary
				exit 0
				;;
			--system)
                modules+=("system")
                ;;
			--system-baseinfo)
				modules+=("system-baseinfo")
				;;
			--system-user)
				modules+=("system-user")
				;;
			--system-crontab)
				modules+=("system-crontab")
				;;
			--system-history)
				modules+=("system-history")
				;;
			--network)
				modules+=("network")
				;;
			--psinfo)
				modules+=("psinfo")
				;;
			--file)
				modules+=("file")
				;;
			--file-systemservice)
				modules+=("file-systemservice")
				;;
			--file-dir)
				modules+=("file-dir")
				;;
			--file-keyfiles)
				modules+=("file-keyfiles")
				;;
			--file-systemlog)
				modules+=("file-systemlog")
				;;
			--backdoor)
				modules+=("backdoor")
				;;
			--webshell)
				modules+=("webshell")
				;;
			--virus)
				modules+=("virus")
				;;
			--memInfo)
				modules+=("memInfo")
				;;
			--hackerTools)
				modules+=("hackerTools")
				;;
			--kernel)
				modules+=("kernel")
				;;
			--other)
				modules+=("other")
				;;
			--k8s)
				modules+=("k8s")
				;;
			--k8s-cluster)
				modules+=("k8s-cluster")
				;;
			--k8s-secret)
				modules+=("k8s-secret")
				;;
			--k8s-fscan)
				modules+=("k8s-fscan")
				;;
			--k8s-baseline)
				modules+=("k8s-baseline")
				;;
			--performance)
				modules+=("performance")
				;;
			--baseline)
                modules+=("baseline")
                ;;
			--baseline-firewall)
				modules+=("baseline-firewall")
				;;
			--baseline-selinux)
				modules+=("baseline-selinux")
				;;	
			--attack-filescan)
				modules+=("attack-filescan")
				;;	
            --all)
                run_all=true
                ;;
            *)
                echo -e "${RED}[!] 未知参数: $arg${NC}"
                usage
                exit 1
                ;;
        esac
    done

    # 如果指定了 --all,则运行所有模块
    if [ "$run_all" = true ]; then
        echo -e "${YELLOW}[+] linuGun 开始执行所有检查项:${NC}"
		systemCheck  		| log2file "${check_file}/checkresult.txt"
		networkInfo	 		| log2file "${check_file}/checkresult.txt"
		processInfo			| log2file "${check_file}/checkresult.txt"
		fileCheck			| log2file "${check_file}/checkresult.txt"
		backdoorCheck		| log2file "${check_file}/checkresult.txt"
		webshellCheck		| log2file "${check_file}/checkresult.txt"
		virusCheck			| log2file "${check_file}/checkresult.txt"
		memInfoCheck		| log2file "${check_file}/checkresult.txt"
		hackerToolsCheck	| log2file "${check_file}/checkresult.txt"
		kernelCheck			| log2file "${check_file}/checkresult.txt"
		otherCheck			| log2file "${check_file}/checkresult.txt"
		k8sCheck			| log2file "${check_file}/checkresult.txt"
		performanceCheck	| log2file "${check_file}/checkresult.txt"
		baselineCheck		| log2file "${check_file}/checkresult.txt"
		# 日志打包函数【等待 2s 后在进行打包,解决脚本执行过程中,日志文件未生成或被占用问题】
		sleep 2 
		checkOutlogPack		| log2file "${check_file}/checkresult.txt"
        echo -e "${GREEN}[+] linuGun v6.0 所有检查项已完成${NC}"
		echo -e "${GREEN} Author:sun977${NC}"  
		echo -e "${GREEN} Mail:jiuwei977@foxmail.com${NC}"  
		echo -e "${GREEN} Date:2025.07.03${NC}"  
    elif [ ${#modules[@]} -gt 0 ]; then  # 模块不为空【需要修改】
        for module in "${modules[@]}"; do
			# 模块和执行函数绑定
            case "$module" in
				system)
					systemCheck
					;;
				system-baseinfo)
					baseInfo
					;;
				system-user)
					userInfoCheck
					;;
				system-crontab)
					crontabCheck
					;;
				system-history)
					historyCheck
					;;
				network)
					networkInfo
					;;	
				psinfo)
					processInfo
					;;
				file)
					fileCheck
					;;
				file-systemservice)
					systemServiceCheck
					;;
				file-dir)
					dirFileCheck
					;;
				file-keyfiles)
					specialFileCheck
					;;
				file-systemlog)
					systemLogCheck
					;;
				backdoor)
					backdoorCheck
					;;
				webshell)
					webshellCheck
					;;
				virus)
					virusCheck
					;;
				memInfo)
					memInfoCheck
					;;
				hackerTools)
					hackerToolsCheck
					;;
				kernel)
					kernelCheck
					;;
				other)
					otherCheck
					;;
				k8s)
					k8sCheck
					;;
				k8s-cluster)
					k8sClusterInfo
					;;
				k8s-secret)
					k8sSecretCheck
					;;
				k8s-fscan)
					k8sSensitiveInfo
					;;
				k8s-baseline)
					k8sBaselineCheck
					;;
				performance)
					performanceCheck
					;;
				baseline)
					baselineCheck
					;;
				baseline-firewall)
					firewallRulesCheck
					;;
				baseline-selinux)
					selinuxStatusCheck
					;;
				attack-filescan)
					attackAngleCheck
					;;
            esac
        done
    else
        echo -e "${RED}[!] 未指定任何有效的检查模块${NC}"
        usage
        exit 1
    fi
}

# 显示使用帮助
usage() {
    echo -e "${GREEN}LinuxGun 安全检查工具 v6.0.2 -- 2025.07.02 ${NC}"
    echo -e "${GREEN}使用方法: bash $0 [选项]${NC}"
    echo -e "${GREEN}可用选项:${NC}"
    echo -e "${YELLOW}    -h, --help             ${GREEN}显示此帮助信息${NC}"
	echo -e "${YELLOW}    --show             	 ${GREEN}详细显示linuxGun检测大纲${NC}"

	echo -e "${GREEN}  全量检查:${NC}"
    echo -e "${YELLOW}    --all                   ${GREEN}执行所有检查项(推荐首次运行)${NC}"

    echo -e "${GREEN}  系统相关检查:${NC}"
    echo -e "${YELLOW}    --system                ${GREEN}执行所有系统相关检查(baseinfo/user/crontab/history)${NC}"
    echo -e "${YELLOW}    --system-baseinfo       ${GREEN}检查系统基础信息(IP/版本/发行版)${NC}"
    echo -e "${YELLOW}    --system-user           ${GREEN}用户信息分析(登录用户/克隆用户/非系统用户/口令检查等)${NC}"
    echo -e "${YELLOW}    --system-crontab        ${GREEN}检查计划任务(系统/用户级crontab)${NC}"
    echo -e "${YELLOW}    --system-history        ${GREEN}历史命令分析(.bash_history/.mysql_history/历史下载/敏感命令等)${NC}"

    echo -e "${GREEN}  网络相关检查:${NC}"
    echo -e "${YELLOW}    --network               ${GREEN}网络连接信息(ARP/高危端口/网络连接/DNS/路由/防火墙策略等)${NC}"

    echo -e "${GREEN}  进程相关检查:${NC}"
    echo -e "${YELLOW}    --psinfo                ${GREEN}进程信息分析(ps/top/敏感进程匹配)${NC}"

    echo -e "${GREEN}  文件相关检查:${NC}"
    echo -e "${YELLOW}    --file                  ${GREEN}执行所有文件相关检查(系统服务/敏感目录/关键文件属性/各种日志文件分析)${NC}"
    echo -e "${YELLOW}    --file-systemservice    ${GREEN}系统服务检查(系统服务/用户服务/启动项等)${NC}"
    echo -e "${YELLOW}    --file-dir              ${GREEN}敏感目录检查(/tmp /root/ 隐藏文件等)${NC}"
    echo -e "${YELLOW}    --file-keyfiles         ${GREEN}关键文件检查(SSH相关配置/环境变量/hosts/shadow/24H变动文件/特权文件等)${NC}"
    echo -e "${YELLOW}    --file-systemlog        ${GREEN}系统日志检查(message/secure/cron/yum/dmesg/btmp/lastlog/wtmp等)[/var/log]${NC}"

    echo -e "${GREEN}  后门与攻击痕迹检查:${NC}"
    echo -e "${YELLOW}    --backdoor              ${GREEN}检查后门特征(SUID/SGID/启动项/异常进程)[待完成]${NC}"
    echo -e "${YELLOW}    --webshell              ${GREEN}WebShell 排查(关键词匹配/文件特征)[待完成]${NC}"
    echo -e "${YELLOW}    --virus                 ${GREEN}病毒信息排查(已安装可疑软件/RPM检测)[待完成]${NC}"
    echo -e "${YELLOW}    --memInfo               ${GREEN}内存信息排查(内存占用/异常内容)[待完成]${NC}"
    echo -e "${YELLOW}    --hackerTools           ${GREEN}黑客工具检查(自定义规则匹配)${NC}"

    echo -e "${GREEN}  其他重要检查:${NC}"
    echo -e "${YELLOW}    --kernel                ${GREEN}内核信息与安全配置检查(驱动排查)${NC}"
    echo -e "${YELLOW}    --other                 ${GREEN}其他安全项检查(可以脚本/文件完整性校验/软件排查)${NC}"
	echo -e "${YELLOW}    --performance           ${GREEN}系统性能评估(磁盘/CPU/内存/负载/流量)${NC}"

	echo -e "${GREEN}  Kubernetes 相关检查:${NC}"
    echo -e "${YELLOW}    --k8s                   ${GREEN}Kubernetes 全量安全检查${NC}"
	echo -e "${YELLOW}    --k8s-cluster           ${GREEN}Kubernetes 集群信息检查(集群信息/节点信息/服务信息等)${NC}"
	echo -e "${YELLOW}    --k8s-secret            ${GREEN}Kubernetes 集群凭据信息检查(secret/pod等)${NC}"
	echo -e "${YELLOW}    --k8s-fscan             ${GREEN}Kubernetes 集群敏感信息扫描(默认路径指定后缀文件[会备份敏感文件])${NC}"
	echo -e "${YELLOW}    --k8s-baseline          ${GREEN}Kubernetes 集群安全基线检查${NC}"
    
	echo -e "${GREEN}  系统安全基线相关:${NC}"
    echo -e "${YELLOW}    --baseline              ${GREEN}执行所有基线安全检查项${NC}"
    echo -e "${YELLOW}    --baseline-firewall     ${GREEN}防火墙策略检查(firewalld/iptables)${NC}"
    echo -e "${YELLOW}    --baseline-selinux      ${GREEN}SeLinux 策略检查${NC}"

	echo -e "${GREEN}  攻击角度信息收集[可选|默认不与--all执行]:${NC}"
    echo -e "${YELLOW}    --attack-filescan       ${GREEN}攻击角度信息收集(默认收集当前系统所有敏感文件信息)${NC}"
}

# 主函数执行
main "$@"



