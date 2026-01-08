<template>

    <div class="container">

        <aside class="aside-left" :class="{ 'collapsed': isLeftCollapsed }">
            <!-- 折叠时显示的展开按钮 -->
            <div class="expand-btn" v-if="isLeftCollapsed" @click="toggleLeft">
                <el-icon>
                    <ArrowRight />
                </el-icon>
            </div>

            <!-- 正常状态的内容 -->
            <template v-else>
                <div class="aside-header">
                    <div class="aside-header-left">
                        <img src="" alt="">
                        <p>最新任务</p>
                    </div>
                    <el-icon class="close-icon" @click="toggleLeft">
                        <Close />
                    </el-icon>
                </div>

                <div class="aside-content-list-left">
                    <!-- 行动列表 -->
                    <template v-if="!showSubtaskList">
                        <div class="aside-content" v-for="item in controlledEquipList" :key="item.id"
                            @click="handleActionClick(item)">
                            <div class="aside-content-header">
                                <p>{{ item.equipmentName }}</p>
                                <img v-if="!isActionBound(item.id)" src="/p.png" alt=""
                                    style="width: 20px; height: 20px;">
                            </div>
                            <div class="aside-content-body">
                                <div class="aside-content-body-item">
                                    <p>行动编号:</p>
                                    <p>行动名称:</p>
                                    <p>行动名称:{{ item.equipmentName }}</p>
                                    <p>行动类型:</p>
                                </div>
                            </div>
                        </div>
                    </template>

                    <!-- 子任务列表 -->
                    <template v-else>
                        <div class="subtask-container">
                            <div class="subtask-header">
                                <p>{{ selectedAction?.equipmentName || '子任务详情' }}</p>
                            </div>
                            <div class="subtask-header-time">
                                <p>开始时间: {{ selectedAction?.startTime || '开始时间' }}</p>
                                <p>结束时间: {{ selectedAction?.endTime || '结束时间' }}</p>
                                <p>行动区域位置如下:</p>
                            </div>
                            <div class="subtask-table-wrapper">
                                <table class="subtask-table">
                                    <thead>
                                        <tr>
                                            <th>序号</th>
                                            <th>经度</th>
                                            <th>纬度</th>
                                            <th>高程</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(coordinate, idx) in getCurrentSubtaskCoordinates()" :key="idx">
                                            <td>{{ coordinate.index || idx + 1 }}</td>
                                            <td>{{ coordinate.longitude }}</td>
                                            <td>{{ coordinate.latitude }}</td>
                                            <td>{{ coordinate.elevation }}</td>
                                        </tr>
                                        <tr v-if="getCurrentSubtaskCoordinates().length === 0">
                                            <td colspan="4"
                                                style="text-align: center; color: rgba(255, 255, 255, 0.5);">暂无数据</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </template>
                </div>

                <div class="bottom-btn">
                    <!-- 返回按钮（仅在显示子任务列表时显示） -->
                    <div class="btn-group" v-if="showSubtaskList">
                        <el-button type="primary" @click="handlePrePlan">
                            预规划
                        </el-button>
                        <el-button type="primary" :disabled="!isPrePlanned" @click="handleBind">
                            装订
                        </el-button>
                        <el-button type="primary" @click="handleBackToActions">
                            返回
                        </el-button>
                        <!-- 新增按钮（仅在显示行动列表时显示） -->
                    </div>
                    <div class="btn-group-2" v-else>
                        <el-button type="primary" @click="handleBackToActions">
                            新增
                        </el-button>
                    </div>
                </div>
            </template>
        </aside>
        <main class="main-content" :class="{ 'expanded-left': isLeftCollapsed, 'expanded-right': isRightCollapsed }">
            <div class="test-buttons">
                <el-button @click="showPermissionDialog = true">权限管理</el-button>
                <el-button>测试按钮2</el-button>
            </div>
        </main>
        <aside class="aside-right" :class="{ 'collapsed': isRightCollapsed }">
            <!-- 折叠时显示的展开按钮 -->
            <div class="expand-btn" v-if="isRightCollapsed" @click="toggleRight">
                <el-icon>
                    <ArrowLeft />
                </el-icon>
            </div>

            <!-- 正常状态的内容 -->
            <template v-else>
                <div class="aside-header">
                    <div class="aside-header-left">
                        <img src="" alt="">
                        <p>消息控制</p>
                    </div>
                    <el-icon class="close-icon" @click="toggleRight">
                        <Close />
                    </el-icon>
                </div>

                <div class="aside-content-list-right">
                    <div class="aside-content-header-btnGroup">
                        <button>全部</button>
                        <button>信息</button>
                        <button>警告</button>
                        <button>错误</button>
                        <button>待命</button>
                    </div>
                    <div class="aside-content-header-btnSelect">
                        <select>全部装备</select>
                    </div>

                    <div class="aside-content-list-wrap">
                        <div class="aside-content-right">
                            <p>XXX厂家XXX设备 </p>
                            <p style="font-size: 12px;">19:12:12</p>
                        </div>
                        <div class="aside-content-right-content">
                            <p>单装置的操控指令XXX </p>
                        </div>
                        <div class="aside-content" v-for="item in 3" :key="item">
                            <div class="aside-content-header">
                                <p>行动类型</p>
                                <el-button type="primary">按钮</el-button>
                            </div>
                            <div class="aside-content-body">
                                <div class="aside-content-body-item">
                                    <p>行动编号:</p>
                                    <p>行动名称:</p>
                                    <p>行动名称:</p>
                                    <p>行动类型:</p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>


            </template>
        </aside>
        <footer class="footer" v-show="isFooterVisible">
            <div class="footer-header">
                <div class="footer-header-title">
                    <div class="title-left">
                        <img src="" alt="">
                        <p>行为序列规划</p>
                    </div>
                    <div class="title-right" @click="closeFooter">
                        <el-icon style="cursor: pointer;">
                            <Close />
                        </el-icon>
                    </div>

                </div>
            </div>
            <div class="footer-content">
                <div class="footer-content-left-btn">
                    <div class="btn-status">
                        <el-icon size="20">
                            <VideoPlay />
                        </el-icon>
                        <el-icon size="20">
                            <VideoPause />
                        </el-icon>
                        <el-icon size="20">
                            <RefreshRight />
                        </el-icon>
                    </div>

                </div>
                <div class="footer-content-right-table">
                    <table class="footer-table">
                        <tbody>
                            <tr v-for="item in prePlanData" :key="item.id">
                                <td>{{ item.actionName }}</td>
                                <td>{{ item.value1 }}</td>
                                <td>{{ item.value2 }}</td>
                            </tr>
                            <tr v-if="prePlanData.length === 0">
                                <td colspan="3" style="text-align: center; color: rgba(255, 255, 255, 0.5);">暂无预规划数据
                                </td>
                            </tr>
                        </tbody>

                    </table>
                </div>
            </div>
        </footer>
    </div>

    <!-- 权限管理弹窗 -->
    <Teleport to="body">
        <div v-if="showPermissionDialog" class="permission-dialog-overlay" @click.self="showPermissionDialog = false">
            <div class="permission-dialog">
                <div class="permission-dialog-header">
                    <div class="permission-dialog-header-left">
                        <img src="" alt="">
                        <p>权限管理</p>
                    </div>
                    <el-icon style="cursor: pointer;color: white;" @click="showPermissionDialog = false">
                        <Close />
                    </el-icon>
                </div>
                <div class="permission-dialog-content">
                    <!-- 内容区域，您可以在此填写内容 -->
                    <button>权限管理</button>
                    <p>当前席位:XXX</p>
                    <!-- <table>
                        <thead>
                            <tr>
                                <th>权限</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>权限</td>
                                <td>操作</td>
                            </tr>
                        </tbody>
                    </table> -->
                    <el-table :data="equipList" style="width: 100%" class="my-table">
                        <el-table-column prop="equipmentName" label="装备名称" />
                        <el-table-column prop="equipmentNumber" label="编号" />
                        <el-table-column prop="controlPersonnal" label="控制位置" />
                        <el-table-column prop="monitoringPersonnalList" label="监控位置" />
                        <el-table-column prop="permissionControl" label="控制权限" class="permission-control">
                            <template #default="scope">
                                <div class="button-group">
                                    <el-button :class="{ 'btn-active': scope.row.controlActiveBtn === 1 }"
                                        class="permission-btn-1" @click="handleReleaseControl(scope.row)">
                                        释放控制
                                    </el-button>
                                    <el-button :class="{ 'btn-active': scope.row.controlActiveBtn === 2 }"
                                        class="permission-btn-2" @click="handleRequestControl(scope.row)">
                                        请求控制
                                    </el-button>
                                </div>
                            </template>
                        </el-table-column>

                        <el-table-column prop="permissionControl" label="监控权限" class="permission-control">
                            <template #default="scope">
                                <div class="button-group">
                                    <el-button :class="{ 'btn-active': scope.row.controlActiveBtn === 1 }"
                                        class="permission-btn-1" @click="handleReleaseControl(scope.row)">
                                        释放监控
                                    </el-button>
                                    <el-button :class="{ 'btn-active': scope.row.controlActiveBtn === 2 }"
                                        class="permission-btn-2" @click="handleRequestControl(scope.row)">
                                        释放控制
                                    </el-button>
                                </div>
                            </template>
                        </el-table-column>
                    </el-table>
                </div>
            </div>
        </div>
    </Teleport>

