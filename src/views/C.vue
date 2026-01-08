<template>
	<div :style="{ width: '100%' , height: '100%' , position: 'relative' }">
		<svg :width="autoWidth" :height="autoHeight" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Mindmap">
			<!-- 定义背景图片 pattern -->
			<defs>
				<pattern v-if="parentBackgroundImage" id="parent-bg-pattern" patternUnits="objectBoundingBox" width="1" height="1">
					<image :href="parentBackgroundImage" width="1" height="1" preserveAspectRatio="none" />
				</pattern>
				<pattern v-if="childBackgroundImage" id="child-bg-pattern" patternUnits="objectBoundingBox" width="1" height="1">
					<image :href="childBackgroundImage" width="1" height="1" preserveAspectRatio="none" />
				</pattern>
			</defs>
			
			<!-- 直线 -->
			<line v-for="ln in straightLinks"
				:key="ln.id"
				:x1="ln.x1"
				:y1="ln.y1"
				:x2="ln.x2"
				:y2="ln.y2"
				:stroke="lineColor"
				:stroke-width="ln.strokeWidth"
				fill="none"
			/>
			<!-- 贝塞尔 -->
			<path v-for="ln in bezierLinks" :key="ln.id" :d="ln.d" :stroke="lineColor" :stroke-width="ln.strokeWidth" fill="none" />

			<!-- 父节点 -->
			<g
				v-if="parentPlaced"
				:transform="`translate(${parentPlaced.x}, ${parentPlaced.y})`"
				:class="['mindmap-parent-node', parentClass]"
				style="cursor: pointer"
				@mouseenter="onEnter(parentPlaced.node, 'parent')"
				@mouseleave="onLeave(parentPlaced.node, 'parent')"
				@click.stop="onClickNode(parentPlaced.node, 'parent', $event)"
			>
				<rect
					:width="parentPlaced.width"
					:height="parentPlaced.height"
					:rx="(parentCorner * scale).toString()"
					:ry="(parentCorner * scale).toString()"
					:fill="getParentFill(parentPlaced.node)"
					:stroke="getNodeStroke(parentPlaced.node, 'parent')"
					:class="['mindmap-parent-rect', parentClass]"
					:style="parentComputedStyle"
				/>
				<text
					:x="parentPlaced.width / 2"
					:y="parentPlaced.height / 2"
					text-anchor="middle"
					alignment-baseline="middle"
					:fill="getNodeTextColor(parentPlaced.node, 'parent')"
					:font-size="parentPlaced.fontSize + 'px'"
					font-weight="bold"
					:style="{ pointerEvents: 'none', dominantBaseline: 'middle' }"
				>
					{{ parentPlaced.label }}
				</text>
			</g>

			<!-- 子节点 -->
			<g
				v-for="child in childrenPlaced"
				:key="child.node.id"
				:transform="`translate(${child.x}, ${child.y})`"
				:class="['mindmap-child-node', childClass]"
				style="cursor: pointer"
				@mouseenter="onEnter(child.node, 'child')"
				@mouseleave="onLeave(child.node, 'child')"
				@click.stop="onClickNode(child.node, 'child', $event)"
			>
				<rect
					:width="child.width"
					:height="child.height"
					:rx="(childCorner * scale).toString()"
					:ry="(childCorner * scale).toString()"
					:fill="getChildFill(child.node)"
					:stroke="getNodeStroke(child.node, 'child')"
					:class="['mindmap-child-rect', childClass]"
					:style="childComputedStyle"
				/>
				<text
					:x="child.width / 2"
					:y="child.height / 2"
					text-anchor="middle"
					alignment-baseline="middle"
					:fill="getNodeTextColor(child.node, 'child')"
					:font-size="child.fontSize + 'px'"
					font-weight="bold"
					:style="{ pointerEvents: 'none', whiteSpace: 'pre', dominantBaseline: 'middle' }"
				>
					<tspan v-for="(line, idx) in (child.label || '').split('\\n')" :key="idx" :x="child.width / 2" :dy="idx === 0 ? 0 : child.fontSize * 1.2">
						{{ line }}
					</tspan>
				</text>
			</g>
		</svg>
	</div>
</template>

<script setup>
import { ref, computed } from 'vue'

