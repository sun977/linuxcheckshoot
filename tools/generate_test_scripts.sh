#!/bin/bash

# 测试脚本生成器 - 自动生成所有测试用例脚本
# Version: 1.0.0
# Author: Sun977
# Description: 自动生成文件上传功能的完整测试脚本
# Usage: ./generate_test_scripts.sh [output_dir]

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认输出目录
OUTPUT_DIR="${1:-./upload_test_suite}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    文件上传测试脚本生成器${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}输出目录: $OUTPUT_DIR${NC}"
echo ""

# 创建输出目录
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

echo -e "${YELLOW}正在生成测试脚本...${NC}"

# 1. 生成测试配置文件
echo -e "${BLUE}[1/7]${NC} 生成测试配置文件..."
cat > test_config.sh << 'EOF'
#!/bin/bash

# 测试配置文件
# 请根据实际环境修改以下配置

# 服务器配置
TEST_IP="127.0.0.1"          # 测试IP地址
TEST_PORT="8080"             # 测试端口
VALID_TOKEN="test123456"     # 有效token
INVALID_TOKEN="wrongtoken"   # 无效token
SHORT_TOKEN="short"          # 过短token
LONG_TOKEN="verylongtokenthatexceedsmaximumlengthof64charactersandshouldfail"

# 文件路径配置
TEST_DIR="$(pwd)"
SMALL_FILE="$TEST_DIR/small_file.txt"
MEDIUM_FILE="$TEST_DIR/medium_file.dat"
LARGE_FILE="$TEST_DIR/large_file.dat"
OVERSIZED_FILE="$TEST_DIR/oversized_file.dat"
ARCHIVE_FILE="$TEST_DIR/test_archive.tar.gz"
EMPTY_FILE="$TEST_DIR/empty_file.txt"
SPACE_FILE="$TEST_DIR/test file with spaces.txt"
SPECIAL_FILE="$TEST_DIR/test-file_with.special@chars.txt"
CHINESE_FILE="$TEST_DIR/中文文件名.txt"
NONEXISTENT_FILE="$TEST_DIR/nonexistent.txt"

# 程序路径配置(请根据实际情况调整)
LINUXGUN_PATH="../linuxgun.sh"
UPLOAD_SERVER_PATH="../uploadServer.py"

# 测试超时设置
SERVER_START_TIMEOUT=5       # 服务器启动超时(秒)
UPLOAD_TIMEOUT=30           # 文件上传超时(秒)
CONCURRENT_COUNT=5          # 并发测试数量

# 日志配置
LOG_LEVEL="INFO"            # 日志级别: DEBUG, INFO, WARN, ERROR
KEEP_LOGS=true              # 是否保留测试日志

EOF
chmod +x test_config.sh
echo -e "${GREEN}✓${NC} test_config.sh"

# 2. 生成测试文件创建脚本
echo -e "${BLUE}[2/7]${NC} 生成测试文件创建脚本..."
cat > create_test_files.sh << 'EOF'
#!/bin/bash

# 创建测试文件脚本
source ./test_config.sh

echo "创建测试文件..."

# 创建不同大小的测试文件
echo "Small test file content" > "$SMALL_FILE"
echo "✓ 创建小文件: $(basename "$SMALL_FILE")"

dd if=/dev/zero of="$MEDIUM_FILE" bs=1M count=10 2>/dev/null
echo "✓ 创建中等文件: $(basename "$MEDIUM_FILE") (10MB)"

dd if=/dev/zero of="$LARGE_FILE" bs=1M count=50 2>/dev/null
echo "✓ 创建大文件: $(basename "$LARGE_FILE") (50MB)"

dd if=/dev/zero of="$OVERSIZED_FILE" bs=1M count=150 2>/dev/null
echo "✓ 创建超大文件: $(basename "$OVERSIZED_FILE") (150MB)"

# 创建特殊文件名
touch "$SPACE_FILE"
echo "✓ 创建空格文件名: $(basename "$SPACE_FILE")"

touch "$SPECIAL_FILE"
echo "✓ 创建特殊字符文件名: $(basename "$SPECIAL_FILE")"

