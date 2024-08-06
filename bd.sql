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

-- ################# TRIGGERS #################

-- Este trigger impede a inserção de clientes com id duplicado na tabela CLIENTE.
DELIMITER $$

CREATE TRIGGER before_insert_cliente
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    DECLARE count_id INT;
    SELECT COUNT(*) INTO count_id
    FROM CLIENTE
    WHERE IdCliente = NEW.IdCliente;
    
    IF count_id > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Id duplicado.';
    END IF;
END$$

DELIMITER ;

-- Esse Trigger impede que clientes tenham CPF repetidos
DELIMITER $$

CREATE TRIGGER before_update_cliente
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
    DECLARE count_cpf INT;
    SELECT COUNT(*) INTO count_cpf
    FROM CLIENTE
    WHERE Cpf = NEW.Cpf AND IdCliente != OLD.IdCliente;
    
    IF count_cpf > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF duplicado.';
    END IF;
END$$

DELIMITER ;

-- Esse Trigger Garante que cada departamento tenha um id único
DELIMITER $$

CREATE TRIGGER before_insert_departamento
BEFORE INSERT ON DEPARTAMENTO
FOR EACH ROW
BEGIN
    DECLARE count_id INT;
    SELECT COUNT(*) INTO count_id
    FROM DEPARTAMENTO
    WHERE IdDepar = NEW.IdDepar;
    
    IF count_id > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'IdDepar duplicado.';
    END IF;
END$$

DELIMITER ;

-- Esse Trigger garante que não tenham email duplicados
DELIMITER $$

CREATE TRIGGER before_insert_trabalhador
BEFORE INSERT ON TRABALHADOR
FOR EACH ROW
BEGIN
    DECLARE count_email INT;
    SELECT COUNT(*) INTO count_email
    FROM TRABALHADOR
    WHERE Email = NEW.Email;
    
    IF count_email > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email já existente.';
    END IF;
END$$

DELIMITER ;

-- Esse Trigger Verifica se não tem nenhum id repedito
DELIMITER $$

CREATE TRIGGER before_update_cliente_id
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
    DECLARE count_id INT;
    SELECT COUNT(*) INTO count_id
    FROM CLIENTE
    WHERE IdCliente = NEW.IdCliente AND IdCliente != OLD.IdCliente;
    
    IF count_id > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'IdCliente already exists.';
    END IF;
END$$

DELIMITER ;



-- Populate data
INSERT INTO EQUIPE_APOIO_ADM (IdEquipe, Apoio) VALUES
(1, 'Suporte Técnico'),
(2, 'Administrativo');

INSERT INTO DEPARTAMENTO (IdDepar, NumTrab, IdEquipe) VALUES
(1, 50, 1),
-- (1, 100, 2),
(2, 30, 2),
(3, 25, 1),
(4, 20, 2);


INSERT INTO TRABALHADOR (Id_trabalhador, Nome, Email, IdConsul) VALUES
(1, 'Daniel Rotrigesr', 'danielzimgamer@gmail.com', NULL),
-- (1, 'sELMA', 'selma@gmail.com', NULL),
(2, 'Francinvaldo de Sousa Barósio', 'naldo.ff.oliveira@outlook.com', NULL),
(3, 'Luis de Deus', 'mojangmedêminecraftdegraca@gmail.com', NULL),
(4, 'Rica de Cássia', 'ricesta123@gmail.com', NULL),
(5, 'Hiago Robério', 'chorao_junior_sou_seu_fa@gmail.com', 1), -- Ele é 1, porque tem vínculo a um consultor externo
(6, 'Gabriela Souza', 'gabriela@gmail.com', 2),
-- (13, 'Gabriel Lima', 'gabriela@gmail.com', NULL),
(7, 'Paulo Almeida', 'paulo@empresa.com', 3),
(8, 'Fernanda Lima', 'fernanda@empresa.com', NULL),
(9, 'Marcos Silva', 'marcos@empresa.com', NULL),
(10, 'Julia Mendes', 'julia@empresa.com', NULL),
(11, 'Carla Figueiredo', 'carla@empresa.com', NULL),
(12, 'Ricardo Santos', 'ricardo@empresa.com', NULL),
(21, 'Felipe Costa', 'felipe@empresa.com', NULL),
(22, 'Mariana Alves', 'mariana@empresa.com', NULL),
(23, 'Alfredo Junior', 'trabalhadorx@empresa.com', NULL);


