# LinuxGun-dev.sh CentOS 7 测试执行指南

## 概述

本指南提供了在 CentOS 7 环境下测试 LinuxGun-dev.sh 脚本的详细步骤和方法。包含环境准备、测试执行、结果分析和问题修复等完整流程。

## 测试工具说明

### 1. 快速验证工具
- **文件名**: `centos7_quick_test.sh`
- **用途**: 快速验证核心功能（5-10分钟）
- **适用场景**: 初步检查、快速验证、CI/CD 集成

### 2. 完整测试套件
- **文件名**: `centos7_test_suite.sh`
- **用途**: 全面功能测试（1-2小时）
- **适用场景**: 详细测试、发布前验证、问题诊断

### 3. 测试方案文档
- **文件名**: `centos7_test_plan.md`
- **用途**: 详细的测试方案和用例设计
- **适用场景**: 测试规划、用例参考

## 环境准备

### 1. 系统要求

```bash
# 检查系统版本
cat /etc/redhat-release
# 应该显示: CentOS Linux release 7.x.xxxx (Core)

# 检查内核版本
uname -r
# 应该显示: 3.10.x-xxx.el7.x86_64

# 检查系统资源
free -h
df -h
```

### 2. 安装必要软件包

```bash
# 更新系统（可选，但建议）
sudo yum update -y

# 安装基础工具包
sudo yum install -y \
    net-tools \
    psmisc \
    lsof \
    strace \
    tcpdump \
    nmap \
    wget \
    curl \
    unzip \
    tar \
    gzip \
    bind-utils \
    telnet \
    nc

# 安装系统管理工具
sudo yum install -y \
    htop \
    iotop \
    iftop \
    sysstat \
    dstat

# 安装安全工具（可选）
sudo yum install -y \
    chkrootkit \
    rkhunter \
    clamav \
    clamav-update

# 确保 SELinux 工具可用
sudo yum install -y \
    policycoreutils-python \
    selinux-policy-devel \
    setroubleshoot-server
```

### 3. 服务配置

```bash
# 启动必要的系统服务
sudo systemctl start sshd
sudo systemctl start crond
sudo systemctl start rsyslog

# 检查服务状态
sudo systemctl status sshd crond rsyslog

# 启动 HTTP 服务（用于测试）
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```

### 4. 创建测试用户

```bash
# 创建普通测试用户
sudo useradd -m testuser
echo "testuser:TestPass123!" | sudo chpasswd

# 创建管理员测试用户
sudo useradd -m adminuser
echo "adminuser:AdminPass123!" | sudo chpasswd
sudo usermod -aG wheel adminuser

# 创建系统服务用户
sudo useradd -r -s /sbin/nologin serviceuser
```

### 5. 准备测试数据

```bash
# 创建测试目录和文件
sudo mkdir -p /tmp/test_data
sudo touch /tmp/test_data/test.txt
sudo chmod 777 /tmp/test_data/test.txt
echo "测试数据" | sudo tee /tmp/test_data/test.txt

# 创建一些测试进程（快速响应测试）
nohup sleep 300 &
nohup python -m SimpleHTTPServer 8888 &

# 创建测试日志文件
sudo touch /var/log/test.log
echo "$(date) 测试日志条目" | sudo tee -a /var/log/test.log
```

## 测试执行步骤

### 第一步：快速验证

```bash
# 进入脚本目录
cd /path/to/linuxgun3.1-releases

# 检查文件权限
ls -la *.sh

# 运行快速验证
sudo ./centos7_quick_test.sh

# 查看快速测试结果
echo "快速测试退出码: $?"
```

**预期结果**:
- 所有基础功能测试通过
- 核心模块能正常执行
- 成功率 ≥ 90%

### 第二步：完整功能测试

```bash
# 运行完整测试套件（推荐在 screen 或 tmux 中运行）
screen -S linuxgun_test
sudo ./centos7_test_suite.sh

# 或者运行特定模块测试
sudo ./centos7_test_suite.sh --basic
sudo ./centos7_test_suite.sh --system
sudo ./centos7_test_suite.sh --network
sudo ./centos7_test_suite.sh --security
```

