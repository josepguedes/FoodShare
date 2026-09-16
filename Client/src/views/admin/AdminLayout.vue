<template>
    <div class="admin-layout">
        <AdminSidebar v-if="userDetails" :userDetails="userDetails" />
        <main class="admin-layout-content">
            <RouterView />
        </main>
    </div>
</template>

<script>
import AdminSidebar from '@/components/AdminSidebar.vue';
import { utilizadorService } from '@/api/utilizador';

export default {
    name: 'AdminLayout',
    components: {
        AdminSidebar
    },
    data() {
        return {
            userDetails: null
        };
    },
    async created() {
        const token = sessionStorage.getItem('token');
        if (!token) {
            this.$router.push('/login');
            return;
        }

        try {
            const payload = JSON.parse(atob(token.split('.')[1]));
            this.userDetails = await utilizadorService.getUserDetails(payload.IdUtilizador);
        } catch (error) {
            console.error('Erro ao carregar dados do administrador:', error);
            this.$router.push('/login');
        }
    }
};
</script>

<style scoped>
.admin-layout {
    min-height: calc(100vh - 80px);
    display: flex;
    background: #f8f9fa;
}

.admin-layout-content {
    flex: 1;
    min-width: 0;
}
</style>
