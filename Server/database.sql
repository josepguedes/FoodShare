CREATE DATABASE IF NOT EXISTS foodshare
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE foodshare;

CREATE TABLE IF NOT EXISTS utilizador (
  IdUtilizador INT NOT NULL AUTO_INCREMENT,
  IdEndereco INT NULL,
  Nome VARCHAR(255) NOT NULL,
  Nif INT NULL,
  DataNascimento DATETIME NULL,
  Email VARCHAR(255) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  DataRegisto DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Classificacao DECIMAL(3,1) NULL DEFAULT 0,
  Funcao VARCHAR(255) NOT NULL DEFAULT 'user',
  ImagemPerfil VARCHAR(255) NULL,
  CloudinaryId VARCHAR(255) NULL,
  PRIMARY KEY (IdUtilizador),
  UNIQUE KEY uq_utilizador_email (Email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS estadoanuncio (
  IdEstadoAnuncio INT NOT NULL AUTO_INCREMENT,
  EstadoAnuncio VARCHAR(255) NOT NULL,
  PRIMARY KEY (IdEstadoAnuncio),
  UNIQUE KEY uq_estadoanuncio_nome (EstadoAnuncio)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produtocategoria (
  IdProdutoCategoria INT NOT NULL AUTO_INCREMENT,
  NomeCategoria VARCHAR(255) NOT NULL,
  PRIMARY KEY (IdProdutoCategoria),
  UNIQUE KEY uq_produtocategoria_nome (NomeCategoria)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS anuncio (
  IdAnuncio INT NOT NULL AUTO_INCREMENT,
  IdUtilizadorAnuncio INT NOT NULL,
  IdUtilizadorReserva INT NULL,
  DataAnuncio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  LocalRecolha VARCHAR(255) NOT NULL,
  HorarioRecolha VARCHAR(255) NOT NULL,
  Preco DECIMAL(10,2) NOT NULL,
  DataRecolha DATETIME NULL,
  IdEstadoAnuncio INT NOT NULL,
  Nome VARCHAR(255) NOT NULL,
  Descricao TEXT NULL,
  DataValidade DATETIME NOT NULL,
  Quantidade INT NOT NULL,
  IdProdutoCategoria INT NOT NULL,
  DataReserva DATETIME NULL,
  ImagemAnuncio VARCHAR(255) NULL,
  CodigoVerificacao VARCHAR(255) NULL,
  CloudinaryId VARCHAR(255) NULL,
  PRIMARY KEY (IdAnuncio),
  KEY idx_anuncio_utilizador (IdUtilizadorAnuncio),
  KEY idx_anuncio_reserva (IdUtilizadorReserva),
  KEY idx_anuncio_estado (IdEstadoAnuncio),
  KEY idx_anuncio_categoria (IdProdutoCategoria),
  CONSTRAINT fk_anuncio_utilizador
    FOREIGN KEY (IdUtilizadorAnuncio) REFERENCES utilizador (IdUtilizador),
  CONSTRAINT fk_anuncio_reserva
    FOREIGN KEY (IdUtilizadorReserva) REFERENCES utilizador (IdUtilizador),
  CONSTRAINT fk_anuncio_estado
    FOREIGN KEY (IdEstadoAnuncio) REFERENCES estadoanuncio (IdEstadoAnuncio),
  CONSTRAINT fk_anuncio_categoria
    FOREIGN KEY (IdProdutoCategoria) REFERENCES produtocategoria (IdProdutoCategoria)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS avaliacao (
  IdAvaliacao INT NOT NULL AUTO_INCREMENT,
  IdAnuncio INT NOT NULL,
  IdAutor INT NOT NULL,
  IdAvaliado INT NOT NULL,
  Comentario VARCHAR(255) NOT NULL,
  DataAvaliacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Classificacao INT NOT NULL,
  PRIMARY KEY (IdAvaliacao),
  KEY idx_avaliacao_anuncio (IdAnuncio),
  KEY idx_avaliacao_autor (IdAutor),
  KEY idx_avaliacao_avaliado (IdAvaliado),
  CONSTRAINT fk_avaliacao_anuncio
    FOREIGN KEY (IdAnuncio) REFERENCES anuncio (IdAnuncio),
  CONSTRAINT fk_avaliacao_autor
    FOREIGN KEY (IdAutor) REFERENCES utilizador (IdUtilizador),
  CONSTRAINT fk_avaliacao_avaliado
    FOREIGN KEY (IdAvaliado) REFERENCES utilizador (IdUtilizador)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS denuncia (
  IdDenuncia INT NOT NULL AUTO_INCREMENT,
  IdAnuncio INT NULL,
  IdUtilizadorDenunciado INT NOT NULL,
  DataDenuncia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Motivo VARCHAR(255) NOT NULL,
  PRIMARY KEY (IdDenuncia),
  KEY idx_denuncia_anuncio (IdAnuncio),
  KEY idx_denuncia_utilizador (IdUtilizadorDenunciado),
  CONSTRAINT fk_denuncia_anuncio
    FOREIGN KEY (IdAnuncio) REFERENCES anuncio (IdAnuncio),
  CONSTRAINT fk_denuncia_utilizador
    FOREIGN KEY (IdUtilizadorDenunciado) REFERENCES utilizador (IdUtilizador)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS mensagem (
  IdMensagem INT NOT NULL AUTO_INCREMENT,
  IdRemetente INT NOT NULL,
  IdDestinatario INT NOT NULL,
  Conteudo VARCHAR(255) NOT NULL,
  DataEnvio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  HoraEnvio TIME NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (IdMensagem),
  KEY idx_mensagem_remetente (IdRemetente),
  KEY idx_mensagem_destinatario (IdDestinatario),
  CONSTRAINT fk_mensagem_remetente
    FOREIGN KEY (IdRemetente) REFERENCES utilizador (IdUtilizador),
  CONSTRAINT fk_mensagem_destinatario
    FOREIGN KEY (IdDestinatario) REFERENCES utilizador (IdUtilizador)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notificacao (
  IdNotificacao INT NOT NULL AUTO_INCREMENT,
  Mensagem VARCHAR(255) NOT NULL,
  DataNotificacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  HoraNotificacao TIME NOT NULL DEFAULT '00:00:00',
  IdRecipiente INT NULL,
  PRIMARY KEY (IdNotificacao),
  KEY idx_notificacao_recipiente (IdRecipiente),
  CONSTRAINT fk_notificacao_recipiente
    FOREIGN KEY (IdRecipiente) REFERENCES utilizador (IdUtilizador)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS NotificacaoUtilizador (
  IdNotificacaoUtilizador INT NOT NULL AUTO_INCREMENT,
  IdUtilizador INT NOT NULL,
  IdNotificacao INT NOT NULL,
  DataRececao DATETIME NULL,
  NotificacaoLida BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (IdNotificacaoUtilizador),
  UNIQUE KEY uq_notificacao_utilizador (IdUtilizador, IdNotificacao),
  KEY idx_notificacao_utilizador_notificacao (IdNotificacao),
  CONSTRAINT fk_notificacao_utilizador_utilizador
    FOREIGN KEY (IdUtilizador) REFERENCES utilizador (IdUtilizador),
  CONSTRAINT fk_notificacao_utilizador_notificacao
    FOREIGN KEY (IdNotificacao) REFERENCES notificacao (IdNotificacao)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS utilizadores_bloqueados (
  IdUtilizadoresBloqueados INT NOT NULL AUTO_INCREMENT,
  IdBloqueador INT NOT NULL,
  IdBloqueado INT NOT NULL,
  DataBloqueio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (IdUtilizadoresBloqueados),
  UNIQUE KEY uq_utilizadores_bloqueados (IdBloqueador, IdBloqueado),
  KEY idx_bloqueio_bloqueado (IdBloqueado),
  CONSTRAINT fk_utilizadores_bloqueados_bloqueador
    FOREIGN KEY (IdBloqueador) REFERENCES utilizador (IdUtilizador),
  CONSTRAINT fk_utilizadores_bloqueados_bloqueado
    FOREIGN KEY (IdBloqueado) REFERENCES utilizador (IdUtilizador)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS admin_bloqueados (
  IdAdminBloqueados INT NOT NULL AUTO_INCREMENT,
  IdBloqueado INT NOT NULL,
  DataBloqueio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  DataFimBloqueio DATETIME NULL,
  PRIMARY KEY (IdAdminBloqueados),
  KEY idx_admin_bloqueio_utilizador (IdBloqueado),
  CONSTRAINT fk_admin_bloqueio_utilizador
    FOREIGN KEY (IdBloqueado) REFERENCES utilizador (IdUtilizador)
) ENGINE=InnoDB;

INSERT IGNORE INTO estadoanuncio (IdEstadoAnuncio, EstadoAnuncio)
VALUES (1, 'Disponível'), (2, 'Reservado'), (3, 'Concluído');

INSERT IGNORE INTO produtocategoria (NomeCategoria)
VALUES ('Outros'), ('Frutas e Legumes'), ('Padaria');

-- Dados de demonstração. Password para ambos: demo1234
INSERT IGNORE INTO utilizador
  (IdUtilizador, Nome, Email, Password, Funcao, ImagemPerfil, CloudinaryId)
VALUES
  (1, 'Inês Martins', 'demo@foodshare.local', '$2b$10$yK9nVRo/uH04mkM3vPye.u0153UVJyd6DarTStWH30TFfJL9YImLC', 'user', 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589449/foodshare/demo/foodshare/demo/ines-martins.jpg', 'foodshare/demo/foodshare/demo/ines-martins'),
  (2, 'Miguel Sousa', 'admin@foodshare.local', '$2b$10$yK9nVRo/uH04mkM3vPye.u0153UVJyd6DarTStWH30TFfJL9YImLC', 'admin', 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589449/foodshare/demo/foodshare/demo/miguel-sousa.jpg', 'foodshare/demo/foodshare/demo/miguel-sousa');

UPDATE utilizador
SET Nome = 'Inês Martins',
    ImagemPerfil = 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589449/foodshare/demo/foodshare/demo/ines-martins.jpg',
    CloudinaryId = 'foodshare/demo/foodshare/demo/ines-martins'
WHERE IdUtilizador = 1;

UPDATE utilizador
SET Nome = 'Miguel Sousa',
  ImagemPerfil = 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589449/foodshare/demo/foodshare/demo/miguel-sousa.jpg',
    CloudinaryId = 'foodshare/demo/foodshare/demo/miguel-sousa'
WHERE IdUtilizador = 2;

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria)
SELECT 1, CURRENT_TIMESTAMP, 'Porto', '18:00 - 20:00', 2.50,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Cabaz de legumes frescos',
       'Legumes frescos para partilhar.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 DAY), 3, 2
WHERE NOT EXISTS (
  SELECT 1 FROM anuncio WHERE IdUtilizadorAnuncio = 1
    AND Nome = 'Cabaz de legumes frescos'
);

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria)
SELECT 1, CURRENT_TIMESTAMP, 'Matosinhos', '12:00 - 14:00', 1.50,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 1,
       'Pao artesanal',
       'Pao artesanal acabado de fazer.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 5, 3
WHERE NOT EXISTS (
  SELECT 1 FROM anuncio WHERE IdUtilizadorAnuncio = 1
    AND Nome = 'Pao artesanal'
);

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria)
SELECT 2, CURRENT_TIMESTAMP, 'Vila Nova de Gaia', '17:30 - 19:00', 3.00,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Fruta da epoca',
       'Selecao de fruta da epoca em bom estado.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 4 DAY), 4, 2
WHERE NOT EXISTS (
  SELECT 1 FROM anuncio WHERE IdUtilizadorAnuncio = 2
    AND Nome = 'Fruta da epoca'
);

UPDATE anuncio
SET ImagemAnuncio = 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589534/foodshare/products/legumes.jpg',
    CloudinaryId = 'foodshare/products/legumes'
WHERE Nome = 'Cabaz de legumes frescos';

UPDATE anuncio
SET ImagemAnuncio = 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg',
    CloudinaryId = 'foodshare/products/pao'
WHERE Nome = 'Pao artesanal';

UPDATE anuncio
SET ImagemAnuncio = 'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg',
    CloudinaryId = 'foodshare/products/fruta'
WHERE Nome = 'Fruta da epoca';

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 2, CURRENT_TIMESTAMP, 'Porto', '19:00 - 20:30', 2.00,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Sopa caseira de legumes', 'Sopa caseira preparada com legumes frescos.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 6, 1,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/sopa.jpg',
       'foodshare/products/sopa'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Sopa caseira de legumes');

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 1, CURRENT_TIMESTAMP, 'Matosinhos', '10:00 - 12:00', 2.75,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Morangos frescos', 'Morangos doces e frescos, acabados de colher.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 4, 2,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589537/foodshare/products/morangos.jpg',
       'foodshare/products/morangos'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Morangos frescos');

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 2, CURRENT_TIMESTAMP, 'Vila Nova de Gaia', '15:00 - 17:00', 1.80,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 1,
       'Bolachas caseiras', 'Bolachas caseiras crocantes para acompanhar o cafe.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 5 DAY), 8, 3,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589538/foodshare/products/bolachas.jpg',
       'foodshare/products/bolachas'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Bolachas caseiras');

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 1, CURRENT_TIMESTAMP, 'Porto', '12:30 - 14:00', 3.50,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Salada colorida', 'Salada fresca com legumes variados.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 3, 1,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589546/foodshare/products/salada.jpg',
       'foodshare/products/salada'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Salada colorida');

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 2, CURRENT_TIMESTAMP, 'Maia', '16:00 - 18:00', 4.00,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 1,
       'Bolo de chocolate', 'Bolo de chocolate caseiro, macio e fresco.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 4 DAY), 2, 3,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589540/foodshare/products/bolo.jpg',
       'foodshare/products/bolo'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Bolo de chocolate');

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 1, CURRENT_TIMESTAMP, 'Gondomar', '18:30 - 20:00', 2.25,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Cabaz de fruta variada', 'Fruta variada e pronta a consumir.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 DAY), 5, 2,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589536/foodshare/products/fruta.jpg',
       'foodshare/products/fruta'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Cabaz de fruta variada');

INSERT INTO anuncio
  (IdUtilizadorAnuncio, DataAnuncio, LocalRecolha, HorarioRecolha, Preco,
   DataRecolha, IdEstadoAnuncio, Nome, Descricao, DataValidade, Quantidade,
   IdProdutoCategoria, ImagemAnuncio, CloudinaryId)
SELECT 2, CURRENT_TIMESTAMP, 'Valongo', '11:00 - 13:00', 1.25,
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), 1,
       'Pao integral', 'Pao integral artesanal acabado de fazer.',
       DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 6, 3,
       'https://res.cloudinary.com/dxpqnq1og/image/upload/v1789589535/foodshare/products/pao.jpg',
       'foodshare/products/pao'
WHERE NOT EXISTS (SELECT 1 FROM anuncio WHERE Nome = 'Pao integral');