#!/bin/bash

# IP封禁管理脚本 - 支持iptables和firewall的IP封禁与解封
# Version: 1.0.0
# Author: Sun977
# Description: 支持iptables和firewall两种工具的IP封禁、解封、批量操作功能
# Update: 2025-07-14
# Usage: ./blockIP.sh [选项] <IP地址|IP文件>

# 脚本配置
set -euo pipefail  # 严格错误处理

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认配置
DEFAULT_TOOL="auto"         # 默认自动检测工具
DEFAULT_ACTION="block"      # 默认操作为封禁
DEFAULT_LOG_FILE="./outBlockIP.log"   # 输出日志文件[当前目录位置]
DEFAULT_BACKUP_DIR="./firewall_backup"  # 默认备份目录 

# 显示使用说明
show_usage() {
    echo -e "${BLUE}说明:${NC} 本脚本用于封禁IP地址,支持iptables和firewall两种工具的IP封禁与解封功能"
    echo -e "${RED}[!!!]注意:${NC} 本脚本会备份iptables和firewall的配置文件,但安全起见请自行先备份一遍(如因此导致配置文件丢失本人概不负责)"
    echo -e "${BLUE}用法:${NC} $0 [选项] <IP地址(IPv4)|IP文件>"
    echo -e "${BLUE}选项:${NC}"
    echo "  -h, --help          显示此帮助信息"
    echo "  -b, --block         封禁IP地址(默认操作)"
    echo "  -u, --unblock       解封IP地址"
    echo "  -t, --tool TOOL     指定防火墙工具: iptables, firewall, auto(默认自动选择工具)"
    echo "  -f, --file FILE     从文件批量处理IP地址"
    echo "  -l, --list          列出当前封禁的IP地址"
    echo "  -c, --check IP      检查指定IP是否被封禁"
    echo "  -s, --status        显示防火墙状态"
    echo "  --backup            备份当前防火墙规则"
    echo "  --restore FILE      从备份文件恢复防火墙规则"
    echo "  --backup-dir DIR    指定备份目录(默认:$DEFAULT_BACKUP_DIR)"
    echo "  --log-file FILE     指定日志文件(默认:$DEFAULT_LOG_FILE)"
    echo "  --show-run          预览模式仅显示将要执行的命令,不实际执行"
    echo ""
    echo -e "${BLUE}示例:${NC}"
    echo "  $0 192.168.1.100                            # 封禁单个IP(自动检测工具)"
    echo "  $0 -u 192.168.1.100                         # 解封单个IP"
    echo "  $0 -t iptables 192.168.1.100                # 使用iptables封禁IP(使用前请确认iptables已安装)"
    echo "  $0 -t firewall -u 192.168.1.100             # 使用firewall解封IP(使用前请确认firewall已安装)"
    echo "  $0 -f ip_list.txt                           # 从文件批量封禁IP"
    echo "  $0 -f ip_list.txt -u                        # 从文件批量解封IP"
    echo "  $0 -l                                       # 列出当前封禁的IP"
    echo "  $0 -c 192.168.1.100                         # 检查IP是否被封禁"
    echo "  $0 -s                                       # 显示防火墙状态"
    echo "  $0 --backup                                 # 备份当前防火墙规则(firewall和iptables都备份)"
    echo "  $0 --backup --backup-dir /path/to/backup    # 自定义备份目录"
    echo "  $0 --restore backup_20250101.tar.gz         # 从备份文件恢复规则"
    echo "  $0 --show-run -f ip_list.txt                # 预览模式下展示从文件批量封禁IP命令但不执行"
    echo "  $0 --backup --show-run                      # 预览模式下展示备份命令但不执行"
}

# 记录日志
log_message() {
    local level="$1"    # 定义日志级别(INFO,WARN,ERROR,DEBUG)
    local message="$2"  # 定义日志消息,可以自定义
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # 使用LOG_FILE变量，如果未设置则使用默认值
    local log_file="${LOG_FILE:-$DEFAULT_LOG_FILE}"
    
    # 确保日志目录存在
    local log_dir=$(dirname "$log_file")
    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir" 2>/dev/null || true
    fi
    
    # 写入日志文件
    echo "[$timestamp] [$level] $message" >> "$log_file" 2>/dev/null || true
    
    # 同时输出到控制台
    case "$level" in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        *)
            echo -e "${RED}[DEBUG]${NC} $message"
            ;;
    esac
}