</template>
<script setup>
import { ref, onMounted } from 'vue';
import { Close, ArrowRight, ArrowLeft } from '@element-plus/icons-vue';
import axios from 'axios';
import { ElMessage } from 'element-plus';

const equipList = ref([]);
const controlledEquipList = ref([]); // 被控制的设备列表（行动列表）
const showSubtaskList = ref(false); // 是否显示子任务列表
const selectedAction = ref(null); // 当前选中的行动
const subtaskList = ref([]); // 子任务列表
const isPrePlanned = ref(false); // 当前行动是否已预规划
const boundActionIds = ref(new Set()); // 已装订的行动ID集合
const prePlanData = ref([]); // 预规划数据列表

// 获取所有设备列表
const getEquipList = () => {
    return axios.get('/api/equipPermission_listNoPage').then(res => {
        console.log(res.data)
        // 为每行数据添加控制权限按钮激活状态，初始值为2（请求控制激活）
        equipList.value = res.data.map(item => ({
            ...item,
            controlActiveBtn: 2 // 1表示释放控制激活，2表示请求控制激活
        }));
        console.log(equipList.value);
        return res.data;
    })
}

// 获取被控制的设备列表
const getControlledEquipList = () => {
    axios.get('/api/equipControl_listNoPage').then(res => {
        console.log('被控制的设备列表:', res.data);
        // 只显示状态为1（请求控制）的设备，并关联完整设备信息
        const controlledList = res.data.filter(item => item.status === 1);
        // 关联设备详细信息
        controlledEquipList.value = controlledList.map(controlItem => {
            const equipInfo = equipList.value.find(equip => equip.modelid === controlItem.modelid);
            return {
                ...controlItem,
                ...equipInfo, // 合并设备详细信息
                id: controlItem.id || equipInfo?.id
            };
        });
    }).catch(err => {
        console.error('获取被控制设备列表失败:', err);
        controlledEquipList.value = [];
    });
}

