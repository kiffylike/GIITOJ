# XOJ-Pro 架构更新说明

## 更新内容概览

### 1. 前端功能增强

#### 语言切换
- 默认语言改为中文（zh-CN）
- 支持简体中文、英文切换
- 语言选择持久化到localStorage

#### 深色/浅色模式切换
- 支持一键切换深色/浅色模式
- 模式选择持久化到localStorage
- 平滑的颜色过渡动画

#### 主题系统
- 内置6种流行主题：
  - 默认主题（蓝色系）
  - GitHub主题（灰蓝系）
  - VS Code主题（蓝黑系）
  - Material Design主题（紫色系）
  - 赛博朋克主题（霓虹粉青系）
  - 二次元主题（粉色系）
- 每个主题都支持深色和浅色模式
- 主题选择持久化到localStorage

### 2. 技术栈更新

#### Docker配置更新
- Redis: 4.0-alpine → 7-alpine
- PostgreSQL: 10-alpine → 16-alpine
- Docker Compose版本: 3 → 3.8
- 添加本地构建支持，可以从源码构建镜像

## 文件变更列表

### 前端 (OnlineJudgeFE-master)

1. `src/store/types.js` - 添加新的mutation类型
2. `src/store/index.js` - 添加主题和语言状态管理
3. `src/i18n/index.js` - 默认语言改为中文，调整语言顺序
4. `src/pages/oj/index.js` - 添加主题和语言初始化
5. `src/pages/oj/components/NavBar.vue` - 添加语言、主题、深色模式切换UI
6. `src/styles/themes.less` - 新建主题样式文件
7. `src/styles/index.less` - 引入主题样式

### 根目录

1. `docker-compose.yml` - 新建Docker Compose配置文件
2. `UPDATE.md` - 本文档

## 运行方式

### 使用Docker Compose运行

```bash
# 构建并启动所有服务
docker-compose up -d --build

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 访问地址

- 前端: http://localhost
- 后端API: http://localhost/api

## 注意事项

1. 首次运行需要初始化数据库
2. 请修改docker-compose.yml中的TOKEN和JUDGE_SERVER_TOKEN为安全值
3. 数据存储在`./data`目录下，删除前请备份
4. 前端主题和语言设置保存在浏览器localStorage中

## 未来改进方向

1. 升级Vue 2.x到Vue 3.x
2. 升级Webpack 3到Vite或Webpack 5
3. 添加更多主题选项
4. 支持自定义主题颜色
5. 升级后端Python和Django版本
