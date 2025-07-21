# LinuxGun 脚本已知问题和解决方案

> **重要提示**: 在对此脚本进行任何修改前，请仔细阅读本文档，避免引入已知的兼容性问题。

## 问题 #001: Bash 关联数组兼容性问题

### 问题描述
- **问题现象**: 模块映射错误，所有模块都被错误地映射到 `baselineCheck` 函数
- **错误日志**: `[DEBUG] 0 -> baselineCheck`（数组中只有一个键值对）
- **影响范围**: 所有使用关联数组的代码段

### 根本原因
- **Bash 版本兼容性**: macOS 默认使用 Bash 3.2.57，不支持关联数组（Associative Arrays）
- **关联数组引入版本**: Bash 4.0+
- **语法问题**: `declare -A array_name` 在 Bash 3.x 中无效

### 解决方案
**不要使用关联数组，改用函数式映射：**

```bash
# ❌ 错误做法 - 关联数组（Bash 4.0+ 才支持）
declare -A module_functions
module_functions[system]="systemCheck"
module_functions[network]="networkInfo"

# ✅ 正确做法 - 函数式映射（兼容 Bash 3.2+）
get_module_function() {
    local module="$1"
    case "$module" in
        "system") echo "systemCheck" ;;
        "network") echo "networkInfo" ;;
        "psinfo") echo "processInfo" ;;
        # ... 其他映射
        *) echo "" ;;  # 未知模块返回空字符串
    esac
}

# 使用方式
func_name=$(get_module_function "$module")
if [[ -n "$func_name" ]]; then
    $func_name
fi
```

### 检测方法
```bash
# 检查 Bash 版本
bash --version

# 测试关联数组支持
bash -c 'declare -A test_array; test_array[key]="value"; echo ${test_array[key]}' 2>/dev/null || echo "不支持关联数组"
```

### 预防措施
1. **兼容性检查**: 在使用高级 Bash 特性前，先检查版本兼容性
2. **替代方案**: 优先使用兼容性更好的实现方式
3. **测试验证**: 在不同 Bash 版本环境中测试脚本

---

## AI 大模型修改指南

### 🚨 关键注意事项

1. **Bash 版本兼容性**
   - 默认目标环境: Bash 3.2+ (macOS/老版本 Linux)
   - 避免使用 Bash 4.0+ 特性，除非明确说明最低版本要求

2. **禁用特性列表**
   - 关联数组 (`declare -A`)
   - `readarray`/`mapfile` 命令
   - `**` 递归通配符
   - `;&` 和 `;;&` case 语句

3. **推荐替代方案**
   - 关联数组 → `case` 语句或函数映射
   - `readarray` → `while read` 循环
   - 复杂数据结构 → 多个简单变量或文件存储

4. **修改前检查清单**
   - [ ] 确认目标 Bash 版本
   - [ ] 检查是否使用了高版本特性
   - [ ] 验证语法兼容性
   - [ ] 测试核心功能

### 🔧 调试技巧

1. **语法检查**: `bash -n script.sh`
2. **版本检查**: `bash --version`
3. **功能测试**: 在目标环境中运行关键代码段
4. **日志分析**: 查看 `message.log` 中的错误信息

---

## 更新记录

- **2025-07-21**: 修复 Bash 关联数组兼容性问题，改用函数式映射
- **2025-07-21**: 创建本文档，记录已知问题和解决方案

---

**最后更新**: 2025-07-21  
**维护者**: AI Assistant  
**版本**: 1.0