# 检测可用的防火墙工具,有工具返回 0 ,并输出工具名(firewall|iptables),没防火墙工具时返回 1
# 优先级: firewall > iptables
detect_firewall_tool() {
    # 优先检查firewall-cmd，如果可用则优先使用
    if command -v firewall-cmd >/dev/null 2>&1; then
        # 检查firewalld服务是否运行
        if systemctl is-active --quiet firewalld 2>/dev/null; then
            echo "firewall"
            return 0
        fi
    fi
    
    # 如果firewall不可用，则使用iptables
    if command -v iptables >/dev/null 2>&1; then
        echo "iptables"
        return 0
    fi
    
    echo "none"   # 没有可用的防火墙工具
    return 1
}

# 验证IP地址格式
validate_ip() {
    # 验证IP地址格式是否正确,合法返回0,否则返回1
    local ip="$1"
    
    # IPv4地址验证
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        IFS='.' read -ra ADDR <<< "$ip"
        for i in "${ADDR[@]}"; do
            if [[ $i -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    fi
    
    # IPv6地址验证(简单验证)
    if [[ $ip =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]; then
        return 0
    fi
    
    return 1
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_message "ERROR" "此脚本需要root权限运行"  # 调用log_message函数输出错误信息
        exit 1
    fi
}

# 使用iptables封禁IP
iptables_block_ip() {
    # 执行成功返回 0 ,失败返回 1
    local ip="$1"       # 传入的IP地址
    local dry_run="$2"  # 是否为预览模式(预览模式仅输出命令不执行)
    
    # 构建 iptables 封禁 IP 命令
    local cmd="iptables -I INPUT -s $ip -j DROP"   
    
    # 如果是预览模式则直接输出命令并返回,否则直接跳过并执行后面逻辑,下一步逻辑：检查IP是否已被封禁
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}[show-run]${NC} $cmd"
        return 0
        # 返回 0 则终止,后面的命令不再执行
    fi
    
    # 检查IP是否已被封禁,如果已被封禁则直接返回0,不执行后面的命令
    if iptables -L INPUT -n | grep -q "$ip"; then
        log_message "WARN" "IP $ip 已经被iptables封禁,无需重复封禁"
        return 0
    fi
    
    # 执行封禁 ip 的命令
    if $cmd; then
        log_message "INFO" "使用iptables成功封禁IP: $ip"
        return 0
    else
        log_message "ERROR" "使用iptables封禁IP失败: $ip"
        return 1
    fi
}

# 使用iptables解封IP
iptables_unblock_ip() {
    local ip="$1"       # 要解封的IP
    local dry_run="$2"  # 是否是预览模式运行,默认为false
    
    # 构建 iptables 解封 IP 命令
    local cmd="iptables -D INPUT -s $ip -j DROP"
    
    # 如果是预览模式,则只打印命令,不实际执行命令,否则继续执行后续逻辑判断
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}[show-run]${NC} $cmd"
        return 0
    fi
    
    # 检查IP是否已经被封禁,如果未找到 IP 则说明该IP未被封禁,不需要再次解封,后续逻辑不再执行
    if ! iptables -L INPUT -n | grep -q "$ip"; then
        log_message "WARN" "IP $ip 未被iptables封禁,无需重复解封"
        return 0  # 返回 0 后续逻辑不再执行
    fi
    
    # 使用iptables命令解封IP
    if $cmd; then
        log_message "INFO" "使用iptables成功解封IP: $ip"
        return 0
    else
        log_message "ERROR" "使用iptables解封IP失败: $ip"
        return 1
    fi
}

# 使用firewall封禁IP
firewall_block_ip() {
    local ip="$1"       # IP地址
    local dry_run="$2"  # 是否为预览模式
    
    # 构建 firrewall 封禁 IP 命令
    local cmd="firewall-cmd --permanent --add-rich-rule='rule family=\"ipv4\" source address=\"$ip\" drop'"
    # 重载 firrewall
    local reload_cmd="firewall-cmd --reload"
    
    # 判断是否是预览模式,是则只输出命令,不执行,后续逻辑不再继续
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}[show-run]${NC} $cmd"
        echo -e "${YELLOW}[show-run]${NC} $reload_cmd"
        return 0
    fi
    
    # 检查IP是否已被封禁
    if firewall-cmd --list-rich-rules | grep -q "source address=\\\"$ip\\\""; then
        log_message "WARN" "IP $ip 已经被firewall封禁,无需重复封禁"
        return 0
    fi
    
    # 执行封禁命令
    if $cmd && $reload_cmd; then
        log_message "INFO" "使用firewall成功封禁IP: $ip"
        return 0
    else
        log_message "ERROR" "使用firewall封禁IP失败: $ip"
        return 1
    fi
}

