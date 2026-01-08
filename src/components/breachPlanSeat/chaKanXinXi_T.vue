<template>
	<div class="chaKanXinXi-wrapper" :style="overlayStyle">
		<div class="chaKanXinXi-container">
			<div class="chaKanXinXi-content">
				<div class="chaKanXinXi-right">
					<!-- 第一行：左上和右上 -->
					<div class="chaKanXinXi-row">
						<!-- 左上：A组件 -->
						<div class="chaKanXinXi-chart chaKanXinXi-chart-top-left">
							<!-- 标题行 -->
							<div class="chaKanXinXi-title">

								<h3 class="chaKanXinXi-title-text">图表A</h3>
							</div>
							<!-- 内容区 -->
							<div class="chaKanXinXi-content-area">
								<A />
							</div>
						</div>

						<!-- 右上：B组件 -->
						<div class="chaKanXinXi-chart chaKanXinXi-chart-top-right">
							<!-- 标题行 -->
							<div class="chaKanXinXi-title">

								<h3 class="chaKanXinXi-title-text">图表B</h3>
							</div>
							<!-- 内容区 -->
							<div class="chaKanXinXi-content-area">
								<B />
							</div>
						</div>
					</div>
										<!-- 第二行：左下和右下 -->
					<div class="chaKanXinXi-row">
						<!-- 左下：A组件 -->
						<div class="chaKanXinXi-chart chaKanXinXi-chart-bottom-left">
							<!-- 标题行 -->
							<div class="chaKanXinXi-title">

								<h3 class="chaKanXinXi-title-text">图表A</h3>
							</div>
							<!-- 内容区 -->
							<div class="chaKanXinXi-content-area">
								<A />
							</div>
						</div>

						<!-- 右下：PentagonChart组件 -->
						<div class="chaKanXinXi-chart chaKanXinXi-chart-bottom-right">
							<!-- 标题行 -->
							<div class="chaKanXinXi-title">

								<h3 class="chaKanXinXi-title-text">五边形图表</h3>
							</div>
							<!-- 内容区 -->
							<!-- <div class="chaKanXinXi-content-area chaKanXinXi-content-center">
								<PentagonChart :size="300" :layers="5" :max-radius="200"
									:colors="['#10b9ec', '#2424d3', '#1a1aff', '#3333ff', '#1414c5']"
									:values="[100, 60, 50, 0, 80]" point-color="#ffffff" :point-radius="4"
									:labels="['语文数学运营', '语文学科\n是好的啊', '语文学科\n是好的啊', '语文学科\n是好的啊', '语文学科\n是好的啊']"
									label-color="black" :label-size="25" :label-offset="33" :show-outer="false"
									:label-dy-offset="17" />
							</div> -->

							<div class="xindong-table">
								<el-table :data="tableData" style="width: 100%">
									<el-table-column prop="index" label="序号" width="120" />
									<el-table-column prop="name" label="名称名称" width="120" />
									<el-table-column prop="type" label="类型类型" width="120" />
									<el-table-column prop="belong" label="所属类型类型" width="120" />
									<el-table-column prop="start" label="开始类型类型" width="120" />
									<el-table-column prop="end" label="结束时间" width="120" />
									<el-table-column prop="power" label="力量类型" width="120" />
									<el-table-column prop="area" label="区域类型" width="120" > 
										<template #default="scope">
											<div
											style="display: flex; align-items: center; justify-content: start;  padding-left: 35px;">
											<el-icon size="25">
												<Location />
											</el-icon>
										</div>
										</template>
									</el-table-column>
								</el-table>
							</div>
							<!-- 按钮区域 -->
							<div class="chaKanXinXi-buttons">
								<button class="chaKanXinXi-btn chaKanXinXi-btn-next" @click="handleNext">下一步</button>
								<button class="chaKanXinXi-btn chaKanXinXi-btn-confirm"
									@click="handleConfirm">确定</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup>

const tableData = [
	{
		index: '1',
		name: 'Tom',
		type: '类型A',
		belong: '所属A',
		start: '2025-01-01',
		end: '2025-01-10',
		power: '80',
		area: '一区',
	},
	{
		index: '2',
		name: 'Jerry',
		type: '类型B',
		belong: '所属B',
		start: '2025-02-01',
		end: '2025-02-15',
		power: '60',
		area: '二区',
	},
	{
		index: '3',
		name: 'Lily',
		type: '类型C',
		belong: '所属C',
		start: '2025-03-01',
		end: '2025-03-20',
		power: '75',
		area: '三区',
	},
	{
		index: '4',
		name: 'Jack',
		type: '类型D',
		belong: '所属D',
		start: '2025-04-05',
		end: '2025-04-12',
		power: '90',
		area: '四区',
	},
];

