# LinuxGun-dev.sh CentOS 7 测试工具包

## 概述

本测试工具包为 LinuxGun-dev.sh 脚本在 CentOS 7 环境下提供了完整的测试解决方案。包含快速验证、全面测试、结果分析和问题修复等全套工具。

## 工具包内容

### 📋 测试方案文档

| 文件名 | 描述 | 用途 |
|--------|------|------|
| `centos7_test_plan.md` | 详细测试方案 | 测试规划、用例设计参考 |
| `centos7_test_guide.md` | 测试执行指南 | 详细的操作步骤和环境准备 |
| `test_result_analysis_guide.md` | 结果分析指南 | 问题诊断和修复方案 |
| `README_TESTING.md` | 测试工具包说明 | 工具使用总览（本文档） |

### 🔧 测试执行工具

| 文件名 | 描述 | 执行时间 | 适用场景 |
|--------|------|----------|----------|
| `centos7_quick_test.sh` | 快速验证脚本 | 5-10分钟 | 快速检查、CI/CD集成 |
| `centos7_test_suite.sh` | 完整测试套件 | 1-2小时 | 全面测试、发布验证 |

### 📊 测试结果文件

测试执行后会生成以下文件：

- `test_logs_[时间戳]/` - 测试日志目录
- `centos7_test_report_[时间戳].md` - Markdown格式测试报告
- `test_results_[时间戳].json` - JSON格式测试结果
- `test_summary_[时间戳].txt` - 测试摘要
- `quick_test_[时间戳].log` - 快速测试日志

## 快速开始

### 1. 环境要求

- **操作系统**: CentOS 7.x
- **权限**: root 或 sudo
- **内存**: 最少 2GB
- **磁盘**: 最少 10GB 可用空间
- **网络**: 能够访问互联网

### 2. 快速验证（推荐首次使用）

```bash
# 进入脚本目录
cd /path/to/linuxgun3.1-releases

# 运行快速验证
sudo ./centos7_quick_test.sh

# 查看结果
echo "退出码: $?"
cat quick_test_*.log
```

**预期结果**: 成功率 ≥ 90%，所有核心功能正常

### 3. 完整测试（详细验证）

```bash
# 运行完整测试套件（建议在 screen 中执行）
screen -S linuxgun_test
sudo ./centos7_test_suite.sh

# 或者运行特定模块
sudo ./centos7_test_suite.sh --basic --system
```

**预期结果**: 总体成功率 ≥ 85%，核心模块成功率 ≥ 95%

## 详细使用说明

### 快速测试脚本 (centos7_quick_test.sh)

#### 功能特点
- ✅ 基础功能验证（语法、帮助、参数解析）
- ✅ 核心模块测试（系统、网络、进程、用户）
- ✅ 性能基准测试
- ✅ 系统兼容性检查
- ✅ 自动生成测试报告

#### 使用方法
```bash
# 基本使用
sudo ./centos7_quick_test.sh

# 详细输出模式
sudo ./centos7_quick_test.sh --verbose

# 查看帮助
./centos7_quick_test.sh --help
```

#### 输出示例
```
========================================
  LinuxGun-dev.sh CentOS 7 快速验证
========================================

=== 环境检查 ===
✓ CentOS 7 环境确认
✓ Root 权限确认
✓ 测试脚本存在: ./linuxGun-dev.sh
✓ 脚本语法正确

=== 系统兼容性检查 ===
✓ netstat 命令可用
✓ lsof 命令可用
✓ ps 命令可用
...

=== 快速功能测试 ===
[测试] 脚本语法检查
  ✓ 通过 (耗时: 1s)
[测试] 帮助信息显示
  ✓ 通过 (耗时: 2s)
...

=== 快速测试报告 ===
测试时间: 2024-01-15 10:30:00
总测试数: 12
通过测试: 11
失败测试: 1
成功率: 92%
✓ 测试结果: 优秀
```

### 完整测试套件 (centos7_test_suite.sh)

#### 功能特点
- 🔍 31个详细测试用例
- 📊 多种测试模块（基础、系统、网络、安全、性能）
- 📈 详细的性能分析
- 📋 完整的测试报告
- 🔧 灵活的模块选择

