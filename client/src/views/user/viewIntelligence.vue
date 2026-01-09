<template>
    <el-button type="primary" @click="openDialog">
        图像标注录入
    </el-button>
    <main v-show="open" class="annotator-container">
        <div class="annotator-container-header">
            <div style="color: #cfe6f7;margin:8px 20px;font-size: 18px;display: flex;align-items: center;gap: 8px;">
                <img src="/p.png" alt="" style="width: 20px;height: 20px;">
                <p>图像标注录入</p>
            </div>
            <div style="color: #cfe6f7;margin:8px 20px;font-size: 18px;display: flex;align-items: center;gap: 8px;">
                <el-icon>
                    <Close />
                </el-icon>
            </div>
        </div>

        <div class="annotator">
            <div class="sidebar">
                <div class="sidebar-title">
                    <img src="/p.png" alt="">
                    <p>照片墙</p>
                </div>

                <div class="date-group" v-for="group in groups" :key="group.date">
                    <div class="date-title">
                        <p>{{ group.date }}</p>
                    </div>
                    <el-scrollbar class="file-list">
                        <div class="file-item" v-for="f in group.files" :key="f.name"
                            :class="{ active: isActive(group.date, f.name) }" @click="select(group.date, f.name)">
                            <img class="file-thumbnail" :src="f.url || getPlaceholderImage(f.name)" :alt="f.name" @error="handleImageError" />
                            <span class="dot" :class="{ ok: f.ok }"></span>
                            <span class="name">{{ f.name }}</span>
                        </div>
                    </el-scrollbar>
                </div>
            </div>
            <div class="main">
                <div class="toolbar">
                    <el-icon @click="prev">
                        <ArrowLeft />
                    </el-icon>
                    <el-icon @click="next" style="margin-left: -10px!important">
                        <ArrowRight />
                    </el-icon>
                    <el-icon>
                        <Files />
                    </el-icon>
                    <el-icon>
                        <Document />
                    </el-icon>
                    <el-icon>
                        <Rank />
                    </el-icon>
                    <el-icon>
                        <Location />
                    </el-icon>
                    <el-icon>
                        <Monitor />
                    </el-icon>
                </div>
                <div class="viewer">
                    <img :src="currentImage" class="preview" />
                </div>
            </div>
            <div class="right">
                <el-card class="info-card" shadow="never">
                    <div class="info-header">
                        <div class="info-header-item1">
                            <img src="/p.png" alt="">
                            <span>图片信息</span>
                        </div>

                        <el-button type="primary" size="small">导入摄像参数</el-button>
                    </div>
                    <div class="info-body">
                        <p>暂无图片数据</p>
                    </div>
                </el-card>
                <div class="table-card" shadow="never">
                    <div class="table-title">
                        <img class="icon" src="/p.png" alt="">
                        <p>检测物体</p>
                    </div>
                    <div class="custom-table">
                        <div class="table-header">
                            <div class="header-cell" style="width: 80px;">序号</div>
                            <div class="header-cell" style="width: 140px;">名称</div>
                            <div class="header-cell" style="width: 120px;">类型</div>
                            <div class="header-cell" style="width: 120px;">损伤</div>
                            <div class="header-cell" style="width: 80px;">修改</div>
                            <div class="header-cell" style="width: 80px;">删除</div>
                        </div>
                        <div class="table-body" v-if="objects.length" style="max-height: 490px; overflow-y: auto;overflow-x: hidden;">
                            <div class="table-row" v-for="(row, index) in objects" :key="index">
                                <div class="table-cell" style="width: 60px;">{{ index + 1 }}</div>
                                <div class="table-cell" style="width: 140px;">{{ row.name }}</div>
                                <div class="table-cell" style="width: 120px;">{{ row.type }}</div>
                                <div class="table-cell" style="width: 120px;">{{ row.damage }}</div>
                                <div class="table-cell" style="width: 80px;">
                                    <el-icon @click="edit(row)" size="20" color="aqua">
                                            <Edit />
                                    </el-icon>
                                </div>
                                <div class="table-cell" style="width: 80px;">
                                    <el-button text type="danger" @click="remove(index)"><el-icon size="20" color="red">
                                            <Delete />
                                        </el-icon></el-button>
                                </div>
                            </div>
                        </div>
                        <div v-else style="height: 200px; display:flex; align-items:center; justify-content:center; color:#9aa7b8;">
                          暂无检测数据
                        </div>
                    </div>
                    <el-button class="btn" type="primary" @click="add">一键分发</el-button>
                </div>
            </div>
        </div>
    </main>

