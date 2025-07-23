#!/bin/bash

# LinuxGun-dev.sh CentOS 7 环境自动化测试套件
# 作者: AI Assistant
# 版本: 1.0
# 日期: $(date +%Y-%m-%d)
# 描述: 针对 CentOS 7 环境的 LinuxGun-dev.sh 脚本全面测试工具

# 设置脚本执行参数
set -e  # 遇到错误立即退出
set -u  # 使用未定义变量时报错

# 全局变量定义
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_SCRIPT="${SCRIPT_DIR}/linuxGun-dev.sh"
TEST_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
TEST_LOG_DIR="${SCRIPT_DIR}/test_logs_${TEST_TIMESTAMP}"
TEST_REPORT_FILE="${TEST_LOG_DIR}/centos7_test_report_${TEST_TIMESTAMP}.md"
TEST_JSON_FILE="${TEST_LOG_DIR}/test_results_${TEST_TIMESTAMP}.json"
TEST_SUMMARY_FILE="${TEST_LOG_DIR}/test_summary_${TEST_TIMESTAMP}.txt"

# 测试统计变量
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0
ERROR_TESTS=0

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 日志级别定义
LOG_LEVEL_INFO="INFO"
LOG_LEVEL_WARN="WARN"
LOG_LEVEL_ERROR="ERROR"
LOG_LEVEL_DEBUG="DEBUG"

# 初始化测试环境
init_test_environment() {
    echo -e "${BLUE}[INFO]${NC} 初始化测试环境..."
    
    # 创建测试日志目录
    mkdir -p "${TEST_LOG_DIR}"
    
    # 检查是否为 CentOS 7
    if [[ ! -f /etc/redhat-release ]] || ! grep -q "CentOS Linux release 7" /etc/redhat-release; then
        echo -e "${YELLOW}[WARN]${NC} 当前系统不是 CentOS 7，测试结果可能不准确"
    fi
    
    # 检查是否为 root 用户
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[ERROR]${NC} 请使用 root 权限运行此测试脚本"
        exit 1
    fi
    
    # 检查测试脚本是否存在
    if [[ ! -f "${TEST_SCRIPT}" ]]; then
        echo -e "${RED}[ERROR]${NC} 找不到测试脚本: ${TEST_SCRIPT}"
        exit 1
    fi
    
    # 检查脚本语法
    if ! bash -n "${TEST_SCRIPT}"; then
        echo -e "${RED}[ERROR]${NC} 测试脚本语法错误"
        exit 1
    fi
    
    # 记录测试环境信息
    {
        echo "=== CentOS 7 测试环境信息 ==="
        echo "测试时间: $(date)"
        echo "系统信息: $(uname -a)"
        echo "发行版信息: $(cat /etc/redhat-release)"
        echo "内核版本: $(uname -r)"
        echo "内存信息: $(free -h | head -2)"
        echo "磁盘信息: $(df -h / | tail -1)"
        echo "网络接口: $(ip addr show | grep -E '^[0-9]+:' | awk '{print $2}' | tr -d ':')"
        echo "当前用户: $(whoami)"
        echo "测试脚本: ${TEST_SCRIPT}"
        echo "测试日志目录: ${TEST_LOG_DIR}"
        echo "=============================="
    } > "${TEST_LOG_DIR}/test_environment.txt"
    
    echo -e "${GREEN}[INFO]${NC} 测试环境初始化完成"
}

# 日志记录函数
log_message() {
    local level="$1"
    local message="$2"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    
    case "$level" in
        "$LOG_LEVEL_INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "$LOG_LEVEL_WARN")
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        "$LOG_LEVEL_ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        "$LOG_LEVEL_DEBUG")
            echo -e "${PURPLE}[DEBUG]${NC} $message"
            ;;
    esac
    
    # 写入日志文件
    echo "[$timestamp] [$level] $message" >> "${TEST_LOG_DIR}/test_execution.log"
}

