<script setup>
import { useRouter } from 'vue-router';
import { User, Lock } from '@element-plus/icons-vue';
const router = useRouter();
const handleLogin = () => {
    router.push('/mode-select');
};
</script>

<template>
    <div class="login-container">
        <div class="login-title-banner">模式选择系统<br>
            <p style="font-size: 20px;">Model Selection System</p>
        </div>
        <div class="login-box">
            <h2 class="login-title">用户登录</h2>
            <div class="login-input-box">
                <el-input placeholder="请输入用户名">
                    <template #prefix>
                        <el-icon size="25" color="rgb(148, 212, 255)" >
                            <User />
                        </el-icon>
                    </template>
                </el-input>
                <el-input placeholder="请输入密码" type="password" >
                    <template #prefix>
                        <el-icon size="25" color="rgb(148, 212, 255)" >
                            <Lock />
                        </el-icon>
                    </template>
                </el-input>
            </div>
            <div class="login-button-box">
                <el-button type="primary" size="large" @click="handleLogin" class="login-button">
                    登录
                </el-button>
                <el-button type="primary" size="large" class="login-button">
                    退出
                </el-button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: rgb(21, 32, 99);
}

.login-box {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 20px;
    background: rgba(16,16,53);
    padding: 40px 60px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    text-align: center;
    width: 27vw;
    height: 34vh;
    box-sizing: border-box;
}

.login-title {
    margin-bottom: 30px;
    color:rgb(115,190,255);
    font-size: 30px;
    font-weight: bold;
}

.login-button {
    width: 100%;
    height: 45px;
    font-size: 16px;
}

.login-input-box {
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin-bottom: 20px;
    width: 100%;
}

:deep(.login-input-box input) {
    width: 100% !important;
    height: 50px !important;
    font-size: 16px !important;
    padding: 0 10px !important;
}
:deep(.login-input-box input::placeholder) {
    color:rgb(115,190,255) !important;
}

:deep(.el-input__wrapper) {
    background-color: rgba(16,16,53) !important;
    border: 1px solid rgb(74,73,107) !important;
}
.login-button-box {
    display: flex;
    gap: 20px;
    width: 100%;
}

.login-title-banner {
    font-size: 45px;
    position: absolute;
    top: 20%;
    left: 50%;
    transform: translateX(-50%);
    font-weight: bold;
    color: rgb(148, 212, 255);
    text-align: center;

}
</style>