INSERT INTO CLIENTE (IdCliente, Nome, Cpf, Contrato, Id_trabalhador) VALUES
(1, 'Salvando Sonegadores', '12345678901', 'Contrato123', 1),
-- (1, 'Salvando Sonegadores', '12345678901', 'Contrato123', 1),
(2, 'Somos Justus', '98765432101', 'Contrato456', 2),
(3, 'Empresa legal -literalmente-', '40028922', 'Contrato789', 3),
-- (9, 'Empresa chata -ironicamente-', '40028922', 'Contrato666', 3),
(4, 'Desleais Juniors', '40048944', 'Contrato1011', 4),
(5, 'Empresa X', '11122233344', 'Contrato555', 5),
(6, 'Empresa Y', '55566677788', 'Contrato666', 6),
(7, 'Empresa Z', '99988877766', 'Contrato777', 7),
(8, 'Empresa W', '44433322211', 'Contrato888', 8);

INSERT INTO COMITE_DE_ETICA (IdDepar, Denuncia) VALUES
(1, 'Denúncia de assédio moral'),
(2, 'O Hiago comeu meu lanche'),
(2, 'A Rica de Cássia me chamou de pobre'),
(1, 'O Daniel chamou o Francivaldo Barósio de elemento químico e tóxico'),
(1, 'Denúncia de corrupção'),
(2, 'Denúncia de discriminação');

INSERT INTO INCIDENTE_TI (IdDepar, Incidente) VALUES
(1, 'Falha no servidor'),
(2, 'O servidor caiu NO CHÃO'),
(2, 'As pilhas do controle do ar-condicionado descarregaram'),
(1, 'Falha de segurança'),
(2, 'Problema de conectividade');


INSERT INTO CONTRATO (IdDepar, DataAdmissao, Contrato) VALUES
(1, '2024-11-01', 'Contrato015'),
(1, '2024-12-01', 'Contrato016'),
(2, '2024-11-01', 'Contrato017'),
(2, '2024-12-01', 'Contrato018'),
(3, '2024-11-01', 'Contrato019'),
(3, '2024-12-01', 'Contrato020'),
(3, '2024-09-01', 'Contrato021'),
(4, '2024-10-01', 'Contrato022');

INSERT INTO RH (IdDepar, AvaliacaoDesempenho, DataAdmissao, Contrato) VALUES
(2, 'Excelente', '2023-02-20', 'Contrato654'),
(1, 'Bom', '2023-03-01', 'Contrato888'),
(3, 'Muito Bom', '2023-09-01', 'Contrato021'),
(4, 'Excelente', '2023-10-01', 'Contrato022');


INSERT INTO TI (IdDepar, Infraestrutura) VALUES
(1, 'Rede de computadores'),
(2, 'Servidores de alta capacidade');


INSERT INTO ADVOCACIA (IdDepar, Qnt_advogados) VALUES
(2, 10),
(1, 5);

INSERT INTO FINANCEIRO (IdDepar, Receita) VALUES
(1, 300.00),
(2, 1000000.00),
(1, 50000.00),
(2, 200000.00);

INSERT INTO DESPESA_FIN (IdDepar, Despesa) VALUES
(1, 200.00),
(2, 999999.00),
(1, 30000.00),
(2, 150000.00);

INSERT INTO CONSUTOR_EXTERNO (IdConsul, Nome, Especializacao, Email) VALUES
(1, 'Berenice', 'Contabilidade', 'bere2020@hotmail.com'),
(2, 'Coronado', 'Engenharia de Software', 'coronado2024@gmail.com'),
(3, 'Pablo Marçal', 'Vendas', 'vendomesmo@gmail.com');