#### 使用方法
```bash
# 运行所有测试
sudo ./centos7_test_suite.sh

# 运行特定模块
sudo ./centos7_test_suite.sh --basic          # 基础功能测试
sudo ./centos7_test_suite.sh --system         # 系统模块测试
sudo ./centos7_test_suite.sh --network        # 网络模块测试
sudo ./centos7_test_suite.sh --security       # 安全检查测试
sudo ./centos7_test_suite.sh --performance    # 性能测试

# 组合测试
sudo ./centos7_test_suite.sh --system --network

# 详细输出
sudo ./centos7_test_suite.sh --verbose

# 测试后不清理环境
sudo ./centos7_test_suite.sh --no-cleanup

# 查看帮助
./centos7_test_suite.sh --help
```

#### 测试模块说明

| 模块 | 测试用例数 | 主要内容 | 预期耗时 |
|------|------------|----------|----------|
| 基础功能 | 5 | 语法检查、参数解析、错误处理 | 2-5分钟 |
| 系统模块 | 4 | 系统信息、用户权限、配置检查 | 10-20分钟 |
| 网络模块 | 3 | 网络配置、连接分析、SSH检查 | 10-15分钟 |
| 进程服务 | 3 | 进程信息、服务检查、危险进程 | 10-15分钟 |
| 安全检查 | 4 | Webshell、病毒、Rootkit检测 | 30-60分钟 |
| 容器集群 | 3 | Kubernetes环境检查 | 5-10分钟 |
| 交互模式 | 3 | 交互功能、用户输入处理 | 5分钟 |
| 综合测试 | 3 | 全模块、组合功能测试 | 15-30分钟 |
| 快速响应测试 | 3 | 内存、并发、快速响应 | 10-15分钟 |

## 测试结果分析

### 1. 成功率评估

| 成功率范围 | 评级 | 说明 | 建议操作 |
|------------|------|------|----------|
| 95-100% | 优秀 | 脚本功能完全正常 | 可以部署到生产环境 |
| 85-94% | 良好 | 大部分功能正常 | 修复失败项后部署 |
| 70-84% | 一般 | 存在一些问题 | 需要重点检查和修复 |
| 50-69% | 较差 | 问题较多 | 全面检查，不建议部署 |
| <50% | 很差 | 严重问题 | 需要大幅修改 |

### 2. 常见问题类型

#### 🔴 高优先级问题
- 脚本语法错误
- 权限问题
- 核心功能失效
- 安全检查失败

#### 🟡 中优先级问题
- 某些命令缺失
- 网络连接问题
- 性能问题
- 兼容性问题

#### 🟢 低优先级问题
- 输出格式问题
- 非关键功能失效
- 警告信息

### 3. 问题修复流程

```bash
# 1. 查看详细错误信息
cat test_logs_*/test_execution.log | grep -i error

# 2. 分析具体失败的测试用例
grep -r "FAIL" test_logs_*/

# 3. 查看修复建议
cat test_result_analysis_guide.md

# 4. 应用修复方案
# （根据具体问题执行相应的修复操作）

# 5. 重新测试验证
sudo ./centos7_quick_test.sh
```

## 环境准备脚本

### 自动环境准备

```bash
#!/bin/bash
# prepare_test_environment.sh

echo "准备 CentOS 7 测试环境..."

# 更新系统
sudo yum update -y

# 安装必要工具
sudo yum install -y \
    net-tools psmisc lsof strace tcpdump nmap \
    wget curl unzip tar gzip bind-utils telnet nc \
    htop iotop iftop sysstat dstat \
    policycoreutils-python selinux-policy-devel

# 启动服务
sudo systemctl start sshd crond rsyslog
sudo systemctl enable sshd crond rsyslog

# 安装 HTTP 服务
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# 创建测试用户
sudo useradd -m testuser
echo "testuser:TestPass123!" | sudo chpasswd
sudo useradd -m adminuser
echo "adminuser:AdminPass123!" | sudo chpasswd
sudo usermod -aG wheel adminuser

# 创建测试数据
sudo mkdir -p /tmp/test_data
sudo touch /tmp/test_data/test.txt
echo "测试数据" | sudo tee /tmp/test_data/test.txt

echo "环境准备完成！"
echo "现在可以运行测试：sudo ./centos7_quick_test.sh"
```

## CI/CD 集成

### Jenkins 集成示例

