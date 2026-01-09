<script setup>
import { ref, provide, computed, onMounted, onUnmounted } from 'vue';
import { ElMessage } from 'element-plus';
import daoHangLan from './daoHangLan.vue';
import axios from 'axios';
import Pozhang from '@/components/breachPlanSeat/pozhang_T.vue'
import GuiHuaXingDong from '@/components/breachPlanSeat/guiHuaXingDong_T.vue'
import ChaKanXinXi from '@/components/breachPlanSeat/chaKanXinXi_T.vue'

// ========== POST请求配置 ==========
// 请在此处填写确定按钮点击后的POST请求地址
const CONFIRM_REQUEST_URL = ''; // TODO: 请填写POST请求地址，例如: '/api/task/confirm'
// =================================

const taskDetails = ref({});
const emit = defineEmits(['close']);
const value1 = ref(false);
const taskList = ref([]);

const getTaskList = () => {
  axios.get('/api/task_nowList').then(res => {
    console.log(res.data)
    taskList.value = res.data;
  })
}
let timer = null;

onMounted(() => {
  getTaskList();
  timer = setInterval(() => {
    getTaskList();
  }, 100000);
});

onUnmounted(() => {
  clearInterval(timer);
});

// 时间线状态管理
const timelineState = ref({
  step1: true, // 任务管理（任务弹窗激活）
  step2: false, // 任务分解分配（受领>规划>确定后进入pozhang）
  step3: false  // 作战规划（pozhang点击下一步）
});

// 提供时间线状态给子组件
provide('timelineState', timelineState);

// 受领状态管理（track每个任务是否已受领，key为任务索引）
const receivedTasks = ref({});

// 接收时间管理（track每个任务的接收时间，key为任务id）
const receiveTimes = ref({});

