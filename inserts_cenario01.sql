use salon_time;

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

INSERT INTO info_salao (
    email,
    telefone,
    logradouro,
    numero,
    cidade,
    estado,
    complemento
) VALUES (
    'contato@salontime.com',
    '11987654321',
    'Rua das Flores',
    '123',
    'São Paulo',
    'SP',
    'Sala 5 - Edifício Central'
);


USE salon_time;

-- ==============================
--  CLIENTES (15)
-- ==============================
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento)
VALUES
(1, 'Marina Souza', '11911111111', '11111111111', 'marina@example.com', '123456', 0, NULL, '1992-05-14'),
(2, 'Ana Souza', '11911111111', '11111111111', 'ana.souza@example.com', '123456', 0, NULL, '1992-05-14'),
(2, 'Bruno Lima', '11922222222', '22222222222', 'bruno.lima@example.com', '123456', 0, NULL, '1988-10-02'),
(2, 'Carla Ferreira', '11933333333', '33333333333', 'carla.ferreira@example.com', '123456', 0, NULL, '1995-08-21'),
(2, 'Daniel Oliveira', '11944444444', '44444444444', 'daniel.oliveira@example.com', '123456', 0, NULL, '1990-12-01'),
(2, 'Eduarda Martins', '11955555555', '55555555555', 'eduarda.martins@example.com', '123456', 0, NULL, '1998-03-11'),
(2, 'Felipe Costa', '11966666666', '66666666666', 'felipe.costa@example.com', '123456', 0, NULL, '1991-09-15'),
(2, 'Gabriela Rocha', '11977777777', '77777777777', 'gabriela.rocha@example.com', '123456', 0, NULL, '1987-07-23'),
(2, 'Henrique Santos', '11988888888', '88888888888', 'henrique.santos@example.com', '123456', 0, NULL, '1993-02-19'),
(2, 'Isabela Moreira', '11999999998', '99999999998', 'isabela.moreira@example.com', '123456', 0, NULL, '1999-06-30'),
(2, 'João Pedro', '11910101010', '10101010101', 'joao.pedro@example.com', '123456', 0, NULL, '1985-11-09'),
(2, 'Karina Almeida', '11911112222', '11112222333', 'karina.almeida@example.com', '123456', 0, NULL, '1994-04-17'),
(2, 'Lucas Menezes', '11922223333', '22223333444', 'lucas.menezes@example.com', '123456', 0, NULL, '1989-01-26'),
(2, 'Mariana Dias', '11933334444', '33334444555', 'mariana.dias@example.com', '123456', 0, NULL, '1996-10-08'),
(2, 'Nathalia Campos', '11944445555', '44445555666', 'nathalia.campos@example.com', '123456', 0, NULL, '1997-12-19'),
(2, 'Otávio Teixeira', '11955556666', '55556666777', 'otavio.teixeira@example.com', '123456', 0, NULL, '1992-07-05');

-- ==============================
--  SERVIÇOS (7)
-- ==============================
INSERT INTO servico (nome, preco, tempo, status, simultaneo, descricao)
VALUES
('Corte de Cabelo Feminino', 80.00, '00:45:00', 'ATIVO', 0, 'Corte moderno com finalização.'),
('Corte Masculino', 60.00, '00:30:00', 'ATIVO', 0, 'Corte masculino com acabamento.'),
('Hidratação Capilar', 90.00, '01:00:00', 'ATIVO', 0, 'Tratamento de hidratação profunda.'),
('Coloração', 150.00, '02:00:00', 'ATIVO', 0, 'Coloração completa dos fios.'),
('Mechas / Luzes', 200.00, '03:00:00', 'ATIVO', 0, 'Iluminação dos fios com técnica personalizada.'),
('Pintura de Unhas', 40.00, '00:30:00', 'ATIVO', 0, 'Esmaltação tradicional.'),
('Escova Modeladora', 70.00, '00:50:00', 'ATIVO', 0, 'Escova com modelagem de pontas.');

