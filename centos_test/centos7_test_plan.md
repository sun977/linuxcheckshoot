# LinuxGun-dev.sh CentOS 7 环境测试方案

## 1. 测试环境准备

### 1.1 系统要求
- **操作系统**: CentOS 7.x (推荐 7.9)
- **内核版本**: 3.10.x
- **内存**: 最少 2GB
- **磁盘空间**: 最少 10GB
- **网络**: 能够访问互联网（用于某些网络检查功能）

### 1.2 必要软件包安装
```bash
# 更新系统
sudo yum update -y

# 安装必要的工具包
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
    find \
    grep \
    awk \
    sed \
    ss \
    netstat \
    iptables \
    systemd \
    crontab \
    rsyslog

# 安装开发工具（如果需要编译某些工具）
sudo yum groupinstall -y "Development Tools"

# 确保 SELinux 工具可用
sudo yum install -y policycoreutils-python selinux-policy-devel
```

### 1.3 测试用户准备
```bash
# 创建测试用户
sudo useradd -m testuser
sudo echo "testuser:testpass123" | chpasswd

# 创建具有 sudo 权限的测试用户
sudo useradd -m adminuser
sudo echo "adminuser:adminpass123" | chpasswd
sudo usermod -aG wheel adminuser

# 创建系统服务用户
sudo useradd -r -s /sbin/nologin serviceuser
```

### 1.4 测试环境模拟
```bash
# 启动一些测试服务
sudo systemctl start httpd 2>/dev/null || sudo yum install -y httpd && sudo systemctl start httpd
sudo systemctl start sshd
sudo systemctl start crond

# 创建测试文件和目录
sudo mkdir -p /tmp/test_files
sudo touch /tmp/test_files/test.txt
sudo chmod 777 /tmp/test_files/test.txt

# 创建一些测试进程
nohup sleep 3600 &
nohup python -m SimpleHTTPServer 8888 &
```

## 2. 测试模块分类

### 2.1 核心功能测试
- 脚本基础功能（帮助、版本、语法检查）
- 参数解析和模块映射
- 日志记录和输出格式
- 错误处理机制

### 2.2 系统信息检查模块
- **system**: 系统基础信息收集
- **system-baseinfo**: 系统基础信息详细检查
- **system-user**: 用户和权限检查

### 2.3 网络安全检查模块
- **network**: 网络配置和连接检查
- **tunnel-ssh**: SSH 隧道和配置检查

### 2.4 进程和服务检查模块
- **psinfo**: 进程信息收集和分析
- **file-systemservice**: 文件系统和系统服务检查

### 2.5 容器和集群检查模块
- **k8s**: Kubernetes 基础检查
- **k8s-cluster**: Kubernetes 集群详细检查

### 2.6 安全检查模块
- **webshell**: Web shell 检测
- **virus**: 病毒和恶意软件检测
- **rootkit**: Rootkit 检测

### 2.7 基线检查模块
- **baseline**: 安全基线检查
- **compliance**: 合规性检查

## 3. 自动化测试脚本设计

### 3.1 测试脚本架构
```
centos7_test_suite/
├── run_tests.sh              # 主测试执行脚本
├── config/
│   ├── test_config.conf      # 测试配置文件
│   └── expected_results.json # 预期结果配置
├── modules/
│   ├── basic_tests.sh        # 基础功能测试
│   ├── system_tests.sh       # 系统模块测试
│   ├── network_tests.sh      # 网络模块测试
│   ├── security_tests.sh     # 安全模块测试
│   └── performance_tests.sh  # 性能测试
├── utils/
│   ├── test_utils.sh         # 测试工具函数
│   ├── result_parser.sh      # 结果解析工具
│   └── report_generator.sh   # 报告生成工具
└── reports/
    ├── test_results.json     # 测试结果 JSON
    ├── test_report.html      # HTML 测试报告
    └── test_logs/            # 详细测试日志
```

## 4. 详细测试用例

### 4.1 基础功能测试用例
```bash
# TC001: 脚本语法检查
bash -n linuxGun-dev.sh

# TC002: 帮助信息显示
bash linuxGun-dev.sh --help

# TC003: 版本信息显示
bash linuxGun-dev.sh --version

# TC004: 大纲信息显示
bash linuxGun-dev.sh --show

# TC005: 无效参数处理
bash linuxGun-dev.sh --invalid-param

# TC006: 权限检查（非 root 用户）
su - testuser -c "bash linuxGun-dev.sh --system"
```

### 4.2 系统模块测试用例
```bash
# TC101: 系统基础信息检查
sudo bash linuxGun-dev.sh --system

# TC102: 系统详细信息检查
sudo bash linuxGun-dev.sh --system-baseinfo

# TC103: 用户权限检查
sudo bash linuxGun-dev.sh --system-user

# TC104: 系统完整性检查
sudo bash linuxGun-dev.sh --system --send /tmp/system_report.tar.gz
```

### 4.3 网络模块测试用例
```bash
# TC201: 网络配置检查
sudo bash linuxGun-dev.sh --network

# TC202: SSH 配置检查
sudo bash linuxGun-dev.sh --tunnel-ssh

# TC203: 网络连接分析
sudo bash linuxGun-dev.sh --network --send /tmp/network_report.tar.gz
```

### 4.4 进程和服务测试用例
```bash
# TC301: 进程信息收集
sudo bash linuxGun-dev.sh --psinfo

# TC302: 系统服务检查
sudo bash linuxGun-dev.sh --file-systemservice

# TC303: 危险进程检测
sudo bash linuxGun-dev.sh --psinfo --send /tmp/process_report.tar.gz
```