echo "中文内容测试" > "$CHINESE_FILE"
echo "✓ 创建中文文件名: $(basename "$CHINESE_FILE")"

# 创建压缩文件
tar -czf "$ARCHIVE_FILE" "$SMALL_FILE" "$MEDIUM_FILE" 2>/dev/null
echo "✓ 创建压缩文件: $(basename "$ARCHIVE_FILE")"

# 创建空文件
touch "$EMPTY_FILE"
echo "✓ 创建空文件: $(basename "$EMPTY_FILE")"

echo ""
echo "测试文件创建完成!"
echo "文件列表:"
ls -lh *.txt *.dat *.gz 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'

EOF
chmod +x create_test_files.sh
echo -e "${GREEN}✓${NC} create_test_files.sh"

# 3. 生成测试用例1
echo -e "${BLUE}[3/7]${NC} 生成测试用例1 - 服务器启动测试..."
cat > test_case_1_server_startup.sh << 'EOF'
#!/bin/bash
# 测试用例1: 服务器启动测试

source ./test_config.sh

echo "=== 测试用例1: 服务器启动测试 ==="
TEST_COUNT=0
PASS_COUNT=0

# 测试函数
test_result() {
    local test_name="$1"
    local result="$2"
    TEST_COUNT=$((TEST_COUNT + 1))
    if [ "$result" = "0" ]; then
        echo "✓ $test_name"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "✗ $test_name"
    fi
}

# 1.1 正常启动测试
echo "1.1 正常启动测试"
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" > /dev/null 2>&1 &
SERVER_PID=$!
sleep $SERVER_START_TIMEOUT

if kill -0 $SERVER_PID 2>/dev/null; then
    test_result "服务器正常启动" 0
    kill $SERVER_PID 2>/dev/null
    wait $SERVER_PID 2>/dev/null
else
    test_result "服务器正常启动" 1
fi

# 1.2 无效IP测试
echo "1.2 无效IP测试"
python3 "$UPLOAD_SERVER_PATH" "999.999.999.999" "$TEST_PORT" "$VALID_TOKEN" 2>&1 | grep -q "无效的IP地址"
test_result "无效IP检测" $?

# 1.3 无效端口测试
echo "1.3 无效端口测试"
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "99999" "$VALID_TOKEN" 2>&1 | grep -q "无效的端口号"
test_result "无效端口检测" $?

# 1.4 无效token测试
echo "1.4 无效token测试"
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$SHORT_TOKEN" 2>&1 | grep -q "无效的token格式"
test_result "短token检测" $?

python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$LONG_TOKEN" 2>&1 | grep -q "无效的token格式"
test_result "长token检测" $?

# 1.5 端口占用测试
echo "1.5 端口占用测试"
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" > /dev/null 2>&1 &
SERVER_PID1=$!
sleep 2

python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" 2>&1 | grep -q "端口.*已被占用"
test_result "端口占用检测" $?

kill $SERVER_PID1 2>/dev/null
wait $SERVER_PID1 2>/dev/null

echo ""
echo "测试用例1完成: $PASS_COUNT/$TEST_COUNT 通过"
echo "=== 测试用例1结束 ==="

EOF
chmod +x test_case_1_server_startup.sh
echo -e "${GREEN}✓${NC} test_case_1_server_startup.sh"

# 4. 生成测试用例2
echo -e "${BLUE}[4/7]${NC} 生成测试用例2 - 文件上传功能测试..."
cat > test_case_2_file_upload.sh << 'EOF'
#!/bin/bash
# 测试用例2: 文件上传功能测试

source ./test_config.sh

echo "=== 测试用例2: 文件上传功能测试 ==="
TEST_COUNT=0
PASS_COUNT=0

# 测试函数
test_result() {
    local test_name="$1"
    local result="$2"
    TEST_COUNT=$((TEST_COUNT + 1))
    if [ "$result" = "0" ]; then
        echo "✓ $test_name"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "✗ $test_name"
    fi
}

# 启动服务器
echo "启动测试服务器..."
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" > server.log 2>&1 &
SERVER_PID=$!
sleep $SERVER_START_TIMEOUT

if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo "✗ 服务器启动失败，跳过文件上传测试"
    exit 1
fi

