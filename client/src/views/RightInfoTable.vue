<template>
	<!-- 输入框 -->
	<div v-if="showData" class="form-row">
		<label class="form-label">*用户名啊</label>
		<input v-model="username" class="form-input" type="text" />
	</div>

	<!-- 输入框 -->
	<div v-if="showData" class="form-row">
		<label class="form-label">*手机号</label>
		<input v-model="phone" class="form-input" type="text" />
	</div>

	<div v-if="showData" class="form-row" style="display: flex">
		<label class="form-label" style="flex: 0 0 auto">*手机号</label>
		<div style="display: flex; width: 100%; align-items: center; gap: 8px; justify-content: center">
			<input class="form-input" type="text" style="flex-basis: 10%" />
			<input class="form-input" type="text" style="flex-basis: 10%" />
			<p style="flex-basis: 1%; font-size: 16px; color: #ffffff">时</p>
			<input class="form-input" type="text" style="flex-basis: 5%" />
			<p style="flex-basis: 5%; font-size: 16px; color: #ffffff">分 至</p>
			<input class="form-input" type="text" style="flex-basis: 10%" />
			<input class="form-input" type="text" style="flex-basis: 10%" />
			<p style="flex-basis: 1%; font-size: 16px; color: #ffffff">时</p>
			<input class="form-input" type="text" style="flex-basis: 5%" />
			<p style="flex-basis: 1%; font-size: 16px; color: #ffffff">分</p>
		</div>
	</div>

	<div v-if="showData" class="form-row">
		<label class="form-label">用户表格</label>

		<div class="table-wrapper">
			<!-- 批量操作 -->
			<div class="table-actions">
				<div>
					<button class="small-btn" @click="selectAllRows">{{ isAllSelected ? '取消全选' : '全选' }}</button>
					<button class="small-btn danger" :disabled="selectedRows.length === 0" @click="batchDelete">批量删除（{{ selectedRows.length }}）</button>
				</div>
				<div class="table-actions-right">
					<!-- 你可以加其它操作 -->
				</div>
			</div>

			<table class="form-table">
				<thead>
					<tr>
						<th class="col-checkbox">
							<div class="checkbox-icon" @click="selectAllRows">
								<span v-if="isAllSelected">✔</span>
								<span v-else-if="isSomeSelected">−</span>
							</div>
						</th>
						<th>姓名</th>
						<th>年龄</th>
						<th>城市</th>
						<th>操作</th>
					</tr>
				</thead>

				<tbody>
					<tr v-for="u in users" :key="u.id" :class="{ 'row-selected': selectedRows.includes(u.id) }">
						<td class="col-checkbox">
							<div class="checkbox-icon" @click="toggleRow(u.id)">
								<span v-if="selectedRows.includes(u.id)">✔</span>
							</div>
						</td>
						<td>{{ u.name }}</td>
						<td>{{ u.age }}</td>
						<td>{{ u.city }}</td>
						<td>
							<button class="table-btn" @click="viewUser(u)">查看</button>
						</td>
					</tr>

					<!-- 如果没有数据，用一个占满全行的按钮（表格风格） -->
					<tr v-if="users.length === 0" class="empty-row">
						<td :colspan="5">
							<button class="table-bottom-btn" @click="addUser">添加新用户</button>
						</td>
					</tr>

					<!-- 正常有数据时，表格底部也显示一个“列表内”按钮作为最后一行 -->
					<tr v-else class="last-row">
						<td :colspan="5">
							<div class="last-row-cell">
								<button class="table-bottom-btn" @click="addUser">添加新用户</button>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<div v-if="showData" class="form-row">
		<label class="form-label">用户表格</label>

		<div class="table-wrapper">
			<table class="form-table">
				<thead>
					<tr>
						<th class="col-checkbox">
							<div class="checkbox-icon" @click="selectAllRows">
								<span v-if="isAllSelected">✔</span>
								<span v-else-if="isSomeSelected">−</span>
							</div>
						</th>
						<th>姓名</th>
						<th>年龄</th>
						<th>城市</th>
						<th>操作</th>
					</tr>
				</thead>

				<tbody>
					<tr v-for="u in users" :key="u.id" :class="{ 'row-selected': selectedRows.includes(u.id) }">
						<td class="col-checkbox">
							<div class="checkbox-icon" @click="toggleRow(u.id)">
								<span v-if="selectedRows.includes(u.id)">✔</span>
							</div>
						</td>
						<td>{{ u.name }}</td>
						<td>{{ u.age }}</td>
						<td>{{ u.city }}</td>
						<td>
							<button class="table-btn" @click="viewUser(u)">查看</button>
						</td>
					</tr>

					<!-- 如果没有数据，用一个占满全行的按钮（表格风格） -->
					<tr v-if="users.length === 0" class="empty-row">
						<td :colspan="5">
							<button class="table-bottom-btn" @click="addUser">添加新用户</button>
						</td>
					</tr>

					<!-- 正常有数据时，表格底部也显示一个“列表内”按钮作为最后一行 -->
					<tr v-else class="last-row">
						<td :colspan="5">
							<div class="last-row-cell">
								<button class="table-bottom-btn" @click="addUser">添加新用户</button>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<!-- 下拉框（单选） -->
	<div v-if="showData" class="form-row" @click.stop>
		<label class="form-label">城市选择</label>

		<div ref="singleBox" class="select-box" @click="toggleSelect">
			<div class="select-value">{{ city || '请选择' }}</div>
			<div class="select-arrow"></div>

			<!-- 下拉内容 -->
			<transition name="fade">
				<div v-if="selectOpen" class="select-list" @click.stop>
					<div v-for="c in cityList" :key="c" class="select-item" @click="selectCity(c)">
						{{ c }}
					</div>
				</div>
			</transition>
		</div>
	</div>
	<!-- 下拉框（单选） -->
	<div v-if="showData" class="form-row" @click.stop>
		<label class="form-label">城市选择</label>

		<div ref="singleBox" class="select-box" @click="toggleSelect">
			<div class="select-value">{{ city || '请选择' }}</div>
			<div class="select-arrow"></div>

			<!-- 下拉内容 -->
			<transition name="fade">
				<div v-if="selectOpen" class="select-list" @click.stop>
					<div v-for="c in cityList" :key="c" class="select-item" @click="selectCity(c)">
						{{ c }}
					</div>
				</div>
			</transition>
		</div>
	</div>

	<!-- 多选下拉 -->
	<div v-if="showData" class="form-row" @click.stop>
		<label class="form-label">多选标签</label>

		<div ref="multiBox" class="select-box" @click="toggleMulti">
			<div class="select-value multi-value">
				<template v-if="tags.length === 0">请选择</template>
				<template v-else>
					<span v-for="t in tags" :key="t" class="tag">{{ t }}</span>
				</template>
			</div>
			<div class="select-arrow"></div>

			<transition name="fade">
				<div v-if="multiOpen" class="select-list multi-list" @click.stop>
					<div v-for="t in tagList" :key="t" class="select-item multi-item" @click.stop="toggleTag(t)">
						<label class="multi-option">
							<input type="checkbox" :checked="tags.includes(t)" />
							<span class="option-label">{{ t }}</span>
							<span v-if="tags.includes(t)" class="check-dot">✓</span>
						</label>
					</div>
				</div>
			</transition>
		</div>
	</div>

	<div v-if="showData" class="form-row" style="justify-content: center">
		<button class="table-bottom-btn" style="font-size: 18px; height: 50px; padding: 0 20px 0 20px">保 存</button>
	</div>
	
	<!-- 未选择操作一时的提示 -->
	<div v-if="!showData" class="empty-tip">
		<p>请点击"操作一"查看数据</p>
	</div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed, watch } from 'vue'

