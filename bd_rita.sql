-- Drop database if it exists
DROP DATABASE IF EXISTS meu_banco_de_dados;

-- Create the database
CREATE DATABASE meu_banco_de_dados;

-- Select the database
USE meu_banco_de_dados;

-- Create the tables
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

CREATE TABLE COMITE_DE_ETICA (
    IdDepar INT,
    Denuncia VARCHAR(255),
    FOREIGN KEY (IdDepar) REFERENCES DEPARTAMENTO(IdDepar)
);

CREATE TABLE ADV_PROCESSO (
    Id_trabalhador INT,
    IdProc INT,
    PRIMARY KEY (Id_trabalhador, IdProc)
);

CREATE TABLE ADV_AUDIENCIA (
    Id_trabalhador INT,
    IdAudi INT,
    PRIMARY KEY (Id_trabalhador, IdAudi)
);

CREATE TABLE ADV_CASO (
    Id_trabalhador INT,
    IdCaso INT,
    PRIMARY KEY (Id_trabalhador, IdCaso)
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

CREATE TABLE PROCESSO (
    IdProc INT PRIMARY KEY,
    Descricao VARCHAR(255),
    IdOrgReg INT,
    IdCliente INT,
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
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

CREATE TABLE ORGREGULADOR (
    IdOrgReg INT PRIMARY KEY,
    Nome VARCHAR(255),
    TipoRegulamento VARCHAR(255)
);

CREATE TABLE STAKEHOLDERS (
    Id_trabalhador INT,
    Qtd_investimento DECIMAL(10, 2),
    PRIMARY KEY (Id_trabalhador)
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
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);

CREATE TABLE SOCIO (
    Id_trabalhador INT,
    Participacao DECIMAL(10, 2),
    PRIMARY KEY (Id_trabalhador)
);

CREATE TABLE ADVOGADO (
    Id_trabalhador INT PRIMARY KEY
);

CREATE TABLE CHEFE (
    Id_trabalhador INT PRIMARY KEY
);

CREATE TABLE AUDIENCIA (
    IdAudi INT PRIMARY KEY,
    Data DATE,
    IdOrgReg INT,
    IdCliente INT,
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
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
(5, 'Hiago Robério', 'chorao_junior_sou_seu_fa@gmail.com', 1);

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

INSERT INTO ADV_PROCESSO (Id_trabalhador, IdProc) VALUES
(1, 2),
(2, 1),
(3, 3);

INSERT INTO ADV_AUDIENCIA (Id_trabalhador, IdAudi) VALUES
(1, 2),
(2, 1),
(3, 3);

INSERT INTO ADV_CASO (Id_trabalhador, IdCaso) VALUES
(1, 2),
(2, 1),
(3, 3);

INSERT INTO INCIDENTE_TI (IdDepar, Incidente) VALUES
(1, 'Falha no servidor'),
(2, 'O servidor caiu NO CHÃO'),
(1, 'As pilhas do controle do ar-condicionado descarregaram');

INSERT INTO CONTRATO (IdDepar, DataAdmissao, Contrato) VALUES
(1, '2024-01-21', 'Contrato001'),
(2, '2024-05-12', 'Contrato002');

INSERT INTO RH (IdDepar, AvaliacaoDesempenho, DataAdmissao, Contrato) VALUES
(2, 'Excelente', '2023-02-20', 'Contrato654');

INSERT INTO TI (IdDepar, Infraestrutura) VALUES
(1, 'Rede de computadores');

INSERT INTO PROCESSO (IdProc, Descricao, IdOrgReg, IdCliente) VALUES
(1, 'Processo trabalhista', 1, 1),
(2, 'Processo civil', 2, 2);

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
(1, 'Orgao1', 'Regulamento1'),
(2, 'Orgao2', 'Regulamento2');

INSERT INTO STAKEHOLDERS (Id_trabalhador, Qtd_investimento) VALUES
(1, 1000.00),
(2, 2000.00);

INSERT INTO SETOR_BIB (IdBib, Setor) VALUES
(1, 'Direito Civil'),
(1, 'Direito Penal');

INSERT INTO CASO (IdCaso, Descricao, IdOrgReg, IdCliente) VALUES
(1, 'Caso de exemplo', 1, 1),
(2, 'Outro caso de exemplo', 2, 2);

INSERT INTO SOCIO (Id_trabalhador, Participacao) VALUES
(1, 50.00),
(2, 30.00);

INSERT INTO ADVOGADO (Id_trabalhador) VALUES
(1),
(2);

INSERT INTO CHEFE (Id_trabalhador) VALUES
(1);

INSERT INTO AUDIENCIA (IdAudi, Data, IdOrgReg, IdCliente) VALUES
(3, '2024-06-01', 1, 1),
(4, '2024-07-15', 2, 2);


-- 2.3.9 Consulta 2: Lista de todos os departamentos e advogados associados, incluindo departamentos que não têm advogados
SELECT d.IdDepar, d.NumTrab, t.Id_trabalhador, t.Nome
FROM DEPARTAMENTO d
LEFT JOIN TRABALHADOR t ON d.IdDepar = t.IdConsul
LEFT JOIN ADVOGADO a ON t.Id_trabalhador = a.Id_trabalhador;


-- 2.3.10 Consulta de todos os processos e advogados associados, incluindo processos que não têm advogados associados
SELECT 
    PROCESSO.IdProc, 
    PROCESSO.Descricao AS ProcessoDescricao, 
    ADVOGADO.Id_trabalhador AS AdvogadoId, 
    TRABALHADOR.Nome AS AdvogadoNome
FROM 
    PROCESSO
LEFT JOIN 
    ADV_PROCESSO ON PROCESSO.IdProc = ADV_PROCESSO.IdProc
LEFT JOIN 
    TRABALHADOR ON ADV_PROCESSO.Id_trabalhador = TRABALHADOR.Id_trabalhador
LEFT JOIN 
    ADVOGADO ON TRABALHADOR.Id_trabalhador = ADVOGADO.Id_trabalhador;

-- 2.3.11 Queremos listar todos os incidentes de TI e os departamentos associados, incluindo os incidentes de TI que n ̃ao tˆem departamentos associados.
SELECT 
    i.IdDepar, 
    i.Incidente, 
    d.NumTrab
FROM 
    INCIDENTE_TI i
LEFT JOIN 
    DEPARTAMENTO d 
ON 
    i.IdDepar = d.IdDepar;

-- 2.3.12 Queremos listar todas as audiˆencias e os advogados associados, incluindo as audiˆencias que n ̃ao tˆem advogados associados.
SELECT 
    a.IdAudi, 
    a.Data, 
    aa.Id_trabalhador
FROM 
    AUDIENCIA a
LEFT JOIN 
    ADV_AUDIENCIA aa 
ON 
    a.IdAudi = aa.IdAudi;

-- 2.3. 13 Listar todos os registros de TRABALHADOR e ADVOGADO, mostrando todas as pessoas que possuem qualquer uma dessas relac ̧  ̃oes, incluindo trabalhadores sem registros de advogado
SELECT 
    T.Id_trabalhador,
    T.Nome,
    T.Email,
    T.IdConsul,
    A.Id_trabalhador AS Advogado
FROM 
    TRABALHADOR T
LEFT JOIN 
    ADVOGADO A
ON 
    T.Id_trabalhador = A.Id_trabalhador;

-- 2.3.14 Listar todos os registros de DEPARTAMENTO e TI, mostrando todos os nomes de departamentos, incluindo aqueles que n ̃ao possuem registros na TI
SELECT
    d.IdDepar AS DepartamentoID,
    d.NumTrab AS NumeroTrabalhadores,
    d.IdEquipe AS EquipeID,
    COALESCE(t.Infraestrutura, 'Nenhum registro TI') AS InfraestruturaTI
FROM
    DEPARTAMENTO d
LEFT JOIN
    TI t ON d.IdDepar = t.IdDepar
ORDER BY
    d.IdDepar;

-- 2.3.15: Listar todos os registros de CLIENTE e PROCESSO, mostrando todos os clientes, incluindo aqueles que n ̃ao possuem registros de processos

SELECT 
    CLIENTE.Nome,
    CLIENTE.Cpf,
    PROCESSO.IdProc
FROM 
    CLIENTE
LEFT JOIN 
    PROCESSO
ON 
    CLIENTE.IdCliente = PROCESSO.IdCliente;

-- 2.3.16: Listar todos os registros de CONTRATO e RH, mostrando todos os contratos, incluindo aqueles que não possuem registros em RH
SELECT 
    CONTRATO.IdDepar,
    CONTRATO.DataAdmissao,
    RH.AvaliacaoDesempenho
FROM 
    CONTRATO
LEFT JOIN 
    RH
ON 
    CONTRATO.IdDepar = RH.IdDepar;

-- 2.5.1: Contar o número de advogados em cada departamento:
SELECT 
    IdDepar,
    SUM(Qnt_advogados) AS TotalAdvogados
FROM 
    ADVOCACIA
GROUP BY 
    IdDepar;

-- 2.5.2: Somar as receitas por departamento
SELECT 
    IdDepar,
    SUM(Receita) AS TotalReceita
FROM 
    FINANCEIRO
GROUP BY 
    IdDepar;

--2.5.3: Contar o numero de trabalhadores por audiência
SELECT 
    IdAudi,
    COUNT(Id_trabalhador) AS QuantidadeTrabalhadores
FROM 
    ADV_AUDIENCIA
GROUP BY 
    IdAudi;