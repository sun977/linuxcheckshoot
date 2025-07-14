#!/bin/bash

# 测试firewall-cmd语法的简单脚本
ip="192.168.1.100"

echo "测试新的firewall-cmd语法:"
echo "封禁命令:"
echo "firewall-cmd --permanent --add-rich-rule='rule family=\"ipv4\" source address=\"$ip\" drop'"

echo "解封命令:"
echo "firewall-cmd --permanent --remove-rich-rule='rule family=\"ipv4\" source address=\"$ip\" drop'"

echo "检查命令:"
echo "firewall-cmd --list-rich-rules | grep -q \"source address=\\\"$ip\\\"\""

echo "\n修复说明:"
echo "1. rich-rule中的family和source address值需要用双引号包围"
echo "2. 正确格式: rule family=\"ipv4\" source address=\"IP\" drop"
echo "3. 错误格式: rule family=ipv4 source address=IP drop"