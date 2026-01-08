<template>
    <div class="header-renWuGuiHua">
        <div class="header-renWuGuiHua-items" :style="itemStyle0">
            <p style="color: white;font-size: 16px;font-weight: bold;">任务管理</p>
        </div>
        <div class="header-renWuGuiHua-items" style="background-image: url('/PZJHX/jianTou-blue.png');">
        </div>
        <div class="header-renWuGuiHua-items" :style="itemStyle1">
            <p style="color: white;font-size: 16px;font-weight: bold;">任务分解分配 </p>
        </div>
        <div class="header-renWuGuiHua-items" style="background-image: url('/PZJHX/jianTou-blue.png');">
        </div>
        <div class="header-renWuGuiHua-items" :style="itemStyle2">
            <p style="color: white;font-size: 16px;font-weight: bold;">作战规划 </p>
        </div>
    </div>
</template>

<script setup>
import { inject, computed, ref } from 'vue'

// 注入时间线状态
const timelineState = inject('timelineState', ref({
  step1: false, // 任务管理（任务弹窗激活）
  step2: false, // 任务分解分配（受领>规划>确定后进入pozhang）
  step3: false  // 作战规划（pozhang点击下一步）
}))

// 获取状态值（处理 ref 或普通对象）
const getState = () => {
  return timelineState.value || timelineState
}

// 每个项目的样式（响应式）
const itemStyle0 = computed(() => {
  const state = getState()
  const isActive = state.step1 || false
  return {
    backgroundImage: isActive ? "url('/daoHangLan/next.png')" : "url('/daoHangLan/ing.png')"
  }
})

const itemStyle1 = computed(() => {
  const state = getState()
  const isActive = state.step2 || false
  return {
    backgroundImage: isActive ? "url('/daoHangLan/next.png')" : "url('/daoHangLan/ing.png')"
  }
})

const itemStyle2 = computed(() => {
  const state = getState()
  const isActive = state.step3 || false
  return {
    backgroundImage: isActive ? "url('/daoHangLan/next.png')" : "url('/daoHangLan/ing.png')"
  }
})
</script>

<style scoped>
.header-renWuGuiHua {
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: fixed;
    padding: 0 120px;
    box-sizing: border-box;
    z-index: 3003;
    top: 45px;
    left: 0;
    width: 100%;
    height: 90px;
    background-color: rgb(15,30,61);
}
.header-renWuGuiHua-items{
    display: flex;
    justify-content: center;
    align-items: center;
    background-image: url('/daoHangLan/ing.png');
    width: 160px;
    height: 55px;
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}
</style>
