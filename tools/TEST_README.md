# blockIP.sh 脚本测试指南

## 概述

本测试套件用于全面验证 `blockIP.sh` 脚本的所有功能，包括IP封禁/解封、批量处理、备份恢复、状态检查等核心功能。

## 测试文件说明

- `test_blockIP.sh` - 主测试脚本
- `blockIP.sh` - 被测试的目标脚本
- `example_ip_list.txt` - 示例IP列表文件

## 测试环境要求

### 系统要求
- Linux操作系统
- Root权限
- Bash shell

### 依赖工具
- `iptables` (通常预装)
- `firewalld` (可选，CentOS/RHEL/Fedora系统)
- `systemctl` (systemd系统)

## 快速开始

### 1. 上传文件到Linux服务器

```bash
# 将以下文件上传到Linux服务器的同一目录
- blockIP.sh
- test_blockIP.sh
- example_ip_list.txt
```

### 2. 设置执行权限

```bash
chmod +x blockIP.sh
chmod +x test_blockIP.sh
```

### 3. 运行完整测试

```bash
# 需要root权限
sudo ./test_blockIP.sh
```

## 测试模块详解

### 1. 基础功能测试
- 帮助信息显示
- 防火墙状态检查
- 脚本语法验证

### 2. 预览模式测试
- 所有操作的预览模式
- 命令显示但不执行
- 安全性验证

### 3. IP地址验证测试
- 有效IPv4地址
- 有效IPv6地址
- 无效IP格式处理
- 边界值测试

### 4. 单个IP操作测试
- iptables封禁/解封
- firewall封禁/解封
- 自动工具检测
- 重复操作处理

### 5. 批量处理测试
- 文件批量封禁
- 文件批量解封
- 注释行处理
- 无效IP跳过

### 6. 备份恢复功能测试
- 防火墙规则备份
- 备份文件恢复
- 自定义备份目录
- 备份文件完整性

### 7. 日志功能测试
- 默认日志记录
- 自定义日志文件
- 日志级别测试
- 日志格式验证

### 8. 错误处理测试
- 无效参数处理
- 缺少参数检测
- 权限不足处理
- 文件不存在处理

### 9. 性能测试
- 大量IP处理
- 内存使用测试
- 执行时间测试

### 10. 集成测试
- 完整工作流程
- 多功能组合
- 状态一致性

## 手动测试用例

如果自动测试脚本无法运行，可以手动执行以下关键测试：

### 基础功能测试

```bash
# 1. 显示帮助
./blockIP.sh --help

# 2. 显示防火墙状态
./blockIP.sh --status

# 3. 预览模式封禁IP
./blockIP.sh --show-run 192.168.1.100
```

### IP封禁测试

```bash
# 1. 封禁单个IP
sudo ./blockIP.sh 192.168.1.100

# 2. 检查IP状态
sudo ./blockIP.sh -c 192.168.1.100

# 3. 列出封禁IP
sudo ./blockIP.sh -l

# 4. 解封IP
sudo ./blockIP.sh -u 192.168.1.100
```

### 批量处理测试

```bash
# 1. 创建测试IP文件
cat > test_ips.txt << EOF
192.168.1.100
192.168.1.101
# 这是注释
10.0.0.100
EOF

# 2. 批量封禁
sudo ./blockIP.sh -f test_ips.txt

# 3. 批量解封
sudo ./blockIP.sh -f test_ips.txt -u
```

### 备份恢复测试

```bash
# 1. 备份当前规则
sudo ./blockIP.sh --backup

# 2. 查看备份文件
ls -la ./firewall_backup/

# 3. 恢复规则（使用实际的备份文件名）
sudo ./blockIP.sh --restore ./firewall_backup/firewall_backup_YYYYMMDD_HHMMSS.tar.gz
```

## 测试结果分析

### 成功标准
- 所有测试用例通过
- 无语法错误
- 功能按预期工作
- 错误处理正确

### 常见问题排查

1. **权限问题**
   ```bash
   # 确保以root权限运行
   sudo ./test_blockIP.sh
   ```

2. **防火墙服务未运行**
   ```bash
   # 启动iptables（如果需要）
   systemctl start iptables
   
   # 启动firewalld（如果需要）
   systemctl start firewalld
   ```

3. **工具未安装**
   ```bash
   # 安装iptables
   yum install iptables-services  # CentOS/RHEL
   apt install iptables          # Ubuntu/Debian
   
   # 安装firewalld
   yum install firewalld         # CentOS/RHEL
   apt install firewalld         # Ubuntu/Debian
   ```

## 测试报告

测试完成后会生成以下文件：
- `test_results.log` - 详细测试日志
- 控制台输出 - 实时测试结果

### 报告内容
- 总测试数量
- 通过测试数量
- 失败测试数量
- 详细错误信息

## 安全注意事项

1. **测试环境隔离**
   - 建议在测试环境运行
   - 避免在生产环境直接测试

2. **备份现有规则**
   ```bash
   # 测试前备份现有防火墙规则
   iptables-save > iptables_backup.rules
   firewall-cmd --list-all > firewall_backup.conf
   ```

3. **测试IP选择**
   - 使用私有IP地址段
   - 避免封禁重要服务IP
   - 确保测试IP不影响正常业务

## 故障恢复

如果测试过程中出现问题：

```bash
# 清理所有测试规则
iptables -F INPUT

# 或者恢复备份
iptables-restore < iptables_backup.rules

# firewalld重置
firewall-cmd --reload
```

## 联系支持

如果遇到问题或需要帮助：
1. 检查 `test_results.log` 详细日志
2. 确认系统环境符合要求
3. 验证权限和依赖工具

---

**注意**: 本测试套件仅用于验证脚本功能，请在安全的测试环境中运行。