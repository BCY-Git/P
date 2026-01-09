<script setup>
import axios from 'axios'
const tableData = ref([
	{
		date: '1',
		name: '001',
		address: '岸本齐是',
		location: 'LocationIcon',
	},
	{
		date: '2',
		name: '002',
		address: '岸本齐是',
	},
	{
		date: '3',
		name: '003',
		address: '三角形',
	},
	{
		date: '4',
		name: '004',
		address: '三角锥',
	},
])
import { ref, onMounted, computed, watch, nextTick, onBeforeUnmount } from 'vue'
import { Location } from '@element-plus/icons-vue'
import CornerDecorator from '@/components/common/CornerDecorator.vue'
const emit = defineEmits(['close', 'next'])

//响应式变量
const branches = ref([]) // 存储完整的子任务列表（包含id）
const taskData = ref([])
//响应式变量



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

const form = ref({
	username: '',
	phone1: '',
	phone2: '',
	startHour: '',
	startMinute: '',
	endHour: '',
	endMinute: ''
})

const checkAll = ref(false)
const users = ref([
	{ name: '张三', age: 20, city: '北京' },
	{ name: '李四', age: 22, city: '上海' },
	{ name: '王五', age: 28, city: '广州' }
])

const selectedCount = ref(0)

const sel1 = ref('')
const sel2 = ref('')
const sel3 = ref('')

const selectedId = ref(null)
const showMenu = ref(false)
const showInfoPanels = ref(false)
const isConfirmed = ref(false)

// 计算是否可以进入下一步
const canProceed = computed(() => {
	return expanded.value && selectedId.value !== null && isConfirmed.value
})

const rootStyle = computed(() => {
	if (expanded.value) {
		return {
			position: 'absolute',
			top: '50%',
			left: '40px',
			transform: 'translateY(-50%)'
		}
	} else {
		return {
			position: 'absolute',
			top: '50%',
			left: '50%',
			transform: 'translate(-50%, -50%)'
		}
	}
})

function selectNode(i) {
	selectedId.value = i
	showInfoPanels.value = true
	// 选择节点后重置确认状态
	isConfirmed.value = false
	
	// 获取选中节点的id并调用详情接口
	const selectedNode = branches.value[i]
	if (selectedNode && selectedNode.id) {
		getSubtaskDetail(selectedNode.id)
	}
}

function toggleAll(val) {
	selectedCount.value = val ? users.value.length : 0
}

function viewUser(row) {
	console.log('view', row)
}

function addUser() {
	users.value.push({ name: '新用户', age: 18, city: '深圳' })
}

function emitClose() {
	emit('close')
}

function emitNext() {
	emit('next')
}

//接口请求
const getChildrenNodes = () => {
	axios.get('/api/subtask_listNoPage').then(res => {
		console.log(res.data)
		// 保存完整的子任务列表（包含id）
		branches.value = res.data
	})
}

// 获取子任务详情
const getSubtaskDetail = (id) => {
	axios.get(`/api/subtask/${id}`).then(res => {
		console.log('子任务详情:', res.data)
		console.log("比较", res.data)
		const detail = res.data
		if (res.data) {
			// 将详情数据填充到表单
			fillFormData(detail)
			// 保存到 taskData
			
			taskData.value = res.data
			console.log("比较", res.data)
		} 
	}).catch(err => {
		console.error('获取子任务详情失败:', err)
	})
}

// 填充表单数据
const fillFormData = (detail) => {
	console.log("比较", detail)
	// 填充任务名称和任务类型
	form.value.username = detail.subtaskName || ''
	form.value.phone1 = detail.subtaskType || ''
	// 解析开始时间 "2025-12-04 10:00:00"
	if (detail.startTime) {
		const startTime = new Date(detail.startTime)
		form.value.startHour = String(startTime.getHours()).padStart(2, '0')
		form.value.startMinute = String(startTime.getMinutes()).padStart(2, '0')
	}
	
	// 解析结束时间
	if (detail.endTime) {
		const endTime = new Date(detail.endTime)
		form.value.endHour = String(endTime.getHours()).padStart(2, '0')
		form.value.endMinute = String(endTime.getMinutes()).padStart(2, '0')
	}
}




// 心智图数据与连线
const expanded = ref(false)


const rootRef = ref(null)
const treeRef = ref(null)
const nodeRefs = ref([])
const paths = ref([])

function toggleExpand() {
	expanded.value = !expanded.value
}

