<template>
<div class="menu-container">
  <div class="menu-item">
    <p 
      v-for="(item, index) in menuItems" 
      :key="index"
      class="row" 
      :class="{ 'selected': selectedIndex === index }"
      @click="selectedIndex = index">
      <el-icon size="27"><component :is="item.icon" /></el-icon> {{ item.label }}
    </p>
  </div>
</div>

</template>

<script setup>
import { ref } from 'vue'
import { User, Menu } from '@element-plus/icons-vue'

const menuItems = [
  { label: '菜单', icon: User },
  { label: '作战笔迹', icon: Menu },
  { label: '任务规划', icon: Menu },
  { label: '物资管理', icon: Menu },
  { label: '工具管理', icon: Menu }
]

const selectedIndex = ref(2)
</script>

<style scoped>
.menu-container {
    position: absolute;
    bottom: 40px;
    left: 20px;
    width: 300px;
    height: 300px;
    background-color: rgba(17,32,73);
    color: white;
    cursor: pointer;
    padding: 10px;
    box-sizing: border-box;
    z-index: 1000;
}
.menu-item {
    height: 90%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 10px;
    border: 2px solid rgba(1,226,252);
}

.menu-item p {
    font-size: 16px;
    color: white;
    background-color: rgba(112,112,112);
    padding: 10px;
    cursor: pointer;
    transition: all 0.3s;
}

/* 选中的项：没有背景色 */
.menu-item p.selected {
    background-color: transparent;
}

/* 未选中的项：降低字体透明度 */
.menu-item p:not(.selected) {
    opacity: 0.6;
}

/* 关键：让图标与文字垂直居中 */
.menu-item .row {
  display: flex;
  align-items: center;
  gap: 6px;
}

</style>