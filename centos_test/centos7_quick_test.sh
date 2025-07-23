#!/bin/bash

# LinuxGun-dev.sh CentOS 7 快速验证脚本
# 作者: AI Assistant
# 版本: 1.0
# 日期: $(date +%Y-%m-%d)
# 描述: 针对 CentOS 7 环境的 LinuxGun-dev.sh 脚本快速功能验证工具

# 设置脚本执行参数
set -e  # 遇到错误立即退出

# 全局变量定义
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_SCRIPT="${SCRIPT_DIR}/linuxGun-dev.sh"
TEST_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
QUICK_TEST_LOG="${SCRIPT_DIR}/quick_test_${TEST_TIMESTAMP}.log"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 测试统计
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 日志记录函数
log_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit_code="${3:-0}"
    local timeout_seconds="${4:-60}"
    
    ((TOTAL_TESTS++))
    
    echo -e "${BLUE}[测试]${NC} $test_name"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 测试: $test_name" >> "$QUICK_TEST_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 命令: $command" >> "$QUICK_TEST_LOG"
    
    local start_time=$(date +%s)
    local exit_code=0
    
    # 执行测试命令
    if timeout "${timeout_seconds}s" bash -c "$command" >> "$QUICK_TEST_LOG" 2>&1; then
        exit_code=$?
    else
        exit_code=$?
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # 判断测试结果
    if [[ $exit_code -eq $expected_exit_code ]]; then
        ((PASSED_TESTS++))
        echo -e "${GREEN}  ✓ 通过${NC} (耗时: ${duration}s)"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 结果: 通过 (耗时: ${duration}s)" >> "$QUICK_TEST_LOG"
    elif [[ $exit_code -eq 124 ]]; then
        ((FAILED_TESTS++))
        echo -e "${RED}  ✗ 超时${NC} (${timeout_seconds}s)"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 结果: 超时 (${timeout_seconds}s)" >> "$QUICK_TEST_LOG"
    else
        ((FAILED_TESTS++))
        echo -e "${RED}  ✗ 失败${NC} (退出码: $exit_code, 预期: $expected_exit_code, 耗时: ${duration}s)"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 结果: 失败 (退出码: $exit_code, 预期: $expected_exit_code, 耗时: ${duration}s)" >> "$QUICK_TEST_LOG"
    fi
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ----------------------------------------" >> "$QUICK_TEST_LOG"
}

# 环境检查
check_environment() {
    echo -e "${CYAN}=== 环境检查 ===${NC}"
    
    # 检查是否为 CentOS 7
    if [[ -f /etc/redhat-release ]] && grep -q "CentOS Linux release 7" /etc/redhat-release; then
        echo -e "${GREEN}✓ CentOS 7 环境确认${NC}"
    else
        echo -e "${YELLOW}⚠ 非 CentOS 7 环境，测试结果可能不准确${NC}"
    fi
    
    # 检查是否为 root 用户
    if [[ $EUID -eq 0 ]]; then
        echo -e "${GREEN}✓ Root 权限确认${NC}"
    else
        echo -e "${RED}✗ 需要 root 权限运行${NC}"
        exit 1
    fi
    
    # 检查测试脚本是否存在
    if [[ -f "$TEST_SCRIPT" ]]; then
        echo -e "${GREEN}✓ 测试脚本存在: $TEST_SCRIPT${NC}"
    else
        echo -e "${RED}✗ 找不到测试脚本: $TEST_SCRIPT${NC}"
        exit 1
    fi
    
    # 检查脚本语法
    if bash -n "$TEST_SCRIPT"; then
        echo -e "${GREEN}✓ 脚本语法正确${NC}"
    else
        echo -e "${RED}✗ 脚本语法错误${NC}"
        exit 1
    fi
    
    echo ""
}

# 记录环境信息
record_environment() {
    {
        echo "=== CentOS 7 快速测试环境信息 ==="
        echo "测试时间: $(date)"
        echo "系统信息: $(uname -a)"
        echo "发行版信息: $(cat /etc/redhat-release 2>/dev/null || echo '未知')"
        echo "内核版本: $(uname -r)"
        echo "内存信息: $(free -h | head -2)"
        echo "磁盘信息: $(df -h / | tail -1)"
        echo "当前用户: $(whoami)"
        echo "测试脚本: $TEST_SCRIPT"
        echo "=============================="
    } >> "$QUICK_TEST_LOG"
}