// 格式化时间为 YYYY-MM-DD HH:mm:ss
const formatDateTime = (date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 从时间字符串中提取日期部分（用于日期选择器）
const extractDate = (timeStr) => {
  if (!timeStr) return null;
  try {
    const date = new Date(timeStr);
    return isNaN(date.getTime()) ? null : date;
  } catch {
    return null;
  }
};

// 从时间字符串中提取小时
const extractHourFromTime = (timeStr) => {
  if (!timeStr) return '';
  try {
    const date = new Date(timeStr);
    return isNaN(date.getTime()) ? '' : String(date.getHours()).padStart(2, '0');
  } catch {
    return '';
  }
};

// 从时间字符串中提取分钟
const extractMinuteFromTime = (timeStr) => {
  if (!timeStr) return '';
  try {
    const date = new Date(timeStr);
    return isNaN(date.getTime()) ? '' : String(date.getMinutes()).padStart(2, '0');
  } catch {
    return '';
  }
};

// 弹窗状态
const showPlanDialog = ref(false);
const showPozhangDialog = ref(false);
const showGuiHuaXingDongDialog = ref(false);
const showChaKanXinXiDialog = ref(false);
const planForm = ref({
  input1: '',
  input2: '',
  input3: ''
});

// 日期选择器临时值
const tempDateValue = ref(null);

// 受领按钮点击事件
const handleReceive = (taskId) => {
  // 记录受领状态（使用任务id作为key）
  receivedTasks.value[taskId] = true;
  // 记录接收时间
  receiveTimes.value[taskId] = formatDateTime(new Date());
  axios.get(`/api/task/${taskId}/details`).then(res => {
    console.log("受领了", res.data)
    taskDetails.value = res.data;
  })
};

const openChaKanXinXi = () => {
  showChaKanXinXiDialog.value = true;
};
// 计算已受领的任务列表
const receivedTaskList = computed(() => {
  return taskList.value.filter(item => receivedTasks.value[item.id]);
});

// 规划按钮点击事件
const handlePlan = () => {
  showPlanDialog.value = true;
};

// 日期确认事件
const handleDateConfirm = (val) => {
  console.log('日期确认:', val);
  if (val) {
    tempDateValue.value = val;
  }
};

// 关闭弹窗
const closePlanDialog = () => {
  showPlanDialog.value = false;
  // 重置表单
  planForm.value = {
    input1: '',
    input2: '',
    input3: ''
  };
  // 重置临时日期值
  tempDateValue.value = null;
};

// 确定按钮点击事件
const handleConfirm = () => {
  console.log('点击确认按钮', planForm.value);
  // 将临时日期值保存到表单中
  if (tempDateValue.value) {
    planForm.value.input3 = tempDateValue.value;
  }
  console.log('input3 的值:', planForm.value.input3, '类型:', typeof planForm.value.input3);
  // 检查是否选择了时间（input3 是日期选择器）
  // 日期选择器可能返回 null、undefined、空字符串、Date 对象或格式化的字符串
  const selectedDate = planForm.value.input3;

  // 更健壮的日期检查：检查是否为有效值
  let hasDate = false;
  if (selectedDate !== null && selectedDate !== undefined && selectedDate !== '') {
    if (typeof selectedDate === 'string') {
      hasDate = selectedDate.trim() !== '';
    } else if (selectedDate instanceof Date) {
      hasDate = !isNaN(selectedDate.getTime());
    } else {
      hasDate = true; // 其他类型也认为有效
    }
  }

  console.log('hasDate:', hasDate);

  if (hasDate) {
    // 准备POST请求参数
    const requestData = {
      id: taskDetails.value.id, // 任务id
      schemeName: taskDetails.value.schemeName || '', // 受领任务后的schemeName
      drilled: taskDetails.value.drilled || '', // drilled字段
      time: planForm.value.input3 // 确定前填写的时间
    };

    // 发送POST请求
    if (CONFIRM_REQUEST_URL) {
      axios.post(CONFIRM_REQUEST_URL, requestData)
        .then(res => {
          console.log('POST请求成功:', res.data);
          ElMessage.success('提交成功');
        })
        .catch(err => {
          console.error('POST请求失败:', err);
          ElMessage.error('提交失败，请重试');
        });
    } else {
      console.warn('请先设置POST请求地址 CONFIRM_REQUEST_URL');
    }

    console.log('日期已选择，准备显示 pozhang 弹窗');
    // 关闭规划弹窗
    closePlanDialog();
    // 更新时间线状态：进入任务分解分配阶段
    timelineState.value.step2 = true;
    // 使用 setTimeout 确保弹窗关闭后再显示新弹窗
    setTimeout(() => {
      showPozhangDialog.value = true;
      console.log('pozhang 弹窗状态:', showPozhangDialog.value);
    }, 200);
  } else {
    // 如果没有选择时间，提示用户
    console.log('日期未选择，显示警告');
    ElMessage.warning('请先选择日期');
    // 不关闭弹窗，让用户继续选择
  }
};

// 关闭 pozhang 弹窗
const closePozhangDialog = () => {
  console.log('closePozhangDialog 被调用，关闭 pozhang 弹窗');
  showPozhangDialog.value = false;
  console.log('showPozhangDialog 状态:', showPozhangDialog.value);
  // 关闭所有弹窗后，也关闭 renWuGuiHua_T 本身
  emit('close');
};

// 处理 pozhang 的 next 事件，切换到 guiHuaXingDong
const handlePozhangNext = () => {
  showPozhangDialog.value = false;
  // 更新时间线状态：进入作战规划阶段
  timelineState.value.step3 = true;
  // 立即显示下一个弹窗，不使用延迟
  showGuiHuaXingDongDialog.value = true;
};

// 关闭 guiHuaXingDong 弹窗
const closeGuiHuaXingDongDialog = () => {
  showGuiHuaXingDongDialog.value = false;
  emit('close');
};

// 处理 guiHuaXingDong 的 next 事件，切换到 chaKanXinXi
const handleGuiHuaXingDongNext = () => {
  showGuiHuaXingDongDialog.value = false;
  // 立即显示下一个弹窗，不使用延迟
  showChaKanXinXiDialog.value = true;
};

// 处理 chaKanXinXi 的 prev 事件，返回到 guiHuaXingDong
const handleChaKanXinXiPrev = () => {
  showChaKanXinXiDialog.value = false;
  // 立即显示上一个弹窗，不使用延迟
  showGuiHuaXingDongDialog.value = true;
};

// 关闭 chaKanXinXi 弹窗
const closeChaKanXinXiDialog = () => {
  showChaKanXinXiDialog.value = false;
  emit('close');
};

// 取消按钮点击事件
const handleCancel = () => {
  closePlanDialog();
};
</script>
<template>
  <div class="renWuGuiHua-wrapper">
    <div class="renWuGuiHua-container ">
      <daoHangLan />
      <div class="renWuGuiHua-content"
        style="display: flex;position: absolute;z-index: 1000; top: 135px; left: 0; right: 0; height: 950px; background-color: rgb(28,36,66);">

        <div class="renWuGuiHua-content-left" style="display: flex;flex-direction: column;">
          <p class="renWuGuiHua-content-left-top"
            style="font-size: 22px;font-weight: bold;color: rgb(99, 170, 222);margin: 20px 0 20px 20px;">
            <img src="/daoHangLan/canMou.png" alt="" style="width: 20px; height: 20px;"> 卡包任务
          </p>
          <div class="renWuGuiHua-content-left-bottom"
            style="width:300px;height:815px;margin-left: 20px;display: flex;flex-direction: column;gap: 10px;background-color: rgb(28,49,92);">
            <div class="content-box" v-for="item in taskList" :key="item.id"
              style="height: 105px;width: 270px;margin-left: 15px;margin-top: 20px;">
              <div class="corner-decorator corner-top-left"></div>
              <div class="corner-decorator corner-top-right"></div>
              <div class="corner-decorator corner-bottom-left"></div>
              <div class="corner-decorator corner-bottom-right"></div>
              <div class="content-box-inner" style='position: relative;'>
                <div class="over" style="display: flex;align-items: center">
                  <div class="h-title-container">
                    <p>{{ item.taskName }}</p>
                  </div>
                </div>
                <div class="button-container"
                  style='display: flex;gap: 10px;position: absolute;bottom: 0px;left: 90px;right: 10px;'>
                  <el-button style="flex: 1;padding: 4px 10px !important;height: 30px; ">边际文书</el-button>
                  <el-button @click="handleReceive(item.id)"
                    style="flex: 1;padding: 4px 10px !important;height: 30px;">受领</el-button>
                </div>
              </div>
            </div>

          </div>
        </div>
        <div class="renWuGuiHua-content-right" style="flex: 1; display: flex; flex-direction: column;">
          <div class="renWuGuiHua-content-right-item-top"
            style="display: flex;justify-content: space-between;align-items: center;">
            <p class="renWuGuiHua-content-left-top"
              style="font-size: 22px;font-weight: bold;color: rgb(99, 170, 222);margin: 20px 0 20px 20px;">
              <img src="/daoHangLan/canMou.png" alt="" style="width: 20px; height: 20px;"> 任务列表
            </p>
            <div class="renWuGuiHua-content-right-item-top-button" style="margin-right: 15px;">
              <el-button
                style="padding: 4px 10px !important;height: 30px; margin-right: 5px !important;">边际文书边际文书边际文书</el-button><span
                style="margin-right: 5px !important;color: rgb(99, 170, 222);font-weight: bold;">|</span>
              <el-button @click="openChaKanXinXi"
                style="padding: 4px 5px !important;height: 30px; margin-right: 5px !important;">查十大看</el-button>
              <el-button style="padding: 4px 5px !important;height: 30px; margin-right: 5px !important;">提交</el-button>
              <el-button style="padding: 4px 5px !important;height: 30px; margin-right: 5px !important;">夏发</el-button>
            </div>
          </div>
          <div class="renWuGuiHua-content-right-item-middle">
            <div class="scroll-bar"
              style=" overflow-y: auto;max-height: 220px; border: 1px solid rgb(156,178,231);width: calc(100% - 40px);margin-left: 20px;">
              <div class="renWuGuiHua-content-right-item-bottom-table">
                <table style="  
                    width: 100%;
                    border-collapse: collapse;
                    color: white;
                    font-size: 18px;
                    font-weight: bold;
                    text-align: center;

                
                   ">
                  <thead style="background-color: rgb(11,27,90);">
                    <tr>
                      <td style="padding: 5px 10px;">序号</td>
                      <td style="padding: 5px 10px;">任务名称</td>
                      <td style="padding: 5px 10px;">任务来源</td>
                      <td style="padding: 5px 10px;width: 200px;">接收时间</td>
                      <td style="padding: 5px 10px;">备注</td>
                      <td style="padding: 5px 10px;">置为当前任务</td>
                      <td></td>
                    </tr>
                  </thead>

                  <tbody style="font-size: 18px;color: rgb(90,165,232);">
                    <tr v-for="item in receivedTaskList" :key="item.id"
                      style="border-top: 1px solid rgb(99, 170, 222); height: 40px;">
                      <td>{{ item.id }}</td>
                      <td style="padding: 5px 10px;">{{ item.taskName }}</td>
                      <td style="padding: 5px 10px;">{{ item.taskFrom }}</td>
                      <td style="padding: 5px 10px;">{{ receiveTimes[item.id] || '' }}</td>
                      <td style="padding: 5px 10px;">{{ item.remarks }}</td>
                      <td style="padding: 5px 10px;">
                        <el-switch v-model="value1" />
                      </td>
                      <td>
                        <el-button @click="handlePlan" :disabled="value1 === false"
                          style="padding: 2px 5px !important;height: 30px; ">规划</el-button>
                      </td>
                    </tr>
                    <tr v-if="receivedTaskList.length === 0"
                      style="border-top: 1px solid rgb(99, 170, 222); height: 40px;">
                      <td colspan="7" style="padding: 10px; color: rgba(255, 255, 255, 0.5);">暂无受领任务</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

          </div>
          <p class="renWuGuiHua-content-left-top"
            style="font-size: 22px;font-weight: bold;color: rgb(99, 170, 222);margin: 20px 0 20px 20px;">
            <img src="/daoHangLan/canMou.png" alt="" style="width: 20px; height: 20px;"> 任务详情
          </p>

          <div v-if="taskDetails.id" class="renWuGuiHua-content-right-item-bottom"
            style="display: flex;flex-direction: column;gap: 10px;padding: 0 40px; width: calc(100% - 60px);">
            <div class="renWuGuiHua-content-right-item-bottom-table" style="display: flex;width: 100%;gap: 15px;">
              <p style="color: white;flex: 1;display: flex;align-items: center;gap: 5px;">*任务名称 <el-input type="text"
                  :value="taskDetails.taskName || ''"
                  style=" flex: 1; height: 35px;  background-color: rgb(11,41,115);" placeholder="请输入任务名称" /></p>
              <p style="color: white;flex: 1;display: flex;align-items: center;gap: 5px;">*任务来源 <el-input type="text"
                  :value="taskDetails.taskFrom || taskDetails.taskSource || ''"
                  style=" flex: 1; height: 35px;  background-color: rgb(11,41,115);" placeholder="请输入任务来源" /></p>
              <p style="color: white;flex: 1;display: flex;align-items: center;gap: 5px;">*任务类型 <el-select 
                  :model-value="taskDetails.taskType || ''"
                  style=" flex: 1; height: 35px;  background-color: rgb(11,41,115);" placeholder="请选择任务类型">
                  <el-option label="类型1" value="1"></el-option>
                  <el-option label="类型2" value="2"></el-option>
                </el-select></p>
            </div>
            <div class="renWuGuiHua-content-right-item-bottom-table" style="display: flex;width: 100%;gap: 20px;">
              <div style="color: white;flex: 1;display: flex;align-items: center;gap: 5px;">*任务目的 <el-input type="text"
                  :value="taskDetails.taskPurpose || taskDetails.taskGoal || ''"
                  style="flex: 1; height: 35px;  background-color: rgb(11,41,115);" placeholder="请输入任务目的" />
              </div>
              <div style="color: white;flex: 1;display: flex;align-items: center;gap: 5px;">*执行力量 <el-select 
                  :model-value="taskDetails.executionForce || taskDetails.force || ''"
                  style="flex: 1; height: 35px;  background-color: rgb(11,41,115);" placeholder="请选择执行力量">
                  <el-option label="力量1" value="1"></el-option>
                  <el-option label="力量2" value="2"></el-option>
                </el-select>
              </div>
            </div>
            <div class="renWuGuiHua-content-right-item-bottom-table" style="display: flex;width: 100%;gap: 25px;">
              <div style="display: flex; align-items: center; gap: 2px; color: white;flex: 2;">
                <span style="white-space: nowrap;margin-left: 8px;margin-right: 2px;">任务时间</span>
                <el-date-picker 
                  type="date"
                  :model-value="extractDate(taskDetails.startTime)"
                  format="YYYY-MM-DD"
                  style="width: 95px;"
                  placeholder="选择日期" />
                <el-input 
                  :value="extractHourFromTime(taskDetails.startTime)"
                  style="width: 70px;"></el-input>
                <span style="margin-right: 5px;">时</span>
                <el-input 
                  :value="extractMinuteFromTime(taskDetails.startTime)"
                  style="width: 95px;"></el-input>
                <span style="margin: 0 20px;">分 — </span>
                <el-date-picker 
                  type="date"
                  :model-value="extractDate(taskDetails.endTime)"
                  format="YYYY-MM-DD"
                  style="width: 95px;"
                  placeholder="选择日期" />
                <el-input 
                  :value="extractHourFromTime(taskDetails.endTime)"
                  style="width: 70px;" placeholder=""></el-input>
                <span style="margin-right: 5px;">时</span>
                <el-input 
                  :value="extractMinuteFromTime(taskDetails.endTime)"
                  style="width: 70px;" placeholder=""></el-input>
                <span style="margin-right: 2px;">分</span>
              </div>
              <div style="display: flex; align-items: center; gap: 5px; color: white;flex: 1;">
                <span style="white-space: nowrap; margin-right: 5px;">备注</span>
                <el-input 
                  :value="taskDetails.remarks || taskDetails.taskNote || ''"
                  style="flex: 1; min-width: 260px;" placeholder="请输入备注"></el-input>
              </div>
            </div>

            <div style="display: flex;gap: 5px;">
              <p style="color: white;">*任务指标</p>
              <table
                style="border: 2px solid rgb(90,109,165); flex: 0 0 350px;height: 100px;color: white;border-collapse: collapse;">
                <thead
                  style="background-color: rgb(11,25,53); text-align: center;border-bottom: 2px solid rgb(90,109,165);">
                  <tr colspan="3">
                    <td style="padding: 5px 10px;">年后 </td>
                    <td style="padding: 5px 10px;">大撒大撒 </td>
                    <td style="padding: 5px 10px;">大撒大</td>
                  </tr>
                </thead>
                <tbody style="text-align: center;">
                  <tr>

                  </tr>
                </tbody>
              </table>
              <p style="color: white;margin: 0 10px;">*任务区域</p>
              <table
                style="color: white; border: 2px solid rgb(90,109,165); flex: 1;height: 100px;border-collapse: collapse;">
                <thead
                  style="background-color: rgb(11,25,53); text-align: center; border-bottom: 2px solid rgb(90,109,165);">
                  <tr>
                    <td style="padding: 5px 10px;">年后 </td>
                    <td style="padding: 5px 10px;">大撒大的大撒 </td>
                    <td style="padding: 5px 10px;">大撒对手的大</td>
                    <td style="padding: 5px 10px;">大撒对的大撒</td>
                    <td style="padding: 5px 10px;">大大</td>
                  </tr>
                </thead>
                <tbody>
                  <tr>

                  </tr>
                </tbody>

              </table>
            </div>
            <div style="display: flex;gap: 5px;">
              <p style="color: white;">*任务位置</p>
              <table style="border: 2px solid rgb(90,109,165); flex: 1;height: 100px;border-collapse: collapse;">
                <thead
                  style="color: white; background-color: rgb(11,25,53); text-align: center;border-bottom: 2px solid rgb(90,109,165);">
                  <tr>
                    <td style="padding: 5px 10px;">年后 </td>
                    <td style="padding: 5px 10px;">大撒大撒 </td>
                    <td style="padding: 5px 10px;">大撒大大</td>
                    <td style="padding: 5px 10px;">大的撒旦撒大</td>
                    <td style="padding: 5px 10px;">大撒大苏打大</td>
                    <td style="padding: 5px 10px;">大大</td>
                    <td style="padding: 5px 10px;">大撒</td>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                  </tr>
                </tbody>
              </table>
            </div>
            <div style="display: flex;justify-content: flex-end;margin-top: 50px;">
              <el-button style="padding: 0 10px!important;">你发生好</el-button>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- 规划弹窗 - 使用 Teleport 渲染到 body，避免 pointer-events 和 z-index 问题 -->
  <Teleport to="body">
    <div v-if="showPlanDialog" class="plan-dialog-overlay" @click.self="closePlanDialog">
      <div class="plan-dialog">
        <div class="plan-dialog-body">
          <div class="plan-form-item">
            <span class="plan-form-label">任务名称：</span>
            <el-input v-model="planForm.input1" class="plan-form-input" placeholder="请输入任务名称" />
          </div>
          <div class="plan-form-item">
            <span class="plan-form-label">执行时间：</span>
            <el-input v-model="planForm.input2" class="plan-form-input" placeholder="请输入执行时间" />
          </div>
          <div class="plan-form-item">
            <span class="plan-form-label">执行人员：</span>
            <el-date-picker type="date" v-model="tempDateValue" class="plan-form-input plan-date-picker"
              placeholder="请选择日期" style="width: 400px; height: 40px;" popper-class="custom-date-picker-popper"
              format="YYYY年MM月DD日" value-format="YYYY-MM-DD" :z-index="2001" confirm @confirm="handleDateConfirm" />
          </div>
        </div>
        <div class="plan-dialog-footer">
          <el-button @click="handleCancel" class="plan-button-cancel">取消</el-button>
          <el-button @click="handleConfirm" class="plan-button-confirm">确定</el-button>
        </div>
      </div>
    </div>
  </Teleport>
  <!-- pozhang 弹窗 - 使用 Teleport 渲染到 body，避免 z-index 问题 -->
  <Teleport to="body">
    <pozhang v-if="showPozhangDialog" @close="closePozhangDialog" @next="handlePozhangNext" />
  </Teleport>
  <!-- guiHuaXingDong 弹窗 - 使用 Teleport 渲染到 body，避免 z-index 问题 -->
  <Teleport to="body">
    <guiHuaXingDong v-if="showGuiHuaXingDongDialog" @close="closeGuiHuaXingDongDialog"
      @next="handleGuiHuaXingDongNext" />
  </Teleport>
  <!-- chaKanXinXi 弹窗 - 使用 Teleport 渲染到 body，避免 z-index 问题 -->
  <Teleport to="body">
    <chaKanXinXi v-if="showChaKanXinXiDialog" @close="closeChaKanXinXiDialog" @prev="handleChaKanXinXiPrev" />
  </Teleport>
</template>


<style scoped>
.renWuGuiHua-wrapper {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1000;
}

.renWuGuiHua-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 1000;
  pointer-events: none;
}