**预期结果**:
- 基础功能测试 100% 通过
- 系统模块测试 ≥ 95% 通过
- 网络模块测试 ≥ 90% 通过
- 安全模块测试 ≥ 85% 通过

### 第三步：手动验证关键功能

```bash
# 1. 验证系统信息收集
sudo bash linuxGun-dev.sh --system-baseinfo
# 检查输出是否包含：IP地址、系统版本、启动时间等

# 2. 验证用户权限检查
sudo bash linuxGun-dev.sh --system-user
# 检查输出是否包含：用户列表、权限分析、特权用户等

# 3. 验证网络配置检查
sudo bash linuxGun-dev.sh --network
# 检查输出是否包含：网络接口、路由表、连接状态等

# 4. 验证进程信息收集
sudo bash linuxGun-dev.sh --psinfo
# 检查输出是否包含：进程列表、资源使用、危险进程等

# 5. 验证报告生成功能
sudo bash linuxGun-dev.sh --system --send /tmp/test_report.tar.gz
# 检查报告文件是否生成并包含正确内容
ls -la /tmp/test_report.tar.gz
tar -tzf /tmp/test_report.tar.gz
```

### 第四步：交互模式测试

```bash
# 启动交互模式
sudo bash linuxGun-dev.sh --inter

# 测试交互选项：
# 1 - 选择第一个选项
# 2 - 选择第二个选项
# q - 退出
# y/n - 确认选择
```

### 第五步：错误处理测试

```bash
# 测试无效参数
bash linuxGun-dev.sh --invalid-option

# 测试非 root 用户执行
su - testuser -c "bash linuxGun-dev.sh --system"

# 测试文件权限问题
chmod 644 linuxGun-dev.sh
bash linuxGun-dev.sh --help
chmod 755 linuxGun-dev.sh
```

## 结果分析

### 1. 测试日志分析

```bash
# 查看快速测试日志
cat quick_test_*.log

# 查看完整测试日志
ls -la test_logs_*/
cat test_logs_*/test_execution.log

# 查看测试报告
cat test_logs_*/centos7_test_report_*.md

# 查看 JSON 结果
cat test_logs_*/test_results_*.json | jq .
```

### 2. 性能分析

```bash
# 检查脚本执行时间
time sudo bash linuxGun-dev.sh --system

# 检查内存使用
(sudo bash linuxGun-dev.sh --system &) && sleep 5 && ps aux | grep linuxGun

# 检查磁盘使用
du -sh test_logs_*/
du -sh /tmp/*report*.tar.gz
```

### 3. 功能验证

```bash
# 验证系统信息准确性
sudo bash linuxGun-dev.sh --system-baseinfo | grep -E "IP地址|系统版本|启动时间"

# 验证网络信息准确性
sudo bash linuxGun-dev.sh --network | grep -E "网络接口|路由|端口"

# 验证进程信息准确性
sudo bash linuxGun-dev.sh --psinfo | grep -E "进程|PID|CPU"
```

## 常见问题和解决方案

### 1. 权限问题

**问题**: 提示需要 root 权限
```bash
# 解决方案
sudo su -
# 或者
sudo bash linuxGun-dev.sh [参数]
```

### 2. 命令未找到

**问题**: 某些命令不存在
```bash
# 检查缺失的命令
which netstat lsof ps grep awk sed

# 安装缺失的工具
sudo yum install -y net-tools lsof procps-ng
```

### 3. 网络连接问题

**问题**: 网络检查失败
```bash
# 检查网络连接
ping -c 3 8.8.8.8

# 检查 DNS 解析
nslookup google.com

# 检查防火墙设置
sudo iptables -L
sudo firewall-cmd --list-all
```

### 4. SELinux 问题

**问题**: SELinux 阻止某些操作
```bash
# 检查 SELinux 状态
getenforce

# 临时禁用 SELinux（仅用于测试）
sudo setenforce 0

# 查看 SELinux 日志
sudo tail -f /var/log/audit/audit.log | grep AVC
```

### 5. 磁盘空间不足

**问题**: 生成报告时磁盘空间不足
```bash
# 检查磁盘空间
df -h

# 清理临时文件
sudo rm -rf /tmp/*report*.tar.gz
sudo rm -rf test_logs_*/

# 清理系统日志（谨慎操作）
sudo journalctl --vacuum-time=7d
```

