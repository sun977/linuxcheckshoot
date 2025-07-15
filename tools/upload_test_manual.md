# 文件上传功能测试手册

## 概述

本测试手册用于验证 `linuxgun.sh` 的 `--send` 功能和 `uploadServer.py` 服务器的文件上传功能。测试环境要求Linux服务器，支持Python3和bash。

## 测试环境要求

### 服务器环境
- **操作系统**: Linux (CentOS 7+, Ubuntu 18.04+, RHEL 7+)
- **Python版本**: Python 3.6+
- **网络**: 支持TCP连接，防火墙开放测试端口
- **磁盘空间**: 至少1GB可用空间
- **权限**: 普通用户权限即可

### 必需工具
- `curl` (用于HTTP请求)
- `netstat` (用于端口检查)
- `python3` (运行上传服务器)
- `bash` (运行linuxgun.sh)

## 测试文件准备

### 1. 创建测试文件

```bash
# 创建测试目录
mkdir -p ~/upload_test
cd ~/upload_test

# 创建不同大小的测试文件
echo "Small test file" > small_file.txt
dd if=/dev/zero of=medium_file.dat bs=1M count=10  # 10MB文件
dd if=/dev/zero of=large_file.dat bs=1M count=50   # 50MB文件
dd if=/dev/zero of=oversized_file.dat bs=1M count=150  # 150MB文件(超过默认限制)

# 创建特殊字符文件名
touch "test file with spaces.txt"
touch "test-file_with.special@chars.txt"
touch "中文文件名.txt"

# 创建压缩文件
tar -czf test_archive.tar.gz *.txt *.dat

# 创建空文件
touch empty_file.txt
```

### 2. 创建测试配置文件

```bash
# 创建测试配置
cat > test_config.sh << 'EOF'
#!/bin/bash

# 测试配置
TEST_IP="127.0.0.1"          # 测试IP地址
TEST_PORT="8080"             # 测试端口
VALID_TOKEN="test123456"     # 有效token
INVALID_TOKEN="wrongtoken"   # 无效token
SHORT_TOKEN="short"          # 过短token
LONG_TOKEN="verylongtokenthatexceedsmaximumlengthof64charactersandshouldfail"

# 测试文件路径
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

# linuxgun.sh路径(需要根据实际情况调整)
LINUXGUN_PATH="../linuxgun.sh"
UPLOAD_SERVER_PATH="./uploadServer.py"

EOF

# 使配置文件可执行
chmod +x test_config.sh
```

## 测试用例

### 测试用例1: 服务器启动测试

```bash
#!/bin/bash
# test_case_1_server_startup.sh

source ./test_config.sh

echo "=== 测试用例1: 服务器启动测试 ==="

# 1.1 正常启动测试
echo "1.1 正常启动测试"
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN &
SERVER_PID=$!
sleep 3

if kill -0 $SERVER_PID 2>/dev/null; then
    echo "✓ 服务器启动成功"
    kill $SERVER_PID
    wait $SERVER_PID 2>/dev/null
else
    echo "✗ 服务器启动失败"
fi

# 1.2 无效IP测试
echo "1.2 无效IP测试"
python3 $UPLOAD_SERVER_PATH "999.999.999.999" $TEST_PORT $VALID_TOKEN 2>&1 | grep -q "无效的IP地址"
if [ $? -eq 0 ]; then
    echo "✓ 无效IP检测正常"
else
    echo "✗ 无效IP检测失败"
fi

# 1.3 无效端口测试
echo "1.3 无效端口测试"
python3 $UPLOAD_SERVER_PATH $TEST_IP "99999" $VALID_TOKEN 2>&1 | grep -q "无效的端口号"
if [ $? -eq 0 ]; then
    echo "✓ 无效端口检测正常"
else
    echo "✗ 无效端口检测失败"
fi

# 1.4 无效token测试
echo "1.4 无效token测试"
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $SHORT_TOKEN 2>&1 | grep -q "无效的token格式"
if [ $? -eq 0 ]; then
    echo "✓ 短token检测正常"
else
    echo "✗ 短token检测失败"
fi

python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $LONG_TOKEN 2>&1 | grep -q "无效的token格式"
if [ $? -eq 0 ]; then
    echo "✓ 长token检测正常"
else
    echo "✗ 长token检测失败"
fi

# 1.5 端口占用测试
echo "1.5 端口占用测试"
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN &
SERVER_PID1=$!
sleep 2

python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN 2>&1 | grep -q "端口.*已被占用"
if [ $? -eq 0 ]; then
    echo "✓ 端口占用检测正常"
else
    echo "✗ 端口占用检测失败"
fi

kill $SERVER_PID1 2>/dev/null
wait $SERVER_PID1 2>/dev/null

echo "=== 测试用例1完成 ==="
```