/* 基本字段 */
const username = ref('')
const phone = ref('')

const props = defineProps({
	id: { type: Number, default: null },
	showData: { type: Boolean, default: false } // 控制是否显示数据
})

watch(
	() => props.id,
	(newVal, oldVal) => {
		console.log('count 改变:', newVal, oldVal)
	}
)

/* 用户表格数据 */
const users = ref([
	{ id: 1, name: '张三', age: 20, city: '北京' },
	{ id: 2, name: '李四', age: 22, city: '上海' },
	{ id: 3, name: '王五', age: 28, city: '广州' }
])

/* 多选表格（左侧 checkbox） */
const selectedRows = ref([]) // 存放 id 列表

const isAllSelected = computed(() => {
	return users.value.length > 0 && selectedRows.value.length === users.value.length
})
const isSomeSelected = computed(() => {
	return selectedRows.value.length > 0 && selectedRows.value.length < users.value.length
})

function selectAllRows() {
	if (isAllSelected.value) {
		selectedRows.value = []
	} else {
		selectedRows.value = users.value.map(u => u.id)
	}
}

/* 单行切换 */
function toggleRow(id) {
	const idx = selectedRows.value.indexOf(id)
	if (idx === -1) {
		selectedRows.value.push(id)
	} else {
		selectedRows.value.splice(idx, 1)
	}
}

