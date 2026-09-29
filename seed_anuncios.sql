-- ============================================================
-- SQL Script: Limpeza e Inserção de Anúncios e Avaliações (Reviews)
-- Projeto: FoodShare
-- Compatible with TiDB / MySQL
-- ============================================================

-- 1. Desativar verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Limpar tabelas de avaliações e anúncios
TRUNCATE TABLE `avaliacao`;
DELETE FROM `anuncio`;

-- 3. Reativar verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;

-- 4. Inserir Anúncios (Ativos de Longa Durabilidade + Concluídos para Avaliações)

-- Anúncios Ativos (IdEstadoAnuncio = 1) com alta durabilidade (2026 / 2027)
INSERT INTO `anuncio` (`IdAnuncio`, `IdUtilizadorAnuncio`, `DataAnuncio`, `LocalRecolha`, `HorarioRecolha`, `Preco`, `IdEstadoAnuncio`, `Nome`, `Descricao`, `DataValidade`, `Quantidade`, `IdProdutoCategoria`, `ImagemAnuncio`, `CloudinaryId`) VALUES
(1, 1, NOW(), 'Porto - Aliados', '10:00 - 18:00', 5.50, 1, 'Cabaz de Legumes Biológicos Frescos', 'Cabaz com cenouras, curgetes, batatas doces e couves biológicas diretamente da horta local. Produtos frescos de longa durabilidade.', '2026-12-31 23:59:59', 10, 2, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589534/foodshare/products/legumes.jpg', 'foodshare/products/legumes'),
(2, 2, NOW(), 'Maia - Centro', '08:00 - 20:00', 2.00, 1, 'Pão de Sourdough / Massa Mãe Artesanal', 'Pão de fermentação natural de 48h, feito com farinhas integrais de moinho de pedra. Excelente preservação.', '2026-11-15 23:59:59', 15, 3, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg', 'foodshare/products/pao'),
(3, 60002, NOW(), 'Matosinhos - Sul', '14:00 - 19:00', 4.00, 1, 'Caixa de Fruta da Época (Maçãs e Peras)', 'Caixa de 3kg com maçãs Gala e peras Rocha frescas apanhadas na região. Duram várias semanas em bom estado.', '2027-01-30 23:59:59', 8, 2, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg', 'foodshare/products/fruta'),
(4, 30002, NOW(), 'Vila Nova de Gaia - Cais de Gaia', '12:00 - 15:00', 3.50, 1, 'Sopa Tradicional de Legumes e Abóbora', 'Sopa caseira reconfortante confeccionada diariamente com ingredientes 100% naturais sem conservantes.', '2026-10-31 23:59:59', 6, 1, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/sopa.jpg', 'foodshare/products/sopa'),
(5, 30003, NOW(), 'Gondomar - São Cosme', '09:00 - 17:00', 6.00, 1, 'Lote de Conservas Artesanais Variadas', 'Conjunto de conservas de peixe (sardinha e atum) em azeite virgem extra de alta qualidade. Longa durabilidade.', '2027-06-30 23:59:59', 12, 1, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589534/foodshare/products/legumes.jpg', 'foodshare/products/legumes'),
(6, 30004, NOW(), 'Porto - Paranhos (Pólo Universitário)', '11:00 - 20:00', 3.00, 1, 'Bolo Caseiro de Cenoura com Cobertura de Chocolate', 'Bolo caseiro acabado de fazer, embalado adequadamente para manter a frescura durante vários dias.', '2026-11-30 23:59:59', 5, 3, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg', 'foodshare/products/pao'),
(7, 30005, NOW(), 'Braga - Centro Histórico', '10:00 - 19:00', 4.50, 1, 'Cabaz Regional de Frutos Secos e Nozes', 'Nozes, amêndoas e avelãs nacionais selecionadas, ricas em nutrientes e com prazo de validade estendido.', '2027-05-15 23:59:59', 20, 2, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg', 'foodshare/products/fruta'),
(8, 60002, NOW(), 'Porto - Cedofeita', '13:00 - 18:00', 2.50, 1, 'Compota Caseira de Frutos Vermelhos 250g', 'Doce caseiro preparado com fruto natural e açúcar de cana biológico. Pote esterilizado e vedado hermeticamente.', '2027-04-30 23:59:59', 15, 1, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/sopa.jpg', 'foodshare/products/sopa'),

-- Anúncios Concluídos (IdEstadoAnuncio = 3) para suportar as avaliações (reviews)
(9, 30003, NOW() - INTERVAL 10 DAY, 'Maia - Centro', '10:00 - 18:00', 3.00, 3, 'Cabaz de Laranjas Doces do Algarve', 'Cabaz concluído com sucesso com fruta fresca e sumarenta.', '2026-10-15 23:59:59', 0, 2, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg', 'foodshare/products/fruta'),
(10, 30004, NOW() - INTERVAL 12 DAY, 'Porto - Boavista', '14:00 - 18:00', 4.00, 3, 'Pão de Centeio Tradicional', 'Lote de pão artesanal concluído e entregue com sucesso.', '2026-10-20 23:59:59', 0, 3, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg', 'foodshare/products/pao'),
(11, 60002, NOW() - INTERVAL 15 DAY, 'Porto - Baixa', '11:00 - 16:00', 5.00, 3, 'Azeite Virgem Extra Biológico 1L', 'Garrafa de azeite caseiro entregue e avaliada com excelência.', '2027-12-31 23:59:59', 0, 1, 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589534/foodshare/products/legumes.jpg', 'foodshare/products/legumes');

-- 5. Inserir Avaliações / Reviews associadas aos anúncios concluídos
INSERT INTO `avaliacao` (`IdAnuncio`, `IdAutor`, `IdAvaliado`, `Comentario`, `DataAvaliacao`, `Classificacao`) VALUES
(9, 30004, 30003, 'Fruta de excelente qualidade, super doce e atendimento pontual. Recomendo vivamente!', NOW() - INTERVAL 9 DAY, 5),
(9, 30002, 30003, 'Excelente comunicação e entrega rápida na hora combinada. Tudo impecável!', NOW() - INTERVAL 8 DAY, 5),
(10, 30006, 30004, 'O pão estava delicioso e muito fresco. Experiência de recolha muito positiva.', NOW() - INTERVAL 11 DAY, 4),
(10, 30005, 30004, 'Vendedora muito simpática e atenciosa. Quantidade generosa e ótimo sabor.', NOW() - INTERVAL 10 DAY, 5),
(11, 30007, 60002, 'Azeite caseiro espetacular, de grande qualidade! Transação simples e sem problemas.', NOW() - INTERVAL 14 DAY, 5),
(11, 1, 60002, 'Vendedor de confiança, super prestável na hora da recolha. Voltarei a comprar!', NOW() - INTERVAL 13 DAY, 5);