```groovy
pipeline {
    agent {
        docker {
            image 'centos:7'
            args '--privileged'
        }
    }
    
    stages {
        stage('环境准备') {
            steps {
                sh '''
                    yum update -y
                    yum install -y net-tools psmisc lsof
                    systemctl start sshd
                '''
            }
        }
        
        stage('快速测试') {
            steps {
                sh '''
                    chmod +x centos7_quick_test.sh
                    ./centos7_quick_test.sh
                '''
            }
        }
        
        stage('完整测试') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    chmod +x centos7_test_suite.sh
                    ./centos7_test_suite.sh --basic --system
                '''
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'test_logs_*/**', allowEmptyArchive: true
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'test_logs_*',
                reportFiles: '*.md',
                reportName: 'LinuxGun Test Report'
            ])
        }
        
        failure {
            emailext (
                subject: "LinuxGun 测试失败: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "测试失败，请查看详细报告: ${env.BUILD_URL}",
                to: "admin@example.com"
            )
        }
    }
}
```

### GitHub Actions 集成示例

```yaml
name: LinuxGun CentOS 7 Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: centos:7
      options: --privileged
    
    steps:
    - uses: actions/checkout@v2
    
    - name: 准备环境
      run: |
        yum update -y
        yum install -y net-tools psmisc lsof systemd
        systemctl start sshd
    
    - name: 运行快速测试
      run: |
        chmod +x centos7_quick_test.sh
        ./centos7_quick_test.sh
    
    - name: 运行核心模块测试
      run: |
        chmod +x centos7_test_suite.sh
        ./centos7_test_suite.sh --basic --system
    
    - name: 上传测试报告
      uses: actions/upload-artifact@v2
      if: always()
      with:
        name: test-reports
        path: |
          test_logs_*/
          quick_test_*.log
```

## 故障排除

### 常见问题快速解决

#### 1. 权限问题
```bash
# 问题：Permission denied
# 解决：
sudo chmod +x *.sh
sudo chown root:root linuxGun-dev.sh
```

#### 2. 命令缺失
```bash
# 问题：command not found
# 解决：
sudo yum install -y net-tools psmisc lsof
```

#### 3. 网络问题
```bash
# 问题：网络连接失败
# 解决：
sudo systemctl restart network
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
```

#### 4. 磁盘空间不足
```bash
# 问题：No space left on device
# 解决：
sudo rm -rf /tmp/*report*.tar.gz
sudo journalctl --vacuum-time=7d
```

#### 5. SELinux 问题
```bash
# 问题：SELinux 阻止操作
# 解决：
sudo setenforce 0  # 临时禁用
# 或者
sudo setsebool -P httpd_can_network_connect 1
```

## 最佳实践

### 1. 测试前准备
- ✅ 在隔离环境中测试
- ✅ 备份重要数据
- ✅ 准备回滚方案
- ✅ 检查系统资源

### 2. 测试执行
- ✅ 先运行快速测试
- ✅ 逐步执行完整测试
- ✅ 监控系统状态
- ✅ 及时保存日志

### 3. 结果分析
- ✅ 重点关注失败用例
- ✅ 分析性能指标
- ✅ 记录问题和解决方案
- ✅ 更新测试用例

### 4. 持续改进
- ✅ 定期更新测试工具
- ✅ 优化测试流程
- ✅ 分享经验教训
- ✅ 建立知识库

## 技术支持

### 文档资源
- 📖 [详细测试方案](centos7_test_plan.md)
- 📋 [执行指南](centos7_test_guide.md)
- 🔍 [结果分析指南](test_result_analysis_guide.md)

### 日志分析
```bash
# 查看所有测试日志
find . -name "*.log" -exec echo "=== {} ===" \; -exec cat {} \;

# 搜索错误信息
grep -r -i "error\|fail\|exception" test_logs_*/

# 分析性能数据
grep -r "耗时\|duration" test_logs_*/
```

### 问题报告
如果遇到问题，请提供以下信息：
1. 系统环境信息（`uname -a`, `cat /etc/redhat-release`）
2. 完整的错误信息
3. 测试日志文件
4. 重现步骤

---

## 版本历史

- **v1.0** (2024-01-15)
  - 初始版本
  - 包含快速测试和完整测试套件
  - 支持 CentOS 7 环境
  - 提供详细的测试报告和分析工具

---

**注意**: 本测试工具包专门针对 CentOS 7 环境设计，在其他 Linux 发行版上可能需要适当调整。建议在生产环境部署前，先在测试环境中充分验证。