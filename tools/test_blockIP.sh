#!/bin/bash

# blockIP.sh 脚本测试用例
# 作者: Sun977
# 版本: 1.0.0
# 说明: 全面测试blockIP.sh脚本的所有功能
# 使用方法: chmod +x test_blockIP.sh && sudo ./test_blockIP.sh

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试配置
SCRIPT_PATH="./blockIP.sh"
TEST_IP="192.168.100.200"  # 测试用IP地址
TEST_IP2="10.0.0.100"      # 第二个测试IP
TEST_IPV6="2001:db8::1"    # IPv6测试地址
TEST_IP_FILE="test_ip_list.txt"
BACKUP_DIR="./test_backup"
LOG_FILE="./test_blockip.log"

# 测试计数器
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 测试结果记录
test_log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "test_results.log"
}

# 执行测试并检查结果
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit_code="${3:-0}"
    
    echo -e "${BLUE}[测试] $test_name${NC}"
    echo "命令: $command"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # 执行命令
    eval "$command"
    local actual_exit_code=$?
    
    # 检查退出码
    if [[ $actual_exit_code -eq $expected_exit_code ]]; then
        echo -e "${GREEN}✓ 通过${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        test_log "PASS" "$test_name"
    else
        echo -e "${RED}✗ 失败 (期望退出码: $expected_exit_code, 实际: $actual_exit_code)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        test_log "FAIL" "$test_name - Expected: $expected_exit_code, Got: $actual_exit_code"
    fi
    echo "--------------------------------------------------------------------"
}

# 检查脚本是否存在
check_script_exists() {
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        echo -e "${RED}错误: 脚本文件 $SCRIPT_PATH 不存在${NC}"
        exit 1
    fi
    
    if [[ ! -x "$SCRIPT_PATH" ]]; then
        echo -e "${YELLOW}警告: 脚本文件没有执行权限，正在添加...${NC}"
        chmod +x "$SCRIPT_PATH"
    fi
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}错误: 此测试脚本需要root权限运行${NC}"
        echo "请使用: sudo $0"
        exit 1
    fi
}

# 创建测试IP文件
create_test_ip_file() {
    cat > "$TEST_IP_FILE" << EOF
# 测试IP列表文件
# 这是注释行，应该被忽略

$TEST_IP
$TEST_IP2
$TEST_IPV6
# 另一个注释
172.16.0.100

# 无效IP测试
999.999.999.999
EOF
    echo -e "${GREEN}创建测试IP文件: $TEST_IP_FILE${NC}"
}

# 清理测试环境
cleanup() {
    echo -e "${YELLOW}清理测试环境...${NC}"
    
    # 清理可能残留的IP封禁规则
    iptables -D INPUT -s "$TEST_IP" -j DROP 2>/dev/null || true
    iptables -D INPUT -s "$TEST_IP2" -j DROP 2>/dev/null || true
    iptables -D INPUT -s "172.16.0.100" -j DROP 2>/dev/null || true
    
    # 清理firewall规则
    if command -v firewall-cmd >/dev/null 2>&1; then
        firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="$TEST_IP" drop' 2>/dev/null || true
        firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="$TEST_IP2" drop' 2>/dev/null || true
        firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="172.16.0.100" drop' 2>/dev/null || true
        firewall-cmd --reload 2>/dev/null || true
    fi
    
    # 清理测试文件
    rm -f "$TEST_IP_FILE" 2>/dev/null || true
    rm -rf "$BACKUP_DIR" 2>/dev/null || true
    rm -f "$LOG_FILE" 2>/dev/null || true
}

# 显示测试结果统计
show_test_summary() {
    echo -e "\n${BLUE}==================== 测试结果统计 ====================${NC}"
    echo -e "总测试数: $TOTAL_TESTS"
    echo -e "${GREEN}通过: $PASSED_TESTS${NC}"
    echo -e "${RED}失败: $FAILED_TESTS${NC}"
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "${GREEN}🎉 所有测试通过！${NC}"
    else
        echo -e "${RED}❌ 有 $FAILED_TESTS 个测试失败${NC}"
        echo "详细信息请查看 test_results.log"
    fi
    echo -e "${BLUE}====================================================${NC}"
}

