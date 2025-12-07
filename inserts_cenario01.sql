USE salon_time;

-- ==============================
--  STATUS AGENDAMENTO
-- ==============================
INSERT INTO status_agendamento (status) VALUES 
('AGENDADO'), 
('CANCELADO'), 
('AUSENTE'), 
('PAGAMENTO_PENDENTE'),
('CONCLUIDO');


-- ==============================
--  TIPO USUÁRIO
-- ==============================
INSERT INTO tipo_usuario (descricao) VALUES 
('ADMINISTRADOR'), 
('CLIENTE'), 
('FUNCIONARIO');

-- ==============================
--  INFO SALÃO
-- ==============================
INSERT INTO info_salao (email, telefone, logradouro, numero, cidade, estado, complemento)
VALUES (
    'contato@salontime.com',
    '11987654321',
    'R. Adamantina',
    '34',
    'São Bernardo do Campo',
    'SP',
    'apto 3'
);

-- ==============================
--  CLIENTES (30 clientes)
-- ==============================
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento)
VALUES
-- ADMIN & FUNCIONÁRIO
(1, 'Marina mota', '11911111111', '11111111111', 'marina@gmail.com', '123456', 0, NULL, '1992-05-14'),
(3, 'Anna Mello', '11911111112', '11111111112', 'anna@gmail.com', '123456', 0, NULL, '1992-05-14'),

-- CLIENTES ORIGINAIS (mantidos)
(2, 'Kauã Navarro', '11911111113', '11111111113', 'kaua.navarro@gmail.com', '123456', 0, NULL, '1992-05-14'),
(2, 'Maikon Douglas', '11922222222', '22222222222', 'maikon.douglas@gmail.com', '123456', 0, NULL, '1988-10-02'),
(2, 'Caio Acayaba', '11933333333', '33333333333', 'caio.acayaba@gmail.com', '123456', 0, NULL, '1995-08-21'),
(2, 'Elerson Sabará', '11944444444', '44444444444', 'elerson.sabara@gmail.com', '123456', 0, NULL, '1990-12-01');

-- ==============================
--  SERVIÇOS CORRIGIDOS (8)
-- ==============================
INSERT INTO servico (nome, preco, tempo, status, simultaneo, descricao)
VALUES
('Corte Feminino', 80.00, '00:45:00', 'ATIVO', 0,
 'Corte feminino completo com análise de formato do rosto, finalização com escova leve e orientações de manutenção para o dia a dia.'),

('Corte Masculino', 60.00, '00:30:00', 'ATIVO', 0,
 'Corte masculino moderno com técnicas de precisão, acabamento detalhado na navalha e finalização com produto modelador.'),

('Hidratação Capilar', 90.00, '01:00:00', 'ATIVO', 1,
 'Tratamento intenso para restauração dos fios, com máscaras profissionais, massagem capilar, vaporização e selagem de cutículas.'),

('Coloração', 250.00, '02:00:00', 'ATIVO', 1,
 'Coloração completa com escolha de tonalidade, aplicação uniforme, tratamento pós-química e finalização com secagem profissional.'),

('Mechas / Luzes', 200.00, '03:00:00', 'ATIVO', 1,
 'Técnicas personalizadas de iluminação, incluindo mechas, luzes ou balayage, com descoloração supervisionada e tonalização profissional.'),

('Dia de Noiva', 1000.00, '04:00:00', 'ATIVO', 0,
 'Pacote exclusivo para noivas, incluindo preparo da pele, penteado, maquiagem completa, finalização especial e suporte até a sessão de fotos.'),

('Escova Modeladora', 70.00, '00:50:00', 'ATIVO', 0,
 'Escova modeladora com definição de ondas, volume e movimento natural, utilizando técnicas térmicas avançadas.'),

('Penteado', 120.00, '01:00:00', 'ATIVO', 0,
 'Penteados sofisticados para eventos, casamentos e festas, com estilização personalizada e fixação de alta durabilidade.');


