#!/bin/bash

# 网落通信监控脚本 - 检测网落流量(发送和接收字节数)
# Version: 1.0.0
# Author: Sun977
# Description: 检测指定网落的流量情况
# Update: 2025-07-08
# Usage: ./monitorInter.sh <网落接口> [选项]

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
    echo -e "${BLUE}用法:${NC} $0 <网落接口> [选项]"
    echo -e "${BLUE}选项:${NC}"
    echo "  -c, --continuous    持续监控模式(默认为单次检测)"
    echo "  -i, --interval N    监控间隔时间(秒,默认1秒)"
    echo "  -h, --help          显示此帮助信息"
    echo "  -l, --list          列出所有可用的网络接口"
    echo ""
    echo -e "${BLUE}示例:${NC}"
    echo "  $0 eth0             # 单次检测eth0接口(默认1秒间隔)"
    echo "  $0 eth0 -c          # 持续监控eth0接口(默认1秒间隔)"
    echo "  $0 eth0 -c -i 5     # 持续监控eth0接口,每5秒刷新"
    # echo "  $0 -c -i 5 eth0   # 同上,参数顺序可调换"
    echo "  $0 -l               # 列出所有网络接口"
}

# 列出所有可用的网络接口
list_interfaces() {
    echo -e "${BLUE}可用的网落接口:${NC}"
    echo "--------------------------------------------------------------------"
    printf "%-15s %-10s %-15s %-20s\n" "接口名" "状态" "IP地址" "描述"
    echo "--------------------------------------------------------------------"
    
    for interface in /sys/class/net/*; do
        local int_name=$(basename "$interface")
        
        # 跳过回环接口
        if [[ "$int_name" == "lo" ]]; then
            continue
        fi
        
        # 获取接口状态
        local status="DOWN"
        if [[ -f "$interface/operstate" ]]; then
            local operstate=$(cat "$interface/operstate")
            if [[ "$operstate" == "up" ]]; then
                status="UP"
            fi
        fi
        
        # 获取IP地址
        local ip_addr="-"
        if command -v ip >/dev/null 2>&1; then
            ip_addr=$(ip addr show "$int_name" 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1 | head -1 || echo "-")
        fi
        
        # 获取接口描述(如果有的话)
        local description="网络接口"
        if [[ "$int_name" =~ ^eth ]]; then
            description="以太网接口"
        elif [[ "$int_name" =~ ^wlan ]]; then
            description="无线网络接口"
        elif [[ "$int_name" =~ ^docker ]]; then
            description="Docker接口"
        elif [[ "$int_name" =~ ^br ]]; then
            description="网桥接口"
        fi
        
        # 根据状态设置颜色
        if [[ "$status" == "UP" ]]; then
            printf "%-15s ${GREEN}%-10s${NC} %-15s %-20s\n" "$int_name" "$status" "$ip_addr" "$description"
        else
            printf "%-15s ${RED}%-10s${NC} %-15s %-20s\n" "$int_name" "$status" "$ip_addr" "$description"
        fi
    done
}

# 验证网络接口是否存在
validate_interface() {
    local interface="$1"
    
    if [[ ! -d "/sys/class/net/$interface" ]]; then
        echo -e "${RED}错误: 网络接口 '$interface' 不存在${NC}"
        echo -e "${YELLOW}提示: 使用 '$0 -l' 查看所有可用接口${NC}"
        return 1
    fi
    
    return 0
}

# 验证时间间隔参数
validate_interval() {
    local interval="$1"
    
    if ! [[ "$interval" =~ ^[0-9]+$ ]] || [[ "$interval" -lt 1 ]]; then
        echo -e "${RED}错误: 监控间隔必须是大于0的整数${NC}"
        return 1
    fi
    
    return 0
}

# 检查必要的文件是否存在
check_dependencies() {
    local interface="$1"
    local stats_dir="/sys/class/net/$interface/statistics"
    
    # 检查统计文件是否存在
    local required_files=("tx_packets" "rx_packets" "tx_bytes" "rx_bytes")
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$stats_dir/$file" ]]; then
            echo -e "${RED}错误: 无法访问接口统计信息 $stats_dir/$file${NC}"
            return 1
        fi
    done
    
    return 0
}

# 格式化字节数显示
format_bytes() {
    local bytes="$1"
    
    if [[ "$bytes" -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ "$bytes" -lt 1048576 ]]; then
        echo "$(( bytes / 1024 ))KB"
    elif [[ "$bytes" -lt 1073741824 ]]; then
        echo "$(( bytes / 1048576 ))MB"
    else
        echo "$(( bytes / 1073741824 ))GB"
    fi
}

# 获取接口统计信息
get_interface_stats() {
    local interface="$1"
    local stats_dir="/sys/class/net/$interface/statistics"
    
    # 读取统计信息
    local tx_packets=$(cat "$stats_dir/tx_packets")
    local rx_packets=$(cat "$stats_dir/rx_packets")
    local tx_bytes=$(cat "$stats_dir/tx_bytes")
    local rx_bytes=$(cat "$stats_dir/rx_bytes")
    
    echo "$tx_packets $rx_packets $tx_bytes $rx_bytes"
}

# 显示接口信息
show_interface_info() {
    local interface="$1"
    
    echo -e "${BLUE}接口信息:${NC}"
    echo "--------------------------------------------------------------------"
    
    # 获取接口状态
    local status="DOWN"
    if [[ -f "/sys/class/net/$interface/operstate" ]]; then
        local operstate=$(cat "/sys/class/net/$interface/operstate")
        if [[ "$operstate" == "up" ]]; then
            status="UP"
        fi
    fi
    
    # 获取IP地址
    local ip_addr="-"
    if command -v ip >/dev/null 2>&1; then
        ip_addr=$(ip addr show "$interface" 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1 | head -1 || echo "-")
    fi
    
    # 获取MAC地址
    local mac_addr="-"
    if [[ -f "/sys/class/net/$interface/address" ]]; then
        mac_addr=$(cat "/sys/class/net/$interface/address")
    fi
    
    echo "接口名称: $interface"
    if [[ "$status" == "UP" ]]; then
        echo -e "接口状态: ${GREEN}$status${NC}"
    else
        echo -e "接口状态: ${RED}$status${NC}"
    fi
    echo "IP地址: $ip_addr"
    echo "MAC地址: $mac_addr"
    echo ""
}

# 监控接口流量
monitor_interface() {
    local interface="$1"    # 接口名称
    local interval="$2"     # 监控间隔
    local single_mode="$3"  # 监控模式
    
    # 显示接口信息
    show_interface_info "$interface"
    
    if [[ "$single_mode" == false ]]; then
         echo -e "${BLUE}开始持续监控接口 $interface 的流量,每 $interval 秒刷新一次...${NC}"
         echo -e "${YELLOW}按 Ctrl+C 停止监控${NC}"
         echo ""
         
         # 设置信号处理
         trap 'echo -e "\n${BLUE}监控已停止${NC}"; exit 0' INT TERM
     else
         echo -e "${BLUE}单次检测接口 $interface 的流量(间隔 $interval 秒)...${NC}"
         echo ""
     fi
    
    # 获取初始统计信息
    local stats_old
    stats_old=$(get_interface_stats "$interface")
    read -r txpkts_old rxpkts_old txbytes_old rxbytes_old <<< "$stats_old"
    
    if [[ "$single_mode" == true ]]; then
        # 单次检测模式
        sleep "$interval"
        
        local stats_new
        stats_new=$(get_interface_stats "$interface")
        read -r txpkts_new rxpkts_new txbytes_new rxbytes_new <<< "$stats_new"
        
        # 计算差值
        local txpkts=$((txpkts_new - txpkts_old))
        local rxpkts=$((rxpkts_new - rxpkts_old))
        local txbytes=$((txbytes_new - txbytes_old))
        local rxbytes=$((rxbytes_new - rxbytes_old))
        
        # 计算速率
        local tx_rate=$((txbytes / interval))
        local rx_rate=$((rxbytes / interval))
        
        echo -e "${GREEN}流量统计 (${interval}秒内):${NC}"
        echo "--------------------------------------------------------------------"
        printf "%-10s %-15s %-15s %-15s %-15s\n" "方向" "数据包" "字节数" "速率" "格式化速率"
        echo "--------------------------------------------------------------------"
        printf "%-10s %-15s %-15s %-15s %-15s\n" "发送(TX)" "$txpkts" "$txbytes" "${tx_rate}B/s" "$(format_bytes $tx_rate)/s"
        printf "%-10s %-15s %-15s %-15s %-15s\n" "接收(RX)" "$rxpkts" "$rxbytes" "${rx_rate}B/s" "$(format_bytes $rx_rate)/s"
        
        return 0
    fi
    
    # 持续监控模式
    while true; do
        sleep "$interval"
        
        # 获取新的统计信息
        local stats_new
        stats_new=$(get_interface_stats "$interface")
        read -r txpkts_new rxpkts_new txbytes_new rxbytes_new <<< "$stats_new"
        
        # 计算差值
        local txpkts=$((txpkts_new - txpkts_old))
        local rxpkts=$((rxpkts_new - rxpkts_old))
        local txbytes=$((txbytes_new - txbytes_old))
        local rxbytes=$((rxbytes_new - rxbytes_old))
        
        # 计算速率
        local tx_rate=$((txbytes / interval))
        local rx_rate=$((rxbytes / interval))
        
        # 清屏并显示当前时间
        clear
        echo -e "${BLUE}当前时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
        echo ""
        
        # 显示接口信息
        show_interface_info "$interface"
        
        # 显示流量信息
        echo -e "${GREEN}实时流量统计:${NC}"
        echo "--------------------------------------------------------------------"
        printf "%-10s %-15s %-15s %-15s %-15s\n" "方向" "数据包/s" "字节/s" "速率" "格式化速率"
        echo "--------------------------------------------------------------------"
        printf "%-10s %-15s %-15s %-15s %-15s\n" "发送(TX)" "$txpkts" "$txbytes" "${tx_rate}B/s" "$(format_bytes $tx_rate)/s"
        printf "%-10s %-15s %-15s %-15s %-15s\n" "接收(RX)" "$rxpkts" "$rxbytes" "${rx_rate}B/s" "$(format_bytes $rx_rate)/s"
        echo ""
        echo -e "${YELLOW}下次刷新: $interval 秒后...${NC}"
        
        # 更新旧值
        txpkts_old=$txpkts_new
        rxpkts_old=$rxpkts_new
        txbytes_old=$txbytes_new
        rxbytes_old=$rxbytes_new
    done
}

# 主函数
main() {
    local interface=""
    local interval="1"  # 默认间隔1秒
    local continuous_mode=false  # 默认单次检测模式
    
    # 参数解析
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -l|--list)
                list_interfaces
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
                if [[ -z "$interface" ]]; then
                    interface="$1"
                else
                    echo -e "${RED}错误: 只能指定一个网落接口${NC}"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # 检查必需参数
    if [[ -z "$interface" ]]; then
        echo -e "${RED}错误: 请指定要监控的网落接口${NC}"
        show_usage
        exit 1
    fi
    
    # 验证参数
    if ! validate_interface "$interface"; then
        exit 1
    fi
    
    if ! validate_interval "$interval"; then
        exit 1
    fi
    
    # 检查依赖
    if ! check_dependencies "$interface"; then
        exit 1
    fi
    
    # 开始监控(注意：这里将continuous_mode取反传递给monitor_interface的single_mode参数)
    local single_mode=true
    if [[ "$continuous_mode" == true ]]; then
        single_mode=false
    fi
    
    monitor_interface "$interface" "$interval" "$single_mode"
}

# 执行主函数
main "$@"