<script setup>
import { ref, defineEmits, onMounted, computed, inject } from 'vue';
import { Document, SuccessFilled, Search, Close } from '@element-plus/icons-vue';
import axios from 'axios';
import CornerDecorator from '@/components/common/CornerDecorator.vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import ChaKanXinXi from '@/components/breachPlanSeat/chaKanXinXi_T.vue';
const emit = defineEmits(['close']);

// 注入打开任务弹窗的方法
const openTaskDialog = inject('openTaskDialog');
const isMinimized = ref(false);
const isReduced = ref(false);
const isApproved = ref(false);
const successMessage = ref(false);
const showChaKanXinXiDialog = ref(false);

//接口变量
const contentBoxes = ref([]);
// 搜索关键词
const searchKeyword = ref('');
//接口函数
const getContentBoxes = () => {
  axios.get('/api/scheme_listNoPage').then(res => {
    console.log('方案列表数据:', res.data);
    contentBoxes.value = res.data;
  }).catch(err => {
    console.error('获取方案列表失败:', err);
  });
};
// 格式化时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '';
  const date = new Date(dateTime);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
};
// 过滤后的方案列表（根据 schemeName 搜索）
const filteredContentBoxes = computed(() => {
  if (!searchKeyword.value.trim()) {
    return contentBoxes.value;
  }
  const keyword = searchKeyword.value.trim().toLowerCase();
  return contentBoxes.value.filter(box => {
    const schemeName = box.schemeName || '';
    return schemeName.toLowerCase().includes(keyword);
  });
});
// 组件挂载时调用接口
onMounted(() => {
  getContentBoxes();
});
const handleMinimize = () => {
  isMinimized.value = !isMinimized.value;
};

const handleReduce = () => {
  isReduced.value = !isReduced.value;
};

const handleClose = () => {
  successMessage.value = false; // 关闭时也关闭提交成功弹窗
  emit('close');
};

const handleApprove = (boxId) => {
  if (boxId) {
    // 为特定 box 设置审批状态
    const box = contentBoxes.value.find(b => b.id === boxId);
    if (box) {
      box.auditstatus = 1;
    }
  } else {
    // 兼容旧的全局状态
    isApproved.value = true;
  }
};

// 按钮处理方法
const handleView = (boxId) => {
  console.log('查看方案', boxId);
  // 查看按钮的处理逻辑
};

const handleJueXinFangAnTu = (boxId) => {
  console.log('绝新房按屠', boxId);
  // 打开查看信息组件
  showChaKanXinXiDialog.value = true;
};

// 关闭查看信息弹窗
const closeChaKanXinXiDialog = () => {
  showChaKanXinXiDialog.value = false;
};

const handleEdit = (boxId) => {
  console.log('编辑方案', boxId);
  // 打开任务弹窗
  if (openTaskDialog) {
    openTaskDialog();
  }
};

const handleSubmit = (boxId) => {
  console.log('提交方案', boxId);
  ElMessageBox.confirm('确定提交该方案吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    await axios.patch(`/api/scheme/${boxId}`, { auditstatus: 1 });
    successMessage.value = true;
    // 刷新数据以更新审批状态
    getContentBoxes();
    // 3秒后自动关闭成功提示
    setTimeout(() => {
      successMessage.value = false;
    }, 1500);
  });
};

const handleIssue = (boxId) => {
  console.log('下发方案', boxId);
  // 下发按钮的处理逻辑
};

const handleDelete = async (boxId) => {
  console.log('删除方案', boxId);
  ElMessageBox.confirm('确定删除该方案吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    await axios.delete(`/api/scheme/${boxId}`);
    ElMessage.success('删除方案成功');
  }).catch(() => {
    ElMessage.error('用户取消删除');
  }).finally(() => {
    getContentBoxes();
  });
};

const handleIssueClick = (auditstatus, boxId) => {
  if (auditstatus === 2) {
    console.log('下发方案', boxId);
    axios.patch(`/api/scheme/${boxId}`, { auditstatus: 5 }).then(res => {
      if (res.data.auditstatus == 5) {
        ElMessage.success('下发方案成功');
      }
    }).catch(() => {
      ElMessage.error('下发方案失败');
    }).finally(() => {
      getContentBoxes();
    });
  }
  else {
    ElMessage.error('等待审批通过后即可下发');
  }
};