/** Props：保留原功能 */
const props = defineProps({
	lineType: { type: String, default: 'straight' },
	lineWidth: { type: Number, default: 2 },
	lineColor: { type: String, default: '#888' },
	svgWidth: { type: Number, default: 0 },
	svgHeight: { type: Number, default: 0 },

	parent: { type: Object, default: () => ({ id: 'parent', label: '地标颇章' }) },
	parentX: { type: Number, default: 100 },
	parentY: { type: Number, default: null },
	parentFontSize: { type: Number, default: 16 },
	parentFontColor: { type: String, default: '#fff' },
	parentHeight: { type: Number, default: 50 },
	parentPaddingX: { type: Number, default: 16 },
	parentPaddingY: { type: Number, default: 10 },
	parentCorner: { type: Number, default: 0 },

	children: { type: Array, default: () => [] },
	childXOffset: { type: Number, default: 235 },
	childFontSize: { type: Number, default: 14 },
	childFontColor: { type: String, default: '#fff' },
	childHeight: { type: Number, default: 40 },
	childPaddingX: { type: Number, default: 12 },
	childPaddingY: { type: Number, default: 8 },
	childCorner: { type: Number, default: 0 },

	verticalGap: { type: Number, default: 17 },
	horizontalGap: { type: Number, default: 30 },

	enableParentClick: { type: Boolean, default: true },
	onNodeClick: { type: Function, default: null },
	enableHoverChildren: { type: Boolean, default: true },
	enableHoverParent: { type: Boolean, default: true },

	parentStyle: { type: Object, default: () => ({}) },
	childStyle: { type: Object, default: () => ({}) },
	parentActiveStyle: { type: Object, default: () => ({}) },
	childActiveStyle: { type: Object, default: () => ({}) },

	// 新增：CSS 类名支持，方便通过样式表控制
	parentClass: { type: String, default: '' },
	childClass: { type: String, default: '' },
	
	// 新增：背景图片快捷方式
	parentBackgroundImage: { type: String, default: '' },
	childBackgroundImage: { type: String, default: '' },

	parentColor: { type: String, default: '#0d1f49' },
	childColor: { type: String, default: '#0d1f49' },

	// padding around content
	paddingLeft: { type: Number, default: 40 },
	paddingRight: { type: Number, default: 40 },
	paddingTop: { type: Number, default: 20 },
	paddingBottom: { type: Number, default: 20 }
})

const emit = defineEmits(['node-click'])
const hoverId = ref(null)
const activeId = ref(null)

/* ---------- SCALE 控制 ---------- */
const scale = ref(1) // 当前缩放比例
const minScale = 0.3
const maxScale = 3
const step = 0.1

function setScale(v) {
	scale.value = Math.max(minScale, Math.min(maxScale, +v.toFixed(2)))
}
function zoomIn() {
	setScale(Math.min(maxScale, +(scale.value + step).toFixed(2)))
}
function zoomOut() {
	setScale(Math.max(minScale, +(scale.value - step).toFixed(2)))
}
function getScale() {
	return scale.value
}

function resetZoom() {
	scale.value = 1
}

/* ---------- 文本测量（基准尺寸） ---------- */
const _canvas = typeof window !== 'undefined' ? document.createElement('canvas') : null
const _ctx = _canvas?.getContext('2d') ?? null
function measureTextWidth(text, fontSize = 14, fontFamily = 'sans-serif') {
	if (!_ctx) {
		return text.length * fontSize * 0.5
	}
	_ctx.font = `${fontSize}px ${fontFamily}`
	return _ctx.measureText(text).width
}

/* STEP 1: 每个子节点的基准尺寸（不含 scale） */
const childrenMeta = computed(() => {
	return (props.children || []).map((c) => {
		const label = String(c.label ?? c.name ?? '')
		const fontSize = c.fontSize ?? props.childFontSize
		const textWidth = measureTextWidth(label, fontSize)
		const width = c.width ?? Math.ceil(textWidth + props.childPaddingX * 2)
		const height = c.height ?? props.childHeight ?? Math.ceil(props.childPaddingY * 2 + fontSize)
		const color = c.color ?? props.childColor
		return { node: c, label, fontSize, width, height, color }
	})
})

/* STEP 2: 基准子节点总高度/最大宽度 */
const totalChildrenHeightBase = computed(() => {
	if (!childrenMeta.value.length) {
		return 0
	}
	return childrenMeta.value.reduce((s, c) => s + c.height, 0) + props.verticalGap * (childrenMeta.value.length - 1)
})
const maxChildWidthBase = computed(() => {
	if (!childrenMeta.value.length) {
		return 0
	}
	return Math.max(...childrenMeta.value.map(c => c.width))
})

/* STEP 3: 父节点基准尺寸 */
const parentMeta = computed(() => {
	const p = props.parent || { id: 'parent', label: '' }
	const text = String(p.label ?? '')
	const textWidth = measureTextWidth(text, props.parentFontSize)
	const width = p.width ?? Math.ceil(textWidth + props.parentPaddingX * 2)
	const height = p.height ?? props.parentHeight ?? Math.ceil(props.parentPaddingY * 2 + props.parentFontSize)
	return { node: p, label: text, width, height, color: p.color ?? props.parentColor }
})

/* 父盒子最小尺寸（来自 props.svgWidth / svgHeight） */
const MIN_PARENT_HEIGHT = computed(() => props.svgHeight || 120)
const MIN_PARENT_WIDTH = computed(() => props.svgWidth || 200)

/* ---------- SCALED （根据 scale） ---------- */
const s = computed(() => scale.value)

// scaled gaps / padding / lineWidth
const scaledHorizontalGap = computed(() => props.horizontalGap * s.value)
const scaledVerticalGap = computed(() => props.verticalGap * s.value)
const scaledPaddingLeft = computed(() => props.paddingLeft * s.value)
const scaledPaddingRight = computed(() => props.paddingRight * s.value)
const scaledPaddingTop = computed(() => props.paddingTop * s.value)
const scaledPaddingBottom = computed(() => props.paddingBottom * s.value)
const scaledLineWidth = computed(() => Math.max(0.5, props.lineWidth * s.value))

/* scaled parent & children sizes (应用 scale) */
const parentMetaScaled = computed(() => {
	const pm = parentMeta.value
	return {
		node: pm.node,
		label: pm.label,
		width: Math.max(1, Math.round(pm.width * s.value)),
		height: Math.max(1, Math.round(pm.height * s.value)),
		fontSize: Math.max(1, +(props.parentFontSize * s.value).toFixed(2)),
		color: pm.color
	}
})

const childrenMetaScaled = computed(() =>
	childrenMeta.value.map(meta => ({
		node: meta.node,
		label: meta.label,
		width: Math.max(1, Math.round(meta.width * s.value)),
		height: Math.max(1, Math.round(meta.height * s.value)),
		fontSize: Math.max(1, +(meta.fontSize * s.value).toFixed(2)),
		color: meta.color
	}))
)

const totalChildrenHeightScaled = computed(() => {
	if (!childrenMetaScaled.value.length) {
		return 0
	}
	return childrenMetaScaled.value.reduce((s, c) => s + c.height, 0) + scaledVerticalGap.value * (childrenMetaScaled.value.length - 1)
})
const maxChildWidthScaled = computed(() => {
	if (!childrenMetaScaled.value.length) {
		return 0
	}
	return Math.max(...childrenMetaScaled.value.map(c => c.width))
})

/* ---------- autoWidth / autoHeight 使用 scaled 值 ---------- */
const autoHeight = computed(() => {
	const contentHeight = Math.max(parentMetaScaled.value.height, totalChildrenHeightScaled.value)
	const fullHeight = contentHeight + scaledPaddingTop.value + scaledPaddingBottom.value
	return Math.max(fullHeight, MIN_PARENT_HEIGHT.value)
})

const autoWidth = computed(() => {
	const contentA =
		scaledPaddingLeft.value + parentMetaScaled.value.width + scaledHorizontalGap.value + maxChildWidthScaled.value + scaledPaddingRight.value
	const contentB =
		(props.parentX ?? 0) + parentMetaScaled.value.width + scaledHorizontalGap.value + maxChildWidthScaled.value + scaledPaddingRight.value
	const fullWidth = Math.max(contentA, contentB) - 20
	return Math.max(fullWidth, MIN_PARENT_WIDTH.value)
})

/* ---------- 放置父节点 / 子节点（使用 scaled 值） ---------- */
const parentPlaced = computed(() => {
	const pm = parentMetaScaled.value
	const x = childrenMeta.value.length === 0 ? (autoWidth.value - pm.width) / 2 : props.parentX * s.value
	// 如果指定了parentY，使用指定值；否则居中
	const y = props.parentY !== null ? props.parentY * s.value : (autoHeight.value - pm.height) / 2
	return {
		node: pm.node,
		label: pm.label,
		width: pm.width,
		height: pm.height,
		x: Math.round(x),
		y: Math.round(y),
		fontSize: pm.fontSize,
		color: pm.color
	}
})

const childrenPlaced = computed(() => {
	const px = parentPlaced.value.x + parentPlaced.value.width + scaledHorizontalGap.value
	const startY = (autoHeight.value - totalChildrenHeightScaled.value) / 2
	const arr = []
	let accum = 0
	for (const meta of childrenMetaScaled.value) {
		const x = Math.round(px)
		const y = Math.round(startY + accum)
		arr.push({ node: meta.node, label: meta.label, width: meta.width, height: meta.height, x, y, color: meta.color, fontSize: meta.fontSize })
		accum += meta.height + scaledVerticalGap.value
	}
	return arr
})

