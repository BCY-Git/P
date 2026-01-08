<template>
	<div ref="chartContainer" style="width: 100%; height: 100%"></div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import * as echarts from 'echarts'
// import echarts from '../../store/echarts'

const chartContainer = ref<HTMLElement | null>(null)

onMounted(() => {
	if (!chartContainer.value) return
	const myChart = echarts.init(chartContainer.value)

	// 水果行（你可以随便扩展更多）
	const fruits = ['苹果', '鸭梨', '西瓜', '香蕉', '葡萄', '芒果', '哈密瓜', '橙子', '柠檬', '草莓', '蓝莓', '菠萝']

	const fruitColors = ['#FFD700', '#FFA500', '#90EE90', '#87CEFA']

	const formatValue = (value: number) => value.toString(16).toUpperCase() + 'T'

	// ⭐ 数据量可以任意扩展
	const scatterData1: [number, number][] = Array.from({ length: fruits.length }).map((_, i) => [
		Math.floor(Math.random() * 70), // X 值
		i // Y 类别
	])

	const option = {
		tooltip: {
			trigger: 'item',
			formatter: (params: any) => {
				const y = fruits[params.data[1]]
				const x = formatValue(params.data[0])
				return `水果: ${y}<br>值: ${x}`
			}
		},

		grid: { left: 120, right: 40, top: 20, bottom: 60 },

		// ⭐ 添加横向 & 纵向滚动条
		dataZoom: [
			// 横向
			{
				type: 'slider',
				xAxisIndex: 0,
				height: 18,
				bottom: 10
			},
			{
				type: 'inside',
				xAxisIndex: 0
			},
			// 纵向
			{
				type: 'slider',
				yAxisIndex: 0,
				width: 18,
				right: 10
			},
			{
				type: 'inside',
				yAxisIndex: 0
			}
		],

		xAxis: {
			type: 'value',
			min: 0,
			max: 80,
			position: 'top',
			axisLabel: { formatter: formatValue },
			splitLine: { show: true }
		},

		yAxis: {
			type: 'category',
			data: fruits,
			inverse: true,
			axisLabel: {
				formatter: (value: string) => {
					const idx = fruits.indexOf(value)
					return `{block${idx % fruitColors.length}|${value}}`
				},
				rich: fruitColors.reduce((acc, color, idx) => {
					acc[`block${idx}`] = {
						backgroundColor: color,
						color: '#000000',
						padding: [3, 8],
						borderRadius: 4,
						fontSize: 14,
						fontWeight: 'bold'
					}
					return acc
				}, {})
			},
			splitLine: { show: true }
		},

		series: [
			{
				name: '水果值',
				type: 'scatter',
				data: scatterData1,
				symbolSize: 22,
				itemStyle: { color: '#FFD700' },

				label: {
					show: true,
					position: 'bottom',
					formatter: (params: any) => {
						const fruitName = fruits[params.data[1]]
						const value = formatValue(params.data[0])
						return `${fruitName}\n${value}`
					},
					fontSize: 12,
					color: '#333'
				}
			}
		]
	}

	myChart.setOption(option)
})
</script>
<style scoped></style>