INSERT INTO BIBLIOTECA_JURI (IdBib, QtdLivro, Id_trabalhador) VALUES
(1, 1000, 1),
(2, 2000, 2);


INSERT INTO ORGREGULADOR (IdOrgReg, Nome, TipoRegulamento) VALUES
(1, 'Orgão Regulador A', 'Regulamento A'),
(2, 'Orgão Regulador B', 'Regulamento B');

INSERT INTO STAKEHOLDERS (Id_trabalhador, Qtd_investimento) VALUES
(1, 10000.00),
(2, 1000.00),
(3, 500.00),
(4, 10000.00),
(5, 50.00),
(6, 7000.00),
(7, 1500.00);

INSERT INTO SETOR_BIB (IdBib, Setor) VALUES
(1, 'Direito Civil'),
(2, 'Direito Penal');


INSERT INTO CASO (IdCaso, Descricao, IdOrgReg, IdCliente) VALUES
(1, 'Caso de Fraude', 1, 1),
(2, 'Caso de Desvio de Verba', 2, 2),
(3, 'Caso de Corrupção', 1, 3),
(4, 'Caso de Roubo', 2, 4);

INSERT INTO SOCIO (Id_trabalhador, Participacao) VALUES
(1, 50.00),
(2, 30.00);


INSERT INTO ADVOGADO (Id_trabalhador) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7);

INSERT INTO CHEFE (Id_trabalhador) VALUES
(1),
(2);

INSERT INTO AUDIENCIA (IdAudi, Data, IdOrgReg, IdCliente) VALUES
(1, '2023-03-15', 1, 1),
(2, '2023-04-20', 2, 2),
(3, '2023-05-15', 1, 3),
(4, '2023-06-20', 2, 4);

INSERT INTO PROCESSO (IdProc, Descricao, IdOrgReg, IdCliente) VALUES
(1, 'Processo trabalhista', 1, 1),
(2, 'Processo civil', 2, 2),
(3, 'Processo penal', 2, 3),
(4, 'Processo ambiental', 1, 4),
(5, 'Processo criminal', 2, 5);

INSERT INTO ADV_PROCESSO (Id_trabalhador, IdProc) VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO ADV_CASO (Id_trabalhador, IdCaso) VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 4);

INSERT INTO ADV_AUDIENCIA (Id_trabalhador, IdAudi) VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 4),
(23, 1),
(23, 2),
(23, 3),
(23, 4);


-- Consultas
-- 2.1.1. Lista de advogados, seus departamentos e os clientes que contrataram esses advogados
SELECT 
    t.Nome AS Advogado,
    d.IdDepar AS Departamento,
    c.Nome AS Cliente
FROM 
    ADVOGADO a
JOIN 
    TRABALHADOR t ON a.Id_trabalhador = t.Id_trabalhador
JOIN 
    CLIENTE c ON t.Id_trabalhador = c.Id_trabalhador
JOIN 
    DEPARTAMENTO d ON d.IdDepar = (SELECT IdDepar FROM DEPARTAMENTO WHERE IdDepar = d.IdDepar);

-- 2.1.2. Lista de departamentos e os advogados que trabalham em processos analisados por um órgão regulador específico.
SELECT
    d.IdDepar AS Departamento,
    t.Nome AS Advogado,
    o.Nome AS OrgaoRegulador,
    p.Descricao AS Processo
FROM
    ADV_PROCESSO ap
JOIN
    TRABALHADOR t ON ap.Id_trabalhador = t.Id_trabalhador
JOIN
    PROCESSO p ON ap.IdProc = p.IdProc
JOIN
    ORGREGULADOR o ON p.IdOrgReg = o.IdOrgReg
JOIN
    CLIENTE c ON p.IdCliente = c.IdCliente