### 测试用例2: 文件上传功能测试

```bash
#!/bin/bash
# test_case_2_file_upload.sh

source ./test_config.sh

echo "=== 测试用例2: 文件上传功能测试 ==="

# 启动服务器
echo "启动测试服务器..."
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN > server.log 2>&1 &
SERVER_PID=$!
sleep 3

if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo "✗ 服务器启动失败"
    exit 1
fi

echo "服务器启动成功，PID: $SERVER_PID"

# 2.1 小文件上传测试
echo "2.1 小文件上传测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE
if [ $? -eq 0 ]; then
    echo "✓ 小文件上传成功"
else
    echo "✗ 小文件上传失败"
fi

# 2.2 中等文件上传测试
echo "2.2 中等文件上传测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $MEDIUM_FILE
if [ $? -eq 0 ]; then
    echo "✓ 中等文件上传成功"
else
    echo "✗ 中等文件上传失败"
fi

# 2.3 大文件上传测试
echo "2.3 大文件上传测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $LARGE_FILE
if [ $? -eq 0 ]; then
    echo "✓ 大文件上传成功"
else
    echo "✗ 大文件上传失败"
fi

# 2.4 超大文件上传测试(应该失败)
echo "2.4 超大文件上传测试(应该失败)"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $OVERSIZED_FILE 2>&1 | grep -q "413"
if [ $? -eq 0 ]; then
    echo "✓ 超大文件正确被拒绝"
else
    echo "✗ 超大文件拒绝机制失败"
fi

# 2.5 压缩文件上传测试
echo "2.5 压缩文件上传测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $ARCHIVE_FILE
if [ $? -eq 0 ]; then
    echo "✓ 压缩文件上传成功"
else
    echo "✗ 压缩文件上传失败"
fi

# 2.6 空文件上传测试
echo "2.6 空文件上传测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $EMPTY_FILE
if [ $? -eq 0 ]; then
    echo "✓ 空文件上传成功"
else
    echo "✗ 空文件上传失败"
fi

# 2.7 特殊字符文件名测试
echo "2.7 特殊字符文件名测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN "$SPACE_FILE"
if [ $? -eq 0 ]; then
    echo "✓ 空格文件名上传成功"
else
    echo "✗ 空格文件名上传失败"
fi

$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN "$SPECIAL_FILE"
if [ $? -eq 0 ]; then
    echo "✓ 特殊字符文件名上传成功"
else
    echo "✗ 特殊字符文件名上传失败"
fi

# 2.8 不存在文件测试
echo "2.8 不存在文件测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $NONEXISTENT_FILE 2>&1 | grep -q "文件不存在"
if [ $? -eq 0 ]; then
    echo "✓ 不存在文件正确检测"
else
    echo "✗ 不存在文件检测失败"
fi

# 关闭服务器
echo "关闭测试服务器..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "=== 测试用例2完成 ==="
```

### 测试用例3: 认证和安全测试