function handleAutoDecompose() {
	showMenu.value = false
	expanded.value = true
}

function handleManualDecompose() {
	showMenu.value = false
	// 手动分解的逻辑
}

function handleOneClickPlan() {
	showMenu.value = false
	// 一键行动规划的逻辑
}

function handleConfirm() {
	isConfirmed.value = true
}

function handleCancel() {
	selectedId.value = null
	showInfoPanels.value = false
	isConfirmed.value = false
}

function makePath(rootRect, nodeRect, containerRect, index, total) {
	const rootRightX = rootRect.right - containerRect.left
	const rootCenterY = rootRect.top - containerRect.top + rootRect.height / 2
	const nodeLeftX = nodeRect.left - containerRect.left
	const nodeCenterY = nodeRect.top - containerRect.top + nodeRect.height / 2
	const spread = 18
	const fan = (index - (total - 1) / 2) * spread
	const cp1x = rootRightX + 10
	const cp2x = nodeLeftX - 10
	const cp1y = rootCenterY + fan
	const cp2y = nodeCenterY
	return `M ${rootRightX} ${rootCenterY} C ${cp1x} ${cp1y}, ${cp2x} ${cp2y}, ${nodeLeftX} ${nodeCenterY}`
}

async function recomputePaths() {
	await nextTick()
	const container = treeRef.value
	const root = rootRef.value
	if (!container || !root || !expanded.value) {
		paths.value = []
		return
	}
	const containerRect = container.getBoundingClientRect()
	const rootRect = root.getBoundingClientRect()
	const ds = []
	const total = nodeRefs.value.length
	nodeRefs.value.forEach((el, i) => {
		if (!el) return
		const nodeRect = el.getBoundingClientRect()
		ds.push(makePath(rootRect, nodeRect, containerRect, i, total))
	})
	paths.value = ds
}

let ro
onMounted(() => {
	ro = new ResizeObserver(() => { recomputePaths() })
	if (treeRef.value) ro.observe(treeRef.value)

	// 点击外部关闭弹框
	document.addEventListener('click', (e) => {
		if (showMenu.value && !e.target.closest('.menu-popup') && !e.target.closest('.tree-root')) {
			showMenu.value = false
		}
	})
})

onBeforeUnmount(() => {
	if (ro) ro.disconnect()
})

watch(expanded, (val) => { if (val) recomputePaths() })
watch(branches, () => { recomputePaths() })

// 预留：后续接入 GET 接口
async function fetchMindBranches() {
	// const data = await fetch('/api/mind').then(r => r.json())
	// branches.value = data
	// recomputePaths()
}
</script>

