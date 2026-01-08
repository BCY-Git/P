<template>
	<svg ref="svgRef" :width="svgSize" :height="svgSize" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Pentagon Chart">
		<!-- 缩放组 -->
		<g :transform="`translate(${centerPx},${centerPx}) scale(${scale}) translate(${-centerDrawing},${-centerDrawing})`">
			<!-- 中心五边形 -->
			<polygon :points="getPentagonPoints(centerDrawing, centerRadiusDrawing)" :fill="centerColor" stroke="white" stroke-width="2" />

			<!-- 五边形层级 -->
			<g v-for="(radius, revIdx) in radii.slice().reverse()" :key="revIdx">
				<polygon :points="getPentagonPoints(centerDrawing, radius)" :fill="colors[originalIndex(revIdx)]" stroke="white" stroke-width="2" />
			</g>

			<!-- 放射线 -->
			<g>
				<line
					v-for="(angle, idx) in angles"
					:key="idx"
					:x1="centerDrawing"
					:y1="centerDrawing"
					:x2="centerDrawing + realMaxRadiusDrawing * Math.cos(angle)"
					:y2="centerDrawing + realMaxRadiusDrawing * Math.sin(angle)"
					stroke="white"
					stroke-width="1"
				/>
			</g>

			<!-- 数据区域 -->
			<polygon
				v-if="showOuter"
				:points="dataPointsStringDrawing"
				:fill="dataAreaColor"
				:stroke="dataAreaBorderColor"
				stroke-width="2"
				fill-opacity="0.6"
			/>

			<!-- 数据点 -->
			<g>
				<circle v-for="(p, idx) in dataPointsCoordsDrawing" :key="idx" :cx="p.x" :cy="p.y" :r="pointRadiusDrawing" :fill="pointColor" />
			</g>
		</g>

		<!-- 标签 -->
		<g>
			<text
				v-for="(angle, idx) in angles"
				:key="idx"
				:x="labelPosPx[idx]?.x ?? centerPx"
				:y="(labelPosPx[idx]?.y ?? centerPx) + labelDyOffset"
				:fill="labelColor"
				:font-size="labelSize"
				text-anchor="middle"
			>
				<tspan
					v-for="(line, lineIdx) in labels[idx]?.split('\n') ?? ['']"
					:key="lineIdx"
					:x="labelPosPx[idx]?.x ?? centerPx"
					:dy="lineIdx === 0 ? getLabelDy(labels[idx]) : labelSize * 1.2"
				>
					{{ line }}
				</tspan>
			</text>
		</g>
	</svg>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
	size: { type: Number, default: 400 },
	layers: { type: Number, default: 5 },
	colors: { type: Array, default: () => ['#0404e6', '#4c4cda', '#0404e6', 'rgba(101,101,202,0.74)', '#0404e6'] },
	centerColor: { type: String, default: '#FF0000' },
	values: { type: Array, default: () => [80, 50, 70, 30, 90] },
	pointColor: { type: String, default: 'red' },
	pointRadius: { type: Number, default: 5 },
	dataAreaColor: { type: String, default: 'rgba(255,0,0,0.3)' },
	dataAreaBorderColor: { type: String, default: 'rgba(255,0,0,0.8)' },
	labels: { type: Array, default: () => ['A', 'B', 'C', 'D', 'E'] },
	labelColor: { type: String, default: 'white' },
	labelSize: { type: Number, default: 14 },
	labelOffset: { type: Number, default: 18 },
	showOuter: { type: Boolean, default: true },
	labelPadding: { type: Number, default: 20 },
	labelDyOffset: { type: Number, default: 0 }
})

// ---------- 首行 tspan dy ----------
function getLabelDy(label) {
	const lines = label?.split('\n')?.length ?? 1
	return lines === 1 ? 0 : -(lines - 1) * props.labelSize * 0.6
}

// ---------- 内部 drawing 坐标系 ----------
const drawingSize = 1000
const centerDrawing = drawingSize / 2
const realMaxRadiusDrawing = computed(() => (drawingSize / 2) * 0.75)

const radii = computed(() => {
	const step = realMaxRadiusDrawing.value / Math.max(1, props.layers)
	return Array.from({ length: props.layers }, (_, i) => step * (i + 1))
})

const centerRadiusDrawing = computed(() => {
	return (radii.value[0] ?? realMaxRadiusDrawing.value / Math.max(1, props.layers)) / 2
})

const angles = computed(() =>
	Array.from({ length: 5 }, (_, i) => -Math.PI / 2 + (2 * Math.PI * i) / 5)
)

function originalIndex(revIdx) {
	return radii.value.length - 1 - revIdx
}

// ---------- 数据点 ----------
function clamp01(v) {
	if (isNaN(v)) return 0
	if (v < 0) return 0
	if (v > 100) return 100
	return v
}

const dataPointsCoordsDrawing = computed(() =>
	angles.value.map((a, i) => {
		const val = clamp01(props.values[i] ?? 0)
		const r = (val / 100) * realMaxRadiusDrawing.value
		return { x: centerDrawing + r * Math.cos(a), y: centerDrawing + r * Math.sin(a) }
	})
)

const dataPointsStringDrawing = computed(() =>
	dataPointsCoordsDrawing.value.map(p => `${p.x},${p.y}`).join(' ')
)

const pointRadiusDrawing = computed(() => props.pointRadius / (scale.value || 1))

function getPentagonPoints(cx, radius) {
	return angles.value.map(a => `${cx + radius * Math.cos(a)},${cx + radius * Math.sin(a)}`).join(' ')
}

// ---------- 标签偏移 ----------
const angleExtraOffsets = [0, 30, 0, 0, 30]
const maxExtraOffset = Math.max(...angleExtraOffsets)

const maxLabelOffset = computed(() => props.labelOffset + props.labelSize / 2 + maxExtraOffset)
const svgSize = computed(() => props.size + maxLabelOffset.value * 2)
const scale = computed(() => props.size / drawingSize)
const centerPx = computed(() => svgSize.value / 2)

const realMaxRadiusPx = computed(() => realMaxRadiusDrawing.value * scale.value)
const labelRadiusPx = computed(() => realMaxRadiusPx.value + props.labelOffset)

const labelPosPx = computed(() =>
	angles.value.map((a, idx) => {
		const extraOffset = angleExtraOffsets[idx] || 0
		const r = labelRadiusPx.value + extraOffset
		return {
			x: centerPx.value + r * Math.cos(a),
			y: centerPx.value + r * Math.sin(a)
		}
	})
)
</script>


<style scoped></style>