</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ArrowLeft, ArrowRight, Plus, Star, View, QuestionFilled, Edit, Delete, Files } from '@element-plus/icons-vue'
import axios from 'axios' 

const open = ref(true)
const openDialog = async () => {
    open.value = true
    await fetchDiscernImages()
}

const groups = ref([])

const current = ref({ date: '', name: '' })
const isActive = (d, n) => current.value.date === d && current.value.name === n
const select = async (d, n) => {
  current.value = { date: d, name: n }
  const id = imageIdByName.value[n]
  if (id != null) {
    await fetchLabelingById(id)
  } else {
    objects.value = []
  }
}

const handleImageError = (e) => {
  // 如果图片加载失败，使用占位符
  const alt = e.target.alt || '图片'
  e.target.src = `https://via.placeholder.com/100x100?text=${encodeURIComponent(alt)}`
}
const flatFiles = computed(() => groups.value.flatMap(g => g.files.map(f => ({ date: g.date, name: f.name }))))
const idx = computed(() => flatFiles.value.findIndex(f => f.date === current.value.date && f.name === current.value.name))
const prev = () => { const i = idx.value; if (i > 0) current.value = flatFiles.value[i - 1] }
const next = () => { const i = idx.value; if (i < flatFiles.value.length - 1) current.value = flatFiles.value[i + 1] }

const getPlaceholderImage = (name) => {
  return `https://via.placeholder.com/900x500?text=${encodeURIComponent(name || '图片')}`
}

const currentImage = computed(() => {
  const g = groups.value.find(g => g.date === current.value.date)
  const f = g?.files.find(f => f.name === current.value.name)
  // 优先使用 https URL，如果没有则使用占位符
  return f?.url || getPlaceholderImage(current.value.name)
})
const objects = ref([
    { name: '目标A', type: '智能', damage: '轻微' },
    { name: '目标B', type: '智能', damage: '一般' },
    { name: '目标C', type: '智能', damage: '严重' },
    { name: '目标D', type: '智能', damage: '轻微' },
    { name: '目标E', type: '智能', damage: '一般' },
    { name: '目标F', type: '智能', damage: '严重' },
    { name: '目标G', type: '智能', damage: '轻微' },
    { name: '目标H', type: '智能', damage: '一般' },
    { name: '目标I', type: '智能', damage: '严重' },
    { name: '轨迹A', type: '智能', damage: '严重' },
    { name: '目标G', type: '智能', damage: '轻微' },
    { name: '目标H', type: '智能', damage: '一般' },
    { name: '目标I', type: '智能', damage: '严重' },
])

const edit = (row) => {

}
const remove = (i) => objects.value.splice(i, 1)

const imageIdByName = ref({})

// 构建完整的图片 URL
const buildImageUrl = (discernImageURL) => {
  if (!discernImageURL) return ''
  // 如果已经是完整的 URL（以 http:// 或 https:// 开头），直接返回
  if (discernImageURL.startsWith('http://') || discernImageURL.startsWith('https://')) {
    return discernImageURL
  }
  // 如果 discernImageURL 以 / 开头，说明是相对路径，需要拼接域名
  // 这里可以根据实际情况修改基础域名
  // 如果 discernImageURL 是 "/DJI_0038.jpg"，拼接成 "http://域名/DJI_0038.jpg"
  if (discernImageURL.startsWith('/')) {
    // 可以根据实际情况配置基础 URL，例如从环境变量或配置中获取
    // 暂时使用当前域名，或者可以根据实际情况修改
    const baseUrl = '' // 如果需要，可以在这里配置基础 URL，例如 'http://example.com'
    return baseUrl ? `${baseUrl}${discernImageURL}` : `http://${discernImageURL.slice(1)}`
  }
  // 否则直接拼接 http:// + discernImageURL
  return `http://${discernImageURL}`
}

