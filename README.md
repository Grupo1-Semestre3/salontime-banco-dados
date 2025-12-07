# SalonTime — Banco de Dados

Este diretório contém os artefatos do banco de dados do projeto SalonTime: scripts SQL para criação e carga de dados e o modelo ER do domínio.

## Visão Geral
- **Objetivo:** disponibilizar a estrutura inicial do banco, relacionamentos e um cenário mínimo de dados para desenvolvimento, testes e demonstrações.
- **SGBD alvo:** MySQL (recomendado MySQL 8.x).

## Estrutura do Diretório
- `criacao_bd.sql`: script de criação do schema, tabelas, chaves e constraints.
- `inserts_cenario01.sql`: carga inicial de dados (cenário 01) para popular tabelas com exemplos.
- `SalonTime_DER.mwb`: arquivo do MySQL Workbench com o Diagrama Entidade-Relacionamento (DER).
- `SalonTime_DER.mwb.bak`: backup do modelo Workbench.

## Pré-requisitos
- MySQL 8.x instalado e acessível no terminal.
- Usuário com permissão para criar schemas/tabelas.
- Opcional: MySQL Workbench para visualizar/editar o DER (`.mwb`).

## Como Usar
### 1) Criar o banco e estrutura
Execute o script de criação (ajuste usuário/host conforme seu ambiente):

```zsh
# Exemplo usando usuário root e solicitando senha
mysql -u root -p < criacao_bd.sql
```

O script cria o schema e todas as tabelas com suas chaves/relacionamentos.

### 2) Inserir dados do cenário 01
Após a criação das tabelas, carregue os dados de exemplo:

```zsh
mysql -u root -p < inserts_cenario01.sql
```

### 3) Visualizar o diagrama (opcional)
Abra o arquivo `SalonTime_DER.mwb` no MySQL Workbench para explorar o DER, validar relacionamentos e gerar DDL se necessário.

## Convenções e Boas Práticas
- Versione alterações de `criacao_bd.sql` e `inserts_cenario01.sql` via PRs.
- Mantenha nomes de tabelas e colunas consistentes com o DER.
