import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/', redirect: '/login' },
        {
            path: '/login',
            component: () => import('../views/login/login.vue')
        },
        {
            path: '/mode-select',
            component: () => import('../views/login/mode-select.vue')
        },
        {
            path: '/pzjhx',
            component: () => import('../views/user/breachPlanSeat.vue')
        },
        {
            path: '/tdzhx',
            component: () => import('../views/user/channelCommandSeat.vue')
        },
        {
            path: '/wzkzx',
            component: () => import('../views/user/unmannedControlSeat.vue')
        },
        {
            path: '/zcdqx',
            component: () => import('../views/user/viewIntelligence.vue')
        },
    ]
})
export default router