/* ---------- 计算连线（使用 scaled positions） ---------- */
const nodesForLinks = computed(() => [parentPlaced.value, ...childrenPlaced.value])

const straightLinks = computed(() => {
	const p = nodesForLinks.value[0]
	return nodesForLinks.value.slice(1).map((c) => ({
		id: `link-${c.node.id}`,
		x1: p.x + p.width,
		y1: p.y + p.height / 2,
		x2: c.x,
		y2: c.y + c.height / 2,
		strokeWidth: scaledLineWidth.value
	}))
})

const bezierLinks = computed(() => {
	const p = nodesForLinks.value[0]
	return nodesForLinks.value.slice(1).map((c) => {
		const x1 = p.x + p.width
		const y1 = p.y + p.height / 2
		const x2 = c.x
		const y2 = c.y + c.height / 2
		const midX = (x1 + x2) / 2
		return { id: `link-${c.node.id}`, d: `M ${x1} ${y1} C ${midX} ${y1}, ${midX} ${y2}, ${x2} ${y2}`, strokeWidth: scaledLineWidth.value }
	})
})

/* 样式 / 高亮逻辑（保持） */
const parentComputedStyle = computed(() => ({ cursor: props.enableParentClick ? 'pointer' : 'default', ...props.parentStyle }))
const childComputedStyle = computed(() => ({ ...props.childStyle }))

function isHover(node) {
	return hoverId.value === node.id
}
function isActive(node) {
	return activeId.value === node.id
}

function getNodeFill(node, type) {
	const base = node.color ?? (type === 'parent' ? props.parentColor : props.childColor)
	if (isActive(node)) {
		return (type === 'parent' ? props.parentActiveStyle : props.childActiveStyle)?.fill ?? base
	}
	if (isHover(node)) {
		return (type === 'parent' ? props.enableHoverParent : props.enableHoverChildren) ? brighten(base) : base
	}
	return base
}

// 父节点填充（支持背景图片）
function getParentFill(node) {
	if (props.parentBackgroundImage) {
		return 'url(#parent-bg-pattern)'
	}
	return getNodeFill(node, 'parent')
}

// 子节点填充（支持背景图片）
function getChildFill(node) {
	if (props.childBackgroundImage) {
		return 'url(#child-bg-pattern)'
	}
	return getNodeFill(node, 'child')
}
function getNodeStroke(node, type) {
	if (isActive(node)) {
		return (type === 'parent' ? props.parentActiveStyle : props.childActiveStyle)?.stroke ?? '#000'
	}
	if (isHover(node)) {
		return (type === 'parent' ? props.enableHoverParent : props.enableHoverChildren) ? '#000' : 'none'
	}
	return 'none'
}
function getNodeTextColor(node, type) {
	if (isActive(node)) {
		return (type === 'parent' ? props.parentActiveStyle : props.childActiveStyle)?.color ?? '#000'
	}
	if (isHover(node)) {
		return (type === 'parent' ? props.enableHoverParent : props.enableHoverChildren) ? '#000' : type === 'parent' ? props.parentFontColor : '#fff'
	}
	return type === 'parent' ? props.parentFontColor : '#fff'
}
function brighten(color) {
	try {
		if (!color) {
			return '#ddd'
		}
		if (color.startsWith('rgb')) {
			return color
		}
		const hex = color.replace('#', '')
		const r = Math.min(255, parseInt(hex.substring(0, 2), 16) + 40)
		const g = Math.min(255, parseInt(hex.substring(2, 4), 16) + 40)
		const b = Math.min(255, parseInt(hex.substring(4, 6), 16) + 40)
		return `rgb(${r},${g},${b})`
	} catch {
		return color
	}
}

/* 事件与点击逻辑 */
function onEnter(node, type) {
	hoverId.value = node.id
}
function onLeave(node, type) {
	hoverId.value = null
}

function onClickNode(node, type, event) {
	if (event && typeof event.stopPropagation === 'function') {
		event.stopPropagation()
	}
	const payload = { node, type, event }
	emit('node-click', payload)
	if (type === 'parent' && !props.enableParentClick) {
		return
	}
	activeId.value = node.id
	setTimeout(() => (activeId.value = null), 130)
	if (typeof props.onNodeClick === 'function') {
		props.onNodeClick(node, type)
	}
}

// 暴露给父组件使用（必须在所有变量定义之后）
defineExpose({ zoomIn, zoomOut, setScale, getScale, resetZoom, parentPlaced})
</script>

<style scoped>

</style>
