# XOJ-Pro 部署指南

## 概述

本文档说明如何构建、推送到 Docker Hub 并启动 XOJ-Pro。

## 前置要求

- Docker Desktop (Windows/Mac) 或 Docker Engine (Linux)
- Docker Hub 账号 (用户名: kiffyowo)
- 至少 4GB 内存

## 快速开始（使用已推送的镜像）

如果你已经构建并推送了镜像，可以直接启动：

```bash
docker compose up -d
```

访问：http://localhost

---

## 完整流程：构建 → 推送 → 启动

### 第一步：构建和推送镜像

#### Windows (PowerShell)

```powershell
# 以管理员身份运行 PowerShell，然后执行：
.\build-and-push.ps1
```

#### Linux/Mac (Bash)

```bash
# 添加执行权限
chmod +x build-and-push.sh

# 执行构建和推送
./build-and-push.sh
```

#### 手动执行（可选）

如果你想手动一步步执行：

```bash
# 1. 登录 Docker Hub
docker login

# 2. 构建所有镜像
docker-compose -f docker-compose.build.yml build

# 3. 推送所有镜像
docker-compose -f docker-compose.build.yml push
```

### 第二步：启动服务

```bash
# 拉取并启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f oj-backend
docker-compose logs -f oj-frontend
```

### 第三步：访问应用

打开浏览器访问：http://localhost

---

## 服务说明

| 服务 | 镜像 | 端口 | 说明 |
|------|------|------|------|
| oj-redis | redis:7-alpine | - | 缓存服务 |
| oj-postgres | postgres:16-alpine | - | 数据库 |
| oj-judge | kiffyowo/judge:v2.0 | 8080 | 判题服务器 |
| oj-backend | kiffyowo/backend:v2.0 | 8000 | 后端 API |
| oj-frontend | kiffyowo/frontend:v2.0 | 80, 443 | 前端 Web |

---

## 常用命令

### 服务管理

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose stop

# 重启服务
docker-compose restart

# 删除服务（保留数据）
docker-compose down

# 删除服务和数据（谨慎使用！）
docker-compose down -v
```

### 日志查看

```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f oj-backend
docker-compose logs -f oj-frontend
docker-compose logs -f oj-judge
```

### 数据库操作

```bash
# 进入数据库容器
docker-compose exec oj-postgres psql -U onlinejudge -d onlinejudge

# 备份数据库
docker-compose exec oj-postgres pg_dump -U onlinejudge onlinejudge > backup.sql

# 恢复数据库
docker-compose exec -T oj-postgres psql -U onlinejudge -d onlinejudge < backup.sql
```

---

## 配置说明

### 修改 TOKEN（重要！）

在 `docker-compose.yml` 中，修改以下值为安全的随机字符串：

```yaml
services:
  oj-judge:
    environment:
      - TOKEN=your_secure_token_here

  oj-backend:
    environment:
      - JUDGE_SERVER_TOKEN=your_secure_token_here
```

### 数据持久化

所有数据存储在 `./data` 目录下：

- `./data/postgres` - PostgreSQL 数据库
- `./data/redis` - Redis 数据
- `./data/backend` - 后端数据（测试用例、日志等）

**备份建议：定期备份 `./data` 目录！**

---

## 故障排查

### 端口被占用

如果 80 端口被占用，修改 `docker-compose.yml`：

```yaml
oj-frontend:
  ports:
    - "8080:80"  # 将主机端口改为 8080
```

然后访问：http://localhost:8080

### 服务启动失败

```bash
# 查看详细日志
docker-compose logs oj-backend
docker-compose logs oj-frontend

# 检查磁盘空间
docker system df

# 清理无用镜像
docker system prune -a
```

### 权限问题

如果遇到权限问题，确保 `./data` 目录有正确的权限：

```bash
# Linux/Mac
sudo chmod -R 755 ./data
```

---

## 镜像标签说明

| 镜像 | 标签 | 说明 |
|------|------|------|
| kiffyowo/judge | v2.0 | 判题服务器 |
| kiffyowo/backend | v2.0 | 后端服务 |
| kiffyowo/frontend | v2.0 | 前端服务 |

如果需要发布新版本，修改标签为 `v2.1`、`v3.0` 等。

---

## 更新流程

当代码有更新时：

```bash
# 1. 重新构建并推送
.uild-and-push.ps1  # Windows
# 或
./build-and-push.sh    # Linux/Mac

# 2. 拉取新镜像并重启
docker compose pull
docker compose up -d
```

---

## 下一步

- 配置 HTTPS（生产环境建议）
- 设置定期备份
- 配置监控和日志收集
- 优化性能参数

有问题请参考：
- Docker 文档: https://docs.docker.com/
- Docker Compose 文档: https://docs.docker.com/compose/