echo "服务器启动成功，PID: $SERVER_PID"

# 2.1 小文件上传测试
echo "2.1 小文件上传测试"
timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SMALL_FILE" > /dev/null 2>&1
test_result "小文件上传" $?

# 2.2 中等文件上传测试
echo "2.2 中等文件上传测试"
timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$MEDIUM_FILE" > /dev/null 2>&1
test_result "中等文件上传" $?

# 2.3 大文件上传测试
echo "2.3 大文件上传测试"
timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$LARGE_FILE" > /dev/null 2>&1
test_result "大文件上传" $?

# 2.4 超大文件上传测试(应该失败)
echo "2.4 超大文件上传测试(应该失败)"
"$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$OVERSIZED_FILE" 2>&1 | grep -q "413"
test_result "超大文件拒绝" $?

# 2.5 压缩文件上传测试
echo "2.5 压缩文件上传测试"
timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$ARCHIVE_FILE" > /dev/null 2>&1
test_result "压缩文件上传" $?

# 2.6 空文件上传测试
echo "2.6 空文件上传测试"
timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$EMPTY_FILE" > /dev/null 2>&1
test_result "空文件上传" $?

# 2.7 特殊字符文件名测试
echo "2.7 特殊字符文件名测试"
timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SPACE_FILE" > /dev/null 2>&1
test_result "空格文件名上传" $?

timeout $UPLOAD_TIMEOUT "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SPECIAL_FILE" > /dev/null 2>&1
test_result "特殊字符文件名上传" $?

# 2.8 不存在文件测试
echo "2.8 不存在文件测试"
"$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$NONEXISTENT_FILE" 2>&1 | grep -q "文件不存在"
test_result "不存在文件检测" $?

# 关闭服务器
echo "关闭测试服务器..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo "测试用例2完成: $PASS_COUNT/$TEST_COUNT 通过"
echo "=== 测试用例2结束 ==="

EOF
chmod +x test_case_2_file_upload.sh
echo -e "${GREEN}✓${NC} test_case_2_file_upload.sh"

# 5. 生成测试用例3
echo -e "${BLUE}[5/7]${NC} 生成测试用例3 - 认证和安全测试..."
cat > test_case_3_security.sh << 'EOF'
#!/bin/bash
# 测试用例3: 认证和安全测试

source ./test_config.sh

echo "=== 测试用例3: 认证和安全测试 ==="
TEST_COUNT=0
PASS_COUNT=0

# 测试函数
test_result() {
    local test_name="$1"
    local result="$2"
    TEST_COUNT=$((TEST_COUNT + 1))
    if [ "$result" = "0" ]; then
        echo "✓ $test_name"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "✗ $test_name"
    fi
}

# 启动服务器
echo "启动测试服务器..."
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" > server.log 2>&1 &
SERVER_PID=$!
sleep $SERVER_START_TIMEOUT

# 3.1 有效token测试
echo "3.1 有效token测试"
"$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SMALL_FILE" > /dev/null 2>&1
test_result "有效token认证" $?

# 3.2 无效token测试
echo "3.2 无效token测试"
"$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$INVALID_TOKEN" "$SMALL_FILE" 2>&1 | grep -q "401"
test_result "无效token拒绝" $?

# 3.3 无token测试
echo "3.3 无token测试"
curl -X POST -F "file=@$SMALL_FILE" "http://$TEST_IP:$TEST_PORT/" 2>&1 | grep -q "401"
test_result "无token拒绝" $?

# 3.4 错误HTTP方法测试
echo "3.4 错误HTTP方法测试"
curl -X GET "http://$TEST_IP:$TEST_PORT/" 2>&1 | grep -q "404"
test_result "GET请求返回404" $?

# 3.5 健康检查测试
echo "3.5 健康检查测试"
curl -s "http://$TEST_IP:$TEST_PORT/health" | grep -q '"status":"ok"'
test_result "健康检查" $?

# 3.6 状态查询测试
echo "3.6 状态查询测试"
curl -s "http://$TEST_IP:$TEST_PORT/status" | grep -q '"status":"running"'
test_result "状态查询" $?