# 使用firewall解封IP
firewall_unblock_ip() {
    local ip="$1"       # IP地址
    local dry_run="$2"  # 是否为预览模式运行
    
    local cmd="firewall-cmd --permanent --remove-rich-rule='rule family=\"ipv4\" source address=\"$ip\" drop'"
    local reload_cmd="firewall-cmd --reload"
    
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}[show-run]${NC} $cmd"
        echo -e "${YELLOW}[show-run]${NC} $reload_cmd"
        return 0
    fi
    
    # 检查IP是否被封禁
    if ! firewall-cmd --list-rich-rules | grep -q "source address=\\\"$ip\\\""; then
        log_message "WARN" "IP $ip 未被firewall封禁,无需重复解封"
        return 0
    fi
    
    if $cmd && $reload_cmd; then
        log_message "INFO" "使用firewall成功解封IP: $ip"
        return 0
    else
        log_message "ERROR" "使用firewall解封IP失败: $ip"
        return 1
    fi
}

# 封禁IP
block_ip() {
    local ip="$1"       # IP地址
    local tool="$2"     # 工具名称
    local dry_run="$3"  # 是否为预览模式运行
    
    # 检测IP的有效性
    if ! validate_ip "$ip"; then
        log_message "ERROR" "无效的IP地址: $ip"
        return 1
    fi
    
    # 根据工具名称选择操作方式 
    case "$tool" in
        "iptables")
            iptables_block_ip "$ip" "$dry_run"  # 调用iptables_block_ip函数封禁
            ;;
        "firewall")
            firewall_block_ip "$ip" "$dry_run"  # 调用firewall_block_ip函数封禁
            ;;
        *)
            log_message "ERROR" "不支持的工具: $tool"
            return 1
            ;;
    esac
}

# 解封IP
unblock_ip() {
    local ip="$1"       # 传入的IP地址
    local tool="$2"     # 使用的工具
    local dry_run="$3"  # 是否为预览模式
    
    # 验证IP地址有效性
    if ! validate_ip "$ip"; then
        log_message "ERROR" "无效的IP地址: $ip"
        return 1
    fi
    
    case "$tool" in
        "iptables")
            iptables_unblock_ip "$ip" "$dry_run"    # 调用 iptables_unblock_ip 函数解封IP
            ;;
        "firewall")
            firewall_unblock_ip "$ip" "$dry_run"    # 调用 firewall_unblock_ip 函数解封IP
            ;;
        *)
            log_message "ERROR" "不支持的工具: $tool"
            return 1
            ;;
    esac
}

# 从文件批量处理IP
process_ip_file() {
    local file="$1"     # 输入文件
    local action="$2"   # 操作类型    # block 封禁, unblock 解封
    local tool="$3"     # 工具名称    # iptables, firewall
    local dry_run="$4"  # 是否为预览模式运行
    
    # 检查文件是否存在
    if [[ ! -f "$file" ]]; then
        log_message "ERROR" "文件不存在: $file"
        return 1
    fi
    
    local total=0   # 总数
    local success=0 # 成功数
    local failed=0  # 失败数
    
    echo -e "${BLUE}开始批量处理IP地址文件: $file${NC}"
    echo "--------------------------------------------------------------------"
    
    # 循环读取文件并处理
    while IFS= read -r line; do
        # 跳过空行和注释行(以#开头的行是注释行)
        if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
            continue # 跳过空行和注释行
        fi
        
        # 提取IP地址(去除空格和注释)
        local ip=$(echo "$line" | awk '{print $1}') # 提取第一列的内容
        
        if [[ -n "$ip" ]]; then
            # 每处理一个 IP 总数 +1 
            total=$((total + 1))
            
            # 判断操作类型
            if [[ "$action" == "block" ]]; then     # 如果是封禁操作
                if block_ip "$ip" "$tool" "$dry_run"; then      # 调用 block_ip 函数封禁IP
                    # 成功总数 +1
                    success=$((success + 1))
                else
                    # 失败总数 +1
                    failed=$((failed + 1))
                fi
            else    # 如果是解封操作
                if unblock_ip "$ip" "$tool" "$dry_run"; then    # 调用 unblock_ip 函数解封IP
                    success=$((success + 1))
                else
                    failed=$((failed + 1))
                fi
            fi
        fi
    done < "$file"
    
    echo "--------------------------------------------------------------------"
    echo -e "${BLUE}批量处理完成:${NC}"
    echo "  总计: $total"
    echo -e "  成功: ${GREEN}$success${NC}"
    echo -e "  失败: ${RED}$failed${NC}"
}