-- ==============================
--  FUNCIONÁRIA (ADMIN) COMPETENTE EM TODOS OS SERVIÇOS
-- ==============================
INSERT INTO funcionario_competencia (funcionario_id, servico_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7);


-- ==============================
--  CUPONS (5)
-- ==============================
INSERT INTO cupom (nome, desconto, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES
('Beleza10', 10, '10% de desconto para todos', 'BELEZA10', 1, '2025-01-01', '2025-12-31', 'TODOS'),
('PrimeiraVez', 15, 'Desconto de boas-vindas', 'PRIMEIRA15', 1, '2025-01-01', '2025-12-31', 'TODOS'),
('Brilho20', 20, 'Para serviços de coloração', 'BRILHO20', 1, '2025-01-01', '2025-12-31', 'TODOS'),
('Cuide25', 25, 'Promoção de cuidados capilares', 'CUIDE25', 1, '2025-01-01', '2025-12-31', 'TODOS'),
('OutubroRosa', 30, 'Campanha especial Outubro Rosa', 'OUTUBROROSA', 1, '2025-10-01', '2025-12-31', 'TODOS');

-- ==============================
--  CUPOM CONFIGURAÇÃO
-- ==============================

INSERT INTO copum_configuracao (intervalo_atendimento, porcentagem_desconto)
VALUES
(5, 10);

-- ==============================
--  PAGAMENTO (3 tipos)
-- ==============================
INSERT INTO pagamento (forma, taxa) VALUES
('Dinheiro', 0.00),
('Cartão de Crédito', 3.50),
('PIX', 0.00);

-- ==============================
--  AGENDAMENTOS (cada cliente 1 agendamento)
-- ==============================

-- Gerando horários alternados para a semana 03/11 a 07/11/2025
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, cupom_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES
(1, 1, 2, 1, 1, 2, '2025-11-01', '09:00:00', '09:45:00', 80.00),
(1, 2, 3, 2, 1, 1, '2025-11-03', '10:00:00', '10:30:00', 60.00),
(1, 3, 4, 3, 1, 3, '2025-11-03', '11:00:00', '12:00:00', 90.00),
(1, 4, 5, 4, 1, 1, '2025-11-04', '09:00:00', '11:00:00', 150.00),
(1, 5, 6, 5, 1, 2, '2025-11-04', '11:15:00', '14:15:00', 200.00),
(1, 6, 7, 1, 1, 2, '2025-11-05', '09:00:00', '09:30:00', 40.00),
(1, 7, 8, 2, 1, 3, '2025-11-05', '10:00:00', '10:50:00', 70.00),
(1, 1, 9, 3, 1, 1, '2025-11-05', '11:00:00', '11:45:00', 80.00),
(1, 2, 10, 4, 1, 1, '2025-11-06', '09:00:00', '09:30:00', 60.00),
(1, 3, 11, 5, 1, 2, '2025-11-06', '10:00:00', '11:00:00', 90.00),
(1, 4, 12, 1, 1, 3, '2025-11-06', '11:15:00', '13:15:00', 150.00),
(1, 5, 13, 2, 1, 2, '2025-11-07', '09:00:00', '12:00:00', 200.00),
(1, 6, 14, 3, 1, 1, '2025-11-07', '13:00:00', '13:30:00', 40.00),
(1, 7, 15, 4, 1, 2, '2025-11-07', '14:00:00', '14:50:00', 70.00),
(1, 1, 2, 5, 1, 3, '2025-11-07', '15:00:00', '15:45:00', 80.00);

-- Gerando horários alternados para a semana 07/10 a 07/11/2025
INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, cupom_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES
(1, 1, 2, 1, 1, 2, '2025-10-07', '09:00:00', '09:45:00', 80.00),
(1, 2, 3, 2, 1, 1, '2025-10-07', '10:00:00', '10:30:00', 60.00),
(1, 3, 4, 3, 1, 3, '2025-10-08', '11:00:00', '12:00:00', 90.00),
(1, 4, 5, 4, 1, 1, '2025-10-08', '09:00:00', '11:00:00', 150.00),
(1, 5, 6, 5, 1, 2, '2025-10-11', '11:15:00', '14:15:00', 200.00),
(1, 6, 7, 1, 1, 2, '2025-10-11', '09:00:00', '09:30:00', 40.00),
(1, 7, 8, 2, 1, 3, '2025-10-12', '10:00:00', '10:50:00', 70.00),
(1, 1, 9, 3, 1, 1, '2025-10-12', '11:00:00', '11:45:00', 80.00),
(1, 2, 10, 4, 1, 1, '2025-10-13', '09:00:00', '09:30:00', 60.00),
(1, 3, 11, 5, 1, 2, '2025-10-13', '10:00:00', '11:00:00', 90.00),
(1, 4, 12, 1, 1, 3, '2025-10-14', '11:15:00', '13:15:00', 150.00),
(1, 5, 13, 2, 1, 2, '2025-10-15', '09:00:00', '12:00:00', 200.00),
(1, 6, 14, 3, 1, 1, '2025-10-15', '13:00:00', '13:30:00', 40.00),
(1, 7, 15, 4, 1, 2, '2025-10-18', '14:00:00', '14:50:00', 70.00),
(1, 1, 2, 5, 1, 3, '2025-10-18', '15:00:00', '15:45:00', 80.00);


-- ==============================
--  AVALIAÇÕES (nota >= 4)
-- ==============================
INSERT INTO avaliacao (agendamento_id, usuario_id, nota_servico, descricao_servico, data_horario)
VALUES
(1, 2, 5, 'Excelente atendimento e corte perfeito.', NOW()),
(2, 3, 4, 'Muito bom, recomendo.', NOW()),
(3, 4, 5, 'Cabelos hidratados e brilhantes!', NOW()),
(4, 5, 4, 'Coloração ficou ótima.', NOW()),
(5, 6, 5, 'Adorei o resultado das mechas.', NOW()),
(6, 7, 4, 'Unhas perfeitas!', NOW()),
(7, 8, 5, 'Escova ficou linda.', NOW()),
(8, 9, 5, 'Corte maravilhoso.', NOW()),
(9, 10, 4, 'Atendimento rápido e cordial.', NOW()),
(10, 11, 5, 'Excelente hidratação.', NOW()),
(11, 12, 4, 'Coloração bem feita.', NOW()),
(12, 13, 5, 'Serviço impecável.', NOW()),
(13, 14, 4, 'Tudo ótimo!', NOW()),
(14, 15, 5, 'Experiência excelente.', NOW()),
(15, 2, 5, 'Voltarei com certeza.', NOW());


-- ==============================
--  Funcionamento
-- ==============================
INSERT INTO funcionamento (dia_semana, inicio, fim, aberto, capacidade, funcionario_id) VALUES
('MONDAY', NULL, NULL, 0, NULL, 1),
('TUESDAY', '10:00:00', '19:00:00', 1, 2, 1),
('WEDNESDAY', '10:00:00', '19:00:00', 1, 2, 1),
('THURSDAY', '10:00:00', '19:00:00', 1, 2, 1),
('FRIDAY', '10:00:00', '19:00:00', 1, 2, 1),
('SATURDAY', '10:00:00', '19:00:00', 1, 2, 1),
('SUNDAY', NULL, NULL, 0, NULL, 1);	


select * from agendamento;

        
        SELECT * 
FROM agendamento 
WHERE 
  funcionario_id = 1
  AND (
    data < CURDATE() 
    OR 
    (data = CURDATE() AND inicio < CURTIME())
  ) 
  AND status_agendamento_id != 1
ORDER BY data DESC, inicio DESC;