-- ============================================================
-- SQL Script: Limpeza e Inserção de Novos Anúncios (Com Alta Durabilidade)
-- Projeto: FoodShare
-- ============================================================

-- 1. Desativar restrições de chave estrangeira temporariamente
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Limpar todos os anúncios existentes e resetar auto_increment
DELETE FROM `anuncio`;
ALTER TABLE `anuncio` AUTO_INCREMENT = 1;

-- 3. Reativar restrições de chave estrangeira
SET FOREIGN_KEY_CHECKS = 1;

-- 4. Inserir novos anúncios com datas de validade estendidas (Alta Durabilidade)
INSERT INTO `anuncio` (
    `IdUtilizadorAnuncio`, 
    `DataAnuncio`, 
    `LocalRecolha`, 
    `HorarioRecolha`, 
    `Preco`, 
    `IdEstadoAnuncio`, 
    `Nome`, 
    `Descricao`, 
    `DataValidade`, 
    `Quantidade`, 
    `IdProdutoCategoria`, 
    `ImagemAnuncio`, 
    `CloudinaryId`
) VALUES 
(
    1, 
    NOW(), 
    'Porto - Aliados', 
    '10:00 - 18:00', 
    5.50, 
    1, 
    'Cabaz de Legumes Biológicos Frescos', 
    'Cabaz com cenouras, curgetes, batatas doces e couves biológicas diretamente da horta local. Produtos frescos e de excelente qualidade.', 
    '2026-12-31 23:59:59', 
    10, 
    2, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589534/foodshare/products/legumes.jpg', 
    'foodshare/products/legumes'
),
(
    2, 
    NOW(), 
    'Maia - Centro', 
    '08:00 - 20:00', 
    2.00, 
    1, 
    'Pão de Sourdough / Massa Mãe Artesanal', 
    'Pão de fermentação natural de 48h, feito com farinhas integrais de moinho de pedra. Elevada durabilidade.', 
    '2026-11-15 23:59:59', 
    15, 
    3, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg', 
    'foodshare/products/pao'
),
(
    60002, 
    NOW(), 
    'Matosinhos - Sul', 
    '14:00 - 19:00', 
    4.00, 
    1, 
    'Caixa de Fruta da Época (Maçãs e Peras)', 
    'Caixa de 3kg com maçãs Gala e peras Rocha frescas apanhadas na região. Excelentes para lanches e sumos.', 
    '2027-01-30 23:59:59', 
    8, 
    2, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg', 
    'foodshare/products/fruta'
),
(
    30002, 
    NOW(), 
    'Vila Nova de Gaia - Cais de Gaia', 
    '12:00 - 15:00', 
    3.50, 
    1, 
    'Sopa Tradicional de Legumes e Abóbora', 
    'Sopa caseira reconfortante confeccionada diariamente com ingredientes 100% naturais sem conservantes.', 
    '2026-10-31 23:59:59', 
    6, 
    1, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/sopa.jpg', 
    'foodshare/products/sopa'
),
(
    30003, 
    NOW(), 
    'Gondomar - São Cosme', 
    '09:00 - 17:00', 
    6.00, 
    1, 
    'Lote de Conservas Artesanais Variadas', 
    'Conjunto de conservas de peixe (sardinha e atum) em azeite virgem extra de alta qualidade. Longa validade.', 
    '2027-06-30 23:59:59', 
    12, 
    1, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589534/foodshare/products/legumes.jpg', 
    'foodshare/products/legumes'
),
(
    30004, 
    NOW(), 
    'Porto - Paranhos (Pólo Universitário)', 
    '11:00 - 20:00', 
    3.00, 
    1, 
    'Bolo Caseiro de Cenoura com Cobertura de Chocolate', 
    'Bolo caseiro acabado de fazer, embalado adequadamente para manter a frescura durante vários dias.', 
    '2026-11-30 23:59:59', 
    5, 
    3, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg', 
    'foodshare/products/pao'
),
(
    30005, 
    NOW(), 
    'Braga - Centro Histórico', 
    '10:00 - 19:00', 
    4.50, 
    1, 
    'Cabaz Regional de Frutos Secos e Nozes', 
    'Nozes, amêndoas e avelãs nacionais selecionadas, ricas em nutrientes e com prazo de validade estendido.', 
    '2027-05-15 23:59:59', 
    20, 
    2, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg', 
    'foodshare/products/fruta'
),
(
    60002, 
    NOW(), 
    'Porto - Cedofeita', 
    '13:00 - 18:00', 
    2.50, 
    1, 
    'Compota Caseira de Frutos Vermelhos 250g', 
    'Doce caseiro preparado com fruto natural e açúcar de cana biológico. Pote esterilizado e vedado hermeticamente.', 
    '2027-04-30 23:59:59', 
    15, 
    1, 
    'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/sopa.jpg', 
    'foodshare/products/sopa'
);