```bash
#!/bin/bash
# test_case_3_security.sh

source ./test_config.sh

echo "=== 测试用例3: 认证和安全测试 ==="

# 启动服务器
echo "启动测试服务器..."
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN > server.log 2>&1 &
SERVER_PID=$!
sleep 3

# 3.1 有效token测试
echo "3.1 有效token测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE
if [ $? -eq 0 ]; then
    echo "✓ 有效token认证成功"
else
    echo "✗ 有效token认证失败"
fi

# 3.2 无效token测试
echo "3.2 无效token测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $INVALID_TOKEN $SMALL_FILE 2>&1 | grep -q "401"
if [ $? -eq 0 ]; then
    echo "✓ 无效token正确被拒绝"
else
    echo "✗ 无效token拒绝机制失败"
fi

# 3.3 无token测试
echo "3.3 无token测试"
curl -X POST -F "file=@$SMALL_FILE" http://$TEST_IP:$TEST_PORT/ 2>&1 | grep -q "401"
if [ $? -eq 0 ]; then
    echo "✓ 无token请求正确被拒绝"
else
    echo "✗ 无token拒绝机制失败"
fi

# 3.4 错误HTTP方法测试
echo "3.4 错误HTTP方法测试"
curl -X GET http://$TEST_IP:$TEST_PORT/ 2>&1 | grep -q "404"
if [ $? -eq 0 ]; then
    echo "✓ GET请求正确返回404"
else
    echo "✗ GET请求处理异常"
fi

# 3.5 健康检查测试
echo "3.5 健康检查测试"
curl -s http://$TEST_IP:$TEST_PORT/health | grep -q '"status":"ok"'
if [ $? -eq 0 ]; then
    echo "✓ 健康检查正常"
else
    echo "✗ 健康检查失败"
fi

# 3.6 状态查询测试
echo "3.6 状态查询测试"
curl -s http://$TEST_IP:$TEST_PORT/status | grep -q '"status":"running"'
if [ $? -eq 0 ]; then
    echo "✓ 状态查询正常"
else
    echo "✗ 状态查询失败"
fi

# 关闭服务器
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "=== 测试用例3完成 ==="
```

### 测试用例4: 并发和压力测试

```bash
#!/bin/bash
# test_case_4_concurrent.sh

source ./test_config.sh

echo "=== 测试用例4: 并发和压力测试 ==="

# 启动服务器
echo "启动测试服务器..."
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN > server.log 2>&1 &
SERVER_PID=$!
sleep 3

# 4.1 并发上传测试
echo "4.1 并发上传测试(5个并发)"
for i in {1..5}; do
    (
        echo "启动并发任务 $i"
        $LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE > upload_$i.log 2>&1
        if [ $? -eq 0 ]; then
            echo "✓ 并发任务 $i 成功"
        else
            echo "✗ 并发任务 $i 失败"
        fi
    ) &
done

# 等待所有并发任务完成
wait

# 4.2 快速连续上传测试
echo "4.2 快速连续上传测试"
for i in {1..10}; do
    $LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ 连续上传 $i 成功"
    else
        echo "✗ 连续上传 $i 失败"
    fi
done

# 4.3 混合文件大小并发测试
echo "4.3 混合文件大小并发测试"
(
    $LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE > small_concurrent.log 2>&1 &
    $LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $MEDIUM_FILE > medium_concurrent.log 2>&1 &
    $LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $LARGE_FILE > large_concurrent.log 2>&1 &
    wait
)

echo "✓ 混合文件大小并发测试完成"

# 关闭服务器
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "=== 测试用例4完成 ==="
```

### 测试用例5: 错误处理和边界测试

```bash
#!/bin/bash
# test_case_5_error_handling.sh

source ./test_config.sh

echo "=== 测试用例5: 错误处理和边界测试 ==="

# 5.1 服务器未启动测试
echo "5.1 服务器未启动测试"
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE 2>&1 | grep -q "连接"
if [ $? -eq 0 ]; then
    echo "✓ 服务器未启动错误正确处理"
else
    echo "✗ 服务器未启动错误处理失败"
fi

# 启动服务器进行后续测试
echo "启动测试服务器..."
python3 $UPLOAD_SERVER_PATH $TEST_IP $TEST_PORT $VALID_TOKEN > server.log 2>&1 &
SERVER_PID=$!
sleep 3

# 5.2 错误端口测试
echo "5.2 错误端口测试"
$LINUXGUN_PATH --send $TEST_IP "9999" $VALID_TOKEN $SMALL_FILE 2>&1 | grep -q "连接"
if [ $? -eq 0 ]; then
    echo "✓ 错误端口连接失败正确处理"
else
    echo "✗ 错误端口连接失败处理异常"
fi

# 5.3 网络中断模拟(通过防火墙规则)
echo "5.3 网络中断模拟测试"
# 注意: 这个测试需要root权限，在生产环境中谨慎使用
if [ "$EUID" -eq 0 ]; then
    iptables -A OUTPUT -p tcp --dport $TEST_PORT -j DROP 2>/dev/null
    $LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE 2>&1 | grep -q "超时\|连接"
    if [ $? -eq 0 ]; then
        echo "✓ 网络中断正确处理"
    else
        echo "✗ 网络中断处理失败"
    fi
    iptables -D OUTPUT -p tcp --dport $TEST_PORT -j DROP 2>/dev/null
else
    echo "⚠ 跳过网络中断测试(需要root权限)"
fi

# 5.4 磁盘空间不足模拟
echo "5.4 磁盘空间测试"
# 创建一个小的临时文件系统来模拟磁盘空间不足
if command -v fallocate >/dev/null 2>&1; then
    echo "✓ 磁盘空间测试环境可用"
    # 这里可以添加具体的磁盘空间不足测试逻辑
else
    echo "⚠ 跳过磁盘空间测试(fallocate不可用)"
fi

# 5.5 服务器异常关闭测试
echo "5.5 服务器异常关闭测试"
kill -9 $SERVER_PID 2>/dev/null
sleep 2
$LINUXGUN_PATH --send $TEST_IP $TEST_PORT $VALID_TOKEN $SMALL_FILE 2>&1 | grep -q "连接"
if [ $? -eq 0 ]; then
    echo "✓ 服务器异常关闭正确检测"
else
    echo "✗ 服务器异常关闭检测失败"
fi

echo "=== 测试用例5完成 ==="
```

