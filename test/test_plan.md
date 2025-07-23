# LinuxGun-dev.sh 测试计划

## 测试概述

本文档提供了对 LinuxGun-dev.sh 脚本的全面测试方法，涵盖所有功能模块的测试用例和验证步骤。

## 测试环境要求

### 基础环境
- **操作系统**: Linux 发行版 (CentOS/Ubuntu/RHEL/Debian)
- **权限要求**: root 用户权限
- **Bash 版本**: 3.2+ (推荐 4.0+)
- **磁盘空间**: 至少 500MB 可用空间

### 可选环境
- **Kubernetes 集群**: 用于测试 k8s 相关功能
- **网络连接**: 用于测试文件传输功能
- **防火墙工具**: iptables 或 firewalld

## 测试分类

### 1. 基础功能测试

#### 1.1 脚本初始化测试
```bash
# 测试用例 1.1.1: 检查脚本语法
bash -n linuxGun-dev.sh

# 测试用例 1.1.2: 检查权限要求
# 以非root用户运行，应该提示权限错误
sudo -u nobody bash linuxGun-dev.sh --help

# 测试用例 1.1.3: 检查帮助信息
bash linuxGun-dev.sh --help
bash linuxGun-dev.sh -h

# 测试用例 1.1.4: 检查版本信息和大纲
bash linuxGun-dev.sh --show
```

**预期结果**:
- 语法检查无错误
- 非root用户运行时显示权限警告
- 帮助信息完整显示
- 大纲信息正确显示

#### 1.2 环境初始化测试
```bash
# 测试用例 1.2.1: 检查输出目录创建
bash linuxGun-dev.sh --system-baseinfo

# 验证目录结构
ls -la output/
ls -la output/linuxgun_*/
ls -la output/linuxgun_*/check_file/
ls -la output/linuxgun_*/check_file/log/
```

**预期结果**:
- 自动创建 output 目录
- 创建带时间戳和IP的子目录
- 创建 check_file 和 log 子目录
- 初始化日志文件

### 2. 系统信息检查模块测试

#### 2.1 基础信息检查
```bash
# 测试用例 2.1.1: 系统基础信息
bash linuxGun-dev.sh --system-baseinfo

# 测试用例 2.1.2: 用户信息分析
bash linuxGun-dev.sh --system-user

# 测试用例 2.1.3: 计划任务检查
bash linuxGun-dev.sh --system-crontab

# 测试用例 2.1.4: 历史命令分析
bash linuxGun-dev.sh --system-history

# 测试用例 2.1.5: 系统模块全量检查
bash linuxGun-dev.sh --system
```

**验证要点**:
- IP地址信息获取正确
- 系统版本和发行版信息准确
- 用户账户分析完整
- 计划任务检查覆盖系统和用户级
- 历史命令分析包含敏感操作检测

### 3. 网络连接检查模块测试

#### 3.1 网络信息检查
```bash
# 测试用例 3.1.1: 网络连接分析
bash linuxGun-dev.sh --network

# 手动验证网络状态
ss -tuln
netstat -tuln
arp -a
```

**验证要点**:
- ARP表信息获取
- 网络连接状态分析
- 高危端口检测
- DNS配置检查
- 防火墙策略分析

### 4. 进程检查模块测试

#### 4.1 进程信息分析
```bash
# 测试用例 4.1.1: 进程信息检查
bash linuxGun-dev.sh --psinfo

# 手动验证进程状态
ps aux
top -n 1
```

**验证要点**:
- ps 进程列表完整
- top 进程分析准确
- 敏感进程匹配规则有效
- 异常进程检测功能

### 5. 文件系统检查模块测试

#### 5.1 文件系统全面检查
```bash
# 测试用例 5.1.1: 文件系统全量检查
bash linuxGun-dev.sh --file

# 测试用例 5.1.2: 系统服务检查
bash linuxGun-dev.sh --file-systemservice

# 测试用例 5.1.3: 敏感目录检查
bash linuxGun-dev.sh --file-dir

# 测试用例 5.1.4: 关键文件检查
bash linuxGun-dev.sh --file-keyfiles

# 测试用例 5.1.5: 系统日志检查
bash linuxGun-dev.sh --file-systemlog
```