/* 批量删除示例（只是从数组移除） */
function batchDelete() {
	if (!selectedRows.value.length) {
		return
	}
	const ids = new Set(selectedRows.value)
	users.value = users.value.filter(u => !ids.has(u.id))
	selectedRows.value = []
}

/* 查看单行 */
function viewUser(u) {
	alert(`查看用户：${u.name} (id:${u.id})`)
}

/* 添加新用户（示例） */
function addUser() {
	const newId = users.value.length ? Math.max(...users.value.map(u => u.id)) + 1 : 1
	users.value.push({ id: newId, name: '新用户' + newId, age: 18, city: '未知' })
}

/* ---------------- 单选下拉 ---------------- */
const city = ref('')
const cityList = ['北京', '上海', '广州', '深圳']
const selectOpen = ref(false)
const singleBox = ref(null)

function toggleSelect() {
	selectOpen.value = !selectOpen.value
}
function selectCity(c) {
	city.value = c
	selectOpen.value = false
}

/* ---------------- 多选下拉 ---------------- */
const tags = ref([])
const tagList = ['Vue', 'Java', '前端', '后端', 'Python']
const multiOpen = ref(false)
const multiBox = ref(null)

function toggleMulti() {
	multiOpen.value = !multiOpen.value
}
function toggleTag(t) {
	const idx = tags.value.indexOf(t)
	if (idx === -1) {
		tags.value.push(t)
	} else {
		tags.value.splice(idx, 1)
	}
}

/* checkbox 组 */
const hobbies = ['听歌', '写代码', '跑步', '游戏']
const selectedHobbies = ref([])

/* 点击外部关闭下拉 - 注册 document 事件 */
function handleDocumentClick(e) {
	// 如果点击在单选或多选组件外部，则关闭他们
	if (singleBox.value && !singleBox.value.contains(e.target)) {
		selectOpen.value = false
	}
	if (multiBox.value && !multiBox.value.contains(e.target)) {
		multiOpen.value = false
	}
}

onMounted(() => {
	document.addEventListener('click', handleDocumentClick)
})

onBeforeUnmount(() => {
	document.removeEventListener('click', handleDocumentClick)
})
</script>

<style scoped>
/* 统一布局 */
.form-row {
	display: flex;
	align-items: flex-start;
	margin-bottom: 18px;
}
.form-label {
	text-align: right;
	width: 85px;
	font-size: 18px;
	padding-top: 6px;
	margin-right: 15px;
	color: white;
	font-weight: 550;
}

/* 输入框 */
.form-input {
	height: 36px;
	background: rgb(2, 38, 151);
	border: 2px solid #5677d9;
	padding-left: 8px;
	color: white;
	font-size: 18px;
	min-width: 0;
	width: 100%;
	flex: 1;
}

/* 表格区域 */
.table-wrapper {
	flex: 1;
}

/* 批量操作栏 */
.table-actions {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 6px;
}
.table-actions .small-btn {
	background: #15305e;
	border: 1px solid #325a9e;
	color: #fff;
	padding: 6px 10px;
	border-radius: 4px;
	margin-right: 8px;
	cursor: pointer;
	font-size: 14px;
}
.table-actions .small-btn.danger {
	background: #7a2431;
	border-color: #a14a52;
}
.table-actions .small-btn:disabled {
	opacity: 0.5;
	cursor: not-allowed;
}

