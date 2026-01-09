<script setup>
import { ref, computed, provide, watch } from 'vue';
import { RouterView, useRoute, useRouter } from 'vue-router';
import { Odometer, Close } from '@element-plus/icons-vue';
import renWuGuiHua_T from '@/components/breachPlanSeat/renWuGuiHua_T.vue';

const route = useRoute();
const router = useRouter();
const isActive = ref(false); // 按钮是否选中
const showRenWuGuiHua = ref(false);
const showMore = ref(false);
const activeIndex = ref(0);

// 任务弹窗激活状态（用于时间线）
const taskDialogActive = ref(false);
// 提供任务弹窗激活状态给子组件
provide('taskDialogActive', taskDialogActive);

// 统一管理所有按钮的激活状态（只能有一个激活）
// 使用字符串标识：'button-0', 'button-1', 'button-2', 'button-3', 'button-4', 'task', 'tiancai'
const activeButtonId = ref(null);

// 处理右侧按钮点击
const handleHeaderButtonClick = (index) => {
  const buttonId = `button-${index}`;
  if (activeButtonId.value === buttonId) {
    // 如果已经激活，则取消激活
    activeButtonId.value = null;
  } else {
    // 激活当前按钮，取消其他所有按钮
    activeButtonId.value = buttonId;
  }
};

// 处理天才按钮点击
const handleTianCaiClick = () => {
  if (activeButtonId.value === 'tiancai') {
    // 如果已经激活，则取消激活
    activeButtonId.value = null;
  } else {
    // 激活天才按钮，取消其他所有按钮
    activeButtonId.value = 'tiancai';
  }
};

// 处理任务弹窗按钮点击（修改为统一激活状态管理）
const handleTaskClick = () => {
  if (!isModeOne.value) {
    return; // 如果不在模式一，不允许操作
  }
  if (activeButtonId.value === 'task') {
    // 如果已经激活，则取消激活
    activeButtonId.value = null;
    isActive.value = false;
    showRenWuGuiHua.value = false;
    taskDialogActive.value = false; // 更新时间线状态
  } else {
    // 激活任务弹窗按钮，取消其他所有按钮
    activeButtonId.value = 'task';
    isActive.value = true;
    showRenWuGuiHua.value = true;
    taskDialogActive.value = true; // 更新时间线状态
  }
};

// 判断是否显示 header（登录和模式选择页面不显示）
const showHeader = computed(() => {
  return route.path !== '/login' && route.path !== '/mode-select';
});

// 判断是否为模式一（只有模式一才能使用任务弹窗）
const isModeOne = computed(() => {
  return route.path === '/pzjhx';
});

// 打开任务弹窗的方法
const openTaskDialog = () => {
  if (!isModeOne.value) {
    return; // 如果不在模式一，不允许操作
  }
  showRenWuGuiHua.value = true;
  isActive.value = true;
  taskDialogActive.value = true;
  activeButtonId.value = 'task';
};

// 提供打开任务弹窗的方法给子组件
provide('openTaskDialog', openTaskDialog);

const exitUser = () => {
  showMore.value = !showMore.value;
};

// 处理菜单项点击
const handleMenuItemClick = (index) => {
  activeIndex.value = index;
  if (index === 0) {
    // 退出登录
    showMore.value = false;
    // 关闭任务弹窗
    showRenWuGuiHua.value = false;
    isActive.value = false;
    activeButtonId.value = null;
    router.push('/login');
  }
  // 其他选项暂时不处理
};

