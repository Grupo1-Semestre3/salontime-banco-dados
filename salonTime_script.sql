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

CREATE TABLE cupom (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    descricao VARCHAR(45),
    codigo VARCHAR(45),
    ativo TINYINT,
    inicio DATE,
    fim DATE,
    tipo_destinatario VARCHAR(45)
);

CREATE TABLE tipo_usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao varchar(45)
);

CREATE TABLE usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_usuario_id INT,
    nome VARCHAR(50),
    telefone CHAR(11),
    CPF CHAR(14),
    email VARCHAR(255),
    senha VARCHAR(30),
    login tinyint,
    foto longblob,
    data_nascimento Date,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativo tinyint default true,
    FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuario(id)
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

CREATE TABLE funcionario_competencia(
	id INT primary key auto_increment,
    funcionario_id INT,
    servico_id INT,
    FOREIGN KEY (servico_id) REFERENCES servico(id),
    FOREIGN KEY (funcionario_id) REFERENCES usuario(id)
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
    funcionario_id INT,
    servico_id INT,
    usuario_id INT,
    cupom_id INT,
    status_agendamento_id INT,
    pagamento_id INT,
    data DATE,
    inicio TIME,
    fim TIME,
    preco DECIMAL(10,2),
    FOREIGN KEY (funcionario_id) REFERENCES usuario(id),
    FOREIGN KEY (cupom_id) REFERENCES cupom(id),
    FOREIGN KEY (servico_id) REFERENCES servico(id),
    FOREIGN KEY (status_agendamento_id) REFERENCES status_agendamento(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (pagamento_id) REFERENCES pagamento(id)
);



CREATE TABLE historico_agendamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_horario DATETIME,
    agendamento_id INT,
    agendamento_funcionario_id INT,
    agendamento_servico_id INT,
    agendamento_usuario_id INT,
    agendamento_status_agendamento_id INT,   
    agendamento_pagamento_id INT,   
    taxa_utilizada DECIMAL(5,2),
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
    capacidade INT,
    funcionario_id INT,
    FOREIGN KEY (funcionario_id) REFERENCES usuario(id)
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
    capacidade INT,
	funcionario_id INT,
    FOREIGN KEY (funcionario_id) REFERENCES usuario(id)
);

CREATE TABLE cupom_configuracao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    intervalo_atendimento INT,
    porcentagem_desconto INT
);

