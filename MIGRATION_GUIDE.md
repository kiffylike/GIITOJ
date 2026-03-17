# XOJ-Pro 技术栈升级指南

## 概述

本文档提供将XOJ-Pro从当前技术栈升级到现代技术栈的详细指南。

## 当前状态

- ✅ 已更新docker-compose.yml使用你的镜像：`kiffyowo/judge:v2.0` 和 `kiffyowo/backend:v2.0`
- ✅ 已添加语言切换、深色模式和主题系统
- ⏳ 待完成：Vue 2 → Vue 3 + Vite迁移

---

## 一、使用当前镜像快速启动

由于你已经提供了预构建的镜像，可以直接使用：

```bash
# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

访问地址：http://localhost

---

## 二、Vue 2 → Vue 3 + Vite 完整迁移指南

### 2.1 项目结构重组

建议创建一个新的前端项目目录 `OnlineJudgeFE-v3`，逐步迁移：

```
OnlineJudgeFE-v3/
├── src/
│   ├── components/
│   ├── pages/
│   ├── store/
│   ├── router/
│   ├── i18n/
│   ├── styles/
│   ├── utils/
│   ├── App.vue
│   └── main.js
├── public/
├── index.html
├── vite.config.js
├── package.json
└── ...
```

### 2.2 依赖升级对照表

| 原依赖 (Vue 2) | 新依赖 (Vue 3) | 说明 |
|----------------|----------------|------|
| vue@^2.5.16 | vue@^3.4.x | Vue核心 |
| vue-router@^3.0.1 | vue-router@^4.2.x | 路由 |
| vuex@^3.0.1 | pinia@^2.1.x | 状态管理 (推荐Pinia) |
| vue-i18n@^7.7.0 | vue-i18n@^9.8.x | 国际化 |
| iview@^2.13.0 | view-ui-plus@^1.3.x | UI组件库 |
| element-ui@^2.3.7 | element-plus@^2.4.x | Element UI Vue3版本 |
| webpack@^3.6.0 | vite@^5.0.x | 构建工具 |
| babel-* | @vitejs/plugin-vue | Vue编译器 |

### 2.3 package.json 示例

```json
{
  "name": "onlinejudge-fe-v3",
  "version": "3.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .vue,.js,.jsx,.cjs,.mjs"
  },
  "dependencies": {
    "vue": "^3.4.21",
    "vue-router": "^4.2.5",
    "pinia": "^2.1.7",
    "vue-i18n": "^9.8.0",
    "view-ui-plus": "^1.3.17",
    "element-plus": "^2.4.4",
    "axios": "^1.6.2",
    "echarts": "^5.4.3",
    "highlight.js": "^11.9.0",
    "katex": "^0.16.9",
    "moment": "^2.29.4",
    "screenfull": "^6.0.2",
    "vue-clipboard3": "^2.0.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.2",
    "vite": "^5.0.10",
    "less": "^4.2.0",
    "eslint": "^8.55.0",
    "eslint-plugin-vue": "^9.19.2"
  }
}
```

### 2.4 vite.config.js 配置

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@oj': path.resolve(__dirname, './src/pages/oj'),
      '@admin': path.resolve(__dirname, './src/pages/admin')
    }
  },
  server: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/public': {
        target: 'http://localhost:8000',
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets'
  }
})
```

### 2.5 Vue 2 → Vue 3 语法变化

#### 2.5.1 组件注册变化

**Vue 2:**
```javascript
import Vue from 'vue'
import App from './App.vue'

new Vue({
  render: h => h(App)
}).$mount('#app')
```

**Vue 3:**
```javascript
import { createApp } from 'vue'
import App from './App.vue'

const app = createApp(App)
app.mount('#app')
```

#### 2.5.2 插件使用变化

**Vue 2:**
```javascript
import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)
```

**Vue 3:**
```javascript
import { createApp } from 'vue'
import VueRouter from 'vue-router'

const app = createApp(App)
app.use(VueRouter)
```

#### 2.5.3 Vuex → Pinia 迁移

**Vuex (旧):**
```javascript
// store/index.js
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: { count: 0 },
  mutations: {
    increment(state) { state.count++ }
  },
  actions: {
    incrementAsync({ commit }) {
      setTimeout(() => commit('increment'), 1000)
    }
  },
  getters: {
    doubleCount: state => state.count * 2
  }
})
```

**Pinia (新):**
```javascript
// stores/counter.js
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({ count: 0 }),
  getters: {
    doubleCount: (state) => state.count * 2
  },
  actions: {
    increment() {
      this.count++
    },
    async incrementAsync() {
      await new Promise(resolve => setTimeout(resolve, 1000))
      this.increment()
    }
  }
})
```

#### 2.5.4 组合式 API (Composition API)