// 请求控制
const handleRequestControl = (row) => {
    // 调用接口，传入modelId和status
    axios.patch('/api/equipControl_update', {
        modelid: row.modelid,
        status: 1 // 1表示请求控制
    }).then(res => {
        console.log('请求控制成功:', res.data);
        // 更新按钮状态
        row.controlActiveBtn = 1;
        // 刷新被控制的设备列表
        getControlledEquipList();
        ElMessage.success('请求控制成功');
    }).catch(err => {
        console.error('请求控制失败:', err);
        ElMessage.error('请求控制失败');
    });
}

// 释放控制
const handleReleaseControl = (row) => {
    // 调用接口，传入modelId和status
    axios.patch('/api/equipControl_update', {
        modelid: row.modelid,
        status: 2 // 2表示释放控制
    }).then(res => {
        console.log('释放控制成功:', res.data);
        // 更新按钮状态
        row.controlActiveBtn = 2;
        // 刷新被控制的设备列表
        getControlledEquipList();
        ElMessage.success('释放控制成功');
    }).catch(err => {
        console.error('释放控制失败:', err);
        ElMessage.error('释放控制失败');
    });
}

// 点击行动盒子，加载子任务
const handleActionClick = (action) => {
    selectedAction.value = action;
    showSubtaskList.value = true;
    // 重置预规划状态（每次点击新的行动时重置）
    isPrePlanned.value = false;
    // 获取该行动相关的子任务
    getSubtasksByAction(action.id);
}

