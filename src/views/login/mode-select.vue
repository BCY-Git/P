<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const selectedMode = ref(null);

const modes = [
  { id: 1, name: 'breachPlanSeat', route: '/pzjhx' },
  { id: 2, name: 'channelCommandSeat', route: '/tdzhx' },
  { id: 3, name: '模式三', route: '/wzkzx' },
  { id: 4, name: '模式四', route: '/zcdqx' },
  { id: 5, name: '模式五', route: '/pzqhx' },
];

const selectMode = (modeId) => {
  selectedMode.value = modeId;
};

const handleConfirm = () => {
  if (!selectedMode.value) return;

  const mode = modes.find(m => m.id === selectedMode.value);
  if (mode && mode.route) {
    router.push(mode.route);
  }
};

const handleCancel = () => {
  router.push('/login');
};
</script>
<template>
  <div class="mode-select-container">
    <div class="mode-select-box">
      <h2 class="mode-title">请选择模式</h2>
      <div class="mode-list">
        <div v-for="mode in modes" :key="mode.id" class="mode-item" :class="{ active: selectedMode === mode.id }"
          @click="selectMode(mode.id)">
          <span class="mode-label">{{ mode.name }}</span>
        </div>
      </div>
      <div class="button-group">
        <el-button @click="handleCancel" size="large">取消</el-button>
        <el-button type="primary" size="large" @click="handleConfirm" :disabled="!selectedMode">
          确认
        </el-button>
      </div>
    </div>
  </div>
</template>



<style scoped>
.mode-select-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: rgb(21, 32, 99);
}

.mode-select-box {
  background: rgba(255, 255, 255, 0.95);
  padding: 40px 60px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  min-width: 400px;
}

.mode-title {
  margin-bottom: 30px;
  color: #333;
  font-size: 24px;
  font-weight: bold;
  text-align: center;
}

.mode-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 30px;
}

.mode-item {
  padding: 15px 20px;
  border: 2px solid #e0e0e0;
  cursor: pointer;
  transition: all 0.3s;
  text-align: center;
}

.mode-item:hover {
  border-color: #667eea;
  background-color: #f5f5f5;
}

.mode-item.active {
  border-color: #667eea;
  background-color: #667eea;
  color: white;
}

.mode-label {
  font-size: 16px;
  font-weight: 500;
}

.button-group {
  display: flex;
  gap: 15px;
  justify-content: center;
}

.button-group .el-button {
  flex: 1;
  height: 45px;
  font-size: 16px;
}
</style>
