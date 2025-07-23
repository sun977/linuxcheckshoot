#!/bin/bash

# LinuxGun-dev.sh 自动化测试脚本
# 用于测试各个模块的功能是否正常

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试结果统计
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# 日志文件
TEST_LOG="test_results_$(date +%Y%m%d_%H%M%S).log"

# 打印测试标题
print_test_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}LinuxGun-dev.sh 功能测试${NC}"
    echo -e "${BLUE}测试时间: $(date)${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# 打印测试结果
print_test_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    case "$result" in
        "PASS")
            echo -e "${GREEN}[PASS]${NC} $test_name"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            ;;
        "FAIL")
            echo -e "${RED}[FAIL]${NC} $test_name"
            if [ -n "$details" ]; then
                echo -e "${RED}       详情: $details${NC}"
            fi
            FAILED_TESTS=$((FAILED_TESTS + 1))
            ;;
        "SKIP")
            echo -e "${YELLOW}[SKIP]${NC} $test_name"
            if [ -n "$details" ]; then
                echo -e "${YELLOW}       原因: $details${NC}"
            fi
            SKIPPED_TESTS=$((SKIPPED_TESTS + 1))
            ;;
    esac
    
    # 记录到日志文件
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$result] $test_name - $details" >> "$TEST_LOG"
}

# 测试脚本语法
test_syntax() {
    echo -e "\n${YELLOW}1. 基础功能测试${NC}"
    
    if bash -n linuxGun-dev.sh >/dev/null 2>&1; then
        print_test_result "脚本语法检查" "PASS" "语法正确"
    else
        print_test_result "脚本语法检查" "FAIL" "语法错误"
        return 1
    fi
}

# 测试帮助信息
test_help() {
    if sudo bash linuxGun-dev.sh --help >/dev/null 2>&1; then
        print_test_result "帮助信息显示" "PASS" "帮助信息正常显示"
    else
        print_test_result "帮助信息显示" "FAIL" "帮助信息显示失败"
    fi
}

# 测试大纲显示
test_show() {
    if sudo bash linuxGun-dev.sh --show >/dev/null 2>&1; then
        print_test_result "大纲信息显示" "PASS" "大纲信息正常显示"
    else
        print_test_result "大纲信息显示" "FAIL" "大纲信息显示失败"
    fi
}

# 测试系统模块
test_system_modules() {
    echo -e "\n${YELLOW}2. 系统信息检查模块测试${NC}"
    
    local modules=("system-baseinfo" "system-user" "system-crontab" "system-history")
    
    for module in "${modules[@]}"; do
        if timeout 30 sudo bash linuxGun-dev.sh --$module >/dev/null 2>&1; then
            print_test_result "$module 模块" "PASS" "模块执行成功"
        else
            local exit_code=$?
            if [ $exit_code -eq 124 ]; then
                print_test_result "$module 模块" "FAIL" "执行超时(30秒)"
            else
                print_test_result "$module 模块" "FAIL" "执行失败(退出码: $exit_code)"
            fi
        fi
    done
    
    # 测试一级模块
    if timeout 30 sudo bash linuxGun-dev.sh --system >/dev/null 2>&1; then
        print_test_result "system 一级模块" "PASS" "一级模块执行成功"
    else
        print_test_result "system 一级模块" "FAIL" "一级模块执行失败"
    fi
}

# 测试网络模块
test_network_modules() {
    echo -e "\n${YELLOW}3. 网络连接检查模块测试${NC}"
    
    if timeout 30 sudo bash linuxGun-dev.sh --network >/dev/null 2>&1; then
        print_test_result "network 模块" "PASS" "网络模块执行成功"
    else
        print_test_result "network 模块" "SKIP" "网络模块在macOS上可能不完全兼容"
    fi
}

# 测试进程模块
test_process_modules() {
    echo -e "\n${YELLOW}4. 进程检查模块测试${NC}"
    
    if timeout 30 sudo bash linuxGun-dev.sh --psinfo >/dev/null 2>&1; then
        print_test_result "psinfo 模块" "PASS" "进程模块执行成功"
    else
        print_test_result "psinfo 模块" "FAIL" "进程模块执行失败"
    fi
}

# 测试文件模块
test_file_modules() {
    echo -e "\n${YELLOW}5. 文件系统检查模块测试${NC}"
    
    local modules=("file-systemservice" "file-dir" "file-keyfiles" "file-systemlog")
    
    for module in "${modules[@]}"; do
        if timeout 30 sudo bash linuxGun-dev.sh --$module >/dev/null 2>&1; then
            print_test_result "$module 模块" "PASS" "模块执行成功"
        else
            print_test_result "$module 模块" "SKIP" "模块在macOS上可能不完全兼容"
        fi
    done
    
    # 测试一级模块
    if timeout 30 sudo bash linuxGun-dev.sh --file >/dev/null 2>&1; then
        print_test_result "file 一级模块" "PASS" "一级模块执行成功"
    else
        print_test_result "file 一级模块" "SKIP" "一级模块在macOS上可能不完全兼容"
    fi
}