// 获取指定行动的子任务列表
const getSubtasksByAction = (actionId) => {
    // 调用接口获取子任务列表
    // 注意：这里需要根据实际的接口和数据关联关系调整
    // 如果子任务数据中有actionId字段，可以通过该字段过滤
    // 如果子任务数据中有subtaskId字段，可能需要通过其他方式关联
    axios.get('/api/subtask_listNoPageDetail').then(res => {
        console.log('子任务列表:', res.data);
        // 根据行动ID过滤子任务
        // 这里假设子任务数据中有actionId或subtaskId字段用于关联
        // 如果数据结构不同，请根据实际情况调整过滤逻辑
        const allSubtasks = res.data || [];
        // 临时方案：显示所有子任务（如果接口支持按行动ID过滤，请使用对应的接口）
        subtaskList.value = allSubtasks;
    }).catch(err => {
        console.error('获取子任务列表失败:', err);
        // 如果接口不存在或失败，使用空数组
        subtaskList.value = [];
    });
}

// 获取当前子任务的坐标数据
const getCurrentSubtaskCoordinates = () => {
    if (!selectedAction.value || subtaskList.value.length === 0) {
        return [];
    }
    // 找到与当前选中行动关联的子任务
    // 这里假设通过某种方式关联，如果数据结构不同，请调整关联逻辑
    // 临时方案：使用第一个子任务的坐标数据
    const currentSubtask = subtaskList.value[0];
    return currentSubtask?.coordinates || [];
}

// 返回行动列表
const handleBackToActions = () => {
    showSubtaskList.value = false;
    selectedAction.value = null;
    subtaskList.value = [];
    isPrePlanned.value = false; // 重置预规划状态
}

// 预规划处理
const handlePrePlan = () => {
    if (!selectedAction.value) {
        ElMessage.warning('请先选择行动');
        return;
    }
    // 获取taskId，这里假设从selectedAction中获取，如果没有则使用id
    const taskId = selectedAction.value.taskId || selectedAction.value.id || 1;

    // 调用接口获取预规划数据
    axios.get('/api/actionPrePlan_list', {
        params: {
            taskId: taskId
        }
    }).then(res => {
        console.log('预规划数据:', res.data);
        // 处理返回的数据结构
        let data = [];
        if (Array.isArray(res.data)) {
            // 如果返回的是数组，查找匹配taskId的项
            const matchedItem = res.data.find(item => item.taskId == taskId);
            if (matchedItem && matchedItem.data) {
                data = matchedItem.data;
            } else if (res.data.length > 0 && res.data[0].data) {
                // 如果没有匹配的，使用第一个
                data = res.data[0].data;
            }
        } else if (res.data && res.data.data) {
            // 如果返回的是对象，直接提取data字段
            data = res.data.data;
        } else if (Array.isArray(res.data)) {
            // 如果直接是数组
            data = res.data;
        }

        prePlanData.value = data;
        // 执行预规划操作
        isPrePlanned.value = true;
        ElMessage.success('预规划成功');
        console.log('预规划行动:', selectedAction.value, '预规划数据:', data);
    }).catch(err => {
        console.error('获取预规划数据失败:', err);
        ElMessage.error('获取预规划数据失败');
        // 即使接口失败，也标记为已预规划（可选）
        // isPrePlanned.value = true;
    });
}

// 装订处理
const handleBind = () => {
    if (!selectedAction.value) {
        ElMessage.warning('请先选择行动');
        return;
    }
    if (!isPrePlanned.value) {
        ElMessage.warning('请先进行预规划');
        return;
    }
    // 执行装订操作
    boundActionIds.value.add(selectedAction.value.id);
    ElMessage.success('装订完成');
    console.log('装订行动:', selectedAction.value);
}

// 检查行动是否已装订
const isActionBound = (actionId) => {
    return boundActionIds.value.has(actionId);
}

onMounted(() => {
    // 先获取所有设备列表，然后再获取被控制的设备列表（用于数据关联）
    getEquipList().then(() => {
        getControlledEquipList();
    });
})

// 左右侧边栏折叠状态
const isLeftCollapsed = ref(false);
const isRightCollapsed = ref(false);

