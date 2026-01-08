<template>
    <div
      class="stamp stamp-animated"
      :class="{ 'stamp-approved': shouldShowApproved }"
      :style="computedStyle"
    ></div>
  </template>
  
  <script setup>
  import { computed, watch, ref, nextTick, onMounted } from 'vue'
  
  // props
  const props = defineProps({
    auditstatus: {
      type: [String, Number],
      default: 0
    },
  
    // 自定义位置和大小（可选）
    top: { type: String, default: "-80px" },
    left: { type: String, default: "150px" },
    size: { type: String, default: "60px" }
  })
  
  // 状态 → 图片映射（支持5个状态）
  const statusImageMap = {
    0: "/breachPlanSeat/weiShenHe.png",
    1: "/breachPlanSeat/shenPiZhong.png",
    2: "/breachPlanSeat/shenPiZhong.png", // 可以根据需要修改
    3: "/breachPlanSeat/shenPiZhong.png", // 可以根据需要修改
    4: "/breachPlanSeat/shenPiZhong.png", // 可以根据需要修改
  }
  
  // 默认图片（当状态不在映射中时使用）
  const defaultImage = "/breachPlanSeat/weiShenHe.png"
  
  // 当前状态（统一转换成数字）
  const statusNumber = computed(() => {
    const num = Number(props.auditstatus)
    // 处理NaN情况
    return isNaN(num) ? 0 : num
  })
  
  // 获取当前状态对应的图片路径
  const currentImage = computed(() => {
    const image = statusImageMap[statusNumber.value]
    if (!image) {
      console.warn(`Stamp组件: 状态 ${statusNumber.value} 没有对应的图片映射，使用默认图片`)
      return defaultImage
    }
    return image
  })
  
  // 控制动画触发的标志（使用ref以便手动控制动画触发）
  const shouldShowApproved = ref(false)
  
  // 初始化shouldShowApproved
  const initApprovedState = () => {
    shouldShowApproved.value = statusNumber.value === 1
  }
  
  // 监听状态变化，当变为 1 时触发动画
  watch(() => props.auditstatus, (newVal, oldVal) => {
    const newStatus = Number(newVal)
    const oldStatus = oldVal !== undefined ? Number(oldVal) : null
    
    // 添加调试日志
    console.log(`Stamp组件状态变化: ${oldStatus} -> ${newStatus}`, {
      newVal,
      oldVal,
      image: currentImage.value,
      statusNumber: statusNumber.value,
      imagePath: currentImage.value
    })
    
    // 如果状态变为1，先移除class再添加以触发动画
    if (newStatus === 1 && oldStatus !== 1) {
      shouldShowApproved.value = false
      nextTick(() => {
        shouldShowApproved.value = true
      })
    } else {
      // 其他情况直接更新状态
      shouldShowApproved.value = newStatus === 1
    }
  }, { immediate: true })
  
  // 组件挂载时初始化
  onMounted(() => {
    initApprovedState()
  })
  
  // 计算 style
  const computedStyle = computed(() => {
    const imageUrl = currentImage.value
    return {
      position: "absolute",
      top: props.top,
      left: props.left,
      width: props.size,
      height: props.size,
      backgroundImage: `url('${imageUrl}')`,
      backgroundPosition: "center",
      backgroundSize: "cover",
      backgroundColor: "rgb(181,158,107)",
      borderRadius: "50%"
    }
  })
  </script>
  
  <style scoped>
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
</style>
  