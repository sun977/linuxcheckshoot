# blockIP.sh Bug修复报告

## 问题描述

在运行 `test_blockIP.sh` 测试时，firewall相关的测试全部失败，错误信息如下：

```
usage: see firewall-cmd man page
firewall-cmd: error: unrecognized arguments: family=ipv4 source address=10.0.0.100 drop'
[ERROR] 使用firewall封禁IP失败: 10.0.0.100
```

## 根本原因

`blockIP.sh` 脚本中使用的 `firewall-cmd` rich-rule 语法不正确。

### 错误的语法格式：
```bash
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=$ip drop'
```

### 正确的语法格式：
```bash
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="$ip" drop'
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
local cmd="firewall-cmd --permanent --add-rich-rule='rule family=\"ipv4\" source address=\"$ip\" drop'"
```

### 2. 修复 firewall_unblock_ip 函数

**文件**: `blockIP.sh` 第252行

**修改前**:
```bash
local cmd="firewall-cmd --permanent --remove-rich-rule='rule family=ipv4 source address=$ip drop'"
```

**修改后**:
```bash
local cmd="firewall-cmd --permanent --remove-rich-rule='rule family=\"ipv4\" source address=\"$ip\" drop'"
```

### 3. 修复 IP 封禁状态检查

**文件**: `blockIP.sh` 第232, 262, 446, 462行

**修改前**:
```bash
firewall-cmd --list-rich-rules | grep -q "source address=\"$ip\""
```

**修改后**:
```bash
firewall-cmd --list-rich-rules | grep -q "source address=\\\"$ip\\\""
```

### 4. 同步修复测试脚本

**文件**: `test_blockIP.sh` 第118-120行

更新了清理函数中的 firewall-cmd 命令格式，使其与修复后的 `blockIP.sh` 保持一致。

## 技术说明

### firewall-cmd rich-rule 语法要求

1. **family 参数**: 必须用双引号包围，如 `family="ipv4"`
2. **source address 参数**: IP地址必须用双引号包围，如 `source address="192.168.1.100"`
3. **完整格式**: `rule family="ipv4" source address="IP地址" drop`

### Shell 转义说明

在 bash 脚本中，由于需要在字符串中包含双引号，需要进行适当的转义：
- 在命令字符串中：`\"` 表示一个双引号字符
- 在 grep 模式中：`\\\"` 表示匹配双引号字符（需要额外转义）

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