<script setup>
import { ref } from 'vue';
import yeWuGongJu_T from '@/components/channelCommandSeat/yeWuGongJu_T.vue';
import Menu_T from '@/components/breachPlanSeat/Menu_T.vue';
import ChaKanXinXi from '@/components/breachPlanSeat/chaKanXinXi_T.vue';
const isOpened = ref(false);
const showSidebar = ref(false);
const showFooter = ref(false);
const showChaKanXinXi = ref(false);
const toggleFooter = () => {
  showFooter.value = !showFooter.value;
};

const open = () => {
  isOpened.value = !isOpened.value;
};

const handleMenuClick = (menuItem) => {
  if (menuItem === 'menu1') {
    showSidebar.value = true;
    isOpened.value = false; // 关闭menu-container
  }
};
const submit = () => {
  console.log('提交');
};

// 选中的item索引，默认第一个（索引0）
const selectedItemIndex = ref(0);

// 点击item的处理函数
const handleItemClick = (index) => {
  selectedItemIndex.value = index;
};

// 处理查看按钮点击
const handleView = () => {
  showChaKanXinXi.value = true;
};

// 关闭查看信息弹窗
const handleCloseChaKanXinXi = () => {
  showChaKanXinXi.value = false;
};

</script>
<template>
  <div class="container">
    <main class="main-content">
    </main>

    <footer class="footer" style="height: 300px;">
      <div class="footer-container">
        <div class="footer-box">
          <!-- Footer内容替换为表格 -->
          <p style="margin-bottom: 10px;color: white;font-size: 14px;">清剿障碍</p>
          <div class="footer-box-item-container" style="display: flex;">
            <div v-for="(item, index) in 11" :key="index" class="footer-box-item"
              :class="{ 'footer-box-item-selected': selectedItemIndex === index }" @click="handleItemClick(index)">
              <p>模式监控</p>
            </div>
          </div>
          <table class="schedule-table" style="border: 2px solid rgb(33, 52, 82);">
            <thead style="font-size: 15px;">
              <tr style="height:60px;width:40px;">
                <th style="width:40px;" rowspan="2">
                  <el-checkbox />
                </th>
                <th width="150px">名称名称是</th>
                <th width="150px">名称名称是</th>
                <th width="150px">名称名称是</th>
                <th width="150px">名称名称是</th>
                <th colspan="3" style="padding:0;">
                  <div style="display:flex; flex-direction:column; width:100%;">

                    <!-- 第一行：独占整行 -->
                    <div style="text-align:center; border-bottom:2px solid rgb(33, 52, 82); padding:4px 0;">
                      你好啊
                    </div>

                    <!-- 第二行：两列 -->
                    <div style="display:flex;">
                      <div style="flex:1; text-align:center; padding:4px 0; border-right:2px solid rgb(33, 52, 82);">
                        你好啊
                      </div>
                      <div style="flex:1; text-align:center; padding:4px 0; border-right:2px solid rgb(33, 52, 82);">
                        你好啊
                      </div>
                      <div style="flex:1; text-align:center; padding:4px 0;">
                        你好啊
                      </div>
                    </div>

                  </div>
                </th>
                <th colspan="4" style="padding:0;">
                  <div style="display:flex; flex-direction:column; width:100%;">

                    <!-- 第一行：独占整行 -->
                    <div style="text-align:center; border-bottom:2px solid rgb(33, 52, 82); padding:4px 0;">
                      你好啊
                    </div>

                    <!-- 第二行：两列 -->
                    <div style="display:flex;">
                      <div style="flex:1; text-align:center; padding:4px 0; border-right:2px solid rgb(33, 52, 82);">
                        你好啊
                      </div>
                      <div style="flex:1; text-align:center; padding:4px 0; border-right:2px solid rgb(33, 52, 82);">
                        你好啊
                      </div>
                      <div style="flex:1; text-align:center; padding:4px 0;border-right:2px solid rgb(33, 52, 82);">
                        你好啊
                      </div>
                      <div style="flex:1; text-align:center; padding:4px 0;">
                        你好啊
                      </div>
                    </div>

                  </div>
                </th>
                <th  style="padding:0;">操作</th>
              </tr>
            </thead>

            <tbody>


            </tbody>
            <tfoot>
              <tr>
                <td colspan="13"
                  style=" text-align: right;color: white;height: 20px;border-bottom: 4px solid rgb(33, 52, 82);">
                  <div
                    style="display:flex; align-items:center;justify-content: flex-end; color:rgb(123,170,198);font-size: 15px;">
                    <span style=" margin-right: 15px;display:flex; align-items:center;gap: 10px;"><el-icon
                        style="margin-right: 5px;">
                        <Rank />
                      </el-icon>东经42度55分</span>
                    <span style="margin-right: 8vw;display:flex; align-items:center;">北纬42度65分</span>
                    <span style="display:flex; align-items:center;gap: 10px;"><el-icon>
                        <Lock />
                      </el-icon>海拔米2:17</span>
                  </div>
                </td>

              </tr>
            </tfoot>
          </table>
        </div>
      </div>

    </footer>
    <Menu_T v-if="showFooter" />
    <!-- 显示/隐藏底部菜单按钮 -->
    <div>
      <el-icon @click="toggleFooter()" style="position: absolute; bottom: 12px; left: 25px; color:white;cursor:pointer;"
        title="显示/隐藏">
        <Menu />
      </el-icon>
    </div>

    <!-- 浮动盒子 -->
    <div class="floating-box" @click="open">
    </div>
    <div v-if="isOpened" class="floating-box-content">
      <span style="color:white;font-size: 16px;">小小工具</span>
      <div class="menu-container"
        style="display:grid;grid-template-columns:repeat(2,1fr);grid-gap:8px;margin-top: 20px;">

        <div class="icon-item" style="display:flex;flex-direction:column;align-items:center;">
          <div class="icon-item-content"> <el-icon size="35" color="white">
              <Menu />
            </el-icon>
            <span class="icon-text" style="margin-top:8px;color:white;font-size: 14px;text-align: center;">组成指挥</span>
          </div>
        </div>
        <div class="icon-item" @click="handleMenuClick('menu1')">
          <div class="icon-item-content"><el-icon size="35" color="white">
              <Menu />
            </el-icon>
            <span style="margin-top:8px;color:white;font-size: 14px;">房按办法</span>
          </div>
        </div>
      </div>
    </div>

    <yeWuGongJu_T v-if="showSidebar" @close="showSidebar = false" @submit="submit" @view="handleView" />

    <!-- chaKanXinXi 弹窗 - 使用 Teleport 渲染到 body，避免 z-index 问题 -->
    <Teleport to="body">
      <ChaKanXinXi v-if="showChaKanXinXi" :fullScreen="true" :hidePrevButton="true" @close="handleCloseChaKanXinXi" />
    </Teleport>
  </div>
</template>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 45px);
  padding: 0;
  margin: 0;
  position: relative;
  /* 为绝对定位的子元素提供定位上下文 */
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
  top: 15px;
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
  top: 100px;
  left: 20px;
  height: auto;
  width: 210px;
  background: rgba(7, 7, 7, 0.7);
  padding: 10px 20px 20px 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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

.footer-box-item {
  height: 20px;
  width: 120px;
  background-color: rgb(22, 43, 112);
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.footer-box-item:hover {
  background-color: rgb(25, 50, 130);
}

.footer-box-item p {
  color: rgb(156, 174, 222);
  font-size: 14px;
  text-align: center;
  font-weight: bold;
}

.footer-box-item-selected {
  background-color: rgb(19, 35, 90) !important;
  border-bottom: 2px solid rgb(82, 117, 198) !important;
  box-sizing: border-box !important;
}
</style>
