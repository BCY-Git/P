<script setup>
import { ref, onMounted, computed } from 'vue'
import { SuccessFilled, WarningFilled } from '@element-plus/icons-vue'
import CornerDecorator from '../common/CornerDecorator.vue'
import dict from '@/utils/dict'
const emit = defineEmits(['next'])
import axios from 'axios'
const branches = ref([])
const hasPlanned = ref(false)
const tableData = ref([])
const actionList = ref([])
const canViewInfo = computed(() => {
  return hasPlanned.value
})

const getChildrenNodes = () => {
  axios.get('/api/subtask/listNoPage').then(res => {
    console.log(res.data)
    branches.value = res.data
  })
}
onMounted(() => {
  getChildrenNodes()
})
const headerBottom = ref(135)
onMounted(() => {
  const el = document.querySelector('.header-renWuGuiHua')
  if (el) {
    const rect = el.getBoundingClientRect()
    headerBottom.value = Math.round(rect.bottom)
  }
})
const overlayStyle = computed(() => ({
  top: headerBottom.value + 'px',
  height: `calc(100vh - ${headerBottom.value}px - 10px)`
}))

function emitNext() {
  if (!canViewInfo.value) {
    return // 如果按钮被禁用，直接返回
  }
  emit('next')
}

function planAll() {
  branches.value.forEach(item => {
    item.isPlanned = true
  })
  hasPlanned.value = true
}

// 格式化时间函数 - 将时间字符串转换为日期对象用于日期选择器
const formatTimeForPicker = (timeStr) => {
  if (!timeStr) return null
  return new Date(timeStr)
}

// 从日期时间中提取小时和分钟
const extractHour = (timeStr) => {
  if (!timeStr) return ''
  const date = new Date(timeStr)
  return String(date.getHours()).padStart(2, '0')
}

const extractMinute = (timeStr) => {
  if (!timeStr) return ''
  const date = new Date(timeStr)
  return String(date.getMinutes()).padStart(2, '0')
}

// 将 actionType 映射为标签文本
const getActionTypeLabel = (actionType) => {
  if (!actionType) return ''

  // 处理多个值的情况（可能是数组或逗号分隔的字符串）
  let types = []
  if (Array.isArray(actionType)) {
    types = actionType
  } else if (typeof actionType === 'string' && actionType.includes(',')) {
    types = actionType.split(',').map(t => t.trim())
  } else {
    types = [actionType]
  }

  // 映射每个类型值到对应的标签
  const labels = types.map(type => {
    const typeNum = Number(type)
    return dict.actionStatusMap[typeNum] || `未知类型(${type})`
  })

  // 如果是多个值，用逗号连接
  return labels.join(', ')
}

// 获取 actionType 的显示值（用于下拉框）
const getActionTypeValue = (actionType) => {
  if (!actionType) return ''
  // 如果是多个值，取第一个作为显示值
  if (Array.isArray(actionType)) {
    return String(actionType[0] || '')
  } else if (typeof actionType === 'string' && actionType.includes(',')) {
    return String(actionType.split(',')[0].trim())
  }
  return String(actionType)
}

function handlePlan(id) {
  axios.get(`/api/action_listNoPage?subtaskId=${id}`)
    .then(res => {
      console.log('行动列表数据:', res.data)
      // 保持 actionType 的原始格式（可能是单个值、数组或逗号分隔的字符串）
      if (res.data && Array.isArray(res.data)) {
        actionList.value = res.data.map(item => ({
          ...item,
          // 保持 actionType 的原始格式，不进行转换
          actionType: item.actionType !== undefined && item.actionType !== null ? item.actionType : ''
        }))
      } else {
        actionList.value = []
      }
    })
    .catch(err => {
      console.error('获取行动列表失败:', err)
      actionList.value = []
    })
}
</script>