.renWuGuiHua-container>* {
  pointer-events: auto;
}

.renWuGuiHua-content {
  pointer-events: auto;
}

.renWuGuiHua-container>* {
  pointer-events: auto;
}

.container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  padding: 0;
  margin: 0;
  position: relative;
  /* 为绝对定位的子元素提供定位上下文 */
}

.header {
  height: 45px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: rgb(22, 37, 118);
  color: white;
  position: relative;
  background-image: url('../../public/header-bag.png');
}

.main-content {
  flex: 20;
  /* 大约占总高度的 20 份 */
  background-color: #2d2727;
  overflow-y: auto;
}

.content {
  height: 100%;
  padding: 1rem;
  box-sizing: border-box;
}

.footer {
  /* 大约占总高度的 7 份 */
  position: absolute;
  bottom: 0;
  width: 100%;
}

.footer-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(21, 24, 41, 0.9);
  /* 半透明黑色遮罩 */
  display: flex;
  flex-direction: column;
  align-items: center;
}

.footer-box {
  margin: 5px 20px 10px 20px;
  /* 上方50px，左右20px，下方10px */
  width: calc(100% - 40px);
  /* 左右各20px的距离 */
  height: calc(100% - 60px);
}

.schedule-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  table-layout: fixed;
  background-color: rgb(21, 29, 63);
  /* color: white; */
}