const fetchDiscernImages = async () => {
  try {
    const res = await axios.get('/discern_ListNoPage')
    const list = Array.isArray(res?.data?.data) ? res.data.data : []
    
    // 按日期分组
    const groupsMap = new Map()
    
    list.forEach(item => {
      const discernImageURL = item.discernImageURL || ''
      // 构建完整的图片 URL
      const url = buildImageUrl(discernImageURL)
      // 从 URL 或文件名提取名称
      const name = discernImageURL ? (discernImageURL.split('/').pop() || `图片${item.id}`) : `图片${item.id}`
      
      imageIdByName.value[name] = item.id
      
      // 获取日期（如果有日期字段，否则使用当前日期）
      const dateStr = item.date || item.createTime || new Date().toISOString().slice(0, 10)
      
      if (!groupsMap.has(dateStr)) {
        groupsMap.set(dateStr, [])
      }
      
      groupsMap.get(dateStr).push({ name, ok: true, url })
    })
    
    // 转换为数组格式，按日期倒序排列
    groups.value = Array.from(groupsMap.entries())
      .map(([date, files]) => ({ date, files }))
      .sort((a, b) => b.date.localeCompare(a.date))
    
    // 初始化 current
    if (groups.value.length > 0 && groups.value[0].files.length > 0) {
      current.value = { date: groups.value[0].date, name: groups.value[0].files[0].name }
    }
  } catch (e) {
    console.error('获取图片列表失败:', e)
    // 可根据需要添加错误提示
  }
}

// 组件挂载时，如果对话框默认打开，则加载数据
onMounted(() => {
  if (open.value) {
    fetchDiscernImages()
  }
})

const mapDamage = (d) => {
  const m = { 0: '无', 1: '轻微', 2: '一般', 3: '严重' }
  return m[d] ?? String(d ?? '')
}

const fetchLabelingById = async (id) => {
  try {
    const res = await axios.get('/discern/labeling', { params: { id } })
    const raw = Array.isArray(res?.data?.data) ? res.data.data[0] : res?.data?.data
    if (!raw) { objects.value = []; return }
    const name = raw.frontLength ? (raw.frontLength.split('/').pop() || `图片${raw.id}`) : `图片${raw.id}`
    const type = raw.type || String(raw.obstacleForm ?? '')
    const damage = mapDamage(raw.damageDegree)
    objects.value = [{ name, type, damage }]
  } catch (e) {
    objects.value = []
  }
}
</script>

<style scoped lang="scss">
$border-color: #768ec0;
$title-color: #4477D0;
$background-color: #172545;