# 快速功能测试
run_quick_tests() {
    echo -e "${CYAN}=== 快速功能测试 ===${NC}"
    
    # 基础功能测试
    log_test "脚本语法检查" "bash -n '$TEST_SCRIPT'"
    log_test "帮助信息显示" "bash '$TEST_SCRIPT' --help"
    log_test "大纲信息显示" "bash '$TEST_SCRIPT' --show"
    log_test "无效参数处理" "bash '$TEST_SCRIPT' --invalid-param" 1
    
    # 核心模块测试
    log_test "系统基础信息检查" "bash '$TEST_SCRIPT' --system-baseinfo" 0 120
    log_test "用户权限检查" "bash '$TEST_SCRIPT' --system-user" 0 120
    log_test "网络配置检查" "bash '$TEST_SCRIPT' --network" 0 180
    log_test "进程信息收集" "bash '$TEST_SCRIPT' --psinfo" 0 180
    
    # 安全检查测试（快速版本）
    log_test "K8s环境检查" "bash '$TEST_SCRIPT' --k8s" 0 60
    log_test "SSH配置检查" "bash '$TEST_SCRIPT' --tunnel-ssh" 0 120
    
    # 交互模式测试
    log_test "交互模式退出测试" "echo 'q' | bash '$TEST_SCRIPT' --inter" 0 30
    
    # 文件生成测试
    local test_report="/tmp/quick_test_report_${TEST_TIMESTAMP}.tar.gz"
    log_test "报告生成测试" "bash '$TEST_SCRIPT' --system-baseinfo --send '$test_report'" 0 300
    
    # 检查生成的报告文件
    if [[ -f "$test_report" ]]; then
        echo -e "${GREEN}✓ 报告文件生成成功: $test_report${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 报告文件生成成功: $test_report" >> "$QUICK_TEST_LOG"
        
        # 检查报告文件内容
        if tar -tzf "$test_report" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ 报告文件格式正确${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 报告文件格式正确" >> "$QUICK_TEST_LOG"
        else
            echo -e "${RED}✗ 报告文件格式错误${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 报告文件格式错误" >> "$QUICK_TEST_LOG"
        fi
        
        # 清理测试文件
        rm -f "$test_report"
    else
        echo -e "${RED}✗ 报告文件未生成${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 报告文件未生成" >> "$QUICK_TEST_LOG"
    fi
    
    echo ""
}

# 系统兼容性检查
check_system_compatibility() {
    echo -e "${CYAN}=== 系统兼容性检查 ===${NC}"
    
    # 检查必要的命令是否存在
    local required_commands=("netstat" "ps" "lsof" "find" "grep" "awk" "sed" "tar" "gzip")
    local missing_commands=()
    
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ $cmd 命令可用${NC}"
        else
            echo -e "${RED}✗ $cmd 命令缺失${NC}"
            missing_commands+=("$cmd")
        fi
    done
    
    if [[ ${#missing_commands[@]} -eq 0 ]]; then
        echo -e "${GREEN}✓ 所有必要命令都可用${NC}"
    else
        echo -e "${YELLOW}⚠ 缺失命令: ${missing_commands[*]}${NC}"
        echo -e "${YELLOW}  建议安装: yum install -y ${missing_commands[*]}${NC}"
    fi
    
    # 检查系统服务
    local services=("sshd" "crond" "rsyslog")
    for service in "${services[@]}"; do
        if systemctl is-active "$service" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ $service 服务运行中${NC}"
        else
            echo -e "${YELLOW}⚠ $service 服务未运行${NC}"
        fi
    done
    
    # 检查网络连接
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        echo -e "${GREEN}✓ 网络连接正常${NC}"
    else
        echo -e "${YELLOW}⚠ 网络连接异常${NC}"
    fi
    
    echo ""
}

# 性能基准测试
run_performance_benchmark() {
    echo -e "${CYAN}=== 性能基准测试 ===${NC}"
    
    # 测试脚本启动时间
    local start_time=$(date +%s%N)
    bash "$TEST_SCRIPT" --help >/dev/null 2>&1
    local end_time=$(date +%s%N)
    local startup_time=$(( (end_time - start_time) / 1000000 ))
    
    echo -e "${BLUE}脚本启动时间: ${startup_time}ms${NC}"
    
    # 测试系统信息收集时间
    start_time=$(date +%s)
    bash "$TEST_SCRIPT" --system-baseinfo >/dev/null 2>&1
    end_time=$(date +%s)
    local collection_time=$((end_time - start_time))
    
    echo -e "${BLUE}系统信息收集时间: ${collection_time}s${NC}"
    
    # 内存使用情况
    local memory_before=$(free | grep '^Mem:' | awk '{print $3}')
    bash "$TEST_SCRIPT" --system >/dev/null 2>&1 &
    local pid=$!
    sleep 2
    local memory_during=$(free | grep '^Mem:' | awk '{print $3}')
    kill $pid 2>/dev/null || true
    wait $pid 2>/dev/null || true
    local memory_usage=$((memory_during - memory_before))
    
    echo -e "${BLUE}内存使用增量: ${memory_usage}KB${NC}"
    
    # 性能评估
    if [[ $startup_time -lt 1000 && $collection_time -lt 60 ]]; then
        echo -e "${GREEN}✓ 性能表现良好${NC}"
    elif [[ $startup_time -lt 3000 && $collection_time -lt 120 ]]; then
        echo -e "${YELLOW}⚠ 性能表现一般${NC}"
    else
        echo -e "${RED}✗ 性能表现较差${NC}"
    fi
    
    echo ""
}

# 生成快速测试报告
generate_quick_report() {
    local success_rate=$(( PASSED_TESTS * 100 / TOTAL_TESTS ))
    
    echo -e "${CYAN}=== 快速测试报告 ===${NC}"
    echo -e "${BLUE}测试时间:${NC} $(date)"
    echo -e "${BLUE}测试环境:${NC} $(cat /etc/redhat-release 2>/dev/null || echo '未知系统')"
    echo -e "${BLUE}总测试数:${NC} $TOTAL_TESTS"
    echo -e "${BLUE}通过测试:${NC} $PASSED_TESTS"
    echo -e "${BLUE}失败测试:${NC} $FAILED_TESTS"
    echo -e "${BLUE}成功率:${NC} ${success_rate}%"
    
    if [[ $success_rate -ge 90 ]]; then
        echo -e "${GREEN}✓ 测试结果: 优秀${NC}"
        echo -e "${GREEN}  LinuxGun-dev.sh 在 CentOS 7 环境下运行良好${NC}"
    elif [[ $success_rate -ge 70 ]]; then
        echo -e "${YELLOW}⚠ 测试结果: 良好${NC}"
        echo -e "${YELLOW}  LinuxGun-dev.sh 基本功能正常，建议检查失败项${NC}"
    else
        echo -e "${RED}✗ 测试结果: 需要改进${NC}"
        echo -e "${RED}  LinuxGun-dev.sh 存在较多问题，需要详细检查${NC}"
    fi
    
    echo -e "${BLUE}详细日志:${NC} $QUICK_TEST_LOG"
    echo ""
}

# 显示使用建议
show_recommendations() {
    echo -e "${CYAN}=== 使用建议 ===${NC}"
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "${GREEN}🎉 所有快速测试通过！${NC}"
        echo "建议进行完整测试以验证所有功能:"
        echo "  sudo ./centos7_test_suite.sh"
    else
        echo -e "${YELLOW}⚠ 发现 $FAILED_TESTS 个问题${NC}"
        echo "建议操作:"
        echo "1. 查看详细日志: cat $QUICK_TEST_LOG"
        echo "2. 检查系统环境和依赖"
        echo "3. 运行完整测试套件: sudo ./centos7_test_suite.sh"
        echo "4. 根据错误信息修复问题"
    fi
    
    echo ""
    echo "完整测试方案文档: centos7_test_plan.md"
    echo "完整测试套件: centos7_test_suite.sh"
    echo ""
}

# 主函数
main() {
    # 解析命令行参数
    case "${1:-}" in
        -h|--help)
            cat << EOF
LinuxGun-dev.sh CentOS 7 快速验证脚本

用法: $0 [选项]

选项:
  -h, --help    显示此帮助信息
  -v, --verbose 详细输出模式

描述:
  此脚本用于快速验证 LinuxGun-dev.sh 在 CentOS 7 环境下的基本功能。
  执行时间约 5-10 分钟，适合快速检查脚本是否能正常运行。

示例:
  sudo $0           # 运行快速测试
  sudo $0 --verbose # 详细输出模式

注意:
  - 需要 root 权限运行
  - 建议在 CentOS 7 环境下执行
  - 完整测试请使用 centos7_test_suite.sh
EOF
            exit 0
            ;;
        -v|--verbose)
            set -x
            ;;
        "")
            # 默认行为，继续执行
            ;;
        *)
            echo "未知参数: $1"
            echo "使用 $0 --help 查看帮助信息"
            exit 1
            ;;
    esac
    
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  LinuxGun-dev.sh CentOS 7 快速验证   ${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    
    local start_time=$(date +%s)
    
    # 记录环境信息
    record_environment
    
    # 执行测试步骤
    check_environment
    check_system_compatibility
    run_quick_tests
    run_performance_benchmark
    
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    
    # 生成报告
    generate_quick_report
    show_recommendations
    
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}总耗时: ${total_duration} 秒${NC}"
    echo -e "${CYAN}========================================${NC}"
    
    # 根据测试结果设置退出码
    if [[ $FAILED_TESTS -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# 脚本入口点
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi