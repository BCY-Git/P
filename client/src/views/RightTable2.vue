<template>
	<div>
		<div v-for="(item, index) in users">
			<div style="font-size: 18px; color: #ffffff; display: flex; justify-content: center; margin-bottom: 10px">
				<p>{{ '随便1' }}</p>
			</div>
			<div style="border: #5060a1 solid 2px; padding: 10px; margin-bottom: 15px">
				<!-- 图标占位 -->
				<div style="display: flex; justify-content: end; padding-bottom: 8px; padding-right: 5px; color: #ffffff; font-size: 15px">
					<p>标</p>
				</div>

				<!-- 输入框 -->
				<div style="display: flex; justify-content: center">
					<div class="form-row" style="flex: 1">
						<label class="form-label">*用户名啊</label>
						<input v-model="username" class="form-input" type="text" />
					</div>

					<!-- 输入框 -->
					<div class="form-row" style="flex: 1">
						<label class="form-label">*手机号</label>
						<input v-model="phone" class="form-input" type="text" />
					</div>
				</div>

				<div class="form-row" style="display: flex">
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

				<div class="form-row">
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
				<div class="form-row" @click.stop>
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
				<div class="form-row" @click.stop>
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
			</div>
		</div>

		<div class="form-row" style="justify-content: center">
			<button class="table-bottom-btn" style="font-size: 18px; height: 50px; padding: 0 20px 0 20px">保 存</button>
		</div>
	</div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed, watch } from 'vue'

/* 基本字段 */
const username = ref('')
const phone = ref('')

/* props（JS 不用类型定义） */
const props = defineProps({
  id: { default: 0 }
})

watch(
  () => props.id,
  (newVal, oldVal) => {
    console.log(newVal, oldVal)
    if (props.id === 2) {
      users.value = users2.value
    }
  }
)

/* 用户表格数据 */
const users = ref([
  { id: 1, name: '张三', age: 20, city: '北京' },
  { id: 2, name: '李四', age: 22, city: '上海' },
  { id: 3, name: '王五', age: 28, city: '广州' }
])

/* 用户表格数据2 */
const users2 = ref([
  { id: 1, name: 'FF', age: 20, city: '北京' },
  { id: 2, name: 'CC', age: 22, city: '上海' },
  { id: 3, name: 'VV', age: 28, city: '广州' }
])

/* 多选表格（左侧 checkbox） */
const selectedRows = ref([])

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

function toggleRow(id) {
  const idx = selectedRows.value.indexOf(id)
  if (idx === -1) {
    selectedRows.value.push(id)
  } else {
    selectedRows.value.splice(idx, 1)
  }
}

/* 查看单行 */
function viewUser(u) {
  alert(`查看用户：${u.name} (id:${u.id})`)
}

/* 添加新用户 */
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
const multiOpen = ref(false)
const multiBox = ref(null)
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

.multi-option input[type='checkbox'] {
	width: 16px;
	height: 16px;
	accent-color: #5fa6ff;
}
</style>