.annotator-container {
    display: flex;
    flex-direction: column;
    background-color: #13264f;
    margin: auto;
    width: 70vw;
    height: 80vh;

    .annotator-container-header {
        display: flex;
        justify-content: space-between;
    }

    .annotator {
        display: flex;
        gap: 8px;
        height: 100vh;
        padding: 8px;
        box-sizing: border-box;

        .sidebar {
            width: 200px;
            background: $background-color;
            color: #cfe6f7;
            overflow: auto;
            padding: 8px;
            border: 2px solid $border-color;

            .sidebar-title {
                display: flex;
                align-items: center;
                gap: 8px;

                img {
                    width: 20px;
                    height: 20px;
                }

                p {
                    color: $title-color;
                }
            }

            .date-title {
                font-weight: 600;
                margin: 8px 0;
                background: linear-gradient(100deg, #1b76ee 0%, #29cdff 100%);
                height: 50px;
                text-align: center;
                display: flex;
                align-items: center;

                p {
                    color: white;
                    font-size: 16px;
                    margin: auto;
                }
            }

            .file-list {
                max-height: 300px;
            }

            .file-item {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 6px 8px;
                cursor: pointer;
                border-radius: 4px;
                transition: background 0.2s;

                &:hover {
                    background: #444;
                    transform: scale(1.05);
                }

                &.active {
                    background: #666;
                }

                .file-thumbnail {
                    width: 40px;
                    height: 40px;
                    object-fit: cover;
                    border-radius: 4px;
                    border: 1px solid $border-color;
                }

                .dot {
                    width: 8px;
                    height: 8px;
                    border-radius: 50%;
                    background: #888;

                    &.ok {
                        background: #3ec46d;
                    }
                }

                .name {
                    color: #eaf6ff;
                    font-size: 13px;
                    flex: 1;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }
            }
        }

        .main {
            flex: 1 1 0;
            min-width: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;

            .toolbar {
                display: flex;
                align-items: center;
                gap: 30px;
                padding: 6px 8px;
                border: 1px solid $border-color;
                background: $background-color;

                .el-icon {
                    padding: 8px;
                    font-size: 20px;
                    cursor: pointer;
                }

                .el-icon:hover {
                    transition: transform 0.3s ease-in-out;
                    transform: translateX(2px);
                    background-color: $border-color;

                }

                .el-icon {
                    color: #64c3ed;
                    font-size: 25px;
                }



            }

            .viewer {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                background: #1f2937;
                border-radius: 6px;
                img{
                    width: 100%;
                    height: 100%;
                }
                .preview {
                    max-width: 100%;
                    max-height: 100%;
                    object-fit: contain;
                }
            }
        }

        .right {
            width: 400px;
            display: flex;
            flex-direction: column;
            gap: 8px;

            :deep(.el-card__body) {
                padding: 0 !important;
            }

            .info-card {
                height: 180px;
                background: $background-color;
                border-radius: 0;
                border: 2px solid $border-color;

                .info-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 8px;

                    .info-header-item1 {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        margin-left: 10px;

                        img {
                            width: 20px;
                            height: 20px;
                        }
                    }

                    :deep(.el-button) {
                        background: #0b2974;
                        padding: 4px 8px !important;
                        margin: 10px !important;
                        border: 2px solid $border-color;
                    }

                    span {
                        color: #4477D0;

                    }
                }

                .info-body {
                    color: #666;
                    font-size: 13px;
                    text-align: center;
                    margin-top: 50px;
                    font-size: 16px;
                }
            }

            .table-card {
                border: 2px solid $border-color;
                height: 570px;

                .table-title {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin: 10px;

                    img {
                        width: 20px;
                        height: 20px;
                    }

                    p {
                        color: $title-color;
                    }
                }

                .btn {
                    margin: 10px 0 0 322px !important;
                    background: #0b2974;
                    border: 2px solid $border-color;
                    padding: 4px 8px !important;

                    &:hover {
                        transition: transform 0.3s ease-in-out;
                        transform: scale(1.05);
                        background-color: #666;
                    }
                }

            }

            .custom-table {
                display: flex;
                flex-direction: column;

                .table-header {
                    display: flex;
                    background: #0b216c;
                    border-bottom: 1px solid $border-color;

                    .header-cell {
                        padding: 8px 12px;
                        font-weight: 600;
                        color: $title-color;
                        text-align: center;

                        &:last-child {
                            border-right: none;
                        }
                    }
                }

                .table-body {
                    flex: 1;
                    overflow-y: auto;

                    .table-row {
                        display: flex;
                        border-bottom: 1px solid $border-color;
                        transition: transform 0.3s ease-in-out;
                        box-sizing: border-box;

                        &:hover {
                            background: #27404e;
                            transform: scale(1.02);
                        }

                        .table-cell {
                            color: white;
                            padding: 5px 10px;
                            text-align: center;
                            display: flex;
                            align-items: center;
                            justify-content: center;

                            &:last-child {
                                border-right: none;
                            }

                            .el-button {
                                padding: 4px 8px;
                                font-size: 12px;
                            }
                        }
                    }
                }
            }
        }
    }
}


.table-body::-webkit-scrollbar {
    width: 2px;
    /* 滚动条宽度 */
}

.table-body::-webkit-scrollbar-track {
    background: transparent;
    /* 轨道 */
}

.table-body::-webkit-scrollbar-thumb {
    background-color: #409eff;
    /* 滑块颜色 */
    border-radius: 4px;
}

.table-body::-webkit-scrollbar-thumb:hover {
    background-color: #66b1ff;
}
</style>