JOIN
    DEPARTAMENTO d ON c.Id_trabalhador = t.Id_trabalhador
WHERE
    o.IdOrgReg = 2; 

-- 2.1.3. Listagem de trabalhadores e suas respectivas equipes de apoio administrativo e bibliotecas jurídicas
SELECT
    t.Nome AS Trabalhador,
    ea.Apoio AS EquipeApoioAdm,
    bj.QtdLivro AS QtdLivrosBiblioteca
FROM
    TRABALHADOR t
LEFT JOIN
    DEPARTAMENTO d ON t.Id_trabalhador = d.IdDepar
LEFT JOIN
    EQUIPE_APOIO_ADM ea ON d.IdEquipe = ea.IdEquipe
LEFT JOIN
    BIBLIOTECA_JURI bj ON t.Id_trabalhador = bj.Id_trabalhador;

-- 2.1.4. Listar os consultores externos e seus departamentos auxiliados
SELECT
    ce.Nome AS ConsultorExterno,
    d.IdDepar AS Departamento
FROM
    CONSUTOR_EXTERNO ce
JOIN
    TRABALHADOR t ON ce.IdConsul = t.IdConsul
JOIN
    DEPARTAMENTO d ON t.IdConsul = ce.IdConsul
GROUP BY
    ce.Nome, d.IdDepar;
    
-- 2.1.5. Combinar informações de clientes, processos e organizações reguladoras em um conjunto de dados  
-- único, selecionando e extraindo apenas os atributos relevantes para uma análise posterior
SELECT
    c.Nome AS Cliente,
    c.Cpf AS CPF,
    c.Contrato AS Contrato,
    p.Descricao AS DescricaoProcesso,
    o.Nome AS OrgaoRegulador,
    o.TipoRegulamento AS TipoRegulamento
FROM
    CLIENTE c
JOIN
    PROCESSO p ON c.IdCliente = p.IdCliente
JOIN
    ORGREGULADOR o ON p.IdOrgReg = o.IdOrgReg;

-- 2.2.1. Listar todos os registros de RH e contratos, mostrando todas as pessoas que possuem qualquer uma dessas relações.
SELECT
    t.Nome AS Trabalhador,
    rh.AvaliacaoDesempenho AS AvaliacaoDesempenho,
    rh.DataAdmissao AS DataAdmissaoRH,
    rh.Contrato AS ContratoRH,
    c.DataAdmissao AS DataAdmissaoContrato,
    c.Contrato AS Contrato
FROM
    TRABALHADOR t
LEFT JOIN
    DEPARTAMENTO d ON t.Id_trabalhador = d.IdDepar
LEFT JOIN
    RH rh ON d.IdDepar = rh.IdDepar
LEFT JOIN
    CONTRATO c ON d.IdDepar = c.IdDepar
WHERE
    rh.IdDepar IS NOT NULL OR c.IdDepar IS NOT NULL;

-- 2.2.2. Obter todos os processos e audiências
SELECT
    t.Nome AS Trabalhador,
    'Processo' AS Tipo,
    p.Descricao AS Descricao
FROM
    ADV_PROCESSO ap
JOIN
    TRABALHADOR t ON ap.Id_trabalhador = t.Id_trabalhador
JOIN
    PROCESSO p ON ap.IdProc = p.IdProc

UNION

SELECT
    t.Nome AS Trabalhador,
    'Audiência' AS Tipo,
    CONCAT('Audiência em ', a.Data) AS Descricao
FROM
    ADV_AUDIENCIA aa
JOIN
    TRABALHADOR t ON aa.Id_trabalhador = t.Id_trabalhador
JOIN
    AUDIENCIA a ON aa.IdAudi = a.IdAudi;

