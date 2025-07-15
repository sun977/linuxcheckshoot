#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
文件上传服务器 - 接收linuxgun.sh发送的文件
Version: 1.0.0
Author: Sun977
Description: 启动HTTP服务器接收文件上传,支持token认证
Update: 2025-07-15
Usage: python3 uploadServer.py <ip> <port> <token>
"""

import os
import sys
import time
import json
import signal
import argparse
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import parse_qs
import cgi
import tempfile
import shutil
from datetime import datetime

# 默认配置
DEFAULT_UPLOAD_DIR = "./uploads"
DEFAULT_MAX_SIZE = "100M"
DEFAULT_LOG_FILE = "./uploadServer.log"

# 全局变量
UPLOAD_DIR = DEFAULT_UPLOAD_DIR
MAX_SIZE = DEFAULT_MAX_SIZE
LOG_FILE = DEFAULT_LOG_FILE
TOKEN = ""
SERVER_START_TIME = ""

# 颜色定义
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color

def log_message(level, message):
    """记录日志信息"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_entry = f"[{timestamp}] [{level}] {message}\n"
    
    # 写入日志文件
    try:
        os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
        with open(LOG_FILE, 'a', encoding='utf-8') as f:
            f.write(log_entry)
    except Exception:
        pass
    
    # 输出到控制台
    color_map = {
        'INFO': Colors.GREEN,
        'WARN': Colors.YELLOW,
        'ERROR': Colors.RED,
        'DEBUG': Colors.BLUE
    }
    color = color_map.get(level, Colors.NC)
    print(f"{color}[{level}]{Colors.NC} {message}")

def parse_size(size_str):
    """解析文件大小字符串，返回字节数"""
    size_str = size_str.upper()
    if size_str.endswith('K'):
        return int(size_str[:-1]) * 1024
    elif size_str.endswith('M'):
        return int(size_str[:-1]) * 1024 * 1024
    elif size_str.endswith('G'):
        return int(size_str[:-1]) * 1024 * 1024 * 1024
    else:
        return int(size_str)

def format_size(size_bytes):
    """格式化文件大小显示"""
    if size_bytes < 1024:
        return f"{size_bytes} B"
    elif size_bytes < 1024 * 1024:
        return f"{size_bytes / 1024:.1f} KB"
    elif size_bytes < 1024 * 1024 * 1024:
        return f"{size_bytes / (1024 * 1024):.1f} MB"
    else:
        return f"{size_bytes / (1024 * 1024 * 1024):.1f} GB"