# 关闭服务器
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo "测试用例3完成: $PASS_COUNT/$TEST_COUNT 通过"
echo "=== 测试用例3结束 ==="

EOF
chmod +x test_case_3_security.sh
echo -e "${GREEN}✓${NC} test_case_3_security.sh"

# 6. 生成测试用例4
echo -e "${BLUE}[6/7]${NC} 生成测试用例4 - 并发和压力测试..."
cat > test_case_4_concurrent.sh << 'EOF'
#!/bin/bash
# 测试用例4: 并发和压力测试

source ./test_config.sh

echo "=== 测试用例4: 并发和压力测试 ==="
TEST_COUNT=0
PASS_COUNT=0

# 测试函数
test_result() {
    local test_name="$1"
    local result="$2"
    TEST_COUNT=$((TEST_COUNT + 1))
    if [ "$result" = "0" ]; then
        echo "✓ $test_name"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "✗ $test_name"
    fi
}

# 启动服务器
echo "启动测试服务器..."
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" > server.log 2>&1 &
SERVER_PID=$!
sleep $SERVER_START_TIMEOUT

# 4.1 并发上传测试
echo "4.1 并发上传测试($CONCURRENT_COUNT个并发)"
CONCURRENT_SUCCESS=0
for i in $(seq 1 $CONCURRENT_COUNT); do
    (
        "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SMALL_FILE" > "upload_$i.log" 2>&1
        if [ $? -eq 0 ]; then
            echo "1" > "success_$i.flag"
        fi
    ) &
done

# 等待所有并发任务完成
wait

# 统计成功数量
for i in $(seq 1 $CONCURRENT_COUNT); do
    if [ -f "success_$i.flag" ]; then
        CONCURRENT_SUCCESS=$((CONCURRENT_SUCCESS + 1))
        rm -f "success_$i.flag"
    fi
    rm -f "upload_$i.log"
done

if [ $CONCURRENT_SUCCESS -eq $CONCURRENT_COUNT ]; then
    test_result "并发上传($CONCURRENT_COUNT个)" 0
else
    test_result "并发上传($CONCURRENT_SUCCESS/$CONCURRENT_COUNT成功)" 1
fi

# 4.2 快速连续上传测试
echo "4.2 快速连续上传测试"
SEQUENTIAL_SUCCESS=0
for i in {1..10}; do
    "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SMALL_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        SEQUENTIAL_SUCCESS=$((SEQUENTIAL_SUCCESS + 1))
    fi
done

if [ $SEQUENTIAL_SUCCESS -eq 10 ]; then
    test_result "快速连续上传(10次)" 0
else
    test_result "快速连续上传($SEQUENTIAL_SUCCESS/10成功)" 1
fi

# 4.3 混合文件大小并发测试
echo "4.3 混合文件大小并发测试"
(
    "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$SMALL_FILE" > small_concurrent.log 2>&1 &
    "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$MEDIUM_FILE" > medium_concurrent.log 2>&1 &
    "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$VALID_TOKEN" "$LARGE_FILE" > large_concurrent.log 2>&1 &
    wait
)

# 检查混合并发结果
MIXED_SUCCESS=0
for log in small_concurrent.log medium_concurrent.log large_concurrent.log; do
    if [ -f "$log" ] && ! grep -q "错误\|失败\|error" "$log"; then
        MIXED_SUCCESS=$((MIXED_SUCCESS + 1))
    fi
    rm -f "$log"
done

if [ $MIXED_SUCCESS -eq 3 ]; then
    test_result "混合文件大小并发" 0
else
    test_result "混合文件大小并发($MIXED_SUCCESS/3成功)" 1
fi

# 关闭服务器
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo "测试用例4完成: $PASS_COUNT/$TEST_COUNT 通过"
echo "=== 测试用例4结束 ==="

EOF
chmod +x test_case_4_concurrent.sh
echo -e "${GREEN}✓${NC} test_case_4_concurrent.sh"

# 7. 生成完整测试套件
echo -e "${BLUE}[7/7]${NC} 生成完整测试套件..."
cat > run_all_tests.sh << 'EOF'
#!/bin/bash
# 完整测试套件执行脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    文件上传功能完整测试套件${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}开始时间: $(date)${NC}"
echo ""

