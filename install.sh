#!/bin/bash

# HadoopDeploy_tool 一键安装脚本
# 作者: violet27-chf
# 版本: 1.0.0
# 描述: 自动安装和配置HadoopDeploy_tool项目

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="HadoopDeploy_tool"
PROJECT_VERSION="1.0.0"
GITHUB_REPO="https://github.com/violet27-chf/HadoopDeploy_tool"
INSTALL_DIR="/opt/hadoopdeploy"
SERVICE_USER="hadoopdeploy"
SERVICE_GROUP="hadoopdeploy"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# 显示欢迎信息
show_welcome() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    HadoopDeploy_tool                         ║"
    echo "║                    一键安装脚本                               ║"
    echo "║                                                              ║"
    echo "║  让Hadoop集群部署变得简单高效                                  ║"
    echo "║  支持全自动、半自动、手动三种部署模式                           ║"
    echo "║                                                              ║"
    echo "║  作者: violet27-chf                                          ║"
    echo "║  版本: 1.0.0                                                 ║"
    echo "║                                                              ║"
    echo "║  让Hadoop集群部署变得简单高效                                  ║"
    echo "║  支持全自动、半自动、手动三种部署模式                           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "项目信息:"
    echo "  - 名称: $PROJECT_NAME"
    echo "  - 版本: $PROJECT_VERSION"
    echo "  - 仓库: $GITHUB_REPO"
    echo "  - 安装目录: $INSTALL_DIR"
    echo ""
    echo "此脚本将自动完成以下操作:"
    echo "  1. 检查系统环境"
    echo "  2. 安装Python和依赖"
    echo "  3. 下载项目文件"
    echo "  4. 安装Python依赖"
    echo "  5. 启动Web界面"
    echo ""
    
    read -p "是否继续安装? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "安装已取消"
        exit 0
    fi
}

#检查系统版本
if grep -qE "release 8\\." /etc/redhat-release; then
    rm -rf /etc/yum.repos.d/*
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
    yum clean all && yum makecache
else
    rm -rf /etc/yum.repos.d/*
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    yum clean all && yum makecache
fi

yum install python3 python3-pip git curl -y

git clone $GITHUB_REPO

cd HadoopDeploy_tool
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
python3 app.py