**Vue 2 Options API:**
```javascript
export default {
  data() {
    return { count: 0 }
  },
  methods: {
    increment() {
      this.count++
    }
  },
  computed: {
    doubleCount() {
      return this.count * 2
    }
  }
}
```

**Vue 3 Composition API:**
```javascript
import { ref, computed } from 'vue'

export default {
  setup() {
    const count = ref(0)
    const doubleCount = computed(() => count.value * 2)
    
    const increment = () => {
      count.value++
    }
    
    return { count, doubleCount, increment }
  }
}
```

或者使用 `<script setup>` 语法糖：
```vue
<script setup>
import { ref, computed } from 'vue'

const count = ref(0)
const doubleCount = computed(() => count.value * 2)

const increment = () => {
  count.value++
}
</script>
```

#### 2.5.5 v-model 变化

**Vue 2:**
```vue
<ChildComponent v-model="value" />
<!-- 等同于 -->
<ChildComponent :value="value" @input="value = $event" />
```

**Vue 3:**
```vue
<ChildComponent v-model="value" />
<!-- 等同于 -->
<ChildComponent :modelValue="value" @update:modelValue="value = $event" />
```

#### 2.5.6 插槽 (Slots) 变化

**Vue 2:**
```vue
<template slot="header" slot-scope="{ data }">
  {{ data }}
</template>
```

**Vue 3:**
```vue
<template #header="{ data }">
  {{ data }}
</template>
```

### 2.6 iView → View UI Plus 迁移

View UI Plus 是 iView 的 Vue 3 版本：

```javascript
import ViewUIPlus from 'view-ui-plus'
import 'view-ui-plus/dist/styles/viewuiplus.css'

app.use(ViewUIPlus)
```

主要变化：
- 组件名前缀从 `i-` 改为无前缀（如 `i-button` → `Button`）
- 部分 API 有调整，参考官方文档

### 2.7 Element UI → Element Plus 迁移

```javascript
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

app.use(ElementPlus)
```

---

## 三、后端升级说明

由于你已经使用 `kiffyowo/backend:v2.0`，假设该镜像已经包含：

- Python 3.12+
- Django 4.2 LTS 或 5.0
- 最新的依赖包

如果需要自定义，可以修改 `OnlineJudge-master/Dockerfile` 和 `requirements.txt`。

### 3.1 Django 3.2 → 4.2 升级要点

1. **Python版本要求**: Django 4.2 需要 Python 3.8+
2. **URLconf变化**: `path()` 成为主要方式
3. **数据库迁移**: 运行 `python manage.py migrate`
4. **中间件更新**: 检查自定义中间件兼容性
5. **模板变化**: 一些模板标签和过滤器有变化

---

## 四、分步迁移策略

### 阶段 1: 准备工作
- [ ] 创建新的前端项目目录
- [ ] 初始化 Vite + Vue 3 项目
- [ ] 复制静态资源文件
- [ ] 设置路径别名和代理

### 阶段 2: 核心基础设施
- [ ] 迁移路由配置 (Vue Router 4)
- [ ] 迁移状态管理 (Pinia)
- [ ] 迁移国际化 (vue-i18n 9)
- [ ] 配置主题系统

### 阶段 3: 组件迁移
- [ ] 迁移通用组件
- [ ] 迁移页面组件
- [ ] 更新 UI 组件库 (View UI Plus / Element Plus)
- [ ] 测试每个组件功能

### 阶段 4: 集成测试
- [ ] 端到端测试
- [ ] 性能优化
- [ ] 构建和部署测试

---

## 五、保留现有功能

在迁移过程中，确保保留我们已实现的功能：

1. ✅ 语言切换 (简体中文 / English)
2. ✅ 深色/浅色模式切换
3. ✅ 6种主题系统 (默认、GitHub、VS Code、Material、赛博朋克、二次元)
4. ✅ 设置持久化到 localStorage

---

## 六、参考资源

- [Vue 3 迁移指南](https://v3-migration.vuejs.org/)
- [Vue Router 4 迁移指南](https://router.vuejs.org/guide/migration/)
- [Pinia 文档](https://pinia.vuejs.org/)
- [Vite 文档](https://cn.vitejs.dev/)
- [View UI Plus 文档](https://www.iviewui.com/view-ui-plus)
- [Element Plus 文档](https://element-plus.org/)

---

##### 七、快速开始 (使用现有镜像)

如果你只想使用当前已更新的功能（无需完整迁移）：

```bash
# 1. 启动服务
docker compose up -d

# 2. 访问应用
# 打开浏览器访问 http://localhost

# 3. 体验新功能
# - 右上角语言切换
# - 主题选择 (6种主题)
# - 深色/浅色模式切换
```

---

## 需要帮助？

如果在迁移过程中遇到问题，可以：
1. 参考官方迁移文档
2. 逐步迁移，每个阶段测试
3. 使用 git 分支管理迁移过程