<template>
  <div class="guihua-overlay" :style="overlayStyle">
    <div class="guihua-dialog">
      <div class="dialog-body">
        <div class="mind-panel">

          <div class="mind-list">
            <el-table :data="branches" style="width: 100%">
              <el-table-column prop="index" label="序号" width="90">
                <template #default="scope">
                  <span class="col-1-2">{{ scope.row.id }}</span>
                </template>
              </el-table-column>
              <el-table-column prop="name" label="名称">
                <template #default="scope">
                  <span class="col-1-2" @click="handlePlan(scope.row.id)">{{ scope.row.subtaskName }}</span>
                </template>
              </el-table-column>
              <el-table-column prop="obstacle" label="障碍">
                <template #default="scope">
                  <div style="display: flex; align-items: center; gap: 8px; justify-content: center;">
                    <el-icon v-if="scope.row.isPlanned" color="#67c23a" size="18">
                      <SuccessFilled />
                    </el-icon>
                    <el-icon v-else color="#909399" size="18">
                      <WarningFilled />
                    </el-icon>
                    <span :style="{ color: scope.row.isPlanned ? '#67c23a' : 'white' }">
                      {{ scope.row.isPlanned ? '已规划' : '未规划' }}
                    </span>
                  </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </div>

        <div class="right"
          style="position: relative;height: 935px;overflow-y: auto;border: 2px solid rgb(103,135,183);">
          <div class="info-panel"
            style=" display: flex;flex-direction: column;gap: 20px;  margin-right: 20px;position: relative;">

            <div v-if="actionList.length === 0" class="warp"
              style="padding: 20px;text-align: center;color: rgba(255, 255, 255, 0.5);">
              <p>暂无行动数据，请点击左侧列表中的任务名称加载行动信息</p>
            </div>
            <div v-for="item in actionList" :key="item.id" class="warp"
              style="display: flex;flex-direction: column;gap: 20px;">

              <div class="right-content-header" style="display: flex;align-items: center;justify-content: center;">
                <p>{{ item.actionName }}</p>
              </div>
              <div class="right-content-box" style="display: flex;flex-direction: column;gap: 20px;padding: 0 20px;">
                <div class="right-content-1">
                  <div class="form-item-1">
                    <p style="width: 80px;color: white;">行动名称</p>
                    <el-input class="input-white" type="text" :value=item.actionName></el-input>
                  </div>
                  <div class="form-item-1">
                    <p style="width: 80px;color: white;">行动类型</p>
                    <!-- 如果是多个值，显示文本；如果是单个值，显示下拉框 -->
                    <template
                      v-if="Array.isArray(item.actionType) || (typeof item.actionType === 'string' && item.actionType.includes(','))">
                      <span
                        style="color: white; padding: 0 11px; line-height: 32px; display: inline-block; min-width: 200px;">
                        {{ getActionTypeLabel(item.actionType) }}
                      </span>
                    </template>
                    <el-select v-else :model-value="getActionTypeValue(item.actionType)" placeholder="请选择行动类型"
                      style="flex: 1;">
                      <el-option v-for="(label, key) in dict.actionStatusMap" :key="key" :label="label"
                        :value="String(key)">
                      </el-option>
                    </el-select>
                  </div>
                </div>
                <div class="right-content-1">
                  <div class="form-item-1">
                    <p style="width: 70px;color: white;">行动时间</p>
                    <el-date-picker type="datetime" placeholder="选择日期时间"
                      :model-value="formatTimeForPicker(item.startTime)" format="YYYY-MM-DD HH:mm:ss" />
                    <p style="color: white;">时</p><el-input type="text" style="width: 200px;"
                      :value="extractHour(item.startTime)"></el-input>
                    <p style="color: white;">分</p>
                    <p style="color: white;">至</p>
                    <el-date-picker type="datetime" placeholder="选择日期时间"
                      :model-value="formatTimeForPicker(item.endTime)" format="YYYY-MM-DD HH:mm:ss" />
                    <p style="color: white;">时</p><el-input type="text" style="width: 200px;"
                      :value="extractHour(item.endTime)"></el-input>
                    <p style="color: white;">分</p>
                  </div>

                </div>
                <div class="right-content-2" style="display: flex;align-items: center;">
                  <p style="width: 80px;color: white;">目标区域</p>
                  <div style="flex: 1;">
                    <table class="simple-table">
                      <thead>
                        <tr>
                          <th style="width:80px">序号</th>
                          <th>任务类型区域</th>
                          <th style="width:240px">操作</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>1</td>
                          <td>{{ item.area }}</td>
                          <td>
                            <el-button class="table-button" style="margin-right: 10px!important;">图上取点</el-button>
                            <el-button class="table-button">取消</el-button>
                          </td>
                        </tr>


                        <tr>
                          <td colspan="3"><el-button class="table-button">图上取点</el-button>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
                <div class="right-content-3" style="display: flex;flex-direction: column;gap: 20px;">
                  <div style="display: flex;align-items: center;">
                    <label style="width: 85px;color: white;">紧前行动</label> <el-input
                      :value="item.parentActionId"></el-input>
                  </div>

                  <div style="display: flex;align-items: center;">
                    <label style="width: 85px;color: white;">协同行动</label> <el-input class="input-white"
                      :value="item.siblingActionId"></el-input>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="button-group">
          <el-button @click="emitNext" :disabled="!canViewInfo"
            :class="{ 'disabled-button': !canViewInfo }">查看信息</el-button>
        </div>
        <div class="button-group2">
          <el-button @click="planAll">一件规划行动</el-button>
        </div>
      </div>
    </div>
  </div>
