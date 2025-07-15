#!/bin/bash

# 快速测试脚本 - 验证基本功能
# Version: 1.0.0
# Author: Sun977
# Description: 快速验证文件上传功能是否正常工作
# Usage: ./quick_test.sh

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
TEST_IP="127.0.0.1"
TEST_PORT="8080"
TEST_TOKEN="quicktest123"
LINUXGUN_PATH="../linuxgun.sh"
UPLOAD_SERVER_PATH="../uploadServer.py"
TEST_FILE="quick_test_file.txt"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}        快速功能测试${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}开始时间: $(date)${NC}"
echo ""

# 检查必要工具
echo -e "${YELLOW}检查环境...${NC}"
for tool in python3 curl; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo -e "${RED}✗ $tool 未安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ $tool 可用${NC}"
done

# 检查必要文件
if [ ! -f "$LINUXGUN_PATH" ]; then
    echo -e "${RED}✗ linuxgun.sh未找到: $LINUXGUN_PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✓ linuxgun.sh可用${NC}"

if [ ! -f "$UPLOAD_SERVER_PATH" ]; then
    echo -e "${RED}✗ uploadServer.py未找到: $UPLOAD_SERVER_PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✓ uploadServer.py可用${NC}"

echo ""

# 创建测试文件
echo -e "${YELLOW}创建测试文件...${NC}"
echo "Quick test file content - $(date)" > "$TEST_FILE"
echo -e "${GREEN}✓ 测试文件创建: $TEST_FILE${NC}"
echo ""

# 启动服务器
echo -e "${YELLOW}启动上传服务器...${NC}"
python3 "$UPLOAD_SERVER_PATH" "$TEST_IP" "$TEST_PORT" "$TEST_TOKEN" > server.log 2>&1 &
SERVER_PID=$!
echo -e "${GREEN}✓ 服务器启动，PID: $SERVER_PID${NC}"

# 等待服务器启动
echo -e "${YELLOW}等待服务器就绪...${NC}"
sleep 3

# 检查服务器是否运行
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "${RED}✗ 服务器启动失败${NC}"
    cat server.log
    exit 1
fi

# 检查服务器响应
echo -e "${YELLOW}检查服务器响应...${NC}"
if curl -s "http://$TEST_IP:$TEST_PORT/health" | grep -q '"status":"ok"'; then
    echo -e "${GREEN}✓ 服务器响应正常${NC}"
else
    echo -e "${RED}✗ 服务器响应异常${NC}"
    kill $SERVER_PID 2>/dev/null
    exit 1
fi
echo ""

# 测试文件上传
echo -e "${YELLOW}测试文件上传...${NC}"
if "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "$TEST_TOKEN" "$TEST_FILE" > upload.log 2>&1; then
    echo -e "${GREEN}✓ 文件上传成功${NC}"
else
    echo -e "${RED}✗ 文件上传失败${NC}"
    echo "上传日志:"
    cat upload.log
fi
echo ""

# 测试错误token
echo -e "${YELLOW}测试错误token认证...${NC}"
if "$LINUXGUN_PATH" --send "$TEST_IP" "$TEST_PORT" "wrongtoken" "$TEST_FILE" 2>&1 | grep -q "401"; then
    echo -e "${GREEN}✓ 错误token正确拒绝${NC}"
else
    echo -e "${RED}✗ 错误token未被拒绝${NC}"
fi
echo ""

# 关闭服务器
echo -e "${YELLOW}关闭服务器...${NC}"
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null
echo -e "${GREEN}✓ 服务器已关闭${NC}"
echo ""

# 清理
echo -e "${YELLOW}清理临时文件...${NC}"
rm -f "$TEST_FILE" server.log upload.log
echo -e "${GREEN}✓ 清理完成${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}        快速测试完成!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}结束时间: $(date)${NC}"
echo ""
echo -e "${YELLOW}如需完整测试，请运行:${NC}"
echo -e "${BLUE}  ./generate_test_scripts.sh${NC}"
echo -e "${BLUE}  cd upload_test_suite${NC}"
echo -e "${BLUE}  ./run_all_tests.sh${NC}"