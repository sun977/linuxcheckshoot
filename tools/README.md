# Linux 系统监控与安全工具集

本目录包含了一系列用于Linux系统监控和安全管理的工具。这些工具可以帮助系统管理员进行网络监控、进程分析、IP封禁管理和文件传输等功能。工具集包含Shell脚本和Python脚本，为应急响应和系统安全管理提供全面支持。

## 工具列表

### 1. blockIP/ - IP封禁管理工具目录

#### blockIP.sh - IP封禁管理脚本

**更新时间**: 2025-07-14
**位置**: `blockIP/blockIP.sh`

**脚本特点**:
- 支持iptables和firewall两种防火墙工具
- 自动检测可用的防火墙工具
- 支持单个IP和批量IP操作
- 完整的备份和恢复功能
- 预览模式，可查看将要执行的命令
- 详细的日志记录功能
- 严格的错误处理机制

**主要功能**:
- IP地址封禁和解封
- 批量处理IP列表文件
- 列出当前被封禁的IP
- 检查指定IP的封禁状态
- 防火墙规则备份和恢复
- 显示防火墙状态

**使用说明**:
```bash
# 基本用法
./blockIP.sh [选项] <IP地址|IP文件>

# 常用选项
-b, --block         封禁IP地址(默认操作)
-u, --unblock       解封IP地址
-t, --tool TOOL     指定防火墙工具: iptables, firewall, auto(默认)
-f, --file FILE     从文件批量处理IP地址
-l, --list          列出当前封禁的IP地址
-c, --check IP      检查指定IP是否被封禁
-s, --status        显示防火墙状态
--backup            备份当前防火墙规则
--restore FILE      从备份文件恢复防火墙规则
--show-run          预览模式，仅显示命令不执行

# 使用示例
./blockIP.sh 192.168.1.100                    # 封禁单个IP
./blockIP.sh -u 192.168.1.100                 # 解封单个IP
./blockIP.sh -f ip_list.txt                   # 批量封禁IP
./blockIP.sh -l                               # 列出被封禁的IP
./blockIP.sh --backup                         # 备份防火墙规则
./blockIP.sh --show-run -f ip_list.txt        # 预览批量操作
```

**注意事项**:
- 需要root权限运行
- 脚本会自动备份配置，但建议手动备份重要配置
- 支持IPv4地址格式验证
- 日志文件默认保存在当前目录的outBlockIP.log

#### example_ip_list.txt - IP列表示例文件

**位置**: `blockIP/example_ip_list.txt`