// footer显示状态（默认显示）
const isFooterVisible = ref(true);

// 权限管理弹窗显示状态
const showPermissionDialog = ref(false);

// 权限管理表格模拟数据
const tableData = ref([
    {
        name: '装备A',
        number: 'EQ001',
        controlPosition: '控制室A',
        monitorPosition: '监控室A',
        permissionControl: '是',
        monitorPermission: '是',
        controlBtn1Active: false,
        controlBtn2Active: false,
        monitorBtn1Active: false,
        monitorBtn2Active: false
    },
    {
        name: '装备B',
        number: 'EQ002',
        controlPosition: '控制室B',
        monitorPosition: '监控室B',
        permissionControl: '是',
        monitorPermission: '否',
        controlBtn1Active: false,
        controlBtn2Active: false,
        monitorBtn1Active: false,
        monitorBtn2Active: false
    },
    {
        name: '装备C',
        number: 'EQ003',
        controlPosition: '控制室C',
        monitorPosition: '监控室C',
        permissionControl: '否',
        monitorPermission: '是',
        controlBtn1Active: false,
        controlBtn2Active: false,
        monitorBtn1Active: false,
        monitorBtn2Active: false
    },
    {
        name: '装备D',
        number: 'EQ004',
        controlPosition: '控制室D',
        monitorPosition: '监控室D',
        permissionControl: '是',
        monitorPermission: '是',
        controlBtn1Active: false,
        controlBtn2Active: false,
        monitorBtn1Active: false,
        monitorBtn2Active: false
    },
    {
        name: '装备E',
        number: 'EQ005',
        controlPosition: '控制室E',
        monitorPosition: '监控室E',
        permissionControl: '否',
        monitorPermission: '否',
        controlBtn1Active: false,
        controlBtn2Active: false,
        monitorBtn1Active: false,
        monitorBtn2Active: false
    }
]);

// 切换左侧边栏
const toggleLeft = () => {
    isLeftCollapsed.value = !isLeftCollapsed.value;
};

// 切换右侧边栏
const toggleRight = () => {
    isRightCollapsed.value = !isRightCollapsed.value;
};

// 关闭footer
const closeFooter = () => {
    isFooterVisible.value = false;
};
</script>

<style lang="scss" scoped>
// 颜色变量
$bg-color: #1d335c;
$text-color: #497fde;
$btn-color: #3370e0;
$btn-color-border: #68c9f6;
$bg-color-1: #112051;


.container {
    display: flex;
    flex-direction: row;
    height: 1035px;
    padding: 0;
    margin: 0;
    position: relative;
    width: 100%;
    background-color: $bg-color;
}