// 关闭任务规划弹窗
const handleCloseRenWuGuiHua = () => {
  showRenWuGuiHua.value = false;
  isActive.value = false;
  taskDialogActive.value = false; // 重置时间线状态
  // 如果当前激活的是任务弹窗按钮，则清除激活状态
  if (activeButtonId.value === 'task') {
    activeButtonId.value = null;
  }
};
</script>
<template>
  <div>
    <!-- 系统的导航栏 -->
    <header v-if="showHeader" class="header">
      <div class="header-left-container">
        <div class="header-left-box-item" style='margin-left: -14px;'>
          <img src="/daoHangLan/p.png" alt="" style="width: 33px; height: 33px;">
          <span class="text-wrap" style="margin-right: 30px;">杨哥杨哥你的技术到<br>底怎么练的PSDWD107</span>
        </div>
        <div class="header-left-box-item">
          <img src="/daoHangLan/canMou.png" alt="" style="width: 33px; height: 33px;">
          <p style="font-size: 14px;font-weight: bold;margin-right: 40px;">MC<br>天佑</p>
        </div>
        <div class="header-left-box-item">
          <img src="/daoHangLan/shiJian.png" alt="" style="width: 25px; height: 25px;">
          <p style="color:rgb(231,219,115);font-weight: bold;font-size: 15px;">天才 2022/42/24 14:20:55 杨哥 2022/42/24
            14:20:55</p>
        </div>
      </div>
      <div class="header-center-icon">
        <el-icon size="32">
          <Odometer />
        </el-icon>
      </div>
      <div class="header-right-container">
        <div class="header-right-box">
          <div class="header-right-box-item" 
            :class="{ active: activeButtonId === 'button-0' }"
            @click="handleHeaderButtonClick(0)">
            <img src="/daoHangLan/weiXianJinBao.png" alt="" style="width: 20px; height: 20px;">
            <p>天才杨哥</p>
          </div>
          <div class="header-right-box-item"
            :class="{ active: activeButtonId === 'button-1' }"
            @click="handleHeaderButtonClick(1)">
            <img src="/daoHangLan/baoWenTongZhi.png" alt="" style="width: 20px; height: 20px;">
            <p>天才杨哥</p>
          </div>
          <div class="header-right-box-item"
            :class="{ active: activeButtonId === 'button-2' }"
            @click="handleHeaderButtonClick(2)">
            <img src="/daoHangLan/xiTongXiaoXi.png" alt="" style="width: 20px; height: 20px;">
            <p>系统设置</p>
          </div>
          <div class="header-right-box-item"
            :class="{ active: activeButtonId === 'button-3' }"
            @click="handleHeaderButtonClick(3)">
            <img src="/daoHangLan/shouFaYouJian.png" alt="" style="width: 20px; height: 20px;">
            <p>收发邮件</p>
          </div>
          <div class="header-right-box-item"
            :class="{ active: activeButtonId === 'button-4' }"
            @click="handleHeaderButtonClick(4)">
            <img src="/daoHangLan/jianBao.png" alt="" style="width: 20px; height: 20px;">
            <p>监保</p>
          </div>
          <div class="header-right-box-item"
            :class="{ active: activeButtonId === 'task', disabled: !isModeOne }"
            @click="handleTaskClick">
            <img src="/daoHangLan/renWuGuiHua.png" alt="" style="width: 20px; height: 20px;">
            <p>任务弹窗</p>
          </div>
          <div class="header-right-box-item"
            :class="{ active: activeButtonId === 'tiancai' }"
            @click="handleTianCaiClick">
            <p style="margin-right: 20px;">天才</p>
          </div>
          <div @click="exitUser()">
            <span style="display:flex;align-items:center; justify-content: center;color:white;font-size: 24px;"><img
                src="/daoHangLan/caiDan.png" alt="" style="width: 20px; height: 20px;"></span>
          </div>
        </div>
      </div>
    </header>
    <!-- 退出用户弹窗 -->
    <div v-if="showHeader && showMore"
      style="position: absolute; top: 45px; z-index: 1001;right: 0; width: 117px;height: 156px; background-color:rgb(11,25,53);border: 1px solid rgb(149,174,227);">
      <div
        style="display: flex;flex-direction: column;justify-content: center;align-items: center;height: 100%;padding: 5px;box-sizing: border-box;color: white;font-size: 15px;font-weight: bold;">
        <p class="menu-item" :class="{ active: activeIndex === 0 }" @click="handleMenuItemClick(0)"
          style="flex: 1; display:flex; align-items:center; ">退出登录 <el-icon>
            <Close />
          </el-icon></p>
        <p class="menu-item" :class="{ active: activeIndex === 1 }" @click="handleMenuItemClick(1)"
          style="flex: 1; display:flex; align-items:center; ">关闭系统 <el-icon>
            <Close />
          </el-icon></p>
        <p class="menu-item" :class="{ active: activeIndex === 2 }" @click="handleMenuItemClick(2)"
          style="flex: 1; display:flex; align-items:center; ">返回桌面 <el-icon>
            <Close />
          </el-icon></p>
        <p class="menu-item" :class="{ active: activeIndex === 3 }" @click="handleMenuItemClick(3)"
          style="flex: 1; display:flex; align-items:center; ">系统设置 <el-icon>
            <Close />
          </el-icon></p>
      </div>
    </div>
    <router-view />
    <renWuGuiHua_T v-if="showRenWuGuiHua" @close="handleCloseRenWuGuiHua" />
  </div>
</template>

<style scoped>
.header {
  height: 45px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: rgb(22, 37, 118);
  color: white;
  position: relative;
  background-image: url('/header-bag.png');
  z-index: 1001;
}

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

.header-left-box-item {
  display: flex;
  align-items: center;
  gap: 10px;
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
  gap: 15px;
}

.header-right-box .el-icon,
.header-right-box p {
  margin: 0;
  white-space: nowrap;
}

.header-right-box-item {
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  padding: 5px 10px;
  border-radius: 4px;
  transition: all 0.3s ease;
  position: relative;
  height: 100%;
}

.header-right-box-item:hover {
  transform: translateX(4px);
}

.header-right-box-item.active {
  background-color: rgb(99, 103, 114);
  border-radius: 0;
  height: 100%;
}

.header-right-box-item.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

.header-right-box-item.disabled:hover {
  transform: none;
}




.scroll-bar {
  overflow-y: auto;
  overflow-x: hidden;
  /* 必须：防止出现横向滚动 */
  box-sizing: border-box;

}

</style>