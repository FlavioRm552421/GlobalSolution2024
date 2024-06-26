--INTEGRANTES DO GRUPO
---RM 552421 - Flavio Sousa Vasconcelos
---RM  97887 - Jo�o Carlos Fran�a Figueiredo
---RM 550200 - Leonardo Oliveira Esparza
---RM 552368 - Wellington Urcino


-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2024-06-03 22:20:21 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g


DROP TABLE gs_bairro CASCADE CONSTRAINTS;

DROP TABLE gs_cidade CASCADE CONSTRAINTS;

DROP TABLE gs_cooperados CASCADE CONSTRAINTS;

DROP TABLE gs_cooperativa CASCADE CONSTRAINTS;

DROP TABLE gs_endereco CASCADE CONSTRAINTS;

DROP TABLE gs_estado CASCADE CONSTRAINTS;

DROP TABLE gs_materiais CASCADE CONSTRAINTS;

DROP TABLE gs_pais CASCADE CONSTRAINTS;

DROP TABLE gs_pedido CASCADE CONSTRAINTS;

DROP TABLE gs_regiao CASCADE CONSTRAINTS;

DROP TABLE gs_status CASCADE CONSTRAINTS;

DROP TABLE gs_usuario CASCADE CONSTRAINTS;


--CRIANDO AS TABELAS

-- Tabelas e Constraints

CREATE TABLE gs_pais (
    cod_pais  INTEGER NOT NULL,
    nome_pais VARCHAR2(30 BYTE) NOT NULL,
    CONSTRAINT gs_pais_pk PRIMARY KEY (cod_pais)
);

CREATE TABLE gs_estado (
    cod_estado INTEGER NOT NULL,
    nome_estado VARCHAR2(30 BYTE) NOT NULL,
    cod_pais INTEGER NOT NULL,
    CONSTRAINT cod_estado_pk PRIMARY KEY (cod_estado),
    CONSTRAINT cod_pais_fk FOREIGN KEY (cod_pais) REFERENCES gs_pais(cod_pais)
);

CREATE TABLE gs_regiao (
    cod_regiao INTEGER NOT NULL,
    nome_regiao VARCHAR2(30 BYTE) NOT NULL,
    CONSTRAINT cod_regiao_pk PRIMARY KEY (cod_regiao)
);

CREATE TABLE gs_cidade (
    cod_cidade INTEGER NOT NULL,
    nome_cidade VARCHAR2(30 BYTE) NOT NULL,
    cod_estado INTEGER NOT NULL,
    CONSTRAINT cod_cidade_pk PRIMARY KEY (cod_cidade),
    CONSTRAINT cod_estado_fk FOREIGN KEY (cod_estado) REFERENCES gs_estado(cod_estado)
);

CREATE TABLE gs_bairro (
    cod_bairro INTEGER NOT NULL,
    nome_bairro VARCHAR2(30 BYTE) NOT NULL,
    cod_cidade INTEGER NOT NULL,
    cod_regiao INTEGER NOT NULL,
    CONSTRAINT cod_bairro_pk PRIMARY KEY (cod_bairro),
    CONSTRAINT cod_cidade_fk FOREIGN KEY (cod_cidade) REFERENCES gs_cidade(cod_cidade),
    CONSTRAINT cod_regiao_fk FOREIGN KEY (cod_regiao) REFERENCES gs_regiao(cod_regiao)
);

CREATE TABLE gs_endereco (
    cod_endereco INTEGER NOT NULL,
    logradouro VARCHAR2(60 BYTE),
    nr_logradouro INTEGER,
    complemento VARCHAR2(60 BYTE),
    referencia VARCHAR2(60 BYTE),
    nr_cep VARCHAR2(8 BYTE),
    cod_bairro INTEGER NOT NULL,
    CONSTRAINT cod_endereco_pk PRIMARY KEY (cod_endereco),
    CONSTRAINT cod_bairro_fk FOREIGN KEY (cod_bairro) REFERENCES gs_bairro(cod_bairro)
);

CREATE TABLE gs_usuario (
    cod_usuario INTEGER NOT NULL,
    nome_usuario VARCHAR2(60 BYTE),
    cod_endereco INTEGER,
    CONSTRAINT cod_usuario_pk PRIMARY KEY (cod_usuario),
    CONSTRAINT cod_end_user_fk FOREIGN KEY (cod_endereco) REFERENCES gs_endereco(cod_endereco)
);

CREATE TABLE gs_cooperativa (
    cod_cooperativa INTEGER NOT NULL,
    nome_cooperativa VARCHAR2(60 BYTE),
    cod_endereco INTEGER,
    gs_cooperativa_id INTEGER NOT NULL,
    CONSTRAINT gs_cooperativa_pk PRIMARY KEY (gs_cooperativa_id),
    CONSTRAINT cod_end_coop_fk FOREIGN KEY (cod_endereco) REFERENCES gs_endereco(cod_endereco)
);

ALTER TABLE gs_cooperativa
MODIFY gs_cooperativa_id INTEGER NULL;

CREATE TABLE gs_cooperados (
    cod_cooperado INTEGER NOT NULL,
    nome_cooperado VARCHAR2(60 BYTE),
    cod_endereco INTEGER,
    cod_cooperativa INTEGER NOT NULL,
    CONSTRAINT cod_coop_pk PRIMARY KEY (cod_cooperado),
    CONSTRAINT cod_end_fk FOREIGN KEY (cod_endereco) REFERENCES gs_endereco(cod_endereco),
    CONSTRAINT cod_coop_id_fk FOREIGN KEY (cod_cooperativa) REFERENCES gs_cooperativa(gs_cooperativa_id)
);

CREATE TABLE gs_status (
    cod_status INTEGER NOT NULL,
    tipo_status VARCHAR2(30 BYTE),
    CONSTRAINT cod_status_pk PRIMARY KEY (cod_status)
);

CREATE TABLE gs_pedido (
    cod_pedido INTEGER NOT NULL,
    data_pedido DATE,
    qtde_itens INTEGER,
    cod_material INTEGER,
    cod_usuario INTEGER,
    cod_status INTEGER,
    cod_cooperado INTEGER,
    CONSTRAINT cod_pedido_pk PRIMARY KEY (cod_pedido),
    CONSTRAINT cod_status_fk FOREIGN KEY (cod_status) REFERENCES gs_status(cod_status),
    CONSTRAINT cod_usuario_fk FOREIGN KEY (cod_usuario) REFERENCES gs_usuario(cod_usuario),
    CONSTRAINT cod_cooperado_fk FOREIGN KEY (cod_cooperado) REFERENCES gs_cooperados(cod_cooperado)
);

CREATE TABLE gs_materiais (
    cod_material INTEGER NOT NULL,
    nome_material VARCHAR2(30 BYTE),
    tipo_material VARCHAR2(30 BYTE),
    cod_pedido INTEGER NOT NULL,
    CONSTRAINT cod_materiais_pk PRIMARY KEY (cod_material),
    CONSTRAINT cod_pedido_fk FOREIGN KEY (cod_pedido) REFERENCES gs_pedido(cod_pedido)
);

ALTER TABLE gs_materiais
MODIFY cod_pedido INTEGER NULL;

-- Sequence e Trigger para gs_cooperativa

CREATE SEQUENCE gs_cooperativa_gs_cooperativa_ START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER gs_cooperativa_gs_cooperativa_ BEFORE
    INSERT ON gs_cooperativa
    FOR EACH ROW
    WHEN (new.gs_cooperativa_id IS NULL)
BEGIN
    :new.gs_cooperativa_id := gs_cooperativa_gs_cooperativa_.nextval;
END;
/


--POPULANDO DADOS PAIS

INSERT INTO gs_pais (cod_pais, nome_pais) VALUES (1, 'Brasil');
INSERT INTO gs_pais (cod_pais, nome_pais) VALUES (2, 'Estados Unidos');
INSERT INTO gs_pais (cod_pais, nome_pais) VALUES (3, 'Canad�');
INSERT INTO gs_pais (cod_pais, nome_pais) VALUES (4, 'Alemanha');
INSERT INTO gs_pais (cod_pais, nome_pais) VALUES (5, 'Jap�o');

COMMIT;

--POPULANDO DADOS ESTADO

INSERT INTO gs_estado (cod_estado, nome_estado, cod_pais) VALUES (1, 'S�o Paulo', 1);
INSERT INTO gs_estado (cod_estado, nome_estado, cod_pais) VALUES (2, 'Rio de Janeiro', 1);
INSERT INTO gs_estado (cod_estado, nome_estado, cod_pais) VALUES (3, 'Minas Gerais', 1);
INSERT INTO gs_estado (cod_estado, nome_estado, cod_pais) VALUES (4, 'Bahia', 1);
INSERT INTO gs_estado (cod_estado, nome_estado, cod_pais) VALUES (5, 'Paran�', 1);

COMMIT;

--POPULANDO DADOS CIDADE

INSERT INTO gs_cidade (cod_cidade, nome_cidade, cod_estado) VALUES (1, 'S�o Paulo', 1);
INSERT INTO gs_cidade (cod_cidade, nome_cidade, cod_estado) VALUES (2, 'Campinas', 1);
INSERT INTO gs_cidade (cod_cidade, nome_cidade, cod_estado) VALUES (3, 'Santos', 1);
INSERT INTO gs_cidade (cod_cidade, nome_cidade, cod_estado) VALUES (4, 'Sorocaba', 1);
INSERT INTO gs_cidade (cod_cidade, nome_cidade, cod_estado) VALUES (5, 'S�o Jos� dos Campos', 1);

COMMIT;

--POPULANDO DADOS REGI�O

INSERT INTO gs_regiao (cod_regiao, nome_regiao) VALUES (1, 'Sul');
INSERT INTO gs_regiao (cod_regiao, nome_regiao) VALUES (2, 'Norte');
INSERT INTO gs_regiao (cod_regiao, nome_regiao) VALUES (3, 'Leste');
INSERT INTO gs_regiao (cod_regiao, nome_regiao) VALUES (4, 'Oeste');

COMMIT; 

--POPULANDO DADOS BAIRRO

INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (1, 'Bairro Sul 1', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (2, 'Bairro Sul 2', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (3, 'Bairro Sul 3', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (4, 'Bairro Sul 4', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (5, 'Bairro Sul 5', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (6, 'Bairro Sul 6', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (7, 'Bairro Sul 7', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (8, 'Bairro Sul 8', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (9, 'Bairro Sul 9', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (10, 'Bairro Sul 10', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (11, 'Bairro Sul 11', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (12, 'Bairro Sul 12', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (13, 'Bairro Sul 13', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (14, 'Bairro Sul 14', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (15, 'Bairro Sul 15', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (16, 'Bairro Sul 16', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (17, 'Bairro Sul 17', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (18, 'Bairro Sul 18', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (19, 'Bairro Sul 19', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (20, 'Bairro Sul 20', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (21, 'Bairro Sul 21', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (22, 'Bairro Sul 22', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (23, 'Bairro Sul 23', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (24, 'Bairro Sul 24', 1, 1);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (25, 'Bairro Sul 25', 1, 1);
COMMIT;

INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (26, 'Bairro Norte 1', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (27, 'Bairro Norte 2', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (28, 'Bairro Norte 3', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (29, 'Bairro Norte 4', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (30, 'Bairro Norte 5', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (31, 'Bairro Norte 6', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (32, 'Bairro Norte 7', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (33, 'Bairro Norte 8', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (34, 'Bairro Norte 9', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (35, 'Bairro Norte 10', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (36, 'Bairro Norte 11', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (37, 'Bairro Norte 12', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (38, 'Bairro Norte 13', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (39, 'Bairro Norte 14', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (40, 'Bairro Norte 15', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (41, 'Bairro Norte 16', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (42, 'Bairro Norte 17', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (43, 'Bairro Norte 18', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (44, 'Bairro Norte 19', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (45, 'Bairro Norte 20', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (46, 'Bairro Norte 21', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (47, 'Bairro Norte 22', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (48, 'Bairro Norte 23', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (49, 'Bairro Norte 24', 1, 2);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (50, 'Bairro Norte 25', 1, 2);
COMMIT;

INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (51, 'Bairro Leste 1', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (52, 'Bairro Leste 2', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (53, 'Bairro Leste 3', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (54, 'Bairro Leste 4', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (55, 'Bairro Leste 5', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (56, 'Bairro Leste 6', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (57, 'Bairro Leste 7', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (58, 'Bairro Leste 8', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (59, 'Bairro Leste 9', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (60, 'Bairro Leste 10', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (61, 'Bairro Leste 11', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (62, 'Bairro Leste 12', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (63, 'Bairro Leste 13', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (64, 'Bairro Leste 14', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (65, 'Bairro Leste 15', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (66, 'Bairro Leste 16', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (67, 'Bairro Leste 17', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (68, 'Bairro Leste 18', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (69, 'Bairro Leste 19', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (70, 'Bairro Leste 20', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (71, 'Bairro Leste 21', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (72, 'Bairro Leste 22', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (73, 'Bairro Leste 23', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (74, 'Bairro Leste 24', 1, 3);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (75, 'Bairro Leste 25', 1, 3);
COMMIT;

INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (76, 'Bairro Oeste 1', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (77, 'Bairro Oeste 2', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (78, 'Bairro Oeste 3', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (79, 'Bairro Oeste 4', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (80, 'Bairro Oeste 5', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (81, 'Bairro Oeste 6', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (82, 'Bairro Oeste 7', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (83, 'Bairro Oeste 8', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (84, 'Bairro Oeste 9', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (85, 'Bairro Oeste 10', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (86, 'Bairro Oeste 11', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (87, 'Bairro Oeste 12', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (88, 'Bairro Oeste 13', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (89, 'Bairro Oeste 14', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (90, 'Bairro Oeste 15', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (91, 'Bairro Oeste 16', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (92, 'Bairro Oeste 17', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (93, 'Bairro Oeste 18', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (94, 'Bairro Oeste 19', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (95, 'Bairro Oeste 20', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (96, 'Bairro Oeste 21', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (97, 'Bairro Oeste 22', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (98, 'Bairro Oeste 23', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (99, 'Bairro Oeste 24', 1, 4);
INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) VALUES (100, 'Bairro Oeste 25', 1, 4);
COMMIT;

--POPULANDO DADOS ENDERE�O

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (1,'Rua das Flores',123,'Apartamento 101','Pr�ximo � pra�a central','1234567',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (2,'Avenida das Palmeiras',456,'Casa Amarela','Ao lado do supermercado','98765432',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (3,'Travessa das Violetas',789,'Sem complemento','Pr�ximo � escola prim�ria','54321098',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (4,'Rua dos Girass�is',321,'Casa Verde','Perto da farm�cia','13579246',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (5,'Avenida dos Jasmins',654,'Apartamento 202','Ao lado do parque','67890123',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (6,'Pra�a das Orqu�deas',987,'Casa Azul','Pr�ximo ao hospital','24680135',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (7,'Alameda dos Cravos',246,'Sem complemento','Perto da esta��o de �nibus','75309864',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (8,'Rua das Hort�nsias',135,'Casa Branca','Pr�ximo � biblioteca','86420975',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (9,'Travessa dos L�rios',579,'Apartamento 303','Ao lado da academia','1234567',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (10,'Avenida dos Ant�rios',741,'Casa Vermelha','Pr�ximo ao cinema','78901234',1);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (11,'Rua das Estrelas',456,'Sem complemento','Pr�ximo � padaria','1234567',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (12,'Avenida dos Planetas',789,'Casa Amarela','Ao lado da pra�a','98765432',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (13,'Travessa das Gal�xias',123,'Apartamento 303','Pr�ximo ao mercado','54321098',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (14,'Rua dos Cometas',987,'Casa Verde','Perto do posto de gasolina','13579246',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (15,'Avenida dos Meteoros',321,'Apartamento 404','Ao lado da escola','67890123',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (16,'Pra�a das Constela��es',654,'Casa Azul','Pr�ximo � igreja','24680135',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (17,'Alameda dos Asteroides',246,'Sem complemento','Perto da praia','75309864',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (18,'Rua das Luas',135,'Casa Branca','Pr�ximo � biblioteca','86420975',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (19,'Travessa dos S�is',579,'Apartamento 505','Ao lado do parque','1234567',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (20,'Avenida das Nebulosas',741,'Casa Vermelha','Pr�ximo ao teatro','78901234',2);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (21,'Rua da Paz',123,'Sem complemento','Pr�ximo � pra�a central','1234567',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (22,'Avenida da Esperan�a',456,'Casa Verde','Ao lado do supermercado','98765432',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (23,'Travessa da Alegria',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (24,'Rua do Amor',321,'Casa Amarela','Perto da farm�cia','13579246',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (25,'Avenida da Felicidade',654,'Apartamento 202','Ao lado do parque','67890123',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (26,'Pra�a da Harmonia',987,'Sem complemento','Pr�ximo ao hospital','24680135',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (27,'Alameda da Uni�o',246,'Casa Azul','Perto da esta��o de �nibus','75309864',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (28,'Rua da Solidariedade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (29,'Travessa da Compaix�o',579,'Casa Branca','Ao lado da academia','1234567',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (30,'Avenida da Generosidade',741,'Apartamento 303','Pr�ximo ao cinema','78901234',3);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (31,'Rua da Liberdade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (32,'Avenida da Justi�a',789,'Sem complemento','Ao lado da pra�a','98765432',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (33,'Travessa da Igualdade',123,'Apartamento 303','Pr�ximo ao mercado','54321098',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (34,'Rua da Democracia',987,'Casa Amarela','Perto do posto de gasolina','13579246',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (35,'Avenida da Fraternidade',321,'Casa Verde','Ao lado da escola','67890123',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (36,'Pra�a da Toler�ncia',654,'Apartamento 404','Pr�ximo � igreja','24680135',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (37,'Alameda da Paz',246,'Sem complemento','Perto da praia','75309864',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (38,'Rua da Harmonia',135,'Casa Branca','Pr�ximo � biblioteca','86420975',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (39,'Travessa da Conviv�ncia',579,'Sem complemento','Ao lado do parque','1234567',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (40,'Avenida da Cidadania',741,'Casa Azul','Pr�ximo ao teatro','78901234',4);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (41,'Rua das Maravilhas',123,'Sem complemento','Pr�ximo � pra�a central','1234567',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (42,'Avenida da Fantasia',456,'Casa Verde','Ao lado do supermercado','98765432',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (43,'Travessa dos Sonhos',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (44,'Rua da Aventura',321,'Casa Amarela','Perto da farm�cia','13579246',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (45,'Avenida da Imagina��o',654,'Apartamento 202','Ao lado do parque','67890123',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (46,'Pra�a da Magia',987,'Sem complemento','Pr�ximo ao hospital','24680135',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (47,'Alameda da Fic��o',246,'Casa Azul','Perto da esta��o de �nibus','75309864',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (48,'Rua da Ilus�o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (49,'Travessa do Encantamento',579,'Casa Branca','Ao lado da academia','1234567',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (50,'Avenida da Inspirac�o',741,'Apartamento 303','Pr�ximo ao cinema','78901234',5);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (51,'Rua da Sabedoria',456,'Casa Vermelha','Pr�ximo � padaria','1234567',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (52,'Avenida da Intelig�ncia',789,'Sem complemento','Ao lado da pra�a','98765432',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (53,'Travessa do Conhecimento',123,'Apartamento 303','Pr�ximo ao mercado','54321098',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (54,'Rua da Educa��o',987,'Casa Amarela','Perto do posto de gasolina','13579246',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (55,'Avenida do Aprendizado',321,'Casa Verde','Ao lado da escola','67890123',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (56,'Pra�a do Saber',654,'Apartamento 404','Pr�ximo � igreja','24680135',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (57,'Alameda do Conhecimento',246,'Sem complemento','Perto da praia','75309864',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (58,'Rua da Experi�ncia',135,'Casa Branca','Pr�ximo � biblioteca','86420975',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (59,'Travessa da Descoberta',579,'Sem complemento','Ao lado do parque','1234567',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (60,'Avenida da Inova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',6);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (61,'Rua da Harmonia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (62,'Avenida da Tranquilidade',456,'Casa Verde','Ao lado do supermercado','98765432',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (63,'Travessa da Serenidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (64,'Rua da Paz Interior',321,'Casa Amarela','Perto da farm�cia','13579246',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (65,'Avenida do Equil�brio',654,'Apartamento 202','Ao lado do parque','67890123',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (66,'Pra�a da Calma',987,'Sem complemento','Pr�ximo ao hospital','24680135',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (67,'Alameda da Plenitude',246,'Casa Azul','Perto da esta��o de �nibus','75309864',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (68,'Rua da Conex�o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (69,'Travessa da Introspec��o',579,'Casa Branca','Ao lado da academia','1234567',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (70,'Avenida da Consci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',7);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (71,'Rua da Prosperidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (72,'Avenida da Abund�ncia',789,'Sem complemento','Ao lado da pra�a','98765432',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (73,'Travessa da Riqueza',123,'Apartamento 303','Pr�ximo ao mercado','54321098',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (74,'Rua da Fortuna',987,'Casa Amarela','Perto do posto de gasolina','13579246',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (75,'Avenida da Opul�ncia',321,'Casa Verde','Ao lado da escola','67890123',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (76,'Pra�a da Prosperidade',654,'Apartamento 404','Pr�ximo � igreja','24680135',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (77,'Alameda da Felicidade',246,'Sem complemento','Perto da praia','75309864',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (78,'Rua da Sorte',135,'Casa Branca','Pr�ximo � biblioteca','86420975',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (79,'Travessa da Plenitude',579,'Sem complemento','Ao lado do parque','1234567',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (80,'Avenida da Bonan�a',741,'Casa Azul','Pr�ximo ao teatro','78901234',8);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (81,'Rua da Energia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (82,'Avenida da Vitalidade',456,'Casa Verde','Ao lado do supermercado','98765432',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (83,'Travessa da For�a',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (84,'Rua da Resist�ncia',321,'Casa Amarela','Perto da farm�cia','13579246',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (85,'Avenida da Sa�de',654,'Apartamento 202','Ao lado do parque','67890123',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (86,'Pra�a da Longevidade',987,'Sem complemento','Pr�ximo ao hospital','24680135',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (87,'Alameda da Resili�ncia',246,'Casa Azul','Perto da esta��o de �nibus','75309864',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (88,'Rua da Supera��o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (89,'Travessa da Flexibilidade',579,'Casa Branca','Ao lado da academia','1234567',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (90,'Avenida da Resist�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',9);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (91,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (92,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (93,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (94,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (95,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (96,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (97,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (98,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (99,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',10);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (100,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',10);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (101,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (102,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (103,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (104,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (105,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (106,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (107,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (108,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (109,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (110,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',11);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (111,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (112,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (113,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (114,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (115,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (116,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (117,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (118,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (119,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (120,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',12);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (121,'Rua da Liberdade',123,'Sem complemento','Pr�ximo � pra�a central','1234567',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (122,'Avenida da Democracia',456,'Casa Verde','Ao lado do supermercado','98765432',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (123,'Travessa da Igualdade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (124,'Rua da Justi�a',321,'Casa Amarela','Perto da farm�cia','13579246',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (125,'Avenida da Equidade',654,'Apartamento 202','Ao lado do parque','67890123',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (126,'Pra�a da Cidadania',987,'Sem complemento','Pr�ximo ao hospital','24680135',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (127,'Alameda dos Direitos Humanos',246,'Casa Azul','Perto da esta��o de �nibus','75309864',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (128,'Rua da Fraternidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (129,'Travessa da Solidariedade',579,'Casa Branca','Ao lado da academia','1234567',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (130,'Avenida da Toler�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',13);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (131,'Rua da Harmonia',456,'Casa Vermelha','Pr�ximo � padaria','1234567',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (132,'Avenida da Paz',789,'Sem complemento','Ao lado da pra�a','98765432',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (133,'Travessa da Serenidade',123,'Apartamento 303','Pr�ximo ao mercado','54321098',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (134,'Rua da Tranquilidade',987,'Casa Amarela','Perto do posto de gasolina','13579246',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (135,'Avenida do Equil�brio',321,'Casa Verde','Ao lado da escola','67890123',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (136,'Pra�a da Calma',654,'Apartamento 404','Pr�ximo � igreja','24680135',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (137,'Alameda da Conex�o',246,'Sem complemento','Perto da praia','75309864',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (138,'Rua da Uni�o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (139,'Travessa da Compaix�o',579,'Sem complemento','Ao lado do parque','1234567',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (140,'Avenida da Generosidade',741,'Casa Azul','Pr�ximo ao teatro','78901234',14);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (141,'Rua das Estrelas',123,'Sem complemento','Pr�ximo � pra�a central','1234567',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (142,'Avenida da Lua',456,'Casa Verde','Ao lado do supermercado','98765432',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (143,'Travessa dos Planetas',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (144,'Rua dos Astros',321,'Casa Amarela','Perto da farm�cia','13579246',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (145,'Avenida dos Cometas',654,'Apartamento 202','Ao lado do parque','67890123',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (146,'Pra�a das Constela��es',987,'Sem complemento','Pr�ximo ao hospital','24680135',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (147,'Alameda das Gal�xias',246,'Casa Azul','Perto da esta��o de �nibus','75309864',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (148,'Rua dos Universos',135,'Sem complemento','Pr�ximo � biblioteca','86420975',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (149,'Travessa dos Nebulosas',579,'Casa Branca','Ao lado da academia','1234567',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (150,'Avenida dos Meteoritos',741,'Apartamento 303','Pr�ximo ao cinema','78901234',15);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (151,'Rua das Maravilhas',456,'Casa Vermelha','Pr�ximo � padaria','1234567',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (152,'Avenida dos Encantos',789,'Sem complemento','Ao lado da pra�a','98765432',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (153,'Travessa da Magia',123,'Apartamento 303','Pr�ximo ao mercado','54321098',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (154,'Rua dos Mist�rios',987,'Casa Amarela','Perto do posto de gasolina','13579246',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (155,'Avenida das Maravilhas',321,'Casa Verde','Ao lado da escola','67890123',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (156,'Pra�a dos Encantamentos',654,'Apartamento 404','Pr�ximo � igreja','24680135',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (157,'Alameda das Maravilhas',246,'Sem complemento','Perto da praia','75309864',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (158,'Rua da Fantasia',135,'Casa Branca','Pr�ximo � biblioteca','86420975',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (159,'Travessa do Sonho',579,'Sem complemento','Ao lado do parque','1234567',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (160,'Avenida da Ilus�o',741,'Casa Azul','Pr�ximo ao teatro','78901234',16);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (161,'Rua da Harmonia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (162,'Avenida da Tranquilidade',456,'Casa Verde','Ao lado do supermercado','98765432',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (163,'Travessa da Serenidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (164,'Rua da Paz Interior',321,'Casa Amarela','Perto da farm�cia','13579246',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (165,'Avenida do Equil�brio',654,'Apartamento 202','Ao lado do parque','67890123',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (166,'Pra�a da Calma',987,'Sem complemento','Pr�ximo ao hospital','24680135',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (167,'Alameda da Plenitude',246,'Casa Azul','Perto da esta��o de �nibus','75309864',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (168,'Rua da Conex�o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (169,'Travessa da Introspec��o',579,'Casa Branca','Ao lado da academia','1234567',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (170,'Avenida da Consci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',17);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (171,'Rua da Prosperidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (172,'Avenida da Abund�ncia',789,'Sem complemento','Ao lado da pra�a','98765432',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (173,'Travessa da Riqueza',123,'Apartamento 303','Pr�ximo ao mercado','54321098',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (174,'Rua da Fortuna',987,'Casa Amarela','Perto do posto de gasolina','13579246',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (175,'Avenida da Opul�ncia',321,'Casa Verde','Ao lado da escola','67890123',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (176,'Pra�a da Prosperidade',654,'Apartamento 404','Pr�ximo � igreja','24680135',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (177,'Alameda da Felicidade',246,'Sem complemento','Perto da praia','75309864',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (178,'Rua da Sorte',135,'Casa Branca','Pr�ximo � biblioteca','86420975',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (179,'Travessa da Plenitude',579,'Sem complemento','Ao lado do parque','1234567',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (180,'Avenida da Bonan�a',741,'Casa Azul','Pr�ximo ao teatro','78901234',18);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (181,'Rua da Energia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (182,'Avenida da Vitalidade',456,'Casa Verde','Ao lado do supermercado','98765432',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (183,'Travessa da For�a',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (184,'Rua da Resist�ncia',321,'Casa Amarela','Perto da farm�cia','13579246',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (185,'Avenida da Sa�de',654,'Apartamento 202','Ao lado do parque','67890123',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (186,'Pra�a da Longevidade',987,'Sem complemento','Pr�ximo ao hospital','24680135',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (187,'Alameda da Resili�ncia',246,'Casa Azul','Perto da esta��o de �nibus','75309864',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (188,'Rua da Supera��o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (189,'Travessa da Flexibilidade',579,'Casa Branca','Ao lado da academia','1234567',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (190,'Avenida da Resist�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',19);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (191,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (192,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (193,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (194,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (195,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (196,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (197,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (198,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (199,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',20);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (200,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',20);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (201,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (202,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (203,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (204,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (205,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (206,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (207,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (208,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (209,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (210,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',21);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (211,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (212,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (213,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (214,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (215,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (216,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (217,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (218,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (219,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (220,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',22);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (221,'Rua da Harmonia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (222,'Avenida da Tranquilidade',456,'Casa Verde','Ao lado do supermercado','98765432',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (223,'Travessa da Serenidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (224,'Rua da Paz Interior',321,'Casa Amarela','Perto da farm�cia','13579246',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (225,'Avenida do Equil�brio',654,'Apartamento 202','Ao lado do parque','67890123',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (226,'Pra�a da Calma',987,'Sem complemento','Pr�ximo ao hospital','24680135',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (227,'Alameda da Plenitude',246,'Casa Azul','Perto da esta��o de �nibus','75309864',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (228,'Rua da Conex�o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (229,'Travessa da Introspec��o',579,'Casa Branca','Ao lado da academia','1234567',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (230,'Avenida da Consci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',23);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (231,'Rua da Prosperidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (232,'Avenida da Abund�ncia',789,'Sem complemento','Ao lado da pra�a','98765432',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (233,'Travessa da Riqueza',123,'Apartamento 303','Pr�ximo ao mercado','54321098',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (234,'Rua da Fortuna',987,'Casa Amarela','Perto do posto de gasolina','13579246',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (235,'Avenida da Opul�ncia',321,'Casa Verde','Ao lado da escola','67890123',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (236,'Pra�a da Prosperidade',654,'Apartamento 404','Pr�ximo � igreja','24680135',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (237,'Alameda da Felicidade',246,'Sem complemento','Perto da praia','75309864',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (238,'Rua da Sorte',135,'Casa Branca','Pr�ximo � biblioteca','86420975',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (239,'Travessa da Plenitude',579,'Sem complemento','Ao lado do parque','1234567',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (240,'Avenida da Bonan�a',741,'Casa Azul','Pr�ximo ao teatro','78901234',24);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (241,'Rua da Esperan�a',123,'Sem complemento','Pr�ximo � pra�a central','1234567',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (242,'Avenida da F�',456,'Casa Verde','Ao lado do supermercado','98765432',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (243,'Travessa da Paz',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (244,'Rua da Caridade',321,'Casa Amarela','Perto da farm�cia','13579246',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (245,'Avenida da Gratid�o',654,'Apartamento 202','Ao lado do parque','67890123',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (246,'Pra�a da Esperan�a',987,'Sem complemento','Pr�ximo ao hospital','24680135',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (247,'Alameda da Solidariedade',246,'Casa Azul','Perto da esta��o de �nibus','75309864',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (248,'Rua da Generosidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (249,'Travessa da Felicidade',579,'Casa Branca','Ao lado da academia','1234567',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (250,'Avenida da Paz',741,'Apartamento 303','Pr�ximo ao cinema','78901234',25);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (251,'Rua da Harmonia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (252,'Avenida da Tranquilidade',456,'Casa Verde','Ao lado do supermercado','98765432',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (253,'Travessa da Serenidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (254,'Rua da Paz Interior',321,'Casa Amarela','Perto da farm�cia','13579246',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (255,'Avenida do Equil�brio',654,'Apartamento 202','Ao lado do parque','67890123',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (256,'Pra�a da Calma',987,'Sem complemento','Pr�ximo ao hospital','24680135',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (257,'Alameda da Plenitude',246,'Casa Azul','Perto da esta��o de �nibus','75309864',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (258,'Rua da Conex�o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (259,'Travessa da Introspec��o',579,'Casa Branca','Ao lado da academia','1234567',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (260,'Avenida da Consci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',26);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (261,'Rua da Prosperidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (262,'Avenida da Abund�ncia',789,'Sem complemento','Ao lado da pra�a','98765432',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (263,'Travessa da Riqueza',123,'Apartamento 303','Pr�ximo ao mercado','54321098',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (264,'Rua da Fortuna',987,'Casa Amarela','Perto do posto de gasolina','13579246',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (265,'Avenida da Opul�ncia',321,'Casa Verde','Ao lado da escola','67890123',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (266,'Pra�a da Prosperidade',654,'Apartamento 404','Pr�ximo � igreja','24680135',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (267,'Alameda da Felicidade',246,'Sem complemento','Perto da praia','75309864',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (268,'Rua da Sorte',135,'Casa Branca','Pr�ximo � biblioteca','86420975',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (269,'Travessa da Plenitude',579,'Sem complemento','Ao lado do parque','1234567',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (270,'Avenida da Bonan�a',741,'Casa Azul','Pr�ximo ao teatro','78901234',27);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (271,'Rua da Energia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (272,'Avenida da Vitalidade',456,'Casa Verde','Ao lado do supermercado','98765432',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (273,'Travessa da For�a',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (274,'Rua da Resist�ncia',321,'Casa Amarela','Perto da farm�cia','13579246',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (275,'Avenida da Sa�de',654,'Apartamento 202','Ao lado do parque','67890123',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (276,'Pra�a da Longevidade',987,'Sem complemento','Pr�ximo ao hospital','24680135',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (277,'Alameda da Resili�ncia',246,'Casa Azul','Perto da esta��o de �nibus','75309864',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (278,'Rua da Supera��o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (279,'Travessa da Flexibilidade',579,'Casa Branca','Ao lado da academia','1234567',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (280,'Avenida da Resist�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',28);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (281,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (282,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (283,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (284,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (285,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (286,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (287,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (288,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (289,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (290,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',29);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (291,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (292,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (293,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (294,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (295,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (296,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (297,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (298,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (299,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',30);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (300,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',30);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (301,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (302,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (303,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (304,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (305,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (306,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (307,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (308,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (309,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (310,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',31);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (311,'Rua da Serenidade',123,'Sem complemento','Pr�ximo � pra�a central','1234567',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (312,'Avenida da Paz Interior',456,'Casa Verde','Ao lado do supermercado','98765432',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (313,'Travessa da Tranquilidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (314,'Rua da Calma',321,'Casa Amarela','Perto da farm�cia','13579246',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (315,'Avenida da Plenitude',654,'Apartamento 202','Ao lado do parque','67890123',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (316,'Pra�a da Resili�ncia',987,'Sem complemento','Pr�ximo ao hospital','24680135',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (317,'Alameda da Supera��o',246,'Casa Azul','Perto da esta��o de �nibus','75309864',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (318,'Rua da Flexibilidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (319,'Travessa da Integridade',579,'Casa Branca','Ao lado da academia','1234567',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (320,'Avenida da For�a',741,'Apartamento 303','Pr�ximo ao cinema','78901234',32);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (321,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (322,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (323,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (324,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (325,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (326,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (327,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (328,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (329,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (330,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',33);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (331,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (332,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (333,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (334,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (335,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (336,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (337,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (338,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (339,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (340,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',34);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (341,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (342,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (343,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (344,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (345,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (346,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (347,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (348,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (349,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (350,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',35);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (351,'Rua da Harmonia',123,'Sem complemento','Pr�ximo � pra�a central','1234567',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (352,'Avenida da Tranquilidade',456,'Casa Verde','Ao lado do supermercado','98765432',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (353,'Travessa da Serenidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (354,'Rua da Paz Interior',321,'Casa Amarela','Perto da farm�cia','13579246',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (355,'Avenida do Equil�brio',654,'Apartamento 202','Ao lado do parque','67890123',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (356,'Pra�a da Calma',987,'Sem complemento','Pr�ximo ao hospital','24680135',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (357,'Alameda da Plenitude',246,'Casa Azul','Perto da esta��o de �nibus','75309864',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (358,'Rua da Conex�o',135,'Sem complemento','Pr�ximo � biblioteca','86420975',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (359,'Travessa da Introspec��o',579,'Casa Branca','Ao lado da academia','1234567',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (360,'Avenida da Consci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',36);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (361,'Rua da Prosperidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (362,'Avenida da Abund�ncia',789,'Sem complemento','Ao lado da pra�a','98765432',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (363,'Travessa da Riqueza',123,'Apartamento 303','Pr�ximo ao mercado','54321098',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (364,'Rua da Fortuna',987,'Casa Amarela','Perto do posto de gasolina','13579246',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (365,'Avenida da Opul�ncia',321,'Casa Verde','Ao lado da escola','67890123',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (366,'Pra�a da Prosperidade',654,'Apartamento 404','Pr�ximo � igreja','24680135',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (367,'Alameda da Felicidade',246,'Sem complemento','Perto da praia','75309864',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (368,'Rua da Sorte',135,'Casa Branca','Pr�ximo � biblioteca','86420975',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (369,'Travessa da Plenitude',579,'Sem complemento','Ao lado do parque','1234567',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (370,'Avenida da Bonan�a',741,'Casa Azul','Pr�ximo ao teatro','78901234',37);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (371,'Rua da Esperan�a',123,'Sem complemento','Pr�ximo � pra�a central','1234567',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (372,'Avenida da F�',456,'Casa Verde','Ao lado do supermercado','98765432',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (373,'Travessa da Paz',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (374,'Rua da Caridade',321,'Casa Amarela','Perto da farm�cia','13579246',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (375,'Avenida da Gratid�o',654,'Apartamento 202','Ao lado do parque','67890123',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (376,'Pra�a da Esperan�a',987,'Sem complemento','Pr�ximo ao hospital','24680135',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (377,'Alameda da Solidariedade',246,'Casa Azul','Perto da esta��o de �nibus','75309864',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (378,'Rua da Generosidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (379,'Travessa da Felicidade',579,'Casa Branca','Ao lado da academia','1234567',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (380,'Avenida da Paz',741,'Apartamento 303','Pr�ximo ao cinema','78901234',38);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (381,'Rua da Serenidade',123,'Sem complemento','Pr�ximo � pra�a central','1234567',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (382,'Avenida da Paz Interior',456,'Casa Verde','Ao lado do supermercado','98765432',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (383,'Travessa da Tranquilidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (384,'Rua da Calma',321,'Casa Amarela','Perto da farm�cia','13579246',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (385,'Avenida da Plenitude',654,'Apartamento 202','Ao lado do parque','67890123',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (386,'Pra�a da Resili�ncia',987,'Sem complemento','Pr�ximo ao hospital','24680135',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (387,'Alameda da Supera��o',246,'Casa Azul','Perto da esta��o de �nibus','75309864',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (388,'Rua da Flexibilidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (389,'Travessa da Integridade',579,'Casa Branca','Ao lado da academia','1234567',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (390,'Avenida da For�a',741,'Apartamento 303','Pr�ximo ao cinema','78901234',39);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (391,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (392,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (393,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (394,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (395,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (396,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (397,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (398,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (399,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',40);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (400,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',40);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (401,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (402,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (403,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (404,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (405,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (406,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (407,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (408,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (409,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (410,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',41);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (411,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (412,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (413,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (414,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (415,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (416,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (417,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (418,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (419,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (420,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',42);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (421,'Rua da Serenidade',123,'Sem complemento','Pr�ximo � pra�a central','1234567',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (422,'Avenida da Paz Interior',456,'Casa Verde','Ao lado do supermercado','98765432',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (423,'Travessa da Tranquilidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (424,'Rua da Calma',321,'Casa Amarela','Perto da farm�cia','13579246',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (425,'Avenida da Plenitude',654,'Apartamento 202','Ao lado do parque','67890123',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (426,'Pra�a da Resili�ncia',987,'Sem complemento','Pr�ximo ao hospital','24680135',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (427,'Alameda da Supera��o',246,'Casa Azul','Perto da esta��o de �nibus','75309864',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (428,'Rua da Flexibilidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (429,'Travessa da Integridade',579,'Casa Branca','Ao lado da academia','1234567',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (430,'Avenida da For�a',741,'Apartamento 303','Pr�ximo ao cinema','78901234',43);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (431,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (432,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (433,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (434,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (435,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (436,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (437,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (438,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (439,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (440,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',44);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (441,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (442,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (443,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (444,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (445,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (446,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (447,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (448,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (449,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (450,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',45);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (451,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (452,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (453,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (454,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (455,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (456,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (457,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (458,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (459,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (460,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',46);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (461,'Rua da Serenidade',123,'Sem complemento','Pr�ximo � pra�a central','1234567',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (462,'Avenida da Paz Interior',456,'Casa Verde','Ao lado do supermercado','98765432',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (463,'Travessa da Tranquilidade',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (464,'Rua da Calma',321,'Casa Amarela','Perto da farm�cia','13579246',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (465,'Avenida da Plenitude',654,'Apartamento 202','Ao lado do parque','67890123',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (466,'Pra�a da Resili�ncia',987,'Sem complemento','Pr�ximo ao hospital','24680135',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (467,'Alameda da Supera��o',246,'Casa Azul','Perto da esta��o de �nibus','75309864',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (468,'Rua da Flexibilidade',135,'Sem complemento','Pr�ximo � biblioteca','86420975',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (469,'Travessa da Integridade',579,'Casa Branca','Ao lado da academia','1234567',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (470,'Avenida da For�a',741,'Apartamento 303','Pr�ximo ao cinema','78901234',47);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (471,'Rua da Criatividade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (472,'Avenida da Inova��o',789,'Sem complemento','Ao lado da pra�a','98765432',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (473,'Travessa da Imagina��o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (474,'Rua da Arte',987,'Casa Amarela','Perto do posto de gasolina','13579246',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (475,'Avenida da Express�o',321,'Casa Verde','Ao lado da escola','67890123',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (476,'Pra�a da Inspira��o',654,'Apartamento 404','Pr�ximo � igreja','24680135',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (477,'Alameda da Cria��o',246,'Sem complemento','Perto da praia','75309864',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (478,'Rua da Inven��o',135,'Casa Branca','Pr�ximo � biblioteca','86420975',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (479,'Travessa da Originalidade',579,'Sem complemento','Ao lado do parque','1234567',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (480,'Avenida da Renova��o',741,'Casa Azul','Pr�ximo ao teatro','78901234',48);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (481,'Rua da Sabedoria',123,'Sem complemento','Pr�ximo � pra�a central','1234567',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (482,'Avenida da Conhecimento',456,'Casa Verde','Ao lado do supermercado','98765432',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (483,'Travessa da Intelig�ncia',789,'Apartamento 101','Pr�ximo � escola prim�ria','54321098',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (484,'Rua do Aprendizado',321,'Casa Amarela','Perto da farm�cia','13579246',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (485,'Avenida da Educa��o',654,'Apartamento 202','Ao lado do parque','67890123',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (486,'Pra�a do Saber',987,'Sem complemento','Pr�ximo ao hospital','24680135',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (487,'Alameda da Sabedoria',246,'Casa Azul','Perto da esta��o de �nibus','75309864',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (488,'Rua do Conhecimento',135,'Sem complemento','Pr�ximo � biblioteca','86420975',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (489,'Travessa do Ensino',579,'Casa Branca','Ao lado da academia','1234567',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (490,'Avenida da Ci�ncia',741,'Apartamento 303','Pr�ximo ao cinema','78901234',49);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (491,'Rua da Felicidade',456,'Casa Vermelha','Pr�ximo � padaria','1234567',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (492,'Avenida da Alegria',789,'Sem complemento','Ao lado da pra�a','98765432',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (493,'Travessa da Divers�o',123,'Apartamento 303','Pr�ximo ao mercado','54321098',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (494,'Rua do Sorriso',987,'Casa Amarela','Perto do posto de gasolina','13579246',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (495,'Avenida da Amizade',321,'Casa Verde','Ao lado da escola','67890123',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (496,'Pra�a da Harmonia',654,'Apartamento 404','Pr�ximo � igreja','24680135',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (497,'Alameda da Companhia',246,'Sem complemento','Perto da praia','75309864',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (498,'Rua da Paz',135,'Casa Branca','Pr�ximo � biblioteca','86420975',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (499,'Travessa da Amabilidade',579,'Sem complemento','Ao lado do parque','1234567',50);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (500,'Avenida da Simpatia',741,'Casa Azul','Pr�ximo ao teatro','78901234',50);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (501,'Rua das Flores',123,'Apt 4','Pr�ximo ao Parque Central','1234567',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (502,'Avenida dos Sonhos',789,'Casa 2','Perto da Esta��o de Metr�','98765432',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (503,'Travessa das Estrelas',456,'Bloco B','Ao lado do Supermercado Solar','54321678',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (504,'Pra�a da Liberdade',987,'Sala 10','Em frente � Biblioteca Municipal','87654321',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (505,'Alameda das Palmeiras',321,'Casa 5','Pr�ximo � Praia do Sol','23456789',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (506,'Rua das Montanhas',654,'Apartamento 8','Ao lado do Hospital S�o Lucas','76543210',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (507,'Avenida das �guas',987,'Casa 3','Pr�ximo ao Parque Aqu�tico','87654321',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (508,'Travessa das Rosas',234,'Bloco C','Em frente � Escola Prim�ria','34567890',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (509,'Pra�a da Harmonia',567,'Sala 7','Perto do Teatro Municipal','65432109',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (510,'Alameda dos Ventos',876,'Casa 1','Ao lado do Centro Comercial','54321098',51);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (511,'Rua das Estrelas',345,'Apartamento 6','Pr�ximo � Esta��o de Trem','43210987',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (512,'Avenida das Flores',678,'Casa 4','Em frente ao Parque da Cidade','21098765',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (513,'Travessa dos Sonhos',543,'Bloco A','Perto do Mercado Central','78901234',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (514,'Pra�a das Palmeiras',210,'Sala 5','Ao lado do Museu de Arte','67890123',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (515,'Alameda da Liberdade',876,'Casa 6','Pr�ximo � Pra�a Principal','10987654',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (516,'Rua das Montanhas',123,'Apartamento 3','Em frente ao Gin�sio Esportivo','89012345',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (517,'Avenida das �guas',456,'Casa 7','Perto do Jardim Bot�nico','56789012',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (518,'Travessa das Rosas',789,'Bloco D','Ao lado do Posto de Gasolina','32109876',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (519,'Pra�a da Harmonia',234,'Sala 4','Pr�ximo � Universidade Central','9876543',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (520,'Alameda dos Ventos',567,'Casa 2','Em frente ao Cinema Star','23456789',52);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (521,'Rua das Estrelas',876,'Apartamento 5','Perto do Centro de Sa�de','54321098',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (522,'Avenida das Flores',345,'Casa 8','Ao lado do Parque Infantil','43210987',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (523,'Travessa dos Sonhos',678,'Bloco B','Pr�ximo � Pra�a da Juventude','21098765',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (524,'Pra�a das Palmeiras',210,'Sala 3','Em frente � Livraria Cultural','67890123',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (525,'Alameda da Liberdade',543,'Casa 9','Perto do Est�dio Municipal','10987654',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (526,'Rua das Montanhas',876,'Apartamento 2','Ao lado do Centro de Artes','89012345',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (527,'Avenida das �guas',123,'Casa 5','Pr�ximo ao Lago Sereno','56789012',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (528,'Travessa das Rosas',456,'Bloco C','Perto do Teatro da Cidade','32109876',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (529,'Pra�a da Harmonia',789,'Sala 2','Em frente � Escola de M�sica','9876543',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (530,'Alameda dos Ventos',234,'Casa 3','Ao lado do Parque dos P�ssaros','23456789',53);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (531,'Rua das Estrelas',567,'Apartamento 4','Pr�ximo � Esta��o Rodovi�ria','54321098',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (532,'Avenida das Flores',876,'Casa 1','Perto do Centro de Conven��es','43210987',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (533,'Travessa dos Sonhos',345,'Bloco A','Em frente ao posto','42520310',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (534,'Pra�a das Palmeiras',543,'Sala 6','Pr�ximo � Biblioteca P�blica','67890123',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (535,'Alameda da Liberdade',876,'Casa 5','Ao lado do Parque das Flores','10987654',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (536,'Rua das Montanhas',234,'Apartamento 1','Perto do Centro Esportivo','89012345',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (537,'Avenida das �guas',567,'Casa 4','Em frente ao Mercado Municipal','56789012',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (538,'Travessa das Rosas',876,'Bloco D','Pr�ximo � Pra�a Central','32109876',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (539,'Pra�a da Harmonia',123,'Sala 3','Ao lado do Teatro da Cidade','9876543',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (540,'Alameda dos Ventos',456,'Casa 2','Perto do Museu de Hist�ria','23456789',54);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (541,'Rua das Estrelas',789,'Apartamento 5','Em frente � Escola Secund�ria','54321098',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (542,'Avenida das Flores',210,'Casa 7','Pr�ximo ao Parque dos Esquilos','43210987',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (543,'Travessa dos Sonhos',567,'Bloco B','Ao lado do Centro de Sa�de','21098765',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (544,'Pra�a das Palmeiras',876,'Sala 4','Perto do Gin�sio Municipal','67890123',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (545,'Alameda da Liberdade',345,'Casa 6','Em frente � Pra�a da Amizade','10987654',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (546,'Rua das Montanhas',678,'Apartamento 3','Pr�ximo � Esta��o de �nibus','89012345',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (547,'Avenida das �guas',345,'Casa 8','Ao lado do Jardim Zool�gico','56789012',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (548,'Travessa das Rosas',789,'Bloco C','Perto do Centro Cultural','32109876',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (549,'Pra�a da Harmonia',234,'Sala 5','Em frente � Universidade Central','9876543',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (550,'Alameda dos Ventos',567,'Casa 1','Pr�ximo ao Cinema Star','23456789',55);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (551,'Rua das Estrelas',876,'Apartamento 2','Pr�ximo � Esta��o de �nibus','54321098',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (552,'Avenida das Flores',123,'Casa 5','Em frente ao Parque dos Esquilos','43210987',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (553,'Travessa dos Sonhos',456,'Bloco B','Ao lado do Centro de Sa�de','21098765',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (554,'Pra�a das Palmeiras',789,'Sala 4','Perto do Gin�sio Municipal','67890123',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (555,'Alameda da Liberdade',210,'Casa 6','Em frente � Pra�a da Amizade','10987654',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (556,'Rua das Montanhas',567,'Apartamento 3','Pr�ximo � Esta��o de Trem','89012345',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (557,'Avenida das �guas',876,'Casa 8','Ao lado do Jardim Zool�gico','56789012',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (558,'Travessa das Rosas',345,'Bloco C','Perto do Centro Cultural','32109876',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (559,'Pra�a da Harmonia',678,'Sala 5','Em frente � Universidade Central','9876543',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (560,'Alameda dos Ventos',876,'Casa 1','Pr�ximo ao Cinema Star','23456789',56);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (561,'Rua das Estrelas',234,'Apartamento 4','Pr�ximo � Biblioteca P�blica','54321098',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (562,'Avenida das Flores',567,'Casa 7','Ao lado do Parque das Flores','43210987',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (563,'Travessa dos Sonhos',876,'Bloco D','Perto do Mercado Municipal','21098765',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (564,'Pra�a das Palmeiras',123,'Sala 3','Em frente ao Teatro da Cidade','67890123',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (565,'Alameda da Liberdade',456,'Casa 2','Pr�ximo ao Museu de Hist�ria','10987654',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (566,'Rua das Montanhas',789,'Apartamento 5','Ao lado do Centro Esportivo','89012345',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (567,'Avenida das �guas',210,'Casa 4','Perto do Parque dos P�ssaros','56789012',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (568,'Travessa das Rosas',567,'Bloco B','Em frente � Pra�a Central','32109876',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (569,'Pra�a da Harmonia',876,'Sala 2','Pr�ximo ao Teatro da Cidade','9876543',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (570,'Alameda dos Ventos',345,'Casa 3','Ao lado do Museu de Arte','23456789',57);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (571,'Rua das Estrelas',678,'Apartamento 6','Perto da Esta��o Rodovi�ria','54321098',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (572,'Avenida das Flores',345,'Casa 8','Em frente ao Centro de Conven��es','43210987',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (573,'Travessa dos Sonhos',789,'Bloco C','Pr�ximo � Pra�a da Amizade','21098765',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (574,'Pra�a das Palmeiras',234,'Sala 5','Ao lado do Parque dos Esquilos','67890123',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (575,'Alameda da Liberdade',567,'Casa 1','Perto do Centro Cultural','10987654',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (576,'Rua das Montanhas',876,'Apartamento 3','Em frente � Universidade Central','89012345',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (577,'Avenida das �guas',123,'Casa 7','Pr�ximo ao Cinema Star','56789012',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (578,'Travessa das Rosas',456,'Bloco B','Ao lado do Jardim Zool�gico','32109876',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (579,'Pra�a da Harmonia',789,'Sala 4','Perto do Centro Esportivo','9876543',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (580,'Alameda dos Ventos',210,'Casa 2','Em frente � Biblioteca P�blica','23456789',58);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (581,'Rua das Estrelas',567,'Apartamento 5','Pr�ximo ao Museu de Hist�ria','54321098',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (582,'Avenida das Flores',876,'Casa 1','Ao lado do Centro de Sa�de','43210987',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (583,'Travessa dos Sonhos',345,'Bloco A','Perto do Parque das Flores','21098930',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (584,'Travessa dos Sonhos',345,'Bloco A','Perto do Parque das Flores','21098765',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (585,'Pra�a das Palmeiras',678,'Sala 2','Ao lado do Centro de Sa�de','9876543',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (586,'Alameda dos Ventos',123,'Casa 7','Em frente � Biblioteca P�blica','56789012',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (587,'Rua das Estrelas',456,'Apartamento 5','Pr�ximo ao Museu de Hist�ria','54321098',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (588,'Avenida das Flores',789,'Casa 1','Ao lado do Centro de Sa�de','43210987',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (589,'Travessa dos Sonhos',210,'Bloco B','Perto do Parque das Flores','21098765',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (590,'Pra�a das Palmeiras',567,'Sala 4','Em frente ao Teatro da Cidade','67890123',59);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (591,'Alameda dos Ventos',876,'Casa 3','Pr�ximo ao Museu de Arte','23456789',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (592,'Rua das Estrelas',234,'Apartamento 6','Ao lado do Centro Esportivo','54321098',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (593,'Avenida das Flores',567,'Casa 8','Em frente � Universidade Central','43210987',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (594,'Travessa dos Sonhos',876,'Bloco C','Perto do Parque dos Esquilos','21098765',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (595,'Pra�a das Palmeiras',123,'Sala 5','Ao lado do Centro Cultural','67890123',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (596,'Alameda dos Ventos',456,'Casa 2','Pr�ximo ao Parque das Flores','23456789',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (597,'Rua das Estrelas',789,'Apartamento 4','Em frente � Biblioteca P�blica','54321098',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (598,'Avenida das Flores',210,'Casa 7','Perto do Museu de Hist�ria','43210987',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (599,'Travessa dos Sonhos',567,'Bloco B','Ao lado do Centro de Sa�de','21098765',60);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (600,'Pra�a das Palmeiras',876,'Sala 3','Pr�ximo ao Parque das Flores','67890123',60);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (601,'Alameda dos Ventos',345,'Casa 6','Em frente � Universidade Central','10987654',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (602,'Rua das Estrelas',678,'Apartamento 2','Perto do Centro Esportivo','54321098',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (603,'Avenida das Flores',345,'Casa 8','Ao lado do Centro Cultural','43210987',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (604,'Travessa dos Sonhos',789,'Bloco C','Pr�ximo ao Parque dos Esquilos','21098765',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (605,'Pra�a das Palmeiras',234,'Sala 5','Em frente � Biblioteca P�blica','67890123',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (606,'Alameda dos Ventos',567,'Casa 1','Perto do Museu de Hist�ria','23456789',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (607,'Rua das Estrelas',876,'Apartamento 4','Ao lado do Centro de Sa�de','54321098',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (608,'Avenida das Flores',345,'Casa 7','Em frente � Universidade Central','43210987',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (609,'Travessa dos Sonhos',678,'Bloco B','Perto do Parque das Flores','21098765',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (610,'Pra�a das Palmeiras',876,'Sala 3','Ao lado do Centro Esportivo','67890123',61);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (611,'Alameda dos Ventos',345,'Casa 6','Pr�ximo ao Centro Cultural','10987654',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (612,'Rua das Estrelas',678,'Apartamento 2','Em frente � Biblioteca P�blica','54321098',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (613,'Avenida das Flores',345,'Casa 8','Perto do Museu de Hist�ria','43210987',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (614,'Travessa dos Sonhos',789,'Bloco C','Ao lado do Centro de Sa�de','21098765',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (615,'Pra�a das Palmeiras',234,'Sala 5','Pr�ximo ao Parque das Flores','67890123',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (616,'Alameda dos Ventos',567,'Casa 1','Em frente � Universidade Central','23456789',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (617,'Rua das Estrelas',876,'Apartamento 4','Perto do Centro Esportivo','67990123',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (618,'Rua das Flores',123,'Apartamento 3','Perto da Creche','45280390',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (619,'Avenida do Sol',456,'Casa A','Perto da Esta��o de Metr�','98765432',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (620,'Travessa dos Amigos',789,'Loja 3','Ao lado da Padaria Central','54321098',62);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (621,'Rua das Palmeiras',321,'Sala 201','Em frente ao Supermercado Bom Pre�o','45678901',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (622,'Avenida Principal',654,'Fundos','Pr�ximo ao Banco Central','78901234',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (623,'Rua dos Girass�is',987,'Bloco B','Ao lado da Escola Municipal','21098765',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (624,'Alameda das �rvores',234,'Casa 2','Pr�ximo � Pra�a da Paz','56789012',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (625,'Pra�a das Rosas',876,'Apartamento 301','Em frente � Biblioteca Municipal','89012345',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (626,'Rua das Orqu�deas',543,'Loja 1','Perto do Posto de Gasolina','23456789',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (627,'Avenida das Estrelas',876,'Casa 3','Pr�ximo ao Hospital S�o Lucas','67890123',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (628,'Travessa da Esperan�a',129,'Apartamento 102','Ao lado do Cinema Central','54321987',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (629,'Rua dos L�rios',987,'Sala 3','Em frente ao Banco do Brasil','21098765',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (630,'Avenida da Paz',321,'Casa A','Pr�ximo ao Terminal de �nibus','9876543',63);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (631,'Alameda das Flores',654,'Bloco C','Ao lado da Farm�cia Popular','98765210',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (632,'Pra�a da Amizade',789,'Apartamento 202','Perto da Delegacia Central','54321098',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (633,'Rua das Ac�cias',147,'Loja 5','Em frente � Sorveteria Gelada','32109876',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (634,'Avenida da Liberdade',753,'Casa B','Pr�ximo ao Parque de Divers�es','65432109',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (635,'Travessa das Margaridas',258,'Sala 2','Ao lado do Caf� Central','98765432',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (636,'Rua dos Pinheiros',963,'Casa 4','Perto da Pra�a do Com�rcio','21098765',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (637,'Avenida dos Jardins',852,'Apartamento 401','Pr�ximo ao Teatro Municipal','54321098',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (638,'Alameda dos Ip�s',741,'Loja 7','Em frente ao Mercado Central','87654321',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (639,'Pra�a das Oliveiras',369,'Casa C','Ao lado da Padaria Doce Sabor','10987654',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (640,'Rua da Alegria',258,'Sala 4','Perto da Esta��o Rodovi�ria','43210987',64);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (641,'Avenida da Esperan�a',147,'Casa 5','Pr�ximo ao Parque Aqu�tico','76543210',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (642,'Travessa das Palmas',963,'Apartamento 502','Ao lado da Escola Estadual','9876543',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (643,'Rua das Violetas',852,'Loja 9','Em frente ao Posto de Sa�de','32109876',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (644,'Alameda da Felicidade',741,'Casa D','Pr�ximo � Pra�a Central','65432109',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (645,'Pra�a dos Girass�is',369,'Sala 5','Perto do Banco Santander','98765432',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (646,'Rua do Sol Nascente',951,'Casa 6','Ao lado do Centro Cultural','21098765',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (647,'Avenida das Maravilhas',753,'Loja 11','Pr�ximo ao Restaurante Sabores','54321098',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (648,'Travessa dos Sonhos',852,'Apartamento 603','Em frente � Livraria Cultura','87654321',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (649,'Rua da Harmonia',741,'Sala 6','Perto do Centro Esportivo','10987654',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (650,'Alameda das Estrelas',369,'Casa E','Ao lado da Loja de Eletr�nicos','43210987',65);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (651,'Pra�a das Borboletas',258,'Apartamento 702','Pr�ximo ao Museu de Arte','76543210',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (652,'Rua dos Sonhos',147,'Loja 13','Em frente � Loja de Roupas Fashion','9876543',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (653,'Avenida das Ilus�es',963,'Casa 7','Perto da Pra�a dos Namorados','32109876',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (654,'Travessa da Saudade',852,'Sala 7','Ao lado do Centro de Conviv�ncia','65432109',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (655,'Rua do Horizonte',741,'Loja 15','Pr�ximo ao Parque Infantil','98765432',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (656,'Alameda da Harmonia',369,'Casa F','Em frente � Quadra de Esportes','21098765',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (657,'Pra�a da Aventura',258,'Apartamento 802','Perto do Shopping Center','54321098',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (658,'Rua da Felicidade',147,'Loja 17','Ao lado da Pizzaria Bella Napoli','87654321',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (659,'Avenida da Imagina��o',963,'Casa 8','Pr�ximo ao Parque de Divers�es','10987654',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (660,'Travessa das Recorda��es',852,'Sala 8','Em frente ao Supermercado Mega','43210987',66);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (661,'Rua da Fantasia',741,'Loja 19','Perto da Pra�a dos Sonhos','76543210',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (662,'Alameda dos Anjos',369,'Casa G','Ao lado da Escola de M�sica','9876543',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (663,'Pra�a da Liberdade',258,'Apartamento 902','Pr�ximo � Esta��o de Trem','32109876',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (664,'Rua das Maravilhas',147,'Loja 21','Em frente � Loja de Brinquedos','65432109',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (665,'Avenida das Virtudes',963,'Casa 9','Perto do Parque Ecol�gico','98765432',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (666,'Travessa da Harmonia',852,'Sala 9','Ao lado da Pra�a dos Anjos','21098765',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (667,'Rua dos Desejos',741,'Loja 23','Pr�ximo ao Centro de Sa�de','54321098',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (668,'Alameda da Serenidade',369,'Casa H','Em frente � Pra�a da Serenidade','21098765',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (669,'Pra�a da Felicidade',258,'Apartamento 1002','Perto da Biblioteca Municipal','9876543',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (670,'Rua das Lembran�as',147,'Loja 25','Ao lado da Sorveteria Doce Sabor','65432109',67);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (671,'Avenida das Mem�rias',963,'Casa 10','Pr�ximo ao Centro Cultural','87654321',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (672,'Travessa dos Sorrisos',852,'Sala 10','Em frente � Pra�a das Lembran�as','32109876',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (673,'Rua da Saudade',741,'Loja 27','Perto do Parque dos P�ssaros','54321098',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (674,'Alameda dos Sonhos',369,'Casa I','Ao lado da Escola Infantil','10987654',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (675,'Pra�a da Paz',258,'Apartamento 1102','Pr�ximo ao Centro Esportivo','76543210',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (676,'Rua da Alegria',147,'Loja 29','Em frente � Padaria Central','9876543',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (677,'Avenida da Juventude',963,'Casa 11','Perto do Campo de Futebol','21098765',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (678,'Travessa da Amizade',852,'Sala 11','Ao lado da Pra�a da Juventude','54321098',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (679,'Rua das Risadas',741,'Loja 31','Pr�ximo ao Hospital Municipal','87654321',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (680,'Alameda da Compaix�o',369,'Casa J','Em frente � Pra�a dos Risos','32109876',68);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (681,'Pra�a dos Abra�os',258,'Apartamento 1202','Perto do Parque de Divers�es','54321098',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (682,'Rua da Esperan�a',147,'Loja 33','Ao lado do Centro de Conviv�ncia','10987654',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (683,'Avenida das Promessas',963,'Casa 12','Pr�ximo � Pra�a da Esperan�a','76543210',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (684,'Travessa da Harmonia',852,'Sala 12','Em frente ao Mercado Municipal','9876543',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (685,'Rua da Amizade',741,'Loja 35','Perto da Pra�a dos Abra�os','21098765',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (686,'Alameda da Solidariedade',369,'Casa K','Ao lado da Escola de Artes','54321098',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (687,'Pra�a da Solid�o',258,'Apartamento 1302','Pr�ximo � Esta��o de �nibus','87654321',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (688,'Rua da Harmonia',147,'Loja 37','Em frente ao Parque dos Sonhos','32109876',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (689,'Avenida da Comunidade',963,'Casa 13','Perto da Delegacia de Pol�cia','54321098',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (690,'Travessa dos Amores',852,'Sala 13','Ao lado da Pra�a da Comunidade','10987654',69);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (691,'Rua da Uni�o',741,'Loja 39','Pr�ximo ao Centro de Eventos','76543210',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (692,'Alameda da Igualdade',369,'Casa L','Em frente � Pra�a da Uni�o','9876543',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (693,'Pra�a da Esperan�a',258,'Apartamento 1402','Perto do Teatro Municipal','21098765',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (694,'Rua da Felicidade',147,'Loja 41','Ao lado do Parque da Amizade','54321098',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (695,'Avenida da Fraternidade',963,'Casa 14','Pr�ximo � Igreja Matriz','87654321',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (696,'Travessa da Felicidade',852,'Sala 14','Em frente ao Centro de Sa�de','32109876',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (697,'Rua da Harmonia',741,'Loja 43','Perto do Centro Cultural','54321098',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (698,'Alameda do Amor',369,'Casa M','Ao lado da Pra�a da Harmonia','10987654',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (699,'Pra�a da Uni�o',258,'Apartamento 1502','Pr�ximo ao Parque Infantil','76543210',70);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (700,'Rua da Amizade',147,'Loja 45','Em frente ao Mercado Central','9876543',70);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (701,'Avenida do Bem',963,'Casa 15','Perto da Escola Municipal','21098765',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (702,'Travessa da Paz',852,'Sala 15','Ao lado da Pra�a da Amizade','54321098',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (703,'Rua da Alegria',741,'Loja 47','Pr�ximo � Esta��o de Trem','87654321',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (704,'Alameda da Generosidade',369,'Casa N','Em frente ao Parque Ecol�gico','32109876',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (705,'Pra�a da Alegria',258,'Apartamento 1602','Perto da Pra�a Central','54321098',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (706,'Rua do Progresso',147,'Loja 49','Ao lado do Centro Esportivo','10987654',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (707,'Avenida da Harmonia',963,'Casa 16','Pr�ximo ao Campo de Futebol','76543210',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (708,'Travessa da Prosperidade',852,'Sala 16','Em frente � Pra�a do Progresso','9876543',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (709,'Rua do Sucesso',741,'Loja 51','Perto do Hospital S�o Lucas','21098765',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (710,'Alameda da Conquista',369,'Casa O','Ao lado do Parque dos P�ssaros','54321098',71);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (711,'Pra�a da Vit�ria',258,'Apartamento 1702','Pr�ximo � Escola Estadual','87654321',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (712,'Rua da Conquista',147,'Loja 53','Em frente � Pra�a dos Sorrisos','32109876',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (713,'Avenida da Realiza��o',963,'Casa 17','Perto do Parque Aqu�tico','54321098',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (714,'Travessa do Triunfo',852,'Sala 17','Ao lado do Centro Comercial','10987654',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (715,'Rua da Prosperidade',741,'Loja 55','Pr�ximo ao Banco do Brasil','76543210',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (716,'Alameda da Sabedoria',369,'Casa P','Em frente ao Centro Universit�rio','21098765',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (717,'Pra�a da Sabedoria',258,'Apartamento 1802','Perto da Livraria Universit�ria','54321098',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (718,'Rua do Conhecimento',147,'Loja 57','Ao lado da Faculdade de Medicina','87654321',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (719,'Avenida da Intelig�ncia',963,'Casa 18','Pr�ximo ao Centro de Pesquisa','32109876',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (720,'Travessa da Educa��o',852,'Sala 18','Em frente � Escola T�cnica','54321098',72);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (721,'Rua da Ci�ncia',741,'Loja 59','Perto do Laborat�rio de Inform�tica','10987654',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (722,'Alameda do Aprendizado',369,'Casa Q','Ao lado da Escola de Idiomas','76543210',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (723,'Pra�a do Conhecimento',258,'Apartamento 1902','Pr�ximo � Biblioteca Universit�ria','21098765',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (724,'Rua da Inova��o',147,'Loja 61','Em frente ao Centro de Inova��o Tecnol�gica','54321098',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (725,'Avenida da Descoberta',963,'Casa 19','Perto do Museu de Ci�ncias','87654321',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (726,'Travessa da Tecnologia',852,'Sala 19','Ao lado do Centro de Tecnologia','32109876',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (727,'Rua da Inspira��o',741,'Loja 63','Pr�ximo ao Laborat�rio de Qu�mica','54321098',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (728,'Alameda da Criatividade',369,'Casa R','Em frente ao Ateli� de Artes','10987654',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (729,'Pra�a da Imagina��o',258,'Apartamento 2002','Perto da Escola de Design','76543210',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (730,'Rua da Arte',147,'Loja 65','Ao lado da Galeria de Arte','21098765',73);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (731,'Avenida da Express�o',963,'Casa 20','Pr�ximo ao Teatro de Rua','54321098',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (732,'Travessa da Poesia',852,'Sala 20','Em frente ao Centro Cultural','87654321',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (733,'Rua da M�sica',741,'Loja 67','Perto da Escola de M�sica','32109876',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (734,'Alameda dos Artistas',369,'Casa S','Ao lado do Est�dio de Grava��o','54321098',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (735,'Pra�a dos Talentos',258,'Apartamento 2102','Pr�ximo ao Conservat�rio de M�sica','10987654',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (736,'Rua do Palco',147,'Loja 69','Em frente ao Teatro Municipal','76543210',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (737,'Avenida do Drama',963,'Casa 21','Perto do Centro de Artes C�nicas','21098765',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (738,'Travessa do Cinema',852,'Sala 21','Ao lado do Cinemark','54321098',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (739,'Rua da Fotografia',741,'Loja 71','Pr�ximo ao Est�dio Fotogr�fico','87654321',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (740,'Alameda das Imagens',369,'Casa T','Em frente � Galeria de Fotos','32109876',74);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (741,'Pra�a da Beleza',258,'Apartamento 2202','Perto do Sal�o de Beleza','54321098',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (742,'Rua da Moda',147,'Loja 73','Ao lado da Boutique Fashion','10987654',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (743,'Avenida do Estilo',963,'Casa 22','Pr�ximo � Passarela de Moda','76543210',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (744,'Travessa do Glamour',852,'Sala 22','Em frente � Casa de Costura','21098765',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (745,'Rua do Charme',741,'Loja 75','Perto do Sal�o de Noivas','54321098',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (746,'Alameda do Eleg�ncia',369,'Casa U','Ao lado da Loja de Grife','87654321',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (747,'Pra�a do Estilo',258,'Apartamento 2302','Pr�ximo � Casa de Perfumes','32109876',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (748,'Rua da Eleg�ncia',147,'Loja 77','Em frente � Loja de Joias','54321098',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (749,'Avenida do Luxo',963,'Casa 23','Perto da Boutique de Luxo','10987654',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (750,'Travessa da Classe',852,'Sala 23','Ao lado da Loja de Artigos Importados','76543210',75);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (751,'Rua do Prest�gio',741,'Loja 79','Pr�ximo � Boutique de Vinhos','21098765',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (752,'Alameda da Riqueza',369,'Casa V','Em frente � Casa de Leil�es','54321098',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (753,'Pra�a da Fortuna',258,'Apartamento 2402','Perto do Banco de Investimentos','87654321',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (754,'Rua da Prosperidade',147,'Loja 81','Ao lado da Bolsa de Valores','32109876',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (755,'Avenida da Abund�ncia',963,'Casa 24','Pr�ximo ao Shopping de Luxo','54321098',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (756,'Travessa da Prosperidade',852,'Sala 24','Em frente � Boutique de Antiguidades','10987654',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (757,'Rua da Oportunidade',741,'Loja 83','Perto da Casa de C�mbio','76543210',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (758,'Alameda do Sucesso',369,'Casa X','Ao lado da Ag�ncia de Modelos','21098765',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (759,'Pra�a da Fama',258,'Apartamento 2502','Pr�ximo ao Tapete Vermelho','54321098',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (760,'Rua das Estrelas',147,'Loja 85','Em frente � Casa de Eventos','87654321',76);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (761,'Avenida do Brilho',963,'Casa 25','Perto do Est�dio de TV','32109876',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (762,'Travessa da Celebridade',852,'Sala 25','Ao lado da Ag�ncia de Talentos','54321098',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (763,'Rua do Glamour',741,'Loja 87','Pr�ximo � Revista de Celebridades','10987654',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (764,'Alameda da Fama',369,'Casa Y','Em frente � Cal�ada da Fama','76543210',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (765,'Pra�a do Showbiz',258,'Apartamento 2602','Perto do Est�dio de Grava��o','21098765',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (766,'Rua do Palco',147,'Loja 89','Ao lado do Teatro de �pera','54321098',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (767,'Avenida da M�sica',963,'Casa 26','Pr�ximo ao Conservat�rio de M�sica','87654321',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (768,'Travessa da Dan�a',852,'Sala 26','Em frente � Escola de Dan�a','32109876',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (769,'Rua do Ritmo',741,'Loja 91','Perto da Casa de Shows','54321098',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (770,'Alameda do Compasso',369,'Casa Z','Ao lado do Est�dio de Dan�a','10987654',77);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (771,'Pra�a do Movimento',258,'Apartamento 2702','Pr�ximo ao Centro de Fitness','76543210',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (772,'Rua do Esporte',147,'Loja 93','Em frente ao Est�dio Municipal','21098765',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (773,'Avenida da Atividade F�sica',963,'Casa 27','Perto da Academia Fitness','54321098',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (774,'Travessa do Bem-Estar',852,'Sala 27','Ao lado da Pista de Corrida','87654321',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (775,'Rua da Sa�de',741,'Loja 95','Pr�ximo � Cl�nica de Fisioterapia','32109876',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (776,'Alameda do Equil�brio',369,'Casa W','Em frente ao Parque Fitness','54321098',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (777,'Pra�a da Vitalidade',258,'Apartamento 2802','Perto do Centro de Yoga','10987654',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (778,'Rua da Nutri��o',147,'Loja 97','Ao lado da Loja de Suplementos','76543210',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (779,'Avenida da Alimenta��o Saud�vel',963,'Casa 28','Pr�ximo ao Mercado Org�nico','21098765',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (780,'Travessa do Sabor',852,'Sala 28','Em frente � Feira de Org�nicos','54321098',78);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (781,'Rua do Gosto',741,'Loja 99','Perto do Emp�rio Gourmet','87654321',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (782,'Alameda da Culin�ria',369,'Casa 1','Ao lado da Escola de Gastronomia','32109876',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (783,'Pra�a do Sabor',258,'Apartamento 2902','Pr�ximo ao Restaurante Gourmet','54321098',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (784,'Rua da Gastronomia',147,'Loja 101','Em frente ao Mercado Municipal','10987654',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (785,'Avenida do Chef',963,'Casa 29','Perto da Escola de Culin�ria','76543210',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (786,'Travessa do Tempero',852,'Sala 29','Ao lado da Padaria Artesanal','21098765',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (787,'Rua do Sabor',741,'Loja 103','Pr�ximo ao Food Truck Park','54321098',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (788,'Alameda dos Sabores',369,'Casa 2','Em frente � Sorveteria Artesanal','87654321',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (789,'Pra�a do Paladar',258,'Apartamento 3002','Perto do Mercado de Especiarias','32109876',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (790,'Rua da Degusta��o',147,'Loja 105','Ao lado da Vin�cola Boutique','54321098',79);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (791,'Avenida do Vinho',963,'Casa 30','Pr�ximo � Adega Familiar','10987654',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (792,'Travessa dos Vinhedos',852,'Sala 30','Em frente � Rota do Vinho','76543210',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (793,'Rua do En�logo',741,'Loja 107','Perto do Bar de Vinhos','21098765',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (794,'Alameda da Enologia',369,'Casa 3','Ao lado da Escola de Enologia','54321098',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (795,'Pra�a da Uva',258,'Apartamento 3102','Pr�ximo � Vin�cola Tradicional','87654321',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (796,'Rua do Sabor',147,'Loja 109','Em frente � Confeitaria Artesanal','32109876',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (797,'Avenida dos Aromas',963,'Casa 31','Perto da Loja de Chocolates','54321098',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (798,'Travessa do Chocolate',852,'Sala 31','Ao lado da F�brica de Chocolate','10987654',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (799,'Rua da Do�ura',741,'Loja 111','Pr�ximo � Loja de Doces Gourmet','76543210',80);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (800,'Alameda dos Doces',369,'Casa 4','Em frente � Sorveteria de Doces','21098765',80);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (801,'Pra�a dos Chocolates',258,'Apartamento 3202','Perto da F�brica de Doces','54321098',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (802,'Rua do Cacau',147,'Loja 113','Ao lado da Plantation de Cacau','87654321',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (803,'Avenida do Doce',963,'Casa 32','Pr�ximo � Loja de Guloseimas','32109876',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (804,'Travessa da Confeitaria',852,'Sala 32','Em frente � F�brica de Cupcakes','54321098',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (805,'Rua dos Confeiteiros',741,'Loja 115','Perto da Escola de Confeitaria','10987654',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (806,'Alameda dos Cupcakes',369,'Casa 5','Ao lado da Confeitaria Caseira','76543210',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (807,'Pra�a dos Bolos',258,'Apartamento 3302','Pr�ximo � Cake Shop','21098765',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (808,'Rua da Torta',147,'Loja 117','Em frente � Tortaria Artesanal','54321098',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (809,'Avenida do Bolo',963,'Casa 33','Perto da Casa de Bolos Caseiros','87654321',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (810,'Travessa dos Bolos',852,'Sala 33','Ao lado da Escola de Cake Design','32109876',81);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (811,'Rua dos Padeiros',741,'Loja 119','Pr�ximo � Padaria Artesanal','54321098',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (812,'Alameda do P�o',369,'Casa 6','Em frente � Escola de Panifica��o','10987654',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (813,'Pra�a dos P�es',258,'Apartamento 3402','Perto da Padaria Gourmet','76543210',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (814,'Rua da Massa',147,'Loja 121','Ao lado da Pizzaria Artesanal','21098765',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (815,'Avenida do Sabor',963,'Casa 34','Pr�ximo ao Restaurante Italiano','54321098',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (816,'Travessa da Pizza',852,'Sala 34','Em frente � Pizzaria Tradicional','87654321',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (817,'Rua do Molho',741,'Loja 123','Perto da Cantina Italiana','32109876',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (818,'Alameda da Pasta',369,'Casa 7','Ao lado do Restaurante de Massas','54321098',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (819,'Pra�a do Macarr�o',258,'Apartamento 3502','Pr�ximo ao Restaurante de Macarr�o','10987654',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (820,'Rua da Carbonara',147,'Loja 125','Em frente � Trattoria Italiana','76543210',82);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (821,'Avenida do Espaguete',963,'Casa 35','Perto da Cantina R�stica','21098765',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (822,'Travessa do Ravi�li',852,'Sala 35','Ao lado do Restaurante Familiar','54321098',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (823,'Rua da Lasanha',741,'Loja 127','Pr�ximo ao Restaurante de Lasanha','87654321',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (824,'Alameda da Culin�ria Italiana',369,'Casa 8','Em frente � Osteria','32109876',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (825,'Pra�a da Gastronomia Italiana',258,'Apartamento 3602','Perto da Trattoria Gourmet','54321098',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (826,'Rua do Gelato',147,'Loja 129','Ao lado da Gelateria Tradicional','10987654',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (827,'Avenida do Sorvete',963,'Casa 36','Pr�ximo � Gelateria Artesanal','76543210',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (828,'Travessa da Sobremesa',852,'Sala 36','Em frente � Pasticceria','21098765',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (829,'Rua da Tiramisu',741,'Loja 131','Perto da Trattoria Romana','54321098',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (830,'Alameda da Dolci',369,'Casa 9','Ao lado da Confeitaria Italiana','87654321',83);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (831,'Pra�a do Gelato',258,'Apartamento 3702','Pr�ximo � Gelateria Gourmet','32109876',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (832,'Rua da Pizza',147,'Loja 133','Em frente � Pizzeria Napoletana','54321098',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (833,'Avenida da Trattoria',963,'Casa 37','Perto da Trattoria Aut�ntica','10987654',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (834,'Travessa do Gnocchi',852,'Sala 37','Ao lado da Trattoria Familiar','76543210',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (835,'Rua da Focaccia',741,'Loja 135','Pr�ximo � Pizzeria Artesanal','21098765',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (836,'Alameda da Bruschetta',369,'Casa 10','Em frente � Trattoria R�stica','54321098',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (837,'Pra�a da Gastronomia Mediterr�nea',258,'Apartamento 3802','Perto do Restaurante Mediterr�neo','87654321',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (838,'Rua do Souvlaki',147,'Loja 137','Ao lado da Taberna Grega','32109876',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (839,'Avenida do Gyro',963,'Casa 38','Pr�ximo ao Restaurante Grego','54321098',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (840,'Travessa da Moussaka',852,'Sala 38','Em frente � Taverna','10987654',84);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (841,'Rua da Tzatziki',741,'Loja 139','Perto da Casa de Meze','76543210',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (842,'Alameda do Baklava',369,'Casa 11','Ao lado da Pastelaria Grega','21098765',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (843,'Pra�a do Vinho Grego',258,'Apartamento 3902','Pr�ximo � Adega Grega','54321098',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (844,'Rua da Ouzo',147,'Loja 141','Em frente � Taverna Ouzeri','87654321',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (845,'Avenida do Retsina',963,'Casa 39','Perto do Bar de Ouzo','32109876',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (846,'Travessa do Saganaki',852,'Sala 39','Ao lado da Taberna de Meze','54321098',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (847,'Rua do Loukoumades',741,'Loja 143','Pr�ximo � Loukoumadeseria','10987654',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (848,'Alameda do Feta',369,'Casa 12','Em frente � Casa de Queijos','76543210',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (849,'Pra�a da Gastronomia Grega',258,'Apartamento 4002','Perto da Taberna Aut�ntica','21098765',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (850,'Rua do Souffl�',147,'Loja 145','Ao lado da P�tisserie Francesa','54321098',85);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (851,'Avenida do Croissant',963,'Casa 40','Pr�ximo � Boulangerie','87654321',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (852,'Travessa da Baguete',852,'Sala 40','Em frente � Boulangerie P�tisserie','32109876',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (853,'Rua da Quiche',741,'Loja 147','Perto da Creperia Francesa','54321098',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (854,'Alameda do Macaron',369,'Casa 13','Ao lado da Macaroneria','10987654',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (855,'Pra�a da P�tisserie',258,'Apartamento 4102','Pr�ximo � P�tisserie Gourmet','76543210',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (856,'Rua do Crepe',147,'Loja 149','Em frente � Cr�perie','21098765',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (857,'Avenida do Pain au Chocolat',963,'Casa 41','Perto da P�tisserie Tradicional','54321098',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (858,'Travessa da Tartelette',852,'Sala 41','Ao lado da P�tisserie Artesanal','87654321',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (859,'Rua da Mille-Feuille',741,'Loja 151','Pr�ximo � Boulangerie Artisanale','32109876',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (860,'Alameda da Gastronomia Francesa',369,'Casa 14','Em frente � Brasserie','54321098',86);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (861,'Pra�a do Croissant',258,'Apartamento 4202','Perto da P�tisserie Caseira','10987654',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (862,'Rua do Baguete',147,'Loja 153','Ao lado da Boulangerie P�tisserie','76543210',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (863,'Avenida do Macaron',963,'Casa 42','Pr�ximo � Confeitaria Francesa','21098765',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (864,'Travessa da Cr�me Br�l�e',852,'Sala 42','Em frente � Boulangerie Gourmet','54321098',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (865,'Rua do Eclair',741,'Loja 155','Perto da P�tisserie Artesanal','87654321',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (866,'Alameda da Cozinha Francesa',369,'Casa 15','Ao lado do Bistr�','32109876',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (867,'Pra�a do Cordon Bleu',258,'Apartamento 4302','Pr�ximo � Brasserie Gourmet','54321098',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (868,'Rua do Ratatouille',147,'Loja 157','Em frente � Bistr� Franc�s','10987654',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (869,'Avenida da Confeitaria',963,'Casa 43','Perto da Confeitaria Tradicional','76543210',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (870,'Travessa da Croque-Monsieur',852,'Sala 43','Ao lado da Boulangerie Gourmande','21098765',87);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (871,'Rua da Patissier',741,'Loja 159','Pr�ximo � Confeitaria Artesanal','54321098',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (872,'Alameda do Chef',369,'Casa 16','Em frente ao Restaurante Franc�s','87654321',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (873,'Pra�a da Gastronomia Francesa',258,'Apartamento 4402','Perto da Brasserie','32109876',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (874,'Rua do Crepe',147,'Loja 161','Ao lado da Creperia Francesa','54321098',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (875,'Avenida do Croissant',963,'Casa 44','Pr�ximo � P�tisserie Francesa','10987654',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (876,'Travessa da Baguette',852,'Sala 44','Em frente � Boulangerie','76543210',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (877,'Rua da Quiche',741,'Loja 163','Perto do Caf� Franc�s','21098765',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (878,'Alameda da Croque-Monsieur',369,'Casa 17','Ao lado da Brasserie Tradicional','54321098',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (879,'Pra�a da Boulangerie',258,'Apartamento 4502','Pr�ximo � Boulangerie Artisanale','87654321',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (880,'Rua da Gastronomia Italiana',147,'Loja 165','Em frente � Cantina Italiana','32109876',88);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (881,'Avenida do Vinho',963,'Casa 45','Perto da Enoteca','54321098',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (882,'Travessa do Espaguete',852,'Sala 45','Ao lado da Trattoria','10987654',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (883,'Rua do Molho',741,'Loja 167','Pr�ximo � Cantina Familiar','76543210',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (884,'Alameda da Pizza',369,'Casa 18','Em frente � Pizzeria','21098765',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (885,'Pra�a do Ravi�li',258,'Apartamento 4602','Perto da Trattoria Aut�ntica','54321098',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (886,'Rua da Lasanha',147,'Loja 169','Ao lado da Cantina Tradicional','87654321',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (887,'Avenida da Gastronomia Italiana',963,'Casa 46','Pr�ximo ao Restaurante Italiano','32109876',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (888,'Travessa do Gnocchi',852,'Sala 46','Em frente � Pizzeria Tradicional','54321210',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (889,'Rua da Carbonara',741,'Loja 171','Perto da Trattoria Gourmet','21098765',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (890,'Alameda da Pizza',369,'Casa 19','Ao lado da Pizzeria Artesanal','54321098',89);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (891,'Pra�a da P�tisserie',258,'Apartamento 4702','Pr�ximo � Confeitaria Gourmet','10987654',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (892,'Rua do Croissant',147,'Loja 173','Em frente � Boulangerie','76543210',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (893,'Avenida do Macaron',963,'Casa 47','Perto da P�tisserie Tradicional','21098765',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (894,'Travessa da Baguette',852,'Sala 47','Ao lado da Boulangerie Artesanal','54321098',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (895,'Rua do Eclair',741,'Loja 175','Pr�ximo � Boulangerie P�tisserie','87654321',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (896,'Alameda da Gastronomia Francesa',369,'Casa 20','Em frente � Brasserie','32109876',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (897,'Pra�a do Cordon Bleu',258,'Apartamento 4802','Perto do Bistr�','54321098',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (898,'Rua do Ratatouille',147,'Loja 177','Ao lado do Restaurante Franc�s','10987654',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (899,'Avenida da Confeitaria',963,'Casa 48','Pr�ximo � P�tisserie Francesa','76543210',90);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (900,'Travessa da Croque-Monsieur',852,'Sala 48','Em frente � Boulangerie','21098765',90);
COMMIT;

INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (901,'Rua da Patissier',741,'Loja 179','Perto da Confeitaria Artesanal','54321098',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (902,'Alameda do Chef',369,'Casa 21','Ao lado do Restaurante Franc�s','87654321',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (903,'Pra�a da Gastronomia Francesa',258,'Apartamento 4902','Pr�ximo � Brasserie','32109876',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (904,'Rua do Crepe',147,'Loja 181','Em frente � Creperia Francesa','54321098',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (905,'Avenida do Croissant',963,'Casa 49','Pr�ximo � P�tisserie','10987654',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (906,'Travessa da Baguette',852,'Sala 49','Ao lado da Boulangerie','76543210',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (907,'Rua do Quiche',741,'Loja 183','Perto da Brasserie','21098765',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (908,'Alameda da Cozinha Francesa',369,'Casa 22','Em frente � Brasserie Gourmet','54321098',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (909,'Pra�a do Croissant',258,'Apartamento 5002','Perto da Boulangerie Artesanal','10987654',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (910,'Rua do Baguete',147,'Loja 185','Ao lado da P�tisserie Tradicional','76543210',91);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (911,'Avenida do Macaron',963,'Casa 50','Pr�ximo � Boulangerie Gourmet','21098765',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (912,'Travessa da Cr�me Br�l�e',852,'Sala 50','Em frente � P�tisserie Artesanal','54321098',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (913,'Rua do Eclair',741,'Loja 187','Perto da Confeitaria Francesa','87654321',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (914,'Alameda da Gastronomia Francesa',369,'Casa 23','Ao lado da Boulangerie','32109876',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (915,'Pra�a da P�tisserie',258,'Apartamento 5102','Pr�ximo � Brasserie Tradicional','54321098',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (916,'Rua do Crepe',147,'Loja 189','Em frente � Boulangerie P�tisserie','10987654',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (917,'Avenida do Croissant',963,'Casa 51','Perto da Boulangerie Artesanal','76543210',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (918,'Travessa da Baguette',852,'Sala 51','Ao lado da P�tisserie Gourmet','21098765',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (919,'Rua do Quiche',741,'Loja 191','Pr�ximo � Boulangerie Tradicional','54321098',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (920,'Alameda do Chef',369,'Casa 24','Em frente � Brasserie P�tisserie','87654321',92);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (921,'Pra�a da Gastronomia Francesa',258,'Apartamento 5202','Perto da Boulangerie Gourmet','32109876',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (922,'Rua do Crepe',147,'Loja 193','Ao lado da P�tisserie Artesanal','54321098',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (923,'Avenida do Croissant',963,'Casa 52','Pr�ximo � Boulangerie de Luxo','10987654',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (924,'Travessa da Baguette',852,'Sala 52','Em frente � Boulangerie de Prest�gio','76543210',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (925,'Rua do Quiche',741,'Loja 195','Perto da Boulangerie Tradicional','21098765',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (926,'Alameda do Chef',369,'Casa 25','Ao lado da Brasserie de Luxo','54321098',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (927,'Pra�a da Gastronomia Francesa',258,'Apartamento 5302','Pr�ximo � P�tisserie Artesanal','87654321',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (928,'Rua do Crepe',147,'Loja 197','Em frente � Boulangerie Gourmet','32109876',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (929,'Avenida do Croissant',963,'Casa 53','Perto da Brasserie Tradicional','54321098',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (930,'Travessa da Baguette',852,'Sala 53','Ao lado da Boulangerie de Luxo','10987654',93);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (931,'Rua do Quiche',741,'Loja 199','Pr�ximo � Brasserie Artesanal','76543210',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (932,'Alameda do Chef',369,'Casa 26','Em frente � P�tisserie de Luxo','21098765',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (933,'Pra�a da Gastronomia Francesa',258,'Apartamento 5402','Perto da Boulangerie de Prest�gio','54321098',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (934,'Rua do Crepe',147,'Loja 201','Ao lado da Brasserie Tradicional','87654321',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (935,'Avenida do Croissant',963,'Casa 54','Pr�ximo � Boulangerie Gourmet','32109876',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (936,'Travessa da Baguette',852,'Sala 54','Em frente � P�tisserie Artesanal','54321210',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (937,'Rua do Quiche',741,'Loja 203','Perto da Boulangerie de Luxo','21098765',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (938,'Alameda do Chef',369,'Casa 27','Ao lado da Brasserie Tradicional','54321098',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (939,'Pra�a da Gastronomia Francesa',258,'Apartamento 5502','Pr�ximo � Boulangerie Gourmet','10987654',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (940,'Rua do Crepe',147,'Loja 205','Em frente � P�tisserie de Luxo','76543210',94);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (941,'Avenida do Croissant',963,'Casa 55','Perto da Brasserie Artesanal','21098765',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (942,'Travessa da Baguette',852,'Sala 55','Ao lado da Boulangerie Tradicional','54321098',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (943,'Rua do Quiche',741,'Loja 207','Pr�ximo � P�tisserie Gourmet','87654321',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (944,'Alameda do Chef',369,'Casa 28','Em frente � Brasserie de Luxo','32109876',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (945,'Pra�a da Gastronomia Francesa',258,'Apartamento 5602','Perto da Boulangerie de Prest�gio','54321098',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (946,'Rua do Crepe',147,'Loja 209','Ao lado da Brasserie Tradicional','10987654',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (947,'Avenida do Croissant',963,'Casa 56','Pr�ximo � P�tisserie Artesanal','76543210',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (948,'Travessa da Baguette',852,'Sala 56','Em frente � Boulangerie Gourmet','21098765',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (949,'Rua do Quiche',741,'Loja 211','Perto da Brasserie de Luxo','54321098',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (950,'Alameda do Chef',369,'Casa 29','Ao lado da P�tisserie de Luxo','87654321',95);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (951,'Pra�a da Gastronomia Francesa',258,'Apartamento 5702','Pr�ximo � Brasserie Artesanal','32109876',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (952,'Rua do Crepe',147,'Loja 213','Em frente � Boulangerie Tradicional','54321098',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (953,'Avenida do Croissant',963,'Casa 57','Perto da P�tisserie Gourmet','10987654',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (954,'Travessa da Baguette',852,'Sala 57','Ao lado da Brasserie de Prest�gio','76543',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (955,'Rua do Quiche',741,'Loja 215','Pr�ximo � Boulangerie de Luxo','21098765',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (956,'Alameda do Chef',369,'Casa 30','Em frente � P�tisserie Tradicional','54321098',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (957,'Pra�a da Gastronomia Francesa',258,'Apartamento 5802','Perto da Brasserie Gourmet','87654321',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (958,'Rua do Crepe',147,'Loja 217','Ao lado da P�tisserie Artesanal','32109876',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (959,'Avenida do Croissant',963,'Casa 58','Pr�ximo � Boulangerie de Luxo','54321098',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (960,'Travessa da Baguette',852,'Sala 58','Em frente � Brasserie Tradicional','10987654',96);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (961,'Rua do Quiche',741,'Loja 219','Perto da P�tisserie Gourmet','76543210',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (962,'Alameda do Chef',369,'Casa 31','Ao lado da Brasserie de Prest�gio','21098765',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (963,'Pra�a da Gastronomia Francesa',258,'Apartamento 5902','Pr�ximo � Boulangerie Artesanal','54321098',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (964,'Rua do Crepe',147,'Loja 221','Em frente � P�tisserie de Luxo','87654321',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (965,'Avenida do Croissant',963,'Casa 59','Perto da Brasserie Tradicional','32109876',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (966,'Travessa da Baguette',852,'Sala 59','Ao lado da Boulangerie Gourmet','54321210',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (967,'Rua do Quiche',741,'Loja 223','Pr�ximo � P�tisserie Artesanal','21098765',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (968,'Alameda do Chef',369,'Casa 32','Em frente � Brasserie de Luxo','54321098',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (969,'Pra�a da Gastronomia Francesa',258,'Apartamento 6002','Perto da Boulangerie Tradicional','10987654',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (970,'Rua do Crepe',147,'Loja 225','Ao lado da Brasserie Gourmet','76543210',97);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (971,'Avenida do Croissant',963,'Casa 60','Pr�ximo � P�tisserie de Prest�gio','21098765',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (972,'Travessa da Baguette',852,'Sala 60','Em frente � Boulangerie Artesanal','54321098',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (973,'Rua do Quiche',741,'Loja 227','Perto da Brasserie de Luxo','87654321',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (974,'Alameda do Chef',369,'Casa 33','Ao lado da P�tisserie de Luxo','32109876',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (975,'Pra�a da Gastronomia Francesa',258,'Apartamento 6102','Pr�ximo � Brasserie Tradicional','54321098',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (976,'Rua do Crepe',147,'Loja 229','Em frente � Boulangerie Gourmet','10987654',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (977,'Avenida do Croissant',963,'Casa 61','Perto da P�tisserie Artesanal','76543210',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (978,'Travessa da Baguette',852,'Sala 61','Ao lado da Brasserie de Luxo','21098765',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (979,'Rua do Quiche',741,'Loja 231','Pr�ximo � P�tisserie Tradicional','54321098',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (980,'Alameda do Chef',369,'Casa 34','Em frente � Brasserie Gourmet','87654321',98);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (981,'Pra�a da Gastronomia Francesa',258,'Apartamento 6202','Perto da Boulangerie de Prest�gio','32109876',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (982,'Rua do Crepe',147,'Loja 233','Ao lado da P�tisserie de Luxo','54321098',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (983,'Avenida do Croissant',963,'Casa 62','Pr�ximo � Brasserie Tradicional','10987654',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (984,'Travessa da Baguette',852,'Sala 62','Em frente � Boulangerie Gourmet','76543210',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (985,'Rua do Quiche',741,'Loja 235','Perto da P�tisserie Artesanal','21098765',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (986,'Alameda do Chef',369,'Casa 35','Ao lado da Brasserie de Luxo','54321098',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (987,'Pra�a da Gastronomia Francesa',258,'Apartamento 6302','Pr�ximo � P�tisserie Tradicional','87654321',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (988,'Rua do Crepe',147,'Loja 237','Em frente � Boulangerie Gourmet','32109876',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (989,'Avenida do Croissant',963,'Casa 63','Perto da Brasserie de Prest�gio','54321098',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (990,'Travessa da Baguette',852,'Sala 63','Ao lado da Boulangerie Artesanal','10987654',99);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (991,'Rua do Quiche',741,'Loja 239','Pr�ximo � Brasserie de Luxo','76543210',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (992,'Alameda do Chef',369,'Casa 36','Em frente � P�tisserie de Luxo','21098765',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (993,'Pra�a da Gastronomia Francesa',258,'Apartamento 6402','Perto da Brasserie Tradicional','54321098',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (994,'Rua do Crepe',147,'Loja 241','Ao lado da Boulangerie Gourmet','87654321',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (995,'Avenida do Croissant',963,'Casa 64','Pr�ximo � P�tisserie Artesanal','32109876',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (996,'Travessa da Baguette',852,'Sala 64','Em frente � Brasserie de Luxo','54321210',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (997,'Rua do Quiche',741,'Loja 243','Perto da P�tisserie Tradicional','21098765',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (998,'Alameda do Chef',369,'Casa 37','Ao lado da Brasserie Gourmet','54321098',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (999,'Pra�a da Gastronomia Francesa',258,'Apartamento 6502','Pr�ximo � Boulangerie de Prest�gio','10987654',100);
INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) VALUES (1000,'Rua Itajuibe',5251,'Apartamento 502','Pr�ximo � Esta��o de Trem','08255710',100);
COMMIT;

--POPULANDO DADOS STATUS

INSERT INTO gs_status (cod_status, tipo_status) VALUES (1,'Aguardando Atendimento');
INSERT INTO gs_status (cod_status, tipo_status) VALUES (2,'Atendido');
INSERT INTO gs_status (cod_status, tipo_status) VALUES (3,'Atendimento Pendente');
INSERT INTO gs_status (cod_status, tipo_status) VALUES (4,'Atendimento Cancelado');
INSERT INTO gs_status (cod_status, tipo_status) VALUES (5,'Em rota para Atendimento');
COMMIT;

--POPULANDO DADOS MATERIAL

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (1,'Latas de refrigerante','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (2,'Embalagens de alimentos','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (3,'Tampas de garrafas','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (4,'Bandejas de alum�nio','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (5,'Papel alum�nio','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (6,'Perfis de janelas e portas','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (7,'Molduras de quadros','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (8,'Pe�as de bicicletas','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (9,'Utens�lios de cozinha','Aluminio');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (10,'Fios el�tricos','Aluminio');
COMMIT;

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (11,'Jornais e revistas','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (12,'Caixas de papel�o','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (13,'Papel de escrit�rio','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (14,'Folhas de caderno','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (15,'Envelopes','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (16,'Cart�es','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (17,'Rascunhos','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (18,'Papel de embrulho','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (19,'Papel de impressora','Papel');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (20,'Papel de presente','Papel');
COMMIT;

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (21,'Latas de alimentos','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (22,'Panelas velhas','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (23,'Ferramentas','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (24,'Pe�as de autom�veis','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (25,'Estruturas met�licas','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (26,'Arames','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (27,'Parafusos e porcas','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (28,'Barras de ferro','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (29,'Tubos','A�o');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (30,'Chapas de a�o','A�o');
COMMIT;

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (31,'Garrafas de vidro','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (32,'Potes de conserva','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (33,'Copos','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (34,'Vidros de janelas','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (35,'Espelhos','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (36,'L�mpadas fluorescentes','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (37,'Frascos de perfumes','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (38,'Cacos de vidro','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (39,'Ta�as','Vidro');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (40,'Vidro temperado','Vidro');
COMMIT;

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (41,'Garrafas PET','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (42,'Embalagens de shampoo','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (43,'Sacolas pl�sticas','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (44,'Tampas de recipientes','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (45,'Brinquedos','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (46,'Tubos de PVC','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (47,'Copos descart�veis','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (48,'Baldes','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (49,'Canetas','Pl�stico');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (50,'Pe�as de eletr�nicos','Pl�stico');
COMMIT;

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (51,'Ferragens','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (52,'Pe�as de m�quinas','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (53,'Utens�lios de cozinha','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (54,'Pe�as de bicicletas','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (55,'Chaves','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (56,'Parafusos','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (57,'Dobradi�as','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (58,'Fios de cobre','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (59,'Pe�as de m�veis','Metal Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (60,'Ferramentas antigas','Metal Variado');
COMMIT;

INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (61,'Livros antigos','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (62,'Cart�es postais','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (63,'Papel de embrulho decorado','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (64,'Etiquetas','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (65,'Papel de scrapbooking','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (66,'Papel de seda','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (67,'Papel de filtro de caf�','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (68,'Papel de parede','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (69,'Papel de desenho','Papel Variado');
INSERT INTO gs_materiais (cod_material, nome_material, tipo_material) VALUES (70,'Papel de origami','Papel Variado');
COMMIT;


--POPULAR DADOS COOPERATIVA

INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (1,'EcoCiclo Reciclagem Coop Ltda',7);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (2,'VerdeVida Cooperativa de Reciclagem Sustent�vel',59);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (3,'RenovaPlaneta Reciclagem Coop',338);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (4,'ReciA��o Cooperativa de Reciclagem Ambiental',468);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (5,'TerraNova Reciclagem Cooperativa',623);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (6,'CicloVerde Cooperativa de Reciclagem e Sustentabilidade',631);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (7,'PlanetaLimpo Reciclagem Cooperativa',752);
INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) VALUES (8,'EcoRenova��o Cooperativa de Reciclagem e Preserva��o',776);
COMMIT;

--POPULAR DADOS COOPERADOS

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (1,'Pedro Silva',3,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (2,'Lucas Santos',11,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (3,'Jo�o Oliveira',12,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (4,'Gabriel Costa',19,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (5,'Mateus Pereira',20,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (6,'Andr� Almeida',27,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (7,'Bruno Rodrigues',35,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (8,'Tiago Fernandes',41,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (9,'Rafael Carvalho',52,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (10,'Diego Sousa',53,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (11,'Ana Silva',64,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (12,'Mariana Santos',76,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (13,'Beatriz Oliveira',77,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (14,'Isabela Costa',85,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (15,'Carolina Pereira',88,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (16,'Juliana Almeida',90,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (17,'Larissa Rodrigues',99,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (18,'Amanda Fernandes',101,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (19,'Camila Carvalho',111,1);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (20,'Let�cia Sousa',121,1);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (21,'Guilherme Lima',132,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (22,'Fernando Gomes',142,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (23,'Vin�cius Castro',146,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (24,'Eduardo Martins',155,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (25,'Lucas Barbosa',160,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (26,'Gustavo Pereira',164,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (27,'Matheus Ribeiro',176,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (28,'Marcelo Mendes',180,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (29,'Caio Marques',187,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (30,'Daniel Ferreira',188,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (31,'Carlos Cardoso',197,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (32,'Roberto Oliveira',198,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (33,'Leonardo Andrade',210,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (34,'Ricardo Duarte',211,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (35,'Marcos Costa',214,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (36,'Lucas Ferreira',221,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (37,'Rodrigo Alves',233,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (38,'Bruno Lima',239,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (39,'Eduardo Castro',248,2);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (40,'Andr� Martins',250,2);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (41,'Vanessa Lima',254,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (42,'Fernanda Gomes',255,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (43,'Raquel Castro',261,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (44,'J�ssica Martins',263,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (45,'Bianca Barbosa',270,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (46,'Bruna Pereira',272,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (47,'Priscila Ribeiro',273,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (48,'Let�cia Mendes',279,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (49,'Patr�cia Marques',285,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (50,'Fernanda Ferreira',286,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (51,'Larissa Cardoso',291,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (52,'Amanda Oliveira',295,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (53,'Daniela Andrade',303,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (54,'Carol Duarte',309,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (55,'Michele Costa',314,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (56,'Camila Ferreira',321,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (57,'Isabela Alves',327,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (58,'Nat�lia Lima',331,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (59,'Beatriz Castro',339,3);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (60,'Mariana Martins',346,3);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (61,'Joaquim Santos',352,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (62,'Renato Cruz',356,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (63,'Gabriel Ferreira',365,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (64,'Fabr�cio Lima',373,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (65,'Felipe Oliveira',374,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (66,'Augusto Cardoso',392,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (67,'Thiago Rocha',393,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (68,'Pedro Alves',404,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (69,'Gustavo Melo',405,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (70,'Rafael Marques',425,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (71,'Leandro Costa',426,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (72,'Marcelo Silva',430,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (73,'Alan Souza',441,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (74,'Bruno Castro',444,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (75,'Douglas Pereira',445,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (76,'Marcos Santos',455,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (77,'Lucas Mendes',457,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (78,'Rodrigo Duarte',474,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (79,'Vin�cius Ferreira',483,4);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (80,'Ricardo Oliveira',492,4);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (81,'Matheus Rodrigues',502,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (82,'Eduardo Lima',503,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (83,'Diego Almeida',518,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (84,'Anderson Martins',520,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (85,'Tiago Gomes',535,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (86,'Carlos Silva',536,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (87,'Jos� Oliveira',543,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (88,'Andr� Rodrigues',547,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (89,'Alex Pereira',554,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (90,'Daniel Costa',562,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (91,'Vanessa Santos',573,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (92,'Renata Cruz',574,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (93,'Gabriela Ferreira',584,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (94,'Fabiana Lima',586,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (95,'Fernanda Oliveira',598,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (96,'Juliana Cardoso',604,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (97,'Carolina Rocha',608,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (98,'Patr�cia Alves',613,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (99,'Giovana Melo',617,5);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (100,'Renata Marques',624,5);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (101,'Let�cia Costa',628,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (102,'Marcela Silva',630,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (103,'Aline Souza',632,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (104,'Bruna Castro',646,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (105,'Rafaela Pereira',649,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (106,'Isabela Santos',653,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (107,'Luana Mendes',654,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (108,'Raquel Duarte',675,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (109,'Larissa Ferreira',676,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (110,'Amanda Oliveira',680,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (111,'Nat�lia Rodrigues',694,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (112,'Camila Lima',695,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (113,'Daniela Almeida',702,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (114,'Aline Martins',707,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (115,'Ana Gomes',717,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (116,'Maria Silva',718,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (117,'Thais Oliveira',726,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (118,'Beatriz Rodrigues',730,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (119,'Larissa Pereira',735,6);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (120,'Carolina Costa',740,6);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (121,'Renan Oliveira',741,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (122,'Lucas Torres',747,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (123,'Guilherme Costa',759,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (124,'Vitor Almeida',769,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (125,'Rafael Pereira',774,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (126,'Felipe Santos',780,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (127,'Jo�o Victor Lima',797,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (128,'Eduardo Souza',798,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (129,'Marcos Vinicius Silva',803,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (130,'Matheus Carvalho',804,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (131,'Gustavo Rocha',810,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (132,'Andr� Luiz Castro',825,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (133,'Bruno Henrique Cardoso',826,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (134,'Thiago Mendon�a',828,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (135,'Fabio Rodrigues',829,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (136,'Gabriel dos Santos',831,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (137,'Ricardo Fernandes',848,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (138,'Douglas Oliveira',849,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (139,'Leonardo Pereira',851,7);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (140,'Marcelo Cruz',852,7);
COMMIT;

INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (141,'Renata Oliveira',869,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (142,'Let�cia Torres',874,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (143,'Amanda Costa',886,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (144,'Beatriz Almeida',895,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (145,'Isabella Pereira',896,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (146,'Larissa Santos',916,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (147,'Camila Lima',925,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (148,'Juliana Souza',928,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (149,'Caroline Silva',931,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (150,'Fernanda Carvalho',934,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (151,'Thais Rocha',946,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (152,'Mariana Castro',947,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (153,'Luiza Cardoso',954,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (154,'Bruna Mendon�a',955,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (155,'Priscila Rodrigues',970,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (156,'Vanessa dos Santos',983,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (157,'Bianca Fernandes',986,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (158,'Nat�lia Oliveira',991,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (159,'Giovanna Pereira',997,8);
INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) VALUES (160,'Rafaela Cruz',998,8);
COMMIT;

--POPULANDO DADOS USUARIO

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (1,'Alice Costa Oliveira',1);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (2,'Aline Costa Martins',2);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (3,'Amanda Almeida Oliveira',4);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (4,'Amanda Almeida Silva',5);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (5,'Amanda Alves Costa',6);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (6,'Amanda Carolina Cardoso',8);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (7,'Amanda Carolina Ferreira',9);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (8,'Amanda Carolina Oliveira',10);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (9,'Amanda Carolina Rodrigues',13);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (10,'Amanda Costa Rodrigues',14);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (11,'Amanda Costa Santos',15);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (12,'Amanda Lima Almeida',16);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (13,'Amanda Lima Alves',17);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (14,'Amanda Lima Costa',18);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (15,'Amanda Lima Martins',21);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (16,'Amanda Lima Oliveira',22);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (17,'Amanda Oliveira Almeida',23);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (18,'Amanda Oliveira Lima',24);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (19,'Amanda�Cristina�Pereira',25);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (20,'Ana Almeida Costa',26);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (21,'Ana Almeida Lima',28);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (22,'Ana Almeida Martins',29);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (23,'Ana Almeida Rodrigues',30);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (24,'Ana Almeida Santos',31);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (25,'Ana Carolina Lima',32);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (26,'Ana Carolina Martins',33);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (27,'Ana Carolina Oliveira Santos',34);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (28,'Ana Carolina Pereira',36);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (29,'Ana Carolina Rodrigues',37);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (30,'Ana Carolina Santos',38);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (31,'Ana Costa Almeida',39);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (32,'Ana Costa Martins',40);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (33,'Ana Costa Oliveira',42);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (34,'Ana Lima Almeida',43);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (35,'Ana Lima Costa',44);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (36,'Ana Lima Oliveira',45);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (37,'Ana Lima Pereira',46);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (38,'Ana Lima Rodrigues',47);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (39,'Ana Oliveira Almeida',48);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (40,'Ana Oliveira Lima',49);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (41,'Ana�Carolina�Rodrigues',50);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (42,'Andr� Almeida Costa',51);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (43,'Andr� Luiz Ferreira',54);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (44,'Andr� Luiz Martins',55);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (45,'Andr� Luiz Oliveira',56);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (46,'Andr� Pereira Almeida',57);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (47,'Andr� Silva Santos',58);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (48,'Antonella Almeida Oliveira',60);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (49,'Antonella Almeida Silva',61);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (50,'Antonella Costa Lima',62);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (51,'Antonella Costa Rodrigues',63);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (52,'Antonella Lima Costa',65);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (53,'Antonella Lima Rodrigues',66);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (54,'Antonella Rodrigues Lima',67);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (55,'Arthur Almeida Costa',68);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (56,'Arthur Almeida Rodrigues',69);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (57,'Arthur Almeida Silva',70);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (58,'Arthur Costa Pereira',71);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (59,'Arthur Costa Rodrigues',72);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (60,'Arthur Lima Oliveira',73);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (61,'Arthur Lima Rodrigues',74);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (62,'Arthur Lima Santos',75);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (63,'Arthur Rodrigues Lima',78);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (64,'Beatriz Alves Oliveira',79);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (65,'Beatriz Costa Almeida',80);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (66,'Beatriz Costa Alves',81);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (67,'Beatriz Costa Oliveira',82);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (68,'Beatriz Costa Santos',83);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (69,'Beatriz Costa Silva',84);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (70,'Beatriz da Silva Santos',86);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (71,'Beatriz Lima Almeida',87);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (72,'Beatriz Lima Costa',89);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (73,'Beatriz Martins Almeida',91);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (74,'Beatriz Oliveira Alves',92);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (75,'Beatriz Oliveira Costa',93);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (76,'Beatriz Oliveira Lima',94);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (77,'Beatriz Oliveira Rodrigues',95);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (78,'Benjamin Almeida Rodrigues',96);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (79,'Benjamin Almeida Silva',97);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (80,'Benjamin Costa Rodrigues',98);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (81,'Benjamin Lima Almeida',100);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (82,'Benjamin Lima Santos',102);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (83,'Bianca Cristina Cardoso',103);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (84,'Bianca Cristina Ferreira',104);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (85,'Bianca Cristina Oliveira',105);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (86,'Bianca Cristina Pereira',106);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (87,'Bianca Cristina Santos',107);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (88,'Bianca Lima Martins',108);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (89,'Bianca Martins Silva',109);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (90,'Bianca Rodrigues Costa',110);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (91,'Bianca�Caroline�Souza',112);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (92,'Bruna Cristina Silva',113);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (93,'Bruno Almeida Lima',114);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (94,'Bruno Almeida Santos',115);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (95,'Bruno Alves Costa',116);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (96,'Bruno Costa Almeida',117);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (97,'Bruno Costa Lima',118);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (98,'Bruno Costa Pereira',119);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (99,'Bruno Henrique Pereira',120);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (100,'Bruno Lima Costa',122);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (101,'Bruno Martins Almeida',123);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (102,'Bruno Oliveira Almeida',124);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (103,'Bruno Oliveira Costa',125);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (104,'Bruno Pereira Costa',126);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (105,'Caio Costa Almeida',127);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (106,'Caio Costa Lima',128);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (107,'Caio Martins Costa',129);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (108,'Camila Almeida Oliveira',130);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (109,'Camila Almeida Pereira',131);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (110,'Camila Alves Lima',133);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (111,'Camila Beatriz Costa',134);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (112,'Camila Beatriz Ferreira',135);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (113,'Camila Beatriz Lima',136);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (114,'Camila Beatriz Rodrigues',137);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (115,'Camila Beatriz Santos',138);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (116,'Camila Lima Almeida',139);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (117,'Camila Lima Alves',140);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (118,'Camila Lima Costa',141);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (119,'Camila Lima Martins',143);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (120,'Camila Lima Oliveira',144);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (121,'Camila�Patr�cia�Ribeiro',145);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (122,'Carlos Costa Pereira',147);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (123,'Carlos Henrique Costa',148);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (124,'Carolina Almeida Rodrigues',149);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (125,'Carolina Beatriz Ferreira',150);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (126,'Carolina Beatriz Lima',151);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (127,'Carolina Beatriz Pereira',152);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (128,'Carolina Beatriz Santos',153);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (129,'Carolina Costa Lima',154);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (130,'Carolina Lima Costa',156);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (131,'Carolina Martins Almeida',157);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (132,'Carolina Martins Lima',158);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (133,'Carolina Oliveira Costa',159);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (134,'Catarina Oliveira Silva',161);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (135,'Clara Almeida Lima',162);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (136,'Clara Almeida Oliveira',163);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (137,'Clara Costa Lima',165);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (138,'Clara Costa Oliveira',166);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (139,'Clara Lima Oliveira',167);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (140,'Clara Lima Pereira',168);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (141,'Clara Lima Rodrigues',169);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (142,'Clara Oliveira Almeida',170);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (143,'Daniel Almeida Costa',171);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (144,'Daniel Almeida Lima',172);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (145,'Daniel Almeida Oliveira',173);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (146,'Daniel Almeida Pereira',174);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (147,'Daniel Almeida Silva',175);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (148,'Daniel Costa Lima',177);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (149,'Daniel Lima Almeida',178);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (150,'Daniel Lima Alves',179);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (151,'Daniel Lima Costa',181);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (152,'Daniel Lima Oliveira',182);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (153,'Daniel Lima Rodrigues',183);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (154,'Daniel Lima Silva',184);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (155,'Daniel Pereira Martins',185);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (156,'Daniel Pereira Silva',186);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (157,'Davi Lima Santos',189);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (158,'Davi Oliveira Almeida',190);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (159,'Diego da Costa Santos',191);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (160,'Eduardo Almeida Silva',192);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (161,'Eduardo Costa Almeida',193);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (162,'Eduardo Costa Lima',194);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (163,'Eduardo Costa Rodrigues',195);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (164,'Eduardo Costa Santos',196);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (165,'Eduardo Lima Costa',199);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (166,'Eduardo Lima Pereira',200);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (167,'Eduardo Lima Santos',201);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (168,'Eduardo Pereira Almeida',202);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (169,'Eduardo Rodrigues Lima',203);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (170,'Elisa Almeida Martins',204);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (171,'Elisa Costa Martins',205);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (172,'Elisa Costa Rodrigues',206);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (173,'Elisa Lima Costa',207);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (174,'Elisa Lima Oliveira',208);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (175,'Elisa Oliveira Martins',209);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (176,'Elisa Rodrigues Lima',212);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (177,'Enzo Almeida Costa',213);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (178,'Enzo Almeida Lima',215);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (179,'Enzo Almeida Silva',216);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (180,'Enzo Costa Martins',217);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (181,'Enzo Costa Oliveira',218);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (182,'Enzo Costa Pereira',219);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (183,'Enzo Costa Rodrigues',220);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (184,'Enzo Costa Santos',222);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (185,'Enzo Costa Silva',223);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (186,'Enzo Lima Almeida',224);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (187,'Enzo Lima Costa',225);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (188,'Enzo Lima Martins',226);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (189,'Enzo Lima Rodrigues',227);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (190,'Enzo Oliveira Almeida',228);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (191,'Enzo Oliveira Lima',229);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (192,'Enzo Silva Almeida',230);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (193,'Felipe Almeida Costa',231);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (194,'Felipe Almeida Pereira',232);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (195,'Felipe Alves Almeida',234);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (196,'Felipe Alves Costa',235);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (197,'Felipe Alves Lima',236);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (198,'Felipe Costa Alves',237);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (199,'Felipe Eduardo Lima',238);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (200,'Felipe Eduardo Pereira',240);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (201,'Felipe Eduardo Santos',241);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (202,'Felipe Eduardo Silva',242);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (203,'Felipe Eduardo Souza',243);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (204,'Felipe Lima Almeida',244);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (205,'Felipe Lima Oliveira',245);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (206,'Felipe Santos Almeida',246);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (207,'Felipe�Ant�nio�Barbosa',247);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (208,'Fernanda Costa Pereira',249);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (209,'Fernanda Martins Lima',251);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (210,'Fernanda Rodrigues Castro',252);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (211,'Fernanda�Isabel�Silveira',253);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (212,'Fernando Costa Almeida',256);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (213,'Fernando Lima Costa',257);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (214,'Fernando Martins Costa',258);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (215,'Gabriel Almeida Costa',259);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (216,'Gabriel Almeida Lima',260);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (217,'Gabriel Almeida Martins',262);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (218,'Gabriel Almeida Oliveira',264);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (219,'Gabriel Almeida Rodrigues',265);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (220,'Gabriel Almeida Silva',266);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (221,'Gabriel Alves Oliveira',267);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (222,'Gabriel Costa Almeida',268);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (223,'Gabriel Costa Oliveira',269);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (224,'Gabriel Costa Pereira',271);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (225,'Gabriel Costa Rodrigues',274);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (226,'Gabriel Eduardo Cardoso',275);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (227,'Gabriel Eduardo Lima',276);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (228,'Gabriel Eduardo Martins',277);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (229,'Gabriel Eduardo Santos',278);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (230,'Gabriel Lima Almeida',280);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (231,'Gabriel Lima Costa',281);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (232,'Gabriel Lima Martins',282);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (233,'Gabriel Lima Oliveira',283);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (234,'Gabriel Lima Rodrigues',284);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (235,'Gabriel Lima Silva',287);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (236,'Gabriel Martins Lima',288);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (237,'Gabriel Oliveira Almeida',289);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (238,'Gabriel Oliveira Lima',290);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (239,'Gabriel Rodrigues Almeida',292);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (240,'Gabriel Rodrigues Lima',293);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (241,'Gabriel Santos Almeida',294);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (242,'Gabriel Santos Costa',296);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (243,'Gabriela Almeida Costa',297);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (244,'Gabriela Almeida Lima',298);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (245,'Gabriela Almeida Martins',299);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (246,'Gabriela Aparecida Martins',300);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (247,'Gabriela Aparecida Pereira',301);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (248,'Gabriela Costa Almeida',302);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (249,'Gabriela Costa Lima',304);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (250,'Gabriela Lima Costa',305);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (251,'Gabriela Santos Lima',306);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (252,'Giovanna Almeida Costa',307);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (253,'Giovanna Almeida Lima',308);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (254,'Giovanna Almeida Martins',310);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (255,'Giovanna Almeida Oliveira',311);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (256,'Giovanna Almeida Silva',312);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (257,'Giovanna Costa Almeida',313);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (258,'Giovanna Costa Lima',315);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (259,'Giovanna Costa Silva',316);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (260,'Giovanna Lima Almeida',317);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (261,'Giovanna Lima Alves',318);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (262,'Giovanna Lima Rodrigues',319);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (263,'Giovanna Lima Silva',320);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (264,'Giovanna Oliveira Martins',322);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (265,'Giovanna Rodrigues Lima',323);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (266,'Guilherme Almeida Costa',324);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (267,'Guilherme Almeida Lima',325);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (268,'Guilherme Almeida Rodrigues',326);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (269,'Guilherme Costa Almeida',328);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (270,'Guilherme Costa Lima',329);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (271,'Guilherme Costa Martins',330);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (272,'Guilherme Costa Santos',332);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (273,'Guilherme da Silva Rodrigues',333);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (274,'Guilherme Lima Alves',334);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (275,'Guilherme Martins Oliveira',335);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (276,'Gustavo Almeida Costa',336);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (277,'Gustavo Almeida Ferreira',337);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (278,'Gustavo Almeida Lima',340);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (279,'Gustavo Almeida Pereira',341);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (280,'Gustavo Almeida Rodrigues',342);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (281,'Gustavo Almeida Silva',343);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (282,'Gustavo Costa Almeida',344);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (283,'Gustavo Costa Silva',345);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (284,'Gustavo da Costa Oliveira',347);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (285,'Gustavo Eduardo Costa',348);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (286,'Gustavo Lima Almeida',349);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (287,'Gustavo Lima Costa',350);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (288,'Gustavo Lima Martins',351);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (289,'Gustavo Lima Oliveira',353);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (290,'Gustavo Martins Almeida',354);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (291,'Gustavo Martins Costa',355);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (292,'Gustavo Oliveira Martins',357);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (293,'Gustavo Rodrigues Almeida',358);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (294,'Gustavo�Jos�Martins',359);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (295,'Heitor Almeida Silva',360);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (296,'Heitor Costa Pereira',361);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (297,'Heitor Costa Rodrigues',362);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (298,'Heitor Costa Santos',363);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (299,'Heitor Lima Silva',364);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (300,'Heitor Rodrigues Almeida',366);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (301,'Heitor Silva Costa',367);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (302,'Helena Almeida Costa',368);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (303,'Helena Almeida Martins',369);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (304,'Helena Almeida Oliveira',370);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (305,'Helena Almeida Rodrigues',371);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (306,'Helena Almeida Silva',372);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (307,'Helena Costa Almeida',375);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (308,'Helena Costa Martins',376);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (309,'Helena Costa Pereira',377);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (310,'Helena Costa Rodrigues',378);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (311,'Helena Costa Silva',379);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (312,'Helena Lima Almeida',380);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (313,'Helena Lima Costa',381);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (314,'Helena Lima Pereira',382);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (315,'Helena Lima Rodrigues',383);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (316,'Helena Lima Santos',384);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (317,'Helena Lima Silva',385);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (318,'Helena Oliveira Costa',386);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (319,'Helena Rodrigues Almeida',387);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (320,'Helo�sa Almeida Lima',388);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (321,'Helo�sa Almeida Martins',389);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (322,'Helo�sa Almeida Oliveira',390);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (323,'Helo�sa Almeida Silva',391);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (324,'Helo�sa Costa Rodrigues',394);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (325,'Helo�sa Lima Rodrigues',395);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (326,'Henrique Almeida Costa',396);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (327,'Henrique Almeida Santos',397);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (328,'Henrique Alves Oliveira',398);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (329,'Henrique Costa Almeida',399);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (330,'Henrique Costa Alves',400);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (331,'Henrique Costa Lima',401);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (332,'Henrique Costa Santos',402);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (333,'Henrique da Silva Oliveira',403);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (334,'Henrique Lima Almeida',406);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (335,'Henrique Lima Alves',407);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (336,'Henrique Lima Costa',408);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (337,'Henrique Oliveira Martins',409);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (338,'Henrique Santos Lima',410);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (339,'Isabel Almeida Costa',411);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (340,'Isabel Almeida Martins',412);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (341,'Isabel Almeida Oliveira',413);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (342,'Isabel Almeida Rodrigues',414);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (343,'Isabel Lima Costa',415);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (344,'Isabel Lima Pereira',416);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (345,'Isabel Lima Silva',417);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (346,'Isabela Almeida Lima',418);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (347,'Isabela Almeida Santos',419);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (348,'Isabela Alves Almeida',420);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (349,'Isabela Alves Costa',421);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (350,'Isabela Alves Lima',422);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (351,'Isabela Costa Oliveira',423);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (352,'Isabela Cristina Lima',424);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (353,'Isabela Cristina Oliveira',427);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (354,'Isabela Cristina Santos',428);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (355,'Isabela Cristina Silva',429);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (356,'Isabela Lima Alves',431);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (357,'Isabela Lima Costa',432);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (358,'Isabela Lima Martins',433);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (359,'Isabela Lima Oliveira',434);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (360,'Isabela Oliveira Almeida',435);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (361,'Isabela Oliveira Lima',436);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (362,'Isabela Oliveira Silva',437);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (363,'Isabela Santos Lima',438);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (364,'Isabela Silva Almeida',439);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (365,'Isabela�Fernanda�Santos',440);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (366,'Isabella Almeida Lima',442);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (367,'Isabella Almeida Martins',443);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (368,'Isabella Almeida Rodrigues',446);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (369,'Isabella Almeida Santos',447);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (370,'Isabella Costa Almeida',448);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (371,'Isabella Costa Lima',449);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (372,'Isabella Costa Rodrigues',450);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (373,'Isabella Lima Almeida',451);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (374,'Isabella Lima Costa',452);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (375,'Isabella Lima Martins',453);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (376,'Isabella Lima Oliveira',454);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (377,'Isabella Lima Santos',456);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (378,'Isabella Lima Silva',458);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (379,'Isabella Rodrigues Costa',459);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (380,'Isadora Almeida Alves',460);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (381,'Isadora Almeida Costa',461);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (382,'Isadora Almeida Lima',462);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (383,'Isadora Almeida Rodrigues',463);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (384,'Isadora Alves Costa',464);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (385,'Isadora Lima Costa',465);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (386,'Isadora Oliveira Almeida',466);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (387,'Isadora Oliveira Lima',467);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (388,'Jo�o Almeida Costa',469);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (389,'Jo�o Almeida Lima',470);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (390,'Jo�o Almeida Oliveira',471);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (391,'Jo�o Costa Almeida',472);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (392,'Jo�o Costa Lima',473);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (393,'Jo�o Costa Oliveira',475);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (394,'Jo�o Lima Almeida',476);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (395,'Jo�o Lima Alves',477);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (396,'Jo�o Lima Martins',478);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (397,'Jo�o Oliveira Lima',479);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (398,'Jo�o Pedro Costa Martins',480);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (399,'Jo�o Rodrigues Almeida',481);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (400,'Jo�o Silva Almeida',482);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (401,'Jo�o Silva Costa',484);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (402,'Jo�o Silva Lima',485);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (403,'Jo�o Silva Oliveira',486);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (404,'Joaquim Almeida Costa',487);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (405,'Joaquim Almeida Silva',488);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (406,'Joaquim Lima Martins',489);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (407,'Joaquim Lima Rodrigues',490);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (408,'Joaquim Lima Silva',491);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (409,'J�lia Alves Oliveira',493);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (410,'Julia Costa Lima',494);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (411,'J�lia Lima Oliveira',495);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (412,'J�lia Martins Almeida',496);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (413,'J�lia Martins Lima',497);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (414,'J�lia Martins Silva',498);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (415,'J�lia Oliveira Almeida',499);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (416,'Julia Oliveira Costa',500);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (417,'J�lia Oliveira Costa',501);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (418,'Julia Oliveira Lima',504);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (419,'J�lia Oliveira Lima',505);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (420,'Julia Santos Lima',506);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (421,'Juliana Almeida Costa',507);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (422,'Juliana Almeida Lima',508);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (423,'Juliana Almeida Oliveira',509);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (424,'Juliana Costa Lima',510);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (425,'Juliana Fernanda Costa',511);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (426,'Juliana Fernanda Lima',512);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (427,'Juliana Fernanda Martins',513);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (428,'Juliana Fernanda Pereira',514);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (429,'Juliana Fernanda Silva',515);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (430,'Juliana Fernandes Souza',516);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (431,'Juliana Lima Costa',517);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (432,'Juliana�Maria�Ferreira',519);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (433,'Larissa Almeida Costa',521);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (434,'Larissa Almeida Oliveira',522);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (435,'Larissa Almeida Rodrigues',523);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (436,'Larissa Alves Lima',524);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (437,'Larissa Alves Santos',525);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (438,'Larissa Costa Lima',526);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (439,'Larissa Costa Rodrigues',527);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (440,'Larissa Oliveira Lima',528);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (441,'Larissa Silva Almeida',529);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (442,'Larissa Vit�ria Costa',530);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (443,'Larissa Vit�ria Ferreira',531);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (444,'Larissa Vit�ria Lima',532);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (445,'Larissa Vit�ria Pereira',533);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (446,'Larissa Vit�ria Rodrigues',534);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (447,'Larissa Vit�ria Santos',537);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (448,'Larissa�Beatriz�Costa',538);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (449,'Laura Almeida Costa',539);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (450,'Laura Almeida Rodrigues',540);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (451,'Laura Almeida Santos',541);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (452,'Laura Alves Costa',542);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (453,'Laura Costa Almeida',544);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (454,'Laura Costa Alves',545);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (455,'Laura Costa Lima',546);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (456,'Laura Costa Martins',548);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (457,'Laura Costa Oliveira',549);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (458,'Laura Costa Pereira',550);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (459,'Laura Costa Santos',551);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (460,'Laura Costa Silva',552);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (461,'Laura Lima Almeida',553);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (462,'Laura Lima Martins',555);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (463,'Laura Lima Oliveira',556);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (464,'Laura Lima Pereira',557);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (465,'Laura Lima Rodrigues',558);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (466,'Laura Oliveira Almeida',559);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (467,'Laura Oliveira Alves',560);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (468,'Laura Oliveira Lima',561);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (469,'Laura Oliveira Rodrigues',563);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (470,'Laura Pereira Almeida',564);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (471,'Laura Rodrigues Lima',565);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (472,'Laura Santos Costa',566);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (473,'Leonardo Almeida Costa',567);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (474,'Leonardo Almeida Pereira',568);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (475,'Leonardo Almeida Silva',569);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (476,'Leonardo Alves Lima',570);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (477,'Leonardo Costa Almeida',571);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (478,'Leonardo Costa Lima',572);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (479,'Leonardo Costa Oliveira',575);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (480,'Leonardo Lima Alves',576);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (481,'Leonardo Lima Oliveira',577);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (482,'Leonardo Rafael Almeida',578);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (483,'Leonardo Rodrigues Lima',579);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (484,'Leonardo Santos Almeida',580);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (485,'Leonardo Santos Alves',581);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (486,'Leonardo Santos Costa',582);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (487,'Leonardo Santos Lima',583);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (488,'Leonardo�Andr�Mendes',585);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (489,'Let�cia Almeida Rodrigues',587);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (490,'Let�cia Fernandes Almeida',588);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (491,'Let�cia Lima Martins',589);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (492,'Let�cia Martins Costa',590);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (493,'Lorena Almeida Costa',591);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (494,'Lorena Almeida Rodrigues',592);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (495,'Lorena Almeida Silva',593);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (496,'Lorena Costa Lima',594);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (497,'Lorena Costa Oliveira',595);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (498,'Lorena Lima Oliveira',596);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (499,'Lorena Lima Pereira',597);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (500,'Lorenzo Almeida Costa',599);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (501,'Lorenzo Costa Almeida',600);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (502,'Lorenzo Costa Martins',601);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (503,'Lorenzo Costa Oliveira',602);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (504,'Lorenzo Costa Rodrigues',603);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (505,'Lorenzo Costa Santos',605);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (506,'Lorenzo Lima Rodrigues',606);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (507,'Lorenzo Lima Santos',607);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (508,'Lorenzo Rodrigues Lima',609);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (509,'Luana Almeida Costa',610);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (510,'Luana Almeida Lima',611);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (511,'Luana Almeida Oliveira',612);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (512,'Luana Almeida Santos',614);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (513,'Luana Costa Almeida',615);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (514,'Luana Costa Rodrigues',616);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (515,'Luana Lima Almeida',618);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (516,'Luana Lima Santos',619);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (517,'Luana Martins Almeida',620);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (518,'Luana Martins Lima',621);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (519,'Lucas Almeida Costa',622);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (520,'Lucas Almeida Lima',625);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (521,'Lucas Almeida Martins',626);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (522,'Lucas Almeida Oliveira',627);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (523,'Lucas Almeida Rodrigues',629);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (524,'Lucas Almeida Santos',633);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (525,'Lucas Almeida Silva',634);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (526,'Lucas Costa Almeida',635);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (527,'Lucas Costa Lima',636);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (528,'Lucas Costa Pereira',637);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (529,'Lucas Costa Santos',638);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (530,'Lucas Eduardo Martins',639);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (531,'Lucas Gabriel Ferreira',640);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (532,'Lucas Gabriel Martins',641);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (533,'Lucas Gabriel Silva',642);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (534,'Lucas Lima Almeida',643);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (535,'Lucas Lima Alves',644);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (536,'Lucas Lima Costa',645);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (537,'Lucas Lima Oliveira',647);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (538,'Lucas Lima Rodrigues',648);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (539,'Lucas Martins Costa',650);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (540,'Lucas Martins Lima',651);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (541,'Lucas Oliveira Almeida',652);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (542,'Lucas Oliveira Alves',655);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (543,'Lucas Oliveira Costa',656);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (544,'Lucas Oliveira Lima',657);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (545,'Lucas Oliveira Martins',658);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (546,'Lucas Pereira Rodrigues',659);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (547,'Lucas Rafael Ferreira',660);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (548,'Lucas Rafael Lima',661);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (549,'Lucas Rafael Martins',662);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (550,'Lucas Rafael Santos',663);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (551,'Lucas Rodrigues Almeida',664);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (552,'Lucas Rodrigues Lima',665);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (553,'Lucas Rodrigues Oliveira',666);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (554,'Lucas Rodrigues Silva',667);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (555,'Lucas Santos Almeida',668);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (556,'Lucas Santos Costa',669);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (557,'Lucas Santos Pereira',670);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (558,'Lucas�Henrique�Pereira',671);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (559,'Lucas�Henrique�Silva',672);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (560,'Luiza Alves Costa',673);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (561,'Luiza Costa Almeida',674);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (562,'Luiza Costa Lima',677);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (563,'Luiza Costa Santos',678);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (564,'Luiza Lima Oliveira',679);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (565,'Luiza Lima Rodrigues',681);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (566,'Luiza Oliveira Alves',682);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (567,'Manuela Almeida Costa',683);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (568,'Manuela Almeida Lima',684);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (569,'Manuela Almeida Martins',685);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (570,'Manuela Costa Almeida',686);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (571,'Manuela Costa Lima',687);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (572,'Manuela Costa Oliveira',688);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (573,'Manuela Lima Oliveira',689);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (574,'Manuela Lima Pereira',690);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (575,'Manuela Martins Almeida',691);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (576,'Manuela Martins Lima',692);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (577,'Manuela Oliveira Costa',693);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (578,'Manuela Oliveira Lima',696);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (579,'Manuela Oliveira Martins',697);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (580,'Marcos Almeida Costa',698);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (581,'Marcos Costa Lima',699);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (582,'Marcos Lima Almeida',700);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (583,'Marcos Lima Alves',701);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (584,'Marcos Lima Oliveira',703);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (585,'Marcos Vinicius Cardoso',704);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (586,'Marcos Vinicius Ferreira',705);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (587,'Marcos Vinicius Rodrigues',706);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (588,'Marcos Vinicius Santos',708);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (589,'Maria Almeida Costa',709);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (590,'Maria Almeida Lima',710);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (591,'Maria Almeida Oliveira',711);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (592,'Maria Almeida Pereira',712);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (593,'Maria Almeida Santos',713);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (594,'Maria Alves Almeida',714);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (595,'Maria Costa Almeida',715);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (596,'Maria Costa Lima',716);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (597,'Maria Lima Alves',719);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (598,'Maria Lima Oliveira',720);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (599,'Maria Lima Rodrigues',721);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (600,'Maria Lima Santos',722);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (601,'Maria Lima Silva',723);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (602,'Maria Martins Lima',724);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (603,'Maria Oliveira Almeida',725);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (604,'Maria Oliveira Lima',727);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (605,'Maria Rodrigues Almeida',728);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (606,'Mariana Almeida Alves',729);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (607,'Mariana Almeida Costa',731);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (608,'Mariana Almeida Lima',732);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (609,'Mariana Alves Costa',733);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (610,'Mariana Alves Lima',734);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (611,'Mariana Costa Almeida',736);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (612,'Mariana Costa Alves',737);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (613,'Mariana Costa Lima',738);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (614,'Mariana Costa Oliveira',739);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (615,'Mariana Costa Rodrigues',742);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (616,'Mariana dos Santos Castro',743);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (617,'Mariana Fernanda Cardoso',744);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (618,'Mariana Fernanda Martins',745);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (619,'Mariana Fernanda Oliveira',746);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (620,'Mariana Fernanda Rodrigues',748);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (621,'Mariana Fernanda Silva',749);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (622,'Mariana Lima Oliveira',750);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (623,'Mariana Martins Almeida',751);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (624,'Mariana Oliveira Alves',753);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (625,'Mariana Oliveira Lima',754);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (626,'Mariana Oliveira Santos',755);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (627,'Marina Costa Almeida',756);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (628,'Marina Martins Lima',757);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (629,'Marina Oliveira Martins',758);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (630,'Marina Silva Santos',760);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (631,'Mateus Costa Lima',761);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (632,'Mateus Lima Almeida',762);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (633,'Mateus Lima Costa',763);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (634,'Mateus Lima Oliveira',764);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (635,'Mateus Oliveira Lima',765);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (636,'Matheus Almeida Costa',766);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (637,'Matheus Almeida Lima',767);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (638,'Matheus Almeida Martins',768);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (639,'Matheus Almeida Rodrigues',770);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (640,'Matheus Almeida Silva',771);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (641,'Matheus Alves Costa',772);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (642,'Matheus Alves Lima',773);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (643,'Matheus Alves Santos',775);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (644,'Matheus Costa Almeida',777);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (645,'Matheus Costa Lima',778);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (646,'Matheus Costa Pereira',779);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (647,'Matheus Costa Rodrigues',781);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (648,'Matheus Henrique Oliveira',782);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (649,'Matheus Lima Almeida',783);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (650,'Matheus Lima Alves',784);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (651,'Matheus Lima Costa',785);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (652,'Matheus Lima Martins',786);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (653,'Matheus Lima Pereira',787);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (654,'Matheus Lima Rodrigues',788);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (655,'Matheus Martins Almeida',789);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (656,'Matheus Oliveira Almeida',790);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (657,'Matheus Oliveira Lima',791);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (658,'Matheus Oliveira Rodrigues',792);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (659,'Matheus Oliveira Santos',793);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (660,'Matheus Pereira Lima',794);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (661,'Matheus Silva Almeida',795);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (662,'Matheus Vinicius Costa',796);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (663,'Matheus Vinicius Oliveira',799);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (664,'Matheus Vinicius Pereira',800);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (665,'Matheus�Gabriel�Almeida',801);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (666,'Matias Lima Oliveira',802);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (667,'Matias Silva Costa',805);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (668,'Maya Almeida Costa',806);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (669,'Maya Costa Almeida',807);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (670,'Maya Costa Lima',808);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (671,'Maya Costa Martins',809);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (672,'Maya Costa Oliveira',811);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (673,'Maya Lima Rodrigues',812);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (674,'Maya Lima Silva',813);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (675,'Miguel Almeida Costa',814);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (676,'Miguel Almeida Martins',815);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (677,'Miguel Almeida Rodrigues',816);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (678,'Miguel Almeida Silva',817);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (679,'Miguel Alves Costa',818);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (680,'Miguel Alves Lima',819);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (681,'Miguel Alves Oliveira',820);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (682,'Miguel Costa Almeida',821);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (683,'Miguel Costa Lima',822);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (684,'Miguel Costa Pereira',823);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (685,'Miguel Costa Rodrigues',824);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (686,'Miguel Costa Santos',827);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (687,'Miguel Lima Almeida',830);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (688,'Miguel Lima Alves',832);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (689,'Miguel Lima Santos',833);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (690,'Miguel Lima Silva',834);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (691,'Miguel Oliveira Costa',835);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (692,'Miguel Oliveira Santos',836);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (693,'Miguel Pereira Silva',837);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (694,'Miguel Rodrigues Costa',838);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (695,'Miguel Santos Rodrigues',839);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (696,'Nat�lia�Aparecida�Dias',840);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (697,'Nicolas Almeida Silva',841);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (698,'Pedro Almeida Alves',842);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (699,'Pedro Almeida Costa',843);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (700,'Pedro Almeida Lima',844);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (701,'Pedro Almeida Oliveira',845);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (702,'Pedro Almeida Santos',846);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (703,'Pedro Almeida Silva',847);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (704,'Pedro Alves Costa',850);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (705,'Pedro Costa Almeida',853);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (706,'Pedro Costa Lima',854);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (707,'Pedro Costa Martins',855);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (708,'Pedro Henrique Cardoso',856);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (709,'Pedro Henrique Oliveira',857);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (710,'Pedro Henrique Rodrigues',858);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (711,'Pedro Henrique Santos',859);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (712,'Pedro Henrique Silva',860);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (713,'Pedro Lima Martins',861);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (714,'Pedro Lima Oliveira',862);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (715,'Pedro Martins Almeida',863);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (716,'Pedro Oliveira Lima',864);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (717,'Pedro Oliveira Santos',865);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (718,'Pedro Rodrigues Almeida',866);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (719,'Pedro�Augusto�Oliveira',867);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (720,'Rafael Almeida Pereira',868);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (721,'Rafael Almeida Rodrigues',870);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (722,'Rafael Costa Lima',871);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (723,'Rafael Lima Martins',872);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (724,'Rafael Lima Oliveira',873);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (725,'Rafael Lima Silva',875);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (726,'Rafael Oliveira Almeida',876);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (727,'Rafael Oliveira Alves',877);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (728,'Rafael Oliveira Costa',878);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (729,'Rafael Oliveira Lima',879);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (730,'Rafael Oliveira Martins',880);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (731,'Rafael Pereira Almeida',881);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (732,'Rafael Rodrigues Almeida',882);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (733,'Rafael�Eduardo�Nascimento',883);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (734,'Rafaela Almeida Costa',884);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (735,'Rafaela Almeida Lima',885);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (736,'Rafaela Almeida Oliveira',887);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (737,'Rafaela Almeida Rodrigues',888);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (738,'Rafaela Almeida Santos',889);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (739,'Rafaela Almeida Silva',890);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (740,'Rafaela Alves Lima',891);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (741,'Rafaela Costa Almeida',892);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (742,'Rafaela Costa Alves',893);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (743,'Rafaela Costa Lima',894);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (744,'Rafaela Costa Santos',897);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (745,'Rafaela Lima Almeida',898);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (746,'Rafaela Lima Martins',899);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (747,'Rafaela Lima Oliveira',900);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (748,'Rafaela Martins Lima',901);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (749,'Rafaela Oliveira Almeida',902);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (750,'Rafaela Oliveira Costa',903);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (751,'Rafaela Oliveira Lima',904);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (752,'Rafaela Oliveira Martins',905);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (753,'Renata Almeida Rodrigues',906);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (754,'Renata Cristina Pereira',907);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (755,'Renata Lima Martins',908);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (756,'Renata Martins Lima',909);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (757,'Renata Oliveira Lima',910);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (758,'Renato Almeida Oliveira',911);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (759,'Ricardo da Costa Pereira',912);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (760,'Rodrigo Alves Oliveira',913);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (761,'Rodrigo Costa Almeida',914);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (762,'Rodrigo Lima Costa',915);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (763,'Samuel Almeida Silva',917);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (764,'Sofia Almeida Lima',918);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (765,'Sofia Almeida Martins',919);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (766,'Sofia Almeida Oliveira',920);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (767,'Sofia Almeida Santos',921);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (768,'Sofia Alves Oliveira',922);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (769,'Sofia Costa Almeida',923);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (770,'Sofia Costa Lima',924);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (771,'Sofia Costa Martins',926);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (772,'Sofia Costa Oliveira',927);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (773,'Sofia Lima Almeida',929);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (774,'Sofia Lima Martins',930);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (775,'Sofia Oliveira Alves',932);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (776,'Sofia Oliveira Lima',933);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (777,'Sofia Oliveira Martins',935);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (778,'Sofia Oliveira Santos',936);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (779,'Sophia Almeida Costa',937);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (780,'Sophia Almeida Lima',938);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (781,'Sophia Almeida Silva',939);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (782,'Sophia Costa Rodrigues',940);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (783,'Sophia Costa Silva',941);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (784,'Sophia Lima Almeida',942);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (785,'Sophia Lima Oliveira',943);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (786,'Sophia Rodrigues Lima',944);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (787,'Sophia Silva Lima',945);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (788,'Theo Almeida Costa',948);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (789,'Theo Almeida Martins',949);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (790,'Theo Almeida Silva',950);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (791,'Theo Costa Almeida',951);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (792,'Theo Lima Almeida',952);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (793,'Theo Lima Martins',953);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (794,'Theo Lima Silva',956);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (795,'Theo Silva Lima',957);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (796,'Thiago Almeida Costa',958);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (797,'Thiago Almeida Martins',959);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (798,'Thiago Costa Alves',960);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (799,'Thiago Costa Oliveira',961);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (800,'Thiago da Silva Pereira',962);
COMMIT;

INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (801,'Thiago Henrique Costa',963);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (802,'Thiago Henrique Ferreira',964);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (803,'Thiago Henrique Lima',965);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (804,'Thiago Henrique Martins',966);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (805,'Thiago Henrique Santos',967);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (806,'Thiago Lima Costa',968);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (807,'Thiago Lima Martins',969);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (808,'Thiago Rodrigues Castro',971);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (809,'Thiago�Luiz�Gon�alves',972);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (810,'Valentina Almeida Costa',973);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (811,'Valentina Almeida Lima',974);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (812,'Valentina Costa Pereira',975);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (813,'Valentina Costa Rodrigues',976);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (814,'Valentina Costa Santos',977);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (815,'Valentina Costa Silva',978);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (816,'Valentina Lima Rodrigues',979);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (817,'Valentina Lima Santos',980);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (818,'Valentina Oliveira Costa',981);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (819,'Valentina Rodrigues Almeida',982);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (820,'Valentina Rodrigues Costa',984);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (821,'Vanessa Lima Rodrigues',985);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (822,'Vanessa Martins Lima',987);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (823,'Vanessa Santos Pereira',988);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (824,'Victor Oliveira Almeida',989);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (825,'Vin�cius Almeida Costa',990);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (826,'Vin�cius Costa Almeida',992);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (827,'Vin�cius Costa Oliveira',993);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (828,'Vin�cius Lima Costa',994);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (829,'Vin�cius Oliveira Almeida',995);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (830,'Vin�cius Pereira Lima',996);
INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) VALUES (831,'Vin�cius�Ricardo�Gomes',999);
COMMIT;


--POPULANDO DADOS PEDIDOS

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (1,TO_DATE('10/04/2024','DD-MM-YYYY'),57,13,1,4,1);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (2,TO_DATE('04/04/2024','DD-MM-YYYY'),139,16,2,4,2);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (3,TO_DATE('20/04/2024','DD-MM-YYYY'),244,1,3,4,3);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (4,TO_DATE('16/04/2024','DD-MM-YYYY'),136,37,4,3,4);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (5,TO_DATE('14/04/2024','DD-MM-YYYY'),149,19,5,2,5);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (6,TO_DATE('08/04/2024','DD-MM-YYYY'),143,58,6,4,6);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (7,TO_DATE('23/04/2024','DD-MM-YYYY'),158,21,7,4,7);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (8,TO_DATE('06/04/2024','DD-MM-YYYY'),73,68,8,1,8);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (9,TO_DATE('03/04/2024','DD-MM-YYYY'),26,55,9,4,9);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (10,TO_DATE('25/04/2024','DD-MM-YYYY'),252,39,10,5,10);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (11,TO_DATE('19/04/2024','DD-MM-YYYY'),38,50,11,5,11);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (12,TO_DATE('14/04/2024','DD-MM-YYYY'),27,66,12,5,12);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (13,TO_DATE('13/04/2024','DD-MM-YYYY'),95,4,13,5,13);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (14,TO_DATE('08/04/2024','DD-MM-YYYY'),243,59,14,2,14);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (15,TO_DATE('09/04/2024','DD-MM-YYYY'),24,60,15,3,15);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (16,TO_DATE('02/04/2024','DD-MM-YYYY'),240,16,16,2,16);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (17,TO_DATE('13/04/2024','DD-MM-YYYY'),235,32,17,5,17);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (18,TO_DATE('01/04/2024','DD-MM-YYYY'),20,14,18,3,18);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (19,TO_DATE('25/04/2024','DD-MM-YYYY'),26,49,19,4,19);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (20,TO_DATE('30/04/2024','DD-MM-YYYY'),153,59,20,1,20);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (21,TO_DATE('20/04/2024','DD-MM-YYYY'),181,8,21,1,21);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (22,TO_DATE('17/04/2024','DD-MM-YYYY'),165,17,22,4,22);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (23,TO_DATE('17/04/2024','DD-MM-YYYY'),98,12,23,2,23);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (24,TO_DATE('13/04/2024','DD-MM-YYYY'),22,10,24,5,24);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (25,TO_DATE('23/04/2024','DD-MM-YYYY'),68,6,25,2,25);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (26,TO_DATE('11/04/2024','DD-MM-YYYY'),106,39,26,4,26);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (27,TO_DATE('26/04/2024','DD-MM-YYYY'),50,40,27,5,27);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (28,TO_DATE('07/04/2024','DD-MM-YYYY'),64,21,28,4,28);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (29,TO_DATE('30/04/2024','DD-MM-YYYY'),88,4,29,5,29);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (30,TO_DATE('25/04/2024','DD-MM-YYYY'),48,27,30,4,30);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (31,TO_DATE('04/04/2024','DD-MM-YYYY'),116,22,31,2,31);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (32,TO_DATE('26/04/2024','DD-MM-YYYY'),66,25,32,4,32);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (33,TO_DATE('03/04/2024','DD-MM-YYYY'),211,1,33,4,33);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (34,TO_DATE('15/04/2024','DD-MM-YYYY'),105,26,34,1,34);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (35,TO_DATE('25/04/2024','DD-MM-YYYY'),168,36,35,3,35);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (36,TO_DATE('22/04/2024','DD-MM-YYYY'),47,50,36,5,36);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (37,TO_DATE('12/04/2024','DD-MM-YYYY'),209,34,37,5,37);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (38,TO_DATE('16/04/2024','DD-MM-YYYY'),52,69,38,5,38);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (39,TO_DATE('22/04/2024','DD-MM-YYYY'),135,50,39,2,39);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (40,TO_DATE('05/04/2024','DD-MM-YYYY'),171,58,40,5,40);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (41,TO_DATE('15/04/2024','DD-MM-YYYY'),85,58,41,5,1);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (42,TO_DATE('06/04/2024','DD-MM-YYYY'),44,60,42,5,2);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (43,TO_DATE('25/04/2024','DD-MM-YYYY'),193,37,43,4,3);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (44,TO_DATE('05/04/2024','DD-MM-YYYY'),79,42,44,2,4);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (45,TO_DATE('02/04/2024','DD-MM-YYYY'),184,8,45,5,5);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (46,TO_DATE('19/04/2024','DD-MM-YYYY'),19,11,46,3,6);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (47,TO_DATE('10/04/2024','DD-MM-YYYY'),123,39,47,3,7);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (48,TO_DATE('16/04/2024','DD-MM-YYYY'),161,25,48,3,8);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (49,TO_DATE('11/04/2024','DD-MM-YYYY'),222,8,49,5,9);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (50,TO_DATE('26/04/2024','DD-MM-YYYY'),193,15,50,3,10);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (51,TO_DATE('26/04/2024','DD-MM-YYYY'),102,60,51,2,11);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (52,TO_DATE('14/04/2024','DD-MM-YYYY'),250,10,52,1,12);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (53,TO_DATE('24/04/2024','DD-MM-YYYY'),76,8,53,4,13);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (54,TO_DATE('26/04/2024','DD-MM-YYYY'),113,14,54,3,14);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (55,TO_DATE('30/04/2024','DD-MM-YYYY'),13,50,55,1,15);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (56,TO_DATE('17/04/2024','DD-MM-YYYY'),191,24,56,4,16);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (57,TO_DATE('03/04/2024','DD-MM-YYYY'),27,36,57,2,17);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (58,TO_DATE('26/04/2024','DD-MM-YYYY'),246,15,58,5,18);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (59,TO_DATE('29/04/2024','DD-MM-YYYY'),52,16,59,3,19);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (60,TO_DATE('15/04/2024','DD-MM-YYYY'),80,25,60,2,20);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (61,TO_DATE('14/04/2024','DD-MM-YYYY'),111,69,61,2,21);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (62,TO_DATE('20/04/2024','DD-MM-YYYY'),109,48,62,5,22);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (63,TO_DATE('28/04/2024','DD-MM-YYYY'),199,22,63,5,23);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (64,TO_DATE('12/04/2024','DD-MM-YYYY'),33,69,64,3,24);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (65,TO_DATE('27/04/2024','DD-MM-YYYY'),249,31,65,2,25);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (66,TO_DATE('24/04/2024','DD-MM-YYYY'),227,12,66,1,26);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (67,TO_DATE('21/04/2024','DD-MM-YYYY'),246,27,67,3,27);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (68,TO_DATE('05/04/2024','DD-MM-YYYY'),223,13,68,5,28);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (69,TO_DATE('24/04/2024','DD-MM-YYYY'),11,50,69,2,29);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (70,TO_DATE('02/04/2024','DD-MM-YYYY'),129,21,70,3,30);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (71,TO_DATE('21/04/2024','DD-MM-YYYY'),11,1,71,3,31);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (72,TO_DATE('11/04/2024','DD-MM-YYYY'),40,68,72,3,32);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (73,TO_DATE('16/04/2024','DD-MM-YYYY'),164,27,73,5,33);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (74,TO_DATE('04/04/2024','DD-MM-YYYY'),105,27,74,3,34);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (75,TO_DATE('20/04/2024','DD-MM-YYYY'),114,16,75,2,35);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (76,TO_DATE('13/04/2024','DD-MM-YYYY'),189,31,76,2,36);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (77,TO_DATE('25/04/2024','DD-MM-YYYY'),35,42,77,2,37);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (78,TO_DATE('04/04/2024','DD-MM-YYYY'),234,21,78,4,38);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (79,TO_DATE('09/04/2024','DD-MM-YYYY'),104,20,79,3,39);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (80,TO_DATE('07/04/2024','DD-MM-YYYY'),217,21,80,5,40);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (81,TO_DATE('11/04/2024','DD-MM-YYYY'),138,66,81,1,1);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (82,TO_DATE('30/04/2024','DD-MM-YYYY'),71,70,82,5,2);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (83,TO_DATE('10/04/2024','DD-MM-YYYY'),114,28,83,1,3);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (84,TO_DATE('29/04/2024','DD-MM-YYYY'),90,40,84,2,4);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (85,TO_DATE('15/04/2024','DD-MM-YYYY'),11,49,85,3,5);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (86,TO_DATE('09/04/2024','DD-MM-YYYY'),138,42,86,5,6);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (87,TO_DATE('13/04/2024','DD-MM-YYYY'),205,62,87,1,7);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (88,TO_DATE('16/04/2024','DD-MM-YYYY'),111,68,88,4,8);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (89,TO_DATE('08/04/2024','DD-MM-YYYY'),76,1,89,5,9);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (90,TO_DATE('06/04/2024','DD-MM-YYYY'),194,46,90,4,10);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (91,TO_DATE('30/04/2024','DD-MM-YYYY'),214,50,91,3,11);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (92,TO_DATE('08/04/2024','DD-MM-YYYY'),45,17,92,3,12);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (93,TO_DATE('11/04/2024','DD-MM-YYYY'),70,35,93,3,13);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (94,TO_DATE('14/04/2024','DD-MM-YYYY'),244,52,94,5,14);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (95,TO_DATE('17/04/2024','DD-MM-YYYY'),88,60,95,3,15);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (96,TO_DATE('13/04/2024','DD-MM-YYYY'),63,65,96,2,16);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (97,TO_DATE('02/04/2024','DD-MM-YYYY'),143,36,97,5,17);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (98,TO_DATE('11/04/2024','DD-MM-YYYY'),185,64,98,3,18);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (99,TO_DATE('18/04/2024','DD-MM-YYYY'),46,1,99,3,19);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (100,TO_DATE('24/04/2024','DD-MM-YYYY'),141,46,100,4,20);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (101,TO_DATE('22/04/2024','DD-MM-YYYY'),71,19,101,5,21);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (102,TO_DATE('06/04/2024','DD-MM-YYYY'),269,42,102,5,22);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (103,TO_DATE('29/04/2024','DD-MM-YYYY'),183,32,103,2,23);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (104,TO_DATE('19/04/2024','DD-MM-YYYY'),210,6,104,3,24);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (105,TO_DATE('02/04/2024','DD-MM-YYYY'),95,40,105,5,25);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (106,TO_DATE('02/04/2024','DD-MM-YYYY'),194,55,106,5,26);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (107,TO_DATE('18/04/2024','DD-MM-YYYY'),40,21,107,2,27);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (108,TO_DATE('20/04/2024','DD-MM-YYYY'),191,67,108,4,28);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (109,TO_DATE('29/04/2024','DD-MM-YYYY'),56,55,109,2,29);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (110,TO_DATE('13/04/2024','DD-MM-YYYY'),119,62,110,4,30);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (111,TO_DATE('12/04/2024','DD-MM-YYYY'),212,31,111,4,31);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (112,TO_DATE('13/04/2024','DD-MM-YYYY'),225,7,112,5,32);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (113,TO_DATE('08/04/2024','DD-MM-YYYY'),19,68,113,5,33);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (114,TO_DATE('17/04/2024','DD-MM-YYYY'),103,42,114,5,34);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (115,TO_DATE('07/04/2024','DD-MM-YYYY'),212,12,115,5,35);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (116,TO_DATE('20/04/2024','DD-MM-YYYY'),206,27,116,1,36);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (117,TO_DATE('30/04/2024','DD-MM-YYYY'),57,25,117,5,37);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (118,TO_DATE('18/04/2024','DD-MM-YYYY'),278,63,118,3,38);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (119,TO_DATE('01/04/2024','DD-MM-YYYY'),107,31,119,4,39);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (120,TO_DATE('20/04/2024','DD-MM-YYYY'),70,30,120,3,40);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (121,TO_DATE('20/04/2024','DD-MM-YYYY'),88,44,121,4,1);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (122,TO_DATE('02/04/2024','DD-MM-YYYY'),124,63,122,5,2);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (123,TO_DATE('06/04/2024','DD-MM-YYYY'),164,57,123,2,3);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (124,TO_DATE('13/04/2024','DD-MM-YYYY'),145,19,124,5,4);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (125,TO_DATE('13/04/2024','DD-MM-YYYY'),91,28,125,5,5);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (126,TO_DATE('19/04/2024','DD-MM-YYYY'),219,38,126,3,6);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (127,TO_DATE('04/04/2024','DD-MM-YYYY'),250,16,127,4,7);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (128,TO_DATE('23/04/2024','DD-MM-YYYY'),102,64,128,3,8);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (129,TO_DATE('09/04/2024','DD-MM-YYYY'),142,26,129,4,9);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (130,TO_DATE('18/04/2024','DD-MM-YYYY'),157,59,130,5,10);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (131,TO_DATE('04/04/2024','DD-MM-YYYY'),86,31,131,4,11);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (132,TO_DATE('17/04/2024','DD-MM-YYYY'),228,10,132,4,12);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (133,TO_DATE('25/04/2024','DD-MM-YYYY'),18,37,133,1,13);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (134,TO_DATE('26/04/2024','DD-MM-YYYY'),199,48,134,5,14);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (135,TO_DATE('02/04/2024','DD-MM-YYYY'),92,26,135,1,15);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (136,TO_DATE('12/04/2024','DD-MM-YYYY'),151,27,136,1,16);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (137,TO_DATE('20/04/2024','DD-MM-YYYY'),97,47,137,1,17);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (138,TO_DATE('16/04/2024','DD-MM-YYYY'),173,64,138,2,18);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (139,TO_DATE('05/04/2024','DD-MM-YYYY'),124,16,139,1,19);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (140,TO_DATE('03/04/2024','DD-MM-YYYY'),261,39,140,3,20);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (141,TO_DATE('24/04/2024','DD-MM-YYYY'),140,16,141,3,21);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (142,TO_DATE('08/04/2024','DD-MM-YYYY'),45,1,142,1,22);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (143,TO_DATE('09/04/2024','DD-MM-YYYY'),169,44,143,3,23);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (144,TO_DATE('12/04/2024','DD-MM-YYYY'),252,52,144,1,24);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (145,TO_DATE('08/04/2024','DD-MM-YYYY'),37,59,145,3,25);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (146,TO_DATE('17/04/2024','DD-MM-YYYY'),182,65,146,2,26);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (147,TO_DATE('28/04/2024','DD-MM-YYYY'),134,56,147,5,27);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (148,TO_DATE('15/04/2024','DD-MM-YYYY'),241,42,148,4,28);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (149,TO_DATE('14/04/2024','DD-MM-YYYY'),97,11,149,2,29);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (150,TO_DATE('06/04/2024','DD-MM-YYYY'),38,62,150,5,30);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (151,TO_DATE('25/04/2024','DD-MM-YYYY'),134,34,151,2,31);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (152,TO_DATE('14/04/2024','DD-MM-YYYY'),254,48,152,3,32);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (153,TO_DATE('21/04/2024','DD-MM-YYYY'),55,17,153,4,33);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (154,TO_DATE('08/04/2024','DD-MM-YYYY'),192,38,154,3,34);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (155,TO_DATE('15/04/2024','DD-MM-YYYY'),194,53,155,5,35);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (156,TO_DATE('09/04/2024','DD-MM-YYYY'),54,64,156,4,36);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (157,TO_DATE('19/04/2024','DD-MM-YYYY'),247,25,157,4,37);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (158,TO_DATE('14/04/2024','DD-MM-YYYY'),194,62,158,5,38);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (159,TO_DATE('19/04/2024','DD-MM-YYYY'),124,8,159,1,39);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (160,TO_DATE('02/04/2024','DD-MM-YYYY'),263,34,160,4,40);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (161,TO_DATE('08/04/2024','DD-MM-YYYY'),148,3,161,4,1);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (162,TO_DATE('06/04/2024','DD-MM-YYYY'),210,30,162,1,2);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (163,TO_DATE('16/04/2024','DD-MM-YYYY'),251,35,163,4,3);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (164,TO_DATE('18/04/2024','DD-MM-YYYY'),141,23,164,5,4);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (165,TO_DATE('29/04/2024','DD-MM-YYYY'),12,46,165,2,5);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (166,TO_DATE('03/04/2024','DD-MM-YYYY'),95,6,166,4,6);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (167,TO_DATE('19/04/2024','DD-MM-YYYY'),23,52,167,5,7);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (168,TO_DATE('26/04/2024','DD-MM-YYYY'),98,20,168,4,8);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (169,TO_DATE('12/04/2024','DD-MM-YYYY'),263,30,169,3,9);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (170,TO_DATE('15/04/2024','DD-MM-YYYY'),191,65,170,4,10);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (171,TO_DATE('03/04/2024','DD-MM-YYYY'),91,24,171,4,11);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (172,TO_DATE('04/04/2024','DD-MM-YYYY'),140,34,172,3,12);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (173,TO_DATE('28/04/2024','DD-MM-YYYY'),133,4,173,4,13);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (174,TO_DATE('17/04/2024','DD-MM-YYYY'),164,55,174,5,14);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (175,TO_DATE('20/04/2024','DD-MM-YYYY'),68,54,175,4,15);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (176,TO_DATE('19/04/2024','DD-MM-YYYY'),197,52,176,1,16);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (177,TO_DATE('02/04/2024','DD-MM-YYYY'),246,44,177,4,17);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (178,TO_DATE('09/04/2024','DD-MM-YYYY'),130,46,178,3,18);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (179,TO_DATE('22/04/2024','DD-MM-YYYY'),175,6,179,5,19);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (180,TO_DATE('20/04/2024','DD-MM-YYYY'),55,56,180,4,20);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (181,TO_DATE('22/04/2024','DD-MM-YYYY'),89,67,181,1,21);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (182,TO_DATE('21/04/2024','DD-MM-YYYY'),17,16,182,1,22);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (183,TO_DATE('18/04/2024','DD-MM-YYYY'),82,30,183,3,23);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (184,TO_DATE('04/04/2024','DD-MM-YYYY'),60,35,184,2,24);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (185,TO_DATE('17/04/2024','DD-MM-YYYY'),234,70,185,3,25);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (186,TO_DATE('26/04/2024','DD-MM-YYYY'),54,13,186,5,26);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (187,TO_DATE('21/04/2024','DD-MM-YYYY'),86,5,187,4,27);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (188,TO_DATE('23/04/2024','DD-MM-YYYY'),116,49,188,5,28);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (189,TO_DATE('22/04/2024','DD-MM-YYYY'),248,26,189,1,29);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (190,TO_DATE('11/04/2024','DD-MM-YYYY'),253,52,190,5,30);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (191,TO_DATE('02/04/2024','DD-MM-YYYY'),236,44,191,2,31);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (192,TO_DATE('16/04/2024','DD-MM-YYYY'),252,25,192,2,32);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (193,TO_DATE('29/04/2024','DD-MM-YYYY'),73,49,193,5,33);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (194,TO_DATE('01/04/2024','DD-MM-YYYY'),87,23,194,1,34);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (195,TO_DATE('29/04/2024','DD-MM-YYYY'),200,49,195,5,35);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (196,TO_DATE('02/04/2024','DD-MM-YYYY'),235,16,196,3,36);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (197,TO_DATE('15/04/2024','DD-MM-YYYY'),254,45,197,5,37);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (198,TO_DATE('30/04/2024','DD-MM-YYYY'),72,66,198,2,38);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (199,TO_DATE('27/04/2024','DD-MM-YYYY'),81,33,199,5,39);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (200,TO_DATE('19/04/2024','DD-MM-YYYY'),209,25,200,2,40);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (201,TO_DATE('15/04/2024','DD-MM-YYYY'),166,10,201,4,14);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (202,TO_DATE('26/04/2024','DD-MM-YYYY'),175,49,202,3,15);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (203,TO_DATE('02/04/2024','DD-MM-YYYY'),94,55,203,3,16);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (204,TO_DATE('26/04/2024','DD-MM-YYYY'),12,68,204,4,17);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (205,TO_DATE('15/04/2024','DD-MM-YYYY'),26,55,205,2,18);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (206,TO_DATE('07/04/2024','DD-MM-YYYY'),274,26,206,1,19);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (207,TO_DATE('10/04/2024','DD-MM-YYYY'),249,47,207,4,20);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (208,TO_DATE('02/04/2024','DD-MM-YYYY'),134,46,208,3,21);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (209,TO_DATE('02/04/2024','DD-MM-YYYY'),127,21,209,2,41);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (210,TO_DATE('16/04/2024','DD-MM-YYYY'),71,30,210,2,42);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (211,TO_DATE('11/04/2024','DD-MM-YYYY'),239,13,211,4,43);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (212,TO_DATE('17/04/2024','DD-MM-YYYY'),130,61,212,2,44);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (213,TO_DATE('04/04/2024','DD-MM-YYYY'),245,28,213,3,45);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (214,TO_DATE('24/04/2024','DD-MM-YYYY'),145,32,214,2,46);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (215,TO_DATE('06/04/2024','DD-MM-YYYY'),266,49,215,2,47);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (216,TO_DATE('06/04/2024','DD-MM-YYYY'),35,24,216,1,48);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (217,TO_DATE('24/04/2024','DD-MM-YYYY'),88,54,217,4,49);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (218,TO_DATE('27/04/2024','DD-MM-YYYY'),10,4,218,5,50);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (219,TO_DATE('30/04/2024','DD-MM-YYYY'),135,56,219,1,51);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (220,TO_DATE('26/04/2024','DD-MM-YYYY'),222,14,220,3,52);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (221,TO_DATE('15/04/2024','DD-MM-YYYY'),240,9,221,5,53);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (222,TO_DATE('18/04/2024','DD-MM-YYYY'),72,68,222,3,54);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (223,TO_DATE('19/04/2024','DD-MM-YYYY'),122,5,223,1,55);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (224,TO_DATE('28/04/2024','DD-MM-YYYY'),99,4,224,1,56);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (225,TO_DATE('04/04/2024','DD-MM-YYYY'),165,29,225,4,57);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (226,TO_DATE('14/04/2024','DD-MM-YYYY'),22,16,226,3,58);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (227,TO_DATE('24/04/2024','DD-MM-YYYY'),143,23,227,1,59);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (228,TO_DATE('18/04/2024','DD-MM-YYYY'),264,27,228,1,60);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (229,TO_DATE('08/04/2024','DD-MM-YYYY'),206,29,229,5,61);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (230,TO_DATE('21/04/2024','DD-MM-YYYY'),130,7,230,1,62);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (231,TO_DATE('23/04/2024','DD-MM-YYYY'),225,25,231,1,63);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (232,TO_DATE('27/04/2024','DD-MM-YYYY'),11,47,232,1,64);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (233,TO_DATE('26/04/2024','DD-MM-YYYY'),200,32,233,1,65);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (234,TO_DATE('15/04/2024','DD-MM-YYYY'),101,10,234,5,66);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (235,TO_DATE('21/04/2024','DD-MM-YYYY'),119,16,235,1,67);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (236,TO_DATE('21/04/2024','DD-MM-YYYY'),175,49,236,3,68);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (237,TO_DATE('30/04/2024','DD-MM-YYYY'),65,48,237,2,69);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (238,TO_DATE('25/04/2024','DD-MM-YYYY'),112,58,238,3,70);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (239,TO_DATE('28/04/2024','DD-MM-YYYY'),256,20,239,3,71);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (240,TO_DATE('15/04/2024','DD-MM-YYYY'),84,38,240,1,72);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (241,TO_DATE('21/04/2024','DD-MM-YYYY'),276,35,241,5,73);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (242,TO_DATE('24/04/2024','DD-MM-YYYY'),163,4,242,4,74);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (243,TO_DATE('20/04/2024','DD-MM-YYYY'),151,47,243,1,75);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (244,TO_DATE('30/04/2024','DD-MM-YYYY'),117,31,244,3,76);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (245,TO_DATE('06/04/2024','DD-MM-YYYY'),121,19,245,1,77);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (246,TO_DATE('19/04/2024','DD-MM-YYYY'),26,35,246,4,78);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (247,TO_DATE('09/04/2024','DD-MM-YYYY'),265,46,247,4,79);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (248,TO_DATE('29/04/2024','DD-MM-YYYY'),175,19,248,1,80);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (249,TO_DATE('07/04/2024','DD-MM-YYYY'),141,46,249,3,41);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (250,TO_DATE('14/04/2024','DD-MM-YYYY'),53,54,250,3,42);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (251,TO_DATE('06/04/2024','DD-MM-YYYY'),13,44,251,3,43);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (252,TO_DATE('25/04/2024','DD-MM-YYYY'),232,22,252,4,44);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (253,TO_DATE('12/04/2024','DD-MM-YYYY'),208,14,253,4,45);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (254,TO_DATE('09/04/2024','DD-MM-YYYY'),183,39,254,4,46);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (255,TO_DATE('05/04/2024','DD-MM-YYYY'),56,17,255,5,47);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (256,TO_DATE('28/04/2024','DD-MM-YYYY'),77,7,256,3,48);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (257,TO_DATE('11/04/2024','DD-MM-YYYY'),227,31,257,4,49);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (258,TO_DATE('05/04/2024','DD-MM-YYYY'),253,4,258,4,50);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (259,TO_DATE('11/04/2024','DD-MM-YYYY'),213,40,259,1,51);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (260,TO_DATE('01/04/2024','DD-MM-YYYY'),56,68,260,1,52);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (261,TO_DATE('29/04/2024','DD-MM-YYYY'),95,62,261,4,53);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (262,TO_DATE('10/04/2024','DD-MM-YYYY'),180,12,262,5,54);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (263,TO_DATE('13/04/2024','DD-MM-YYYY'),81,65,263,4,55);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (264,TO_DATE('09/04/2024','DD-MM-YYYY'),46,4,264,1,56);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (265,TO_DATE('15/04/2024','DD-MM-YYYY'),16,61,265,3,57);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (266,TO_DATE('08/04/2024','DD-MM-YYYY'),134,57,266,4,58);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (267,TO_DATE('05/04/2024','DD-MM-YYYY'),21,27,267,2,59);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (268,TO_DATE('04/04/2024','DD-MM-YYYY'),229,70,268,4,60);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (269,TO_DATE('03/04/2024','DD-MM-YYYY'),33,47,269,1,61);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (270,TO_DATE('24/04/2024','DD-MM-YYYY'),269,11,270,3,62);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (271,TO_DATE('16/04/2024','DD-MM-YYYY'),239,43,271,3,63);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (272,TO_DATE('23/04/2024','DD-MM-YYYY'),267,45,272,1,64);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (273,TO_DATE('07/04/2024','DD-MM-YYYY'),46,21,273,1,65);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (274,TO_DATE('09/04/2024','DD-MM-YYYY'),151,64,274,4,66);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (275,TO_DATE('27/04/2024','DD-MM-YYYY'),99,41,275,5,67);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (276,TO_DATE('29/04/2024','DD-MM-YYYY'),11,29,276,2,68);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (277,TO_DATE('27/04/2024','DD-MM-YYYY'),263,5,277,2,69);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (278,TO_DATE('06/04/2024','DD-MM-YYYY'),108,1,278,2,70);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (279,TO_DATE('07/04/2024','DD-MM-YYYY'),109,3,279,4,71);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (280,TO_DATE('28/04/2024','DD-MM-YYYY'),265,31,280,5,72);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (281,TO_DATE('30/04/2024','DD-MM-YYYY'),219,56,281,2,73);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (282,TO_DATE('08/04/2024','DD-MM-YYYY'),36,37,282,4,74);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (283,TO_DATE('16/04/2024','DD-MM-YYYY'),74,47,283,5,75);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (284,TO_DATE('22/04/2024','DD-MM-YYYY'),72,25,284,2,76);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (285,TO_DATE('03/04/2024','DD-MM-YYYY'),72,2,285,1,77);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (286,TO_DATE('30/04/2024','DD-MM-YYYY'),218,17,286,5,78);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (287,TO_DATE('04/04/2024','DD-MM-YYYY'),11,28,287,1,79);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (288,TO_DATE('18/04/2024','DD-MM-YYYY'),104,46,288,3,80);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (289,TO_DATE('14/04/2024','DD-MM-YYYY'),160,40,289,2,41);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (290,TO_DATE('29/04/2024','DD-MM-YYYY'),222,64,290,1,42);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (291,TO_DATE('10/04/2024','DD-MM-YYYY'),198,56,291,2,43);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (292,TO_DATE('30/04/2024','DD-MM-YYYY'),217,44,292,4,44);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (293,TO_DATE('14/04/2024','DD-MM-YYYY'),262,53,293,5,45);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (294,TO_DATE('03/04/2024','DD-MM-YYYY'),205,63,294,4,46);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (295,TO_DATE('06/04/2024','DD-MM-YYYY'),266,51,295,3,47);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (296,TO_DATE('05/04/2024','DD-MM-YYYY'),11,60,296,1,48);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (297,TO_DATE('20/04/2024','DD-MM-YYYY'),69,23,297,4,49);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (298,TO_DATE('25/04/2024','DD-MM-YYYY'),216,60,298,4,50);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (299,TO_DATE('15/04/2024','DD-MM-YYYY'),191,39,299,3,51);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (300,TO_DATE('29/04/2024','DD-MM-YYYY'),173,60,300,4,52);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (301,TO_DATE('22/04/2024','DD-MM-YYYY'),73,37,301,5,53);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (302,TO_DATE('08/04/2024','DD-MM-YYYY'),206,69,302,3,54);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (303,TO_DATE('28/04/2024','DD-MM-YYYY'),209,56,303,1,55);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (304,TO_DATE('03/04/2024','DD-MM-YYYY'),77,52,304,4,56);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (305,TO_DATE('19/04/2024','DD-MM-YYYY'),241,23,305,5,57);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (306,TO_DATE('03/04/2024','DD-MM-YYYY'),263,56,306,2,58);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (307,TO_DATE('10/04/2024','DD-MM-YYYY'),230,52,307,3,59);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (308,TO_DATE('05/04/2024','DD-MM-YYYY'),47,52,308,5,60);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (309,TO_DATE('28/04/2024','DD-MM-YYYY'),100,27,309,5,61);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (310,TO_DATE('15/04/2024','DD-MM-YYYY'),132,61,310,4,62);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (311,TO_DATE('19/04/2024','DD-MM-YYYY'),246,7,311,5,63);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (312,TO_DATE('23/04/2024','DD-MM-YYYY'),48,62,312,1,64);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (313,TO_DATE('11/04/2024','DD-MM-YYYY'),187,67,313,2,65);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (314,TO_DATE('28/04/2024','DD-MM-YYYY'),13,1,314,1,66);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (315,TO_DATE('02/04/2024','DD-MM-YYYY'),150,63,315,1,67);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (316,TO_DATE('27/04/2024','DD-MM-YYYY'),130,16,316,2,68);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (317,TO_DATE('23/04/2024','DD-MM-YYYY'),226,21,317,5,69);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (318,TO_DATE('25/04/2024','DD-MM-YYYY'),18,61,318,2,70);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (319,TO_DATE('26/04/2024','DD-MM-YYYY'),251,45,319,2,71);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (320,TO_DATE('15/04/2024','DD-MM-YYYY'),80,24,320,1,72);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (321,TO_DATE('24/04/2024','DD-MM-YYYY'),202,67,321,2,73);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (322,TO_DATE('10/04/2024','DD-MM-YYYY'),86,64,322,2,74);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (323,TO_DATE('06/04/2024','DD-MM-YYYY'),105,43,323,1,75);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (324,TO_DATE('17/04/2024','DD-MM-YYYY'),39,48,324,5,76);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (325,TO_DATE('01/04/2024','DD-MM-YYYY'),59,10,325,5,77);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (326,TO_DATE('27/04/2024','DD-MM-YYYY'),152,36,326,5,78);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (327,TO_DATE('02/04/2024','DD-MM-YYYY'),191,61,327,5,79);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (328,TO_DATE('19/04/2024','DD-MM-YYYY'),112,60,328,5,80);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (329,TO_DATE('24/04/2024','DD-MM-YYYY'),170,31,329,1,41);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (330,TO_DATE('16/04/2024','DD-MM-YYYY'),160,38,330,2,42);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (331,TO_DATE('01/04/2024','DD-MM-YYYY'),211,46,331,3,43);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (332,TO_DATE('13/04/2024','DD-MM-YYYY'),230,40,332,1,44);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (333,TO_DATE('09/04/2024','DD-MM-YYYY'),230,9,333,1,45);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (334,TO_DATE('21/04/2024','DD-MM-YYYY'),24,21,334,4,46);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (335,TO_DATE('23/04/2024','DD-MM-YYYY'),79,8,335,5,47);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (336,TO_DATE('06/04/2024','DD-MM-YYYY'),23,55,336,2,48);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (337,TO_DATE('23/04/2024','DD-MM-YYYY'),195,25,337,3,49);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (338,TO_DATE('29/04/2024','DD-MM-YYYY'),26,28,338,4,50);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (339,TO_DATE('06/04/2024','DD-MM-YYYY'),134,8,339,5,51);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (340,TO_DATE('03/04/2024','DD-MM-YYYY'),212,16,340,5,52);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (341,TO_DATE('12/04/2024','DD-MM-YYYY'),104,25,341,3,53);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (342,TO_DATE('01/04/2024','DD-MM-YYYY'),102,43,342,2,54);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (343,TO_DATE('14/04/2024','DD-MM-YYYY'),268,9,343,4,55);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (344,TO_DATE('14/04/2024','DD-MM-YYYY'),12,62,344,1,56);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (345,TO_DATE('12/04/2024','DD-MM-YYYY'),61,1,345,4,57);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (346,TO_DATE('23/04/2024','DD-MM-YYYY'),217,2,346,5,58);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (347,TO_DATE('03/04/2024','DD-MM-YYYY'),42,60,347,3,59);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (348,TO_DATE('03/04/2024','DD-MM-YYYY'),183,70,348,2,60);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (349,TO_DATE('23/04/2024','DD-MM-YYYY'),199,29,349,2,61);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (350,TO_DATE('24/04/2024','DD-MM-YYYY'),14,19,350,5,62);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (351,TO_DATE('26/04/2024','DD-MM-YYYY'),107,54,351,2,63);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (352,TO_DATE('27/04/2024','DD-MM-YYYY'),197,47,352,1,64);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (353,TO_DATE('28/04/2024','DD-MM-YYYY'),182,10,353,1,65);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (354,TO_DATE('18/04/2024','DD-MM-YYYY'),256,5,354,2,66);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (355,TO_DATE('24/04/2024','DD-MM-YYYY'),32,38,355,3,67);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (356,TO_DATE('04/04/2024','DD-MM-YYYY'),248,68,356,2,68);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (357,TO_DATE('28/04/2024','DD-MM-YYYY'),176,61,357,5,69);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (358,TO_DATE('28/04/2024','DD-MM-YYYY'),57,23,358,5,70);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (359,TO_DATE('25/04/2024','DD-MM-YYYY'),224,64,359,3,71);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (360,TO_DATE('22/04/2024','DD-MM-YYYY'),58,6,360,4,72);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (361,TO_DATE('07/04/2024','DD-MM-YYYY'),12,40,361,1,73);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (362,TO_DATE('16/04/2024','DD-MM-YYYY'),107,47,362,1,74);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (363,TO_DATE('16/04/2024','DD-MM-YYYY'),37,65,363,1,75);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (364,TO_DATE('26/04/2024','DD-MM-YYYY'),215,39,364,5,76);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (365,TO_DATE('25/04/2024','DD-MM-YYYY'),70,24,365,1,77);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (366,TO_DATE('15/04/2024','DD-MM-YYYY'),185,23,366,3,78);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (367,TO_DATE('01/04/2024','DD-MM-YYYY'),72,34,367,2,79);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (368,TO_DATE('27/04/2024','DD-MM-YYYY'),124,25,368,1,80);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (369,TO_DATE('05/04/2024','DD-MM-YYYY'),109,49,369,1,41);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (370,TO_DATE('11/04/2024','DD-MM-YYYY'),251,29,370,1,42);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (371,TO_DATE('27/04/2024','DD-MM-YYYY'),190,57,371,4,43);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (372,TO_DATE('03/04/2024','DD-MM-YYYY'),19,56,372,5,44);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (373,TO_DATE('09/04/2024','DD-MM-YYYY'),241,4,373,1,45);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (374,TO_DATE('09/04/2024','DD-MM-YYYY'),272,58,374,2,46);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (375,TO_DATE('29/04/2024','DD-MM-YYYY'),75,17,375,1,47);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (376,TO_DATE('03/04/2024','DD-MM-YYYY'),78,6,376,3,48);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (377,TO_DATE('11/04/2024','DD-MM-YYYY'),129,37,377,3,49);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (378,TO_DATE('19/04/2024','DD-MM-YYYY'),258,36,378,4,50);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (379,TO_DATE('25/04/2024','DD-MM-YYYY'),129,55,379,4,51);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (380,TO_DATE('24/04/2024','DD-MM-YYYY'),200,10,380,5,52);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (381,TO_DATE('23/04/2024','DD-MM-YYYY'),22,62,381,3,53);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (382,TO_DATE('05/04/2024','DD-MM-YYYY'),98,63,382,2,54);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (383,TO_DATE('11/04/2024','DD-MM-YYYY'),140,40,383,3,55);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (384,TO_DATE('30/04/2024','DD-MM-YYYY'),130,56,384,3,56);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (385,TO_DATE('07/04/2024','DD-MM-YYYY'),182,60,385,2,57);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (386,TO_DATE('03/04/2024','DD-MM-YYYY'),65,58,386,5,58);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (387,TO_DATE('30/04/2024','DD-MM-YYYY'),244,12,387,5,59);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (388,TO_DATE('14/04/2024','DD-MM-YYYY'),124,55,388,5,60);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (389,TO_DATE('30/04/2024','DD-MM-YYYY'),144,46,389,5,61);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (390,TO_DATE('26/04/2024','DD-MM-YYYY'),118,53,390,2,62);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (391,TO_DATE('17/04/2024','DD-MM-YYYY'),109,36,391,5,63);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (392,TO_DATE('29/04/2024','DD-MM-YYYY'),245,41,392,2,64);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (393,TO_DATE('13/04/2024','DD-MM-YYYY'),70,3,393,4,65);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (394,TO_DATE('14/04/2024','DD-MM-YYYY'),139,50,394,2,66);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (395,TO_DATE('06/04/2024','DD-MM-YYYY'),58,14,395,4,67);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (396,TO_DATE('28/04/2024','DD-MM-YYYY'),44,28,396,1,68);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (397,TO_DATE('10/04/2024','DD-MM-YYYY'),276,3,397,1,69);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (398,TO_DATE('11/04/2024','DD-MM-YYYY'),40,35,398,3,70);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (399,TO_DATE('04/04/2024','DD-MM-YYYY'),76,63,399,3,71);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (400,TO_DATE('23/04/2024','DD-MM-YYYY'),278,11,400,2,72);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (401,TO_DATE('08/04/2024','DD-MM-YYYY'),64,31,401,3,73);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (402,TO_DATE('20/04/2024','DD-MM-YYYY'),254,39,402,4,74);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (403,TO_DATE('01/04/2024','DD-MM-YYYY'),79,25,403,5,75);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (404,TO_DATE('18/04/2024','DD-MM-YYYY'),114,59,404,1,76);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (405,TO_DATE('11/04/2024','DD-MM-YYYY'),280,30,405,4,77);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (406,TO_DATE('20/04/2024','DD-MM-YYYY'),253,13,406,1,78);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (407,TO_DATE('14/04/2024','DD-MM-YYYY'),20,63,407,5,79);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (408,TO_DATE('17/04/2024','DD-MM-YYYY'),246,11,408,2,80);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (409,TO_DATE('18/04/2024','DD-MM-YYYY'),88,35,409,3,45);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (410,TO_DATE('28/04/2024','DD-MM-YYYY'),275,31,410,5,46);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (411,TO_DATE('14/04/2024','DD-MM-YYYY'),124,51,411,3,47);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (412,TO_DATE('16/04/2024','DD-MM-YYYY'),38,7,412,3,48);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (413,TO_DATE('04/04/2024','DD-MM-YYYY'),41,63,413,1,49);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (414,TO_DATE('14/04/2024','DD-MM-YYYY'),241,28,414,1,50);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (415,TO_DATE('24/04/2024','DD-MM-YYYY'),115,2,415,1,51);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (416,TO_DATE('14/04/2024','DD-MM-YYYY'),15,43,416,1,52);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (417,TO_DATE('05/04/2024','DD-MM-YYYY'),61,19,417,1,81);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (418,TO_DATE('25/04/2024','DD-MM-YYYY'),177,5,418,4,82);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (419,TO_DATE('06/04/2024','DD-MM-YYYY'),175,61,419,1,83);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (420,TO_DATE('17/04/2024','DD-MM-YYYY'),74,46,420,4,84);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (421,TO_DATE('03/04/2024','DD-MM-YYYY'),234,17,421,4,85);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (422,TO_DATE('15/04/2024','DD-MM-YYYY'),37,23,422,4,86);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (423,TO_DATE('27/04/2024','DD-MM-YYYY'),262,11,423,5,87);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (424,TO_DATE('19/04/2024','DD-MM-YYYY'),94,31,424,3,88);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (425,TO_DATE('09/04/2024','DD-MM-YYYY'),18,38,425,3,89);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (426,TO_DATE('07/04/2024','DD-MM-YYYY'),259,56,426,2,90);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (427,TO_DATE('27/04/2024','DD-MM-YYYY'),213,15,427,4,91);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (428,TO_DATE('24/04/2024','DD-MM-YYYY'),14,44,428,3,92);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (429,TO_DATE('02/04/2024','DD-MM-YYYY'),260,29,429,1,93);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (430,TO_DATE('14/04/2024','DD-MM-YYYY'),93,57,430,5,94);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (431,TO_DATE('27/04/2024','DD-MM-YYYY'),52,32,431,3,95);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (432,TO_DATE('19/04/2024','DD-MM-YYYY'),67,16,432,2,96);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (433,TO_DATE('09/04/2024','DD-MM-YYYY'),201,36,433,3,97);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (434,TO_DATE('30/04/2024','DD-MM-YYYY'),217,66,434,4,98);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (435,TO_DATE('03/04/2024','DD-MM-YYYY'),43,38,435,1,99);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (436,TO_DATE('16/04/2024','DD-MM-YYYY'),30,10,436,3,100);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (437,TO_DATE('30/04/2024','DD-MM-YYYY'),114,64,437,2,101);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (438,TO_DATE('25/04/2024','DD-MM-YYYY'),94,64,438,5,102);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (439,TO_DATE('15/04/2024','DD-MM-YYYY'),257,5,439,4,103);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (440,TO_DATE('07/04/2024','DD-MM-YYYY'),167,65,440,3,104);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (441,TO_DATE('04/04/2024','DD-MM-YYYY'),173,51,441,4,105);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (442,TO_DATE('28/04/2024','DD-MM-YYYY'),73,9,442,4,106);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (443,TO_DATE('08/04/2024','DD-MM-YYYY'),170,15,443,3,107);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (444,TO_DATE('25/04/2024','DD-MM-YYYY'),78,20,444,1,108);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (445,TO_DATE('26/04/2024','DD-MM-YYYY'),124,13,445,3,109);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (446,TO_DATE('14/04/2024','DD-MM-YYYY'),231,34,446,1,110);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (447,TO_DATE('14/04/2024','DD-MM-YYYY'),201,48,447,3,111);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (448,TO_DATE('09/04/2024','DD-MM-YYYY'),124,6,448,5,112);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (449,TO_DATE('20/04/2024','DD-MM-YYYY'),159,48,449,5,113);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (450,TO_DATE('23/04/2024','DD-MM-YYYY'),257,40,450,4,114);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (451,TO_DATE('24/04/2024','DD-MM-YYYY'),137,11,451,4,115);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (452,TO_DATE('04/04/2024','DD-MM-YYYY'),129,19,452,1,116);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (453,TO_DATE('23/04/2024','DD-MM-YYYY'),229,62,453,4,117);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (454,TO_DATE('29/04/2024','DD-MM-YYYY'),238,5,454,1,118);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (455,TO_DATE('14/04/2024','DD-MM-YYYY'),12,53,455,5,119);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (456,TO_DATE('01/04/2024','DD-MM-YYYY'),226,29,456,3,120);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (457,TO_DATE('25/04/2024','DD-MM-YYYY'),243,25,457,2,81);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (458,TO_DATE('26/04/2024','DD-MM-YYYY'),21,70,458,2,82);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (459,TO_DATE('14/04/2024','DD-MM-YYYY'),65,68,459,3,83);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (460,TO_DATE('10/04/2024','DD-MM-YYYY'),128,65,460,2,84);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (461,TO_DATE('30/04/2024','DD-MM-YYYY'),257,47,461,3,85);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (462,TO_DATE('30/04/2024','DD-MM-YYYY'),272,70,462,1,86);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (463,TO_DATE('27/04/2024','DD-MM-YYYY'),230,52,463,1,87);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (464,TO_DATE('26/04/2024','DD-MM-YYYY'),45,27,464,3,88);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (465,TO_DATE('04/04/2024','DD-MM-YYYY'),109,9,465,3,89);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (466,TO_DATE('24/04/2024','DD-MM-YYYY'),274,41,466,4,90);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (467,TO_DATE('03/04/2024','DD-MM-YYYY'),200,47,467,3,91);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (468,TO_DATE('06/04/2024','DD-MM-YYYY'),87,28,468,4,92);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (469,TO_DATE('16/04/2024','DD-MM-YYYY'),128,44,469,2,93);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (470,TO_DATE('02/04/2024','DD-MM-YYYY'),130,21,470,5,94);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (471,TO_DATE('27/04/2024','DD-MM-YYYY'),40,50,471,5,95);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (472,TO_DATE('17/04/2024','DD-MM-YYYY'),17,12,472,2,96);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (473,TO_DATE('02/04/2024','DD-MM-YYYY'),110,49,473,5,97);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (474,TO_DATE('11/04/2024','DD-MM-YYYY'),226,26,474,2,98);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (475,TO_DATE('30/04/2024','DD-MM-YYYY'),189,40,475,1,99);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (476,TO_DATE('10/04/2024','DD-MM-YYYY'),263,14,476,1,100);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (477,TO_DATE('19/04/2024','DD-MM-YYYY'),130,63,477,4,101);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (478,TO_DATE('20/04/2024','DD-MM-YYYY'),39,51,478,4,102);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (479,TO_DATE('10/04/2024','DD-MM-YYYY'),102,41,479,3,103);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (480,TO_DATE('22/04/2024','DD-MM-YYYY'),250,31,480,4,104);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (481,TO_DATE('07/04/2024','DD-MM-YYYY'),19,31,481,1,105);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (482,TO_DATE('17/04/2024','DD-MM-YYYY'),41,32,482,3,106);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (483,TO_DATE('19/04/2024','DD-MM-YYYY'),202,50,483,4,107);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (484,TO_DATE('24/04/2024','DD-MM-YYYY'),172,24,484,5,108);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (485,TO_DATE('03/04/2024','DD-MM-YYYY'),258,60,485,5,109);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (486,TO_DATE('05/04/2024','DD-MM-YYYY'),133,23,486,2,110);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (487,TO_DATE('07/04/2024','DD-MM-YYYY'),173,58,487,5,111);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (488,TO_DATE('06/04/2024','DD-MM-YYYY'),199,51,488,3,112);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (489,TO_DATE('13/04/2024','DD-MM-YYYY'),71,24,489,3,113);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (490,TO_DATE('11/04/2024','DD-MM-YYYY'),228,69,490,1,114);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (491,TO_DATE('24/04/2024','DD-MM-YYYY'),151,62,491,1,115);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (492,TO_DATE('15/04/2024','DD-MM-YYYY'),81,15,492,5,116);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (493,TO_DATE('12/04/2024','DD-MM-YYYY'),135,58,493,2,117);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (494,TO_DATE('26/04/2024','DD-MM-YYYY'),223,20,494,5,118);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (495,TO_DATE('27/04/2024','DD-MM-YYYY'),155,60,495,1,119);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (496,TO_DATE('03/04/2024','DD-MM-YYYY'),24,45,496,4,120);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (497,TO_DATE('06/04/2024','DD-MM-YYYY'),255,38,497,1,81);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (498,TO_DATE('19/04/2024','DD-MM-YYYY'),28,70,498,2,82);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (499,TO_DATE('17/04/2024','DD-MM-YYYY'),20,3,499,1,83);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (500,TO_DATE('18/04/2024','DD-MM-YYYY'),158,38,500,5,84);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (501,TO_DATE('29/04/2024','DD-MM-YYYY'),154,41,501,1,85);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (502,TO_DATE('16/04/2024','DD-MM-YYYY'),160,4,502,4,86);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (503,TO_DATE('30/04/2024','DD-MM-YYYY'),120,6,503,1,87);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (504,TO_DATE('12/04/2024','DD-MM-YYYY'),177,15,504,5,88);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (505,TO_DATE('18/04/2024','DD-MM-YYYY'),15,7,505,3,89);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (506,TO_DATE('09/04/2024','DD-MM-YYYY'),26,21,506,2,90);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (507,TO_DATE('05/04/2024','DD-MM-YYYY'),47,52,507,2,91);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (508,TO_DATE('14/04/2024','DD-MM-YYYY'),33,38,508,3,92);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (509,TO_DATE('21/04/2024','DD-MM-YYYY'),130,12,509,4,93);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (510,TO_DATE('14/04/2024','DD-MM-YYYY'),191,26,510,2,94);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (511,TO_DATE('06/04/2024','DD-MM-YYYY'),246,6,511,2,95);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (512,TO_DATE('28/04/2024','DD-MM-YYYY'),206,49,512,4,96);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (513,TO_DATE('19/04/2024','DD-MM-YYYY'),238,46,513,2,97);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (514,TO_DATE('30/04/2024','DD-MM-YYYY'),149,25,514,1,98);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (515,TO_DATE('18/04/2024','DD-MM-YYYY'),202,39,515,2,99);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (516,TO_DATE('27/04/2024','DD-MM-YYYY'),76,33,516,1,100);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (517,TO_DATE('07/04/2024','DD-MM-YYYY'),167,10,517,3,101);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (518,TO_DATE('11/04/2024','DD-MM-YYYY'),194,41,518,2,102);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (519,TO_DATE('11/04/2024','DD-MM-YYYY'),199,36,519,3,103);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (520,TO_DATE('28/04/2024','DD-MM-YYYY'),258,47,520,5,104);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (521,TO_DATE('01/04/2024','DD-MM-YYYY'),37,28,521,1,105);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (522,TO_DATE('10/04/2024','DD-MM-YYYY'),240,51,522,2,106);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (523,TO_DATE('01/04/2024','DD-MM-YYYY'),242,64,523,1,107);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (524,TO_DATE('02/04/2024','DD-MM-YYYY'),111,28,524,4,108);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (525,TO_DATE('17/04/2024','DD-MM-YYYY'),168,45,525,3,109);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (526,TO_DATE('20/04/2024','DD-MM-YYYY'),184,21,526,3,110);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (527,TO_DATE('17/04/2024','DD-MM-YYYY'),68,53,527,1,111);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (528,TO_DATE('19/04/2024','DD-MM-YYYY'),279,2,528,3,112);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (529,TO_DATE('20/04/2024','DD-MM-YYYY'),47,30,529,3,113);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (530,TO_DATE('28/04/2024','DD-MM-YYYY'),237,30,530,3,114);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (531,TO_DATE('01/04/2024','DD-MM-YYYY'),219,31,531,3,115);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (532,TO_DATE('28/04/2024','DD-MM-YYYY'),222,40,532,3,116);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (533,TO_DATE('06/04/2024','DD-MM-YYYY'),165,26,533,2,117);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (534,TO_DATE('13/04/2024','DD-MM-YYYY'),180,26,534,5,118);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (535,TO_DATE('16/04/2024','DD-MM-YYYY'),81,54,535,4,119);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (536,TO_DATE('22/04/2024','DD-MM-YYYY'),274,10,536,4,120);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (537,TO_DATE('26/04/2024','DD-MM-YYYY'),26,55,537,5,81);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (538,TO_DATE('26/04/2024','DD-MM-YYYY'),94,21,538,5,82);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (539,TO_DATE('08/04/2024','DD-MM-YYYY'),261,58,539,3,83);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (540,TO_DATE('26/04/2024','DD-MM-YYYY'),207,1,540,3,84);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (541,TO_DATE('20/04/2024','DD-MM-YYYY'),169,54,541,5,85);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (542,TO_DATE('04/04/2024','DD-MM-YYYY'),79,32,542,1,86);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (543,TO_DATE('20/04/2024','DD-MM-YYYY'),254,24,543,5,87);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (544,TO_DATE('16/04/2024','DD-MM-YYYY'),135,57,544,5,88);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (545,TO_DATE('10/04/2024','DD-MM-YYYY'),246,70,545,3,89);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (546,TO_DATE('22/04/2024','DD-MM-YYYY'),237,30,546,4,90);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (547,TO_DATE('16/04/2024','DD-MM-YYYY'),214,58,547,3,91);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (548,TO_DATE('19/04/2024','DD-MM-YYYY'),271,60,548,5,92);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (549,TO_DATE('29/04/2024','DD-MM-YYYY'),272,21,549,2,93);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (550,TO_DATE('05/04/2024','DD-MM-YYYY'),124,2,550,5,94);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (551,TO_DATE('22/04/2024','DD-MM-YYYY'),241,7,551,4,95);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (552,TO_DATE('07/04/2024','DD-MM-YYYY'),95,53,552,2,96);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (553,TO_DATE('02/04/2024','DD-MM-YYYY'),244,4,553,4,97);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (554,TO_DATE('30/04/2024','DD-MM-YYYY'),235,41,554,3,98);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (555,TO_DATE('20/04/2024','DD-MM-YYYY'),248,64,555,2,99);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (556,TO_DATE('27/04/2024','DD-MM-YYYY'),106,31,556,5,100);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (557,TO_DATE('30/04/2024','DD-MM-YYYY'),194,28,557,5,101);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (558,TO_DATE('24/04/2024','DD-MM-YYYY'),140,66,558,1,102);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (559,TO_DATE('23/04/2024','DD-MM-YYYY'),222,49,559,4,103);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (560,TO_DATE('24/04/2024','DD-MM-YYYY'),239,67,560,1,104);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (561,TO_DATE('01/04/2024','DD-MM-YYYY'),157,16,561,2,105);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (562,TO_DATE('21/04/2024','DD-MM-YYYY'),183,30,562,4,106);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (563,TO_DATE('15/04/2024','DD-MM-YYYY'),205,19,563,3,107);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (564,TO_DATE('10/04/2024','DD-MM-YYYY'),16,45,564,2,108);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (565,TO_DATE('16/04/2024','DD-MM-YYYY'),254,59,565,5,109);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (566,TO_DATE('04/04/2024','DD-MM-YYYY'),30,28,566,4,110);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (567,TO_DATE('15/04/2024','DD-MM-YYYY'),74,61,567,2,111);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (568,TO_DATE('09/04/2024','DD-MM-YYYY'),79,8,568,2,112);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (569,TO_DATE('15/04/2024','DD-MM-YYYY'),179,60,569,1,113);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (570,TO_DATE('26/04/2024','DD-MM-YYYY'),99,67,570,3,114);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (571,TO_DATE('22/04/2024','DD-MM-YYYY'),223,52,571,4,115);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (572,TO_DATE('19/04/2024','DD-MM-YYYY'),191,59,572,5,116);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (573,TO_DATE('12/04/2024','DD-MM-YYYY'),18,30,573,5,117);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (574,TO_DATE('17/04/2024','DD-MM-YYYY'),79,62,574,4,118);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (575,TO_DATE('28/04/2024','DD-MM-YYYY'),45,61,575,2,119);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (576,TO_DATE('03/04/2024','DD-MM-YYYY'),152,39,576,3,120);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (577,TO_DATE('06/04/2024','DD-MM-YYYY'),45,57,577,3,81);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (578,TO_DATE('12/04/2024','DD-MM-YYYY'),205,51,578,4,82);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (579,TO_DATE('14/04/2024','DD-MM-YYYY'),280,59,579,1,83);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (580,TO_DATE('11/04/2024','DD-MM-YYYY'),35,65,580,1,84);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (581,TO_DATE('08/04/2024','DD-MM-YYYY'),71,7,581,4,85);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (582,TO_DATE('25/04/2024','DD-MM-YYYY'),83,26,582,4,86);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (583,TO_DATE('19/04/2024','DD-MM-YYYY'),28,50,583,1,87);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (584,TO_DATE('09/04/2024','DD-MM-YYYY'),109,68,584,5,88);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (585,TO_DATE('21/04/2024','DD-MM-YYYY'),11,69,585,4,89);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (586,TO_DATE('22/04/2024','DD-MM-YYYY'),135,49,586,1,90);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (587,TO_DATE('11/04/2024','DD-MM-YYYY'),269,44,587,4,91);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (588,TO_DATE('29/04/2024','DD-MM-YYYY'),176,10,588,2,92);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (589,TO_DATE('14/04/2024','DD-MM-YYYY'),148,19,589,5,93);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (590,TO_DATE('29/04/2024','DD-MM-YYYY'),212,15,590,4,94);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (591,TO_DATE('17/04/2024','DD-MM-YYYY'),29,22,591,4,95);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (592,TO_DATE('15/04/2024','DD-MM-YYYY'),24,55,592,3,96);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (593,TO_DATE('03/04/2024','DD-MM-YYYY'),67,9,593,5,97);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (594,TO_DATE('21/04/2024','DD-MM-YYYY'),21,60,594,3,98);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (595,TO_DATE('08/04/2024','DD-MM-YYYY'),263,15,595,5,99);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (596,TO_DATE('12/04/2024','DD-MM-YYYY'),145,7,596,2,100);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (597,TO_DATE('20/04/2024','DD-MM-YYYY'),81,29,597,1,101);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (598,TO_DATE('10/04/2024','DD-MM-YYYY'),185,22,598,1,102);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (599,TO_DATE('03/04/2024','DD-MM-YYYY'),250,47,599,5,103);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (600,TO_DATE('30/04/2024','DD-MM-YYYY'),279,18,600,1,104);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (601,TO_DATE('08/04/2024','DD-MM-YYYY'),184,14,601,5,105);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (602,TO_DATE('18/04/2024','DD-MM-YYYY'),114,67,602,2,106);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (603,TO_DATE('29/04/2024','DD-MM-YYYY'),118,60,603,4,107);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (604,TO_DATE('26/04/2024','DD-MM-YYYY'),125,16,604,3,108);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (605,TO_DATE('15/04/2024','DD-MM-YYYY'),99,28,605,2,109);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (606,TO_DATE('04/04/2024','DD-MM-YYYY'),59,8,606,5,110);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (607,TO_DATE('10/04/2024','DD-MM-YYYY'),167,24,607,2,111);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (608,TO_DATE('16/04/2024','DD-MM-YYYY'),265,7,608,1,112);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (609,TO_DATE('13/04/2024','DD-MM-YYYY'),193,8,609,3,113);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (610,TO_DATE('11/04/2024','DD-MM-YYYY'),149,37,610,4,114);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (611,TO_DATE('15/04/2024','DD-MM-YYYY'),193,12,611,3,115);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (612,TO_DATE('08/04/2024','DD-MM-YYYY'),98,4,612,3,116);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (613,TO_DATE('28/04/2024','DD-MM-YYYY'),98,1,613,1,117);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (614,TO_DATE('08/04/2024','DD-MM-YYYY'),136,34,614,3,118);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (615,TO_DATE('19/04/2024','DD-MM-YYYY'),35,15,615,5,121);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (616,TO_DATE('30/04/2024','DD-MM-YYYY'),186,27,616,3,122);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (617,TO_DATE('22/04/2024','DD-MM-YYYY'),205,32,617,1,123);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (618,TO_DATE('01/04/2024','DD-MM-YYYY'),69,15,618,3,124);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (619,TO_DATE('30/04/2024','DD-MM-YYYY'),41,4,619,2,125);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (620,TO_DATE('05/04/2024','DD-MM-YYYY'),61,14,620,2,126);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (621,TO_DATE('05/04/2024','DD-MM-YYYY'),25,37,621,2,127);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (622,TO_DATE('29/04/2024','DD-MM-YYYY'),215,52,622,3,128);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (623,TO_DATE('12/04/2024','DD-MM-YYYY'),94,52,623,2,129);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (624,TO_DATE('18/04/2024','DD-MM-YYYY'),221,53,624,3,130);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (625,TO_DATE('28/04/2024','DD-MM-YYYY'),84,7,625,1,131);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (626,TO_DATE('08/04/2024','DD-MM-YYYY'),182,3,626,3,132);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (627,TO_DATE('03/04/2024','DD-MM-YYYY'),14,36,627,5,133);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (628,TO_DATE('22/04/2024','DD-MM-YYYY'),86,67,628,1,134);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (629,TO_DATE('23/04/2024','DD-MM-YYYY'),192,8,629,5,135);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (630,TO_DATE('17/04/2024','DD-MM-YYYY'),64,41,630,5,136);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (631,TO_DATE('06/04/2024','DD-MM-YYYY'),168,7,631,3,137);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (632,TO_DATE('25/04/2024','DD-MM-YYYY'),74,43,632,5,138);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (633,TO_DATE('16/04/2024','DD-MM-YYYY'),171,12,633,4,139);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (634,TO_DATE('12/04/2024','DD-MM-YYYY'),56,57,634,3,140);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (635,TO_DATE('13/04/2024','DD-MM-YYYY'),258,19,635,4,141);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (636,TO_DATE('09/04/2024','DD-MM-YYYY'),93,18,636,2,142);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (637,TO_DATE('01/04/2024','DD-MM-YYYY'),61,33,637,3,143);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (638,TO_DATE('07/04/2024','DD-MM-YYYY'),71,52,638,5,144);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (639,TO_DATE('17/04/2024','DD-MM-YYYY'),185,67,639,1,145);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (640,TO_DATE('13/04/2024','DD-MM-YYYY'),17,68,640,1,146);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (641,TO_DATE('29/04/2024','DD-MM-YYYY'),241,30,641,2,147);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (642,TO_DATE('20/04/2024','DD-MM-YYYY'),69,13,642,5,148);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (643,TO_DATE('23/04/2024','DD-MM-YYYY'),207,35,643,5,149);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (644,TO_DATE('15/04/2024','DD-MM-YYYY'),38,9,644,3,150);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (645,TO_DATE('20/04/2024','DD-MM-YYYY'),195,48,645,1,151);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (646,TO_DATE('21/04/2024','DD-MM-YYYY'),198,5,646,3,152);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (647,TO_DATE('14/04/2024','DD-MM-YYYY'),11,57,647,3,153);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (648,TO_DATE('18/04/2024','DD-MM-YYYY'),191,5,648,4,154);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (649,TO_DATE('09/04/2024','DD-MM-YYYY'),20,36,649,3,155);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (650,TO_DATE('11/04/2024','DD-MM-YYYY'),206,67,650,2,156);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (651,TO_DATE('24/04/2024','DD-MM-YYYY'),36,43,651,5,157);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (652,TO_DATE('16/04/2024','DD-MM-YYYY'),93,6,652,4,158);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (653,TO_DATE('13/04/2024','DD-MM-YYYY'),149,32,653,3,159);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (654,TO_DATE('19/04/2024','DD-MM-YYYY'),122,55,654,1,160);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (655,TO_DATE('08/04/2024','DD-MM-YYYY'),21,53,655,5,121);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (656,TO_DATE('22/04/2024','DD-MM-YYYY'),267,16,656,3,122);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (657,TO_DATE('23/04/2024','DD-MM-YYYY'),149,9,657,3,123);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (658,TO_DATE('06/04/2024','DD-MM-YYYY'),61,19,658,5,124);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (659,TO_DATE('10/04/2024','DD-MM-YYYY'),73,14,659,4,125);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (660,TO_DATE('14/04/2024','DD-MM-YYYY'),72,19,660,5,126);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (661,TO_DATE('10/04/2024','DD-MM-YYYY'),125,13,661,1,127);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (662,TO_DATE('25/04/2024','DD-MM-YYYY'),71,16,662,5,128);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (663,TO_DATE('15/04/2024','DD-MM-YYYY'),54,48,663,2,129);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (664,TO_DATE('03/04/2024','DD-MM-YYYY'),18,44,664,2,130);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (665,TO_DATE('23/04/2024','DD-MM-YYYY'),192,33,665,3,131);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (666,TO_DATE('11/04/2024','DD-MM-YYYY'),227,65,666,2,132);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (667,TO_DATE('28/04/2024','DD-MM-YYYY'),40,41,667,4,133);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (668,TO_DATE('20/04/2024','DD-MM-YYYY'),159,5,668,2,134);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (669,TO_DATE('28/04/2024','DD-MM-YYYY'),229,57,669,1,135);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (670,TO_DATE('15/04/2024','DD-MM-YYYY'),186,56,670,4,136);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (671,TO_DATE('24/04/2024','DD-MM-YYYY'),96,48,671,1,137);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (672,TO_DATE('09/04/2024','DD-MM-YYYY'),187,5,672,3,138);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (673,TO_DATE('21/04/2024','DD-MM-YYYY'),258,13,673,3,139);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (674,TO_DATE('25/04/2024','DD-MM-YYYY'),28,64,674,5,140);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (675,TO_DATE('09/04/2024','DD-MM-YYYY'),193,12,675,1,141);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (676,TO_DATE('03/04/2024','DD-MM-YYYY'),203,15,676,5,142);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (677,TO_DATE('20/04/2024','DD-MM-YYYY'),243,10,677,5,143);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (678,TO_DATE('19/04/2024','DD-MM-YYYY'),259,58,678,5,144);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (679,TO_DATE('20/04/2024','DD-MM-YYYY'),41,16,679,2,145);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (680,TO_DATE('20/04/2024','DD-MM-YYYY'),199,33,680,5,146);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (681,TO_DATE('18/04/2024','DD-MM-YYYY'),20,12,681,2,147);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (682,TO_DATE('28/04/2024','DD-MM-YYYY'),243,32,682,4,148);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (683,TO_DATE('08/04/2024','DD-MM-YYYY'),242,3,683,5,149);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (684,TO_DATE('10/04/2024','DD-MM-YYYY'),83,16,684,5,150);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (685,TO_DATE('10/04/2024','DD-MM-YYYY'),210,39,685,2,151);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (686,TO_DATE('22/04/2024','DD-MM-YYYY'),211,4,686,5,152);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (687,TO_DATE('26/04/2024','DD-MM-YYYY'),213,67,687,1,153);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (688,TO_DATE('23/04/2024','DD-MM-YYYY'),241,50,688,3,154);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (689,TO_DATE('13/04/2024','DD-MM-YYYY'),219,64,689,1,155);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (690,TO_DATE('09/04/2024','DD-MM-YYYY'),185,6,690,4,156);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (691,TO_DATE('08/04/2024','DD-MM-YYYY'),115,25,691,5,157);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (692,TO_DATE('21/04/2024','DD-MM-YYYY'),84,24,692,1,158);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (693,TO_DATE('30/04/2024','DD-MM-YYYY'),99,9,693,2,159);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (694,TO_DATE('13/04/2024','DD-MM-YYYY'),165,55,694,3,160);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (695,TO_DATE('06/04/2024','DD-MM-YYYY'),12,58,695,3,121);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (696,TO_DATE('07/04/2024','DD-MM-YYYY'),129,58,696,5,122);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (697,TO_DATE('27/04/2024','DD-MM-YYYY'),206,45,697,2,123);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (698,TO_DATE('08/04/2024','DD-MM-YYYY'),92,68,698,4,124);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (699,TO_DATE('12/04/2024','DD-MM-YYYY'),158,24,699,4,125);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (700,TO_DATE('07/04/2024','DD-MM-YYYY'),251,38,700,3,126);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (701,TO_DATE('20/04/2024','DD-MM-YYYY'),251,59,701,2,127);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (702,TO_DATE('13/04/2024','DD-MM-YYYY'),38,39,702,5,128);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (703,TO_DATE('14/04/2024','DD-MM-YYYY'),149,70,703,5,129);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (704,TO_DATE('11/04/2024','DD-MM-YYYY'),110,32,704,4,130);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (705,TO_DATE('14/04/2024','DD-MM-YYYY'),109,6,705,3,131);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (706,TO_DATE('22/04/2024','DD-MM-YYYY'),152,4,706,5,132);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (707,TO_DATE('27/04/2024','DD-MM-YYYY'),181,12,707,4,133);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (708,TO_DATE('12/04/2024','DD-MM-YYYY'),94,16,708,4,134);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (709,TO_DATE('04/04/2024','DD-MM-YYYY'),174,22,709,4,135);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (710,TO_DATE('28/04/2024','DD-MM-YYYY'),153,40,710,1,136);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (711,TO_DATE('23/04/2024','DD-MM-YYYY'),109,9,711,4,137);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (712,TO_DATE('26/04/2024','DD-MM-YYYY'),25,61,712,4,138);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (713,TO_DATE('15/04/2024','DD-MM-YYYY'),108,44,713,2,139);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (714,TO_DATE('23/04/2024','DD-MM-YYYY'),41,44,714,3,140);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (715,TO_DATE('03/04/2024','DD-MM-YYYY'),124,9,715,1,141);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (716,TO_DATE('10/04/2024','DD-MM-YYYY'),50,44,716,1,142);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (717,TO_DATE('15/04/2024','DD-MM-YYYY'),271,68,717,4,143);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (718,TO_DATE('02/04/2024','DD-MM-YYYY'),26,51,718,2,144);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (719,TO_DATE('02/04/2024','DD-MM-YYYY'),189,14,719,1,145);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (720,TO_DATE('04/04/2024','DD-MM-YYYY'),136,68,720,4,146);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (721,TO_DATE('01/04/2024','DD-MM-YYYY'),33,54,721,2,147);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (722,TO_DATE('19/04/2024','DD-MM-YYYY'),23,46,722,4,148);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (723,TO_DATE('12/04/2024','DD-MM-YYYY'),152,23,723,3,149);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (724,TO_DATE('20/04/2024','DD-MM-YYYY'),82,4,724,2,150);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (725,TO_DATE('12/04/2024','DD-MM-YYYY'),51,25,725,4,151);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (726,TO_DATE('09/04/2024','DD-MM-YYYY'),99,69,726,4,152);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (727,TO_DATE('30/04/2024','DD-MM-YYYY'),239,68,727,1,153);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (728,TO_DATE('23/04/2024','DD-MM-YYYY'),180,31,728,5,154);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (729,TO_DATE('23/04/2024','DD-MM-YYYY'),59,4,729,2,155);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (730,TO_DATE('04/04/2024','DD-MM-YYYY'),83,57,730,4,156);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (731,TO_DATE('16/04/2024','DD-MM-YYYY'),257,64,731,4,157);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (732,TO_DATE('30/04/2024','DD-MM-YYYY'),96,19,732,5,158);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (733,TO_DATE('27/04/2024','DD-MM-YYYY'),95,19,733,4,159);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (734,TO_DATE('21/04/2024','DD-MM-YYYY'),49,17,734,4,160);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (735,TO_DATE('23/04/2024','DD-MM-YYYY'),116,33,735,3,121);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (736,TO_DATE('07/04/2024','DD-MM-YYYY'),70,47,736,5,122);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (737,TO_DATE('08/04/2024','DD-MM-YYYY'),242,57,737,3,123);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (738,TO_DATE('06/04/2024','DD-MM-YYYY'),144,57,738,4,124);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (739,TO_DATE('04/04/2024','DD-MM-YYYY'),148,70,739,1,125);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (740,TO_DATE('16/04/2024','DD-MM-YYYY'),246,45,740,3,126);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (741,TO_DATE('07/04/2024','DD-MM-YYYY'),132,11,741,1,127);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (742,TO_DATE('09/04/2024','DD-MM-YYYY'),147,11,742,2,128);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (743,TO_DATE('17/04/2024','DD-MM-YYYY'),253,40,743,2,129);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (744,TO_DATE('13/04/2024','DD-MM-YYYY'),272,17,744,2,130);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (745,TO_DATE('01/04/2024','DD-MM-YYYY'),228,50,745,1,131);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (746,TO_DATE('30/04/2024','DD-MM-YYYY'),37,51,746,4,132);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (747,TO_DATE('23/04/2024','DD-MM-YYYY'),129,45,747,1,133);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (748,TO_DATE('05/04/2024','DD-MM-YYYY'),120,42,748,4,134);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (749,TO_DATE('19/04/2024','DD-MM-YYYY'),185,10,749,2,135);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (750,TO_DATE('17/04/2024','DD-MM-YYYY'),44,7,750,1,136);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (751,TO_DATE('23/04/2024','DD-MM-YYYY'),124,37,751,2,137);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (752,TO_DATE('19/04/2024','DD-MM-YYYY'),173,12,752,3,138);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (753,TO_DATE('04/04/2024','DD-MM-YYYY'),269,8,753,4,139);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (754,TO_DATE('28/04/2024','DD-MM-YYYY'),89,32,754,5,140);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (755,TO_DATE('29/04/2024','DD-MM-YYYY'),214,60,755,5,141);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (756,TO_DATE('26/04/2024','DD-MM-YYYY'),235,44,756,2,142);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (757,TO_DATE('28/04/2024','DD-MM-YYYY'),214,52,757,5,143);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (758,TO_DATE('17/04/2024','DD-MM-YYYY'),173,30,758,4,144);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (759,TO_DATE('09/04/2024','DD-MM-YYYY'),137,48,759,1,145);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (760,TO_DATE('28/04/2024','DD-MM-YYYY'),114,42,760,3,146);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (761,TO_DATE('20/04/2024','DD-MM-YYYY'),112,20,761,5,147);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (762,TO_DATE('19/04/2024','DD-MM-YYYY'),160,53,762,1,148);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (763,TO_DATE('24/04/2024','DD-MM-YYYY'),73,35,763,1,149);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (764,TO_DATE('03/04/2024','DD-MM-YYYY'),51,33,764,4,150);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (765,TO_DATE('27/04/2024','DD-MM-YYYY'),240,19,765,4,151);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (766,TO_DATE('08/04/2024','DD-MM-YYYY'),138,56,766,1,152);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (767,TO_DATE('03/04/2024','DD-MM-YYYY'),114,18,767,4,153);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (768,TO_DATE('18/04/2024','DD-MM-YYYY'),260,26,768,1,154);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (769,TO_DATE('30/04/2024','DD-MM-YYYY'),119,20,769,2,155);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (770,TO_DATE('19/04/2024','DD-MM-YYYY'),122,29,770,2,156);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (771,TO_DATE('11/04/2024','DD-MM-YYYY'),208,63,771,3,157);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (772,TO_DATE('27/04/2024','DD-MM-YYYY'),59,70,772,3,158);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (773,TO_DATE('09/04/2024','DD-MM-YYYY'),238,47,773,3,159);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (774,TO_DATE('15/04/2024','DD-MM-YYYY'),205,47,774,4,160);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (775,TO_DATE('14/04/2024','DD-MM-YYYY'),98,14,775,2,121);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (776,TO_DATE('20/04/2024','DD-MM-YYYY'),24,26,776,5,122);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (777,TO_DATE('05/04/2024','DD-MM-YYYY'),267,56,777,2,123);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (778,TO_DATE('30/04/2024','DD-MM-YYYY'),134,27,778,3,124);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (779,TO_DATE('30/04/2024','DD-MM-YYYY'),180,28,779,3,125);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (780,TO_DATE('22/04/2024','DD-MM-YYYY'),234,57,780,2,126);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (781,TO_DATE('20/04/2024','DD-MM-YYYY'),92,34,781,5,127);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (782,TO_DATE('09/04/2024','DD-MM-YYYY'),207,70,782,2,128);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (783,TO_DATE('02/04/2024','DD-MM-YYYY'),253,16,783,4,129);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (784,TO_DATE('17/04/2024','DD-MM-YYYY'),16,69,784,3,130);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (785,TO_DATE('05/04/2024','DD-MM-YYYY'),123,15,785,3,131);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (786,TO_DATE('26/04/2024','DD-MM-YYYY'),112,66,786,2,132);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (787,TO_DATE('29/04/2024','DD-MM-YYYY'),90,65,787,4,133);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (788,TO_DATE('28/04/2024','DD-MM-YYYY'),261,4,788,2,134);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (789,TO_DATE('04/04/2024','DD-MM-YYYY'),108,20,789,4,135);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (790,TO_DATE('10/04/2024','DD-MM-YYYY'),112,24,790,2,136);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (791,TO_DATE('20/04/2024','DD-MM-YYYY'),171,31,791,4,137);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (792,TO_DATE('22/04/2024','DD-MM-YYYY'),61,30,792,2,138);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (793,TO_DATE('02/04/2024','DD-MM-YYYY'),172,1,793,4,139);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (794,TO_DATE('27/04/2024','DD-MM-YYYY'),77,30,794,2,140);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (795,TO_DATE('06/04/2024','DD-MM-YYYY'),73,68,795,2,141);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (796,TO_DATE('19/04/2024','DD-MM-YYYY'),127,17,796,2,142);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (797,TO_DATE('26/04/2024','DD-MM-YYYY'),20,54,797,3,143);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (798,TO_DATE('11/04/2024','DD-MM-YYYY'),24,20,798,4,144);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (799,TO_DATE('29/04/2024','DD-MM-YYYY'),60,26,799,2,145);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (800,TO_DATE('14/04/2024','DD-MM-YYYY'),144,9,800,2,146);
COMMIT;

INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (801,TO_DATE('26/04/2024','DD-MM-YYYY'),217,10,801,5,147);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (802,TO_DATE('21/04/2024','DD-MM-YYYY'),252,67,802,1,148);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (803,TO_DATE('21/04/2024','DD-MM-YYYY'),89,39,803,3,149);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (804,TO_DATE('25/04/2024','DD-MM-YYYY'),77,12,804,5,150);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (805,TO_DATE('16/04/2024','DD-MM-YYYY'),200,8,805,3,151);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (806,TO_DATE('27/04/2024','DD-MM-YYYY'),82,31,806,2,152);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (807,TO_DATE('28/04/2024','DD-MM-YYYY'),19,27,807,2,153);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (808,TO_DATE('19/04/2024','DD-MM-YYYY'),169,60,808,2,154);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (809,TO_DATE('09/04/2024','DD-MM-YYYY'),189,24,809,1,155);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (810,TO_DATE('06/04/2024','DD-MM-YYYY'),127,67,810,4,156);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (811,TO_DATE('23/04/2024','DD-MM-YYYY'),102,39,811,3,157);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (812,TO_DATE('17/04/2024','DD-MM-YYYY'),73,17,812,2,158);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (813,TO_DATE('01/04/2024','DD-MM-YYYY'),260,10,813,3,159);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (814,TO_DATE('05/04/2024','DD-MM-YYYY'),104,67,814,4,160);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (815,TO_DATE('27/04/2024','DD-MM-YYYY'),21,30,815,5,121);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (816,TO_DATE('08/04/2024','DD-MM-YYYY'),213,27,816,1,122);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (817,TO_DATE('11/04/2024','DD-MM-YYYY'),236,51,817,5,123);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (818,TO_DATE('21/04/2024','DD-MM-YYYY'),67,42,818,3,124);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (819,TO_DATE('17/04/2024','DD-MM-YYYY'),160,16,819,5,125);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (820,TO_DATE('04/04/2024','DD-MM-YYYY'),61,43,820,2,126);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (821,TO_DATE('05/04/2024','DD-MM-YYYY'),132,17,821,1,127);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (822,TO_DATE('12/04/2024','DD-MM-YYYY'),126,61,822,5,128);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (823,TO_DATE('22/04/2024','DD-MM-YYYY'),192,8,823,5,129);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (824,TO_DATE('15/04/2024','DD-MM-YYYY'),171,32,824,5,130);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (825,TO_DATE('21/04/2024','DD-MM-YYYY'),46,37,825,2,131);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (826,TO_DATE('02/04/2024','DD-MM-YYYY'),58,26,826,2,132);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (827,TO_DATE('30/04/2024','DD-MM-YYYY'),203,56,827,4,133);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (828,TO_DATE('04/04/2024','DD-MM-YYYY'),35,32,828,5,134);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (829,TO_DATE('02/04/2024','DD-MM-YYYY'),122,36,829,3,135);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (830,TO_DATE('03/04/2024','DD-MM-YYYY'),97,46,830,2,136);
INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) VALUES (831,TO_DATE('12/04/2024','DD-MM-YYYY'),168,16,831,4,137);
COMMIT;


--CARGA DE DADOS COM PROCEDURE

--TABELA SEQUENCIA LOGS DE ERROS

CREATE TABLE gs_error_log (
    log_id         INTEGER PRIMARY KEY,
    procedure_name VARCHAR2(100 BYTE),
    user_name      VARCHAR2(30 BYTE),
    error_date     DATE,
    error_code     INTEGER,
    error_message  VARCHAR2(4000 BYTE)
);

CREATE SEQUENCE gs_error_log_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


--TABELA GS_PAIS

CREATE OR REPLACE PROCEDURE sp_insert_gs_pais (
    p_cod_pais  IN INTEGER,
    p_nome_pais IN VARCHAR2
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_pais (cod_pais, nome_pais) 
    VALUES (p_cod_pais, p_nome_pais);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_pais', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_ESTADO

CREATE OR REPLACE PROCEDURE sp_insert_gs_estado (
    p_cod_estado IN INTEGER,
    p_nome_estado IN VARCHAR2,
    p_cod_pais IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_estado (cod_estado, nome_estado, cod_pais) 
    VALUES (p_cod_estado, p_nome_estado, p_cod_pais);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_estado', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_REGIAO

CREATE OR REPLACE PROCEDURE sp_insert_gs_regiao (
    p_cod_regiao IN INTEGER,
    p_nome_regiao IN VARCHAR2
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_regiao (cod_regiao, nome_regiao) 
    VALUES (p_cod_regiao, p_nome_regiao);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_regiao', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_CIDADE

CREATE OR REPLACE PROCEDURE sp_insert_gs_cidade (
    p_cod_cidade IN INTEGER,
    p_nome_cidade IN VARCHAR2,
    p_cod_estado IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_cidade (cod_cidade, nome_cidade, cod_estado) 
    VALUES (p_cod_cidade, p_nome_cidade, p_cod_estado);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_cidade', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_BAIRRO

CREATE OR REPLACE PROCEDURE sp_insert_gs_bairro (
    p_cod_bairro IN INTEGER,
    p_nome_bairro IN VARCHAR2,
    p_cod_cidade IN INTEGER,
    p_cod_regiao IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_bairro (cod_bairro, nome_bairro, cod_cidade, cod_regiao) 
    VALUES (p_cod_bairro, p_nome_bairro, p_cod_cidade, p_cod_regiao);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_bairro', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/


--TABELA GS_ENDERECO

CREATE OR REPLACE PROCEDURE sp_insert_gs_endereco (
    p_cod_endereco IN INTEGER,
    p_logradouro IN VARCHAR2,
    p_nr_logradouro IN INTEGER,
    p_complemento IN VARCHAR2,
    p_referencia IN VARCHAR2,
    p_nr_cep IN VARCHAR2,
    p_cod_bairro IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_endereco (cod_endereco, logradouro, nr_logradouro, complemento, referencia, nr_cep, cod_bairro) 
    VALUES (p_cod_endereco, p_logradouro, p_nr_logradouro, p_complemento, p_referencia, p_nr_cep, p_cod_bairro);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_endereco', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_USUARIO

CREATE OR REPLACE PROCEDURE sp_insert_gs_usuario (
    p_cod_usuario IN INTEGER,
    p_nome_usuario IN VARCHAR2,
    p_cod_endereco IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_usuario (cod_usuario, nome_usuario, cod_endereco) 
    VALUES (p_cod_usuario, p_nome_usuario, p_cod_endereco);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_usuario', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/


--TABELA GS_COOPERATIVA

CREATE OR REPLACE PROCEDURE sp_insert_gs_cooperativa (
    p_cod_cooperativa IN INTEGER,
    p_nome_cooperativa IN VARCHAR2,
    p_cod_endereco IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_cooperativa (cod_cooperativa, nome_cooperativa, cod_endereco) 
    VALUES (p_cod_cooperativa, p_nome_cooperativa, p_cod_endereco);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_cooperativa', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_COOPERADOS

CREATE OR REPLACE PROCEDURE sp_insert_gs_cooperados (
    p_cod_cooperado IN INTEGER,
    p_nome_cooperado IN VARCHAR2,
    p_cod_endereco IN INTEGER,
    p_cod_cooperativa IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_cooperados (cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa) 
    VALUES (p_cod_cooperado, p_nome_cooperado, p_cod_endereco, p_cod_cooperativa);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_cooperados', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_STATUS

CREATE OR REPLACE PROCEDURE sp_insert_gs_status (
    p_cod_status IN INTEGER,
    p_tipo_status IN VARCHAR2
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_status (cod_status, tipo_status) 
    VALUES (p_cod_status, p_tipo_status);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_status', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_PEDIDO

CREATE OR REPLACE PROCEDURE sp_insert_gs_pedido (
    p_cod_pedido IN INTEGER,
    p_data_pedido IN DATE,
    p_qtde_itens IN INTEGER,
    p_cod_material IN INTEGER,
    p_cod_usuario IN INTEGER,
    p_cod_status IN INTEGER,
    p_cod_cooperado IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_pedido (cod_pedido, data_pedido, qtde_itens, cod_material, cod_usuario, cod_status, cod_cooperado) 
    VALUES (p_cod_pedido, p_data_pedido, p_qtde_itens, p_cod_material, p_cod_usuario, p_cod_status, p_cod_cooperado);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_pedido', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/

--TABELA GS_MATERIAIS

CREATE OR REPLACE PROCEDURE sp_insert_gs_materiais (
    p_cod_material IN INTEGER,
    p_nome_material IN VARCHAR2,
    p_tipo_material IN VARCHAR2,
    p_cod_pedido IN INTEGER
)
IS
    v_user_name VARCHAR2(30);
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    INSERT INTO gs_materiais (cod_material, nome_material, tipo_material, cod_pedido) 
    VALUES (p_cod_material, p_nome_material, p_tipo_material, p_cod_pedido);
EXCEPTION
    WHEN OTHERS THEN
        v_user_name := SYS_CONTEXT('USERENV', 'CURRENT_USER');
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO gs_error_log (log_id, procedure_name, user_name, error_date, error_code, error_message)
        VALUES (gs_error_log_seq.NEXTVAL, 'sp_insert_gs_materiais', v_user_name, SYSDATE, v_error_code, v_error_message);
        RAISE;
END;
/


--CRIANDO 4 BLOCOS ANONIMOS

--PRIMEIRO BLOCO AN�NIMO

DECLARE
    CURSOR cur_usuarios IS
        SELECT cod_usuario, nome_usuario, cod_endereco
        FROM gs_usuario;
        
    rec_usuarios cur_usuarios%ROWTYPE;
BEGIN
    OPEN cur_usuarios;
    LOOP
        FETCH cur_usuarios INTO rec_usuarios;
        EXIT WHEN cur_usuarios%NOTFOUND;
        
        -- Tomada de decis�o: verificar se o c�digo do endere�o � v�lido
        IF rec_usuarios.cod_endereco IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Cod_Usuario: ' || rec_usuarios.cod_usuario || ', Nome_Usuario: ' || rec_usuarios.nome_usuario || ', Cod_Endereco: ' || rec_usuarios.cod_endereco);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cod_Usuario: ' || rec_usuarios.cod_usuario || ', Nome_Usuario: ' || rec_usuarios.nome_usuario || ' (Endere�o n�o dispon�vel)');
        END IF;
    END LOOP;
    CLOSE cur_usuarios;
END;
/


--SEGUNDO BLOCO ANONIMO

DECLARE
    CURSOR cur_cooperativas IS
        SELECT cod_cooperativa, nome_cooperativa, cod_endereco
        FROM gs_cooperativa;
        
    rec_cooperativas cur_cooperativas%ROWTYPE;
BEGIN
    OPEN cur_cooperativas;
    LOOP
        FETCH cur_cooperativas INTO rec_cooperativas;
        EXIT WHEN cur_cooperativas%NOTFOUND;
        
        -- Tomada de decis�o: verificar se o c�digo do endere�o � v�lido
        IF rec_cooperativas.cod_endereco IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Cod_Cooperativa: ' || rec_cooperativas.cod_cooperativa || ', Nome_Cooperativa: ' || rec_cooperativas.nome_cooperativa || ', Cod_Endereco: ' || rec_cooperativas.cod_endereco);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cod_Cooperativa: ' || rec_cooperativas.cod_cooperativa || ', Nome_Cooperativa: ' || rec_cooperativas.nome_cooperativa || ' (Endere�o n�o dispon�vel)');
        END IF;
    END LOOP;
    CLOSE cur_cooperativas;
END;
/

--TERCEIRO BLOCO AN�NIMO

DECLARE
    CURSOR cur_cooperados IS
        SELECT cod_cooperado, nome_cooperado, cod_endereco, cod_cooperativa
        FROM gs_cooperados;
        
    rec_cooperados cur_cooperados%ROWTYPE;
BEGIN
    OPEN cur_cooperados;
    LOOP
        FETCH cur_cooperados INTO rec_cooperados;
        EXIT WHEN cur_cooperados%NOTFOUND;
        
        -- Tomada de decis�o: verificar se o c�digo do endere�o � v�lido
        IF rec_cooperados.cod_endereco IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Cod_Cooperado: ' || rec_cooperados.cod_cooperado || ', Nome_Cooperado: ' || rec_cooperados.nome_cooperado || ', Cod_Endereco: ' || rec_cooperados.cod_endereco || ', Cod_Cooperativa: ' || rec_cooperados.cod_cooperativa);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cod_Cooperado: ' || rec_cooperados.cod_cooperado || ', Nome_Cooperado: ' || rec_cooperados.nome_cooperado || ' (Endere�o n�o dispon�vel), Cod_Cooperativa: ' || rec_cooperados.cod_cooperativa);
        END IF;
    END LOOP;
    CLOSE cur_cooperados;
END;
/

--QUARTO BLOCO ANONIMO (COM RELATORIO)

SET SERVEROUTPUT ON;

DECLARE
    CURSOR cur_pedidos IS
        SELECT p.cod_pedido, p.data_pedido, p.qtde_itens, p.cod_material, p.cod_usuario, p.cod_status, p.cod_cooperado, m.tipo_material, s.tipo_status
        FROM gs_pedido p
        JOIN gs_materiais m ON p.cod_material = m.cod_material
        JOIN gs_status s ON p.cod_status = s.cod_status;
        
    rec_pedidos cur_pedidos%ROWTYPE;
    v_total_geral NUMBER := 0;
    v_sub_total NUMBER := 0;
    v_last_tipo_material VARCHAR2(30) := NULL;
    v_last_tipo_status VARCHAR2(30) := NULL;
    
    PROCEDURE print_sub_total IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Sub-Total   ' || v_sub_total);
        v_total_geral := v_total_geral + v_sub_total;
        v_sub_total := 0;
    END;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Campo1     Campo2     Valor');

    OPEN cur_pedidos;
    LOOP
        FETCH cur_pedidos INTO rec_pedidos;
        EXIT WHEN cur_pedidos%NOTFOUND;
        
        -- Agrupamento por tipo_material e tipo_status
        IF v_last_tipo_material IS NULL THEN
            v_last_tipo_material := rec_pedidos.tipo_material;
            v_last_tipo_status := rec_pedidos.tipo_status;
        ELSIF v_last_tipo_material != rec_pedidos.tipo_material OR v_last_tipo_status != rec_pedidos.tipo_status THEN
            print_sub_total;
            v_last_tipo_material := rec_pedidos.tipo_material;
            v_last_tipo_status := rec_pedidos.tipo_status;
        END IF;

        DBMS_OUTPUT.PUT_LINE(rec_pedidos.tipo_material || '           ' || rec_pedidos.tipo_status || '           ' || rec_pedidos.qtde_itens);
        v_sub_total := v_sub_total + rec_pedidos.qtde_itens;
    END LOOP;
    
    -- Output last subtotal
    print_sub_total;
    
    DBMS_OUTPUT.PUT_LINE('Total Geral ' || v_total_geral);
    CLOSE cur_pedidos;
END;
/