// 印章功能 - 状态图片映射（支持5个状态）
const statusImageMap = {
  0: "/breachPlanSeat/weiShenHe.png",
  1: "/breachPlanSeat/shenPiZhong.png",
  2: "/breachPlanSeat/shenPiZhong.png",
  3: "/breachPlanSeat/shenPiZhong.png",
  4: "/breachPlanSeat/shenPiZhong.png",
};

// 默认图片
const defaultImage = "/breachPlanSeat/weiShenHe.png";

// 获取印章图片路径
const getStampImage = (auditstatus) => {
  const status = Number(auditstatus);
  const num = isNaN(status) ? 0 : status;
  return statusImageMap[num] || defaultImage;
};

// 判断是否显示审批动画（状态为1时显示）
const shouldShowApproved = (auditstatus) => {
  return Number(auditstatus) === 1;
};



</script>

<template>
  <div :style="{
    position: 'fixed',
    top: isMinimized ? 'calc(100% - 60px)' : '45px',
    left: isReduced ? 'calc(100% - 260px)' : '0',
    width: isReduced ? '240px' : '493px',
    height: isMinimized ? '60px' : '1010px',
    background: 'rgba(21,29,63,0.7)',
    zIndex: 100,
    padding: '0 20px 20px 20px',
    boxShadow: '2px 0 10px rgba(0,0,0,0.3)',
    transition: 'all 0.3s ease'
  }">

    <!-- 成功提示 -->
    <div class="success-message" v-if="successMessage"
      style="position: absolute; top: 63px; left: 760px; width:400px; height: 63px; background-color:white; z-index: 1000;">
      <p
        style="display:flex;gap: 10px;align-items:center;color: green;font-size: 16px;font-weight: bold;text-align: left;line-height: 63px;padding-left: 30px;">
        <el-icon>
          <SuccessFilled />
        </el-icon>提交成功
      </p>
    </div>
    <div style="display:flex;justify-content: space-between;gap:10px;align-items:center;">
      <div class="title-container"
        style="width:130px;height:20px;font-weight: bold; color:rgb(99,174,222);font-size:16px;margin:10px 0 15px 0;display:flex;align-items:center;gap:8px;">
        <div class="trapezoid-icon"></div>
        <h2>方案办法</h2>
      </div>
      <div>
        <el-icon @click="handleClose" style="color:white;cursor:pointer;" title="关闭">
          <Close />
        </el-icon>
      </div>

    </div>
    <div v-if="!isMinimized">
      <div class="fangankuang-container" style="display:flex;justify-content: space-between;width:100%;">
        <div class="fangankuang"
          style=" border-bottom: 3px solid rgb(90,109,165);  box-sizing: border-box;padding:5px 25px;margin-bottom: 10px;color:white;text-align:center; background-color: rgb(11,41,115);">
          级本
        </div>
        <button class="fangankuang-button"
          style="border:2px solid rgb(90,109,165);margin-bottom: 21px;padding: 2px 6px;background-color: rgb(11,41,115);color:white;text-align:center;">
          批量操作
        </button>
      </div>
      <!-- 新增搜索框 -->
      <div :style="{
        position: 'relative',
        width: isReduced ? '200px' : '100%',
        height: '35px',
        marginBottom: '20px',
        boxSizing: 'border-box'
      }">
        <el-input 
          v-model="searchKeyword"
          placeholder="请输入搜索内容"
          style="width:100%; height:100%;box-sizing: border-box;font-size: 16px;font-weight: bold;"
          class="custom-search-input">
          <template #suffix>
            <el-icon size="18" style="color:rgb(99, 138, 222);cursor:pointer;">
              <Search />
            </el-icon>
          </template>
        </el-input>
      </div>
      <!-- 新增五个盒子 -->
      <div class="content-box-container" style="overflow-y: auto;max-height: 852px; " :class="{ 'reduced': isReduced }">
        <div class="content-box" v-for="box in filteredContentBoxes" :key="box.id">
          <CornerDecorator />
          <div class="content-box-inner" style='position: relative;'>
            <div class="over" style="display: flex;align-items: center;gap: 50px;">
              <div class="square-block">主</div>
              <div class="h-title-container">
                <h4>{{ box.schemeName }}</h4>
                <h6 style="font-size: 15px;">{{ box.scenarioTime ? formatDateTime(box.scenarioTime) : '' }}</h6>
                <p style="font-size: 14px; display: flex;align-items: center;">
                  <el-icon>
                    <Document/>
                  </el-icon>
                  <span style="margin-left: 4px;">推演结果查看</span>
                </p>
                <p style="font-size: 14px; display: flex;align-items: center;">
                  <el-checkbox style="height: 14px;"></el-checkbox>
                  <span style="margin-left: 4px;">设置主要方案</span>
                </p>
              </div>
            </div>

            <div class="button-container"
              style='display: flex;gap: 10px;position: absolute;bottom: 10px;left: 10px;right: 10px;'>
              <el-button style="flex: 1;" @click="handleView(box.id)">
                查看
              </el-button>
              <el-button style="flex: 1; padding: 0 10px !important;" @click="handleJueXinFangAnTu(box.id)">
                绝新房按屠
              </el-button>
              <el-button style="flex: 1;" @click="handleEdit(box.id)">
                编辑
              </el-button>
              <el-button style="flex: 1;"
                :class="{ 'disabled-button': box.auditstatus !== 0 }"
                :disabled="box.auditstatus !== 0" @click="handleSubmit(box.id)">
                提交
              </el-button>
              <el-tooltip effect="dark" content="等待审批通过后即可下发" placement="bottom">
                <el-button style="flex: 1;" :class="{ 'btn-disabled': box.auditstatus !== 2 }"
                  @click="handleIssueClick(box.auditstatus, box.id)">
                  下发
                </el-button>
              </el-tooltip>

              <el-button :disabled="box.auditstatus !== 0"
                style="flex: 1; border:2px solid rgb(90,109,165); background-color: rgb(11,41,115);"
                @click="handleDelete(box.id)">
                删除
              </el-button>
              <!-- 印章 -->
              <div
                v-if="box.auditstatus !== undefined && box.auditstatus !== null"
                class="stamp stamp-animated"
                :class="{ 'stamp-approved': shouldShowApproved(box.auditstatus) }"
                :style="{
                  position: 'absolute',
                  top: '-80px',
                  left: '150px',
                  width: '60px',
                  height: '60px',
                  backgroundImage: `url('${getStampImage(box.auditstatus)}')`,
                  backgroundPosition: 'center',
                  backgroundSize: 'cover',
                  backgroundColor: 'rgb(181,158,107)',
                  borderRadius: '50%'
                }"
                :key="`stamp-${box.id}-${box.auditstatus}`"
              ></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- chaKanXinXi 弹窗 - 使用 Teleport 渲染到 body，避免 z-index 问题 -->
    <Teleport to="body">
      <ChaKanXinXi v-if="showChaKanXinXiDialog" @close="closeChaKanXinXiDialog" />
    </Teleport>
  </div>
</template>

<style scoped>
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
  justify-content: flex-start;
  margin-bottom: 10px;
  flex-direction: column;
  margin-bottom: 40px;
  margin-left: -40px;
}

.h-title-container h4 {
  margin: 0;
  color: white;
  font-size: 18px;
  text-align: left;
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
  margin-bottom: 87px;
  margin-left: 1px;
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

/* 审批印章动画 */
.stamp-animated {
  transition: background-image 0.5s ease-in-out, transform 0.5s ease-in-out;
  transform-origin: center;
}

.stamp-animated.stamp-approved {
  animation: stampApprove 0.6s ease-in-out;
}

@keyframes stampApprove {
  0% {
    transform: scale(1);
    opacity: 1;
  }

  50% {
    transform: scale(1.2);
    opacity: 0.8;
  }

  100% {
    transform: scale(1);
    opacity: 1;
  }
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

.disabled-button {
  background-color: rgb(103, 103, 103) !important;
}
</style>
<style>
.el-message-box__btns button {
  display: flex;
  justify-content: center;
  width: 50px !important;
  height: 30px !important;
  font-size: 16px !important;
  margin-right: 10px !important;
}
</style>