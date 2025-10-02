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

-- ADMIN
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento) 
VALUES 
(1, 'Admin Master', '11999999999', '00000000000', 'admin@salontime.com', 'admin123', 1, NULL, '1980-01-01');

-- CLIENTES
INSERT INTO usuario (tipo_usuario_id, nome, telefone, CPF, email, senha, login, foto, data_nascimento) 
VALUES  
(2, 'Maria Clara', '11966665555', '34567890123', 'maria@cliente.com', 'maria123', 0, NULL, '1995-12-20'),
(2, 'Lucas Lima', '11955554444', '45678901234', 'lucas@cliente.com', 'lucas123', 0, NULL, '2000-03-10');

INSERT INTO funcionamento (dia_semana, inicio, fim, aberto, capacidade, funcionario_id) VALUES
('TUESDAY', '10:00:00', '19:00:00', 1, 2, 1),
('WEDNESDAY', '10:00:00', '19:00:00', 1, 2, 1),
('THURSDAY', '10:00:00', '19:00:00', 1, 2, 1),
('FRIDAY', '10:00:00', '19:00:00', 1, 2, 1),
('SATURDAY', '10:00:00', '19:00:00', 1, 2, 1),
('SUNDAY', NULL, NULL, 0, NULL, 1),
('MONDAY', NULL, NULL, 0, NULL, 1);

INSERT INTO servico (nome, preco, tempo, status, simultaneo, descricao, foto)
VALUES 
('Corte Feminino', 70.00, '00:45:00', 'ATIVO', 1, 'Corte feminino completo', NULL),
('Corte Masculino', 50.00, '00:30:00', 'ATIVO', 1, 'Corte masculino tradicional', NULL),
('Manicure', 40.00, '00:40:00', 'ATIVO', 0, 'Serviço de manicure', NULL),
('Luzes top', 150.00, '02:00:00', 'ATIVO', 0, 'Luzes especiais', NULL),
('Dia da Noiva', 200.00, '03:00:00', 'ATIVO', 1, 'Pacote especial para noivas', NULL);

INSERT INTO pagamento (forma, taxa) VALUES 
('Dinheiro', 0.00),
('Cartão de Crédito', 3.50),
('Cartão de Débito', 0.0),
('Pix', 0.00);


INSERT INTO funcionario_competencia (funcionario_id, servico_id)
VALUES 
(1, 1), -- Corte Feminino
(1, 2), -- Corte Masculino
(1, 3), -- Manicure
(1, 4), -- Manicure
(1, 5); -- Manicure

INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES 
(1, 1, 2, 1, 2, '2025-09-22', '19:00:00', '19:30:00', 50.00),
(1, 2, 3, 1, 2, '2025-09-28', '15:00:00', '15:30:00', 1150.00);

INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES 
(1, 1, 3, 1, 1, '2025-10-26', '21:00:00', '22:00:00', 40.00);

INSERT INTO agendamento (funcionario_id, servico_id, usuario_id, status_agendamento_id, pagamento_id, data, inicio, fim, preco)
VALUES 
(1, 1, 3, 1, 1, '2025-09-26', '21:00:00', '22:00:00', 40.00);

INSERT INTO avaliacao (agendamento_id, usuario_id, nota_servico, descricao_servico, data_horario)
VALUES 
(1, 2, 5, 'Excelente atendimento e corte impecável!', NOW()),
(2, 2, 4, 'Bom serviço, mas poderia ser mais rápido.', NOW());


INSERT INTO cupom (nome, desconto, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Desconto Black Friday', 30,  'Desconto de 30% na Black Friday', 'BLACK30', 1, '2025-11-01', '2025-11-30', 'EXCLUSIVO');

INSERT INTO cupom (nome, desconto, descricao, codigo, ativo, inicio, fim, tipo_destinatario)
VALUES 
('Desconto Natal', 10, 'Desconto de 10% no Natal', 'NATAL10', 1, '2025-11-01', '2025-11-30', 'TODOS');



select * from agendamento;