-- 2.2.3 Encontrar trabalhadores que estejam em ambos os departamento de RH e TI.
SELECT t.Id_trabalhador, t.Nome, t.Email
FROM TRABALHADOR t
WHERE EXISTS (
    SELECT 1
    FROM RH rh
    WHERE rh.IdDepar = (
        SELECT d.IdDepar
        FROM DEPARTAMENTO d
        WHERE d.IdDepar = rh.IdDepar
        AND d.IdDepar = (
            SELECT ti.IdDepar
            FROM TI ti
            WHERE ti.IdDepar = rh.IdDepar
        )
    )
);

-- 2.2.4 Encontrar advogados que estão ao mesmo tempo em um caso e em um processo
SELECT
    t.Id_trabalhador AS IdAdvogado,
    t.Nome AS NomeAdvogado
FROM
    ADV_CASO ac
JOIN
    ADV_PROCESSO ap ON ac.Id_trabalhador = ap.Id_trabalhador
JOIN
    TRABALHADOR t ON ac.Id_trabalhador = t.Id_trabalhador;

-- 2.2.5 Listar todos os contratos que não possuem incidentes em TI. |FALTA POVOAR MAIS|
SELECT
    c.IdDepar,
    c.Contrato
FROM
    CONTRATO c
LEFT JOIN
    INCIDENTE_TI it ON c.IdDepar = it.IdDepar
WHERE
    it.IdDepar IS NULL;


-- 2.3.1 Listar todos os nomes dos clientes com caso
SELECT DISTINCT
    c.Nome AS NomeCliente
FROM
    CLIENTE c
JOIN
    CASO ca ON c.IdCliente = ca.IdCliente;

-- 2.3.2. Listar os nome de todos os clientes com processos
SELECT DISTINCT
    c.Nome AS NomeCliente
FROM
    CLIENTE c
JOIN
    PROCESSO p ON c.IdCliente = p.IdCliente;

-- 2.3.3. Exibir o nome do trabalhador e do cliente
SELECT
    t.Nome AS NomeTrabalhador,
    c.Nome AS NomeCliente
FROM
    TRABALHADOR t
JOIN
    CLIENTE c ON t.Id_trabalhador = c.Id_trabalhador;


-- 2.3.4 Exibindo a descrição do processo e a data da audiência
SELECT
    p.Descricao AS DescricaoProcesso,
    a.Data AS DataAudiencia
FROM
    PROCESSO p
JOIN
    AUDIENCIA a ON p.IdCliente = a.IdCliente AND p.IdOrgReg = a.IdOrgReg;

-- 2.3.5 Realizando a junção total entre Trabalhador e advogado
SELECT
    t.Id_trabalhador,
    t.Nome,
    'Trabalhador' AS Tipo
FROM
    TRABALHADOR t
LEFT JOIN
    ADVOGADO a ON t.Id_trabalhador = a.Id_trabalhador
WHERE
    a.Id_trabalhador IS NULL

UNION

SELECT
    a.Id_trabalhador,
    t.Nome,
    'Advogado' AS Tipo
FROM
    ADVOGADO a
LEFT JOIN
    TRABALHADOR t ON t.Id_trabalhador = a.Id_trabalhador

UNION

SELECT
    t.Id_trabalhador,
    t.Nome,
    'Trabalhador e Advogado' AS Tipo
FROM
    TRABALHADOR t
JOIN
    ADVOGADO a ON t.Id_trabalhador = a.Id_trabalhador;

-- 2.3.6 Junção externa total de PROCESSO E AUDIENCIA
SELECT
    p.IdProc,
    p.Descricao AS DescricaoProcesso,
    a.IdAudi AS IdAudiencia,
    a.Data AS DataAudiencia,
    'Processo' AS Tipo
FROM
    PROCESSO p
LEFT JOIN
    AUDIENCIA a ON p.IdCliente = a.IdCliente AND p.IdOrgReg = a.IdOrgReg
WHERE
    a.IdAudi IS NULL

UNION

SELECT
    p.IdProc,
    p.Descricao AS DescricaoProcesso,
    a.IdAudi AS IdAudiencia,
    a.Data AS DataAudiencia,
    'Audiencia' AS Tipo
FROM
    AUDIENCIA a
