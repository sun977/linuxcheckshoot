#!/bin/bash
HELL=/bin/bash 
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# 更新功能,所有系统通用【等待更新】
# 使用函数形式优化代码
# 模块化：linuxgun.sh --[option] 的方式调用各个模块
# 根据参数执行不同的功能 
# 输出 放在最后的处理函数上,内部函数不在单独设置输出
# [INFO] 提示输出 -- 提示
# [NOTE] 注意输出 -- 需要注意
# [WARN] 警告输出 -- 重点关注
# [KNOW] 知识点
# [ERRO] 错误输出

# if [[ "$1" == "--ps" ]] || [[ "$1" == "-p" ]]; then
#     check_nginx_ps
# elif [[ "$1" == "--inject" ]] || [[ "$1" == "-i" ]]; then
#     inject_config "$2" "$3"
# else
#     echo "Description:"
#     echo "  - This script is used to inject SOC configuration into the nginx.conf"
#     echo "  - This script can only be used once, and the original nginx.conf will be backed up"
#     echo "Usage: $0 [option] [nginx_path] [nginx_conf_path]"
#     echo "Options:"
#     echo "  -p, --ps    Check the nginx process information"
#     echo "  -i, --inject   Inject the SOC configuration into the nginx configuration file"
#     echo "Example:"
#     echo "  $0 -c"
#     echo "  $0 -i /usr/sbin/nginx /etc/nginx/nginx.conf"
# fi

# 大纲 summary
# 系统信息排查
#  - 系统基础信息
#  - 用户信息分析
#  - 计划任务分析
#  - 历史命令分析
	# - 输出当前shell系统历史命令[history]
	# - 输出用系历史命令[.bash_history]
	# - 是否下载过脚本文件
	# - 是否通过主机下载,传输过文件
	# - 是否增加,删除过账号
	# - 是否执行过黑客命令
	# - 其他敏感命令
	# - 检查系统中所有可能的历史文件路径[补充]
	# - 输出系统中所有用户的历史文件[补充]
# 网络链接排查
#  - ARP 攻击分析
#  - 网络连接分析
# 进程排查
#  - ps进程分析
#  - top进程分析
#  - 敏感进程匹配[规则匹配]
# 文件排查
#  - 系统服务排查
	# - 系统服务收集
	# - 系统服务分析
	# 	- 系统自启动服务分析
	# 	- 系统正在运行的服务分析
	# - 用户服务分析
#  - 敏感目录排查
	# - /tmp目录
	# - /root目录(隐藏文件)
#  - 新增文件排查
#  - 特殊文件排查
	# - ssh相关文件排查
	# - 环境变量排查
	# - shadow文件排查
#  - 隐藏文件排查
#  - 日志文件分析
# 后门排查
# webshell排查
# 病毒排查
# 其他排查
# 基线检查
# k8s排查

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
date=$(date +%Y%m%d)
# 取出本机器上第一个非回环地址的IP地址,用于区分导出的文件
ipadd=$(ip addr | grep -w inet | grep -v 127.0.0.1 | awk 'NR==1{print $2}' | sed 's#/\([0-9]\+\)#_\1#') # 192.168.1.1_24

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
echo "LinuxGun v5.0 检查项" > ${check_file}/checkresult.txt
echo "" >> ${check_file}/checkresult.txt
echo "检查发现危险项,请注意:" > ${check_file}/dangerlist.txt
echo "" >> ${check_file}/dangerlist.txt

# 判断目录是否存在
if [ ! -d "$check_file" ];then
	echo "检查 ${check_file} 目录不存在,请检查"
	exit 1
fi

if [ $(whoami) != "root" ];then
	echo "安全检查必须使用root账号,否则某些项无法检查"
	exit 1
fi

# ------------------------

# 在 check_file 下追加模式打开文件，将输出结果展示在终端且同时保存到对应文件中 
cd $check_file  
saveCheckResult="tee -a checkresult.txt" 
saveDangerResult="tee -a dangerlist.txt"

