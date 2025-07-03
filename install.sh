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
NC='\033[0m' 

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
    echo -e "${PURPLE}HadoopDeploy_tool"
    echo -e "${PURPLE}一键安装脚本${NC}"
    echo
    echo -e "${GREEN}让Hadoop集群部署变得简单高效"
    echo -e "支持全自动、半自动、手动三种部署模式${NC}"
    echo
    echo -e "${YELLOW}作者: violet27-chf"
    echo -e "版本: 1.0.0${NC}"
    echo
    echo -e "${PURPLE}项目信息:${NC}"
    echo -e "  - 名称: ${GREEN}$PROJECT_NAME${NC}"
    echo -e "  - 版本: ${YELLOW}$PROJECT_VERSION${NC}"
    echo -e "  - 仓库: ${BLUE}$GITHUB_REPO${NC}"
    echo -e "  - 安装目录: ${CYAN}$INSTALL_DIR${NC}"
    echo ""
    echo -e "${PURPLE}此脚本将自动完成以下操作:${NC}"
    echo -e "  ${GREEN}1.${NC} 检查系统环境"
    echo -e "  ${GREEN}2.${NC} 安装Python和依赖"
    echo -e "  ${GREEN}3.${NC} 下载项目文件"
    echo -e "  ${GREEN}4.${NC} 安装Python依赖"
    echo -e "  ${GREEN}5.${NC} 启动Web界面"
    echo ""
    
    echo -e "${YELLOW}是否继续安装? (y/N): ${NC}" -n 1 -r
    read -p "" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "安装已取消"
        exit 0
    fi
}

# 显示欢迎信息
show_welcome

# 开始安装流程
log_step "开始安装 HadoopDeploy_tool..."

#检查系统版本
log_info "检查系统版本..."
if grep -qE "release 8\\." /etc/redhat-release; then
    log_info "检测到 CentOS 8，配置 yum 源..."
    rm -rf /etc/yum.repos.d/*
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
    yum clean all && yum makecache
else
    log_info "检测到 CentOS 7，配置 yum 源..."
    rm -rf /etc/yum.repos.d/*
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    yum clean all && yum makecache
fi

log_info "安装系统依赖包..."
yum install python3 python3-pip git curl -y

log_info "安装nmap..."
yum install nmap -y

log_info "切换目录..."
cd /opt

log_info "下载项目文件..."
git clone $GITHUB_REPO

log_info "切换目录..."
cd HadoopDeploy_tool

log_info "创建 Python 虚拟环境..."
python3 -m venv venv
source venv/bin/activate

log_info "安装 Python 依赖包..."
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

log_success "安装目录在/opt/hadoopDeploy_tool"
log_success "安装完成！正在启动 Web 界面..."
log_info "访问地址: http://localhost:5000"
echo ""
python3 app.py