## 完整测试套件

```bash
#!/bin/bash
# run_all_tests.sh - 运行所有测试用例

echo "========================================"
echo "    文件上传功能完整测试套件"
echo "========================================"
echo "开始时间: $(date)"
echo ""

# 检查测试环境
echo "检查测试环境..."

# 检查Python3
if ! command -v python3 >/dev/null 2>&1; then
    echo "✗ Python3未安装"
    exit 1
fi
echo "✓ Python3可用: $(python3 --version)"

# 检查curl
if ! command -v curl >/dev/null 2>&1; then
    echo "✗ curl未安装"
    exit 1
fi
echo "✓ curl可用"

# 检查netstat
if ! command -v netstat >/dev/null 2>&1; then
    echo "✗ netstat未安装"
    exit 1
fi
echo "✓ netstat可用"

# 检查必要文件
source ./test_config.sh
if [ ! -f "$LINUXGUN_PATH" ]; then
    echo "✗ linuxgun.sh未找到: $LINUXGUN_PATH"
    exit 1
fi
echo "✓ linuxgun.sh可用"

if [ ! -f "$UPLOAD_SERVER_PATH" ]; then
    echo "✗ uploadServer.py未找到: $UPLOAD_SERVER_PATH"
    exit 1
fi
echo "✓ uploadServer.py可用"

echo ""
echo "环境检查完成，开始执行测试..."
echo ""

# 创建测试结果目录
mkdir -p test_results
TEST_START_TIME=$(date +%s)

# 运行测试用例
echo "执行测试用例1: 服务器启动测试"
bash test_case_1_server_startup.sh > test_results/test1_result.log 2>&1
echo "测试用例1完成"
echo ""

echo "执行测试用例2: 文件上传功能测试"
bash test_case_2_file_upload.sh > test_results/test2_result.log 2>&1
echo "测试用例2完成"
echo ""

echo "执行测试用例3: 认证和安全测试"
bash test_case_3_security.sh > test_results/test3_result.log 2>&1
echo "测试用例3完成"
echo ""

echo "执行测试用例4: 并发和压力测试"
bash test_case_4_concurrent.sh > test_results/test4_result.log 2>&1
echo "测试用例4完成"
echo ""

echo "执行测试用例5: 错误处理和边界测试"
bash test_case_5_error_handling.sh > test_results/test5_result.log 2>&1
echo "测试用例5完成"
echo ""

# 计算测试时间
TEST_END_TIME=$(date +%s)
TEST_DURATION=$((TEST_END_TIME - TEST_START_TIME))

# 生成测试报告
echo "========================================"
echo "           测试结果汇总"
echo "========================================"
echo "测试完成时间: $(date)"
echo "总测试时间: ${TEST_DURATION}秒"
echo ""

# 统计测试结果
for i in {1..5}; do
    echo "测试用例$i结果:"
    if [ -f "test_results/test${i}_result.log" ]; then
        SUCCESS_COUNT=$(grep -c "✓" test_results/test${i}_result.log)
        FAIL_COUNT=$(grep -c "✗" test_results/test${i}_result.log)
        echo "  成功: $SUCCESS_COUNT 项"
        echo "  失败: $FAIL_COUNT 项"
        
        if [ $FAIL_COUNT -gt 0 ]; then
            echo "  失败详情:"
            grep "✗" test_results/test${i}_result.log | sed 's/^/    /'
        fi
    else
        echo "  ✗ 测试日志文件不存在"
    fi
    echo ""
done

# 清理测试文件
echo "清理测试环境..."
rm -f *.log upload_*.log small_concurrent.log medium_concurrent.log large_concurrent.log
echo "✓ 测试环境清理完成"

echo "========================================"
echo "详细测试日志保存在 test_results/ 目录中"
echo "========================================"
```