.schedule-table th,
.schedule-table td {
  border: 2px solid rgb(33, 52, 82);
  padding: 4px 8px;
  text-align: center;
}

.schedule-table th {
  background-color: rgb(21, 29, 63);
  font-weight: bold;
  color: rgb(107, 158, 231);
}

.cell-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.upper-part,
.lower-part {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgb(107, 158, 231);
}

.floating-box {
  width: 33px;
  height: 33px;
  background-color: rgb(14, 81, 140);
  position: absolute;
  top: calc(5% + 15px);
  left: 10px;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  border-radius: 4px;
  background-image: url('/main-icon.png');
  background-size: cover;
  /* 完全覆盖盒子 */
  background-position: center;
  background-repeat: no-repeat;
  color: transparent;
  /* 隐藏文字 */
}

.floating-box-content {
  position: fixed;
  top: calc(5% + 56px);
  left: 20px;
  height: 335px;
  width: 300px;
  background: rgba(7, 7, 7, 0.7);
  padding: 10px 20px 0px 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}


/* 导航区 */
.header-left-container {
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 20px;
  padding-left: 20px;
}

.header-left-container .el-icon,
.header-left-container span,
.header-left-container p {
  margin: 0;
  white-space: nowrap;
}

.header-center-icon {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1;
}