# 列出被封禁的IP
list_blocked_ips() {
    local tool="$1"     # 工具名称(iptable|firewall|auto)
    
    echo -e "${BLUE}当前被封禁的IP地址:${NC}"
    echo "--------------------------------------------------------------------"
    
    case "$tool" in
        "iptables")
            echo -e "${YELLOW}iptables规则:${NC}"
            iptables -L INPUT -n --line-numbers | grep DROP | grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" || echo "  无封禁IP"
            ;;
        "firewall")
            echo -e "${YELLOW}firewall规则:${NC}"
            firewall-cmd --list-rich-rules | grep "drop" || echo "  无封禁IP"
            ;;
        "auto")
            echo -e "${YELLOW}iptables规则:${NC}"
            iptables -L INPUT -n --line-numbers | grep DROP | grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" || echo "  无封禁IP"
            echo ""
            echo -e "${YELLOW}firewall规则:${NC}"
            if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
                firewall-cmd --list-rich-rules | grep "drop" || echo "  无封禁IP"
            else
                echo "  firewalld未运行"
            fi
            ;;
    esac
}

# 检查IP是否被封禁
check_ip_blocked() {
    local ip="$1"       # IP地址
    local tool="$2"     # 检查工具
    
    # 检查IP格式有效性
    if ! validate_ip "$ip"; then
        log_message "ERROR" "无效的IP地址: $ip"
        return 1
    fi
    
    echo -e "${BLUE}检查IP $ip 的封禁状态:${NC}"
    echo "--------------------------------------------------------------------"
    
    # 默认 信号量 状态为未封禁 false
    local blocked=false
    
    case "$tool" in
        "iptables")
            if iptables -L INPUT -n | grep -q "$ip"; then
                echo -e "${RED}iptables: 已封禁 $ip ${NC}"
                blocked=true
            else
                echo -e "${GREEN}iptables: 未封禁 $ip ${NC}"
            fi
            ;;
        "firewall")
            if firewall-cmd --list-rich-rules | grep -q "source address=\\\"$ip\\\""; then
                echo -e "${RED}firewall: 已封禁 $ip ${NC}"
                blocked=true
            else
                echo -e "${GREEN}firewall: 未封禁 $ip ${NC}"
            fi
            ;;
        "auto")
            if iptables -L INPUT -n | grep -q "$ip"; then
                echo -e "${RED}iptables: 已封禁 $ip ${NC}"
                blocked=true
            else
                echo -e "${GREEN}iptables: 未封禁 $ip ${NC}"
            fi
            
            if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
                if firewall-cmd --list-rich-rules | grep -q "source address=\\\"$ip\\\""; then
                    echo -e "${RED}firewall: 已封禁 $ip  ${NC}"
                    blocked=true
                else
                    echo -e "${GREEN}firewall: 未封禁 $ip ${NC}"
                fi
            else
                echo -e "${YELLOW}firewall: 服务未运行${NC}"
            fi
            ;;
    esac
    
    echo "--------------------------------------------------------------------"
    # 检测信号量 blockd 
    if [[ "$blocked" == "true" ]]; then
        echo -e "${RED}结果: IP $ip 已被封禁${NC}"
    else
        echo -e "${GREEN}结果: IP $ip 未被封禁${NC}"
    fi
}