-- ==============================
--  FUNCIONÁRIA ADMIN COMPETENTE EM TODOS OS SERVIÇOS
-- ==============================
INSERT INTO funcionario_competencia (funcionario_id, servico_id)
VALUES
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),
(2, 1),(2, 2),(2, 3),(2, 4),(2, 5),(2, 6),(2, 7),(2, 8);

-- ==============================
-- CUPONS
-- ==============================
INSERT INTO cupom (nome, desconto, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES
('Beleza10', 10, '10% de desconto para todos', 'BELEZA10', 1, '2025-01-01', '2025-12-31', 'TODOS'),
('PrimeiraVez', 15, 'Desconto de boas-vindas', 'PRIMEIRA15', 1, '2025-01-01', '2025-12-31', 'TODOS');

INSERT INTO cupom_configuracao (intervalo_atendimento, porcentagem_desconto)
VALUES (5, 10);

-- ==============================
--  PAGAMENTO
-- ==============================
INSERT INTO pagamento (forma, taxa)
VALUES ('Dinheiro', 0), ('Crédito', 3.50), ('PIX', 0),  ('Débito', 0);

-- ==============================
--  AGENDAMENTOS – NOVEMBRO & DEZEMBRO 2025
-- ==============================

-- 20 agendamentos novembro
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, cupom_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES
-- CONCLUÍDOS
(1,1,3,NULL,5,1,'2025-11-02','10:00','10:45',80),
(1,3,4,NULL,5,3,'2025-11-03','14:00','15:00',90),
(1,2,5,NULL,5,1,'2025-11-05','09:00','09:30',60),
(1,8,6,NULL,5,3,'2025-11-06','11:00','12:00',120),
(1,4,3,NULL,5,1,'2025-11-10','13:00','15:00',150),

-- PENDENTES
(1,7,5,NULL,1,3,'2025-11-12','15:00','15:50',70),
(1,1,3,NULL,1,1,'2025-11-13','10:00','10:45',80),
(1,3,4,NULL,1,2,'2025-11-14','16:00','17:00',90),

-- AGENDADOS
(1,5,5,NULL,1,2,'2025-11-15','09:00','12:00',200),
(1,3,6,NULL,1,1,'2025-11-16','14:00','15:00',90),
(1,2,6,NULL,1,2,'2025-11-17','10:00','10:30',60),
(1,8,4,NULL,1,3,'2025-11-18','11:00','12:00',120),
(1,7,3,NULL,1,1,'2025-11-19','09:00','10:00',70),

-- CANCELADOS
(1,4,4,NULL,2,1,'2025-11-20','13:00','15:00',150),
(1,1,5,NULL,2,3,'2025-11-22','08:00','08:45',80),

-- AUSENTE
(1,3,6,NULL,3,1,'2025-11-23','15:00','16:00',90),

-- MAIS CONCLUÍDOS
(1,5,4,NULL,5,1,'2025-11-25','09:00','12:00',200),
(1,7,3,NULL,5,3,'2025-11-26','16:00','17:00',70),
(1,2,5,NULL,5,2,'2025-11-27','10:00','10:30',60),
(1,8,5,NULL,5,1,'2025-11-28','14:00','15:00',120);

-- 15 agendamentos dezembro
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, cupom_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES
-- CONCLUÍDOS
(1,1,6,NULL,5,1,'2025-12-02','10:00','10:45',80),
(1,3,5,NULL,5,3,'2025-12-02','11:00','12:00',90),
(1,7,4,NULL,5,1,'2025-12-03','09:00','10:00',70),
(1,8,3,NULL,5,2,'2025-12-04','13:00','14:00',120),

-- AGENDADOS
(1,4,3,NULL,1,1,'2025-12-13','14:00','16:00',150),
(1,3,5,NULL,1,1,'2025-12-12','10:00','11:00',90),

-- PENDENTES
(1,1,5,NULL,1,2,'2025-12-3','11:00','11:45',80),
(1,2,6,NULL,1,1,'2025-12-4','09:00','09:30',60),

-- CANCELADOS
(1,7,3,NULL,2,3,'2025-12-12','15:00','16:00',70),

-- AUSENTE
(1,8,4,NULL,3,1,'2025-12-02','12:00','13:00',120),

-- MAIS CONCLUÍDOS
(1,4,6,NULL,5,1,'2025-12-06','15:00','17:00',150),
(1,2,4,NULL,5,3,'2025-12-08','10:00','10:30',60),
(1,1,3,NULL,5,1,'2025-12-06','09:00','09:45',80),
(1,6,3,NULL,5,1,'2025-12-04','09:00','09:45',80);

-- ==============================
-- AVALIAÇÕES APENAS DOS CONCLUÍDOS
-- ==============================
INSERT INTO avaliacao (agendamento_id, usuario_id, nota_servico, descricao_servico, data_horario)
VALUES
(1, 3, 5, 'Atendimento rápido, cordial e resultado impecável no corte. Recomendo pela excelência da equipe!', NOW()),
(2, 4, 4, 'O serviço de hidratação proporcionou cabelos macios e brilhantes. Fiquei satisfeita com o cuidado e atenção.', NOW()),
(3, 5, 5, 'Corte realizado com técnica perfeita. Superou minhas expectativas pelo profissionalismo e dedicação.', NOW()),
(4, 6, 4, 'Penteado elaborado com capricho, resultado muito bonito e resistente. Demonstraram grande habilidade!', NOW()),
(5, 3, 5, 'A coloração ficou vibrante e uniforme. Atendimento profissional, equipamentos modernos e preocupação com o resultado.', NOW()),

(17, 4, 5, 'As mechas ficaram naturais e luminosas, com acabamento excelente. O profissional demonstrou domínio da técnica!', NOW()),
(18, 3, 4, 'A escova modeladora deixou meus cabelos sedosos e com ótimo movimento. Fui atendida pontualmente e com atenção.', NOW()),
(19, 5, 5, 'Corte realizado de forma ágil, com resultado muito profissional. Ambiente agradável e atendimento de alto nível.', NOW()),
(20, 5, 4, 'Penteado elegante, ideal para ocasiões especiais. Fui ouvida sobre preferências e o resultado superou expectativas.', NOW()),
(34, 2, 5, 'Simplesmente perfeito, make não borrou e deu tudo certo no meu casamento, super bem feito!!!', NOW());

-- ==============================
-- FUNCIONAMENTO DO SALÃO
-- ==============================
INSERT INTO funcionamento (dia_semana, inicio, fim, aberto, capacidade, funcionario_id) VALUES
('MONDAY', NULL, NULL, 0, NULL, 1),
('TUESDAY', '10:00:00', '19:00:00', 1, 2, 1),
('WEDNESDAY', '10:00:00', '19:00:00', 1, 2, 1),
('THURSDAY', '10:00:00', '19:00:00', 1, 2, 1),
('FRIDAY', '10:00:00', '19:00:00', 1, 2, 1),
('SATURDAY', '10:00:00', '19:00:00', 1, 2, 1),
('SUNDAY', NULL, NULL, 0, NULL, 1);

INSERT INTO funcionamento (dia_semana, inicio, fim, aberto, capacidade, funcionario_id) VALUES
('MONDAY', NULL, NULL, 0, NULL, 2),
('TUESDAY', '10:00:00', '19:00:00', 1, 2, 2),
('WEDNESDAY', '10:00:00', '19:00:00', 1, 2, 2),
('THURSDAY', '10:00:00', '19:00:00', 1, 2, 2),
('FRIDAY', '10:00:00', '19:00:00', 1, 2, 2),
('SATURDAY', '10:00:00', '19:00:00', 1, 2, 2),
('SUNDAY', NULL, NULL, 0, NULL, 2);

INSERT INTO desc_cancelamento (descricao, agendamento_id) VALUES 
("Não vou poder comparecer",14),
("Agendei o serviço errado",15),
("Me enganei com minha agenda, peço desculpas",30);

select * from agendamento where usuario_id = 4 and status_agendamento_id = 5;