CREATE TABLE avaliacao (
	id INT PRIMARY KEY auto_increment,
    agendamento_id INT,
    usuario_id INT,
    nota_servico INT,
    descricao_servico VARCHAR(255),
    data_horario DATETIME,
    FOREIGN KEY (agendamento_id) REFERENCES agendamento(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);


CREATE TABLE cupom_destinado (
    id INT PRIMARY KEY auto_increment,
    cupom_id INT,
    usuario_id INT,
    usado TINYINT,
    FOREIGN KEY (cupom_id) REFERENCES cupom(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE copum_configuracao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    intervalo_atendimento INT,
    porcentagem_desconto INT
);


INSERT INTO copum_configuracao (intervalo_atendimento, porcentagem_desconto)
VALUES (10, 10);




-- ----------------------------- TRIGGERS ------------------------
-- TRIGGERS corrigidas
DELIMITER //
CREATE TRIGGER trg_historico_agendamento
AFTER INSERT ON agendamento
FOR EACH ROW
BEGIN
    DECLARE v_taxa DECIMAL(5,2);

    SELECT taxa INTO v_taxa
    FROM pagamento
    WHERE id = NEW.pagamento_id;

    INSERT INTO historico_agendamento (
        data_horario,
        agendamento_id,
        agendamento_funcionario_id,
        agendamento_servico_id,
        agendamento_usuario_id,
        agendamento_status_agendamento_id,
        agendamento_pagamento_id,
        inicio,
        fim,
        preco,
        taxa_utilizada
    )
    VALUES (
        NOW(),
        NEW.id,
        NEW.funcionario_id,
        NEW.servico_id,
        NEW.usuario_id,
        NEW.status_agendamento_id,
        NEW.pagamento_id,
        NEW.inicio,
        NEW.fim,
        NEW.preco,
        v_taxa
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_historico_agendamento_update
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    DECLARE v_taxa DECIMAL(5,2);

    SELECT taxa INTO v_taxa
    FROM pagamento
    WHERE id = NEW.pagamento_id;

    INSERT INTO historico_agendamento (
        data_horario,
        agendamento_id,
        agendamento_funcionario_id,
        agendamento_servico_id,
        agendamento_usuario_id,
        agendamento_status_agendamento_id,
        agendamento_pagamento_id,
        inicio,
        fim,
        preco,
        taxa_utilizada
    )
    VALUES (
        NOW(),
        NEW.id,
        NEW.funcionario_id,
        NEW.servico_id,
        NEW.usuario_id,
        NEW.status_agendamento_id,
        NEW.pagamento_id,
        NEW.inicio,
        NEW.fim,
        NEW.preco,
        v_taxa
    );
END;
//
DELIMITER ;


-- DADOS INICIAIS


INSERT INTO status_agendamento (status) VALUES 
('AGENDADO'), 
('CANCELADO'), 
('AUSENTE'), 
('PAGAMENTO_PENDENTE'),
('CONCLUIDO');

INSERT INTO tipo_usuario (descricao) VALUES 
('ADMINISTRADOR'), 
('CLIENTE'), 
('FUNCIONARIO');

-- ADMIN
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento) 
VALUES 
(1, 'Admin Master', '11999999999', '00000000000', 'admin@salontime.com', 'admin123', 1, NULL, '1980-01-01');

-- FUNCIONÁRIOS
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento) 
VALUES  
(3, 'Joana Souza', '11988887777', '12345678900', 'joana@salontime.com', 'joana123', 0, NULL, '1990-05-15'),
(3, 'Carlos Mendes', '11977776666', '23456789001', 'carlos@salontime.com', 'carlos123', 0, NULL, '1985-09-30');

-- CLIENTES
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento) 
VALUES  
(2, 'Maria Clara', '11966665555', '34567890123', 'maria@cliente.com', 'maria123', 0, NULL, '1995-12-20'),
(2, 'Lucas Lima', '11955554444', '45678901234', 'lucas@cliente.com', 'lucas123', 0, NULL, '2000-03-10');

INSERT INTO funcionamento (dia_semana, inicio, fim, aberto, capacidade, funcionario_id) VALUES
('TUESDAY', '10:00:00', '19:00:00', 1, 1, 1),
('WEDNESDAY', '10:00:00', '19:00:00', 1, 1, 1),
('THURSDAY', '10:00:00', '19:00:00', 1, 1, 1),
('FRIDAY', '10:00:00', '19:00:00', 1, 1, 1),
('SATURDAY', '10:00:00', '19:00:00', 1, 1, 1),
('SUNDAY', NULL, NULL, 0, NULL, 1),
('MONDAY', NULL, NULL, 0, NULL, 1);

INSERT INTO servico (nome, preco, tempo, status, simultaneo, descricao, foto)
VALUES 
('Corte Feminino', 70.00, '00:45:00', 'ATIVO', 1, 'Corte feminino completo', NULL),
('Corte Masculino', 50.00, '00:30:00', 'ATIVO', 1, 'Corte masculino tradicional', NULL),
('Manicure', 40.00, '00:40:00', 'ATIVO', 0, 'Serviço de manicure', NULL),
('Luzes top', 40.00, '02:00:00', 'ATIVO', 0, 'Serviço de manicure', NULL);

INSERT INTO pagamento (forma, taxa)
VALUES 
('Dinheiro', 0.00),
('Cartão de Crédito', 3.50),
('Pix', 0.00);

-- Joana faz Corte Feminino e Manicure
INSERT INTO funcionario_competencia (funcionario_id, servico_id)
VALUES 
(2, 1), 
(2, 3);

