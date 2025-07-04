#!/bin/bash

# IP通信监控脚本 - 检测与指定IP通信的进程
# Version: 1.0.0
# Author: Sun977
# Description: 检测与指定IP通信的进程
# Update: 2025-07-02


# 脚本配置
set -euo pipefail  # 严格错误处理

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 显示使用说明
show_usage() {
    echo -e "${BLUE}用法:${NC} $0 <IP地址> [选项]"
    echo -e "${BLUE}选项:${NC}"
    echo "  -c, --continuous    持续监控模式（按Ctrl+C停止）"
    echo "  -i, --interval N    持续监控时间间隔（秒，默认5秒）"
    echo "  -h, --help         显示此帮助信息"
    echo ""
    echo -e "${BLUE}示例:${NC}"
    echo "  $0 192.168.1.100                    # 单次检测"
    echo "  $0 192.168.1.100 -c                 # 持续监控"
    echo "  $0 192.168.1.100 -c -i 10           # 每10秒监控一次"
}

# 验证IP地址格式
validate_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -ra ADDR <<< "$ip"
        for i in "${ADDR[@]}"; do
            # 检查前导零（除了单独的0）
            if [[ ${#i} -gt 1 && $i =~ ^0 ]]; then
                return 1
            fi
            # 检查数值范围
            if [[ $i -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# 检查必要的命令是否存在
check_dependencies() {
    local available_tools=()
    
    # 检查可用的网络检测工具
    if command -v lsof >/dev/null 2>&1; then
        available_tools+=("lsof")
    fi
    
    if command -v netstat >/dev/null 2>&1; then
        available_tools+=("netstat")
    fi
    
    if command -v ss >/dev/null 2>&1; then
        available_tools+=("ss")
    fi
    
    # 至少需要一个网络检测工具
    if [[ ${#available_tools[@]} -eq 0 ]]; then
        echo -e "${RED}错误: 未找到可用的网络检测工具${NC}"
        echo "请安装以下工具之一: lsof, netstat, ss"
        exit 1
    fi
    
    # 显示将使用的工具
    echo -e "${BLUE}可用的网络检测工具:${NC} ${available_tools[*]}"
}

# 检测ICMP连接（ping等）
get_icmp_connections() {
    local target_ip="$1"
    local found=false
    
    # 检查是否有ping进程正在运行
    local ping_processes
    ping_processes=$(ps aux | grep -E "ping.*${target_ip}" | grep -v grep || true)
    
    if [[ -n "$ping_processes" ]]; then
        echo "$ping_processes" | while read -r line; do
            local user=$(echo "$line" | awk '{print $1}')
            local pid=$(echo "$line" | awk '{print $2}')
            local command=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
            printf "%-20s %-8s %-12s %-10s %-25s %-25s\n" "ping" "$pid" "$user" "ICMP" "-" "$target_ip"
            found=true
        done
    fi
    
    return 0
}

# 使用lsof检测TCP/UDP连接
get_connections_with_lsof() {
    local target_ip="$1"
    local connections
    
    connections=$(lsof -i@"${target_ip}" -n -P 2>/dev/null || true)
    
    if [[ -n "$connections" ]]; then
        echo "$connections" | grep -v "COMMAND" | awk -v target="$target_ip" '
        {
            command = $1
            pid = $2
            user = $3
            protocol = $5
            
            local_addr = ""
            remote_addr = ""
            
            for (i = 9; i <= NF; i++) {
                if ($i ~ target) {
                    if (local_addr == "") {
                        local_addr = $(i-1)
                        remote_addr = $i
                    } else if (remote_addr == "") {
                        remote_addr = $i
                    }
                }
            }
            
            if (local_addr == "" && remote_addr == "") {
                for (i = 8; i <= NF; i++) {
                    if ($i ~ target) {
                        if (i > 8) local_addr = $(i-1)
                        remote_addr = $i
                        break
                    }
                }
            }
            
            if (protocol ~ /TCP/) {
                proto = "TCP"
            } else if (protocol ~ /UDP/) {
                proto = "UDP"
            } else {
                proto = protocol
            }
            
            if (local_addr != "" || remote_addr != "") {
                printf "%-20s %-8s %-12s %-10s %-25s %-25s\n", command, pid, user, proto, local_addr, remote_addr
            }
        }'
    fi
}

# 使用netstat检测TCP/UDP连接
get_connections_with_netstat() {
    local target_ip="$1"
    local connections
    
    # 使用netstat获取连接信息
    connections=$(netstat -tuln 2>/dev/null | grep "$target_ip" || true)
    connections+="\n"$(netstat -tun 2>/dev/null | grep "$target_ip" || true)
    
    if [[ -n "$connections" ]]; then
        echo "$connections" | grep -v "^$" | while read -r line; do
            local proto=$(echo "$line" | awk '{print $1}')
            local local_addr=$(echo "$line" | awk '{print $4}')
            local remote_addr=$(echo "$line" | awk '{print $5}')
            
            # 尝试通过端口找到对应的进程
            local port=$(echo "$remote_addr" | sed 's/.*://')
            local pid_info=$(netstat -tulnp 2>/dev/null | grep ":$port " | head -1 || true)
            
            if [[ -n "$pid_info" ]]; then
                local pid_process=$(echo "$pid_info" | awk '{print $7}' | cut -d'/' -f1)
                local process_name=$(echo "$pid_info" | awk '{print $7}' | cut -d'/' -f2)
                local user=$(ps -o user= -p "$pid_process" 2>/dev/null || echo "unknown")
                
                printf "%-20s %-8s %-12s %-10s %-25s %-25s\n" "$process_name" "$pid_process" "$user" "$proto" "$local_addr" "$remote_addr"
            fi
        done
    fi
}

# 使用ss检测TCP/UDP连接
get_connections_with_ss() {
    local target_ip="$1"
    local connections
    
    # 使用ss获取连接信息
    connections=$(ss -tuln 2>/dev/null | grep "$target_ip" || true)
    connections+="\n"$(ss -tun 2>/dev/null | grep "$target_ip" || true)
    
    if [[ -n "$connections" ]]; then
        echo "$connections" | grep -v "^$" | while read -r line; do
            local proto=$(echo "$line" | awk '{print $1}')
            local local_addr=$(echo "$line" | awk '{print $5}')
            local remote_addr=$(echo "$line" | awk '{print $6}')
            
            # ss输出格式可能包含进程信息
            if echo "$line" | grep -q "users:"; then
                local process_info=$(echo "$line" | sed 's/.*users:((//' | sed 's/)).*//' | head -1)
                local process_name=$(echo "$process_info" | cut -d',' -f1 | tr -d '"')
                local pid=$(echo "$process_info" | cut -d',' -f2)
                local user=$(ps -o user= -p "$pid" 2>/dev/null || echo "unknown")
                
                printf "%-20s %-8s %-12s %-10s %-25s %-25s\n" "$process_name" "$pid" "$user" "$proto" "$local_addr" "$remote_addr"
            fi
        done
    fi
}

# 获取TCP/UDP连接信息（使用可用的工具）
get_tcp_udp_connections() {
    local target_ip="$1"
    
    # 按优先级尝试不同的工具
    if command -v lsof >/dev/null 2>&1; then
        get_connections_with_lsof "$target_ip"
    elif command -v ss >/dev/null 2>&1; then
        get_connections_with_ss "$target_ip"
    elif command -v netstat >/dev/null 2>&1; then
        get_connections_with_netstat "$target_ip"
    fi
    
    return 0
}

# 获取与目标IP通信的进程信息（支持ICMP、TCP、UDP）
get_ip_connections() {
    local target_ip="$1"
    local found_any=false
    
    # 格式化输出表头
    echo -e "${GREEN}与 IP 地址 $target_ip 的连接信息:${NC}"
    echo "--------------------------------------------------------------------"
    printf "%-20s %-8s %-12s %-10s %-25s %-25s\n" "进程名" "PID" "用户" "协议" "本地地址" "远程地址"
    echo "--------------------------------------------------------------------"
    
    # 检测ICMP连接
    local icmp_output
    icmp_output=$(get_icmp_connections "$target_ip")
    if [[ -n "$icmp_output" ]]; then
        echo "$icmp_output"
        found_any=true
    fi
    
    # 检测TCP/UDP连接
    local tcp_udp_output
    tcp_udp_output=$(get_tcp_udp_connections "$target_ip")
    if [[ -n "$tcp_udp_output" ]]; then
        echo "$tcp_udp_output"
        found_any=true
    fi
    
    if [[ "$found_any" == false ]]; then
        echo -e "${YELLOW}未发现与 IP 地址 $target_ip 的活动连接${NC}"
        return 1
    fi
    
    return 0
}

# 主函数
main() {
    local target_ip=""
    local continuous_mode=false
    local interval=5
    
    # 参数解析
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -c|--continuous)
                continuous_mode=true
                shift
                ;;
            -i|--interval)
                if [[ -n "${2:-}" ]] && [[ "$2" =~ ^[0-9]+$ ]]; then
                    interval="$2"
                    shift 2
                else
                    echo -e "${RED}错误: -i 选项需要一个数字参数${NC}"
                    exit 1
                fi
                ;;
            -*)
                echo -e "${RED}错误: 未知选项 $1${NC}"
                show_usage
                exit 1
                ;;
            *)
                if [[ -z "$target_ip" ]]; then
                    target_ip="$1"
                else
                    echo -e "${RED}错误: 只能指定一个IP地址${NC}"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # 检查是否提供了IP地址
    if [[ -z "$target_ip" ]]; then
        echo -e "${RED}错误: 请提供要监控的IP地址${NC}"
        show_usage
        exit 1
    fi
    
    # 验证IP地址格式
    if ! validate_ip "$target_ip"; then
        echo -e "${RED}错误: 无效的IP地址格式: $target_ip${NC}"
        exit 1
    fi
    
    # 检查依赖
    check_dependencies
    
    # 执行监控
    if [[ "$continuous_mode" == true ]]; then
        echo -e "${BLUE}开始持续监控与 IP 地址 $target_ip 的通信，每 $interval 秒刷新一次...${NC}"
        echo -e "${YELLOW}按 Ctrl+C 停止监控${NC}"
        echo ""
        
        # 设置信号处理
        trap 'echo -e "\n${BLUE}监控已停止${NC}"; exit 0' INT TERM
        
        while true; do
            clear
            echo -e "${BLUE}当前时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
            echo ""
            get_ip_connections "$target_ip" || true
            echo ""
            echo -e "${YELLOW}下次刷新: $interval 秒后...${NC}"
            sleep "$interval"
        done
    else
        # 单次检测模式
        echo -e "${BLUE}检测与 IP 地址 $target_ip 的通信...${NC}"
        echo ""
        get_ip_connections "$target_ip"
    fi
}

# 执行主函数
main "$@"