# ------------------------

################################################################

# 颜色：分割线:绿色 检查项:黄色 错误项和注意项:红色 输出项:蓝色

# banner 函数  格式需要调整
echoBanner() {
    echo -e "${YELLOW}****************************************************************${NC}"
    echo -e "${BLUE}      __     __                      ______                     ${NC}"
    echo -e "${BLUE}     / /    /_/____   __  __ _  __ / ____/__  __ ____           ${NC}"
    echo -e "${BLUE}    / /    / // __ \ / / / /| |/_// / __ / / / // __ \\         ${NC}"
    echo -e "${BLUE}   / /___ / // / / // /_/ /_>  < / /_/ // /_/ // / / /          ${NC}"
    echo -e "${BLUE}  /_____//_//_/ /_/ \__,_//_/|_| \____/ \__,_//_/ /_/           ${NC}"
    echo -e "${BLUE}                                                                ${NC}" 
    echo -e "${BLUE}                                                Version:5.0     ${NC}"
    echo -e "${BLUE}                                                Author:sun977   ${NC}"
    echo -e "${BLUE}                                                Date:2024.7.29  ${NC}"
	echo -e "${YELLOW}****************************************************************${NC}"
    echo -e "${GREEN}检查内容:${NC}"
    echo -e "${GREEN}    1.采集系统基础环境信息${NC}"
    echo -e "${GREEN}    2.将原始数据进行分析,并找出存在可疑或危险项${NC}"
    echo -e "${GREEN}    3.基线检查的功能${NC}"
    echo -e "${GREEN}    4.黑客工具检查的功能${NC}"
    echo -e "${GREEN}如何使用:${NC}"
    echo -e "${GREEN}    1.需要将本脚本上传到相应的服务器中${NC}"
    echo -e "${GREEN}    2.执行 chmod +x linuxgun.sh${NC}"
    echo -e "${GREEN}    3.执行 ./linuxgun.sh 即可运行检查${NC}"
	echo -e "${YELLOW}================================================================${NC}"
}

# 采集系统基础信息【归档 -- systemCheck】
baseInfo(){
    echo -e "${GREEN}==========${YELLOW}1.Get System Info${GREEN}==========${NC}"
    echo -e "${YELLOW}[1.0]Get System Basic Info${NC}"  
    echo -e "${YELLOW}[1.1]IP地址信息[ip addr]:${NC}"  
    ip=$(ip addr | grep -w inet | awk '{print $2}')
    if [ -n "$ip" ];then
        (echo -e "${YELLOW}[+]本机IP地址信息:${NC}" && echo "$ip")   
    else
        echo -e "${RED}[!]本机未配置IP地址${NC}"  
    fi

    # 系统版本信息
    echo -e "${YELLOW}[1.2]系统版本信息[uname -a]:${NC}"  
    unameInfo=$(uname -a)
    if [ -n "$unameInfo" ];then
        # (echo -e "${YELLOW}[+]系统内核版本信息:${NC}" && echo "$unameInfo")  
        echo -e "${YELLOW}[+]系统版本信息如下:${NC}"  
        osName=$(echo $unameInfo | awk '{print $1}')  # 系统名称
        hostName=$(echo $unameInfo | awk '{print $2}')  # 主机名
        kernelVerson=$(echo $unameInfo | awk '{print $3}')  # 内核版本
        arch=$(echo $unameInfo | awk '{print $12}')  # 系统架构
        echo -e "${YELLOW}[+]系统名称:$osName${NC}"  
        echo -e "${YELLOW}[+]主机名:$hostName${NC}"  
        echo -e "${YELLOW}[+]内核版本:$kernelVerson${NC}"  
        echo -e "${YELLOW}[+]系统架构:$arch${NC}"  
    
    else
        echo -e "${RED}[!]未发系统版本信息${NC}"  
    fi

    # 系统发行版本
    echo -e "${YELLOW}[1.3]系统发行版本信息[/etc/*-release]:${NC}"  
    systemver=$(cat /etc/*-release)
    if [ -n "$systemver" ];then
        (echo -e "${YELLOW}[+]系统发行版本信息:${NC}" && echo "$systemver")  
    else
        echo -e "${RED}[!]未发现系统发行版本信息${NC}"  
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
            # "Change:改变时间,文件属性变化会导致该时间更新,当文件修改时也会导致该时间更新;但是改变文件的属性,如读写权限时只会导致该时间更新，不会导致修改时间更新

			# # 检测可疑计划任务[可以写在内部，但是颜色有点问题]
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
	# - 实时历史: history 命令显示的是当前 shell 会话中已经执行过的命令历史，包括那些在当前会话中输入的命令。默认显示 500 条命令，可以通过 -c 参数清除历史记录。
	# - 动态更新: 当你在 shell 会话中执行命令时，这些命令会被实时添加到历史记录中，因此 history 命令的输出会随着你的命令输入而不断更新。
	# - 受限于当前会话: history 命令只显示当前 shell 会话的历史记录。如果关闭了终端再重新打开，history 命令将只显示新会话中的命令历史，除非你使用了历史文件共享设置。
	# - 命令编号: history 命令的输出带有命令编号，这使得引用特定历史命令变得容易。你可以使用 !number 形式来重新执行历史中的任意命令
	# cat /[user]/.bash_history:
	# - 持久化历史: /[user]/.bash_history 文件是 bash shell 保存的命令历史文件，它保存了用户过去执行的命令，即使在关闭终端或注销后，这些历史记录也会被保留下来。
	# - 静态文件: /[user]/.bash_history 是一个文件，它的内容不会随着你当前会话中的命令输入而实时更新。文件的内容会在你退出终端会话时更新，bash 会把当前会话的命令追加到这个文件中。
	# - 不受限于当前会话: cat /[user]/.bash_history 可以显示用户的所有历史命令，包括以前会话中的命令，而不只是当前会话的命令。
	# - 无命令编号: 由于 /[user]/.bash_history 是一个普通的文本文件，它的输出没有命令编号，你不能直接使用 !number 的方式来引用历史命令。
	# 注意: 大多数情况下 linux 系统会为每个用户创建一个 .bash_history 文件。
	# 		set +o history 是关闭命令历史记录功能，set -o history 重新打开[只影响当前的 shell 会话]
	
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
			# 如果文件非空，输出历史命令
			(echo -e "${YELLOW}[+]操作系统历史命令如下:${NC}" && echo "$history") 
		else
			# 如果文件为空，输出警告信息
			echo -e "${RED}[!]未发现历史命令,请检查是否记录及已被清除${NC}" 
		fi
	else
		# 如果文件不存在，同样输出警告信息
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

	# 检查历史记录目录，看是否被备份，注意：这里可以看开容器持久化的.bash_history
	echo -e "${YELLOW}[+]输出系统中所有可能的.bash_history*文件路径:${NC}"
	findOut=$(find / -name ".bash_history*" -type f -exec ls -l {} \;) # 输出所有.bash_history文件[包含容器]
	if [ -n "$findOut" ]; then
		echo -e "${YELLOW}以下历史命令文件如有未检查需要人工手动检查，有可能涵盖容器内 history 文件${NC}"
		(echo -e "${YELLOW}[+]系统中所有可能的.bash_history*文件如下:${NC}" && echo "$findOut") 
	else
		echo -e "${RED}[!]未发现系统中存在历史命令文件,请人工检查机器是否被清理攻击痕迹${NC}" 
	fi

	# 输出其他用户的历史命令[cat /[user]/.bash_history]
	# 使用awk处理/etc/passwd文件，提取用户名和主目录，并检查.bash_history文件
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
	# 4. 遍历步骤1中获取的每个用户名，并检查其是否与步骤2中获取的任何用户名匹配，并且根据步骤3是否允许空密码进行判断。如果存在匹配，则打印通知，表示存在空密码且允许登录的用户。
	# 5. 最后，根据是否找到匹配，打印警告消息，要求人工分析配置和账户，或者打印消息表示未发现空口令且可登录的用户。
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
				# 分析系统启动项 【这里只是启动服务项，不包括其他服务项，所以在这里检查不完整，单独检查吧】
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
				# 分析系统启动项 【这里只是运行中服务项，不包括其他服务项，所以在这里检查不完整，单独检查吧】
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

# 系统服务排查 【完成】
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


# 敏感目录排查【归档 -- 】
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

# SSH登录配置排查
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
	if [ "$protocolver" -eq "2" ];then
		echo -e "${YELLOW}[+]openssh使用ssh2协议${NC}" 
	else
		echo -e "${YELLOW}[!]openssh未ssh2协议,版本过低${NC}"
	fi

	# ssh版本分析 -- 罗列几个有漏洞的ssh版本
	echo -e "${YELLOW}正在检查SSH版本[ssh -V]:${NC}"
	sshver=$(ssh -V)
	if [ -n "$sshver" ];then
		echo -e "${YELLOW}[+]ssh版本信息如下:${NC}" && echo "$sshver"
	else
		echo -e "${RED}[+]未发现ssh版本信息,请注意这是异常现象!${NC}"
	fi

	# 其他
}


# 特殊文件排查【归档 -- 】
specialFileCheck(){
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

	# shadow文件分析 【好几个 shadow】	
	## shadow 内容 权限 属性
	echo -e "${YELLOW}[+]正在检查shadow文件[/etc/shadow]:${NC}"
	shadow_tmp=$(cat /etc/shadow)
	if [ -n "$shadow_tmp" ];then
		# 输出 shadow 文件内容
		echo -e "${YELLOW}[+]shadow文件如下:${NC}" && echo "$shadow_tmp"
		
		# 文件权限检查
		echo -e "${YELLOW}[+]shadow文件权限如下:${NC}"
		shadow_au=$(ls -l /etc/shadow | awk '{print $1}')
		if [ "${shadow_au:1:9}" = "rw-------" ]; then
			echo -e "${YELLOW}[+]/etc/shadow文件权限为600,权限符合规范${NC}" 
		else
			echo -e "${YELLOW}[!]/etc/shadow文件权限为:""${shadow_au:1:9}"",不符合规范,权限应改为600${NC}" 
		fi
		
		# 文件属性检查
		# 当一个文件或目录具有 "a" 属性时，只有特定的用户或具有超级用户权限的用户才能够修改、重命名或删除这个文件。
		# 其他普通用户在写入文件时只能进行数据的追加操作，而无法对现有数据进行修改或删除。
		# 属性 "i" 表示文件被设置为不可修改（immutable）的权限。这意味着文件不能被更改、重命名、删除或链接。
		# 具有 "i" 属性的文件对于任何用户或进程都是只读的，并且不能进行写入操作
		echo -e "${YELLOW}[+]正在检查shadow文件属性:${NC}"
		flag=0
		for ((x=1;x<=15;x++))
		do
			apend=$(lsattr /etc/shadow | cut -c $x)
			if [ $apend = "i" ];then
				echo "/etc/shadow文件存在i安全属性,符合要求" 
				flag=1
			fi
			if [ $apend = "a" ];then
				echo "/etc/shadow文件存在a安全属性" 
				flag=1
			fi
		done
		if [ $flag = 0 ];then
			echo "/etc/shadow文件不存在相关安全属性,建议使用chattr +i或chattr +a防止/etc/shadow被删除或修改" 
		fi
		printf "\n" 

	else
		echo -e "${RED}[!]未发现shadow文件${NC}"
	fi
	printf "\n"

	## gshadow 内容 权限 属性
	echo -e "${YELLOW}[+]正在检查gshadow文件[/etc/gshadow]:${NC}"
	gshadow_tmp=$(cat /etc/gshadow)
	if [ -n "$gshadow_tmp" ];then
		# 输出 gshadow 文件内容
		echo -e "${YELLOW}[+]gshadow文件如下:${NC}" && echo "$gshadow_tmp"
		
		# 文件权限检查
		echo -e "${YELLOW}[+]gshadow文件权限如下:${NC}"


		# 文件属性检查
		echo -e "${YELLOW}[+]正在检查gshadow文件属性:${NC}"

	else
		echo -e "${RED}[!]未发现gshadow文件${NC}"
	fi
	printf "\n"

	# 黑客工具检查匹配【迁移出去】
	# /proc/<pid>/[cmdline|environ|fd/*] 【迁移出去】
	
	# 24小时内新增文件分析
	# 24小时内修改文件分析
	echo -e "${YELLOW}正在检查最近24小时内变动的敏感文件[py|sh|per|pl|php|asp|jsp|exe]:${NC}" 
	echo -e "${YELLOW}[说明] find / -mtime -1 -type f ${NC}" 
	echo -e "${YELLOW}[注意]不检查/proc,/dev,/sys,/run目录,需要检查请自行修改脚本,脚本需要人工判定是否有害 ${NC}" 
	find_tmp=$(find / ! \( -path "/proc/*" -o -path "/dev/*" -o -path "/sys/*" -o -path "/run/*" \) -mtime -1 -type f | grep -E "\.(py|sh|per|pl|php|asp|jsp|exe)$")
	if [ -n "$find_tmp" ];then
		echo -e "${YELLOW}[+]最近24小时内变动的敏感文件如下:${NC}" && echo "$find_tmp"
	else
		echo -e "${RED}[!]未发现最近24小时内变动的敏感文件${NC}"
	fi
	printf "\n" 

	echo -e "${YELLOW}正在检查最近24小时内变动的所有文件:${NC}" 
	#查看最近24小时内有改变的文件类型文件，排除内容目录/proc /dev /sys  
	echo -e "${YELLOW}[注意]不检查/proc,/dev,/sys,/run目录,需要检查请自行修改脚本,脚本需要人工判定是否有害 ${NC}" 
	find_tmp2=$(find / ! \( -path "/proc/*" -o -path "/dev/*" -o -path "/sys/*" -o -path "/run/*" \) -type f -mtime -1) 
	if [ -n "$find_tmp2" ];then
		echo -e "${YELLOW}[+]最近24小时内变动的所有文件如下:${NC}" && echo "$find_tmp2"
	else
		echo -e "${RED}[!]未发现最近24小时内变动的所有文件${NC}"
	fi
	printf "\n"

	# SUID/SGID Files 可用于提权 
	## SUID(Set User ID) 文件是一种特殊权限文件,它允许文件拥有者以root权限运行,而不需要root权限。
	## SGID(Set Group ID) 文件是一种特殊权限文件,任何用户运行该文件时都会以文件所属组的权限执行,对于目录,SGID目录下创建的文件会继承该组的权限。
	echo -e "${YELLOW}[+]正在检查SUID/SGID文件:${NC}"
	echo -e "${YELLOW}[注意]如果SUID/SGID文件同时出现在最近24H变换检测中,说明机器有极大概率已经中招${NC}"
	find_suid=$(find / -type f -perm -4000 -ls)
	if [ -n "$find_suid" ];then
		echo -e "${YELLOW}[+]SUID文件如下:${NC}" && echo "$find_suid"
	fi

	find_sgid=$(find / -type f -perm -2000 -ls)
	if [ -n "$find_sgid" ];then
		echo -e "${YELLOW}[+]SGID文件如下:${NC}" && echo "$find_sgid"
	fi


	# 其他
}


# 系统日志分析
systemLogCheck(){
	# 日志配置与打包
	# secure日志分析
	# message日志分析
	# cron日志分析
	# yum/apt日志分析 
	# dmesg日志分析
	# btmp日志分析
	# lastlog日志分析
	# wtmp日志分析
	# journalctl日志分析
}

# 文件信息排查
fileCheck(){
	# 系统服务排查 systemServiceCheck
	# 敏感目录排查 dirFileCheck
	# 新增文件排查 specialFileCheck
	# 隐藏文件排查 dirFileCheck
	# 特殊文件排查 sshCheck | specialFileCheck
	# 日志文件分析 systemLogCheck 【重点】
}

# 后门排查
backdoorCheck(){
	# 常见后门目录 /tmp /usr/bin /usr/sbin 
}

# webshell 排查
webshellCheck(){
	# 检查网站常见的目录
	# 访问日志
}

# 病毒排查
virusCheck(){
	# 基础排查
	# 病毒特有行为排查
}

# 内存和VFS排查
memInfoCheck(){
	# /proc/<pid>/[cmdline|environ|fd/*]
}

# 黑客工具排查
hackerToolsCheck(){
	# 黑客工具排查
	# 常见黑客痕迹排查
}

# 其他排查
otherCheck(){
}

# 基线检查
baselineCheck(){
	# 基线检查
}

# k8s排查
k8sCheck(){
}


# 攻击角度信息收集
attackAngleCheck(){
	# 
}















echo "[9.13]正在检查登陆相关文件权限:" | $saveCheckResult
echo "[9.13.1]正在检查etc文件权限[etc]:" | $saveCheckResult
etc=$(ls -l / | grep etc | awk '{print $1}')
if [ "${etc:1:9}" = "rwxr-x---" ]; then
    echo "[+]/etc/权限为750,权限正常" | $saveCheckResult
else
    echo "[!]/etc/文件权限为:""${etc:1:9}","权限不符合规划,权限应改为750" | $saveCheckResult
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
printf "\n" | $saveCheckResult



echo "[12.5]正在检查全盘是否存在黑客工具[./checkrules/hackertoolslist.txt]:" | $saveCheckResult
# hacker_tools_list="nc sqlmap nmap xray beef nikto john ettercap backdoor *proxy msfconsole msf *scan nuclei *brute* gtfo Titan zgrab frp* lcx *reGeorg nps spp suo5 sshuttle v2ray"
# 从 hacker_tools_list 列表中取出一个工具名然后全盘搜索
# hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
echo "[说明]定义黑客工具列表文件hackertoolslist.txt,全盘搜索该列表中的工具名,如果存在则告警(工具文件可自行维护)" | $saveCheckResult
for hacker_tool in `cat ${current_dir}/checkrules/hackertoolslist.txt`
do
	findhackertool=$(find / -name $hacker_tool 2>/dev/null)
	if [ -n "$findhackertool" ];then
		(echo "[!]发现全盘存在可疑黑客工具:$hacker_tool" && echo "$findhackertool") |  $saveDangerResult | $saveCheckResult
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


echo "[14.4]正在分析cron日志:" | $saveCheckResult
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


echo "[14.9]正在分析wtmp日志[last]:" | $saveCheckResult
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


echo "[18.3]正在分析内存情况:" | $saveCheckResult
echo "[18.3.1]正在检查内存相关信息:" | $saveCheckResult
(echo "[+]内存信息如下[more /proc/meminfo]:" && more /proc/meminfo) | $saveCheckResult
(echo "[+]内存使用情况如下[free -m]:" && free -m) | $saveCheckResult
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
echo "Author:sun977" | $saveCheckResult
echo "Mail:jiuwei977@foxmail.com" |	$saveCheckResult
echo "Date:2024.6.16" | $saveCheckResult
