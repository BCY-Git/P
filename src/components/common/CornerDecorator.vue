<template>
	<div>
		<div class="corner-decorator corner-top-left" :style="decoratorStyle"></div>
		<div class="corner-decorator corner-top-right" :style="decoratorStyle"></div>
		<div class="corner-decorator corner-bottom-left" :style="decoratorStyle"></div>
		<div class="corner-decorator corner-bottom-right" :style="decoratorStyle"></div>
	</div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
	// 边框颜色
	borderColor: {
		type: String,
		default: 'rgb(90, 154, 214)'
	},
	// 边框宽度
	borderWidth: {
		type: String,
		default: '3px'
	},
	// 装饰宽度
	width: {
		type: String,
		default: '5px'
	},
	// 装饰高度
	height: {
		type: String,
		default: '8px'
	},
	// z-index
	zIndex: {
		type: [String, Number],
		default: 1
	},
	// 容器边框宽度（用于对齐装饰在border上）
	containerBorderWidth: {
		type: String,
		default: '0px'
	}
})

const decoratorStyle = computed(() => {
	// 计算偏移量：让装饰的边框与容器的border对齐
	// 装饰元素需要向外偏移，使装饰边框的外边缘与容器边框的外边缘对齐
	// 偏移量 = -(装饰边框宽度 / 2) + (容器边框宽度 / 2)
	const borderWidthNum = parseFloat(props.borderWidth) || 3
	const containerBorderWidthNum = parseFloat(props.containerBorderWidth) || 0
	const offset = -(borderWidthNum / 2) + (containerBorderWidthNum / 2)

	return {
		borderColor: props.borderColor,
		borderWidth: props.borderWidth,
		width: props.width,
		height: props.height,
		zIndex: props.zIndex,
		'--offset': `${offset}px`
	}
})
</script>

<style scoped>
.corner-decorator {
	position: absolute;
	border-style: solid;
	pointer-events: none;
}

.corner-top-left {
	top: var(--offset, 0);
	left: var(--offset, 0);
	border-right: none;
	border-bottom: none;
}

.corner-top-right {
	top: var(--offset, 0);
	right: var(--offset, 0);
	border-left: none;
	border-bottom: none;
}

.corner-bottom-left {
	bottom: var(--offset, 0);
	left: var(--offset, 0);
	border-right: none;
	border-top: none;
}

.corner-bottom-right {
	bottom: var(--offset, 0);
	right: var(--offset, 0);
	border-left: none;
	border-top: none;
}
</style>