# 执行单个测试用例
execute_test_case() {
    local test_id="$1"
    local test_name="$2"
    local test_command="$3"
    local expected_exit_code="${4:-0}"
    local timeout_seconds="${5:-300}"
    
    ((TOTAL_TESTS++))
    
    log_message "$LOG_LEVEL_INFO" "执行测试用例 $test_id: $test_name"
    
    local test_log_file="${TEST_LOG_DIR}/${test_id}_${test_name//[^a-zA-Z0-9]/_}.log"
    local start_time=$(date +%s)
    local exit_code=0
    
    # 执行测试命令
    if timeout "${timeout_seconds}s" bash -c "$test_command" > "$test_log_file" 2>&1; then
        exit_code=$?
    else
        exit_code=$?
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # 判断测试结果
    if [[ $exit_code -eq $expected_exit_code ]]; then
        ((PASSED_TESTS++))
        log_message "$LOG_LEVEL_INFO" "测试用例 $test_id 通过 (耗时: ${duration}s)"
        echo "PASS" > "${test_log_file}.result"
    elif [[ $exit_code -eq 124 ]]; then
        ((ERROR_TESTS++))
        log_message "$LOG_LEVEL_ERROR" "测试用例 $test_id 超时 (${timeout_seconds}s)"
        echo "TIMEOUT" > "${test_log_file}.result"
    else
        ((FAILED_TESTS++))
        log_message "$LOG_LEVEL_ERROR" "测试用例 $test_id 失败 (退出码: $exit_code, 预期: $expected_exit_code)"
        echo "FAIL" > "${test_log_file}.result"
    fi
    
    # 记录测试详情到 JSON
    {
        echo "{"
        echo "  \"test_id\": \"$test_id\","
        echo "  \"test_name\": \"$test_name\","
        echo "  \"command\": \"$test_command\","
        echo "  \"expected_exit_code\": $expected_exit_code,"
        echo "  \"actual_exit_code\": $exit_code,"
        echo "  \"duration_seconds\": $duration,"
        echo "  \"result\": \"$(cat "${test_log_file}.result")\","
        echo "  \"log_file\": \"$test_log_file\","
        echo "  \"timestamp\": \"$(date -Iseconds)\""
        echo "},"
    } >> "${TEST_JSON_FILE}.tmp"
}

# 基础功能测试
run_basic_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行基础功能测试..."
    
    # TC001: 脚本语法检查
    execute_test_case "TC001" "脚本语法检查" "bash -n '${TEST_SCRIPT}'"
    
    # TC002: 帮助信息显示
    execute_test_case "TC002" "帮助信息显示" "bash '${TEST_SCRIPT}' --help"
    
    # TC003: 大纲信息显示
    execute_test_case "TC003" "大纲信息显示" "bash '${TEST_SCRIPT}' --show"
    
    # TC004: 无效参数处理
    execute_test_case "TC004" "无效参数处理" "bash '${TEST_SCRIPT}' --invalid-param" 1
    
    # TC005: 无参数执行
    execute_test_case "TC005" "无参数执行" "bash '${TEST_SCRIPT}'" 1
    
    log_message "$LOG_LEVEL_INFO" "基础功能测试完成"
}

# 系统模块测试
run_system_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行系统模块测试..."
    
    # TC101: 系统基础信息检查
    execute_test_case "TC101" "系统基础信息检查" "bash '${TEST_SCRIPT}' --system" 0 600
    
    # TC102: 系统详细信息检查
    execute_test_case "TC102" "系统详细信息检查" "bash '${TEST_SCRIPT}' --system-baseinfo" 0 300
    
    # TC103: 用户权限检查
    execute_test_case "TC103" "用户权限检查" "bash '${TEST_SCRIPT}' --system-user" 0 300
    
    # TC104: 系统完整性检查并生成报告
    execute_test_case "TC104" "系统完整性检查" "bash '${TEST_SCRIPT}' --system --send '/tmp/system_report_${TEST_TIMESTAMP}.tar.gz'" 0 900
    
    log_message "$LOG_LEVEL_INFO" "系统模块测试完成"
}

# 网络模块测试
run_network_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行网络模块测试..."
    
    # TC201: 网络配置检查
    execute_test_case "TC201" "网络配置检查" "bash '${TEST_SCRIPT}' --network" 0 600
    
    # TC202: SSH 配置检查
    execute_test_case "TC202" "SSH配置检查" "bash '${TEST_SCRIPT}' --tunnel-ssh" 0 300
    
    # TC203: 网络连接分析并生成报告
    execute_test_case "TC203" "网络连接分析" "bash '${TEST_SCRIPT}' --network --send '/tmp/network_report_${TEST_TIMESTAMP}.tar.gz'" 0 900
    
    log_message "$LOG_LEVEL_INFO" "网络模块测试完成"
}

