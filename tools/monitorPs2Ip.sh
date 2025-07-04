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
    local missing_deps=()
    
    if ! command -v lsof >/dev/null 2>&1; then
        missing_deps+=("lsof")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${RED}错误: 缺少必要的命令:${NC} ${missing_deps[*]}"
        echo "请安装缺少的工具后重试"
        exit 1
    fi
}

# 获取与目标IP通信的进程信息
get_ip_connections() {
    local target_ip="$1"
    local connections
    
    # 使用lsof获取连接信息，支持IPv4和IPv6
    connections=$(lsof -i@"${target_ip}" -n -P 2>/dev/null || true)
    
    if [[ -z "$connections" ]]; then
        echo -e "${YELLOW}未发现与 IP 地址 $target_ip 的活动连接${NC}"
        return 1
    fi
    
    # 格式化输出
    echo -e "${GREEN}与 IP 地址 $target_ip 的连接信息:${NC}"
    echo "--------------------------------------------------"
    printf "%-20s %-8s %-12s %-25s %-25s\n" "进程名" "PID" "用户" "本地地址" "远程地址"
    echo "--------------------------------------------------"
    
    echo "$connections" | grep -v "COMMAND" | awk -v target="$target_ip" '
    {
        # 提取字段信息
        command = $1
        pid = $2
        user = $3
        
        # 处理网络连接信息（第9列通常是本地地址，第10列是远程地址）
        local_addr = ""
        remote_addr = ""
        
        # 查找包含目标IP的连接
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
        
        # 如果没有找到目标IP，检查是否在其他字段中
        if (local_addr == "" && remote_addr == "") {
            for (i = 8; i <= NF; i++) {
                if ($i ~ target) {
                    if (i > 8) local_addr = $(i-1)
                    remote_addr = $i
                    break
                }
            }
        }
        
        # 输出格式化结果
        if (local_addr != "" || remote_addr != "") {
            printf "%-20s %-8s %-12s %-25s %-25s\n", command, pid, user, local_addr, remote_addr
        }
    }'
    
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