.header-right-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-right: 20px;
}

.header-right-box {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 30px;
}

.header-right-box .el-icon,
.header-right-box p {
  margin: 0;
  white-space: nowrap;
}

.td:only-child {
  width: 100%;
}

.custom-search-input :deep(.el-input__wrapper) {
  background-color: rgb(16, 48, 136) !important;
  border: none !important;
  box-shadow: none !important;
  border: 2px solid rgb(90, 109, 165) !important;
  border-radius: 0 !important;
}

.custom-search-input :deep(.el-input__inner) {
  background-color: rgb(16, 48, 136) !important;
  color: white !important;
  border: none !important;
}

.custom-search-input :deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.6) !important;
}

.custom-search-input :deep(.el-input__suffix) {
  background-color: rgb(16, 48, 136) !important;
  /* 与搜索框背景一致 */
  border-radius: 0 4px 4px 0 !important;
}

.custom-search-input :deep(.el-input__suffix-inner) {
  background-color: rgb(16, 48, 136) !important;
  /* 与搜索框背景一致 */
  padding: 0 2px !important;

}

.custom-search-input :deep(.el-input.is-focus .el-input__wrapper) {
  box-shadow: none !important;
}

/* 内容盒子容器 */
.content-box-container {
  display: flex;
  flex-direction: column;
  gap: 15px;
  overflow-y: auto;
  padding-right: 4px;
}