import { Edit } from '@element-plus/icons-vue'
import PentagonChart from '@/views/PentagonChart.vue'
import A from '@/views/A.vue'
import B from '@/views/B.vue'

const emit = defineEmits(['next', 'close'])

const handleNext = () => {
	emit('next')
}

const handleConfirm = () => {
	emit('close')
}

import { ref, onMounted, computed } from 'vue'
const headerBottom = ref(135)
onMounted(() => {
	const el = document.querySelector('.header-renWuGuiHua')
	if (el) {
		const rect = el.getBoundingClientRect()
		headerBottom.value = Math.round(rect.bottom)
	}
})

const overlayStyle = computed(() => ({
	top: headerBottom.value + 'px',
	height: `calc(100vh - ${headerBottom.value}px - 10px)`
}))
</script>

<style scoped>
.chaKanXinXi-wrapper {
	position: fixed;
	left: 0;
	width: 100%;
	z-index: 3007;
	pointer-events: auto;
	background-color: #0d1f49;
}

.chaKanXinXi-container {
	height: 100%;
	width: 100%;
	margin-top: 0;
	overflow: hidden;
}

.chaKanXinXi-content {
	width: 100%;
	height: 100%;
	display: flex;
	flex-direction: row;
	padding: 0px 10px 10px 10px;
}

.chaKanXinXi-left {
	width: 450px;
	height: 100%;
	flex-shrink: 0;
}

.chaKanXinXi-right {
	width: 100%;
	min-width: 0;
	height: 100%;
	display: flex;
	flex-direction: column;
	margin-right: 20px;
}

.chaKanXinXi-row {
	display: flex;
	height: 50%;
	width: 100%;
	box-sizing: border-box;
	flex-shrink: 0;
}

.chaKanXinXi-chart {
	display: flex;
	flex-direction: column;
	flex: 1;
	min-width: 0;
	height: 100%;
	border: 2px solid #6a99e9;
	box-sizing: border-box;
	background-color: #0d1f49;
}

.chaKanXinXi-chart-top-right {
	border-left: none;
}

.chaKanXinXi-chart-bottom-left {
	border-top: none;
}

.chaKanXinXi-chart-bottom-right {
	border-left: none;
	border-top: none;
	position: relative;
}

.chaKanXinXi-title {
	height: 44px;
	width: 100%;
	display: flex;
	align-items: center;
}

.chaKanXinXi-title-text {
	color: white;
	padding-left: 40px;
	background-color: rgb(22, 55, 151);
	width: 100%;
	height: 100%;
	display: flex;
	align-items: center;
}

.chaKanXinXi-content-area {
	flex: 1;
	min-height: 0;
	padding: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.chaKanXinXi-content-center {
	display: flex;
	align-items: center;
	justify-content: center;
}

.chaKanXinXi-buttons {
	position: absolute;
	bottom: 20px;
	right: 20px;
	display: flex;
	gap: 10px;
	z-index: 10;
}

.chaKanXinXi-btn {
	height: 35px;
	padding: 0 20px;
	border: 2px solid #3665d2;
	color: #ffffff;
	font-weight: bold;
	background-color: #002588;
	cursor: pointer;
	font-size: 16px;
	transition: all 0.3s;
}

.chaKanXinXi-btn:hover {
	background-color: #0033aa;
	border-color: #4a7de8;
}

.chaKanXinXi-btn-confirm {
	background-color: #0b2974;
}

.chaKanXinXi-btn-confirm:hover {
	background-color: #0d3a8f;
}



.xindong-table :deep(.el-table th) {
	color: white !important;
	border-bottom: 2px solid #6a99e9 !important;
	border-top: none !important;
	border-left: none !important;
	border-right: none !important;
	height: 50px !important;
	line-height: 50px !important;
	text-align: center !important;
	padding: 0 !important;
}

.xindong-table :deep(.el-table td) {
	border-bottom: 2px solid #6a99e9 !important;
	border-top: none !important;
	border-left: none !important;
	border-right: none !important;
	text-align: center !important;
	padding: 12px 0 !important;
	height: 70px !important;
	line-height: 70px !important;
	max-height: 70px !important;
	
}







</style>
