# blockIP.sh Bug修复报告

## 问题描述

在运行 `blockIP.sh` 脚本时，firewall相关的操作失败，错误信息如下：

```
usage: see firewall-cmd man page
firewall-cmd: error: unrecognized arguments: family=ipv4 source address=10.0.0.50 drop'
[ERROR] 使用firewall封禁IP失败: 10.0.0.50
```

## 根本原因

问题出现在 `firewall-cmd` 命令的参数传递中。脚本中使用了单引号包围 `rich-rule` 参数，但在命令执行时，这些单引号被当作了命令参数的一部分，导致 `firewall-cmd` 无法正确解析。

### 错误的命令格式：
```bash
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=$ip drop'
```

### 正确的命令格式：
```bash
firewall-cmd --permanent --add-rich-rule="rule family=ipv4 source address=$ip drop"
```

## 修复内容

### 1. 修复 firewall_block_ip 函数

**文件**: `blockIP.sh` 第220行

**修改前**:
```bash
local cmd="firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=$ip drop'"
```

**修改后**:
```bash
local cmd="firewall-cmd --permanent --add-rich-rule=\"rule family=ipv4 source address=$ip drop\""
```

### 2. 修复 firewall_unblock_ip 函数

**文件**: `blockIP.sh` 第252行

**修改前**:
```bash
local cmd="firewall-cmd --permanent --remove-rich-rule='rule family=ipv4 source address=$ip drop'"
```

**修改后**:
```bash
local cmd="firewall-cmd --permanent --remove-rich-rule=\"rule family=ipv4 source address=$ip drop\""
```

### 3. 修复 IP 封禁状态检查

**文件**: `blockIP.sh` 第232, 262, 446, 462行

**修改前**:
```bash
firewall-cmd --list-rich-rules | grep -q "source address=\\\"$ip\\\""
```

**修改后**:
```bash
firewall-cmd --list-rich-rules | grep -q "source address=$ip"
```

### 4. 同步修复测试脚本

**文件**: `test_blockIP.sh` 第117-119行

**修改前**:
```bash
firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="$TEST_IP" drop'
```

**修改后**:
```bash
firewall-cmd --permanent --remove-rich-rule="rule family=ipv4 source address=$TEST_IP drop"
```

更新了清理函数中的 firewall-cmd 命令格式，使其与修复后的 `blockIP.sh` 保持一致。

## 技术说明

问题的根本原因是在 Bash 脚本中，当命令字符串包含单引号时，这些单引号会被当作命令参数的一部分传递给 `firewall-cmd`，导致命令解析失败。

修复方法是将命令字符串中的单引号改为转义的双引号，确保 `rich-rule` 参数能够正确传递给 `firewall-cmd`。

正确的命令构建方式：
```bash
local cmd="firewall-cmd --permanent --add-rich-rule=\"rule family=ipv4 source address=$ip drop\""
```

### Shell 转义说明

在 Bash 脚本中，当需要在双引号字符串中包含双引号时，需要使用反斜杠进行转义：
- `\"` 在双引号字符串中表示转义的双引号
- 命令执行时，转义的双引号会被正确传递给 `firewall-cmd`

修复后的命令格式确保了 `rich-rule` 参数能够被 `firewall-cmd` 正确解析。

## 验证方法

修复完成后，可以通过以下方式验证：

1. **预览模式测试**:
   ```bash
   sudo ./blockIP.sh --show-run -t firewall 192.168.1.100
   ```

2. **运行完整测试**:
   ```bash
   sudo ./test_blockIP.sh
   ```

3. **手动验证语法**:
   ```bash
   # 测试封禁命令语法
   firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.100" drop' --dry-run
   ```

## 影响范围

此修复影响所有使用 firewall-cmd 进行 IP 封禁的功能：
- 单个 IP 封禁/解封
- 批量 IP 处理
- IP 封禁状态检查
- 自动检测工具功能

## 兼容性

修复后的语法与以下版本兼容：
- firewalld 0.6.0+
- CentOS/RHEL 7+
- Fedora 28+
- Ubuntu 18.04+ (如果安装了 firewalld)

修复不会影响 iptables 相关功能的正常使用。