.content-box {
  /* 控制每个content-box的最大高度 */
  max-height: 100%;
  padding: 10px;
  border-radius: 5px;
}

/* 定制滚动条样式 */
.content-box-container::-webkit-scrollbar {
  width: 6px;
  /* 滚动条宽度 */
  padding-left: 2px;
  /* 控制轨道左侧的空隙 */
}

.content-box-container::-webkit-scrollbar-thumb {
  background-color: rgb(120, 170, 255);
  /* 滚动条颜色 */

}

.content-box-container::-webkit-scrollbar-track {
  /* 滚动条轨道的颜色 */
  border-radius: 10px;
}

/* 内容盒子 - 宽度与搜索框保持一致 */
.content-box {
  width: 100%;
  height: 150px;
  background: rgb(11, 25, 54);
  position: relative;
  transition: width 0.3s ease;
  box-sizing: border-box;
}

/* 缩小状态下的盒子宽度 - 与搜索框缩小后的宽度一致 */
.content-box-container.reduced .content-box {
  width: 200px;
}

/* 盒子内部内容容器 - 避免父元素样式影响，宽度与搜索框保持一致 */
.content-box-inner {
  position: relative;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0 10px 10px 10px;
  color: white;
  /* 重置可能继承的样式 */
  font-size: inherit;
  line-height: inherit;
  /* 确保内容宽度计算正确，减去padding后仍然填满父容器 */
  box-sizing: border-box;
}

/* 角落装饰 */
.corner-decorator {
  position: absolute;
  width: 5px;
  height: 8px;
  border-color: rgb(90, 154, 214);
  border-width: 3px;
  border-style: solid;
  pointer-events: none;
  z-index: 1;
}

.corner-top-left {
  top: 0;
  left: 0;
  border-right: none;
  border-bottom: none;
}

.corner-top-right {
  top: 0;
  right: 0;
  border-left: none;
  border-bottom: none;
}

.corner-bottom-left {
  bottom: 0;
  left: 0;
  border-right: none;
  border-top: none;
}

.corner-bottom-right {
  bottom: 0;
  right: 0;
  border-left: none;
  border-top: none;
}

/* 等腰梯形图标 - 横向摆放，左右对称 */
.trapezoid-icon {
  width: 16px;
  height: 16px;
  background: linear-gradient(to right, rgb(99, 195, 231), rgb(49, 89, 123));
  /* 等腰梯形：上底和下底水平平行，左右两边相等且对称 */
  /* 左边宽(0-20%)，右边窄(75%-85%)，左右对称 */
  clip-path: polygon(0 15%, 75% 0, 75% 100%, 0 85%);
  flex-shrink: 0;
}