# 备份防火墙规则
backup_firewall_rules() {
    local backup_dir="$1"  # 备份目录
    local dry_run="$2"    # 是否为预览模式
    
    # 创建备份目录
    if [[ "$dry_run" != "true" ]]; then
        if [[ ! -d "$backup_dir" ]]; then
            mkdir -p "$backup_dir" || {
                log_message "ERROR" "无法创建备份目录: $backup_dir"
                return 1
            }
        fi
    fi
    
    # 生成备份文件名(包含时间戳)
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_file="$backup_dir/firewall_backup_$timestamp.tar.gz"
    
    echo -e "${BLUE}开始备份防火墙规则...${NC}"
    echo "--------------------------------------------------------------------"
    
    # 创建临时目录用于存放备份文件
    local temp_dir="/tmp/firewall_backup_$$"
    
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}[show-run]${NC} mkdir -p $temp_dir"
        echo -e "${YELLOW}[show-run]${NC} iptables-save > $temp_dir/iptables.rules"
        if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
            echo -e "${YELLOW}[show-run]${NC} firewall-cmd --list-all-zones > $temp_dir/firewall_zones.conf"
            echo -e "${YELLOW}[show-run]${NC} firewall-cmd --list-rich-rules > $temp_dir/firewall_rich_rules.conf"
            echo -e "${YELLOW}[show-run]${NC} cp -r /etc/firewalld/ $temp_dir/firewalld_config/"
        fi
        echo -e "${YELLOW}[show-run]${NC} tar -czf $backup_file -C $temp_dir ."
        echo -e "${YELLOW}[show-run]${NC} rm -rf $temp_dir"
        log_message "INFO" "预览模式: 备份文件将保存到 $backup_file"
        return 0
    fi
    
    # 创建临时目录
    mkdir -p "$temp_dir" || {
        log_message "ERROR" "无法创建临时目录: $temp_dir"
        return 1
    }
    
    # 备份iptables规则
    if command -v iptables >/dev/null 2>&1; then
        if iptables-save > "$temp_dir/iptables.rules" 2>/dev/null; then
            log_message "INFO" "iptables规则备份成功"
        else
            log_message "WARN" "iptables规则备份失败"
        fi
    fi
    
    # 备份firewall规则
    if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
        # 备份zone配置
        if firewall-cmd --list-all-zones > "$temp_dir/firewall_zones.conf" 2>/dev/null; then
            log_message "INFO" "firewall zones配置备份成功"
        else
            log_message "WARN" "firewall zones配置备份失败"
        fi
        
        # 备份rich rules
        if firewall-cmd --list-rich-rules > "$temp_dir/firewall_rich_rules.conf" 2>/dev/null; then
            log_message "INFO" "firewall rich rules备份成功"
        else
            log_message "WARN" "firewall rich rules备份失败"
        fi
        
        # 备份firewalld配置文件
        if [[ -d "/etc/firewalld" ]]; then
            if cp -r /etc/firewalld/ "$temp_dir/firewalld_config/" 2>/dev/null; then
                log_message "INFO" "firewalld配置文件备份成功"
            else
                log_message "WARN" "firewalld配置文件备份失败"
            fi
        fi
    fi
    
    # 创建备份信息文件
    cat > "$temp_dir/backup_info.txt" << EOF
# 防火墙规则备份信息
# 备份时间: $(date '+%Y-%m-%d %H:%M:%S')
# 备份主机: $(hostname)
# 系统信息: $(uname -a)
# 脚本版本: 1.0.0

# 备份内容:
# - iptables.rules: iptables规则
# - firewall_zones.conf: firewall zones配置
# - firewall_rich_rules.conf: firewall rich rules
# - firewalld_config/: firewalld配置目录
EOF
    
    # 创建压缩包
    if tar -czf "$backup_file" -C "$temp_dir" . 2>/dev/null; then
        log_message "INFO" "备份文件创建成功: $backup_file"
        echo -e "${GREEN}备份完成!${NC}"
        echo "备份文件: $backup_file"
        echo "备份大小: $(du -h "$backup_file" | cut -f1)"
    else
        log_message "ERROR" "备份文件创建失败"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # 清理临时目录
    rm -rf "$temp_dir"
    
    echo "--------------------------------------------------------------------"
    return 0
}