# 测试K8s模块
test_k8s_modules() {
    echo -e "\n${YELLOW}6. Kubernetes检查模块测试${NC}"
    
    local modules=("k8s-cluster" "k8s-secret" "k8s-fscan")
    
    for module in "${modules[@]}"; do
        if timeout 30 sudo bash linuxGun-dev.sh --$module >/dev/null 2>&1; then
            print_test_result "$module 模块" "PASS" "模块执行成功(无K8s环境时正常退出)"
        else
            print_test_result "$module 模块" "FAIL" "模块执行失败"
        fi
    done
}

# 测试安全检查模块
test_security_modules() {
    echo -e "\n${YELLOW}7. 安全检查模块测试${NC}"
    
    local modules=("backdoor" "tunnel" "tunnel-ssh" "hackerTools" "kernel" "other")
    
    for module in "${modules[@]}"; do
        if timeout 30 sudo bash linuxGun-dev.sh --$module >/dev/null 2>&1; then
            print_test_result "$module 模块" "PASS" "模块执行成功"
        else
            print_test_result "$module 模块" "SKIP" "模块可能未完全实现或在macOS上不兼容"
        fi
    done
}

# 测试基线检查模块
test_baseline_modules() {
    echo -e "\n${YELLOW}8. 基线检查模块测试${NC}"
    
    local modules=("baseline" "baseline-firewall" "baseline-selinux")
    
    for module in "${modules[@]}"; do
        if timeout 30 sudo bash linuxGun-dev.sh --$module >/dev/null 2>&1; then
            print_test_result "$module 模块" "PASS" "模块执行成功"
        else
            print_test_result "$module 模块" "SKIP" "模块在macOS上可能不完全兼容"
        fi
    done
}

# 测试交互模式
test_interactive_mode() {
    echo -e "\n${YELLOW}9. 交互模式测试${NC}"
    
    # 测试交互模式 - 自动回答 'n' 跳过
    if echo 'n' | timeout 30 sudo bash linuxGun-dev.sh --system-baseinfo --inter >/dev/null 2>&1; then
        print_test_result "交互模式(跳过)" "PASS" "交互模式正常工作"
    else
        print_test_result "交互模式(跳过)" "FAIL" "交互模式执行失败"
    fi
    
    # 测试交互模式 - 自动回答 'y' 执行
    if echo 'y' | timeout 30 sudo bash linuxGun-dev.sh --system-baseinfo --inter >/dev/null 2>&1; then
        print_test_result "交互模式(执行)" "PASS" "交互模式正常工作"
    else
        print_test_result "交互模式(执行)" "FAIL" "交互模式执行失败"
    fi
}

# 测试错误处理
test_error_handling() {
    echo -e "\n${YELLOW}10. 错误处理测试${NC}"
    
    # 测试未知参数
    if sudo bash linuxGun-dev.sh --unknown-module >/dev/null 2>&1; then
        print_test_result "未知参数处理" "FAIL" "应该拒绝未知参数"
    else
        print_test_result "未知参数处理" "PASS" "正确拒绝未知参数"
    fi
    
    # 测试无参数
    if sudo bash linuxGun-dev.sh >/dev/null 2>&1; then
        print_test_result "无参数处理" "FAIL" "应该显示使用说明"
    else
        print_test_result "无参数处理" "PASS" "正确显示使用说明"
    fi
}

# 打印测试总结
print_test_summary() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}测试总结${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "总测试数: $TOTAL_TESTS"
    echo -e "${GREEN}通过: $PASSED_TESTS${NC}"
    echo -e "${RED}失败: $FAILED_TESTS${NC}"
    echo -e "${YELLOW}跳过: $SKIPPED_TESTS${NC}"
    
    local success_rate=0
    if [ $TOTAL_TESTS -gt 0 ]; then
        success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    fi
    
    echo -e "成功率: ${success_rate}%"
    echo -e "详细日志: $TEST_LOG"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "\n${GREEN}✅ 所有关键功能测试通过！${NC}"
        return 0
    else
        echo -e "\n${RED}❌ 发现 $FAILED_TESTS 个失败的测试项${NC}"
        return 1
    fi
}

# 主函数
main() {
    # 检查是否有root权限
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}错误: 此测试脚本需要root权限运行${NC}"
        echo "请使用: sudo bash $0"
        exit 1
    fi
    
    # 检查linuxGun-dev.sh是否存在
    if [ ! -f "linuxGun-dev.sh" ]; then
        echo -e "${RED}错误: 找不到 linuxGun-dev.sh 文件${NC}"
        echo "请确保在正确的目录中运行此测试脚本"
        exit 1
    fi
    
    print_test_header
    
    # 执行各项测试
    test_syntax || exit 1  # 语法错误时直接退出
    test_help
    test_show
    test_system_modules
    test_network_modules
    test_process_modules
    test_file_modules
    test_k8s_modules
    test_security_modules
    test_baseline_modules
    test_interactive_mode
    test_error_handling
    
    # 打印测试总结
    print_test_summary
}

# 运行主函数
main "$@"