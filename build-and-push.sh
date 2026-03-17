#!/bin/bash
# XOJ-Pro 构建和推送脚本 (Bash)
# 使用方法: chmod +x build-and-push.sh && ./build-and-push.sh

set -e

echo "========================================"
echo -e "\033[36m  XOJ-Pro Docker 构建和推送\033[0m"
echo "========================================"
echo ""

# 检查 Docker 是否运行
echo -e "[1/5] \033[33m检查 Docker 状态...\033[0m"
if ! docker version > /dev/null 2>&1; then
    echo -e "\033[31m✗ Docker 未运行，请先启动 Docker\033[0m"
    exit 1
fi
echo -e "\033[32m✓ Docker 正在运行\033[0m"

# 登录 Docker Hub
echo ""
echo -e "[2/5] \033[33m登录 Docker Hub...\033[0m"
docker login
echo -e "\033[32m✓ Docker Hub 登录成功\033[0m"

# 构建所有镜像
echo ""
echo -e "[3/5] \033[33m开始构建镜像...\033[0m"
docker compose -f docker-compose.build.yml build
echo -e "\033[32m✓ 所有镜像构建成功\033[0m"

# 推送所有镜像
echo ""
echo -e "[4/5] \033[33m开始推送镜像到 Docker Hub...\033[0m"
docker compose -f docker-compose.build.yml push
echo -e "\033[32m✓ 所有镜像推送成功\033[0m"

echo ""
echo "========================================"
echo -e "\033[32m  构建和推送完成！\033[0m"
echo "========================================"
echo ""
echo -e "镜像已推送到："
echo -e "  - kiffyowo/judge:v2.0"
echo -e "  - kiffyowo/backend:v2.0"
echo -e "  - kiffyowo/frontend:v2.0"
echo ""
echo -e "\033[36m现在可以运行: docker-compose up -d\033[0m"