<template>
	<div class="pozhang-overlay" :style="overlayStyle">
		<div class="pozhang-dialog">
			<div class="dialog-body">
				<div class="mind-panel">

					<div class="mind-tree" ref="treeRef" style="position: relative; overflow: hidden;">
						<CornerDecorator borderColor="rgb(120,170,155)" borderWidth="4px" width="8px" height="15px" />
						<div class="panel-title" style="position: absolute;top: 0;left: 5px;">
							<span style="display: flex;align-items: center;gap: 5px;"> <img src="/breachPlanSeat/shenPiZhong.png"
									alt="" style="width: 20px; height: 20px;"> 思维导图</span>
						</div>

						<div class="tree-root" ref="rootRef" @click.stop="showMenu = true" :style="rootStyle"
							style="background-image: url('');" @click="getChildrenNodes()"> 最强破障</div>

						<!-- 选项弹框 -->
						<div v-if="showMenu" class="menu-popup" @click.stop>
							<div class="menu-item" @click="handleAutoDecompose">自动分解</div>
							<div class="menu-item" @click="handleManualDecompose">手动分解</div>
							<div class="menu-item" @click="handleOneClickPlan">一键行动规划</div>
						</div>

						<div class="tree-branch" v-if="expanded">
							<div v-for="(t, i) in branches" :key="i" class="tree-node"
								style="background-image: url('');background-size: 100% 100%;background-position: center;"
								:class="{ selected: selectedId === i }" :ref="el => nodeRefs[i] = el"
								@click="selectNode(i)">
								<span class="node-text">{{ t.subtaskName }}</span>
							</div>
						</div>
						<svg class="mind-links" v-if="expanded">
							<path v-for="(d, i) in paths" :key="i" :d="d" />
						</svg>
					</div>
					<!-- <div class="mind-tools">
						<div class="tool">＋</div>
						<div class="tool">×</div>
						<div class="tool">●</div>
					</div> -->
					<div class="button-group">
						<el-button>
							查看
						</el-button>
						<el-button @click="emitNext" :disabled="!canProceed">
							下一步
						</el-button>
					</div>
				</div>

				<div class="right">
					<div class="info-panel-main"
						style="border: 2px solid rgb(103,135,183); margin-right: 20px;position: relative;">
						<CornerDecorator borderColor="rgb(120,170,155)" borderWidth="2px" width="8px" height="15px" />
						<div class="panel-title" style="background-color: rgb(22,55,190); padding-left: 30px;">
							<span style="font-size: 18px;color: white;">任务信息</span>
						</div>
						<div class="panel-content-main" v-if="showInfoPanels">
							<template v-if="selectedId !== null">
								<div class="form-row">
									<label>*任务名称</label>
									<el-input v-model="form.username" class="input" placeholder="" />
								</div>
								<div class="form-row">
									<label>*任务类型</label>
									<el-input v-model="form.phone1" class="input" placeholder="" />
								</div>


								<div class="form-row time-row">
									<label style="width: 80px;">*任务时间</label>
									<div class="time-inputs">
										<el-input v-model="form.startHour" class="time" />
										<span>时</span>
										<el-input v-model="form.startMinute" class="time" />
										<span>分至</span>
										<el-input v-model="form.endHour" class="time" />
										<span>时</span>
										<el-input v-model="form.endMinute" class="time" />
										<span>分</span>
									</div>
								</div>

								<div class="table-block">
									<div style="display: flex; ">
										<p style="width: 80px;color: white;padding-left: 10px;">*任务区域</p>
										<div style="flex: 1; padding-left: 10px;">
											<table class="simple-table">

												<thead>
													<tr>
														<th style="width:80px">序号</th>
														<th>任务类型区域</th>
														<th style="width:240px">操作</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>1</td>
														<td>六边形</td>
														<td>
															<el-button class="table-button"
																style="margin-right: 10px!important;">图上取点</el-button>
															<el-button class="table-button">取消</el-button>
														</td>
													</tr>
													<tr>
														<td>2</td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td>3</td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td colspan="3"><el-button class="table-button">图上取点</el-button>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>

									<div class="triple-selects">
										<p style="width: 85px;color: white;padding-left: 10px;">执行力量</p>
										<el-select class="simple-select" v-model="sel1" placeholder="请选择"></el-select>
									</div>
									<div class="triple-selects">
										<p style="width: 85px;color: white;padding-left: 10px;">是但任务</p>
										<el-select class="simple-select" v-model="sel2" placeholder="请选择"></el-select>
									</div>
									<div class="triple-selects">
										<p style="width: 85px;color: white;padding-left: 10px;">滑稽任务</p>
										<el-select class="simple-select" v-model="sel3" placeholder="请选择">
										</el-select>
									</div>
								</div>
							</template>
							<template v-else>
								<div class="placeholder"></div>
							</template>

						</div>
						<div class="actions">
						</div>
					</div>
					<div class="info-panel-extended"
						style="border: 2px solid rgb(103,135,183); margin-right: 20px;position: relative;">
						<CornerDecorator borderColor="rgb(120,170,155)" borderWidth="2px" width="8px" height="15px" />
						<div class="panel-title" style="padding-left: 10px;">
							<span style="margin-left: 20px; color: rgb(90, 170, 222)!important;">障碍</span>
						</div>
						<div class="panel-content-extended" v-if="showInfoPanels">
							<el-table :data="tableData" style="width: 100%">
								<el-table-column type="selection" width="70" />
								<el-table-column label="序号" width="300">
									<template #default="scope">{{ scope.row.date }}</template>
								</el-table-column>
								<el-table-column property="name" label="障碍编号" width="300" />
								<el-table-column property="address" label="障碍类型" width="300" show-overflow-tooltip />
								<el-table-column label="障碍位置">
									<template #header>
									</template>
									<template #default="scope">
										<div
											style="display: flex; align-items: center; justify-content: start; width: 100%; height: 100%; padding-left: 20px;">
											<el-icon size="25">
												<Location />
											</el-icon>
										</div>
									</template>
								</el-table-column>
							</el-table>
						</div>
						<div class="actions" v-if="showInfoPanels">
							<el-button @click="handleCancel">取消</el-button>
							<el-button @click="handleConfirm">确认</el-button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.pozhang-overlay {
	position: fixed;
	left: 0;
	right: 0;
	width: 100vw;
	background-color: transparent;
	z-index: 3004;
	height: 950px !important;
}