# 主测试函数
main() {
    echo -e "${BLUE}开始 blockIP.sh 脚本功能测试${NC}"
    echo -e "${BLUE}====================================================${NC}"
    
    # 初始化
    check_script_exists
    check_root
    cleanup
    create_test_ip_file
    
    # 清空测试日志
    > test_results.log
    
    echo -e "\n${YELLOW}=== 1. 基础功能测试 ===${NC}"
    
    # 测试帮助信息
    run_test "显示帮助信息" "$SCRIPT_PATH --help"
    run_test "显示帮助信息(短选项)" "$SCRIPT_PATH -h"
    
    # 测试防火墙状态
    run_test "显示防火墙状态" "$SCRIPT_PATH --status"
    run_test "显示防火墙状态(短选项)" "$SCRIPT_PATH -s"
    
    echo -e "\n${YELLOW}=== 2. 预览模式测试 ===${NC}"
    
    # 测试预览模式
    run_test "预览模式封禁IP" "$SCRIPT_PATH --show-run $TEST_IP"
    run_test "预览模式解封IP" "$SCRIPT_PATH --show-run -u $TEST_IP"
    run_test "预览模式备份" "$SCRIPT_PATH --show-run --backup"
    
    echo -e "\n${YELLOW}=== 3. IP地址验证测试 ===${NC}"
    
    # 测试无效IP地址
    run_test "无效IP地址测试" "$SCRIPT_PATH --show-run 999.999.999.999" 1
    run_test "空IP地址测试" "$SCRIPT_PATH --show-run ''" 1
    run_test "无效格式IP测试" "$SCRIPT_PATH --show-run 'not.an.ip'" 1
    
    echo -e "\n${YELLOW}=== 4. 单个IP封禁/解封测试 ===${NC}"
    
    # 测试iptables工具
    if command -v iptables >/dev/null 2>&1; then
        run_test "iptables封禁IP" "$SCRIPT_PATH -t iptables $TEST_IP"
        run_test "检查IP封禁状态" "$SCRIPT_PATH -c $TEST_IP"
        run_test "列出封禁IP" "$SCRIPT_PATH -l"
        run_test "iptables解封IP" "$SCRIPT_PATH -t iptables -u $TEST_IP"
        run_test "重复解封IP(应该警告)" "$SCRIPT_PATH -t iptables -u $TEST_IP"
    fi
    
    # 测试firewall工具
    if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
        run_test "firewall封禁IP" "$SCRIPT_PATH -t firewall $TEST_IP2"
        run_test "检查firewall封禁状态" "$SCRIPT_PATH -c $TEST_IP2"
        run_test "firewall解封IP" "$SCRIPT_PATH -t firewall -u $TEST_IP2"
    fi
    
    # 测试自动检测工具
    run_test "自动检测工具封禁IP" "$SCRIPT_PATH $TEST_IP"
    run_test "自动检测工具解封IP" "$SCRIPT_PATH -u $TEST_IP"
    
    echo -e "\n${YELLOW}=== 5. 批量处理测试 ===${NC}"
    
    # 测试批量封禁
    run_test "批量封禁IP" "$SCRIPT_PATH -f $TEST_IP_FILE"
    run_test "列出所有封禁IP" "$SCRIPT_PATH -l"
    run_test "批量解封IP" "$SCRIPT_PATH -f $TEST_IP_FILE -u"
    
    # 测试不存在的文件
    run_test "处理不存在的文件" "$SCRIPT_PATH -f nonexistent.txt" 1
    
    echo -e "\n${YELLOW}=== 6. 备份和恢复功能测试 ===${NC}"
    
    # 创建一些规则用于备份测试
    $SCRIPT_PATH $TEST_IP >/dev/null 2>&1 || true
    
    # 测试备份功能
    run_test "备份防火墙规则" "$SCRIPT_PATH --backup --backup-dir $BACKUP_DIR"
    
    # 检查备份文件是否创建
    if [[ -d "$BACKUP_DIR" ]]; then
        backup_file=$(find "$BACKUP_DIR" -name "firewall_backup_*.tar.gz" | head -1)
        if [[ -n "$backup_file" ]]; then
            run_test "恢复防火墙规则" "$SCRIPT_PATH --restore '$backup_file'"
        else
            echo -e "${RED}警告: 未找到备份文件${NC}"
        fi
    fi
    
    # 测试恢复不存在的文件
    run_test "恢复不存在的备份文件" "$SCRIPT_PATH --restore nonexistent.tar.gz" 1
    
    echo -e "\n${YELLOW}=== 7. 日志功能测试 ===${NC}"
    
    # 测试自定义日志文件
    run_test "使用自定义日志文件" "$SCRIPT_PATH --log-file $LOG_FILE --show-run $TEST_IP"
    
    # 检查日志文件是否创建
    if [[ -f "$LOG_FILE" ]]; then
        echo -e "${GREEN}✓ 日志文件创建成功${NC}"
    else
        echo -e "${RED}✗ 日志文件创建失败${NC}"
    fi
    
    echo -e "\n${YELLOW}=== 8. 错误处理测试 ===${NC}"
    
    # 测试无效选项
    run_test "无效选项测试" "$SCRIPT_PATH --invalid-option" 1
    run_test "缺少参数测试" "$SCRIPT_PATH -t" 1
    run_test "缺少文件参数测试" "$SCRIPT_PATH -f" 1
    run_test "缺少检查IP参数测试" "$SCRIPT_PATH -c" 1
    run_test "缺少恢复文件参数测试" "$SCRIPT_PATH --restore" 1
    
    # 测试不支持的工具
    run_test "不支持的工具测试" "$SCRIPT_PATH -t unsupported $TEST_IP" 1
    
    echo -e "\n${YELLOW}=== 9. IPv6支持测试 ===${NC}"
    
    # 测试IPv6地址
    run_test "IPv6地址预览模式" "$SCRIPT_PATH --show-run $TEST_IPV6"
    
    echo -e "\n${YELLOW}=== 10. 权限测试 ===${NC}"
    
    # 这些测试需要在非root用户下运行，这里只做预览
    echo -e "${BLUE}注意: 权限测试需要在非root用户下手动执行以下命令:${NC}"
    echo "su - normaluser -c '$SCRIPT_PATH $TEST_IP'  # 应该失败并提示需要root权限"
    
    echo -e "\n${YELLOW}=== 11. 性能和稳定性测试 ===${NC}"
    
    # 创建大量IP的测试文件
    large_ip_file="large_ip_test.txt"
    echo "# 大量IP测试文件" > "$large_ip_file"
    for i in {1..50}; do
        echo "192.168.200.$i" >> "$large_ip_file"
    done
    
    run_test "大量IP预览模式测试" "$SCRIPT_PATH --show-run -f $large_ip_file"
    
    # 清理大文件
    rm -f "$large_ip_file"
    
    echo -e "\n${YELLOW}=== 12. 集成测试 ===${NC}"
    
    # 综合测试：封禁、检查、备份、恢复、解封
    run_test "集成测试-封禁" "$SCRIPT_PATH $TEST_IP"
    run_test "集成测试-检查" "$SCRIPT_PATH -c $TEST_IP"
    run_test "集成测试-备份" "$SCRIPT_PATH --backup --backup-dir $BACKUP_DIR"
    run_test "集成测试-解封" "$SCRIPT_PATH -u $TEST_IP"
    
    # 最终清理
    cleanup
    
    # 显示测试结果
    show_test_summary
    
    echo -e "\n${BLUE}测试完成！${NC}"
    echo "详细日志保存在: test_results.log"
}

# 信号处理
trap cleanup EXIT

# 执行主函数
main "$@"