/* 标题容器 */
.h-title-container {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  flex-direction: column;
  margin-bottom: 40px;
}

.h-title-container h5 {
  margin: 0;
  color: white;
}

/* 正方形块 */
.square-block {
  width: 24px;
  height: 24px;
  background-color: rgb(99, 138, 222);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 14px;
  flex-shrink: 0;
  margin-bottom: 85px;
  margin-left: 5px;
  margin-right: 10px;
}

.text-wrap {
  word-wrap: break-word;
  /* 确保长文本自动换行 */
  word-break: break-word;
  /* 处理无空格的长单词 */
}

.button-container {
  display: flex;
  justify-content: space-between;
  gap: 10px;
}

.stamp {
  position: absolute;
  left: 0;
  right: 0;
  margin: 0 auto;
  width: 40px;
  height: 40px;
  background-size: cover;
  background-position: center;
  border-radius: 50%;
}

.icon-item {
  border: 2px solid transparent;
  /* 默认透明边框，预留空间 */
  box-sizing: border-box;
  /* 确保边框不影响布局 */
  transition: border-color 0.3s ease;
  /* 平滑过渡效果 */
  display: flex;
  flex-direction: column;
  max-height: 100px;
}

.icon-item-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.icon-item-content span {
  font-size: 15px;
}

.icon-item:hover {
  border: 2px solid rgb(90, 109, 165);
}

:deep(.h-title-container .el-checkbox__inner) {
  height: 16px;
  width: 16px;
  padding: 0;
  border: 2px solid rgb(90, 109, 165);
  background: rgb(11, 41, 115);
}

.el-button {
  color: white;
  border: 2px solid rgb(90, 109, 165);
  background-color: rgb(11, 41, 115);
}

.icon-text {
  width: 85px;
  /* 你根据 UI 调整 */
  color: white;
  line-height: 18px;
  word-break: break-all;
  /* 防止挤成四行 */
}

.header-right-box-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.header-left-box-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.menu-item {
  flex: 1;
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 10px;
  border-radius: 6px;
  transition: background 0.25s, color 0.25s;
}

.menu-item:hover {
  background: rgba(255, 255, 255, 0.15);
}

.menu-item.active {
  background: rgba(255, 255, 255, 0.35);
  color: #fff;
}

.menu-item-work {
  cursor: pointer;
  height: 100%;
  width: 100%;

}

.menu-item-work.active {
  width: 100%;
  height: 100%;
  background: rgba(201, 9, 9, 0.3);
  color: #fff;
  cursor: pointer;
}

/* 滚动条 */
/* 整个滚动条 */
/* 滚动容器：保留给滚动条的空间，禁止横向滚动 */
.scroll-bar {
  overflow-y: auto;
  overflow-x: hidden;
  /* 必须：防止出现横向滚动 */
  box-sizing: border-box;

}

/* 内层 wrapper：通过 transform 视觉向右偏移，不改变布局宽度 -> 不会触发横向滚动 */

.scroll-bar::-webkit-scrollbar {
  width: 4px;
  height: 4px;
  background-color: rgb(156, 178, 231);

}

/* 滚动条滑块 */
.scroll-bar::-webkit-scrollbar-thumb {
  background: rgb(82, 113, 198);
}

/* 滑块在鼠标悬浮时 */
.scroll-bar::-webkit-scrollbar-thumb:hover {
  background: rgb(75, 140, 200);
}

.renWuGuiHua-content-right-item-bottom-table input::placeholder {
  color: rgb(82, 121, 198);
  font-size: 16px;
  font-weight: bold;
  padding: 0 20px;
}


/* 改 wrapper 背景、边框颜色 */
:deep(.el-input__wrapper) {
  background-color: rgb(11, 41, 115);
  border-radius: 0;
  border: 2px solid rgb(90, 109, 165) !important;
  box-shadow: none !important;
  /* 必须去掉，否则边框不会变 */

}

/* 改 inner 的颜色或文本 */

:deep(.el-select__wrapper) {
  background-color: rgb(11, 41, 115);
  border-radius: 0;
  border: 2px solid rgb(90, 109, 165) !important;
  box-shadow: none !important;
  /* 必须去掉，否则边框不会变 */
  height: 35px !important;
}

/* 规划弹窗样式 */
.plan-dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 2000;
  pointer-events: auto;
}

.plan-dialog {
  width: 785px;
  height: 470px;
  background-color: rgb(24, 38, 87);
  border: 2px solid rgb(90, 109, 165);
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  pointer-events: auto;
  position: relative;
  z-index: 2001;
}

.plan-dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  border-bottom: 2px solid rgb(90, 109, 165);
}

.plan-dialog-body {
  flex: 1;
  padding: 40px 30px;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  gap: 30px;
  overflow-y: auto;
}