-- Carlos faz Corte Masculino
INSERT INTO funcionario_competencia (funcionario_id, servico_id)
VALUES 
(3, 2);


INSERT INTO funcionario_competencia (funcionario_id, servico_id)
VALUES 
(2, 2);

-- Maria Clara agendou Corte Feminino com Joana
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES (2, 1, 4, 1, 1, '2025-05-20', '14:00:00', '14:45:00', 70.00);

-- Maria Clara agendou Corte Feminino com Joana
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES (1, 1, 4, 1, 1, '2025-05-20', '10:00:00', '11:00:00', 70.00);


-- Lucas Lima agendou Corte Masculino com Carlos
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES (3, 2, 5, 1, 2, '2025-05-21', '15:00:00', '15:30:00', 50.00);

-- Lucas Lima agendou Corte Masculino com Carlos
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES (3, 2, 4, 1, 2, '2025-05-27', '15:00:00', '15:30:00', 50.00);

update agendamento set status_agendamento_id = 2 where id =3;

INSERT INTO avaliacao (agendamento_id, usuario_id, nota_servico, descricao_servico, data_horario)
VALUES 
(1, 4, 5, 'Excelente atendimento e corte impecável!', NOW()),
(2, 5, 4, 'Bom serviço, mas poderia ser mais rápido.', NOW());


-- Simulando cancelamento futuro
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES (2, 3, 4, 2, 1, '2025-06-26', '16:00:00', '16:40:00', 40.00);

INSERT INTO desc_cancelamento (descricao, agendamento_id)
VALUES ('Cliente teve imprevisto no trabalho', 3);

INSERT INTO info_salao (email, telefone, logradouro, numero, cidade, estado, complemento) 
VALUES ('contato@salaoexemplo.com', '11987654321', 'Rua das Flores', '123', 'São Paulo', 'SP', 'Próximo ao metrô');

select * from funcionario_competencia;

update funcionario_competencia set funcionario_id = 1 where funcionario_id = 2;


