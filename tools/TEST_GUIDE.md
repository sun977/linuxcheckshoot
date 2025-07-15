# 文件上传功能测试指南

## 概述

本测试指南提供了完整的文件上传功能测试方案，包括 `linuxgun.sh` 的 `--send` 功能和 `uploadServer.py` 文件接收服务的全面测试。

## 测试环境要求

### 系统要求
- **操作系统**: Linux (推荐 CentOS 7+, Ubuntu 18.04+)
- **Python版本**: Python 3.6+
- **网络**: 支持TCP连接
- **磁盘空间**: 至少500MB可用空间

### 必需工具
```bash
# 检查必需工具
which python3 curl netstat bash tar gzip

# 如果缺少工具，请安装：
# CentOS/RHEL:
sudo yum install python3 curl net-tools bash tar gzip

# Ubuntu/Debian:
sudo apt-get install python3 curl net-tools bash tar gzip
```

### 权限要求
- 普通用户权限即可
- 需要能够绑定指定端口（建议使用8080-9999范围）
- 需要读写当前目录权限

## 快速开始

### 1. 快速功能验证

```bash
# 进入tools目录
cd tools/

# 运行快速测试
./quick_test.sh
```

快速测试将验证：
- 环境依赖检查
- 服务器启动
- 基本文件上传
- Token认证
- 服务器关闭

### 2. 生成完整测试套件

```bash
# 生成测试脚本
./generate_test_scripts.sh

# 进入测试目录
cd upload_test_suite/

# 修改配置（可选）
vim test_config.sh

# 运行完整测试
./run_all_tests.sh
```

## 详细测试说明

### 测试配置

编辑 `test_config.sh` 文件，根据实际环境调整配置：

```bash
# 服务器配置
TEST_IP="127.0.0.1"          # 测试IP地址
TEST_PORT="8080"             # 测试端口
VALID_TOKEN="test123456"     # 有效token

# 程序路径配置
LINUXGUN_PATH="../linuxgun.sh"
UPLOAD_SERVER_PATH="../uploadServer.py"

# 测试超时设置
SERVER_START_TIMEOUT=5       # 服务器启动超时(秒)
UPLOAD_TIMEOUT=30           # 文件上传超时(秒)
CONCURRENT_COUNT=5          # 并发测试数量
```

### 测试用例详解

#### 测试用例1: 服务器启动测试
**文件**: `test_case_1_server_startup.sh`

**测试内容**:
- 正常启动测试
- 无效IP地址检测
- 无效端口号检测
- Token格式验证
- 端口占用检测

**预期结果**:
```
✓ 服务器正常启动
✓ 无效IP检测
✓ 无效端口检测
✓ 短token检测
✓ 长token检测
✓ 端口占用检测
```

#### 测试用例2: 文件上传功能测试
**文件**: `test_case_2_file_upload.sh`

**测试内容**:
- 小文件上传 (< 1KB)
- 中等文件上传 (10MB)
- 大文件上传 (50MB)
- 超大文件上传 (150MB, 应失败)
- 压缩文件上传
- 空文件上传
- 特殊字符文件名
- 不存在文件检测

**预期结果**:
```
✓ 小文件上传
✓ 中等文件上传
✓ 大文件上传
✓ 超大文件拒绝
✓ 压缩文件上传
✓ 空文件上传
✓ 空格文件名上传
✓ 特殊字符文件名上传
✓ 不存在文件检测
```

#### 测试用例3: 认证和安全测试
**文件**: `test_case_3_security.sh`

**测试内容**:
- 有效Token认证
- 无效Token拒绝
- 无Token请求拒绝
- 错误HTTP方法处理
- 健康检查接口
- 状态查询接口

**预期结果**:
```
✓ 有效token认证
✓ 无效token拒绝
✓ 无token拒绝
✓ GET请求返回404
✓ 健康检查
✓ 状态查询
```

#### 测试用例4: 并发和压力测试
**文件**: `test_case_4_concurrent.sh`

**测试内容**:
- 并发上传测试 (5个并发)
- 快速连续上传 (10次)
- 混合文件大小并发

