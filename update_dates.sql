-- ============================================================
-- SQL Script: Atualizar DataRecolha e DataValidade para +1 Ano
-- ============================================================

-- Opção 1: Definir dinamicamente a DataRecolha e DataValidade de todos os anúncios ativos para +1 Ano a partir de hoje
UPDATE `anuncio`
SET `DataRecolha` = DATE_ADD(NOW(), INTERVAL 1 YEAR),
    `DataValidade` = DATE_ADD(NOW(), INTERVAL 1 YEAR)
WHERE `IdEstadoAnuncio` = 1;

-- Opção 2: Definir com datas fixas específicas (ex: final de 2027)
-- UPDATE `anuncio` 
-- SET `DataRecolha` = '2027-09-30 18:00:00',
--     `DataValidade` = '2027-12-31 23:59:59'
-- WHERE `IdEstadoAnuncio` = 1;