# 进程和服务测试
run_process_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行进程和服务测试..."
    
    # TC301: 进程信息收集
    execute_test_case "TC301" "进程信息收集" "bash '${TEST_SCRIPT}' --psinfo" 0 600
    
    # TC302: 系统服务检查
    execute_test_case "TC302" "系统服务检查" "bash '${TEST_SCRIPT}' --file-systemservice" 0 600
    
    # TC303: 危险进程检测并生成报告
    execute_test_case "TC303" "危险进程检测" "bash '${TEST_SCRIPT}' --psinfo --send '/tmp/process_report_${TEST_TIMESTAMP}.tar.gz'" 0 900
    
    log_message "$LOG_LEVEL_INFO" "进程和服务测试完成"
}

# 安全检查测试
run_security_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行安全检查测试..."
    
    # TC401: Web shell 检测
    execute_test_case "TC401" "Webshell检测" "bash '${TEST_SCRIPT}' --webshell" 0 1200
    
    # TC402: 病毒检测
    execute_test_case "TC402" "病毒检测" "bash '${TEST_SCRIPT}' --virus" 0 1800
    
    # TC403: Rootkit 检测
    execute_test_case "TC403" "Rootkit检测" "bash '${TEST_SCRIPT}' --rootkit" 0 1200
    
    # TC404: 综合安全检查
    execute_test_case "TC404" "综合安全检查" "bash '${TEST_SCRIPT}' --webshell --virus --rootkit --send '/tmp/security_report_${TEST_TIMESTAMP}.tar.gz'" 0 600
    
    log_message "$LOG_LEVEL_INFO" "安全检查测试完成"
}

# 容器和集群测试
run_container_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行容器和集群测试..."
    
    # TC501: Kubernetes 基础检查
    execute_test_case "TC501" "Kubernetes基础检查" "bash '${TEST_SCRIPT}' --k8s" 0 300
    
    # TC502: Kubernetes 集群检查
    execute_test_case "TC502" "Kubernetes集群检查" "bash '${TEST_SCRIPT}' --k8s-cluster" 0 600
    
    # TC503: 容器安全检查并生成报告
    execute_test_case "TC503" "容器安全检查" "bash '${TEST_SCRIPT}' --k8s --k8s-cluster --send '/tmp/k8s_report_${TEST_TIMESTAMP}.tar.gz'" 0 900
    
    log_message "$LOG_LEVEL_INFO" "容器和集群测试完成"
}

# 交互模式测试
run_interactive_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行交互模式测试..."
    
    # TC601: 交互模式基础测试
    execute_test_case "TC601" "交互模式基础测试" "echo -e '1\\ny\\nq' | bash '${TEST_SCRIPT}' --inter" 0 300
    
    # TC602: 交互模式模块选择
    execute_test_case "TC602" "交互模式模块选择" "echo -e '2\\n1\\ny\\nq' | bash '${TEST_SCRIPT}' --inter" 0 600
    
    # TC603: 交互模式退出测试
    execute_test_case "TC603" "交互模式退出测试" "echo 'q' | bash '${TEST_SCRIPT}' --inter" 0 60
    
    log_message "$LOG_LEVEL_INFO" "交互模式测试完成"
}

# 综合测试
run_comprehensive_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行综合测试..."
    
    # TC701: 全模块检查
    execute_test_case "TC701" "全模块检查" "bash '${TEST_SCRIPT}' --all" 0 7200
    
    # TC702: 多模块组合检查
    execute_test_case "TC702" "多模块组合检查" "bash '${TEST_SCRIPT}' --system --network --psinfo" 0 1800
    
    # TC703: 全模块检查并发送报告
    execute_test_case "TC703" "全模块检查并发送报告" "bash '${TEST_SCRIPT}' --all --send '/tmp/full_report_${TEST_TIMESTAMP}.tar.gz'" 0 7200
    
    log_message "$LOG_LEVEL_INFO" "综合测试完成"
}

