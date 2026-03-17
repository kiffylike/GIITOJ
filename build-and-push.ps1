# XOJ-Pro 构建和推送脚本 (PowerShell)
# 使用方法: .\build-and-push.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  XOJ-Pro Docker 构建和推送" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 是否运行
Write-Host "[1/5] 检查 Docker 状态..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "✓ Docker 正在运行" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    exit 1
}

# 登录 Docker Hub
Write-Host ""
Write-Host "[2/5] 登录 Docker Hub..." -ForegroundColor Yellow
docker login
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker Hub 登录失败" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Docker Hub 登录成功" -ForegroundColor Green

# 构建所有镜像
Write-Host "[3/5] 开始构建镜像..." -ForegroundColor Yellow
docker compose -f docker-compose.build.yml build
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 镜像构建失败" -ForegroundColor Red
    exit 1
}
Write-Host "✓ 所有镜像构建成功" -ForegroundColor Green

# 推送所有镜像
Write-Host ""
Write-Host "[4/5] 开始推送镜像到 Docker Hub..." -ForegroundColor Yellow
docker compose -f docker-compose.build.yml push
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 镜像推送失败" -ForegroundColor Red
    exit 1
}
Write-Host "✓ 所有镜像推送成功" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  构建和推送完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "镜像已推送到：" -ForegroundColor White
Write-Host "  - kiffyowo/judge:v2.0" -ForegroundColor Gray
Write-Host "  - kiffyowo/backend:v2.0" -ForegroundColor Gray
Write-Host "  - kiffyowo/frontend:v2.0" -ForegroundColor Gray
Write-Host ""
Write-Host "现在可以运行: docker-compose up -d" -ForegroundColor Cyan