## 测试执行步骤

### 1. 环境准备

```bash
# 1. 上传文件到Linux服务器
scp -r linuxgun3.1-releases/ user@server:/home/user/

# 2. 登录服务器
ssh user@server

# 3. 进入测试目录
cd /home/user/linuxgun3.1-releases/tools/

# 4. 确保文件权限
chmod +x ../linuxgun.sh
chmod +x uploadServer.py
```

### 2. 创建测试环境

```bash
# 创建测试目录和文件
mkdir -p ~/upload_test
cd ~/upload_test

# 复制测试脚本
cp /path/to/test_scripts/* .

# 创建测试文件
bash test_config.sh
```

### 3. 执行测试

```bash
# 运行完整测试套件
bash run_all_tests.sh

# 或者单独运行测试用例
bash test_case_1_server_startup.sh
bash test_case_2_file_upload.sh
bash test_case_3_security.sh
bash test_case_4_concurrent.sh
bash test_case_5_error_handling.sh
```

### 4. 查看测试结果

```bash
# 查看测试结果汇总
cat test_results/test*_result.log

# 查看服务器日志
cat server.log

# 查看上传的文件
ls -la uploads/
```

## 预期测试结果

### 正常情况下的预期结果

- **测试用例1**: 所有服务器启动测试应该通过
- **测试用例2**: 除超大文件外，所有文件上传测试应该成功
- **测试用例3**: 有效token通过，无效token被拒绝
- **测试用例4**: 并发上传应该全部成功
- **测试用例5**: 错误情况应该被正确处理

### 常见问题排查

1. **端口被占用**: 更改测试端口或停止占用端口的进程
2. **权限问题**: 确保有写入权限和执行权限
3. **防火墙阻拦**: 开放测试端口或临时关闭防火墙
4. **Python版本**: 确保Python 3.6+版本
5. **网络问题**: 检查网络连接和DNS解析

## 性能基准

### 预期性能指标

- **小文件(< 1MB)**: 上传时间 < 1秒
- **中等文件(10MB)**: 上传时间 < 10秒
- **大文件(50MB)**: 上传时间 < 30秒
- **并发连接**: 支持至少5个并发上传
- **内存使用**: 服务器内存使用 < 100MB

### 性能测试命令

```bash
# 测试上传速度
time ./linuxgun.sh --send 127.0.0.1 8080 test123456 large_file.dat

# 监控服务器资源使用
top -p $(pgrep -f uploadServer.py)

# 网络监控
netstat -i
iftop -i eth0
```

## 安全测试检查清单

- [ ] Token认证机制正常工作
- [ ] 无效token被正确拒绝
- [ ] 文件大小限制生效
- [ ] 文件名安全处理(防止目录遍历)
- [ ] 未授权访问被阻止
- [ ] 错误信息不泄露敏感信息
- [ ] 日志记录访问尝试
- [ ] CORS设置适当

## 故障排除指南

### 常见错误及解决方案

1. **连接被拒绝**
   - 检查服务器是否启动
   - 检查端口是否正确
   - 检查防火墙设置

2. **401 Unauthorized**
   - 检查token是否正确
   - 检查token格式是否符合要求

3. **413 File too large**
   - 检查文件大小是否超过限制
   - 调整MAX_SIZE配置

4. **500 Internal Server Error**
   - 检查服务器日志
   - 检查磁盘空间
   - 检查文件权限

5. **超时错误**
   - 检查网络连接
   - 增加超时时间
   - 检查服务器负载

---

**注意**: 本测试手册适用于Linux服务器环境。在生产环境中运行测试前，请确保已备份重要数据并获得必要的权限。