LEFT JOIN
    PROCESSO p ON p.IdCliente = a.IdCliente AND p.IdOrgReg = a.IdOrgReg
WHERE
    p.IdProc IS NULL

UNION

SELECT
    p.IdProc,
    p.Descricao AS DescricaoProcesso,
    a.IdAudi AS IdAudiencia,
    a.Data AS DataAudiencia,
    'Processo e Audiência' AS Tipo
FROM
    PROCESSO p
JOIN
    AUDIENCIA a ON p.IdCliente = a.IdCliente AND p.IdOrgReg = a.IdOrgReg;
    
-- 2.3.7 Exibindo todos os dados de contrato e RH
SELECT
    c.IdDepar AS Departamento,
    c.DataAdmissao AS DataAdmissaoContrato,
    c.Contrato AS ContratoDescricao,
    r.AvaliacaoDesempenho AS AvaliacaoDesempenhoRH,
    r.DataAdmissao AS DataAdmissaoRH,
    r.Contrato AS ContratoDescricaoRH,
    'Contrato' AS Tipo
FROM
    CONTRATO c
LEFT JOIN
    RH r ON c.IdDepar = r.IdDepar
WHERE
    r.IdDepar IS NULL

UNION

SELECT
    c.IdDepar AS Departamento,
    c.DataAdmissao AS DataAdmissaoContrato,
    c.Contrato AS ContratoDescricao,
    r.AvaliacaoDesempenho AS AvaliacaoDesempenhoRH,
    r.DataAdmissao AS DataAdmissaoRH,
    r.Contrato AS ContratoDescricaoRH,
    'RH' AS Tipo
FROM
    RH r
LEFT JOIN
    CONTRATO c ON r.IdDepar = c.IdDepar
WHERE
    c.IdDepar IS NULL

UNION

SELECT
    c.IdDepar AS Departamento,
    c.DataAdmissao AS DataAdmissaoContrato,
    c.Contrato AS ContratoDescricao,
    r.AvaliacaoDesempenho AS AvaliacaoDesempenhoRH,
    r.DataAdmissao AS DataAdmissaoRH,
    r.Contrato AS ContratoDescricaoRH,
    'Contrato e RH' AS Tipo
FROM
    CONTRATO c
JOIN
    RH r ON c.IdDepar = r.IdDepar;

-- 2.3.8. Exibindo todos os dados entre o financeiro e as despesas
SELECT
    f.IdDepar AS Departamento,
    f.Receita AS ReceitaFinanceira,
    d.Despesa AS DespesaFinanceira,
    'Financeiro' AS Tipo
FROM
    FINANCEIRO f
LEFT JOIN
    DESPESA_FIN d ON f.IdDepar = d.IdDepar
WHERE
    d.IdDepar IS NULL

UNION

SELECT
    f.IdDepar AS Departamento,
    f.Receita AS ReceitaFinanceira,
    d.Despesa AS DespesaFinanceira,
    'Despesa' AS Tipo
FROM
    DESPESA_FIN d
LEFT JOIN
    FINANCEIRO f ON d.IdDepar = f.IdDepar
WHERE
    f.IdDepar IS NULL

UNION

SELECT
    f.IdDepar AS Departamento,
    f.Receita AS ReceitaFinanceira,
    d.Despesa AS DespesaFinanceira,
    'Financeiro e Despesa' AS Tipo
FROM
    FINANCEIRO f
JOIN
    DESPESA_FIN d ON f.IdDepar = d.IdDepar;

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