# 检查测试环境
echo -e "${YELLOW}检查测试环境...${NC}"

# 检查必要工具
for tool in python3 curl netstat bash; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo -e "${RED}✗ $tool 未安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ $tool 可用${NC}"
done

# 加载配置
if [ ! -f "test_config.sh" ]; then
    echo -e "${RED}✗ 测试配置文件不存在${NC}"
    exit 1
fi
source ./test_config.sh

# 检查必要文件
if [ ! -f "$LINUXGUN_PATH" ]; then
    echo -e "${RED}✗ linuxgun.sh未找到: $LINUXGUN_PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✓ linuxgun.sh可用${NC}"

if [ ! -f "$UPLOAD_SERVER_PATH" ]; then
    echo -e "${RED}✗ uploadServer.py未找到: $UPLOAD_SERVER_PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✓ uploadServer.py可用${NC}"

echo ""
echo -e "${GREEN}环境检查完成，开始执行测试...${NC}"
echo ""

# 创建测试文件
echo -e "${YELLOW}创建测试文件...${NC}"
if [ -f "create_test_files.sh" ]; then
    bash create_test_files.sh
else
    echo -e "${RED}✗ 测试文件创建脚本不存在${NC}"
    exit 1
fi
echo ""

# 创建测试结果目录
mkdir -p test_results
TEST_START_TIME=$(date +%s)

# 运行测试用例
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0

for test_case in test_case_*.sh; do
    if [ -f "$test_case" ]; then
        echo -e "${BLUE}执行 $test_case${NC}"
        bash "$test_case" > "test_results/${test_case%.sh}_result.log" 2>&1
        
        # 统计结果
        if [ -f "test_results/${test_case%.sh}_result.log" ]; then
            PASSED=$(grep -c "✓" "test_results/${test_case%.sh}_result.log")
            FAILED=$(grep -c "✗" "test_results/${test_case%.sh}_result.log")
            TOTAL_PASSED=$((TOTAL_PASSED + PASSED))
            TOTAL_FAILED=$((TOTAL_FAILED + FAILED))
            TOTAL_TESTS=$((TOTAL_TESTS + PASSED + FAILED))
            
            echo -e "${GREEN}  通过: $PASSED${NC}, ${RED}失败: $FAILED${NC}"
        fi
        echo ""
    fi
done

# 计算测试时间
TEST_END_TIME=$(date +%s)
TEST_DURATION=$((TEST_END_TIME - TEST_START_TIME))

# 生成测试报告
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}           测试结果汇总${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}测试完成时间: $(date)${NC}"
echo -e "${GREEN}总测试时间: ${TEST_DURATION}秒${NC}"
echo -e "${GREEN}总测试数量: $TOTAL_TESTS${NC}"
echo -e "${GREEN}通过测试: $TOTAL_PASSED${NC}"
echo -e "${RED}失败测试: $TOTAL_FAILED${NC}"

if [ $TOTAL_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 所有测试通过!${NC}"
else
    echo -e "${YELLOW}⚠ 有测试失败，请检查详细日志${NC}"
fi

echo ""
echo -e "${BLUE}详细测试日志保存在 test_results/ 目录中${NC}"

# 清理临时文件
if [ "$KEEP_LOGS" != "true" ]; then
    echo -e "${YELLOW}清理临时文件...${NC}"
    rm -f *.log server.log
    echo -e "${GREEN}✓ 清理完成${NC}"
fi

echo -e "${BLUE}========================================${NC}"

EOF
chmod +x run_all_tests.sh
echo -e "${GREEN}✓${NC} run_all_tests.sh"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}    测试脚本生成完成!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${BLUE}生成的文件:${NC}"
ls -la *.sh | awk '{print "  " $9}'
echo ""
echo -e "${YELLOW}使用说明:${NC}"
echo -e "${BLUE}1.${NC} 修改 test_config.sh 中的配置"
echo -e "${BLUE}2.${NC} 运行 ./run_all_tests.sh 执行完整测试"
echo -e "${BLUE}3.${NC} 或单独运行测试用例: ./test_case_1_server_startup.sh"
echo ""
echo -e "${GREEN}测试套件已准备就绪!${NC}"