**预期结果**:
```
✓ 并发上传(5个)
✓ 快速连续上传(10次)
✓ 混合文件大小并发
```

## 手动测试步骤

### 1. 启动上传服务器

```bash
# 方法1: 使用Python脚本
python3 uploadServer.py 127.0.0.1 8080 mytoken123

# 方法2: 使用Shell脚本
./uploadServer.sh --start 127.0.0.1 8080 mytoken123
```

**预期输出**:
```
========================================
           文件上传服务器
========================================
服务器信息:
  IP地址: 127.0.0.1
  端口: 8080
  Token: mytoken123
  上传目录: ./uploads
  最大文件大小: 100MB
  启动时间: 2024-01-15 10:30:45

服务器已启动，等待文件上传...
按 Ctrl+C 停止服务器

接收路径: http://127.0.0.1:8080/
健康检查: http://127.0.0.1:8080/health
状态查询: http://127.0.0.1:8080/status
```

### 2. 测试文件上传

```bash
# 创建测试文件
echo "Test content" > test.txt
dd if=/dev/zero of=large.dat bs=1M count=10

# 上传文件
./linuxgun.sh --send 127.0.0.1 8080 mytoken123 test.txt
./linuxgun.sh --send 127.0.0.1 8080 mytoken123 large.dat
```

**预期输出**:
```
正在上传文件到远程服务器...
服务器: 127.0.0.1:8080
文件: test.txt
文件上传成功!
服务器响应: {"status":"success","message":"文件上传成功","filename":"test.txt","size":13}
```

### 3. 测试认证安全

```bash
# 测试错误token
./linuxgun.sh --send 127.0.0.1 8080 wrongtoken test.txt

# 测试无token (使用curl)
curl -X POST -F "file=@test.txt" http://127.0.0.1:8080/
```

**预期输出**:
```
# 错误token
文件上传失败!
HTTP错误代码: 401
错误信息: Unauthorized

# 无token
{"error":"Missing Authorization header"}
```

### 4. 测试健康检查

```bash
# 健康检查
curl http://127.0.0.1:8080/health

# 状态查询
curl http://127.0.0.1:8080/status
```

**预期输出**:
```
# 健康检查
{"status":"ok","timestamp":"2024-01-15T10:30:45Z"}

# 状态查询
{"status":"running","uptime":"00:05:23","uploads":3,"total_size":"10.5MB"}
```

## 故障排除

### 常见问题

#### 1. 服务器启动失败

**问题**: `Address already in use`
```bash
# 检查端口占用
netstat -tlnp | grep :8080

# 杀死占用进程
sudo kill -9 <PID>

# 或使用其他端口
python3 uploadServer.py 127.0.0.1 8081 mytoken123
```

**问题**: `Permission denied`
```bash
# 使用非特权端口 (>1024)
python3 uploadServer.py 127.0.0.1 8080 mytoken123

# 或检查防火墙
sudo firewall-cmd --list-ports
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

#### 2. 文件上传失败

**问题**: `Connection refused`
```bash
# 检查服务器是否运行
curl http://127.0.0.1:8080/health

# 检查网络连接
telnet 127.0.0.1 8080
```

**问题**: `File too large`
```bash
# 检查文件大小
ls -lh large_file.dat

# 服务器默认限制100MB，可以修改uploadServer.py中的MAX_FILE_SIZE
```

**问题**: `Token authentication failed`
```bash
# 确保token一致
echo "服务器token: mytoken123"
echo "客户端token: mytoken123"

# 检查token长度 (8-64字符)
echo "mytoken123" | wc -c
```

#### 3. 测试脚本问题

**问题**: `Permission denied` 执行脚本
```bash
# 添加执行权限
chmod +x *.sh
```

**问题**: `Command not found`
```bash
# 检查依赖
which python3 curl netstat

# 安装缺失工具
sudo yum install python3 curl net-tools  # CentOS
sudo apt install python3 curl net-tools  # Ubuntu
```

**问题**: 测试文件创建失败
```bash
# 检查磁盘空间
df -h .