</template>



<style scoped>
.guihua-overlay {
  position: fixed;
  left: 0;
  right: 0;
  width: 100vw;
  background-color: transparent;
  z-index: 3006;
}

.guihua-dialog {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0px;
  top: 0;
  margin: 0;
  background-color: rgb(15, 30, 61);
}

.dialog-body {
  display: flex;
  height: 100%;
}

.mind-panel {
  width: 520px;
  display: flex;
  flex-direction: column;
  margin-right: 20px;
}

.panel-title {
  display: flex;
  align-items: center;
  gap: 8px;
  color: rgb(99, 170, 222);
  font-weight: bold;
  padding: 12px 0;
}

.icon {
  width: 20px;
  height: 20px;
}

.mind-list {
  flex: 1;
  padding: 10px;
  margin-left: 20px;
  border: 2px solid rgb(90, 109, 165);
  background-color: rgb(21, 29, 63);
  overflow: auto;
}

.col-1-2 {
  color: rgb(90, 166, 231);
}

.right {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-height: 0;
}

.info-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
  max-height: 875px;
}

.info-panel::-webkit-scrollbar {
  width: 6px;
  background-color: rgb(156, 178, 231);
}

.info-panel::-webkit-scrollbar-thumb {
  background: rgb(82, 113, 198);
}

.info-panel::-webkit-scrollbar-thumb:hover {
  background: rgb(75, 140, 200);
}

.panel-content {
  flex: 1;
  overflow-y: auto;
  padding: 0 6px 0 20px;
  min-height: 0;
}

.panel-content::-webkit-scrollbar {
  width: 6px;
  background-color: rgb(156, 178, 231);
}

.panel-content::-webkit-scrollbar-thumb {
  background: rgb(82, 113, 198);
}

.panel-content::-webkit-scrollbar-thumb:hover {
  background: rgb(75, 140, 200);
}

.button-group {
  position: absolute;
  bottom: 20px;
  right: 0px;
  transform: translateX(-50%);
  display: flex;
  gap: 10px;
  z-index: 3010;
}

.button-group :deep(.el-button) {
  width: 80px;
  height: 32px;
  background-color: rgb(11, 41, 115);
  border: 2px solid rgb(90, 109, 165);
  color: white;
}

.button-group :deep(.el-button.is-disabled) {
  background-color: rgb(11, 41, 115) !important;
  border-color: rgb(60, 80, 120) !important;
  color: rgba(255, 255, 255, 0.5) !important;
  cursor: not-allowed !important;
}

.button-group :deep(.el-button.is-disabled:hover) {
  background-color: rgb(11, 41, 115) !important;
  border-color: rgb(60, 80, 120) !important;
}

.button-group2 {
  position: absolute;
  bottom: 20px;
  left: 410px;
  display: flex;
  gap: 10px;
  z-index: 3010;
}

.button-group2 :deep(.el-button) {
  width: 100px;
  height: 32px;
  background-color: rgb(11, 41, 115);
  border: 2px solid rgb(90, 109, 165);
  color: white;
}
</style>
<style>
/* 思维导图表格样式 */
.mind-list .el-table {
  background-color: transparent !important;
}