# 快速响应性能测试
run_performance_tests() {
    log_message "$LOG_LEVEL_INFO" "开始执行快速响应性能测试..."
    
    # TC801: 内存使用测试
    execute_test_case "TC801" "内存使用测试" "(bash '${TEST_SCRIPT}' --system &) && sleep 5 && ps aux | grep linuxGun-dev.sh | grep -v grep" 0 300
    
    # TC802: 并发执行测试
    execute_test_case "TC802" "并发执行测试" "for i in {1..3}; do bash '${TEST_SCRIPT}' --system-baseinfo & done; wait" 0 600
    
    # TC803: 快速响应测试（限制在5分钟内完成）
    execute_test_case "TC803" "快速响应测试" "timeout 300s bash '${TEST_SCRIPT}' --all" 0 300
    
    log_message "$LOG_LEVEL_INFO" "快速响应性能测试完成"
}

# 生成测试报告
generate_test_report() {
    log_message "$LOG_LEVEL_INFO" "生成测试报告..."
    
    # 完成 JSON 文件
    if [[ -f "${TEST_JSON_FILE}.tmp" ]]; then
        # 移除最后一个逗号并添加 JSON 结构
        sed '$ s/,$//' "${TEST_JSON_FILE}.tmp" > "${TEST_JSON_FILE}.clean"
        {
            echo "{"
            echo "  \"test_suite\": \"LinuxGun-dev.sh CentOS 7 Test Suite\","
            echo "  \"timestamp\": \"$(date -Iseconds)\","
            echo "  \"environment\": {"
            echo "    \"os\": \"$(cat /etc/redhat-release)\","
            echo "    \"kernel\": \"$(uname -r)\","
            echo "    \"hostname\": \"$(hostname)\""
            echo "  },"
            echo "  \"summary\": {"
            echo "    \"total_tests\": $TOTAL_TESTS,"
            echo "    \"passed_tests\": $PASSED_TESTS,"
            echo "    \"failed_tests\": $FAILED_TESTS,"
            echo "    \"skipped_tests\": $SKIPPED_TESTS,"
            echo "    \"error_tests\": $ERROR_TESTS,"
            echo "    \"success_rate\": \"$(( PASSED_TESTS * 100 / TOTAL_TESTS ))%\""
            echo "  },"
            echo "  \"test_cases\": ["
            cat "${TEST_JSON_FILE}.clean"
            echo "  ]"
            echo "}"
        } > "${TEST_JSON_FILE}"
        rm -f "${TEST_JSON_FILE}.tmp" "${TEST_JSON_FILE}.clean"
    fi
    
    # 生成 Markdown 报告
    {
        echo "# LinuxGun-dev.sh CentOS 7 测试报告"
        echo ""
        echo "## 测试概述"
        echo ""
        echo "- **测试时间**: $(date)"
        echo "- **测试环境**: $(cat /etc/redhat-release)"
        echo "- **内核版本**: $(uname -r)"
        echo "- **主机名**: $(hostname)"
        echo "- **测试脚本**: ${TEST_SCRIPT}"
        echo ""
        echo "## 测试统计"
        echo ""
        echo "| 项目 | 数量 | 百分比 |"
        echo "|------|------|--------|"
        echo "| 总测试数 | $TOTAL_TESTS | 100% |"
        echo "| 通过测试 | $PASSED_TESTS | $(( PASSED_TESTS * 100 / TOTAL_TESTS ))% |"
        echo "| 失败测试 | $FAILED_TESTS | $(( FAILED_TESTS * 100 / TOTAL_TESTS ))% |"
        echo "| 跳过测试 | $SKIPPED_TESTS | $(( SKIPPED_TESTS * 100 / TOTAL_TESTS ))% |"
        echo "| 错误测试 | $ERROR_TESTS | $(( ERROR_TESTS * 100 / TOTAL_TESTS ))% |"
        echo ""
        echo "## 详细测试结果"
        echo ""
        
        # 遍历所有测试结果文件
        for result_file in "${TEST_LOG_DIR}"/*.result; do
            if [[ -f "$result_file" ]]; then
                local test_name=$(basename "$result_file" .result)
                local result=$(cat "$result_file")
                local log_file="${result_file%.result}.log"
                
                case "$result" in
                    "PASS")
                        echo "- ✅ **$test_name**: 通过"
                        ;;
                    "FAIL")
                        echo "- ❌ **$test_name**: 失败"
                        if [[ -f "$log_file" ]]; then
                            echo "  - 错误信息: $(tail -3 "$log_file" | head -1)"
                        fi
                        ;;
                    "TIMEOUT")
                        echo "- ⏰ **$test_name**: 超时"
                        ;;
                    "SKIP")
                        echo "- ⏭️ **$test_name**: 跳过"
                        ;;
                esac
            fi
        done
        
        echo ""
        echo "## 系统资源使用情况"
        echo ""
        echo "### 内存使用"
        echo "\`\`\`"
        free -h
        echo "\`\`\`"
        echo ""
        echo "### 磁盘使用"
        echo "\`\`\`"
        df -h
        echo "\`\`\`"
        echo ""
        echo "### 网络接口"
        echo "\`\`\`"
        ip addr show | grep -E '^[0-9]+:'
        echo "\`\`\`"
        echo ""
        echo "## 测试文件位置"
        echo ""
        echo "- **测试日志目录**: ${TEST_LOG_DIR}"
        echo "- **JSON 结果文件**: ${TEST_JSON_FILE}"
        echo "- **环境信息文件**: ${TEST_LOG_DIR}/test_environment.txt"
        echo "- **执行日志文件**: ${TEST_LOG_DIR}/test_execution.log"
        echo ""
        echo "## 建议和总结"
        echo ""
        if [[ $PASSED_TESTS -eq $TOTAL_TESTS ]]; then
            echo "🎉 **所有测试通过！** LinuxGun-dev.sh 脚本在 CentOS 7 环境下运行正常。"
        elif [[ $(( PASSED_TESTS * 100 / TOTAL_TESTS )) -ge 80 ]]; then
            echo "✅ **大部分测试通过** ($(( PASSED_TESTS * 100 / TOTAL_TESTS ))%)，脚本基本功能正常，建议修复失败的测试用例。"
        else
            echo "⚠️ **测试通过率较低** ($(( PASSED_TESTS * 100 / TOTAL_TESTS ))%)，建议详细检查失败原因并进行修复。"
        fi
        echo ""
        echo "### 下一步行动"
        echo ""
        echo "1. 查看详细的测试日志文件分析失败原因"
        echo "2. 根据错误信息修复脚本中的问题"
        echo "3. 在修复后重新运行测试验证"
        echo "4. 考虑在不同的 CentOS 7 子版本上进行测试"
        echo ""
        echo "---"
        echo "*报告生成时间: $(date)*"
    } > "${TEST_REPORT_FILE}"
    
    # 生成简要摘要
    {
        echo "=== LinuxGun-dev.sh CentOS 7 测试摘要 ==="
        echo "测试时间: $(date)"
        echo "总测试数: $TOTAL_TESTS"
        echo "通过测试: $PASSED_TESTS"
        echo "失败测试: $FAILED_TESTS"
        echo "跳过测试: $SKIPPED_TESTS"
        echo "错误测试: $ERROR_TESTS"
        echo "成功率: $(( PASSED_TESTS * 100 / TOTAL_TESTS ))%"
        echo "详细报告: ${TEST_REPORT_FILE}"
        echo "JSON 结果: ${TEST_JSON_FILE}"
        echo "========================================"
    } > "${TEST_SUMMARY_FILE}"
    
    log_message "$LOG_LEVEL_INFO" "测试报告生成完成"
}

# 清理测试环境
cleanup_test_environment() {
    log_message "$LOG_LEVEL_INFO" "清理测试环境..."
    
    # 清理临时文件
    rm -f /tmp/*_report_${TEST_TIMESTAMP}.tar.gz 2>/dev/null || true
    
    # 停止可能的后台进程
    pkill -f "linuxGun-dev.sh" 2>/dev/null || true
    
    log_message "$LOG_LEVEL_INFO" "测试环境清理完成"
}

# 显示帮助信息
show_help() {
    cat << EOF
LinuxGun-dev.sh CentOS 7 环境自动化测试套件

用法: $0 [选项]

选项:
  -h, --help              显示此帮助信息
  -a, --all               运行所有测试模块（默认）
  -b, --basic             仅运行基础功能测试
  -s, --system            仅运行系统模块测试
  -n, --network           仅运行网络模块测试
  -p, --process           仅运行进程和服务测试
  -S, --security          仅运行安全检查测试
  -c, --container         仅运行容器和集群测试
  -i, --interactive       仅运行交互模式测试
  -C, --comprehensive     仅运行综合测试
  -P, --performance       仅运行性能测试
  -v, --verbose           详细输出模式
  --no-cleanup            测试完成后不清理环境

示例:
  $0                      # 运行所有测试
  $0 --basic              # 仅运行基础功能测试
  $0 --system --network   # 运行系统和网络模块测试
  $0 --verbose            # 详细输出模式运行所有测试

测试结果将保存在: ${TEST_LOG_DIR}
EOF
}

# 主函数
main() {
    local run_all=true
    local run_basic=false
    local run_system=false
    local run_network=false
    local run_process=false
    local run_security=false
    local run_container=false
    local run_interactive=false
    local run_comprehensive=false
    local run_performance=false
    local verbose=false
    local no_cleanup=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -a|--all)
                run_all=true
                shift
                ;;
            -b|--basic)
                run_all=false
                run_basic=true
                shift
                ;;
            -s|--system)
                run_all=false
                run_system=true
                shift
                ;;
            -n|--network)
                run_all=false
                run_network=true
                shift
                ;;
            -p|--process)
                run_all=false
                run_process=true
                shift
                ;;
            -S|--security)
                run_all=false
                run_security=true
                shift
                ;;
            -c|--container)
                run_all=false
                run_container=true
                shift
                ;;
            -i|--interactive)
                run_all=false
                run_interactive=true
                shift
                ;;
            -C|--comprehensive)
                run_all=false
                run_comprehensive=true
                shift
                ;;
            -P|--performance)
                run_all=false
                run_performance=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            --no-cleanup)
                no_cleanup=true
                shift
                ;;
            *)
                echo "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 设置详细输出
    if [[ "$verbose" == "true" ]]; then
        set -x
    fi
    
    echo -e "${CYAN}======================================${NC}"
    echo -e "${CYAN}  LinuxGun-dev.sh CentOS 7 测试套件  ${NC}"
    echo -e "${CYAN}======================================${NC}"
    echo ""
    
    # 初始化测试环境
    init_test_environment
    
    local start_time=$(date +%s)
    
    # 执行测试模块
    if [[ "$run_all" == "true" ]]; then
        run_basic_tests
        run_system_tests
        run_network_tests
        run_process_tests
        run_security_tests
        run_container_tests
        run_interactive_tests
        run_comprehensive_tests
        run_performance_tests
    else
        [[ "$run_basic" == "true" ]] && run_basic_tests
        [[ "$run_system" == "true" ]] && run_system_tests
        [[ "$run_network" == "true" ]] && run_network_tests
        [[ "$run_process" == "true" ]] && run_process_tests
        [[ "$run_security" == "true" ]] && run_security_tests
        [[ "$run_container" == "true" ]] && run_container_tests
        [[ "$run_interactive" == "true" ]] && run_interactive_tests
        [[ "$run_comprehensive" == "true" ]] && run_comprehensive_tests
        [[ "$run_performance" == "true" ]] && run_performance_tests
    fi
    
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    
    # 生成测试报告
    generate_test_report
    
    # 清理测试环境
    if [[ "$no_cleanup" != "true" ]]; then
        cleanup_test_environment
    fi
    
    # 显示测试摘要
    echo ""
    echo -e "${CYAN}======================================${NC}"
    echo -e "${CYAN}           测试完成摘要              ${NC}"
    echo -e "${CYAN}======================================${NC}"
    cat "${TEST_SUMMARY_FILE}"
    echo -e "${CYAN}总耗时: ${total_duration} 秒${NC}"
    echo -e "${CYAN}======================================${NC}"
    
    # 根据测试结果设置退出码
    if [[ $FAILED_TESTS -eq 0 && $ERROR_TESTS -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# 脚本入口点
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi