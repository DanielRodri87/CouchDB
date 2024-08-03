-- Create and use the database
DROP DATABASE IF EXISTS meu_banco_de_dados;
CREATE DATABASE meu_banco_de_dados;
USE meu_banco_de_dados;

-- Create tables
CREATE TABLE EQUIPE_APOIO_ADM (
    IdEquipe INT PRIMARY KEY,
    Apoio VARCHAR(255)
);

CREATE TABLE DEPARTAMENTO (
    IdDepar INT PRIMARY KEY,
    NumTrab INT,
    IdEquipe INT,
    FOREIGN KEY (IdEquipe) REFERENCES EQUIPE_APOIO_ADM(IdEquipe)
);

CREATE TABLE TRABALHADOR (
    Id_trabalhador INT PRIMARY KEY,
    Nome VARCHAR(255),
    Email VARCHAR(255),
    IdConsul INT
);

CREATE TABLE CLIENTE (
    IdCliente INT PRIMARY KEY,
    Nome VARCHAR(255),
    Cpf VARCHAR(11),
    Contrato VARCHAR(255),
    Id_trabalhador INT,
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador)
);

CREATE TABLE ORGREGULADOR (
    IdOrgReg INT PRIMARY KEY,
    Nome VARCHAR(255),
    TipoRegulamento VARCHAR(255)
);

CREATE TABLE PROCESSO (
    IdProc INT PRIMARY KEY,
    Descricao VARCHAR(255),
    IdOrgReg INT,
    IdCliente INT,
    FOREIGN KEY (IdOrgReg) REFERENCES ORGREGULADOR(IdOrgReg),
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);

CREATE TABLE AUDIENCIA (
    IdAudi INT PRIMARY KEY,
    Data DATE,
    IdOrgReg INT,
    IdCliente INT,
    FOREIGN KEY (IdOrgReg) REFERENCES ORGREGULADOR(IdOrgReg),
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);

CREATE TABLE COMITE_DE_ETICA (
    IdDepar INT,
    Denuncia VARCHAR(255),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE ADV_PROCESSO (
    Id_trabalhador INT,
    IdProc INT,
    PRIMARY KEY (Id_trabalhador, IdProc),
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador),
    FOREIGN KEY (IdProc) REFERENCES PROCESSO(IdProc)
);

CREATE TABLE ADV_AUDIENCIA (
    Id_trabalhador INT,
    IdAudi INT,
    PRIMARY KEY (Id_trabalhador, IdAudi),
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador),
    FOREIGN KEY (IdAudi) REFERENCES AUDIENCIA(IdAudi)
);

CREATE TABLE INCIDENTE_TI (
    IdDepar INT,
    Incidente VARCHAR(255),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE CONTRATO (
    IdDepar INT,
    DataAdmissao DATE,
    Contrato VARCHAR(255),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE RH (
    IdDepar INT,
    AvaliacaoDesempenho VARCHAR(255),
    DataAdmissao DATE,
    Contrato VARCHAR(255),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE TI (
    IdDepar INT,
    Infraestrutura VARCHAR(255),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE ADVOCACIA (
    IdDepar INT,
    Qnt_advogados INT,
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE FINANCEIRO (
    IdDepar INT,
    Receita DECIMAL(10, 2),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE DESPESA_FIN (
    IdDepar INT,
    Despesa DECIMAL(10, 2),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE CONSUTOR_EXTERNO (
    IdConsul INT PRIMARY KEY,
    Nome VARCHAR(255),
    Especializacao VARCHAR(255),
    Email VARCHAR(255)
);

CREATE TABLE BIBLIOTECA_JURI (
    IdBib INT PRIMARY KEY,
    QtdLivro INT,
    Id_trabalhador INT,
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador)
);

CREATE TABLE STAKEHOLDERS (
    Id_trabalhador INT,
    Qtd_investimento DECIMAL(10, 2),
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador)
);

CREATE TABLE SETOR_BIB (
    IdBib INT,
    Setor VARCHAR(255),
    FOREIGN KEY (IdBib) REFERENCES BIBLIOTECA_JURI(IdBib)
);

CREATE TABLE CASO (
    IdCaso INT PRIMARY KEY,
    Descricao VARCHAR(255),
    IdOrgReg INT,
    IdCliente INT,
    FOREIGN KEY (IdOrgReg) REFERENCES ORGREGULADOR(IdOrgReg),
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);

CREATE TABLE SOCIO (
    Id_trabalhador INT,
    Participacao DECIMAL(10, 2),
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador)
);

CREATE TABLE ADVOGADO (
    Id_trabalhador INT,
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador)
);

CREATE TABLE CHEFE (
    Id_trabalhador INT,
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador)
);

CREATE TABLE ADV_CASO (
    Id_trabalhador INT,
    IdCaso INT,
    PRIMARY KEY (Id_trabalhador, IdCaso),
    FOREIGN KEY (Id_trabalhador) REFERENCES TRABALHADOR(Id_trabalhador),
    FOREIGN KEY (IdCaso) REFERENCES CASO(IdCaso)
);

-- Populate data
INSERT INTO EQUIPE_APOIO_ADM (IdEquipe, Apoio) VALUES
(1, 'Suporte Técnico'),
(2, 'Administrativo');

INSERT INTO DEPARTAMENTO (IdDepar, NumTrab, IdEquipe) VALUES
(1, 50, 1),
(2, 30, 2);

INSERT INTO TRABALHADOR (Id_trabalhador, Nome, Email, IdConsul) VALUES
(1, 'Daniel Rotrigesr', 'danielzimgamer@gmail.com', NULL),
(2, 'Francinvaldo de Sousa Barósio', 'naldo.ff.oliveira@outlook.com', NULL),
(3, 'Luis de Deus', 'mojangmedêminecraftdegraca@gmail.com', NULL),
(4, 'Rica de Cássia', 'ricesta123@gmail.com', NULL),
(5, 'Hiago Robério', 'chorao_junior_sou_seu_fa@gmail.com', 1); -- Ele é 1, porque tem vínculo a um consultor externo

INSERT INTO CLIENTE (IdCliente, Nome, Cpf, Contrato, Id_trabalhador) VALUES
(1, 'Salvando Sonegadores', '12345678901', 'Contrato123', 1),
(2, 'Somos Justus', '98765432101', 'Contrato456', 2),
(3, 'Empresa legal -literalmente-', '40028922', 'Contrato789', 3),
(4, 'Desleais Juniors', '40048944', 'Contrato1011', 4);

INSERT INTO COMITE_DE_ETICA (IdDepar, Denuncia) VALUES
(1, 'Denúncia de assédio moral'),
(2, 'O Hiago comeu meu lanche'),
(2, 'A Rica de Cássia me chamou de pobre'),
(1, 'O Daniel chamou o Francivaldo Barósio de elemento químico e tóxico');

INSERT INTO INCIDENTE_TI (IdDepar, Incidente) VALUES
(1, 'Falha no servidor'),
(2, 'O servidor caiu NO CHÃO'),
(2, 'As pilhas do controle do ar-condicionado descarregaram');

INSERT INTO CONTRATO (IdDepar, DataAdmissao, Contrato) VALUES
(1, '2024-01-21', 'Contrato001'),
(2, '2024-05-12', 'Contrato002');

INSERT INTO RH (IdDepar, AvaliacaoDesempenho, DataAdmissao, Contrato) VALUES
(2, 'Excelente', '2023-02-20', 'Contrato654');

INSERT INTO TI (IdDepar, Infraestrutura) VALUES
(1, 'Rede de computadores');

INSERT INTO ADVOCACIA (IdDepar, Qnt_advogados) VALUES
(2, 10);

INSERT INTO FINANCEIRO (IdDepar, Receita) VALUES
(1, 300.00),
(2, 1000000.00);

INSERT INTO DESPESA_FIN (IdDepar, Despesa) VALUES
(1, 200.00),
(2, 999999.00);

INSERT INTO CONSUTOR_EXTERNO (IdConsul, Nome, Especializacao, Email) VALUES
(1, 'Berenice', 'Contabilidade', 'bere2020@hotmail.com');

INSERT INTO BIBLIOTECA_JURI (IdBib, QtdLivro, Id_trabalhador) VALUES
(1, 1000, 1);

INSERT INTO ORGREGULADOR (IdOrgReg, Nome, TipoRegulamento) VALUES
(1, 'Orgão Regulador A', 'Regulamento A'),
(2, 'Orgão Regulador B', 'Regulamento B');

INSERT INTO STAKEHOLDERS (Id_trabalhador, Qtd_investimento) VALUES
(1, 10000.00),
(2, 1000.00),
(3, 500.00),
(4, 10000.00),
(5, 50.00);

INSERT INTO SETOR_BIB (IdBib, Setor) VALUES
(1, 'Direito Civil');

INSERT INTO CASO (IdCaso, Descricao, IdOrgReg, IdCliente) VALUES
(1, 'Caso de Fraude', 1, 1),
(2, 'Caso de Desvio de Verba', 2, 2);

INSERT INTO SOCIO (Id_trabalhador, Participacao) VALUES
(1, 50.00);

INSERT INTO ADVOGADO (Id_trabalhador) VALUES
(1),
(2),
(3),
(4),
(5);

INSERT INTO CHEFE (Id_trabalhador) VALUES
(1);

INSERT INTO AUDIENCIA (IdAudi, Data, IdOrgReg, IdCliente) VALUES
(1, '2023-03-15', 1, 1),
(2, '2023-04-20', 2, 2);

INSERT INTO PROCESSO (IdProc, Descricao, IdOrgReg, IdCliente) VALUES
(1, 'Processo trabalhista', 1, 1),
(2, 'Processo civil', 2, 2),
(3, 'Processo penal', 2, 3);

INSERT INTO ADV_PROCESSO (Id_trabalhador, IdProc) VALUES
(1, 2),
(2, 1),
(3, 3);


INSERT INTO ADV_CASO (Id_trabalhador, IdCaso) VALUES
(1, 2),
(2, 1);

INSERT INTO ADV_AUDIENCIA (Id_trabalhador, IdAudi) VALUES
(1, 2),
(2, 1);

-- Consultas
-- 1. Listando todos os advogados e seus respectivos clientes
SELECT 
    A.Nome AS Advogado,
    C.Nome AS Cliente
FROM 
    ADVOGADO AD
    JOIN TRABALHADOR A ON AD.Id_trabalhador = A.Id_trabalhador
    JOIN CLIENTE C ON A.Id_trabalhador = C.Id_trabalhador
ORDER BY
    A.Nome, C.Nome;
    
-- -- 2. Lista de advogados, seus departamentos e os clientes que contrataram esses advogados
SELECT 
    A.Nome AS Advogado,
    D.IdDepar AS Departamento,
    C.Nome AS Cliente
FROM
    ADVOGADO AD
    JOIN TRABALHADOR A ON AD.Id_trabalhador = A.Id_trabalhador
    JOIN CLIENTE C ON A.Id_trabalhador = C.Id_trabalhador
    JOIN DEPARTAMENTO D ON A.IdConsul = D.IdDepar
ORDER BY
    A.Nome, D.IdDepar, C.Nome;




-- 2. Lista de advogados, seus departamentos e os clientes que contrataram esses advogados
SELECT 
    A.Nome AS Advogado,
    D.IdDepar AS Departamento,
    C.Nome AS Cliente
FROM
    ADVOGADO AD
    JOIN TRABALHADOR A ON AD.Id_trabalhador = A.Id_trabalhador
    JOIN CLIENTE C ON A.Id_trabalhador = C.Id_trabalhador
    JOIN DEPARTAMENTO D ON A.IdConsul = D.IdDepar
ORDER BY
    A.Nome, D.IdDepar, C.Nome;