### 4.5 安全检查测试用例
```bash
# TC401: Web shell 检测
sudo bash linuxGun-dev.sh --webshell

# TC402: 病毒检测
sudo bash linuxGun-dev.sh --virus

# TC403: Rootkit 检测
sudo bash linuxGun-dev.sh --rootkit

# TC404: 综合安全检查
sudo bash linuxGun-dev.sh --webshell --virus --rootkit
```

### 4.6 容器和集群测试用例
```bash
# TC501: Kubernetes 基础检查
sudo bash linuxGun-dev.sh --k8s

# TC502: Kubernetes 集群检查
sudo bash linuxGun-dev.sh --k8s-cluster

# TC503: 容器安全检查（如果有 Docker）
sudo bash linuxGun-dev.sh --k8s --send /tmp/k8s_report.tar.gz
```

### 4.7 交互模式测试用例
```bash
# TC601: 交互模式基础测试
echo -e "1\ny\nq" | sudo bash linuxGun-dev.sh --inter

# TC602: 交互模式模块选择
echo -e "2\n1\ny\nq" | sudo bash linuxGun-dev.sh --inter

# TC603: 交互模式退出测试
echo "q" | sudo bash linuxGun-dev.sh --inter
```

### 4.8 综合测试用例
```bash
# TC701: 全模块检查
sudo bash linuxGun-dev.sh --all

# TC702: 多模块组合检查
sudo bash linuxGun-dev.sh --system --network --psinfo

# TC703: 全模块检查并发送报告
sudo bash linuxGun-dev.sh --all --send /tmp/full_report.tar.gz
```

## 5. 性能和压力测试

### 5.1 性能测试指标
- 脚本执行时间
- 内存使用情况
- CPU 使用率
- 磁盘 I/O 性能
- 网络带宽使用

### 5.2 压力测试场景
```bash
# 并发执行测试
for i in {1..3}; do
    sudo bash linuxGun-dev.sh --system &
done
wait

# 快速响应测试（限制执行时间在5分钟内）
timeout 300 sudo bash linuxGun-dev.sh --all

# 大文件系统测试
sudo bash linuxGun-dev.sh --file-systemservice
```

## 6. 测试结果验证

### 6.1 输出格式验证
- 日志格式正确性
- JSON 输出格式验证
- 报告文件完整性
- 压缩包结构验证

### 6.2 功能正确性验证
- 系统信息准确性
- 网络配置正确性
- 进程信息完整性
- 安全检查有效性

### 6.3 错误处理验证
- 异常情况处理
- 错误信息准确性
- 恢复机制有效性

## 7. 测试报告要求

### 7.1 测试报告内容
1. **执行摘要**
   - 测试环境信息
   - 测试执行时间
   - 总体测试结果

2. **详细测试结果**
   - 每个测试用例的执行结果
   - 失败用例的详细错误信息
   - 性能测试数据

3. **问题分析**
   - 发现的 Bug 列表
   - 性能瓶颈分析
   - 兼容性问题

4. **改进建议**
   - 代码优化建议
   - 功能增强建议
   - 文档改进建议

### 7.2 测试数据收集
```bash
# 收集系统信息
uname -a > test_env_info.txt
cat /etc/redhat-release >> test_env_info.txt
free -h >> test_env_info.txt
df -h >> test_env_info.txt

# 收集测试执行日志
tail -f /var/log/messages &
sudo bash linuxGun-dev.sh --all 2>&1 | tee test_execution.log

# 收集性能数据
top -b -n 1 > performance_snapshot.txt
ps aux > process_snapshot.txt
netstat -tuln > network_snapshot.txt
```

## 8. 测试执行计划

### 8.1 测试阶段
1. **第一阶段**: 基础功能测试（15-30 分钟）
2. **第二阶段**: 核心模块测试（30-60 分钟）
3. **第三阶段**: 安全功能测试（30-45 分钟）
4. **第四阶段**: 快速响应测试（15-30 分钟）
5. **第五阶段**: 综合测试和报告生成（15 分钟）

### 8.2 测试人员要求
- 熟悉 Linux 系统管理
- 了解网络安全基础
- 具备 Shell 脚本调试能力
- 能够分析系统日志

### 8.3 测试环境隔离
- 使用虚拟机或容器进行测试
- 确保测试不影响生产环境
- 准备测试数据备份和恢复方案

## 9. 风险控制

### 9.1 测试风险
- 脚本可能影响系统稳定性
- 某些检查可能触发安全告警
- 大量日志可能占用磁盘空间

### 9.2 风险缓解措施
- 在隔离环境中进行测试
- 监控系统资源使用情况
- 定期清理测试产生的临时文件
- 准备系统快照和回滚方案

## 10. 测试完成标准

### 10.1 通过标准
- 所有核心功能测试用例通过率 ≥ 95%
- 无严重安全漏洞或系统稳定性问题
- 性能指标满足预期要求
- 错误处理机制正常工作

### 10.2 交付物
- 完整的测试报告
- 测试用例执行记录
- 发现问题的详细分析
- 代码修改建议和补丁

---

**注意**: 本测试方案需要在 CentOS 7 环境下执行，确保所有依赖软件已正确安装，并具备相应的系统管理权限。测试过程中请密切监控系统状态，如发现异常情况请及时停止测试并分析原因。