-- 2.3.13 Listar todos os registros de TRABALHADOR e ADVOGADO, mostrando todas as pessoas que possuem qualquer uma dessas relac ̧  ̃oes, incluindo trabalhadores sem registros de advogado
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

    
-- 2.4.1 Nosso objetivo é listar os trabalhadores que participaram de todas as audiências disponíveis na advocacia 		|ESTRANHO! Mas justificável, falta povoar|
SELECT t.Id_trabalhador, t.Nome
FROM (
    SELECT Id_trabalhador, COUNT(IdAudi) AS Participacoes
    FROM ADV_AUDIENCIA
    GROUP BY Id_trabalhador
) AS ParticipacoesPorTrabalhador
JOIN TRABALHADOR t ON ParticipacoesPorTrabalhador.Id_trabalhador = t.Id_trabalhador
WHERE Participacoes = (SELECT COUNT(*) FROM AUDIENCIA);

    
-- 2.4.2. Nosso objetivo é encontrar contratos associados a todos os Departamentos da advocacia
WITH DepartamentosAdvocacia AS (
    SELECT
        d.IdDepar
    FROM
        DEPARTAMENTO d
    JOIN
        ADVOCACIA a ON d.IdDepar = a.IdDepar
)

SELECT
    c.IdDepar AS DepartamentoID,
    c.Contrato
FROM
    CONTRATO c
JOIN
    DepartamentosAdvocacia da ON c.IdDepar = da.IdDepar
ORDER BY
    c.IdDepar;

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

-- 2.5.3: Contar o numero de trabalhadores por audiência
SELECT 
    IdAudi,
    COUNT(Id_trabalhador) AS QuantidadeTrabalhadores
FROM 
    ADV_AUDIENCIA
GROUP BY 
    IdAudi;
-- 2.5.4. Contar o numero de trabalhadores.
SELECT
    COUNT(*) AS NumeroTrabalhadores
FROM
    TRABALHADOR;

-- 2.5.5. Contar o número de trabalhadores associados a stakeholders
SELECT
    COUNT(DISTINCT t.Id_trabalhador) AS NumeroTrabalhadores
FROM
    TRABALHADOR t
JOIN
    STAKEHOLDERS s ON t.Id_trabalhador = s.Id_trabalhador;


-- 2.5.6. Contar o numero de trabalhadores associados a advogados    
SELECT
    COUNT(DISTINCT t.Id_trabalhador) AS NumeroTrabalhadores
FROM
    TRABALHADOR t
JOIN
    ADVOGADO a ON t.Id_trabalhador = a.Id_trabalhador;

-- 2.5.7. Contar o número de contratos por departamento
SELECT
    d.IdDepar AS Departamento,
    COUNT(c.Contrato) AS NumeroDeContratos
FROM
    DEPARTAMENTO d
LEFT JOIN
    CONTRATO c ON d.IdDepar = c.IdDepar
GROUP BY
    d.IdDepar
ORDER BY
    d.IdDepar;
    
-- 2.5.8. Contar o número de departamento
SELECT
    COUNT(*) AS NumeroDeDepartamentos
FROM
    DEPARTAMENTO;
    
-- 2.5.9. Contar os trabalhadores com o maior número de livros em suas bibliotecas
WITH MaxLivros AS (
    SELECT
        MAX(b.QtdLivro) AS MaxLivros
    FROM
        BIBLIOTECA_JURI b
)

SELECT
    COUNT(*) AS NumeroDeTrabalhadores
FROM
    BIBLIOTECA_JURI b
JOIN
    MaxLivros m ON b.QtdLivro = m.MaxLivros
JOIN
    TRABALHADOR t ON b.Id_trabalhador = t.Id_trabalhador;


-- 2.5.10. Contar os órgãos reguladores com o maior número de audiências analisadas
WITH MaxAudiencias AS (
    SELECT
        IdOrgReg,
        COUNT(IdAudi) AS NumeroDeAudiencias
    FROM
        AUDIENCIA
    GROUP BY
        IdOrgReg
),
MaxAudienciaCount AS (
    SELECT
        MAX(NumeroDeAudiencias) AS MaxAudiencias
    FROM
        MaxAudiencias
)

SELECT
    COUNT(*) AS NumeroDeOrgaosReguladores
FROM
    MaxAudiencias ma
JOIN
    MaxAudienciaCount mac ON ma.NumeroDeAudiencias = mac.MaxAudiencias;