/* 表格样式 */
.form-table {
	width: 100%;
	border-collapse: collapse;
	background: rgb(13, 31, 73);
	border: 2px solid #5677d9;
	box-sizing: border-box;
}
.form-table thead th {
	background-color: rgba(2, 38, 151);
	color: rgb(128, 207, 255);
	font-size: 19px;
	padding: 6px 4px;
	border-bottom: 2px solid #5677d9;
	text-align: center;
	vertical-align: middle;
}
.form-table th,
.form-table td {
	text-align: center;
	padding: 3px;
	vertical-align: middle;
}
.form-table th:last-child,
.form-table td:last-child {
	border-right: none;
}
.form-table tbody td {
	font-size: 18px;
	color: #fff;
	border-bottom: 2px solid #5677d9;
}
.form-table tbody tr.row-selected {
	background: linear-gradient(90deg, rgba(14, 29, 62, 0.6), rgba(21, 40, 78, 0.6));
}
.empty-row td {
	padding: 20px 0;
	text-align: center;
}
.last-row .last-row-cell {
	display: flex;
	justify-content: center;
	padding: 10px 0;
}
.table-btn {
	background: rgb(11, 41, 116);
	color: white;
	border: 2px solid #5677d9;
	padding: 6px 12px;
	font-size: 14px;
	cursor: pointer;
}
.table-bottom-btn {
	background: rgb(11, 41, 116);
	border: 3px solid #5677d9;
	color: white;
	font-size: 16px;
	padding: 8px 18px;
	cursor: pointer;
}
.col-checkbox {
	width: 56px;
}

/* 三态复选框 */
.checkbox-icon {
	width: 20px;
	height: 20px;
	border: 1px solid #2f4266;
	border-radius: 4px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	color: #aee0ff;
	font-size: 16px;
	user-select: none;
}

/* 下拉（单选 & 多选） */
.select-box {
	flex: 1;
	position: relative;
	background: rgb(2, 38, 151);
	border: 1px solid #5060a1;
	color: white;
	padding: 8px 36px 8px 12px;
	font-size: 18px;
	cursor: pointer;
	box-sizing: border-box;
}
.select-arrow {
	position: absolute;
	right: 10px;
	top: 50%;
	transform: translateY(-50%);
	width: 10px;
	height: 10px;
	pointer-events: none;
}
.select-arrow::after {
	content: '';
	display: block;
	width: 0;
	height: 0;
	margin: 0 auto;
	border-left: 6px solid transparent;
	border-right: 6px solid transparent;
	border-top: 6px solid #ffffff;
	opacity: 0.9;
}
.select-list {
	position: absolute;
	top: calc(100% + 6px);
	left: 0;
	width: 100%;
	background: rgb(24, 42, 87);
	border: 1px solid #3b4a6a;
	border-radius: 6px;
	margin-top: 4px;
	z-index: 50;
	box-shadow: 0 6px 18px rgba(4, 13, 48, 0.6);
	overflow: hidden;
}
.select-item {
	padding: 10px 14px;
	color: #ffffff;
	font-size: 16px;
	border-bottom: 1px solid #374969;
	cursor: pointer;
}
.select-item:hover {
	background: rgba(34, 68, 162, 0.4);
}
.select-item:last-child {
	border-bottom: none;
}
.multi-list .multi-item {
	display: flex;
	align-items: center;
	padding: 8px 12px;
}
.multi-option {
	display: flex;
	align-items: center;
	width: 100%;
	cursor: pointer;
	gap: 10px;
}
.multi-option input[type='checkbox'] {
	width: 16px;
	height: 16px;
	accent-color: #5fa6ff;
}
.multi-option .option-label {
	flex: 1;
	color: #eaf4ff;
}
.multi-option .check-dot {
	color: #aee0ff;
	font-weight: 700;
	padding-left: 8px;
}
.multi-value .tag {
	display: inline-block;
	background: rgba(80, 120, 230, 0.12);
	color: #ffffff;
	border: 1px solid rgba(80, 120, 230, 0.22);
	padding: 2px 8px;
	margin-right: 6px;
	border-radius: 12px;
	font-size: 18px;
}
.fade-enter-active,
.fade-leave-active {
	transition: all 150ms ease;
}
.fade-enter-from {
	opacity: 0;
	transform: translateY(-6px);
}
.fade-enter-to {
	opacity: 1;
	transform: translateY(0);
}
.fade-leave-from {
	opacity: 1;
	transform: translateY(0);
}
.fade-leave-to {
	opacity: 0;
	transform: translateY(-6px);
}

/* checkbox 组样式 */
.check-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
}
.check-item {
	font-size: 18px;
	display: flex;
	align-items: center;
	gap: 8px;
}
.check-label {
	color: #eaf4ff;
}

/* 空状态提示 */
.empty-tip {
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 200px;
	padding: 40px;
}

.empty-tip p {
	color: #6a99e9;
	font-size: 18px;
	text-align: center;
}
</style>
