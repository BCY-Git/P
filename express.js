import express from 'express';
import cors from 'cors';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import os from 'os';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const app = express();
const port = 3000;

// 启用 CORS
app.use(cors());

// 解析 JSON 请求体
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 静态文件服务 - 提供图片资源
app.use('/images', express.static(path.join(__dirname, 'public/images')));

// 读取 u-db.json 数据
const dbPath = path.join(__dirname, 'u-db.json');
let dbData = {};

// 加载数据库
function loadDB() {
  try {
    const data = fs.readFileSync(dbPath, 'utf8');
    dbData = JSON.parse(data);
    console.log('数据库加载成功');
    console.log('可用数据键:', Object.keys(dbData));
  } catch (error) {
    console.error('读取数据库文件失败:', error.message);
    console.error('文件路径:', dbPath);
    dbData = {};
  }
}

// 初始化加载数据库
loadDB();

// 根路由
app.get('/', (req, res) => {
    res.send('Hello XRKJ');
});

// 图像识别列表接口（无分页）
app.get('/discern/ListNoPage', (req, res) => {
  try {
    const data = dbData.discern_images?.data || dbData.discern_ListNoPage || [];
    console.log(`[GET] /discern_ListNoPage - 返回 ${data.length} 条数据`);
    res.json({
      status: 0,
      msg: 'success',
      data: data
    });
  } catch (error) {
    console.error('获取图像识别列表失败:', error);
    res.status(500).json({
      status: 1,
      msg: '服务器错误',
      data: null
    });
  }
});

// 图像标注详情接口
app.get('/discern/labeling', (req, res) => {
  try {
    const { id } = req.query;
    console.log(`[GET] /discern/labeling?id=${id}`);
    const list = dbData.discern_ListNoPage || [];
    const item = list.find(item => item.id == id);
    
    if (item) {
      res.json({
        status: 0,
        msg: 'success',
        data: item
      });
    } else {
      console.log(`未找到 id=${id} 的数据`);
      res.json({
        status: 1,
        msg: '未找到数据',
        data: null
      });
    }
  } catch (error) {
    console.error('获取图像标注详情失败:', error);
    res.status(500).json({
      status: 1,
      msg: '服务器错误',
      data: null
    });
  }
});

// 子任务列表接口（无分页）
app.get('/subtask/listNoPage', (req, res) => {
  const data = dbData.subtask_listNoPage || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 子任务详情接口
app.get('/subtask/:id', (req, res) => {
  const { id } = req.params;
  const list = dbData.subtask_listNoPage || [];
  const item = list.find(item => item.id == id);
  
  if (item) {
    res.json({
      status: 0,
      msg: 'success',
      data: item
    });
  } else {
    res.json({
      status: 1,
      msg: '未找到数据',
      data: null
    });
  }
});

// 任务列表接口
app.get('/task/nowList', (req, res) => {
  const data = dbData.task_nowList || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 任务详情接口
app.get('/task/:id/details', (req, res) => {
  const { id } = req.params;
  const list = dbData.task_nowList || [];
  const item = list.find(item => item.id == id);
  
  if (item) {
    res.json({
      status: 0,
      msg: 'success',
      data: item
    });
  } else {
    res.json({
      status: 1,
      msg: '未找到数据',
      data: null
    });
  }
});

// 方案列表接口（无分页）
app.get('/scheme_listNoPage', (req, res) => {
  const data = dbData.scheme_listNoPage || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 删除方案接口
app.delete('/scheme/:id', (req, res) => {
  const { id } = req.params;
  res.json({
    status: 0,
    msg: '删除成功',
    data: null
  });
});

// 行动列表接口（无分页）
app.get('/action_listNoPage', (req, res) => {
  const { subtaskId } = req.query;
  const data = dbData.action_listNoPage || [];
  const filtered = subtaskId ? data.filter(item => item.subtaskId == subtaskId) : data;
  res.json({
    status: 0,
    msg: 'success',
    data: filtered
  });
});

// 设备权限列表接口（无分页）
app.get('/equipPermission_listNoPage', (req, res) => {
  const data = dbData.equipPermission_listNoPage || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 设备控制列表接口（无分页）
app.get('/equipControl_listNoPage', (req, res) => {
  const data = dbData.equipControl_listNoPage || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 子任务详情列表接口
app.get('/subtask_listNoPageDetail', (req, res) => {
  const data = dbData.subtask_listNoPageDetail || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 行动预案列表接口
app.get('/actionPrePlan_list', (req, res) => {
  const data = dbData.actionPrePlan_list || [];
  res.json({
    status: 0,
    msg: 'success',
    data: data
  });
});

// 404 处理 - 必须在所有路由之后
app.use((req, res) => {
  res.status(404).json({
    status: 1,
    msg: '接口不存在',
    data: null
  });
});

// 错误处理中间件 - 必须在最后，且需要4个参数
app.use((err, req, res, next) => {
  console.error('服务器错误:', err.stack);
  res.status(err.status || 500).json({
    status: 1,
    msg: err.message || '服务器错误',
    data: null
  });
});

// 获取本机 IP 地址
function getLocalIP() {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      // 跳过内部（即 127.0.0.1）和非 IPv4 地址
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return 'localhost';
}

app.listen(port, '0.0.0.0', () => {
    const localIP = getLocalIP();
    console.log(`Server is running on port ${port}`);
    console.log(`本地访问: http://localhost:${port}`);
    console.log(`局域网访问: http://${localIP}:${port}`);
    console.log(`API 服务已启动`);
});