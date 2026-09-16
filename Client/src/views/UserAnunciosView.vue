<template>
    <div class="user-section-page anuncios-page">
        <UserSidebar :userDetails="userDetails" />
        <main class="user-section-content">
            <div class="user-section-header">
                <div>
                    <h1 class="user-section-title">Meus Anúncios</h1>
                    <p class="user-section-subtitle">Gere os produtos que partilhaste com a comunidade.</p>
                </div>
                        <button class="btn btn-primary" @click="openCreateModal">
                            <i class="bi bi-plus-lg me-2"></i>Criar Anúncio
                        </button>
            </div>

            <section class="user-section-surface">
                    <AnuncioList :anuncios="anuncios" :loading="loading" :error="error" @delete="deleteAnuncio"
                        @view-details="openDetails" @edit="openEditModal" @confirm-code="openConfirmCodeModal" />

                    <nav v-if="totalPages > 1" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item" :class="{ disabled: currentPage === 1 }">
                                <button class="page-link" @click="goToPage(currentPage - 1)">
                                    <i class="bi bi-chevron-left"></i>
                                </button>
                            </li>
                            <li class="page-item" v-for="page in totalPages" :key="page"
                                :class="{ active: page === currentPage }">
                                <button class="page-link" @click="goToPage(page)">{{ page }}</button>
                            </li>
                            <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                                <button class="page-link" @click="goToPage(currentPage + 1)">
                                    <i class="bi bi-chevron-right"></i>
                                </button>
                            </li>
                        </ul>
                    </nav>

                    <UserAnuncioEdit v-if="showEdit" :anuncio="selectedAnuncio" :show="showEdit" @close="closeEditModal"
                        @updated="handleAnuncioEditado" />

            </section>
        </main>

        <!-- Modal de Detalhes -->
        <UserAnuncioDetails v-if="selectedAnuncio" :anuncio="selectedAnuncio" :show="showDetails"
            @close="closeDetails" />

        <!-- Modal Criar Anúncio -->
        <CreateAnuncio v-if="showCreate" @close="closeCreate" @created="handleAnuncioCriado" />

        <!-- Modal Confirmar Código -->
        <UserConfirmCodeModal v-if="showConfirmCodeModal" :anuncioId="confirmCodeAnuncioId" :show="showConfirmCodeModal"
            @close="closeConfirmCodeModal" @confirmed="handleCodeConfirmed" />
    </div>
</template>


<script>
import UserSidebar from '@/components/UserSidebar.vue';
import UserAnuncioDetails from '@/components/UserAnuncioDetails.vue';
import UserConfirmCodeModal from '@/components/UserConfirmCodeModal.vue';
import UserAnuncioEdit from '@/components/UserAnuncioEdit.vue';
import CreateAnuncio from '@/components/CreateAnuncio.vue';
import AnuncioList from '@/components/UserAnuncios.vue';
import { utilizadorService } from '@/api/utilizador';
import { anunciosService } from '@/api/anuncio';

export default {
    name: 'UserAnunciosView',
    components: {
        UserSidebar,
        AnuncioList,
        UserAnuncioDetails,
        UserAnuncioEdit,
        CreateAnuncio,
        UserConfirmCodeModal
    },
    data() {
        return {
            userDetails: null,
            anuncios: [],
            loading: true,
            error: null,
            selectedAnuncio: null,
            showEdit: false,
            showDetails: false,
            showCreate: false,
            showConfirmCodeModal: false,
            confirmCodeAnuncioId: null,
            currentPage: 1,
            totalPages: 1, // Add this line
            itemsPerPage: 9 // Add this line
        }
    },
    methods: {
        async fetchUserDetails() {
            try {
                const token = sessionStorage.getItem('token');
                if (!token) return this.$router.push('/login');
                const payload = JSON.parse(atob(token.split('.')[1]));
                this.userDetails = await utilizadorService.getUserDetails(payload.IdUtilizador);

                // Lê a página da query string
                let page = parseInt(this.$route.query.page) || 1;
                this.currentPage = page;

                // Se não existe ?page=... na URL, força para page=1
                if (!this.$route.query.page) {
                    this.$router.replace({ query: { ...this.$route.query, page: 1 } });
                    page = 1;
                }

                await this.fetchAnuncios(this.userDetails.IdUtilizador, page);
            } catch (error) {
                console.error('Erro ao carregar dados do usuário:', error);
                this.error = 'Erro ao carregar dados do usuário';
            }
        },
        async fetchAnuncios(userId = this.userDetails.IdUtilizador, page = 1) {
            try {
                this.loading = true;
                const response = await anunciosService.getUserAnuncios(userId, page, this.itemsPerPage);
                this.anuncios = response.data;
                this.currentPage = response.currentPage;   // <-- usa o valor do backend
                this.totalPages = response.totalPages;     // <-- usa o valor do backend
            } catch (error) {
                this.error = 'Erro ao carregar anúncios';
            } finally {
                this.loading = false;
            }
        },
        async deleteAnuncio(id) {
            if (confirm('Tem certeza que deseja excluir este anúncio?')) {
                try {
                    await anunciosService.deleteAnuncio(id);
                    this.anuncios = this.anuncios.filter(a => a.IdAnuncio !== id);
                } catch (error) {
                    console.error('Erro ao excluir anúncio:', error);
                    alert('Erro ao excluir anúncio');
                }
            }
        },
        openDetails(anuncio) {
            this.selectedAnuncio = anuncio;
            this.showDetails = true;
        },
        closeDetails() {
            this.selectedAnuncio = null;
            this.showDetails = false;
        },
        openCreateModal() {
            this.showCreate = true;
        },

        closeCreate() {
            this.showCreate = false;
        },
        openEditModal(anuncio) {
            this.selectedAnuncio = anuncio;
            this.showEdit = true;
        },
        closeEditModal() {
            this.selectedAnuncio = null;
            this.showEdit = false;
        },
        openConfirmCodeModal(anuncioId) {
            this.confirmCodeAnuncioId = anuncioId;
            this.showConfirmCodeModal = true;
        },
        closeConfirmCodeModal() {
            this.showConfirmCodeModal = false;
            this.confirmCodeAnuncioId = null;
        },
        goToPage(page) {
            if (page < 1 || page > this.totalPages) return;
            // Atualiza a query string do URL
            this.$router.push({ query: { ...this.$route.query, page } });
            // O watcher abaixo vai chamar fetchAnuncios com a página correta
        },
        async handleAnuncioCriado() {
            this.closeCreate();
            await this.fetchAnuncios(this.userDetails.IdUtilizador);
        },
        async handleAnuncioEditado() {
            this.closeEditModal();
            await this.fetchAnuncios(this.userDetails.IdUtilizador);
        },
        async handleCodeConfirmed() {
            this.closeConfirmCodeModal();
            await this.fetchAnuncios(this.userDetails.IdUtilizador);
        },
    },
    created() {
        this.fetchUserDetails();
    },


    watch: {
        '$route.query.page'(newPage) {
            const page = parseInt(newPage) || 1;
            if (page !== this.currentPage) {
                this.currentPage = page;
                if (this.userDetails) {
                    this.fetchAnuncios(this.userDetails.IdUtilizador, page);
                }
            }
        }
    }
}
</script>
<style scoped>
.anuncios-page {
    background-color: #f8f9fa;
}


.reservas-page {
    padding-top: 80px;
    min-height: 100vh;
    background-color: #f8f9fa;
}

.forms {
    margin-top: 20px;
}

h2 {
    color: #333;
    font-weight: 600;
}
</style>