# 检查写权限
ls -ld .
touch test_write_permission && rm test_write_permission
```

### 调试技巧

#### 1. 启用详细日志

```bash
# 服务器端详细日志
python3 uploadServer.py 127.0.0.1 8080 mytoken123 --debug

# 客户端详细输出
bash -x linuxgun.sh --send 127.0.0.1 8080 mytoken123 test.txt
```

#### 2. 网络调试

```bash
# 抓包分析
sudo tcpdump -i lo port 8080

# 使用curl详细模式
curl -v -X POST -H "Authorization: Bearer mytoken123" -F "file=@test.txt" http://127.0.0.1:8080/
```

#### 3. 性能监控

```bash
# 监控服务器资源
top -p $(pgrep -f uploadServer.py)

# 监控网络连接
watch 'netstat -an | grep :8080'

# 监控磁盘IO
iostat -x 1
```

## 测试报告

### 自动生成报告

运行完整测试后，会在 `test_results/` 目录生成详细报告：

```
test_results/
├── test_case_1_server_startup_result.log
├── test_case_2_file_upload_result.log
├── test_case_3_security_result.log
└── test_case_4_concurrent_result.log
```

### 报告解读

**成功示例**:
```
=== 测试用例1: 服务器启动测试 ===
✓ 服务器正常启动
✓ 无效IP检测
✓ 无效端口检测
✓ 短token检测
✓ 长token检测
✓ 端口占用检测

测试用例1完成: 6/6 通过
```

**失败示例**:
```
=== 测试用例2: 文件上传功能测试 ===
✓ 小文件上传
✗ 中等文件上传
✓ 大文件上传

测试用例2完成: 2/3 通过
```

## 性能基准

### 预期性能指标

| 测试项目 | 预期结果 | 备注 |
|---------|---------|------|
| 服务器启动时间 | < 3秒 | 包含Python解释器启动 |
| 小文件上传(1KB) | < 1秒 | 本地网络 |
| 中等文件上传(10MB) | < 10秒 | 本地网络 |
| 大文件上传(50MB) | < 30秒 | 本地网络 |
| 并发上传(5个) | 全部成功 | 小文件并发 |
| 内存使用 | < 100MB | 服务器进程 |
| CPU使用 | < 50% | 上传期间 |

### 压力测试建议

```bash
# 大量小文件测试
for i in {1..100}; do
    echo "test $i" > "test_$i.txt"
    ./linuxgun.sh --send 127.0.0.1 8080 mytoken123 "test_$i.txt" &
done
wait

# 长时间运行测试
while true; do
    ./linuxgun.sh --send 127.0.0.1 8080 mytoken123 test.txt
    sleep 1
done
```

## 安全测试

### 安全检查清单

- [ ] Token认证正常工作
- [ ] 无效Token被正确拒绝
- [ ] 文件大小限制生效
- [ ] 文件名安全处理
- [ ] 路径遍历攻击防护
- [ ] 服务器错误信息不泄露敏感信息
- [ ] 上传目录权限正确设置

### 安全测试用例

```bash
# 路径遍历测试
echo "malicious" > "../../../etc/passwd"
./linuxgun.sh --send 127.0.0.1 8080 mytoken123 "../../../etc/passwd"

# 特殊文件名测试
touch "file;rm -rf /"
./linuxgun.sh --send 127.0.0.1 8080 mytoken123 "file;rm -rf /"

# 大量请求测试
for i in {1..1000}; do
    curl -X POST http://127.0.0.1:8080/ &
done
```

## 总结

本测试指南提供了完整的文件上传功能测试方案，包括：

1. **快速验证**: 使用 `quick_test.sh` 进行基本功能检查
2. **完整测试**: 使用自动生成的测试套件进行全面测试
3. **手动测试**: 详细的手动测试步骤和验证方法
4. **故障排除**: 常见问题的解决方案
5. **性能基准**: 预期的性能指标
6. **安全测试**: 安全相关的测试用例

通过这些测试，可以确保文件上传功能在各种场景下都能正常、安全、稳定地工作。