.pozhang-dialog {
	position: absolute;
	left: 0;
	right: 0;
	bottom: 10px;
	top: 0;
	margin: 0;
	background-color: rgb(15, 30, 61);
}

.dialog-header {
	height: 0;
}

.close-btn {
	position: absolute;
	top: 8px;
	right: 12px;
}

.dialog-body {
	display: flex;
	height: 100%;
}

.mind-panel {
	width: 520px;
	display: flex;
	flex-direction: column;
	margin-right: 20px;
	height: 880px;
}

.right {
	width: 1380px;
	display: flex;
	flex-direction: column;
	gap: 10px;
	min-height: 0;
}

.info-panel-main,
.info-panel-extended {
	flex: 1;
	display: flex;
	flex-direction: column;
	min-height: 0;
}

.panel-title {
	display: flex;
	align-items: center;
	gap: 8px;
	color: rgb(99, 170, 222);
	font-weight: bold;
	padding: 12px 0;
}

.panel-title.second {
	margin-top: 14px;
}

.icon {
	width: 20px;
	height: 20px;
}

.form-row {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 8px;
	padding-left: 10px;
}

.form-row label {
	width: 80px;
	color: white;
}

.input {
	flex: 1;
}

.time-row label {
	width: 100px;
	color: white;
}

.time-inputs {
	display: flex;
	align-items: center;
	gap: 8px;
}

.time-inputs span {
	color: white;
}

.time {
	width: 80px;
}

.table-block {
	display: block;
	margin-top: 10px;
}

.panel-content-main {
	flex: 1;
	overflow-y: auto;
	padding: 10px 10px 0px 20px;
	min-height: 0;
}

.panel-content-extended {
	flex: 1;
	overflow-y: auto;
	padding: 0 0px 0 0px;
	min-height: 0;
}

.simple-table {
	width: 100%;
	border-collapse: collapse;
	background-color: transparent;
}

.simple-table th,
.simple-table td {
	border-top: 2px solid rgb(90, 109, 165);
	border-bottom: 2px solid rgb(90, 109, 165);
	border-left: none;
	border-right: none;
	color: white;
	padding: 6px 10px;
	text-align: center;
	line-height: 1.5;
}

.simple-table th {
	color: rgb(90, 170, 222) !important;
}

.simple-table thead th:first-child {
	border-left: 2px solid rgb(90, 109, 165);
}

.simple-table thead th:last-child {
	border-right: 2px solid rgb(90, 109, 165);
}

.simple-table tbody td:first-child {
	border-left: 2px solid rgb(90, 109, 165);
}

.simple-table tbody td:last-child {
	border-right: 2px solid rgb(90, 109, 165);
}

.simple-table thead th {
	background-color: rgb(11, 41, 115);
}

.simple-table tbody tr {
	background-color: transparent;
}

.panel-content-main::-webkit-scrollbar,
.panel-content-extended::-webkit-scrollbar {
	width: 6px;
	background-color: rgb(156, 178, 231);
}

.panel-content-main::-webkit-scrollbar-thumb,
.panel-content-extended::-webkit-scrollbar-thumb {
	background: rgb(82, 113, 198);
}

.panel-content-main::-webkit-scrollbar-thumb:hover,
.panel-content-extended::-webkit-scrollbar-thumb:hover {
	background: rgb(75, 140, 200);
}

.triple-selects {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-top: 8px;
}

.info-panel-main :deep(.el-select__wrapper),
.info-panel-extended :deep(.el-select__wrapper) {
	background-color: rgb(11, 41, 115);
	border: 2px solid rgb(90, 109, 165);
	border-radius: 0;
	box-shadow: none;
	height: 35px;
}

.info-panel-main :deep(.el-select__inner),
.info-panel-extended :deep(.el-select__inner) {
	color: white;
}

.info-panel-main :deep(.el-select__popper .el-select-dropdown),
.info-panel-extended :deep(.el-select__popper .el-select-dropdown) {
	background-color: rgb(11, 41, 115);
	border: 2px solid rgb(90, 109, 165);
}

.info-panel-main :deep(.el-select__popper .el-select-dropdown__item),
.info-panel-extended :deep(.el-select__popper .el-select-dropdown__item) {
	color: white;
}