**验证要点**:
- 系统服务状态检查
- /tmp 和 /root 目录扫描
- SSH配置文件分析
- 系统日志文件解析
- 文件权限和属性检查

### 6. 安全检查模块测试

#### 6.1 后门和隧道检测
```bash
# 测试用例 6.1.1: 后门检测
bash linuxGun-dev.sh --backdoor

# 测试用例 6.1.2: 隧道检测
bash linuxGun-dev.sh --tunnel

# 测试用例 6.1.3: SSH隧道专项检测
bash linuxGun-dev.sh --tunnel-ssh

# 测试用例 6.1.4: 黑客工具检测
bash linuxGun-dev.sh --hackerTools
```

**验证要点**:
- SUID/SGID文件检查
- SSH隧道特征识别
- 黑客工具规则匹配
- 异常连接检测

### 7. Kubernetes 检查模块测试

#### 7.1 K8s 环境检查 (需要K8s环境)
```bash
# 测试用例 7.1.1: K8s全量检查
bash linuxGun-dev.sh --k8s

# 测试用例 7.1.2: 集群信息检查
bash linuxGun-dev.sh --k8s-cluster

# 测试用例 7.1.3: 凭据信息检查
bash linuxGun-dev.sh --k8s-secret

# 测试用例 7.1.4: 敏感文件扫描
bash linuxGun-dev.sh --k8s-fscan

# 测试用例 7.1.5: 基线检查
bash linuxGun-dev.sh --k8s-baseline
```

**验证要点**:
- K8s环境自动识别
- 集群配置信息收集
- Secret和ConfigMap分析
- 敏感文件备份功能

### 8. 基线检查模块测试

#### 8.1 安全基线检查
```bash
# 测试用例 8.1.1: 全量基线检查
bash linuxGun-dev.sh --baseline

# 测试用例 8.1.2: 防火墙策略检查
bash linuxGun-dev.sh --baseline-firewall

# 测试用例 8.1.3: SELinux策略检查
bash linuxGun-dev.sh --baseline-selinux
```

**验证要点**:
- 账户管理策略检查
- 密码策略验证
- 文件权限检查
- 网络配置验证

### 9. 性能和其他模块测试

#### 9.1 性能评估
```bash
# 测试用例 9.1.1: 系统性能评估
bash linuxGun-dev.sh --performance

# 测试用例 9.1.2: 其他安全检查
bash linuxGun-dev.sh --other

# 测试用例 9.1.3: 内核检查
bash linuxGun-dev.sh --kernel
```

**验证要点**:
- 磁盘使用情况
- CPU和内存状态
- 系统负载分析
- 内核模块检查

### 10. 交互模式测试

#### 10.1 交互式执行
```bash
# 测试用例 10.1.1: 交互模式全量检查
bash linuxGun-dev.sh --all --inter

# 测试用例 10.1.2: 交互模式部分检查
bash linuxGun-dev.sh --system --network --inter
```

**验证要点**:
- 每个模块执行前的用户确认
- 用户输入验证
- 跳过模块的处理

### 11. 文件传输功能测试

#### 11.1 文件发送测试 (需要接收服务器)
```bash
# 启动接收服务器 (在另一台机器或容器中)
cd tools/uploadServer
python3 uploadServer.py 0.0.0.0 8080 test_token_123

# 测试用例 11.1.1: 发送检查结果
bash linuxGun-dev.sh --all
bash linuxGun-dev.sh --send 192.168.1.100 8080 test_token_123

# 测试用例 11.1.2: 发送指定文件
bash linuxGun-dev.sh --send 192.168.1.100 8080 test_token_123 /path/to/file.tar.gz
```

**验证要点**:
- 文件压缩打包功能
- 网络传输成功
- 认证token验证
- 错误处理机制

