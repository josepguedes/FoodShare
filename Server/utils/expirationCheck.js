const db = require('../models/db');
const { Op } = require('sequelize');

/**
 * Ensures all required status records exist in the `estadoanuncio` table to prevent foreign key errors.
 */
const ensureEstadoAnuncioExists = async () => {
    try {
        const defaultStates = [
            { IdEstadoAnuncio: 1, EstadoAnuncio: "Disponível" },
            { IdEstadoAnuncio: 2, EstadoAnuncio: "Reservado" },
            { IdEstadoAnuncio: 3, EstadoAnuncio: "Concluído" },
            { IdEstadoAnuncio: 4, EstadoAnuncio: "Cancelado" },
            { IdEstadoAnuncio: 5, EstadoAnuncio: "Expirado" },
            { IdEstadoAnuncio: 6, EstadoAnuncio: "Por Pagar" },
        ];

        for (const estado of defaultStates) {
            await db.EstadoAnuncio.findOrCreate({
                where: { IdEstadoAnuncio: estado.IdEstadoAnuncio },
                defaults: estado
            });
        }
    } catch (err) {
        console.error('[ExpirationCheck] Erro ao garantir estados de anúncio:', err);
    }
};

/**
 * Checks all active or reserved announcements to see if their expiration date (DataValidade) has passed.
 * If expired:
 * 1. Changes IdEstadoAnuncio to 5 ('Expirado').
 * 2. Creates a notification for the announcement owner.
 * 3. If reserved, notifies the user who reserved it.
 */
const checkAndExpireAnuncios = async () => {
    try {
        // Ensure status 5 ('Expirado') exists in DB to prevent foreign key constraints
        await ensureEstadoAnuncioExists();

        const now = new Date();

        // Find all announcements in state 1 (Ativo) or 2 (Reservado) with DataValidade before now
        const expiredAnuncios = await db.Anuncio.findAll({
            where: {
                IdEstadoAnuncio: { [Op.in]: [1, 2] },
                DataValidade: { [Op.lt]: now }
            }
        });

        if (!expiredAnuncios || expiredAnuncios.length === 0) {
            return 0;
        }

        console.log(`[ExpirationCheck] Encontrados ${expiredAnuncios.length} anúncios expirados.`);

        for (const anuncio of expiredAnuncios) {
            const estadoAnterior = anuncio.IdEstadoAnuncio;

            // 1. Update status to Expirado (5)
            await anuncio.update({ IdEstadoAnuncio: 5 });

            // 2. Create notification for the announcement owner
            const mensagemDono = `O seu anúncio "${anuncio.Nome}" (ID: ${anuncio.IdAnuncio}) expirou por ter atingido a data de validade (${new Date(anuncio.DataValidade).toLocaleDateString('pt-PT')}) e foi desativado.`;

            const notificacaoDono = await db.Notificacao.create({
                IdRecipiente: anuncio.IdUtilizadorAnuncio,
                Mensagem: mensagemDono,
                DataNotificacao: now,
                HoraNotificacao: now,
            });

            await db.NotificacaoUtilizador.create({
                IdNotificacao: notificacaoDono.IdNotificacao,
                IdUtilizador: anuncio.IdUtilizadorAnuncio,
                DataRececao: now,
                NotificacaoLida: false
            });

            // 3. If it was reserved (IdEstadoAnuncio === 2), notify the reservador as well
            if (estadoAnterior === 2 && anuncio.IdUtilizadorReserva) {
                const mensagemReservador = `O anúncio "${anuncio.Nome}" que tinha reservado expirou e a sua reserva foi cancelada.`;

                const notificacaoReservador = await db.Notificacao.create({
                    IdRecipiente: anuncio.IdUtilizadorReserva,
                    Mensagem: mensagemReservador,
                    DataNotificacao: now,
                    HoraNotificacao: now,
                });

                await db.NotificacaoUtilizador.create({
                    IdNotificacao: notificacaoReservador.IdNotificacao,
                    IdUtilizador: anuncio.IdUtilizadorReserva,
                    DataRececao: now,
                    NotificacaoLida: false
                });
            }
        }

        console.log(`[ExpirationCheck] ${expiredAnuncios.length} anúncios foram desativados por expiração e os respetivos utilizadores notificados.`);
        return expiredAnuncios.length;
    } catch (error) {
        console.error('[ExpirationCheck] Erro ao verificar e atualizar anúncios expirados:', error);
        return 0;
    }
};

module.exports = { checkAndExpireAnuncios };
