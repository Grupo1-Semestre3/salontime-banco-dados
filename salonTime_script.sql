create database salon_time;

-- drop database salon_time;

use salon_time;

show tables;

-- Criação das tabelas
CREATE TABLE info_salao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255),
    telefone VARCHAR(11),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    cidade VARCHAR(45),
    estado VARCHAR(45),
    complemento VARCHAR(45)
);

CREATE TABLE tipo_usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao varchar(45)
);

CREATE TABLE usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_tipo_usuario INT,
    nome VARCHAR(50),
    telefone CHAR(11),
    CPF CHAR(14),
    email VARCHAR(255),
    senha VARCHAR(30),
    login tinyint,
    FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario(id)
);

CREATE TABLE servico (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    preco DECIMAL(10,2),
    tempo TIME,
    status enum("ATIVO", "INATIVO"),
    simultaneo TINYINT,
    descricao varchar(255),
    foto longblob
);

CREATE TABLE status_agendamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status enum("AGENDADO","CANCELADO","AUSENTE","PAGAMENTO_PENDENTE","CONCLUIDO")
);

create table pagamento(
	id INT PRIMARY KEY AUTO_INCREMENT,
    forma varchar(50),
    taxa decimal(10,2)
);

CREATE TABLE agendamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_servico INT,
    fk_usuario INT,
    fk_status INT,
    fk_pagamento INT,
    data DATE,
    inicio TIME,
    fim TIME,
    preco DECIMAL(10,2),
    FOREIGN KEY (fk_servico) REFERENCES servico(id),
    FOREIGN KEY (fk_status) REFERENCES status_agendamento(id),
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id),
    FOREIGN KEY (fk_pagamento) REFERENCES pagamento(id)
);



CREATE TABLE historico_agendamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_horario DATETIME,
    agendamento_id INT,
    agendamento_fk_servico INT,
    agendamento_fk_usuario INT,
    agendamento_fk_status INT,   
    agendamento_fk_pagamento INT,   
    FOREIGN KEY (agendamento_id) REFERENCES agendamento(id),
    inicio time,
    fim time,
    preco decimal(10,2)
);

CREATE TABLE funcionamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dia_semana ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'),
    inicio TIME,
    fim TIME,
    aberto TINYINT,
    capacidade INT
);


CREATE TABLE desc_cancelamento(
	id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(200),
    agendamento_id INT,
    FOREIGN KEY (agendamento_id) REFERENCES agendamento(id)
);

CREATE TABLE horario_excecao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_inicio DATE,
    data_fim DATE,
    inicio TIME,
    fim TIME,
    aberto TINYINT,
    capacidade INT
);

CREATE TABLE avaliacao (
    fk_agendamento INT PRIMARY KEY,
    nota_servico INT,
    descricao_servico VARCHAR(255),
    data_horario DATETIME,
    FOREIGN KEY (fk_agendamento) REFERENCES agendamento(id)
);


-- ----------------------------- TRIGGERS ------------------------

DELIMITER //
CREATE TRIGGER trg_historico_agendamento
AFTER INSERT ON agendamento
FOR EACH ROW
BEGIN
    INSERT INTO historico_agendamento (
        data_horario,
        agendamento_id,
        agendamento_fk_servico,
        agendamento_fk_usuario,
        agendamento_fk_status,
        agendamento_fk_pagamento,
        inicio,
        fim,
        preco
    )
    VALUES (
        NOW(),
        NEW.id,
        NEW.fk_servico,
        NEW.fk_usuario,
        NEW.fk_status,
        NEW.fk_pagamento,
        NEW.inicio,
        NEW.fim,
        NEW.preco
    );
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_historico_agendamento_update
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    INSERT INTO historico_agendamento (
        data_horario,
        agendamento_id,
        agendamento_fk_servico,
        agendamento_fk_usuario,
        agendamento_fk_status,
        agendamento_fk_pagamento,
        inicio,
        fim,
        preco
    )
    VALUES (
        NOW(),
        NEW.id,
        NEW.fk_servico,
        NEW.fk_usuario,
        NEW.fk_status,
        NEW.fk_pagamento,
        NEW.inicio,
        NEW.fim,
        NEW.preco
    );
END//
DELIMITER ;




-- --------------- INSERTS -----------------

INSERT INTO funcionamento (dia_semana, inicio, fim, aberto, capacidade) VALUES
('TUESDAY', '10:00:00', '19:00:00', 1, 2),
('WEDNESDAY', '10:00:00', '19:00:00', 1, 2),
('THURSDAY', '10:00:00', '19:00:00', 1, 2),
('FRIDAY', '10:00:00', '19:00:00', 1, 2),
('SATURDAY', '10:00:00', '19:00:00', 1, 2),
('SUNDAY', NULL, NULL, 0, NULL),
('MONDAY', NULL, NULL, 0, NULL);


insert into status_agendamento (status) values ('AGENDADO'), ('CANCELADO'), ('AUSENTE'), ('PAGAMENTO_PENDENTE'),('CONCLUIDO');

-- Inserção de tipos de usuário
INSERT INTO tipo_usuario (descricao) VALUES ('Administrador'), ('Cliente');

-- Inserção de usuários (1 admin e 1 cliente)
INSERT INTO usuario (fk_tipo_usuario, nome, telefone, CPF, email, senha, login) VALUES
(1, 'Administrador do Salão', '11999999999', '000.000.000-00', 'admin@salao.com', 'admin123', 0),
(2, 'Cliente Exemplo', '11888888888', '111.111.111-11', 'cliente@exemplo.com', 'cliente123', 0);

-- Inserção de serviços
INSERT INTO servico (nome, preco, tempo, status, simultaneo) VALUES
('Corte de Cabelo', 50.00, '00:30:00', 'ATIVO', 0),
('Manicure', 40.00, '00:45:00', 'ATIVO', 1);

insert into pagamento (forma, taxa) values("Pix", 0);
insert into pagamento (forma, taxa) values("Credito", 0);

insert into agendamento (fk_servico, fk_usuario, fk_status, data, inicio, fim, preco) values (1, 1, 1, '2025-04-10', '10:00:00', '11:00:00', '1');




-- ------------------ TESTE TRIGGERS ----------------------

update agendamento set fk_status = 2  where id = 1;


-- -------------------- SELECTS --------------------------
select * from historico_agendamento;

select * from agendamento;

SELECT COUNT(*) > 0
FROM agendamento
WHERE data = '2025-04-10'
  AND (
    ('10:00:00' BETWEEN inicio AND fim)
    OR ('11:00:00' BETWEEN inicio AND fim)
    OR (inicio BETWEEN '10:00:00' AND '12:00:00')
  );
  
  select * from servico;