## 测试报告模板

### 基本信息
- **测试时间**: [填写测试执行时间]
- **测试环境**: [CentOS 版本、内核版本、硬件配置]
- **测试人员**: [测试人员姓名]
- **脚本版本**: [LinuxGun-dev.sh 版本]

### 测试结果摘要
- **总测试用例**: [数量]
- **通过用例**: [数量]
- **失败用例**: [数量]
- **跳过用例**: [数量]
- **成功率**: [百分比]

### 详细测试结果

#### 基础功能测试
- [ ] 脚本语法检查
- [ ] 帮助信息显示
- [ ] 参数解析
- [ ] 错误处理

#### 系统模块测试
- [ ] 系统信息收集
- [ ] 用户权限检查
- [ ] 系统配置分析

#### 网络模块测试
- [ ] 网络配置检查
- [ ] 连接状态分析
- [ ] SSH 配置检查

#### 安全模块测试
- [ ] 进程安全检查
- [ ] 文件权限检查
- [ ] 恶意软件检测

#### 性能测试
- **脚本启动时间**: [毫秒]
- **内存使用峰值**: [MB]
- **磁盘使用量**: [MB]
- **网络带宽使用**: [KB/s]

### 发现的问题

1. **问题描述**: [详细描述]
   - **严重程度**: [高/中/低]
   - **影响范围**: [功能模块]
   - **重现步骤**: [具体步骤]
   - **错误信息**: [错误日志]
   - **建议修复**: [修复建议]

### 改进建议

1. **功能改进**:
   - [具体建议]

2. **性能优化**:
   - [具体建议]

3. **兼容性改进**:
   - [具体建议]

### 测试结论

- **整体评价**: [优秀/良好/一般/需改进]
- **推荐使用**: [是/否]
- **注意事项**: [使用注意事项]

## 持续集成建议

### 1. 自动化测试脚本

```bash
#!/bin/bash
# CI 测试脚本示例

set -e

# 环境检查
if [[ ! -f /etc/redhat-release ]] || ! grep -q "CentOS Linux release 7" /etc/redhat-release; then
    echo "错误: 非 CentOS 7 环境"
    exit 1
fi

# 快速测试
echo "执行快速测试..."
if sudo ./centos7_quick_test.sh; then
    echo "快速测试通过"
else
    echo "快速测试失败"
    exit 1
fi

# 核心功能测试
echo "执行核心功能测试..."
if sudo ./centos7_test_suite.sh --basic --system; then
    echo "核心功能测试通过"
else
    echo "核心功能测试失败"
    exit 1
fi

echo "所有测试通过"
```

### 2. 测试环境容器化

```dockerfile
# Dockerfile 示例
FROM centos:7

# 安装必要软件包
RUN yum update -y && \
    yum install -y net-tools psmisc lsof strace tcpdump nmap wget curl unzip tar gzip && \
    yum clean all

# 复制测试脚本
COPY . /opt/linuxgun/
WORKDIR /opt/linuxgun/

# 设置执行权限
RUN chmod +x *.sh

# 默认执行快速测试
CMD ["./centos7_quick_test.sh"]
```

### 3. Jenkins 集成

```groovy
// Jenkinsfile 示例
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
                sh 'yum install -y net-tools psmisc lsof'
            }
        }
        
        stage('快速测试') {
            steps {
                sh 'chmod +x centos7_quick_test.sh'
                sh './centos7_quick_test.sh'
            }
        }
        
        stage('完整测试') {
            steps {
                sh 'chmod +x centos7_test_suite.sh'
                sh './centos7_test_suite.sh --basic --system'
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
    }
}
```

## 总结

本指南提供了在 CentOS 7 环境下全面测试 LinuxGun-dev.sh 脚本的完整方法。通过遵循这些步骤，您可以：

1. **快速验证**脚本的基本功能
2. **全面测试**所有模块和特性
3. **准确分析**测试结果和性能
4. **及时发现**和修复问题
5. **持续改进**脚本质量

建议在每次脚本更新后都执行完整的测试流程，确保脚本在生产环境中的稳定性和可靠性。