class UploadHandler(BaseHTTPRequestHandler):
    """文件上传处理器"""
    
    def log_message(self, format, *args):
        """重写日志方法，避免默认日志输出"""
        pass
    
    def do_POST(self):
        """处理POST请求 - 文件上传"""
        client_ip = self.client_address[0]
        
        try:
            # 检查Authorization头
            auth_header = self.headers.get('Authorization')
            if not auth_header or not auth_header.startswith('Bearer '):
                self.send_error(401, 'Unauthorized: Missing or invalid token')
                log_message('WARN', f'未授权访问尝试 - IP: {client_ip}')
                return
            
            provided_token = auth_header[7:]  # 移除'Bearer '前缀
            if provided_token != TOKEN:
                self.send_error(401, 'Unauthorized: Invalid token')
                log_message('WARN', f'无效token访问尝试 - IP: {client_ip}, Token: {provided_token[:8]}***')
                return
            
            # 检查Content-Type
            content_type = self.headers.get('Content-Type')
            if not content_type or not content_type.startswith('multipart/form-data'):
                self.send_error(400, 'Bad Request: Expected multipart/form-data')
                log_message('WARN', f'无效Content-Type - IP: {client_ip}, Type: {content_type}')
                return
            
            # 检查文件大小
            content_length = int(self.headers.get('Content-Length', 0))
            max_bytes = parse_size(MAX_SIZE)
            if content_length > max_bytes:
                self.send_error(413, f'File too large: Maximum size is {MAX_SIZE}')
                log_message('WARN', f'文件过大被拒绝 - IP: {client_ip}, Size: {format_size(content_length)}')
                return
            
            # 解析上传的文件
            form = cgi.FieldStorage(
                fp=self.rfile,
                headers=self.headers,
                environ={'REQUEST_METHOD': 'POST'}
            )
            
            if 'file' not in form:
                self.send_error(400, 'Bad Request: No file field found')
                log_message('WARN', f'未找到文件字段 - IP: {client_ip}')
                return
            
            file_item = form['file']
            if not file_item.filename:
                self.send_error(400, 'Bad Request: No file selected')
                log_message('WARN', f'未选择文件 - IP: {client_ip}')
                return
            
            # 生成安全的文件名
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            original_filename = file_item.filename
            # 移除路径分隔符，防止目录遍历攻击
            safe_filename = original_filename.replace('/', '_').replace('\\', '_')
            safe_filename = f"{timestamp}_{safe_filename}"
            
            # 确保上传目录存在
            os.makedirs(UPLOAD_DIR, exist_ok=True)
            file_path = os.path.join(UPLOAD_DIR, safe_filename)
            
            # 保存文件
            with open(file_path, 'wb') as f:
                shutil.copyfileobj(file_item.file, f)
            
            file_size = os.path.getsize(file_path)
            
            # 返回成功响应
            response = {
                'status': 'success',
                'message': 'File uploaded successfully',
                'original_filename': original_filename,
                'saved_filename': safe_filename,
                'size': file_size,
                'size_formatted': format_size(file_size),
                'upload_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                'upload_path': os.path.abspath(file_path)
            }
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response, ensure_ascii=False).encode('utf-8'))
            
            log_message('INFO', f'文件上传成功 - IP: {client_ip}, 原文件名: {original_filename}, 保存为: {safe_filename}, 大小: {format_size(file_size)}')
            
        except Exception as e:
            error_msg = f'Internal Server Error: {str(e)}'
            self.send_error(500, error_msg)
            log_message('ERROR', f'文件上传失败 - IP: {client_ip}, 错误: {str(e)}')
    
    def do_GET(self):
        """处理GET请求 - 健康检查和状态查询"""
        client_ip = self.client_address[0]
        
        if self.path == '/health':
            # 健康检查端点
            response = {
                'status': 'ok',
                'service': 'upload-server',
                'version': '1.0.0',
                'start_time': SERVER_START_TIME,
                'uptime': str(datetime.now() - datetime.strptime(SERVER_START_TIME, '%Y-%m-%d %H:%M:%S'))
            }
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response, ensure_ascii=False).encode('utf-8'))
            
            log_message('DEBUG', f'健康检查请求 - IP: {client_ip}')
            
        elif self.path == '/status':
            # 状态查询端点
            try:
                # 统计上传文件信息
                file_count = 0
                total_size = 0
                if os.path.exists(UPLOAD_DIR):
                    for filename in os.listdir(UPLOAD_DIR):
                        file_path = os.path.join(UPLOAD_DIR, filename)
                        if os.path.isfile(file_path):
                            file_count += 1
                            total_size += os.path.getsize(file_path)
                
                response = {
                    'status': 'running',
                    'service': 'upload-server',
                    'start_time': SERVER_START_TIME,
                    'upload_dir': os.path.abspath(UPLOAD_DIR),
                    'max_file_size': MAX_SIZE,
                    'uploaded_files': file_count,
                    'total_size': format_size(total_size),
                    'log_file': os.path.abspath(LOG_FILE)
                }
                
                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(response, ensure_ascii=False).encode('utf-8'))
                
                log_message('DEBUG', f'状态查询请求 - IP: {client_ip}')
                
            except Exception as e:
                self.send_error(500, f'Status query failed: {str(e)}')
                log_message('ERROR', f'状态查询失败 - IP: {client_ip}, 错误: {str(e)}')
        else:
            # 其他路径返回404
            self.send_error(404, 'Not Found')
            log_message('DEBUG', f'无效路径访问 - IP: {client_ip}, Path: {self.path}')
    
    def do_OPTIONS(self):
        """处理OPTIONS请求 - CORS预检"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Authorization, Content-Type')
        self.end_headers()

def signal_handler(signum, frame):
    """信号处理器 - 优雅关闭服务器"""
    print(f"\n{Colors.YELLOW}[INFO]{Colors.NC} 接收到中断信号，正在关闭服务器...")
    log_message('INFO', '服务器正在关闭...')
    
    # 显示服务器运行统计
    try:
        if os.path.exists(UPLOAD_DIR):
            file_count = len([f for f in os.listdir(UPLOAD_DIR) if os.path.isfile(os.path.join(UPLOAD_DIR, f))])
            print(f"{Colors.BLUE}[INFO]{Colors.NC} 服务器运行期间共接收 {file_count} 个文件")
            log_message('INFO', f'服务器运行期间共接收 {file_count} 个文件')
    except Exception:
        pass
    
    print(f"{Colors.GREEN}[INFO]{Colors.NC} 服务器已安全关闭")
    log_message('INFO', '服务器已安全关闭')
    sys.exit(0)

def validate_ip(ip):
    """验证IP地址格式"""
    if ip == "0.0.0.0":
        return True
    
    parts = ip.split('.')
    if len(parts) != 4:
        return False
    
    try:
        for part in parts:
            if not 0 <= int(part) <= 255:
                return False
        return True
    except ValueError:
        return False

def validate_port(port):
    """验证端口号"""
    try:
        port_num = int(port)
        return 1 <= port_num <= 65535
    except ValueError:
        return False

def validate_token(token):
    """验证token格式"""
    if len(token) < 8 or len(token) > 64:
        return False
    return token.isalnum()

def show_server_info(ip, port, token):
    """显示服务器启动信息"""
    print(f"{Colors.GREEN}========================================{Colors.NC}")
    print(f"{Colors.GREEN}    文件上传服务器启动成功!{Colors.NC}")
    print(f"{Colors.GREEN}========================================{Colors.NC}")
    print(f"{Colors.BLUE}监听地址:{Colors.NC} {ip}:{port}")
    print(f"{Colors.BLUE}上传目录:{Colors.NC} {os.path.abspath(UPLOAD_DIR)}")
    print(f"{Colors.BLUE}日志文件:{Colors.NC} {os.path.abspath(LOG_FILE)}")
    print(f"{Colors.BLUE}最大文件大小:{Colors.NC} {MAX_SIZE}")
    print(f"{Colors.BLUE}Token:{Colors.NC} {token[:8]}*** (已隐藏)")
    print(f"{Colors.BLUE}启动时间:{Colors.NC} {SERVER_START_TIME}")
    print(f"{Colors.GREEN}========================================{Colors.NC}")
    print(f"{Colors.YELLOW}健康检查URL:{Colors.NC} http://{ip}:{port}/health")
    print(f"{Colors.YELLOW}状态查询URL:{Colors.NC} http://{ip}:{port}/status")
    print(f"{Colors.GREEN}========================================{Colors.NC}")
    print(f"{Colors.YELLOW}使用以下命令发送文件:{Colors.NC}")
    print(f"{Colors.YELLOW}./linuxgun.sh --send {ip} {port} {token} /path/to/file{Colors.NC}")
    print(f"{Colors.GREEN}========================================{Colors.NC}")
    print(f"{Colors.BLUE}按 Ctrl+C 停止服务器{Colors.NC}")
    print()

def main():
    """主函数"""
    global UPLOAD_DIR, MAX_SIZE, LOG_FILE, TOKEN, SERVER_START_TIME
    
    # 检查参数
    if len(sys.argv) != 4:
        print(f"{Colors.RED}[ERROR]{Colors.NC} 参数错误")
        print(f"{Colors.BLUE}用法:{Colors.NC} python3 {sys.argv[0]} <ip> <port> <token>")
        print(f"{Colors.BLUE}示例:{Colors.NC} python3 {sys.argv[0]} 0.0.0.0 8080 abc123def456")
        sys.exit(1)
    
    ip = sys.argv[1]
    port = sys.argv[2]
    token = sys.argv[3]
    
    # 验证参数
    if not validate_ip(ip):
        print(f"{Colors.RED}[ERROR]{Colors.NC} 无效的IP地址: {ip}")
        sys.exit(1)
    
    if not validate_port(port):
        print(f"{Colors.RED}[ERROR]{Colors.NC} 无效的端口号: {port} (范围: 1-65535)")
        sys.exit(1)
    
    if not validate_token(token):
        print(f"{Colors.RED}[ERROR]{Colors.NC} 无效的token格式 (长度8-64位,仅支持字母数字)")
        sys.exit(1)
    
    # 设置全局变量
    TOKEN = token
    SERVER_START_TIME = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # 创建上传目录
    try:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
    except Exception as e:
        print(f"{Colors.RED}[ERROR]{Colors.NC} 无法创建上传目录: {e}")
        sys.exit(1)
    
    # 注册信号处理器
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    try:
        # 创建HTTP服务器
        server_address = (ip, int(port))
        httpd = HTTPServer(server_address, UploadHandler)
        
        # 显示启动信息
        show_server_info(ip, port, token)
        
        # 记录启动日志
        log_message('INFO', f'文件上传服务器启动成功 - 监听: {ip}:{port}')
        log_message('INFO', f'上传目录: {os.path.abspath(UPLOAD_DIR)}')
        log_message('INFO', f'最大文件大小: {MAX_SIZE}')
        log_message('INFO', f'Token: {token[:8]}*** (已隐藏)')
        
        # 启动服务器
        httpd.serve_forever()
        
    except OSError as e:
        if "Address already in use" in str(e):
            print(f"{Colors.RED}[ERROR]{Colors.NC} 端口 {port} 已被占用，请选择其他端口")
        else:
            print(f"{Colors.RED}[ERROR]{Colors.NC} 启动服务器失败: {e}")
        log_message('ERROR', f'启动服务器失败: {e}')
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}[ERROR]{Colors.NC} 服务器运行错误: {e}")
        log_message('ERROR', f'服务器运行错误: {e}')
        sys.exit(1)

if __name__ == '__main__':
    main()