.aside-left {
    position: relative;
    width: 20%;
    height: 1035px;
    background-color: $bg-color;
    flex-shrink: 0;
    color: white;
    transition: width 0.3s ease;
    overflow: hidden;

    &.collapsed {
        width: 30px;
    }

    .expand-btn {
        width: 30px;
        height: 60px;
        background-color: $bg-color;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        border-right: 1px solid rgba(255, 255, 255, 0.1);
        transition: all 0.3s ease;

        &:hover {
            background-color: lighten($bg-color, 5%);
        }

        .el-icon {
            color: white;
            font-size: 18px;
        }
    }

    .aside-header {
        height: 45px;
        background-color: red;
        padding: 0 10px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;

        .aside-header-left {
            display: flex;
            align-items: center;
            gap: 10px;

            p {
                color: $text-color;
                font-size: 16px;
                margin: 0;
            }

            img {
                width: 20px;
                height: 20px;
            }
        }

        .close-icon {
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: transform 0.3s ease;

            &:hover {
                transform: scale(1.1);
            }
        }
    }

    .aside-content-list-left {
        .aside-content {
            border-bottom: 1px solid #202124;
            padding: 20px;
            height: 150px;
            cursor: pointer;
            transition: all 0.3s ease;

            &:hover {
                background-color: rgba(255, 255, 255, 0.05);
            }

            .aside-content-header {
                display: flex;
                justify-content: space-between;
            }
        }

        // 子任务项样式
        .subtask-item {
            border-bottom: 1px solid #202124;
            padding: 20px;
            min-height: 120px;
            background-color: rgba(17, 32, 81, 0.3);
            border-left: 3px solid $text-color;
            margin-bottom: 10px;
            border-radius: 4px;

            .aside-content-header {
                display: flex;
                justify-content: space-between;
            }
        }

        // 子任务表格容器
        .subtask-container {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;

            .subtask-header {
                padding: 15px 20px;
                border-bottom: 1px solid #202124;
                background-color: rgba(17, 32, 81, 0.5);

                p {
                    color: $text-color;
                    font-size: 16px;
                    margin: 0;
                    font-weight: 500;
                }
            }

            .subtask-header-time {
                display: flex;
                flex-direction: column;
                padding: 10px;
                background-color: rgba(17, 32, 81, 0.5);

                p {
                    color: $text-color;
                }
            }

            .subtask-table-wrapper {
                flex: 1;
                overflow-y: auto;
                padding: 10px;

                .subtask-table {
                    width: 100%;
                    border-collapse: collapse;
                    background-color: rgba(17, 32, 81, 0.3);
                    color: white;

                    thead {
                        background-color: rgba(73, 127, 222, 0.3);

                        th {
                            padding: 10px;
                            text-align: left;
                            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                            color: $text-color;
                            font-size: 14px;
                            font-weight: 500;
                        }
                    }

                    tbody {
                        tr {
                            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                            transition: background-color 0.2s ease;

                            &:hover {
                                background-color: rgba(255, 255, 255, 0.05);
                            }

                            &:last-child {
                                border-bottom: none;
                            }

                            td {
                                padding: 10px;
                                font-size: 13px;
                                color: rgba(255, 255, 255, 0.9);
                            }
                        }
                    }
                }
            }
        }
    }

    .bottom-btn {
        position: absolute;
        bottom: 200px;
        left: 190px;
        height: 35px;

        .btn-group {
            display: flex;
            gap: 5px;

            button {
                width: 60px;
                height: 25px;
                background-color: $btn-color;
                border: 1px solid $btn-color-border;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;

                &:disabled {
                    background-color: rgba(51, 112, 224, 0.3) !important;
                    border-color: rgba(104, 201, 246, 0.3) !important;
                    color: rgba(255, 255, 255, 0.5) !important;
                    cursor: not-allowed !important;
                }
            }
        }

        .btn-group-2 {
            margin-left: 140px;

            button {
                width: 50px;
                height: 25px;
                background-color: $btn-color;
                border: 1px solid $btn-color-border;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;

            }
        }
    }
}

.main-content {
    width: 60%;
    height: 100%;
    flex-shrink: 0;
    transition: width 0.3s ease;
    position: relative;

    &.expanded-left {
        width: calc(60% + 20% - 30px);
    }

    &.expanded-right {
        width: calc(60% + 20% - 30px);
    }

    &.expanded-left.expanded-right {
        width: calc(60% + 40% - 60px);
    }

    .test-buttons {
        padding: 20px;
        display: flex;
        gap: 10px;
    }
}

.aside-right {
    position: relative;
    width: 20%;
    height: 1035px;
    background-color: $bg-color;
    flex-shrink: 0;
    color: white;
    transition: width 0.3s ease;
    overflow: hidden;

    &.collapsed {
        width: 30px;
    }

    .expand-btn {
        width: 30px;
        height: 60px;
        background-color: $bg-color;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        border-left: 1px solid rgba(255, 255, 255, 0.1);
        transition: all 0.3s ease;

        &:hover {
            background-color: lighten($bg-color, 5%);
        }

        .el-icon {
            color: white;
            font-size: 18px;
        }
    }

    .aside-header {
        height: 45px;
        background-color: red;
        padding: 0 10px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;

        .aside-header-left {
            display: flex;
            align-items: center;
            gap: 10px;

            p {
                color: $text-color;
                font-size: 16px;
                margin: 0;
            }

            img {
                width: 20px;
                height: 20px;
            }
        }

        .close-icon {
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: transform 0.3s ease;

            &:hover {
                transform: scale(1.1);
            }
        }
    }

    .aside-content-list-right {
        padding: 30px 20px 0 20px;

        .aside-content-header-btnGroup {
            margin-bottom: 10px;
            display: flex;
            gap: 10px;

            button {
                width: 60px;
                height: 30px;
                background-color: $btn-color;
                border: 1px solid $btn-color-border;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;

                &:hover {
                    background-color: lighten($bg-color, 5%);
                }
            }
        }

        .aside-content-header-btnSelect {
            select {
                width: 70%;
                height: 30px;
                background-color: #334462;
                border: 1px solid #e1e4e9;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-bottom: 10px;
            }
        }

        .aside-content-list-wrap {
            padding: 10px;
            border: 1px solid red;
            height: 700px;

            .aside-content-right {
                display: flex;
                justify-content: space-between;
            }

            .aside-content-right-content {
                border: 1px solid $btn-color-border;
                padding: 10px;
                height: 50px;
                background-color: $bg-color-1
            }


            .aside-content {
                border-bottom: 1px solid #202124;
                height: 150px;

                .aside-content-header {
                    display: flex;
                    justify-content: space-between;
                }
            }
        }

    }

    .bottom-btn {
        position: absolute;
        bottom: 200px;
        left: 350px;
        height: 45px;
    }
}

.footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    height: 200px;
    background-color: rgb(66, 55, 55);
    color: white;
    z-index: 1000;

    .footer-header {
        width: 100%;
        height: 30px;

        p {
            color: $text-color;
        }

        .footer-header-title {
            background-color: #284478;
            padding-left: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            height: 30px;

            .title-left {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .title-right {
                margin-right: 10px;
            }
        }
    }

    .footer-content {
        display: flex;

        .footer-content-left-btn {
            width: 35px;
            height: 170px;
            background-color: $bg-color-1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 10px;
            padding-left: 10px;

            .btn-status {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            button {
                width: 30px;
                height: 30px;
                background-color: $btn-color;
            }
        }

        .footer-content-right-table {
            width: 90%;
            padding: 20px;
            box-sizing: border-box;

            .footer-table {
                width: 1830px;
                background-color: $bg-color-1;
                border-collapse: collapse;

                tbody {
                    height: 100px;

                    tr {

                        td {
                            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                            border-left: none;
                            border-right: none;
                            color: white;

                            &:first-child {
                                padding-left: 40px;
                            }
                        }

                        &:last-child td {
                            border-bottom: none;
                        }
                    }
                }
            }
        }
    }
}

/* 权限管理弹窗样式 */
.permission-dialog-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 3000;
}

.permission-dialog {
    padding: 0 10px 10px 10px;
    width: 1000px;
    height: 600px;
    background-color: #16284f;
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    pointer-events: auto;
    position: relative;
    z-index: 3001;
}

.permission-dialog-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 45px;


    .permission-dialog-header-left {
        display: flex;

        p {
            color: $text-color;
        }
    }

}

.permission-dialog-content {
    flex: 1;
    padding: 10px;
    overflow-y: auto;
    color: white;
    background-color: #273b67;

    button {
        width: 15%;
        height: 30px;
        background-color: #1a3174;
        border: 1px solid #3370e0;
        color: white;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .my-table {
        width: 100%;
        background-color: #273b67;

        .el-table__header {
            background-color: red;
        }
    }

    // 修改表格中按钮的样式（使用深度选择器穿透scoped样式）
    :deep(.my-table .el-table__body-wrapper) {
        .button-group {
            display: flex;
            flex-direction: row;
            gap: 5px;
            align-items: center;
        }

        .permission-btn-1 {
            width: 60px;
            height: 25px;
            color: white !important;
            background-color: #41567a !important;
            border: 1px solid $btn-color-border !important;
            padding: 0 8px !important;
            font-size: 12px !important;
            margin: 0 !important;

            &:hover {
                background-color: lighten(#41567a, 10%) !important;
            }

            &.btn-active {
                background-color: #3370e0 !important;
                border-color: #68c9f6 !important;
            }
        }

        .permission-btn-2 {
            width: 60px;
            height: 25px;
            color: white !important;
            background-color: #5a6b8a !important;
            border: 1px solid $btn-color-border !important;
            padding: 0 8px !important;
            font-size: 12px !important;
            margin: 0 !important;

            &:hover {
                background-color: lighten(#5a6b8a, 10%) !important;
            }

            &.btn-active {
                background-color: #4a90e2 !important;
                border-color: #68c9f6 !important;
            }
        }
    }
}
</style>