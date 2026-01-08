<template>
	<div id="gantt" style="width: 100%; height: 100%"></div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import * as echarts from 'echarts'

onMounted(() => {
	const chartDom = document.getElementById('gantt')!
	const myChart = echarts.init(chartDom)

	// 行名称（项目）
	const tasksRows = ['项目1', '项目2', '项目3', '项目4', '项目5', '项目6', '项目7', '项目8', '项目9', '项目10']

	// 新增更多任务数据（示例）
	const taskData = [
		{ row: '项目1', name: '任务A', start: '2025-11-18', end: '2025-11-20', color: '#1f77b4' },
		{ row: '项目1', name: '任务B', start: '2025-11-21', end: '2025-11-25', color: '#ff7f0e' },

		{ row: '项目2', name: '任务C', start: '2025-11-19', end: '2025-11-22', color: '#2ca02c' },
		{ row: '项目2', name: '任务D', start: '2025-11-23', end: '2025-11-26', color: '#d62728' },

		{ row: '项目3', name: '任务E', start: '2025-11-18', end: '2025-11-19', color: '#9467bd' },
		{ row: '项目3', name: '任务F', start: '2025-11-20', end: '2025-11-24', color: '#8c564b' },

		// 多添加一些示例任务
		...Array.from({ length: 30 }).map((_, i) => ({
			row: `项目${(i % 10) + 1}`,
			name: `任务${i + 10}`,
			start: `2025-11-${10 + (i % 15)}`,
			end: `2025-11-${12 + (i % 15)}`,
			color: ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b'][i % 6]
		}))
	]

	const barData = taskData.map(task => ({
		value: [new Date(task.start).getTime(), tasksRows.indexOf(task.row), new Date(task.end).getTime()],
		itemStyle: { color: task.color },
		label: { show: true, formatter: task.name, position: 'inside', color: '#fff' },
		taskName: task.name,
		row: task.row,
		start: task.start,
		end: task.end
	}))

	const option = {
		tooltip: {
			formatter: (params: any) => {
				const task = params.data
				return `${task.taskName} (${task.row})<br>开始: ${task.start}<br>结束: ${task.end}`
			}
		},
		grid: { left: 150, right: 50, top: 20, bottom: 50 },

		// ⭐ 横向 & 纵向滚动条
		dataZoom: [
			{
				type: 'slider',
				xAxisIndex: 0,
				height: 20,
				bottom: 10
			},
			{
				type: 'slider',
				yAxisIndex: 0,
				width: 20,
				right: 10
			},
			{ type: 'inside', xAxisIndex: 0 },
			{ type: 'inside', yAxisIndex: 0 }
		],

		xAxis: {
			type: 'time',
			position: 'top',
			splitLine: { show: true }
		},
		yAxis: {
			type: 'category',
			data: tasksRows.slice().reverse(),
			inverse: true,
			axisLabel: { fontSize: 14 },
			splitLine: { show: true }
		},

		series: [
			{
				type: 'custom',
				renderItem: (params: any, api: any) => {
					const categoryIndex = api.value(1)
					const start = api.coord([api.value(0), categoryIndex])
					const end = api.coord([api.value(2), categoryIndex])
					const height = 18

					return {
						type: 'rect',
						shape: {
							x: start[0],
							y: start[1] - height / 2,
							width: end[0] - start[0],
							height
						},
						style: api.style()
					}
				},
				encode: { x: [0, 2], y: 1 },
				data: barData
			}
		]
	}

	myChart.setOption(option)
})
</script>

<style scoped></style>
