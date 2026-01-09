# PZ-WEB 项目

全栈项目，包含前端（Vue 3）和后端（Express）代码。

## 项目结构

```
PZ-WEB/
├── client/          # 前端代码（Vue 3 + Vite）
│   ├── src/         # 源代码
│   ├── public/      # 静态资源
│   └── package.json # 前端依赖
├── server/          # 后端代码（Express）
│   ├── express.js   # Express 服务器
│   ├── u-db.json    # 数据库文件
│   └── package.json # 后端依赖
└── package.json     # 根配置文件
```

## 安装依赖

### 安装所有依赖
```bash
npm run install:all
```

### 只安装前端依赖
```bash
npm run install:client
```

### 只安装后端依赖
```bash
npm run install:server
```

## 运行项目

### 运行前端开发服务器
```bash
npm run dev:client
# 或
npm run dev
```

### 运行后端服务器
```bash
npm run dev:server
```

## 构建项目

### 构建前端
```bash
npm run build:client
# 或
npm run build
```

## 开发说明

- 前端运行在：`http://localhost:5173` (Vite 默认端口)
- 后端运行在：`http://localhost:3000`
- 前端通过 `/api` 代理请求到后端服务器