# 恢复防火墙规则
restore_firewall_rules() {
    local backup_file="$1"  # 备份文件路径
    local dry_run="$2"     # 是否为预览模式
    
    # 检查备份文件是否存在
    if [[ ! -f "$backup_file" ]]; then
        log_message "ERROR" "备份文件不存在: $backup_file"
        return 1
    fi
    
    echo -e "${BLUE}开始恢复防火墙规则...${NC}"
    echo "--------------------------------------------------------------------"
    echo "备份文件: $backup_file"
    
    # 创建临时目录用于解压备份文件
    local temp_dir="/tmp/firewall_restore_$$"
    
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}[show-run]${NC} mkdir -p $temp_dir"
        echo -e "${YELLOW}[show-run]${NC} tar -xzf $backup_file -C $temp_dir"
        echo -e "${YELLOW}[show-run]${NC} iptables-restore < $temp_dir/iptables.rules"
        if command -v firewall-cmd >/dev/null 2>&1; then
            echo -e "${YELLOW}[show-run]${NC} cp -r $temp_dir/firewalld_config/* /etc/firewalld/"
            echo -e "${YELLOW}[show-run]${NC} systemctl reload firewalld"
        fi
        echo -e "${YELLOW}[show-run]${NC} rm -rf $temp_dir"
        log_message "INFO" "预览模式: 将从备份文件 $backup_file 恢复规则"
        return 0
    fi
    
    # 创建临时目录
    mkdir -p "$temp_dir" || {
        log_message "ERROR" "无法创建临时目录: $temp_dir"
        return 1
    }
    
    # 解压备份文件
    if ! tar -xzf "$backup_file" -C "$temp_dir" 2>/dev/null; then
        log_message "ERROR" "无法解压备份文件: $backup_file"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # 显示备份信息
    if [[ -f "$temp_dir/backup_info.txt" ]]; then
        echo -e "${YELLOW}备份信息:${NC}"
        grep "^# " "$temp_dir/backup_info.txt" | sed 's/^# //'
        echo "--------------------------------------------------------------------"
    fi
    
    # 恢复iptables规则
    if [[ -f "$temp_dir/iptables.rules" ]] && command -v iptables-restore >/dev/null 2>&1; then
        if iptables-restore < "$temp_dir/iptables.rules" 2>/dev/null; then
            log_message "INFO" "iptables规则恢复成功"
        else
            log_message "ERROR" "iptables规则恢复失败"
        fi
    fi
    
    # 恢复firewall规则
    if [[ -d "$temp_dir/firewalld_config" ]] && command -v firewall-cmd >/dev/null 2>&1; then
        # 备份当前配置
        if [[ -d "/etc/firewalld" ]]; then
            cp -r /etc/firewalld/ "/etc/firewalld.backup.$(date +%s)" 2>/dev/null || true
        fi
        
        # 恢复配置文件
        if cp -r "$temp_dir/firewalld_config/"* /etc/firewalld/ 2>/dev/null; then
            log_message "INFO" "firewalld配置文件恢复成功"
            
            # 重新加载firewalld
            if systemctl is-active --quiet firewalld 2>/dev/null; then
                if systemctl reload firewalld 2>/dev/null; then
                    log_message "INFO" "firewalld服务重新加载成功"
                else
                    log_message "WARN" "firewalld服务重新加载失败"
                fi
            else
                log_message "WARN" "firewalld服务未运行,请手动启动服务"
            fi
        else
            log_message "ERROR" "firewalld配置文件恢复失败"
        fi
    fi
    
    # 清理临时目录
    rm -rf "$temp_dir"
    
    echo -e "${GREEN}恢复完成!${NC}"
    echo "--------------------------------------------------------------------"
    return 0
}