### 12. 全量测试

#### 12.1 完整功能测试
```bash
# 测试用例 12.1.1: 全量非交互检查
bash linuxGun-dev.sh --all

# 测试用例 12.1.2: 全量交互检查
bash linuxGun-dev.sh --all --inter
```

**验证要点**:
- 所有模块正常执行
- 日志记录完整
- 输出文件生成
- 性能统计准确

## 测试验证方法

### 1. 输出文件验证
```bash
# 检查输出目录结构
find output/ -type f -name "*.txt" -o -name "*.log" | head -20

# 检查主要结果文件
cat output/linuxgun_*/check_file/checkresult.txt | head -50

# 检查日志文件
cat output/linuxgun_*/check_file/log/message.log
cat output/linuxgun_*/check_file/log/operations.log
cat output/linuxgun_*/check_file/log/performance.log
```

### 2. 错误处理验证
```bash
# 测试无效参数
bash linuxGun-dev.sh --invalid-option

# 测试参数组合冲突
bash linuxGun-dev.sh --send 127.0.0.1 8080 token --all

# 测试权限不足场景
sudo -u nobody bash linuxGun-dev.sh --system
```

### 3. 性能测试验证
```bash
# 检查执行时间记录
grep "执行时间" output/linuxgun_*/check_file/log/performance.log

# 检查内存使用情况
ps aux | grep linuxGun-dev.sh
```

## 测试结果评估标准

### 成功标准
1. **功能完整性**: 所有模块能够正常执行
2. **输出准确性**: 检查结果与手动验证一致
3. **错误处理**: 异常情况下能够优雅处理
4. **日志完整性**: 操作日志和错误日志记录完整
5. **性能合理性**: 执行时间在可接受范围内

### 失败标准
1. **脚本语法错误**: bash -n 检查失败
2. **权限检查失败**: 非root用户能够执行敏感操作
3. **模块执行失败**: 任何模块执行时出现致命错误
4. **输出文件缺失**: 应该生成的文件未创建
5. **日志记录缺失**: 关键操作未记录日志

## 测试执行建议

### 测试顺序
1. 先执行基础功能测试
2. 再执行各个模块的单独测试
3. 最后执行全量测试和集成测试

### 测试环境
1. **开发环境**: 用于基础功能测试
2. **测试环境**: 用于完整功能验证
3. **生产环境**: 用于最终验证 (谨慎执行)

### 测试数据准备
1. 准备测试用的配置文件
2. 创建测试用户和组
3. 设置测试用的计划任务
4. 准备测试用的网络连接

## 常见问题排查

### 1. 权限问题
```bash
# 检查脚本权限
ls -la linuxGun-dev.sh
chmod +x linuxGun-dev.sh

# 检查当前用户
whoami
id
```

### 2. 依赖工具缺失
```bash
# 检查必要工具
which ip || which ifconfig
which ps
which netstat || which ss
```

### 3. 磁盘空间不足
```bash
# 检查磁盘空间
df -h .
du -sh output/
```

### 4. 日志分析
```bash
# 查看错误日志
grep "ERROR" output/linuxgun_*/check_file/log/message.log
grep "WARN" output/linuxgun_*/check_file/log/message.log
```

## 测试报告模板

### 测试执行记录
- **测试时间**: 
- **测试环境**: 
- **测试版本**: 
- **执行用户**: 

### 测试结果汇总
- **通过的测试用例**: 
- **失败的测试用例**: 
- **跳过的测试用例**: 
- **发现的问题**: 

### 性能统计
- **总执行时间**: 
- **各模块执行时间**: 
- **生成文件大小**: 
- **内存使用峰值**: 

### 建议和改进
- **功能改进建议**: 
- **性能优化建议**: 
- **用户体验改进**: 
- **文档完善建议**: 

---

**注意**: 本测试计划应该根据实际环境和需求进行调整，某些测试用例可能需要特定的环境配置才能执行。