#!/bin/bash

# 测试firewall-cmd修复的简单验证脚本
# 用于验证命令参数传递是否正确

echo "测试firewall-cmd命令参数传递修复"
echo "======================================"

# 测试IP
test_ip="192.168.1.100"

echo "1. 测试修复后的命令格式:"
echo "   封禁命令:"
cmd="firewall-cmd --permanent --add-rich-rule=\"rule family=ipv4 source address=$test_ip drop\""
echo "   $cmd"

echo "   解封命令:"
cmd="firewall-cmd --permanent --remove-rich-rule=\"rule family=ipv4 source address=$test_ip drop\""
echo "   $cmd"

echo "   检查命令:"
echo "   firewall-cmd --list-rich-rules | grep -q \"source address=$test_ip\""

echo ""
echo "2. 关键修复点:"
echo "   - 使用转义双引号替代单引号包围rich-rule参数"
echo "   - 使用eval执行包含转义字符的命令字符串"
echo "   - 避免了shell对复杂命令的错误解析"
echo "   - 确保firewall-cmd能正确接收和解析参数"

echo ""
echo "3. 如果要实际测试，请运行:"
echo "   sudo ./blockIP.sh --show-run -t firewall $test_ip"