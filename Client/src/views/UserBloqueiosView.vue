<template>
    <div class="user-section-page user-bloqueios-page">
        <UserSidebar :userDetails="userDetails" />

        <!-- Main Content -->
        <main class="user-section-content">
            <div class="user-section-header">
                <div>
                    <h1 class="user-section-title">Utilizadores Bloqueados</h1>
                    <p class="user-section-subtitle">Gere as pessoas que não podem contactar contigo.</p>
                </div>
            </div>

            <!-- Loading State -->
            <div v-if="loading" class="text-center py-5">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Carregando...</span>
                </div>
            </div>

            <!-- Error State -->
            <div v-else-if="error" class="alert alert-danger" role="alert">
                {{ error }}
            </div>

            <!-- UserBloqueadosList Component -->
            <div v-else class="user-section-surface">
                <UserBloqueadosList :bloqueios="bloqueios" @desbloquear="desbloquearUtilizador" />
            </div>
        </main>
    </div>
</template>

<script>
import UserSidebar from '@/components/UserSidebar.vue';
import UserBloqueadosList from '@/components/UserBloqueadosList.vue';
import { utilizadorService } from '@/api/utilizador';

export default {
    name: 'UserBloqueadosView',
    components: {
        UserSidebar,
        UserBloqueadosList
    },
    data() {
        return {
            userDetails: null,
            bloqueios: [],
            loading: true,
            error: null
        }
    },
    methods: {
        async fetchUserDetails() {
            try {
                const token = sessionStorage.getItem('token');
                if (!token) {
                    this.$router.push('/login');
                    return;
                }

                const payload = JSON.parse(atob(token.split('.')[1]));
                const userDetails = await utilizadorService.getUserDetails(payload.IdUtilizador);
                this.userDetails = userDetails;
            } catch (error) {
                console.error('Error fetching user details:', error);
            }
        },
        async fetchBloqueios() {
            try {
                this.loading = true;
                this.error = null;

                const token = sessionStorage.getItem('token');
                if (!token) {
                    this.$router.push('/login');
                    return;
                }

                const payload = JSON.parse(atob(token.split('.')[1]));
                const response = await fetch(`http://localhost:3000/bloqueios/utilizador?idBloqueador=${payload.IdUtilizador}`, {
                    headers: {
                        'Authorization': `Bearer ${token}` // Add authorization header
                    }
                });

                if (!response.ok) {
                    throw new Error('Erro ao carregar utilizadores bloqueados');
                }

                if (response.status === 204) {
                    this.bloqueios = [];
                    return;
                }

                const data = await response.json();
                this.bloqueios = (data.data || []).map(bloqueio => ({
                    ...bloqueio,
                    bloqueado: {
                        ...bloqueio.bloqueado,
                        Nome: bloqueio.bloqueado?.Nome || 'Usuário',
                        ImagemPerfil: bloqueio.bloqueado?.ImagemPerfil || 'https://via.placeholder.com/32'
                    },
                    DataBloqueio: bloqueio.DataBloqueio,
                    IdUtilizadoresBloqueados: bloqueio.IdUtilizadoresBloqueados
                }));
            } catch (error) {
                console.error('Error fetching blocked users:', error);
                this.error = 'Erro ao carregar utilizadores bloqueados';
            } finally {
                this.loading = false;
            }
        },
        async desbloquearUtilizador(idBloqueio) {
            if (confirm('Tem certeza que deseja desbloquear este utilizador?')) {
                try {
                    const token = sessionStorage.getItem('token');
                    if (!token) {
                        this.$router.push('/login');
                        return;
                    }

                    const response = await fetch(`http://localhost:3000/bloqueios/utilizador/${idBloqueio}`, {
                        method: 'DELETE',
                        headers: {
                            'Authorization': `Bearer ${token}`
                        }
                    });

                    if (!response.ok) {
                        throw new Error('Erro ao desbloquear utilizador');
                    }

                    // Atualizar a lista após desbloquear
                    await this.fetchBloqueios();
                } catch (error) {
                    console.error('Error unblocking user:', error);
                    alert('Erro ao desbloquear utilizador');
                }
            }
        },
        formatDate(date) {
            if (!date) return 'Data não definida';

            try {
                const options = {
                    day: '2-digit',
                    month: '2-digit',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                };

                return new Date(date).toLocaleDateString('pt-PT', options);
            } catch (error) {
                console.error('Error formatting date:', error);
                return 'Data inválida';
            }
        }
    },
    created() {
        this.fetchUserDetails();
        this.fetchBloqueios();
    }
}
</script>

<style scoped>
.user-bloqueios-page {
    background: #f8f9fa;
}

.table th,
.table td {
    vertical-align: middle;
}

.btn-outline-danger {
    transition: all 0.2s;
}

.btn-outline-danger:hover {
    background-color: #dc3545;
    color: white;
}

</style>