.mind-list .el-table__header-wrapper {
  background-color: transparent !important;
}

.mind-list .el-table__body-wrapper {
  background-color: transparent !important;
}

.mind-list .el-table th {
  background-color: rgb(11, 41, 115) !important;
  color: white !important;
  font-size: 16px;
  text-align: center;
  border-bottom: 2px solid rgb(90, 109, 165) !important;
  border-top: none !important;
  border-left: none !important;
  border-right: none !important;
  height: 50px !important;
  line-height: 50px !important;
  padding: 0 !important;
}

.el-table--fit {
  border-right: 2px solid rgb(90, 109, 165) !important;
}

.mind-list .el-table td {
  background-color: transparent !important;
  color: white !important;
  text-align: center;
  border-bottom: 2px solid rgb(90, 109, 165) !important;
  border-top: none !important;
  border-left: none !important;
  border-right: none !important;
}

.mind-list .el-table__row:hover>td {
  background-color: rgba(20, 52, 120, 0.5) !important;
}

.mind-list .el-table::before {
  display: none !important;
}

.mind-list .el-table__inner-wrapper::before {
  display: none !important;
}

.el-table__row {
  background-color: rgba(20, 52, 120, 0.5) !important;
  height: 55px !important;
  font-size: 16px !important;
  font-weight: bold !important;
}

.el-table--fit {
  border: 2px solid rgb(90, 109, 165);
  max-height: 800px;
}




.right-content-header {
  height: 50px;
  background-color: rgb(11, 41, 115);
  color: white;
  font-size: 16px;
  font-weight: bold;
  text-align: center;
}

.right-content-1 {
  display: flex;
  gap: 20px;
}

.form-item-1 {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
}


.simple-table {
  width: 100%;
  border-collapse: collapse;
  background-color: transparent;
}

.simple-table th,
.simple-table td {
  border-top: 2px solid rgb(90, 109, 165);
  border-bottom: 2px solid rgb(90, 109, 165);
  border-left: none;
  border-right: none;
  color: white;
  padding: 6px 10px;
  text-align: center;
  line-height: 1.5;
}

.simple-table th {
  color: rgb(90, 170, 222) !important;
}

.simple-table thead th:first-child {
  border-left: 2px solid rgb(90, 109, 165);
}

.simple-table thead th:last-child {
  border-right: 2px solid rgb(90, 109, 165);
}

.simple-table tbody td:first-child {
  border-left: 2px solid rgb(90, 109, 165);
}

.simple-table tbody td:last-child {
  border-right: 2px solid rgb(90, 109, 165);
}

.simple-table thead th {
  background-color: rgb(11, 41, 115);
}

.simple-table tbody tr {
  background-color: transparent;
}

.table-button {
  width: 100px;
  height: 30px;
  background-color: rgb(11, 41, 115) !important;
  border: 2px solid rgb(90, 109, 165) !important;
  color: white !important;
}

/* 修改 el-input 的文字颜色 CSS 变量 - 使用非 scoped 样式确保生效 */
.guihua-dialog .el-input__wrapper {
  --el-input-text-color: white !important;
}

.guihua-dialog .el-input__inner {
  color: white !important;
}

.guihua-dialog .el-input__inner::placeholder {
  color: rgba(255, 255, 255, 0.6) !important;
}

/* 针对 input-white 类的特殊样式 */
.input-white .el-input__wrapper {
  --el-input-text-color: white !important;
}

.input-white .el-input__inner {
  color: white !important;
}

.input-white .el-input__inner::placeholder {
  color: rgba(255, 255, 255, 0.6) !important;
}

/* 通用 el-input 样式 */
.guihua-dialog .el-input .el-input__wrapper .el-input__inner {
  color: white !important;
}

/* 确保输入框和选择框可以点击 - 设置更高的 z-index */
.guihua-dialog .el-input,
.guihua-dialog .el-select,
.guihua-dialog .el-date-picker {
  position: relative;
  z-index: 10;
}

.guihua-dialog .el-input__wrapper,
.guihua-dialog .el-select__wrapper,
.guihua-dialog .el-date-editor {
  position: relative;
  z-index: 10;
}
</style>