# 显示防火墙状态
show_firewall_status() {
    echo -e "${BLUE}防火墙状态:${NC}"
    echo "--------------------------------------------------------------------"
    
    # 检查iptables
    if command -v iptables >/dev/null 2>&1; then
        echo -e "${GREEN}iptables: 已安装${NC}"
        local blocked_count=$(iptables -L INPUT -n | grep DROP | grep -c -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" || echo "0")
        echo "  当前封禁IP数量: $blocked_count"
    else
        echo -e "${RED}iptables: 未安装${NC}"
    fi
    
    echo ""
    
    # 检查firewalld
    if command -v firewall-cmd >/dev/null 2>&1; then
        echo -e "${GREEN}firewalld: 已安装${NC}"
        if systemctl is-active --quiet firewalld 2>/dev/null; then
            echo -e "  服务状态: ${GREEN}运行中${NC}"
            local blocked_count=$(firewall-cmd --list-rich-rules | grep -c "drop" || echo "0")
            echo "  当前封禁IP数量: $blocked_count"
        else
            echo -e "  服务状态: ${RED}未运行${NC}"
        fi
    else
        echo -e "${RED}firewalld: 未安装${NC}"
    fi
    
    echo ""
    
    # 推荐工具
    local recommended_tool=$(detect_firewall_tool)  # 调用函数获取推荐工具
    # 输出推荐工具不等于none
    if [[ "$recommended_tool" != "none" ]]; then
        echo -e "${BLUE}推荐使用工具: ${GREEN}$recommended_tool${NC}"
    else
        echo -e "${RED}警告: 未检测到可用的防火墙工具${NC}"
    fi
}

# 主函数
main() {
    local action="$DEFAULT_ACTION"  # 默认行为 block 封禁
    local tool="$DEFAULT_TOOL"      # 默认工具 auto 自动识别(firewall|iptables)
    local ip_address=""             # 待处理IP
    local ip_file=""                # 待处理IP文件
    local dry_run="false"           # 默认非预览模式
    local check_ip=""               # 待检查的IP
    local backup_dir="$DEFAULT_BACKUP_DIR"  # 备份目录
    local restore_file=""           # 恢复文件路径
    local do_backup="false"         # 是否执行备份
    local do_restore="false"        # 是否执行恢复
    
    # 参数解析
    while [[ $# -gt 0 ]]; do
        case $1 in      
            -h|--help)
                show_usage
                exit 0
                ;;
            -b|--block)
                action="block"  # 设置操作为 封禁
                shift   # 本意是丢弃第一个参数,后续参数全体左移(丢弃$1,原来的$2变为$1,原来的$3变为$2,以此类推),在这里是丢弃-b参数,避免重复处理-b
                ;;
            -u|--unblock)
                action="unblock"    # 设置操作为 解封
                shift   # 在这里是丢弃已经处理过的-u参数,避免重复处理-u
                ;;
            -t|--tool)
                if [[ -n "${2:-}" ]]; then  # 检测第二个参数是否存在,${2:-} 是一种默认值语法:如果 $2 不存在或为空,返回空字符串
                    tool="$2"               # 设置工具为第二个参数
                    shift 2                 # 丢弃第一个参数和第二个参数,参数整体左移 2 位(-t 和 tool 已经处理完毕)
                else                        # 如果 $2 不存在或为空,说明没有指定工具
                    log_message "ERROR" "-t 选项需要指定工具名称"
                    exit 1                  # 退出脚本
                fi
                ;;
            -f|--file)
                if [[ -n "${2:-}" ]]; then  # 检测第二个参数是否存在
                    ip_file="$2"            # 设置IP文件为第二个参数
                    shift 2                 # 丢弃第一个参数和第二个参数,参数整体左移 2 位(-f 和 ip_file 已经处理完毕)
                else                        # 如果 $2 不存在或为空,说明没有指定IP文件
                    log_message "ERROR" "-f 选项需要指定文件路径"
                    exit 1                  # 退出脚本
                fi
                ;;
            -l|--list)
                list_blocked_ips "auto"     # 调用函数list_blocked_ips(),参数为auto,表示自动检测工具
                exit 0
                ;;
            -c|--check)
                if [[ -n "${2:-}" ]]; then  # 检测第二个参数是否存在
                    check_ip="$2"           # 设置检查IP为第二个参数
                    shift 2                 # 丢弃第一个参数和第二个参数,参数整体左移 2 位(-c 和 check_ip 已经处理完毕)
                else                        # 如果 $2 不存在或为空,说明没有指定检查IP
                    log_message "ERROR" "-c 选项需要指定IP地址"
                    exit 1
                fi
                ;;
            -s|--status)
                show_firewall_status "auto"  # 调用函数 show_firewall_status() 显示防火墙状态,iptable 和 firewall 都展示
                exit 0
                ;;
            --log-file)
                # 检查下一个参数是否存在且不是以 - 开头的选项
                if [[ -n "${2:-}" ]] && [[ "${2}" != -* ]]; then    
                    LOG_FILE="$2"           # 如存在,则说明用户指定了日志文件路径,将使用用户指定的日志文件路径
                    shift 2     # 移除已处理的参数
                else
                    # 如果没有指定路径或下一个参数是选项，则使用默认路径
                    LOG_FILE=${DEFAULT_LOG_FILE}    # 使用默认路径的全局变量
                    shift 1     # 移除已处理的参数
                fi
                ;;
            --backup)
                do_backup="true"  # 启用备份模式
                shift
                ;;
            --restore)
                if [[ -n "${2:-}" ]]; then
                    restore_file="$2"  # 设置恢复文件路径
                    do_restore="true"
                    shift 2
                else
                    log_message "ERROR" "--restore 选项需要指定备份文件路径"
                    exit 1
                fi
                ;;
            --backup-dir)
                if [[ -n "${2:-}" ]]; then
                    backup_dir="$2"  # 设置备份目录
                    shift 2
                else
                    log_message "ERROR" "--backup-dir 选项需要指定备份目录路径"
                    exit 1
                fi
                ;;
            --show-run)
                dry_run="true"  # 启用预览模式运行,实际不执行任何命令
                shift   # 整体左移一位继续处理后续参数
                ;;
            -*)
                log_message "ERROR" "未知选项: $1"
                show_usage
                exit 1
                ;;
            *)
                if [[ -z "$ip_address" ]]; then     # 如果ip_address为空，则将第一个参数作为ip_address
                    ip_address="$1"
                else
                    log_message "ERROR" "只能指定一个IP地址"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # 检查IP状态
    if [[ -n "$check_ip" ]]; then
        check_ip_blocked "$check_ip" "auto"
        exit 0
    fi
    
    # 执行备份操作
    if [[ "$do_backup" == "true" ]]; then
        backup_firewall_rules "$backup_dir" "$dry_run"
        exit $?
    fi
    
    # 执行恢复操作
    if [[ "$do_restore" == "true" ]]; then
        # 恢复操作需要root权限(除非是预览模式)
        if [[ "$dry_run" != "true" ]]; then
            check_root
        fi
        restore_firewall_rules "$restore_file" "$dry_run"
        exit $?
    fi
    
    # 检查必需参数
    if [[ -z "$ip_address" ]] && [[ -z "$ip_file" ]]; then
        log_message "ERROR" "请指定要处理的IP地址或IP文件"
        show_usage
        exit 1
    fi
    
    # 自动检测工具
    if [[ "$tool" == "auto" ]]; then
        tool=$(detect_firewall_tool)
        if [[ "$tool" == "none" ]]; then
            log_message "ERROR" "未检测到可用的防火墙工具(iptables或firewall)"
            exit 1
        fi
        log_message "INFO" "自动检测到防火墙工具: $tool"
    fi
    
    # 验证工具有效性
    if [[ "$tool" != "iptables" ]] && [[ "$tool" != "firewall" ]]; then
        log_message "ERROR" "不支持的工具: $tool (支持: iptables, firewall)"
        exit 1
    fi
    
    # 检查工具可用性
    case "$tool" in
        "iptables")
            if ! command -v iptables >/dev/null 2>&1; then
                log_message "ERROR" "iptables未安装或不可用"
                exit 1
            fi
            ;;
        "firewall")
            if ! command -v firewall-cmd >/dev/null 2>&1; then
                log_message "ERROR" "firewall-cmd未安装或不可用"
                exit 1
            fi
            if ! systemctl is-active --quiet firewalld 2>/dev/null; then
                log_message "ERROR" "firewalld服务未运行"
                exit 1
            fi
            ;;
    esac
    
    # 检查root权限(除非是show-run模式)
    if [[ "$dry_run" != "true" ]]; then
        check_root
    fi
    
    # 执行操作
    if [[ -n "$ip_file" ]]; then
        # 批量处理(支持批量封禁或解封IP)
        process_ip_file "$ip_file" "$action" "$tool" "$dry_run"
    else
        # 单个IP处理
        if [[ "$action" == "block" ]]; then
            block_ip "$ip_address" "$tool" "$dry_run"
        else
            unblock_ip "$ip_address" "$tool" "$dry_run"
        fi
    fi
}

# 执行主函数
main "$@"