.table-toolbar {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 6px 0;
}

.table {
	background-color: rgb(21, 29, 63);
}

.actions {
	display: flex;
	justify-content: end;
	padding: 0 30px 30px 0;
	gap: 10px;

	.el-button {
		width: 60px;
		height: 30px;
		background-color: rgb(11, 41, 115);
		border: 2px solid rgb(90, 109, 165);
		color: white;
	}
}

.table-button {
	width: 100px;
	height: 30px;
	background-color: rgb(11, 41, 115);
	border: 2px solid rgb(90, 109, 165);
	color: white;
}

.mind-tree {
	flex: 1;
	margin: 0 20px 12px 20px;
	border: 2px solid rgb(90, 109, 165);
	background-color: rgb(21, 29, 63);
	overflow: auto;
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
}

.tree-root {
	color: white;
	font-weight: bold;
	padding: 10px 16px;
	border: 2px solid rgb(99, 170, 222);
	background-color: rgb(15, 30, 61);
	white-space: nowrap;
	cursor: pointer;

	background-size: 100% 100%;
	background-position: center;
}

.tree-branch {
	display: flex;
	flex-direction: column;
	gap: 16px;
	padding: 12px;
	margin-left: 100px;
}

.tree-node {
	display: inline-block;
	color: white;
	border: 2px solid rgb(90, 109, 165);
	background-color: rgb(11, 41, 115);
	padding: 6px 10px;
	position: relative;
}

.tree-node:hover {
	cursor: pointer;
	border-color: rgb(99, 170, 222);
}

.tree-node.selected {
	border-color: rgb(99, 170, 222);
	background-color: rgb(20, 52, 120);
}

.placeholder {
	min-height: 24px;
}



.node-extra {
	position: absolute;
	right: -130px;
	top: 50%;
	transform: translateY(-50%);
	border: 2px solid rgb(90, 109, 165);
	background-color: rgb(11, 41, 115);
	color: white;
	padding: 4px 8px;
	border-radius: 6px;
}

.mind-tools {
	display: flex;
	justify-content: center;
	gap: 8px;
	padding: 8px 0 12px;
}

.tool {
	width: 22px;
	height: 22px;
	border: 2px solid rgb(90, 109, 165);
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
}

.mind-links {
	position: absolute;
	inset: 0;
	pointer-events: none;
	width: 100%;
	height: 100%;
	z-index: 3;
}

.mind-links path {
	stroke: rgb(99, 170, 222);
	stroke-width: 1.5;
	fill: none;
	stroke-linecap: round;
	shape-rendering: geometricPrecision;
}

.button-group {
	position: absolute;
	bottom: 30px;
	left: 370px;
	display: flex;
	gap: 10px;

	button {
		width: 60px;
		height: 30px;
		background-color: rgb(11, 41, 115);
		border: 2px solid rgb(90, 109, 165);
		color: white;
	}
}

.menu-popup {
	position: absolute;
	top: calc(50% + 30px);
	left: 50%;
	transform: translateX(-50%);
	width: 180px;
	height: 150px;
	background-color: rgb(21, 29, 63);
	z-index: 10;
	display: flex;
	flex-direction: column;
	padding: 10px;
	box-sizing: border-box;
}

.menu-item {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	border: 1px solid rgb(90, 109, 165);
	margin-bottom: 5px;
	cursor: pointer;
	transition: all 0.3s;
}

.menu-item:hover {
	background-color: rgb(11, 41, 115);
	border-color: rgb(99, 170, 222);
}

.menu-item:last-child {
	margin-bottom: 0;
}

/* 选中复选框颜色 */
:deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
	background-color: #409eff !important;
	border-color: #409eff !important;
}

:deep(.el-checkbox__input) {
	margin-left: 20px !important;
	margin-right: 90px !important;
}
</style>
<style>
/* 表头背景 */
.el-table th {
	background-color: rgb(25, 34, 59) !important;
	color: white !important;
	line-height: 3 !important;
}

/* 表格内容行 */
.el-table td {
	background-color: #0f1e3d !important;
	color: rgb(90, 146, 189) !important;
	line-height: 3 !important;
	font-weight: bold !important;
}

/* 鼠标悬浮 */
.el-table__row:hover>td {
	background-color: #1c2e60 !important;
}

/* tooltip 气泡 */
.el-tooltip__popper {
	background-color: black !important;
	color: white !important;
}
</style>
