<template>
  <div :style="{
    position: 'fixed',
    top: isMinimized ? 'calc(100% - 50px)' : '45px',
    left: isReduced ? 'calc(100% - 260px)' : '0',
    width: isReduced ? '240px' : '493px',
    height: isMinimized ? '60px' : '980px',
    background: 'rgba(24,33,64)',
    zIndex: 100,
    padding: '0 20px 20px 20px',
    boxShadow: '2px 0 10px rgba(0,0,0,0.3)',
    transition: 'all 0.3s ease'
  }">
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
          批量批量
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
        <el-input placeholder="请输入搜索内容"
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
      <div class="content-box-container" style="overflow-y: auto;max-height: 800px; " :class="{ 'reduced': isReduced }">
        <div class="content-box">
          <div class="corner-decorator corner-top-left"></div>
          <div class="corner-decorator corner-top-right"></div>
          <div class="corner-decorator corner-bottom-left"></div>
          <div class="corner-decorator corner-bottom-right"></div>
          <div class="content-box-inner" style='position: relative;'>
            <div class="over" style="display: flex;align-items: center">
              <div class="square-block">标</div>
              <div class="h-title-container">
                <h4>你好我是徐坤哈哈</h4>
                <h6>2025/11/19 14:20:55</h6>
                <p style=" font-size: 14px; "><el-icon>
                    <Document />
                  </el-icon> 什么结果的查看</p>
                <p style=" font-size: 14px;"><el-checkbox style="height: 14px;"></el-checkbox> 什么为设计方案</p>
              </div>
            </div>

            <div class="button-container"
              style='display: flex;gap: 10px;position: absolute;bottom: 10px;left: 10px;right: 10px;'>
              <el-button style="flex: 1; ">扎看</el-button>
              <el-button style="flex: 1; ">上报</el-button>
              <el-button  @click="shenYue" style="flex: 1; ">审阅</el-button>
              <el-button @click="handleSubmit" style="flex: 1; ">提交</el-button>
              <el-button style="flex: 1; ">夏发</el-button>
              <el-button
                style="flex: 1; border:2px solid rgb(90,109,165); background-color: rgb(11,41,115);">山除</el-button>
              <div class="stamp"
                style=" position: absolute; top: -80px; left: 5px;  width: 60px; height: 60px; background-image: url('../../public/success.png');background-color: rgb(181,158,107); background-position: center; border-radius: 50%;">
              </div>
              <!-- 添加已审核盖章 -->
              <div class="stamp"
                style="position: absolute; left: 0; right: 0; margin: 0 auto; width: 40px; height: 40px; background-image: url('/mnt/data/9ba1fd10-ea20-473f-a7b3-8755fd7007d8.png'); background-size: cover; background-position: center; border-radius: 50%;">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 审阅弹窗 -->
  <div v-if="showDialog" class="custom-dialog-overlay" @click.self="showDialog = false">
    <div class="custom-dialog" @click.stop>
      <slot name="dialog-content">
        <!-- 默认内容，可以通过插槽自定义 -->
        <div style="padding: 20px; color: white;position: relative;">
          <h3 style="margin: 10px 0 15px 0;">弹窗标题</h3>
          <div style="display: flex;gap: 10px;align-items: center;margin-top: 20px;">
            <p style="margin: 0;">弹窗房按状态</p>
            <el-select style="width: 280px; margin: 0;" v-model="value" placeholder="请选择"
              popper-class="custom-select-dropdown" :popper-options="{
                modifiers: [
                  {
                    name: 'offset',
                    options: {
                      offset: [0, 0]   // [水平偏移, 垂直偏移]
                    }
                  }
                ]
              }">
              <el-option label="通过" value="1" />
              <el-option label="不通过" value="2" />
              <el-option label="需修改" value="3" />
            </el-select>
          </div>
          <el-button @click="handleConfirm"
            style="width: 20%; height: 100%;padding: 8px 20px!important;margin-left: 280px!important;margin-top: 60px!important;font-size: 16px;">确定</el-button>
        </div>
      </slot>
      <div style="position: absolute; top: 20px; right: 20px; cursor: pointer;" @click="showDialog = false">
        <el-icon style="color: white; font-size: 20px;">
          <Close />
        </el-icon>
      </div>
    </div>
  </div>
  <div v-if="showConfirm"
    style="position: absolute; left: 50%;top: 50%;transform: translate(-50%, -50%); width: 450px;height: 150px;">
    <div style="  background: linear-gradient(
    to right,
    rgb(19, 47, 107) 0%,
    rgb(24, 73, 148) 50%,
    rgb(19, 47, 107) 100%
  );border: 2px solid rgb(90, 109, 165);padding: 15px 20px 20px 20px;">
      <h3 style="text-align: center; margin-bottom: 10px;color: rgb(99, 142,255);">确认提交</h3>
      <p style="text-align: center; margin-bottom: 20px;color: white;">确认提交后，将无法修改</p>
      <div style="display: flex;justify-content: center;gap: 10px;">
        <el-button @click="handleCancel" style="width: 20%;height: 30px;font-size: 16px;">取消</el-button>
        <el-button @click="handleConfirm" style="width: 20%;height: 30px;font-size: 16px;">确定</el-button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue';
import { Close } from '@element-plus/icons-vue';

const emit = defineEmits(['close', 'submit']);

const isMinimized = ref(false);
const isReduced = ref(false);
const showDialog = ref(false);
const value = ref('');
const showConfirm = ref(false);
const shenYue = () => {
  showDialog.value = true;
};
const handleCancel = () => {
  showConfirm.value = false;
};
const handleConfirm = () => {
  showConfirm.value = true;
};

const handleClose = () => {
  emit('close');
};

const handleSubmit = () => {
  emit('submit');
};
</script>
<style scoped>
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

/* 弹窗样式 */
.custom-dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding-top: 120px;
}

.custom-dialog {
  position: absolute;
  width: 430px;
  height: 230px;
  background-color: rgb(24, 39, 87);
  border: 2px solid rgba(90, 109, 165, 0.8);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  box-sizing: border-box;
  top: 120px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1001;
}

:deep(.el-select-dropdown) {
  background-color: rgb(50, 97, 178) !important;
  color: white !important;
}

:deep(.el-select-dropdown__item) {
  background-color: rgb(50, 97, 178) !important;
  color: white !important;
}

:deep(.el-select-dropdown__item:hover) {
  background-color: rgb(70, 120, 210) !important;
}
</style>
