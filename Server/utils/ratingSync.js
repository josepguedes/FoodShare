const db = require('../models/db');

/**
 * Recalculates and updates the Classificacao column for a specific user based on their reviews.
 * @param {number} userId - The IdUtilizador to recalculate rating for.
 */
const recalculateUserRating = async (userId) => {
    try {
        if (!userId) return;

        const result = await db.Avaliacao.findOne({
            where: { IdAvaliado: userId },
            attributes: [
                [db.sequelize.fn('AVG', db.sequelize.col('Classificacao')), 'mediaClassificacao']
            ]
        });

        const rawMedia = result ? result.getDataValue('mediaClassificacao') : null;
        const media = rawMedia !== null && rawMedia !== undefined ? parseFloat(rawMedia).toFixed(1) : 0;

        await db.Utilizador.update(
            { Classificacao: media },
            { where: { IdUtilizador: userId } }
        );

        return media;
    } catch (error) {
        console.error(`[RatingSync] Erro ao recalcular classificação do utilizador ${userId}:`, error);
        return 0;
    }
};

/**
 * Synchronizes ratings for ALL users in the database on server startup.
 */
const syncAllUserRatings = async () => {
    try {
        await db.sequelize.query(`
            UPDATE \`utilizador\` u 
            LEFT JOIN (
                SELECT \`IdAvaliado\`, AVG(\`Classificacao\`) AS media 
                FROM \`avaliacao\` 
                GROUP BY \`IdAvaliado\`
            ) a ON u.\`IdUtilizador\` = a.\`IdAvaliado\` 
            SET u.\`Classificacao\` = IFNULL(ROUND(a.media, 1), 0);
        `);
        console.log('[RatingSync] Classificação de todos os utilizadores sincronizada com sucesso.');
    } catch (error) {
        console.error('[RatingSync] Erro ao sincronizar classificações de utilizadores:', error);
    }
};

module.exports = { recalculateUserRating, syncAllUserRatings };
