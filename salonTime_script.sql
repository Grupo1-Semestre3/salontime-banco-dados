create database salon_time;

-- 	drop database salon_time;

use salon_time;

CREATE TABLE status_usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(45)
);

CREATE TABLE tipo_usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100)
);

CREATE TABLE usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_status_usuario INT,
    fk_tipo_usuario INT,
    nome VARCHAR(255),
    telefone CHAR(11),
    CPF CHAR(14),
    email VARCHAR(255),
    senha VARCHAR(255),
    FOREIGN KEY (fk_status_usuario) REFERENCES status_usuario(id),
    FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario(id)
);

CREATE TABLE horario_funcionamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_usuario INT,
    dia_semana ENUM('Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'),
    inicio TIME,
    fim TIME,
    aberto TINYINT,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id)
);

CREATE TABLE horario_excecao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_usuario INT,
    data_excecao DATE,
    inicio TIME,
    fim TIME,
    aberto TINYINT,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id)
);

CREATE TABLE servico (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    preco DECIMAL(10,2),
    tempo TIME,
    status VARCHAR(20)
);

CREATE TABLE status_agendamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status ENUM('Pendente', 'Confirmado', 'Cancelado', 'Concluído')
);

CREATE TABLE status_pagamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status ENUM('Pendente', 'Pago', 'Cancelado')
);

CREATE TABLE pagamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    forma VARCHAR(45),
    taxa DECIMAL(10,2)
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
    fk_funcionario INT,
    fk_status_pagamento INT,
    FOREIGN KEY (fk_servico) REFERENCES servico(id),
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id),
    FOREIGN KEY (fk_status) REFERENCES status_agendamento(id),
    FOREIGN KEY (fk_pagamento) REFERENCES pagamento(id),
    FOREIGN KEY (fk_status_pagamento) REFERENCES status_pagamento(id)
);

CREATE TABLE avaliacao (
    fk_agendamento INT,
    nota_servico INT,
    descricao_servico VARCHAR(255),
    data_horario DATETIME,
    PRIMARY KEY (fk_agendamento),
    FOREIGN KEY (fk_agendamento) REFERENCES agendamento(id)
);

CREATE TABLE historico_agendamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_agendamento INT,
    fk_pagamento INT,
    fk_status INT,
    preco_final DECIMAL(10,2),
    data_horario DATETIME,
    FOREIGN KEY (fk_agendamento) REFERENCES agendamento(id),
    FOREIGN KEY (fk_pagamento) REFERENCES pagamento(id),
    FOREIGN KEY (fk_status) REFERENCES status_agendamento(id)
);

-- Inserindo alguns registros
INSERT INTO status_usuario (status) VALUES ('Ativo'), ('Inativo');
INSERT INTO tipo_usuario (descricao) VALUES ('Cliente'), ('Administrador');
INSERT INTO usuario (fk_status_usuario, fk_tipo_usuario, nome, telefone, CPF, email, senha) 
VALUES (1, 1, 'João Silva', '11987654321', '123.456.789-00', 'joao@email.com', 'senha123');

INSERT INTO usuario (fk_status_usuario, fk_tipo_usuario, nome, telefone, CPF, email, senha) 
VALUES (1, 2, 'Marina Mota', '11987654321', '223.456.789-00', 'mamotta@email.com', 'senha123');

INSERT INTO servico (nome, preco, tempo, status) VALUES ('Corte de Cabelo', 50.00, '00:30:00', 'Disponível');

INSERT INTO status_agendamento (status) VALUES ('Pendente'), ('Confirmado');
INSERT INTO status_pagamento (status) VALUES ('Pendente'), ('Pago');
INSERT INTO pagamento (forma, taxa) VALUES ('Cartão de Crédito', 5.00);

INSERT INTO agendamento (fk_servico, fk_usuario, fk_status, fk_pagamento, data, inicio, fim, fk_funcionario, fk_status_pagamento)
VALUES (1, 1, 1, 1, '2024-04-10', '15:00:00', '15:30:00', 2, 1);



-- -------------------- TRIGGERS -------------

CREATE TRIGGER after_agendamento_insert
AFTER INSERT ON agendamento
FOR EACH ROW
INSERT INTO historico_agendamento (fk_agendamento, fk_pagamento, fk_status, preco_final, data_horario)
VALUES (NEW.id, NEW.fk_pagamento, NEW.fk_status, (SELECT preco FROM servico WHERE id = NEW.fk_servico), NOW());


DELIMITER $$

CREATE TRIGGER after_agendamento_update
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    IF OLD.fk_status <> NEW.fk_status THEN
        INSERT INTO historico_agendamento 
            (fk_agendamento, fk_pagamento, fk_status, preco_final, data_horario)
        VALUES 
            (NEW.id, NEW.fk_pagamento, NEW.fk_status, 
             (SELECT preco FROM servico WHERE id = NEW.fk_servico), 
             NOW());
    END IF;
END $$

DELIMITER ;



-- ---------------------- SELECTS ---------------


select * from agendamento;

select * from historico_agendamento;


-- ---------------- TESTE TRIGER UPDATE --------------


select * from agendamento;

UPDATE agendamento SET fk_status = 2 WHERE id = 3;