**文件说明**:
- 提供IP地址列表的标准格式示例
- 用于批量IP操作的参考模板
- 每行一个IP地址，支持注释行(以#开头)

**使用方法**:
```bash
# 复制示例文件并编辑
cp blockIP/example_ip_list.txt my_ip_list.txt
# 编辑文件添加需要处理的IP地址
vim my_ip_list.txt
# 使用文件进行批量操作
./blockIP/blockIP.sh -f my_ip_list.txt
```

---

### 2. uploadServer/ - 文件上传服务器工具目录

#### uploadServer.py - HTTP文件上传服务器

**更新时间**: 2025-07-15
**位置**: `uploadServer/uploadServer.py`

**脚本特点**:
- HTTP文件上传服务器，专门用于接收linuxGun.sh发送的检查结果文件
- 支持Bearer Token认证，确保传输安全性
- 文件大小限制和格式验证
- 详细的访问日志和错误日志记录
- 支持自定义上传目录、端口和文件大小限制
- 防止目录遍历攻击的安全文件名处理

**主要功能**:
- 接收HTTP POST文件上传请求
- Token认证验证
- 文件大小和格式检查
- 安全的文件存储和命名
- 详细的操作日志记录
- JSON格式的响应信息

**使用说明**:
```bash
# 基本用法
python3 uploadServer.py <IP地址> <端口> <认证Token>

# 使用示例
python3 uploadServer/uploadServer.py 192.168.1.100 8080 your_secret_token

# 配合linuxGun.sh使用
./linuxGun.sh --all                                    # 先执行检查
./linuxGun.sh --send 192.168.1.100 8080 your_secret_token  # 发送结果
```

**配置选项**:
- 默认上传目录: `./uploads`
- 默认最大文件大小: `1024M`
- 默认日志文件: `./uploadServer.log`
- 支持的文件格式: 所有格式(主要用于tar.gz压缩包)

**安全特性**:
- Bearer Token认证机制
- 文件大小限制防止DoS攻击
- 安全的文件名处理防止路径遍历
- 详细的访问日志记录
- IP地址和操作时间记录

#### requirements.txt - Python依赖文件

**位置**: `uploadServer/requirements.txt`

**文件说明**:
- 列出uploadServer.py所需的Python依赖包
- 当前版本使用Python标准库，无额外依赖
- 为未来功能扩展预留依赖管理

**安装依赖**:
```bash
cd uploadServer
pip3 install -r requirements.txt
```

---

### 3. monitorInter.sh - 网络接口流量监控脚本

**更新时间**: 2025-07-08

**脚本特点**:
- 实时监控网络接口流量
- 支持单次检测和持续监控模式
- 自动格式化字节数显示(B/KB/MB/GB)
- 显示详细的接口信息
- 计算实时传输速率
- 友好的用户界面和颜色输出

**主要功能**:
- 监控指定网络接口的发送和接收流量
- 显示数据包数量和字节数统计
- 计算实时传输速率
- 列出所有可用的网络接口
- 显示接口状态、IP地址和MAC地址

**使用说明**:
```bash
# 基本用法
./monitorInter.sh <网络接口> [选项]

# 常用选项
-c, --continuous    持续监控模式(默认为单次检测)
-i, --interval N    监控间隔时间(秒,默认1秒)
-l, --list          列出所有可用的网络接口
-h, --help          显示帮助信息

# 使用示例
./monitorInter.sh eth0                        # 单次检测eth0接口
./monitorInter.sh eth0 -c                     # 持续监控eth0接口
./monitorInter.sh eth0 -c -i 5                # 每5秒刷新一次
./monitorInter.sh -l                          # 列出所有网络接口
```

**输出信息**:
- 接口基本信息(名称、状态、IP地址、MAC地址)
- 流量统计(发送/接收的数据包数和字节数)
- 实时传输速率(B/s, KB/s, MB/s等)
- 格式化的易读显示

---

### 4. monitorPs2Ip.sh - IP通信进程监控脚本

**更新时间**: 2025-07-02

**脚本特点**:
- 检测与指定IP通信的所有进程
- 支持多种网络检测工具(lsof, netstat, ss)
- 自动检测可用工具并选择最佳方案
- 支持TCP、UDP和ICMP协议监控
- 显示详细的连接信息和进程信息
- 支持持续监控模式

**主要功能**:
- 检测与目标IP建立连接的进程
- 显示进程名、PID、用户、协议类型
- 显示本地地址和远程地址信息
- 检测ping等ICMP连接
- 支持单次检测和持续监控

**使用说明**:
```bash
# 基本用法
./monitorPs2Ip.sh <IP地址> [选项]

# 常用选项
-c, --continuous    持续监控模式(按Ctrl+C停止)
-i, --interval N    持续监控时间间隔(秒，默认5秒)
-h, --help          显示帮助信息

# 使用示例
./monitorPs2Ip.sh 192.168.1.100               # 单次检测
./monitorPs2Ip.sh 192.168.1.100 -c            # 持续监控
./monitorPs2Ip.sh 192.168.1.100 -c -i 10      # 每10秒监控一次
```

**输出信息**:
- 进程名称和PID
- 运行用户
- 协议类型(TCP/UDP/ICMP)
- 本地地址和端口
- 远程地址和端口
- 连接状态信息

**依赖工具**:
脚本会自动检测并使用以下工具之一:
- lsof (推荐，功能最全面)
- ss (现代替代工具)
- netstat (传统工具)

---

## 系统要求

### 基础环境
- Linux操作系统
- Bash shell环境 (Shell脚本)
- Python 3.6+ (uploadServer.py)
- 相应的系统权限(某些功能需要root权限)

### 依赖工具
- 网络监控工具: lsof/netstat/ss等
- 防火墙工具: iptables/firewalld (blockIP.sh)
- Python标准库 (uploadServer.py)

## 安装和使用

### Shell脚本工具
1. 确保脚本具有执行权限:
```bash
chmod +x *.sh
chmod +x blockIP/*.sh
```

2. 运行Shell脚本:
```bash
# 查看帮助信息
./scriptname.sh -h

# 执行具体功能
./scriptname.sh [参数]
```

### Python工具
1. 安装Python依赖(如需要):
```bash
cd uploadServer
pip3 install -r requirements.txt
```

2. 运行Python脚本:
```bash
python3 uploadServer/uploadServer.py <IP> <端口> <Token>
```

## 注意事项

1. **权限要求**: blockIP.sh需要root权限运行
2. **备份建议**: 使用blockIP.sh前建议手动备份防火墙配置
3. **网络工具**: 确保系统安装了必要的网络监控工具
4. **IP格式**: 所有脚本都支持IPv4地址格式验证
5. **日志记录**: blockIP.sh和uploadServer.py都会生成详细的操作日志
6. **安全性**: uploadServer.py使用Token认证，请妥善保管认证令牌
7. **文件传输**: 建议在安全的网络环境中使用文件上传功能

## 故障排除

### 通用问题
- 如果遇到权限问题，请使用sudo运行脚本
- 查看脚本的帮助信息了解详细用法
- 检查日志文件获取错误信息

### Shell脚本问题
- 如果网络监控工具不可用，请安装相应的软件包
- blockIP.sh权限问题：确保以root权限运行
- 防火墙工具检测失败：检查iptables或firewalld是否安装

### Python脚本问题
- Python版本兼容性：确保使用Python 3.6+
- 端口占用问题：检查指定端口是否被其他程序占用
- Token认证失败：确保客户端和服务端使用相同的Token
- 文件上传失败：检查文件大小是否超过限制

## 工具集集成使用

### 典型应急响应流程
1. **系统检查**: 使用linuxGun.sh进行全面安全检查
```bash
./linuxGun.sh --all
```

2. **启动接收服务**: 在分析机器上启动文件接收服务
```bash
python3 tools/uploadServer/uploadServer.py 192.168.1.100 8080 emergency_token_2025
```

3. **传输检查结果**: 将检查结果发送到分析机器
```bash
./linuxGun.sh --send 192.168.1.100 8080 emergency_token_2025 [FILE_PATH]
```

4. **实时监控**: 根据需要使用监控工具
```bash
# 监控网络接口
./tools/monitorInter.sh eth0 -c

# 监控特定IP通信
./tools/monitorPs2Ip.sh 192.168.1.200 -c
```

5. **IP封禁**: 发现恶意IP时进行封禁
```bash
# 封禁单个IP
./tools/blockIP/blockIP.sh 192.168.1.200

# 批量封禁
echo "192.168.1.200\n192.168.1.201" > malicious_ips.txt
./tools/blockIP/blockIP.sh -f malicious_ips.txt
```

## 作者信息

- **作者**: Sun977
- **邮箱**: jiuwei977@foxmail.com
- **项目**: LinuxCheckShoot - Linux安全检测工具集
- **版本**: v6.0.5 (2025-07-15)
- **维护**: 持续更新和功能增强

## 版本历史

- **v6.0.5 (2025-07-15)**: 新增uploadServer.py文件传输功能
- **v6.0.4 (2025-07-14)**: 完善blockIP.sh IP封禁管理功能
- **v6.0.3 (2025-07-08)**: 优化monitorInter.sh网络监控功能
- **v6.0.2 (2025-07-02)**: 新增monitorPs2Ip.sh进程监控功能

---

*本工具集旨在为Linux系统管理员和安全从业者提供便捷的系统监控和安全管理功能。请在充分了解各工具功能的前提下谨慎使用，特别是涉及防火墙规则修改的操作。*