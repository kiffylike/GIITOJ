# XOJ-Pro
An open-source Online Judge system based on QDUOJ
## 🛠️ 快速部署

为了方便用户快速上手，我们提供了专门的部署仓库。请前往以下地址获取完整的 Docker 配置文件及部署脚本：

👉 **部署仓库地址**：[kiffylike/XOJ-ProDeploy](https://github.com/kiffylike/XOJ-ProDeploy)

### 快速启动指令：
```bash
# 克隆部署仓库
git clone https://github.com/kiffylike/XOJ-ProDeploy.git && cd XOJ-ProDeploy

# 启动服务
docker compose -f docker-compose.xoj-pro.yml up -d