.plan-form-item {
  display: flex;
  align-items: center;
  justify-self: center;
  gap: 15px;
}

.plan-form-label {
  color: white;
  font-size: 16px;
  width: 80px;
  flex-shrink: 0;
  text-align: right;
}

.plan-form-input {
  width: 400px !important;
  height: 40px !important;
}

/* 统一设置 el-input 和 el-date-picker 的样式 */
.plan-form-input :deep(.el-input__wrapper),
.plan-form-input :deep(.el-date-editor .el-input__wrapper),
.plan-form-input.el-date-editor :deep(.el-input__wrapper) {
  background-color: rgb(11, 41, 115) !important;
  border: 2px solid rgb(90, 109, 165) !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  height: 40px !important;
  width: 520px !important;
}

.plan-form-input :deep(.el-input__inner),
.plan-form-input :deep(.el-date-editor .el-input__inner),
.plan-form-input.el-date-editor :deep(.el-input__inner) {
  background-color: rgb(11, 41, 115) !important;
  color: white !important;
  font-size: 16px !important;
  height: 40px !important;
}

.plan-form-input :deep(.el-input__inner::placeholder),
.plan-form-input :deep(.el-date-editor .el-input__inner::placeholder),
.plan-form-input.el-date-editor :deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.6) !important;
}

.plan-form-input :deep(.el-input__suffix),
.plan-form-input :deep(.el-date-editor .el-input__suffix),
.plan-form-input.el-date-editor :deep(.el-input__suffix) {
  color: rgb(99, 138, 222) !important;
}

.plan-form-input :deep(.el-input__prefix),
.plan-form-input :deep(.el-date-editor .el-input__prefix),
.plan-form-input.el-date-editor :deep(.el-input__prefix) {
  color: rgb(99, 138, 222) !important;
}




.plan-dialog-footer {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 15px;
  padding: 20px 30px;
}

.plan-button-cancel,
.plan-button-confirm {
  padding: 8px 25px !important;
  height: 35px !important;
  border: 2px solid rgb(90, 109, 165) !important;
  background-color: rgb(11, 41, 115) !important;
  color: white !important;
  border-radius: 0 !important;
  font-size: 16px !important;
}

.plan-button-cancel:hover,
.plan-button-confirm:hover {
  background-color: rgb(28, 49, 92) !important;
  border-color: rgb(99, 138, 222) !important;
}

.plan-button-confirm {
  background-color: rgb(11, 41, 115) !important;
}
</style>

<style>
/* 日期选择器弹窗样式 - 必须使用非 scoped 样式，因为弹窗挂载在 body 下 */



.custom-date-picker-popper .el-picker-panel__body {
  box-sizing: border-box !important;
  overflow: hidden !important;
  border: none !important;
}

.custom-date-picker-popper .el-picker-panel__content {
  box-sizing: border-box !important;
  overflow: hidden !important;
  color: white;
  border: none !important;
}

.custom-date-picker-popper .el-picker-panel__body-wrapper {
  margin: 0 !important;
  background-color: rgb(50, 97, 178) !important;
  box-sizing: border-box !important;
  overflow: hidden !important;
  color: white;
  border: none !important;
}

.el-picker-panel__body {
  border: none !important;
}

.el-date-picker__header {
  color: white !important;
}

/* 日期选择器所有文字设置为白色 */
.custom-date-picker-popper .el-picker-panel__header,
.custom-date-picker-popper .el-picker-panel__header button,
.custom-date-picker-popper .el-picker-panel__header-label,
.custom-date-picker-popper .el-date-picker__header-label,
.custom-date-picker-popper .el-picker-panel__header-label span,
.custom-date-picker-popper .el-date-picker__header-label span,
.custom-date-picker-popper .el-date-table th,
.custom-date-picker-popper .el-date-table th .cell,
.custom-date-picker-popper .el-date-table td .cell,
.custom-date-picker-popper .el-date-table td.available .cell,
.custom-date-picker-popper .el-date-table td.today .cell,
.custom-date-picker-popper .el-date-table td.selected .cell,
.custom-date-picker-popper .el-date-table td.current .cell,
.custom-date-picker-popper .el-picker-panel__footer .el-button {
  color: white !important;
}

/* 年份/月份标签文字强制设为白色 */
.custom-date-picker-popper .el-picker-panel__header button span,
.custom-date-picker-popper .el-picker-panel__header-label button,
.custom-date-picker-popper .el-date-picker__header-label button,
.custom-date-picker-popper .el-picker-panel__header-label>span,
.custom-date-picker-popper .el-date-picker__header-label>span {
  color: white !important;
}

/* 表头区域所有文字强制设为白色 */
.custom-date-picker-popper .el-picker-panel__header *,
.custom-date-picker-popper .el-date-picker__header * {
  color: white !important;
}

/* 其他月份的日期文字 */
.custom-date-picker-popper .el-date-table td.prev-month .cell,
.custom-date-picker-popper .el-date-table td.next-month .cell {
  color: rgba(255, 255, 255, 0.6) !important;
}
</style>