INSERT INTO cupom (nome, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Desconto Black Friday', 'Desconto de 30% na Black Friday', 'BLACK30', 1, '2025-11-25', '2025-11-30', 'clientes');

INSERT INTO cupom (nome, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Frete Grátis', 'Frete grátis para compras acima de R$100', 'FRETEGRATIS', 1, '2025-05-01', '2025-06-01', 'todos');

INSERT INTO cupom (nome, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Desconto Aniversário', '20% para aniversariantes do mês', 'ANIV20', 1, '2025-01-01', '2025-12-31', 'clientes');

INSERT INTO cupom (nome, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Desconto Funcionários', '50% exclusivo para funcionários', 'FUNC50', 1, '2025-01-01', '2025-12-31', 'funcionarios');

INSERT INTO cupom (nome, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Promoção Verão', '10% em toda loja no verão', 'VERAO10', 0, '2025-12-01', '2026-02-28', 'todos');

INSERT INTO cupom_destinado (cupom_id, usuario_id, usado) 
VALUES 
(1, 1, 0),
(2, 2, 1),
(3, 2, 0);

INSERT INTO cupom_configuracao (intervalo_atendimento, porcentagem_desconto) VALUES (10, 10);

select * from  agendamento;

SELECT 
    s.id,
    s.nome,
    s.preco,
    s.tempo,
    s.status,
    s.simultaneo,
    s.descricao,
    s.foto,
    AVG(a.nota_servico) AS media_nota
FROM 
    servico s
LEFT JOIN 
    agendamento ag ON s.id = ag.servico_id
LEFT JOIN 
    avaliacao a ON ag.id = a.agendamento_id
WHERE 
    s.status = 'ATIVO'
GROUP BY 
    s.id, s.nome, s.preco, s.tempo, s.status, s.simultaneo, s.descricao, s.foto;


    
    SELECT * FROM agendamento WHERE status_agendamento_id = 2 ORDER BY data ASC, inicio ASC;
select * from agendamento;


select * from usuario;

SELECT * FROM agendamento WHERE (data < CURDATE() AND usuario_id = 4) OR (data = CURDATE() AND inicio < CURTIME()) ORDER BY data ASC, inicio ASC;	

select * from agendamento;

SELECT inicio, fim
FROM agendamento
WHERE data = '2025-05-20';

SELECT 
    a.inicio, 
    a.fim,
    (SELECT f.capacidade 
     FROM funcionamento f 
     WHERE f.funcionario_id = a.funcionario_id 
     LIMIT 1) AS capacidade
FROM 
    agendamento a
WHERE 
    a.data = '2025-05-20';


-- -------------------------- VIEW ----------------------------


-- KPIS DE ATENDIMENTOS, FATURAMENTO E ATENDIMENTOS CANCELADOS

CREATE VIEW vw_agendamentos_mensal AS
SELECT 
    YEAR(data_horario) AS ano,
    MONTH(data_horario) AS mes,
    COUNT(*) AS total_agendamentos,
    SUM(preco) AS faturamento_total,
    SUM(CASE WHEN agendamento_status_agendamento_id = 2 THEN 1 ELSE 0 END) AS total_cancelados
FROM 
    historico_agendamento
GROUP BY 
    YEAR(data_horario),
    MONTH(data_horario)
ORDER BY
    ano,
    mes;
    
select * from vw_agendamentos_mensal;


-- KPI DE USUARIO CADASTRADOS

CREATE VIEW vw_cadastros_mensais_usuarios AS
SELECT 
    YEAR(data_criacao) AS ano,
    MONTH(data_criacao) AS mes,
    COUNT(*) AS total_cadastros
FROM 
    usuario
GROUP BY 
    YEAR(data_criacao),
    MONTH(data_criacao)
ORDER BY 
    ano,
    mes;
    
select * from  vw_cadastros_mensais_usuarios;



-- GRÁFICO QTD ATENDIMENTO POR MES

CREATE TABLE calendario_2025 (
  dia DATE PRIMARY KEY
);

-- Inserindo de 2025-01-01 até 2025-12-31
INSERT INTO calendario_2025 (dia)
SELECT DATE('2025-01-01') + INTERVAL seq DAY
FROM (
  SELECT a + b * 10 AS seq
  FROM (
    SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
  ) AS unidades,
  (
    SELECT 0 b UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
    UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
    UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
    UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
    UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
    UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34
    UNION ALL SELECT 35
  ) AS dezenas
  WHERE a + b * 10 <= 364
) AS dias;

CREATE VIEW atendimentos_por_dia AS
SELECT 
  c.dia,
  COUNT(h.id) AS total_atendimentos
FROM calendario_2025 c
LEFT JOIN historico_agendamento h
  ON DATE(h.data_horario) = c.dia
GROUP BY c.dia
ORDER BY c.dia;

SELECT * FROM atendimentos_por_dia;

-- GRÁFICO DE ATENDIMENTO POR SERVIÇO

CREATE VIEW view_atendimentos_por_servico_mes AS
SELECT
    DATE_FORMAT(h.data_horario, '%Y-%m') AS mes,
    s.id AS servico_id,
    s.nome AS nome_servico,
    COUNT(*) AS quantidade_atendimentos
FROM
    historico_agendamento h
JOIN
    servico s ON h.agendamento_servico_id = s.id
WHERE
    s.status = 'ATIVO'
GROUP BY
    DATE_FORMAT(h.data_horario, '%Y-%m'),
    s.id,
    s.nome
ORDER BY
    mes, nome_servico;
    
    select * from view_atendimentos_por_servico_mes;

SELECT * FROM agendamento WHERE ((data > CURDATE()) OR (data = CURDATE() AND inicio > CURTIME())) AND usuario_id = 2 ORDER BY data ASC, inicio ASC LIMIT 1;
SELECT * FROM historico_agendamento;
SELECT * FROM agendamento;
SELECT * FROM agendamento WHERE funcionario_id = 2;
